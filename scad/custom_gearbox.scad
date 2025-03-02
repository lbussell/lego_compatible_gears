// https://github.com/dpellegr/PolyGear
use <PolyGear.scad>
use <common.scad>
use <clutch.scad>
use <cross_hole.scad>

part = "fork"; // ["driving_ring", "bushing", "fork", "fork_offset"]
num_teeth = 18;
is_clutch = true;

gear_length         = studs(1) * (3/4);
clutch_teeth_length = studs(1) * (1/4);
total_length = gear_length + clutch_teeth_length;
driving_ring_bushing_length = studs(3);

driving_ring_length = studs(1);
driving_ring_clearance = 0.15;
driving_ring_wall_thickness = 1;

cross_hole_inner_d = 5.00;
cross_hole_inner_r = cross_hole_inner_d / 2;

bushing_wall_thickness = 1.0;
axle_hole_wall_thickness = 1.0;

clutch_teeth = 4;
clutch_extrusion = 1;
clutch_teeth_width = 0.8;

driving_ring_outer_r = 7.0;
driving_ring_inner_r = driving_ring_outer_r - driving_ring_wall_thickness;

driving_ring_bushing_outer_r = (5.0 / 2) + 1;

shift_fork_indent_h = studs(1/4);
shift_fork_indent_depth = 1.5;

separation = studs(1/4);

/* [Hidden] */
$fn = 35;
debug = false;

render()
{
    assembly();
}

module assembly()
{
    if (part == "driving_ring")
    {
        driving_ring();
    }

    if (part == "fork")
    {
        color("slateblue") shift_fork([8*2, 0, 0]);
    }

    if (part == "fork_offset")
    {
        color("slateblue") shift_fork([8*2, 8, 0]);
    }

    if (part == "bushing")
    {
        color("firebrick") driving_ring_bushing();
    }

    if (debug)
    {
        translate([-2 * 8, -2 * 8, 0])
        stud_grid();
    }
}

module driving_ring_bushing()
{
    difference()
    {
        union()
        {
            translate([0, 0, height_per_part]) axle_bushing(height_per_part);
            interface();
            translate([0, 0, -height_per_part]) axle_bushing(height_per_part);
        }
    }

    h = 8;
    height_per_part = ((h * 3) - (0.1 * 2)) / 3;

    module interface()
    {
        linear_extrude(height = height_per_part, center = true)
            driving_ring_interface();
    }
}

module axle_bushing(h)
{
    difference()
    {
        cylinder(h = h, r = driving_ring_bushing_outer_r, center = true);

        linear_extrude(height = h, center = true) 
            cross_2d_rounded(cross_hole_inner_d);

        difference()
        {
            linear_extrude(h = h, center = true) offset(delta = 1) driving_ring_interface();
            linear_extrude(h = h, center = true) driving_ring_interface();
        }
    }
}

module driving_ring()
{
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

shift_fork_dr_clearance = 0.35;
shift_fork_gear_clearance = studs(1/4);
shift_fork_wall_thickness = 1.0;

shift_fork_inner_r = driving_ring_outer_r + shift_fork_dr_clearance;
shift_fork_outer_r = shift_fork_inner_r + shift_fork_wall_thickness;
shift_fork_length = studs(1) - shift_fork_gear_clearance;

module shift_fork(connector_position = [8*2, 0, 0])
{
    cube_size = 20;
    shift_fork_thickness = shift_fork_indent_h - 2*shift_fork_dr_clearance;

    difference()
    {
        union()
        {
            linear_extrude(height = studs(1), center = true)
                connector_outer_2d();


            // outer
            difference()
            {
                union()
                {
                    linear_extrude(height = shift_fork_thickness + 1, center = true) frame_2d();
                    cylinder(h = shift_fork_length, r = shift_fork_outer_r, center = true);
                }
                cylinder(h = shift_fork_length, r = shift_fork_inner_r, center = true);
            }

            // inner
            difference()
            {
                cylinder(h = shift_fork_thickness, r = shift_fork_outer_r, center = true);
                cylinder(h = shift_fork_indent_h, r = shift_fork_inner_r - shift_fork_indent_depth, center = true);
            }

        }

        cylinder(h = shift_fork_indent_h, r = shift_fork_inner_r - shift_fork_indent_depth, center = true);
        // cut off half of the cylinder to turn it into a fork
        translate([-cube_size, -cube_size / 2, -cube_size / 2]) cube(cube_size);

        // connector
        translate(connector_position)
            linear_extrude(h = studs(1) + 0.1, center = true)
            cross_2d_rounded(cross_hole_inner_d);
    }

    module connector_outer_2d()
    {
        translate(connector_position)
            circle(r = studs(1) / 2);
    }

    module fork_outer_2d()
    {
        circle(r = shift_fork_outer_r);
    }
    
    module frame_2d()
    {
        smooth = 10;
        connector_width = studs(3/4);

        distance_from_center_to_connector = sqrt(pow(connector_position[0], 2) + pow(connector_position[1], 2));
        angle_from_center_to_connector = -atan2(connector_position[1], connector_position[0]);

        offset(-smooth)
        offset(smooth)
        impl();

        module impl()
        {
            union()
            {
                fork_outer_2d();

                // connect fork to connector
                rotate([0, 0, -angle_from_center_to_connector])
                    translate([0, -connector_width / 2, -shift_fork_thickness / 2])
                    square([distance_from_center_to_connector, connector_width]);

                connector_outer_2d();
            }
        }
    }
}

module stud_grid()
{
    for (i = [0:4])
    {
        for (j = [0:4])
        {
            // for (k = [0:4])
            // {
                // translate([i * 8, j * 8, k * 8])
                translate([i * 8, j * 8])
                color("crimson", 0.3)
                // cylinder(r = cross_hole_inner_r, h = 1, center = true);
                sphere(r = 0.5);
            // }
        }
    }
}
