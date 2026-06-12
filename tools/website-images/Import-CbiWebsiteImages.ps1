param(
    [Parameter(Mandatory=$false)]
    [string]$RepoPath = 'P:\projectRESTCON_OS\businesses\crainbrosinc\git\crainbrosinc-services',

    [Parameter(Mandatory=$false)]
    [switch]$Execute
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

$ImagesRoot = Join-Path $RepoPath 'images'
$IncomingRoot = Join-Path $ImagesRoot '_incoming'
$PageAssetsRoot = Join-Path $ImagesRoot 'page-assets'
$ManifestPath = Join-Path $ImagesRoot 'cbi-website-image-manifest.csv'
$AllowedExtensions = @('.jpg', '.jpeg', '.png', '.webp')
$PreviewSequenceMap = @{}
$PlannedTargets = New-Object System.Collections.Generic.HashSet[string]

function Get-NextSequence {
    param(
        [Parameter(Mandatory=$true)][string]$DestinationFolder,
        [Parameter(Mandatory=$true)][string]$BaseName,
        [Parameter(Mandatory=$true)][string]$Extension
    )

    $Key = ($DestinationFolder + '|' + $BaseName + '|' + $Extension).ToLowerInvariant()

    if ($PreviewSequenceMap.ContainsKey($Key)) {
        $PreviewSequenceMap[$Key] = [int]$PreviewSequenceMap[$Key] + 1
        return [int]$PreviewSequenceMap[$Key]
    }

    $MaxExisting = 0

    if (Test-Path $DestinationFolder) {
        $Pattern = '^' + [regex]::Escape($BaseName) + '-(?<n>[0-9]{2})' + [regex]::Escape($Extension) + '$'

        $ExistingNumbers = Get-ChildItem -Path $DestinationFolder -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match $Pattern } |
            ForEach-Object { [int]$Matches['n'] }

        if ($ExistingNumbers) {
            $MaxExisting = ($ExistingNumbers | Measure-Object -Maximum).Maximum
        }
    }

    $Next = [int]$MaxExisting + 1
    $PreviewSequenceMap[$Key] = $Next
    return $Next
}

function Add-ManifestRow {
    param(
        [Parameter(Mandatory=$true)][string]$Scope,
        [Parameter(Mandatory=$true)][string]$TargetPageFamily,
        [Parameter(Mandatory=$true)][string]$ServiceSlug,
        [Parameter(Mandatory=$true)][string]$AreaSlug,
        [Parameter(Mandatory=$true)][string]$Role,
        [Parameter(Mandatory=$true)][string]$RelativePath,
        [Parameter(Mandatory=$true)][string]$OriginalFileName
    )

    $Row = [pscustomobject]@{
        ImportedAtLocal = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        Scope = $Scope
        TargetPageFamily = $TargetPageFamily
        ServiceSlug = $ServiceSlug
        AreaSlug = $AreaSlug
        Role = $Role
        RelativePath = $RelativePath
        OriginalFileName = $OriginalFileName
    }

    if (Test-Path $ManifestPath) {
        $Row | Export-Csv -Path $ManifestPath -NoTypeInformation -Append -Encoding UTF8
    } else {
        $Row | Export-Csv -Path $ManifestPath -NoTypeInformation -Encoding UTF8
    }
}

