param(
    [Parameter(Mandatory = $true)]
    [string]$RepoPath,

    [Parameter(Mandatory = $true)]
    [string]$ProposalCsvPath,

    [Parameter(Mandatory = $true)]
    [string]$PreviewPath,

    [switch]$Execute
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

function ConvertTo-HtmlAttributeValue {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    $Result = $Value
    $Result = [regex]::Replace($Result, '&', '&amp;')
    $Result = [regex]::Replace($Result, '"', '&quot;')
    $Result = [regex]::Replace($Result, '<', '&lt;')
    $Result = [regex]::Replace($Result, '>', '&gt;')
    return $Result
}

function ConvertTo-HtmlTextValue {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    $Result = $Value
    $Result = [regex]::Replace($Result, '&', '&amp;')
    $Result = [regex]::Replace($Result, '<', '&lt;')
    $Result = [regex]::Replace($Result, '>', '&gt;')
    return $Result
}

function Get-CanonicalHref {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Scheme,

        [Parameter(Mandatory = $true)]
        [string]$HostName,

        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    return ($Scheme + '://' + $HostName + $Path)
}

function Update-HeadMetadata {
    param(
        [Parameter(Mandatory = $true)]
        [string]$HtmlText,

        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [string]$CanonicalHref
    )

    $EscapedTitle = ConvertTo-HtmlTextValue -Value $Title
    $EscapedDescription = ConvertTo-HtmlAttributeValue -Value $Description
    $EscapedCanonicalHref = ConvertTo-HtmlAttributeValue -Value $CanonicalHref

    $Updated = $HtmlText

    $Updated = [regex]::Replace(
        $Updated,
        '<title\b[^>]*>.*?</title>',
        ('<title>' + $EscapedTitle + '</title>'),
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline
    )

    $Updated = [regex]::Replace(
        $Updated,
        '<meta\b(?=[^>]*\bname=["'']description["''])[^>]*>',
        ('<meta name="description" content="' + $EscapedDescription + '">'),
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    $HasCanonical = [regex]::IsMatch(
        $Updated,
        '<link\b(?=[^>]*\brel=["'']canonical["''])[^>]*>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    if ($HasCanonical) {
        $Updated = [regex]::Replace(
            $Updated,
            '<link\b(?=[^>]*\brel=["'']canonical["''])[^>]*>',
            ('<link rel="canonical" href="' + $EscapedCanonicalHref + '">'),
            [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        )
    } else {
        $DescriptionPattern = '<meta\b(?=[^>]*\bname=["'']description["''])[^>]*>'
        $DescriptionMatch = [regex]::Match($Updated, $DescriptionPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

        if (-not $DescriptionMatch.Success) {
            throw 'Could not locate meta description for canonical insertion.'
        }

        $InsertText = $DescriptionMatch.Value + "`r`n" + '  <link rel="canonical" href="' + $EscapedCanonicalHref + '">'
        $Updated = $Updated.Substring(0, $DescriptionMatch.Index) + $InsertText + $Updated.Substring($DescriptionMatch.Index + $DescriptionMatch.Length)
    }

    return $Updated
}

if (-not (Test-Path $RepoPath)) {
    throw ('RepoPath not found: ' + $RepoPath)
}

if (-not (Test-Path $ProposalCsvPath)) {
    throw ('Proposal CSV not found: ' + $ProposalCsvPath)
}

$Rows = Import-Csv $ProposalCsvPath

$RowsToApply = $Rows | Where-Object {
    $_.PageFamily -eq 'homepage-market-wide' -or
    $_.PageFamily -eq 'service-category' -or
    $_.PageFamily -eq 'service-area'
}

$ExcludedRows = $Rows | Where-Object {
    $_.PageFamily -eq 'ads-zip-landing'
}

$PreviewLines = New-Object System.Collections.Generic.List[string]
$PreviewLines.Add('# Crain Bros Inc Metadata + Canonical Preview')
$PreviewLines.Add('')
$PreviewLines.Add('Generated: 2026-06-12')
$PreviewLines.Add('')
$PreviewLines.Add('## Scope')
$PreviewLines.Add('')
$PreviewLines.Add('- This preview includes homepage, service-category pages, and service-area pages only.')
$PreviewLines.Add('- Ads / ZIP landing pages are excluded because their canonical strategy is still marked decision-required.')
$PreviewLines.Add('- This preview does not change sitemap.xml, robots.txt, staticwebapp.config.json, redirects, or page URLs.')
$PreviewLines.Add('')
$PreviewLines.Add('## Counts')
$PreviewLines.Add('')
$PreviewLines.Add(('- Candidate rows included: ' + @($RowsToApply).Count))
$PreviewLines.Add(('- Ads rows excluded: ' + @($ExcludedRows).Count))
$PreviewLines.Add(('- Execute mode: ' + [string]$Execute.IsPresent))
$PreviewLines.Add('')
$PreviewLines.Add('## Page changes')
$PreviewLines.Add('')

$ChangedCount = 0
$UnchangedCount = 0

foreach ($Row in $RowsToApply) {
    $RelativeFile = $Row.File
    $FilePath = Join-Path $RepoPath $RelativeFile

    if (-not (Test-Path $FilePath)) {
        throw ('Missing HTML file: ' + $RelativeFile)
    }

    $OriginalText = [System.IO.File]::ReadAllText($FilePath)
    $CanonicalHref = Get-CanonicalHref -Scheme $Row.ProposedCanonicalScheme -HostName $Row.ProposedCanonicalHost -Path $Row.ProposedCanonicalPath

    $UpdatedText = Update-HeadMetadata `
        -HtmlText $OriginalText `
        -Title $Row.ProposedTitle `
        -Description $Row.ProposedDescription `
        -CanonicalHref $CanonicalHref

    $Changed = ($UpdatedText -ne $OriginalText)

    if ($Changed) {
        $ChangedCount++
    } else {
        $UnchangedCount++
    }

    $PreviewLines.Add(('### ' + $RelativeFile))
    $PreviewLines.Add('')
    $PreviewLines.Add(('- Page family: ' + $Row.PageFamily))
    $PreviewLines.Add(('- Changed if executed: ' + [string]$Changed))
    $PreviewLines.Add(('- Current title: ' + $Row.CurrentTitle))
    $PreviewLines.Add(('- Proposed title: ' + $Row.ProposedTitle))
    $PreviewLines.Add(('- Current description: ' + $Row.CurrentDescription))
    $PreviewLines.Add(('- Proposed description: ' + $Row.ProposedDescription))
    $PreviewLines.Add(('- Proposed canonical components: scheme=' + $Row.ProposedCanonicalScheme + '; host=' + $Row.ProposedCanonicalHost + '; path=' + $Row.ProposedCanonicalPath))
    $PreviewLines.Add('')

    if ($Execute.IsPresent -and $Changed) {
        $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($FilePath, $UpdatedText, $Utf8NoBom)
    }
}

$PreviewLines.Insert(15, ('- Changed pages if executed: ' + $ChangedCount))
$PreviewLines.Insert(16, ('- Unchanged pages if executed: ' + $UnchangedCount))

$PreviewDir = Split-Path -Parent $PreviewPath
if (-not (Test-Path $PreviewDir)) {
    New-Item -Path $PreviewDir -ItemType Directory | Out-Null
}

$Utf8NoBomForPreview = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($PreviewPath, $PreviewLines, $Utf8NoBomForPreview)

Write-Host ('Preview path: ' + $PreviewPath)
Write-Host ('Candidate rows included: ' + @($RowsToApply).Count)
Write-Host ('Ads rows excluded: ' + @($ExcludedRows).Count)
Write-Host ('Changed pages if executed: ' + $ChangedCount)
Write-Host ('Unchanged pages if executed: ' + $UnchangedCount)
Write-Host ('Execute mode: ' + [string]$Execute.IsPresent)