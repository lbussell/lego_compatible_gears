// https://github.com/dpellegr/PolyGear
use <PolyGear.scad>
use <common.scad>
use <clutch.scad>
use <cross_hole.scad>

$fn = 25;

num_teeth = 32;
is_clutch = false;
taper = true;
helix_angle = 0.0;
wall_thickness = 1.0;
cross_hole_fillet_r = 0.20;
length = studs(1);

gear();

module gear()
{
    padding = 2.5;
    gear_inner_diameter = gear_inner_diameter(num_teeth, padding, wall_thickness);
    center_diameter = center_outer_diameter(wall_thickness, is_clutch);

    // sizes for taper //
    // overall radius of the whole gear
    r_outer = (num_teeth + padding) / 2;
    // just to the edge of the wall
    r_inner = gear_inner_diameter / 2 + wall_thickness;

    intersection()
    {
        if (taper)
        {
            tapered_cylinder(
                r_outer = r_outer,
                r_inner = r_inner,
                total_h = length,
                h_inner = length / 2);
        }

        union()
        {
            hollow_gear(num_teeth, length, gear_inner_diameter);
            supports(
                num_teeth = num_teeth,
                length = length,
                wall_thickness = wall_thickness,
                gear_inner_diameter = gear_inner_diameter,
                // provide some padding so that supports aren't just
                // tangent to the outside of the center of the gear.
                center_outer_diameter = center_diameter - (wall_thickness / 2));
            center(is_clutch);
        }
    }

    module center(is_clutch)
    {
        if (is_clutch)
        {
            clutch();
        }
        else
        {
            cross_hole(
                length = length,
                wall_thickness = wall_thickness);
        }
    }
}

module hollow_gear(num_teeth, length, inner_space_diameter)
{
    fn = 10;

    difference()
    {
        spur_gear(
            n = num_teeth,
            w = length,
            helix_angle = 0,
            $fn = fn);
        cylinder(
            h = length,
            r = inner_space_diameter / 2,
            center = true);
    }
}

module supports(num_teeth, length, wall_thickness, gear_inner_diameter, center_outer_diameter)
{
    support_length = (gear_inner_diameter - center_outer_diameter) / 2;
    support_start = center_outer_diameter / 2 + support_length / 2;

    translate([0,  support_start, 0]) cube([wall_thickness, support_length, length], center = true);
    translate([0, -support_start, 0]) cube([wall_thickness, support_length, length], center = true);
    translate([ support_start, 0, 0]) cube([support_length, wall_thickness, length], center = true);
    translate([-support_start, 0, 0]) cube([support_length, wall_thickness, length], center = true);
}

function gear_inner_diameter(num_teeth, padding, wall_thickness) =
    num_teeth - padding - (2 * wall_thickness);

function center_outer_diameter(wall_thickness, is_clutch) =
    is_clutch
        ? clutch_outer_diameter()
        : cross_hole_outer_diameter(wall_thickness);
