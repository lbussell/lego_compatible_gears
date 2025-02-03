// https://github.com/dpellegr/PolyGear
use <PolyGear.scad>
use <common.scad>
use <clutch.scad>
use <cross_hole.scad>

num_teeth = 16;

gear_length         = studs(1) * (3/4);
clutch_teeth_length = studs(1) * (1/4);
total_length = gear_length + clutch_teeth_length;
driving_ring_bushing_length = studs(3);

driving_ring_length = studs(1);
driving_ring_clearance = 0.2;
driving_ring_wall_thickness = 1;

cross_hole_inner_d = 5.05;
cross_hole_inner_r = cross_hole_inner_d / 2;

bushing_wall_thickness = 1.0;
axle_hole_wall_thickness = 1.0;

clutch_teeth = 4;
clutch_extrusion = 0.7;
clutch_teeth_width = 0.8;

driving_ring_outer_r = 7.0;
driving_ring_inner_r = driving_ring_outer_r - driving_ring_wall_thickness;

driving_ring_bushing_outer_r = cross_hole_inner_d / 2 + bushing_wall_thickness;

shift_fork_indent_h = studs(1/4);
shift_fork_indent_depth = 1.5;

separation = studs(1/4);

/* [Hidden] */
$fn = 35;

render()
{
    assembly();
}

module assembly()
{
    // translate([0, 0, 4])
    // driving_ring();

    // color("firebrick") driving_ring_bushing();

    // translate([0, 0, -8])
    color("dodgerblue") custom_clutch_gear(num_teeth = num_teeth);
}

module driving_ring_bushing()
{
    difference()
    {
        union()
        {
            translate([0, 0, height_per_part]) axle_bushing();
            interface();
            translate([0, 0, -height_per_part]) axle_bushing();
        }
    }

    h = 8;
    height_per_part = ((h * 3) - (0.1 * 2)) / 3;

    module axle_bushing()
    {
        difference()
        {
            cylinder(h = height_per_part, r = driving_ring_bushing_outer_r, center = true);

            linear_extrude(height = height_per_part, center = true) 
                cross_2d_rounded(cross_hole_inner_d);

            difference()
            {
                linear_extrude(h = height_per_part, center = true) offset(delta = 1) driving_ring_interface();
                linear_extrude(h = height_per_part, center = true) driving_ring_interface();
            }
        }
    }

    module interface()
    {
        linear_extrude(height = height_per_part, center = true)
            driving_ring_interface();
    }
}

module driving_ring()
{
    inside_r = driving_ring_bushing_outer_r + driving_ring_clearance + driving_ring_wall_thickness;

    difference()
    {
        union()
        {
            outer_tube();
            center_structure();
            clutch_teeth();
        }
        driving_ring_mount();
        shift_fork_indent();
    }

    module driving_ring_mount()
    {
        linear_extrude(height = total_length, center = true)
            offset(r = driving_ring_clearance)
            driving_ring_interface();
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

    module axle_hole()
    {
        cylinder(h = total_length, r = axle_hole_inner_r, center = true);
    }

    module shift_fork_indent()
    {
        difference()
        {
            cylinder(h = shift_fork_indent_h, r = driving_ring_outer_r + 0.1, center = true);
            cylinder(h = shift_fork_indent_h, r = driving_ring_outer_r - shift_fork_indent_depth, center = true);
        }
    }
}

module custom_clutch_gear(num_teeth)
{
    inner = driving_ring_bushing_outer_r + driving_ring_clearance;
    outer = inner + axle_hole_wall_thickness;
    teeth_outer = outer + clutch_extrusion;

    difference()
    {
        union()
        {
            translate([0, 0, -total_length / 2 + gear_length / 2])
            spur_gear(n = num_teeth, w = gear_length, helix_angle = 0);

            cylinder(h = total_length, r = outer, center = true);

            clutch_teeth();
        }

        cylinder(h = total_length, r = inner, center = true);
    }

    module clutch_teeth()
    {
        repeatInCircle(n = clutch_teeth, di = 0)
            translate([teeth_outer / 2, 0, 0])
            cube(size = [teeth_outer, clutch_teeth_width, total_length], center=true);
    }
}

module driving_ring_interface()
{
    fudge = -1;
    square_size = 2.5;

    difference()
    {
        circle(r = driving_ring_bushing_outer_r + 1);

        repeatInCircle(n = 4, di = 1/2)
            translate([driving_ring_bushing_outer_r - fudge, 0, 0]) 
            rotate([0, 0, 45])
            square([square_size, square_size], center = true);
    }
}
