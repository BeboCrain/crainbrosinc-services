param(
    [Parameter(Mandatory = $true)]
    [string]$RepoPath,

    [Parameter(Mandatory = $true)]
    [string]$SocialProposalCsvPath,

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

function Get-UrlFromComponents {
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

function Remove-ExistingSocialMetadata {
    param(
        [Parameter(Mandatory = $true)]
        [string]$HtmlText
    )

    $Updated = $HtmlText

    $Patterns = @(
        '<meta\b(?=[^>]*\bproperty=["'']og:)[^>]*>\r?\n?',
        '<meta\b(?=[^>]*\bname=["'']twitter:)[^>]*>\r?\n?'
    )

    foreach ($Pattern in $Patterns) {
        $Updated = [regex]::Replace(
            $Updated,
            $Pattern,
            '',
            [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        )
    }

    return $Updated
}

function Add-SocialMetadata {
    param(
        [Parameter(Mandatory = $true)]
        [string]$HtmlText,

        [Parameter(Mandatory = $true)]
        [string]$OpenGraphTitle,

        [Parameter(Mandatory = $true)]
        [string]$OpenGraphDescription,

        [Parameter(Mandatory = $true)]
        [string]$OpenGraphType,

        [Parameter(Mandatory = $true)]
        [string]$OpenGraphUrl,

        [Parameter(Mandatory = $true)]
        [string]$TwitterCard,

        [Parameter(Mandatory = $true)]
        [string]$TwitterTitle,

        [Parameter(Mandatory = $true)]
        [string]$TwitterDescription
    )

    $Updated = Remove-ExistingSocialMetadata -HtmlText $HtmlText

    $CanonicalMatch = [regex]::Match(
        $Updated,
        '<link\b(?=[^>]*\brel=["'']canonical["''])[^>]*>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    if (-not $CanonicalMatch.Success) {
        throw 'Could not locate canonical tag for social metadata insertion.'
    }

    $EscapedOpenGraphTitle = ConvertTo-HtmlAttributeValue -Value $OpenGraphTitle
    $EscapedOpenGraphDescription = ConvertTo-HtmlAttributeValue -Value $OpenGraphDescription
    $EscapedOpenGraphType = ConvertTo-HtmlAttributeValue -Value $OpenGraphType
    $EscapedOpenGraphUrl = ConvertTo-HtmlAttributeValue -Value $OpenGraphUrl
    $EscapedTwitterCard = ConvertTo-HtmlAttributeValue -Value $TwitterCard
    $EscapedTwitterTitle = ConvertTo-HtmlAttributeValue -Value $TwitterTitle
    $EscapedTwitterDescription = ConvertTo-HtmlAttributeValue -Value $TwitterDescription

    $SocialLines = @(
        ('  <meta property="og:title" content="' + $EscapedOpenGraphTitle + '">'),
        ('  <meta property="og:description" content="' + $EscapedOpenGraphDescription + '">'),
        ('  <meta property="og:type" content="' + $EscapedOpenGraphType + '">'),
        ('  <meta property="og:url" content="' + $EscapedOpenGraphUrl + '">'),
        ('  <meta name="twitter:card" content="' + $EscapedTwitterCard + '">'),
        ('  <meta name="twitter:title" content="' + $EscapedTwitterTitle + '">'),
        ('  <meta name="twitter:description" content="' + $EscapedTwitterDescription + '">')
    )

    $InsertText = $CanonicalMatch.Value + "`r`n" + ($SocialLines -join "`r`n")
    $Updated = $Updated.Substring(0, $CanonicalMatch.Index) + $InsertText + $Updated.Substring($CanonicalMatch.Index + $CanonicalMatch.Length)

    return $Updated
}

if (-not (Test-Path $RepoPath)) {
    throw ('RepoPath not found: ' + $RepoPath)
}

if (-not (Test-Path $SocialProposalCsvPath)) {
    throw ('Social proposal CSV not found: ' + $SocialProposalCsvPath)
}

$Rows = Import-Csv $SocialProposalCsvPath

$RowsToApply = $Rows | Where-Object {
    $_.IncludeInFirstSocialMetadataEdit -eq 'Yes'
}

$PreviewLines = New-Object System.Collections.Generic.List[string]
$PreviewLines.Add('# Crain Bros Inc Social Metadata Apply Preview')
$PreviewLines.Add('')
$PreviewLines.Add('Generated: 2026-06-12')
$PreviewLines.Add('')
$PreviewLines.Add('## Scope')
$PreviewLines.Add('')
$PreviewLines.Add('- Homepage, service-category pages, and service-area pages only.')
$PreviewLines.Add('- Ads pages remain excluded.')
$PreviewLines.Add('- This script does not add og:image or twitter:image because image strategy is deferred.')
$PreviewLines.Add('- This script does not change sitemap.xml, robots.txt, staticwebapp.config.json, redirects, or page URLs.')
$PreviewLines.Add('')
$PreviewLines.Add('## Counts')
$PreviewLines.Add('')
$PreviewLines.Add(('- Candidate rows included: ' + @($RowsToApply).Count))
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

    $OpenGraphUrl = Get-UrlFromComponents `
        -Scheme $Row.ProposedOpenGraphUrlScheme `
        -HostName $Row.ProposedOpenGraphUrlHost `
        -Path $Row.ProposedOpenGraphUrlPath

    $UpdatedText = Add-SocialMetadata `
        -HtmlText $OriginalText `
        -OpenGraphTitle $Row.ProposedOpenGraphTitle `
        -OpenGraphDescription $Row.ProposedOpenGraphDescription `
        -OpenGraphType $Row.ProposedOpenGraphType `
        -OpenGraphUrl $OpenGraphUrl `
        -TwitterCard $Row.ProposedTwitterCard `
        -TwitterTitle $Row.ProposedTwitterTitle `
        -TwitterDescription $Row.ProposedTwitterDescription

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
    $PreviewLines.Add(('- og:title: ' + $Row.ProposedOpenGraphTitle))
    $PreviewLines.Add(('- og:description: ' + $Row.ProposedOpenGraphDescription))
    $PreviewLines.Add(('- og:type: ' + $Row.ProposedOpenGraphType))
    $PreviewLines.Add(('- og:url components: scheme=' + $Row.ProposedOpenGraphUrlScheme + '; host=' + $Row.ProposedOpenGraphUrlHost + '; path=' + $Row.ProposedOpenGraphUrlPath))
    $PreviewLines.Add(('- twitter:card: ' + $Row.ProposedTwitterCard))
    $PreviewLines.Add(('- twitter:title: ' + $Row.ProposedTwitterTitle))
    $PreviewLines.Add(('- twitter:description: ' + $Row.ProposedTwitterDescription))
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

$PreviewText = ($PreviewLines -join "`r`n")
$PreviewText = $PreviewText.TrimEnd("`r", "`n") + "`r`n"

$Utf8NoBomForPreview = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($PreviewPath, $PreviewText, $Utf8NoBomForPreview)

Write-Host ('Preview path: ' + $PreviewPath)
Write-Host ('Candidate rows included: ' + @($RowsToApply).Count)
Write-Host ('Changed pages if executed: ' + $ChangedCount)
Write-Host ('Unchanged pages if executed: ' + $UnchangedCount)
Write-Host ('Execute mode: ' + [string]$Execute.IsPresent)