function Import-OneFolder {
    param(
        [Parameter(Mandatory=$true)][string]$Scope,
        [Parameter(Mandatory=$true)][string]$TargetPageFamily,
        [Parameter(Mandatory=$true)][string]$SourceFolder,
        [Parameter(Mandatory=$true)][string]$DestinationFolder,
        [Parameter(Mandatory=$true)][string]$ServiceSlug,
        [Parameter(Mandatory=$true)][string]$AreaSlug,
        [Parameter(Mandatory=$true)][string]$Role,
        [Parameter(Mandatory=$true)][string]$BaseName
    )

    if (!(Test-Path $SourceFolder)) {
        return
    }

    if (!(Test-Path $DestinationFolder)) {
        New-Item -ItemType Directory -Path $DestinationFolder | Out-Null
    }

    $Files = Get-ChildItem -Path $SourceFolder -File -ErrorAction SilentlyContinue |
        Where-Object { $AllowedExtensions -contains $_.Extension.ToLowerInvariant() } |
        Sort-Object Name

    foreach ($File in $Files) {
        $Ext = $File.Extension.ToLowerInvariant()

        if ($Ext -eq '.jpeg') {
            $Ext = '.jpg'
        }

        $Seq = Get-NextSequence -DestinationFolder $DestinationFolder -BaseName $BaseName -Extension $Ext
        $FinalName = "$BaseName-{0:D2}$Ext" -f $Seq
        $DestinationPath = Join-Path $DestinationFolder $FinalName
        $RelativePath = $DestinationPath.Substring($RepoPath.Length).TrimStart('\') -replace '\\','/'

        if (-not $PlannedTargets.Add($DestinationPath.ToLowerInvariant())) {
            throw "Duplicate target detected before import: $DestinationPath"
        }

        if ($Execute) {
            Move-Item -Path $File.FullName -Destination $DestinationPath -Force

            Add-ManifestRow `
                -Scope $Scope `
                -TargetPageFamily $TargetPageFamily `
                -ServiceSlug $ServiceSlug `
                -AreaSlug $AreaSlug `
                -Role $Role `
                -RelativePath $RelativePath `
                -OriginalFileName $File.Name

            Write-Host "IMPORTED: $RelativePath"
        } else {
            Write-Host "PREVIEW: $($File.FullName) -> $RelativePath"
        }
    }
}

function Import-HomePageMarketWide {
    $DropRoot = Join-Path $IncomingRoot 'home-page\service-cards'
    $FinalRoot = Join-Path $PageAssetsRoot 'home-page\service-cards'

    if (!(Test-Path $DropRoot)) {
        return
    }

    Get-ChildItem -Path $DropRoot -Directory | ForEach-Object {
        $ServiceSlug = $_.Name

        Get-ChildItem -Path $_.FullName -Directory | ForEach-Object {
            $Role = $_.Name
            $SourceFolder = $_.FullName
            $DestinationFolder = Join-Path $FinalRoot $ServiceSlug
            $BaseName = "$ServiceSlug-northeast-arkansas-crain-bros-inc-$Role"

            Import-OneFolder `
                -Scope 'home-page' `
                -TargetPageFamily 'index.html' `
                -SourceFolder $SourceFolder `
                -DestinationFolder $DestinationFolder `
                -ServiceSlug $ServiceSlug `
                -AreaSlug 'market-wide' `
                -Role $Role `
                -BaseName $BaseName
        }
    }
}

function Import-ServiceCategoryPages {
    $DropRoot = Join-Path $IncomingRoot 'service-category-pages'
    $FinalRoot = Join-Path $PageAssetsRoot 'service-category-pages'

    if (!(Test-Path $DropRoot)) {
        return
    }

    Get-ChildItem -Path $DropRoot -Directory | ForEach-Object {
        $ServiceSlug = $_.Name

        Get-ChildItem -Path $_.FullName -Directory | ForEach-Object {
            $AreaSlug = $_.Name

            Get-ChildItem -Path $_.FullName -Directory | ForEach-Object {
                $Role = $_.Name
                $SourceFolder = $_.FullName
                $DestinationFolder = Join-Path (Join-Path (Join-Path $FinalRoot $ServiceSlug) $AreaSlug) ''
                $BaseName = "$ServiceSlug-$AreaSlug-crain-bros-inc-$Role"

                Import-OneFolder `
                    -Scope 'service-category-pages' `
                    -TargetPageFamily 'pages' `
                    -SourceFolder $SourceFolder `
                    -DestinationFolder $DestinationFolder `
                    -ServiceSlug $ServiceSlug `
                    -AreaSlug $AreaSlug `
                    -Role $Role `
                    -BaseName $BaseName
            }
        }
    }
}

function Import-AdsPages {
    $DropRoot = Join-Path $IncomingRoot 'ads-pages'
    $FinalRoot = Join-Path $PageAssetsRoot 'ads-pages'

    if (!(Test-Path $DropRoot)) {
        return
    }

    Get-ChildItem -Path $DropRoot -Directory | ForEach-Object {
        $AreaSlug = $_.Name

        Get-ChildItem -Path $_.FullName -Directory | ForEach-Object {
            $ServiceSlug = $_.Name

            Get-ChildItem -Path $_.FullName -Directory | ForEach-Object {
                $Role = $_.Name
                $SourceFolder = $_.FullName
                $DestinationFolder = Join-Path (Join-Path (Join-Path $FinalRoot $AreaSlug) $ServiceSlug) ''
                $BaseName = "$ServiceSlug-$AreaSlug-crain-bros-inc-$Role"

                Import-OneFolder `
                    -Scope 'ads-pages' `
                    -TargetPageFamily 'ads' `
                    -SourceFolder $SourceFolder `
                    -DestinationFolder $DestinationFolder `
                    -ServiceSlug $ServiceSlug `
                    -AreaSlug $AreaSlug `
                    -Role $Role `
                    -BaseName $BaseName
            }
        }
    }
}

Write-Host '=== CBI WEBSITE IMAGE IMPORT ==='
Write-Host "RepoPath: $RepoPath"
Write-Host "Execute: $Execute"

Import-HomePageMarketWide
Import-ServiceCategoryPages
Import-AdsPages

Write-Host '=== DONE ==='

if ($Execute) {
    Write-Host "Manifest: $ManifestPath"
} else {
    Write-Host 'Preview only. Re-run with -Execute to move and rename files.'
}