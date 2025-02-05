#!/usr/bin/env pwsh

param(
    [string]$OpenSCADPath = "C:\Program Files\OpenSCAD (Nightly)\openscad.com",
    [string]$OutputDir = "stl",
    [int[]]$Sizes = @(10, 12, 14, 16, 18, 20, 22, 24)
)

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir
}

$output = "$OutputDir/gearbox"

& $OpenSCADPath -o $output/driving_ring.stl -D '"part=""driving_ring"""' custom_clutch_gear.scad
& $OpenSCADPath -o $output/3L_bushing.stl -D '"part=""bushing"""' custom_clutch_gear.scad
& $OpenSCADPath -o $output/shift_fork.stl -D '"part=""fork"""' custom_clutch_gear.scad
& $OpenSCADPath -o $output/shift_fork_offset.stl -D '"part=""fork_offset"""' custom_clutch_gear.scad

& $OpenSCADPath -o $output/gears/gear_10.stl -D '"part=""gear"""' -D 'num_teeth=10' -D 'is_clutch=false' custom_clutch_gear.scad
& $OpenSCADPath -o $output/gears/gear_12.stl -D '"part=""gear"""' -D 'num_teeth=12' -D 'is_clutch=false' custom_clutch_gear.scad
& $OpenSCADPath -o $output/gears/gear_14.stl -D '"part=""gear"""' -D 'num_teeth=14' -D 'is_clutch=false' custom_clutch_gear.scad
& $OpenSCADPath -o $output/gears/gear_16.stl -D '"part=""gear"""' -D 'num_teeth=16' -D 'is_clutch=false' custom_clutch_gear.scad

& $OpenSCADPath -o $output/gears/clutch_gear_16.stl -D '"part=""gear"""' -D 'num_teeth=16' -D 'is_clutch=true' custom_clutch_gear.scad
& $OpenSCADPath -o $output/gears/clutch_gear_18.stl -D '"part=""gear"""' -D 'num_teeth=18' -D 'is_clutch=true' custom_clutch_gear.scad
& $OpenSCADPath -o $output/gears/clutch_gear_20.stl -D '"part=""gear"""' -D 'num_teeth=20' -D 'is_clutch=true' custom_clutch_gear.scad
& $OpenSCADPath -o $output/gears/clutch_gear_22.stl -D '"part=""gear"""' -D 'num_teeth=22' -D 'is_clutch=true' custom_clutch_gear.scad
