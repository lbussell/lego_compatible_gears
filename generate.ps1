#!/usr/bin/env pwsh

param(
    [string]$OpenSCADPath = "C:\Program Files\OpenSCAD (Nightly)\openscad.com",
    [string]$OutputDir = "stl"
)

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir
}

$scadDir = "scad"
# $output = "$OutputDir/gearbox"

# & $OpenSCADPath -o $output/driving_ring.stl -D '"part=""driving_ring"""' $scadDir/custom_clutch_gear.scad
# & $OpenSCADPath -o $output/3L_bushing.stl -D '"part=""bushing"""' $scadDir/custom_clutch_gear.scad
# & $OpenSCADPath -o $output/shift_fork.stl -D '"part=""fork"""' $scadDir/custom_clutch_gear.scad
# & $OpenSCADPath -o $output/shift_fork_offset.stl -D '"part=""fork_offset"""' $scadDir/custom_clutch_gear.scad

function Generate-Gears {
    param (
        [int[]]$Sizes,
        [string]$GearRatio = "1/2",
        [bool]$Chamfer = $false,
        [bool]$Center = $true,
        [bool]$IsClutch = $false,
        [string]$SubDir = "gears"
    )

    # Ensure output directory and subdirectory exist
    if (-not (Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir
    }
    $gearDir = Join-Path $OutputDir $SubDir
    if (-not (Test-Path $gearDir)) {
        New-Item -ItemType Directory -Path $gearDir
    }

    foreach ($size in $Sizes) {
        # Build a suffix based on the Chamfer and IsClutch parameters
        $suffix = ""
        if ($Chamfer) { $suffix += "_chamfer" }
        if ($IsClutch) { $suffix += "_clutch" }
        
        # Descriptive filename using gear size and options inside the chosen subdirectory
        $outputPath = "$gearDir/gear_${size}${suffix}.stl"

        # Build parameters as a hashtable
        $params = @{
            num_teeth = $size
            is_clutch = $IsClutch.ToString().ToLower()
            gear_ratio = $GearRatio
            chamfer   = $Chamfer.ToString().ToLower()
            center    = $Center.ToString().ToLower()
        }
        # Create argument string by joining hashtable entries
        $paramString = ($params.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ";"

        & $OpenSCADPath `
            -o $outputPath `
            -D $paramString `
            "$scadDir/gear/gear.scad"
    }
}

Generate-Gears -SubDir "gears" -Sizes @(12, 14, 16, 18, 20, 22, 24) -GearRatio "1/2" -Chamfer $false -Center $true -IsClutch $false
Generate-Gears -SubDir "gears" -Sizes @(12, 14, 16, 18, 20, 22, 24) -GearRatio "1" -Chamfer $true -Center $true -IsClutch $false

Generate-Gears -SubDir "gearbox/gears" -Sizes @(12, 14, 16, 18, 20, 22, 24) -GearRatio "3/4" -Chamfer $false -Center $false -IsClutch $false
Generate-Gears -SubDir "gearbox/gears" -Sizes @(14, 16, 18, 20, 22, 24) -GearRatio "3/4" -Chamfer $false -Center $false -IsClutch $true
