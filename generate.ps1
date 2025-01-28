#!/usr/bin/env pwsh

param(
    [string]$OpenSCADPath = "C:\Program Files\OpenSCAD\openscad.com",
    [string]$OutputDir = "stl",
    [int[]]$Sizes = @(10, 12, 14, 16, 18, 20, 22)
)

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir
}

foreach ($size in $Sizes) {
    $inputFile = "lego_compatible_gear.scad"
    $outputFile = "$OutputDir/gear_$size.stl"
    $cmd = "$OpenSCADPath -o $outputFile -D teeth=$size $inputFile"
    Write-Host "Running: $cmd"
    & $OpenSCADPath -o $outputFile -D teeth=$size $inputFile
}
