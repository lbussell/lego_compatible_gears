// https://github.com/dpellegr/PolyGear
use <PolyGear.scad>
use <common.scad>
use <clutch.scad>
use <cross_hole.scad>
// use <gear.scad>

num_teeth = 16;

gear_length         = studs(1) * (3/4);
clutch_teeth_length = studs(1) * (1/4);
total_length = gear_length + clutch_teeth_length;

axle_hole_inner_d = 5.1;
axle_hole_inner_r = axle_hole_inner_d / 2;

axle_hole_wall_thickness = 1.2;
axle_hole_outer_r = axle_hole_inner_r + axle_hole_wall_thickness;

clutch_teeth = 4;
clutch_extrusion = 0.7;
clutch_extrusion_outer_r = axle_hole_outer_r + clutch_extrusion;

/* [Hidden] */
$fn = 25;

render()
{
    assembly();
}

module assembly()
{
    custom_clutch_gear();
}

module driving_ring()
{
}

module custom_clutch_gear()
{
    difference()
    {
        union()
        {
            translate([0, 0, -clutch_teeth_length / 2]) spur_gear(n = num_teeth, w = gear_length, helix_angle = 0);
            cylinder(h = total_length, r = axle_hole_outer_r, center = true);
            repeatInCircle(n = clutch_teeth, di = 0)
                translate([clutch_extrusion_outer_r / 2, 0, gear_length + (clutch_teeth_length / 2) - (total_length / 2)])
                cube(size = [clutch_extrusion_outer_r, 1, clutch_teeth_length], center=true);
        }
        cylinder(h = total_length, r = axle_hole_inner_r, center = true);
    }
}

module repeatInCircle(n,di){
    for(i=[0:n-1])
        rotate([0,0,(i+di)*360/n]) children();
}
