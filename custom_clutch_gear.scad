// https://github.com/dpellegr/PolyGear
use <PolyGear.scad>
use <common.scad>
use <clutch.scad>
use <cross_hole.scad>
// use <gear.scad>

num_teeth = 20;

gear_length         = studs(1) * (3/4);
clutch_teeth_length = studs(1) * (1/4);
total_length = gear_length + clutch_teeth_length;
driving_ring_bushing_length = studs(3);

driving_ring_length = studs(1);
driving_ring_clearance = 0.5;
driving_ring_wall_thickness = 1;

cross_hole_inner_d = 5.15;

driving_ring_bushing_offset = 1.0;
driving_ring_bushing_outer_d = cross_hole_inner_d + driving_ring_bushing_offset * 2;
axle_hole_clearance = 0.15;
axle_hole_inner_d = driving_ring_bushing_outer_d + (2 * axle_hole_clearance);
axle_hole_inner_r = axle_hole_inner_d / 2;

driving_ring_circle_clearance = axle_hole_clearance;
driving_ring_circle_offset = 1.0;
driving_ring_circle_r = 1.3;

axle_hole_wall_thickness = 1.0;
axle_hole_outer_r = axle_hole_inner_r + axle_hole_wall_thickness;

clutch_teeth = 4;
clutch_extrusion = 0.7;
clutch_teeth_width = 0.8;
clutch_extrusion_outer_r = axle_hole_outer_r + clutch_extrusion;

driving_ring_bushing_outer_r = cross_hole_inner_d / 2 + driving_ring_bushing_offset;

// separation = -studs(1) * (1/5);
separation = studs(1/4);

/* [Hidden] */
$fn = 35;

render()
{
    assembly();
}

module assembly()
{
    translate([0, 0, total_length / 2 + separation / 2])
    driving_ring();

    color("firebrick")
    driving_ring_bushing();

    color("dodgerblue")
    translate([0, 0, -(total_length / 2) - separation / 2])
    custom_clutch_gear(num_teeth = num_teeth);
}

module driving_ring_bushing()
{
    difference()
    {
        union()
        {
            cylinder(h = studs(1), r = driving_ring_bushing_outer_r, center = true);
            linear_extrude(height = driving_ring_bushing_length, center = true) 
            difference()
            {
                circle(r = cross_hole_inner_d / 2 + driving_ring_bushing_offset);
                cross_2d_rounded(cross_hole_inner_d);
            }
        }

        linear_extrude(height = driving_ring_bushing_length, center = true)
            driving_ring_circles(+driving_ring_circle_clearance);
    }
}

module driving_ring_circles(clearance)
{
    repeatInCircle(n = 4, di = 1/2)
        translate([driving_ring_bushing_outer_r + driving_ring_circle_offset, 0, 0])
        circle(r = driving_ring_circle_r + (clearance / 2));
}

module driving_ring()
{
    // driving_ring_outer_r = driving_ring_inner_r + driving_ring_wall_thickness;
    driving_ring_outer_r = 7.0;
    driving_ring_inner_r = clutch_extrusion_outer_r + driving_ring_clearance / 2;

    shift_fork_indent_h = studs(1/4);
    shift_fork_indent_depth = 1.0;

    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    outer_tube();
                    center_structure();
                    clutch_teeth();
                }
                axle_hole();
            }

            driving_ring_inner_teeth();
        }
        shift_fork_indent();
    }

    module outer_tube()
    {
        difference()
        {
            cylinder(h = total_length, r = driving_ring_outer_r, center = true);
            cylinder(h = total_length, r = driving_ring_inner_r, center = true);
        }
    }

    module center_structure()
    {
        cylinder(h = total_length / 2, r = driving_ring_outer_r, center = true);
    }

    module clutch_teeth()
    {
        translate([0, 0, -gear_length / 2]) clutch_teeth_impl();
        translate([0, 0, +gear_length / 2]) clutch_teeth_impl();

        module clutch_teeth_impl()
        {
            repeatInCircle(n = clutch_teeth, di = 1/2)
                translate([driving_ring_inner_r - (clutch_extrusion / 2), 0, 0])
                cube([clutch_extrusion, clutch_teeth_width, clutch_teeth_length], center=true);
        }
    }

    module driving_ring_inner_teeth()
    {
        linear_extrude(h = total_length / 2, center = true)
        driving_ring_circles(-driving_ring_circle_clearance);
    }

    module axle_hole()
    {
        cylinder(h = total_length, r = axle_hole_inner_r, center = true);
    }

    module shift_fork_indent()
    {
        difference()
        {
            cylinder(h = shift_fork_indent_h, r = driving_ring_outer_r + 0.1, center = true);
            cylinder(h = shift_fork_indent_h, r = axle_hole_inner_r + axle_hole_wall_thickness, center = true);
        }
    }
}

module custom_clutch_gear(num_teeth)
{
    difference()
    {
        union()
        {
            translate([0, 0, -clutch_teeth_length / 2]) spur_gear(n = num_teeth, w = gear_length, helix_angle = 0);
            cylinder(h = total_length, r = axle_hole_outer_r, center = true);
            repeatInCircle(n = clutch_teeth, di = 0)
                translate([clutch_extrusion_outer_r / 2, 0, gear_length + (clutch_teeth_length / 2) - (total_length / 2)])
                cube(size = [clutch_extrusion_outer_r, clutch_teeth_width, clutch_teeth_length], center=true);
        }
        cylinder(h = total_length, r = axle_hole_inner_r, center = true);
    }
}

module repeatInCircle(n,di){
    for(i=[0:n-1])
        rotate([0,0,(i+di)*360/n]) children();
}
