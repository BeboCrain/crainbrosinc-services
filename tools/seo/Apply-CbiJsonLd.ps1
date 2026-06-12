param(
    [Parameter(Mandatory = $true)]
    [string]$RepoPath,

    [Parameter(Mandatory = $true)]
    [string]$JsonLdProposalCsvPath,

    [Parameter(Mandatory = $true)]
    [string]$PreviewPath,

    [switch]$Execute
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

function ConvertFrom-HtmlText {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    $Result = $Value
    $Result = $Result -replace '&amp;', '&'
    $Result = $Result -replace '&quot;', '"'
    $Result = $Result -replace '&#39;', "'"
    $Result = $Result -replace '&lt;', '<'
    $Result = $Result -replace '&gt;', '>'
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

function Get-ServiceNameFromTitle {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title
    )

    $DecodedTitle = ConvertFrom-HtmlText -Value $Title
    $Parts = $DecodedTitle -split '\s+\|\s+'
    return $Parts[0].Trim()
}

function New-JsonLdBlock {
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$Objects
    )

    $GraphObject = [ordered]@{
        '@context' = ('https' + '://schema.org')
        '@graph' = $Objects
    }

    $Json = $GraphObject | ConvertTo-Json -Depth 20
    return "<script type=`"application/ld+json`">`r`n$Json`r`n</script>"
}

function Remove-ExistingJsonLd {
    param(
        [Parameter(Mandatory = $true)]
        [string]$HtmlText
    )

    return [regex]::Replace(
        $HtmlText,
        '<script\b(?=[^>]*\btype=["'']application/ld\+json["''])[^>]*>.*?</script>\r?\n?',
        '',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline
    )
}

function Add-JsonLdBeforeHeadClose {
    param(
        [Parameter(Mandatory = $true)]
        [string]$HtmlText,

        [Parameter(Mandatory = $true)]
        [string]$JsonLdBlock
    )

    $CleanHtml = Remove-ExistingJsonLd -HtmlText $HtmlText

    $HeadCloseMatch = [regex]::Match(
        $CleanHtml,
        '</head>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    if (-not $HeadCloseMatch.Success) {
        throw 'Could not locate closing head tag for JSON-LD insertion.'
    }

    $InsertText = $JsonLdBlock + "`r`n"
    return $CleanHtml.Substring(0, $HeadCloseMatch.Index) + $InsertText + $CleanHtml.Substring($HeadCloseMatch.Index)
}

function New-JsonLdObjectsForRow {
    param(
        [Parameter(Mandatory = $true)]
        [object]$Row
    )

    $Url = Get-UrlFromComponents -Scheme $Row.CanonicalScheme -HostName $Row.CanonicalHost -Path $Row.CanonicalPath
    $DecodedTitle = ConvertFrom-HtmlText -Value $Row.Title
    $DecodedDescription = ConvertFrom-HtmlText -Value $Row.Description
    $DecodedH1 = ConvertFrom-HtmlText -Value $Row.H1

    $Objects = New-Object System.Collections.Generic.List[object]

    if ($Row.PageFamily -eq 'homepage-market-wide') {
        $Organization = [ordered]@{
            '@type' = 'Organization'
            '@id' = $Url + '#organization'
            'name' = 'Crain Bros Inc'
            'url' = $Url
        }

        $WebSite = [ordered]@{
            '@type' = 'WebSite'
            '@id' = $Url + '#website'
            'name' = 'Crain Bros Inc'
            'url' = $Url
            'publisher' = [ordered]@{
                '@id' = $Url + '#organization'
            }
        }

        $WebPage = [ordered]@{
            '@type' = 'WebPage'
            '@id' = $Url + '#webpage'
            'url' = $Url
            'name' = $DecodedTitle
            'description' = $DecodedDescription
            'isPartOf' = [ordered]@{
                '@id' = $Url + '#website'
            }
            'about' = [ordered]@{
                '@id' = $Url + '#organization'
            }
        }

        $Objects.Add($Organization)
        $Objects.Add($WebSite)
        $Objects.Add($WebPage)
    } elseif ($Row.PageFamily -eq 'service-category') {
        $ServiceName = Get-ServiceNameFromTitle -Title $Row.Title

        $WebPage = [ordered]@{
            '@type' = 'WebPage'
            '@id' = $Url + '#webpage'
            'url' = $Url
            'name' = $DecodedTitle
            'description' = $DecodedDescription
        }

        $Service = [ordered]@{
            '@type' = 'Service'
            '@id' = $Url + '#service'
            'name' = $ServiceName
            'description' = $DecodedDescription
            'provider' = [ordered]@{
                '@type' = 'Organization'
                'name' = 'Crain Bros Inc'
            }
            'areaServed' = [ordered]@{
                '@type' = 'AdministrativeArea'
                'name' = 'Northeast Arkansas'
            }
            'mainEntityOfPage' = [ordered]@{
                '@id' = $Url + '#webpage'
            }
        }

        $Objects.Add($WebPage)
        $Objects.Add($Service)
    } elseif ($Row.PageFamily -eq 'service-area') {
        $WebPage = [ordered]@{
            '@type' = 'WebPage'
            '@id' = $Url + '#webpage'
            'url' = $Url
            'name' = $DecodedTitle
            'description' = $DecodedDescription
            'headline' = $DecodedH1
            'about' = [ordered]@{
                '@type' = 'Organization'
                'name' = 'Crain Bros Inc'
            }
        }

        $Objects.Add($WebPage)
    } else {
        throw ('Unsupported page family for JSON-LD apply: ' + $Row.PageFamily)
    }

    return $Objects.ToArray()
}

if (-not (Test-Path $RepoPath)) {
    throw ('RepoPath not found: ' + $RepoPath)
}

if (-not (Test-Path $JsonLdProposalCsvPath)) {
    throw ('JSON-LD proposal CSV not found: ' + $JsonLdProposalCsvPath)
}

$Rows = Import-Csv $JsonLdProposalCsvPath

$RowsToApply = $Rows | Where-Object {
    $_.JsonLdEligibleForFirstStructuredDataPhase -eq 'Yes'
}

$PreviewLines = New-Object System.Collections.Generic.List[string]
$PreviewLines.Add('# Crain Bros Inc JSON-LD Apply Preview')
$PreviewLines.Add('')
$PreviewLines.Add('Generated: 2026-06-12')
$PreviewLines.Add('')
$PreviewLines.Add('## Scope')
$PreviewLines.Add('')
$PreviewLines.Add('- Homepage, service-category pages, and service-area pages only.')
$PreviewLines.Add('- Ads pages remain excluded.')
$PreviewLines.Add('- FAQPage, AggregateRating, Review, Offer, price, and separate location claims are not generated.')
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
    $JsonLdObjects = New-JsonLdObjectsForRow -Row $Row
    $JsonLdBlock = New-JsonLdBlock -Objects $JsonLdObjects

    $UpdatedText = Add-JsonLdBeforeHeadClose -HtmlText $OriginalText -JsonLdBlock $JsonLdBlock
    $Changed = ($UpdatedText -ne $OriginalText)

    if ($Changed) {
        $ChangedCount++
    } else {
        $UnchangedCount++
    }

    $SchemaTypes = ($JsonLdObjects | ForEach-Object { $_.'@type' }) -join ', '

    $PreviewLines.Add(('### ' + $RelativeFile))
    $PreviewLines.Add('')
    $PreviewLines.Add(('- Page family: ' + $Row.PageFamily))
    $PreviewLines.Add(('- Changed if executed: ' + [string]$Changed))
    $PreviewLines.Add(('- JSON-LD types: ' + $SchemaTypes))
    $PreviewLines.Add(('- URL components: scheme=' + $Row.CanonicalScheme + '; host=' + $Row.CanonicalHost + '; path=' + $Row.CanonicalPath))
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
