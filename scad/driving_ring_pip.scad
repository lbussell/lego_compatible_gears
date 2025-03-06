use <common/util.scad>
use <driving_ring_interface.scad>
use <gear/gear.scad>

include <common/dimensions.scad>

// Clearance between driving ring and outer shift fork
Clearance = 0.25;
// Height in studs
Height = 1;
// Outer wall thickness
Outer_Wall = 2;
// Driving ring axle connector clearance
Driving_Ring_Axle_Connector_Clearance = 0.15;

/* [Hidden] */
fudge = 0.1;
$fn = 100;

driving_ring_pip();

module driving_ring_pip()
{
    _dr_height = cstuds(Height);

    _inset_height = _dr_height / 2;

    // inset should make the inner r a 45 degree angle
    _inset = _inset_height / 2; 
    _inner_r = dr_outer_r - _inset;

    _h = _dr_height;
    _dr_outer_r = dr_outer_r;
    _pip_inset_r = dr_outer_r - _inset;

    _dr_inner_r = drac_outer_r + 1 + Driving_Ring_Axle_Connector_Clearance;

    render()
    {
        difference()
        {
            assembly();

            lo = -1;
            hi = 1;
            t = lo + (hi - lo) * sin(360*$t);
            *translate([0, 0, 10 + t]) 
            cube([100, 100, 20], center = true);
        }
    }

    module assembly()
    {
        union() 
        {
            color("darkcyan", 1) driving_ring();
            color("peru", 1) shift_fork();

            *color("peru", 1)
                rotate([0, 0, 70])
                translate([0, 0, -6])
                difference()
            {
                custom_clutch_gear(num_teeth = 20, is_clutch = true);

                difference()
                {
                    translate([0,0,studs(1/4)]) cylinder(h = studs(1/4)-0.1, r = 14);
                    translate([0,0,cstuds(3/4)]) rotate([0, 180, 0])
                        inset_impl(clearance = 0.1);
                }
            }
        }
    }

    module driving_ring()
    {

        union()
        {
            difference()
            {
                rotate_extrude() driving_ring_side_profile_2d();
                linear_extrude(h = _h, center = true)
                    offset(r = Driving_Ring_Axle_Connector_Clearance)
                    driving_ring_interface();
                inset();
            }

            // Divot for fixed driving ring positions
            _circle_pos = drac_outer_r + 1.5;
            _circle_r = 0.7;
            *rotate_extrude() translate([_circle_pos, 0]) circle(r = _circle_r);

            clutch_teeth();
        }

        module clutch_teeth()
        {
            _outer_r = dr_inner_r;
            _clutch_extrusion = _outer_r - _dr_inner_r - 0.25;

            mirror([0, 0, 1])
                repeatInCircle(n = 4, di = 90)
                translate([_outer_r - _clutch_extrusion/2, 0, 0])
                cube([_clutch_extrusion, clutch_teeth_width, _h], center = true);
        }
    }

    module inset()
    {
        inset_impl();
        mirror([0, 0, 1]) inset_impl();
    }

    module inset_impl(clearance = 0)
    {
        inset_outer_r = dr_inner_r;
        inset_inner_r = drac_outer_r - 1;

        translate([0, 0, _h/4])
        cylinder(h = _h/4, r1 = _dr_inner_r + clearance, r2 = inset_outer_r + clearance);

        translate([0, 0, _h/8])
        cylinder(h = _h/8, r1 = inset_inner_r + clearance, r2 = _dr_inner_r + clearance);
    }

    module shift_fork()
    {
        _sf_outer_r = _dr_outer_r + Clearance + Outer_Wall;

        difference()
        {
            cylinder(h = _h, r = _sf_outer_r, center = true);
            interface();
        }

        module interface()
        {
            rotate_extrude()
            difference()
            {
                offset(delta = Clearance)
                driving_ring_side_profile_2d();

                // Remove all negative x values to make rotate_extrude work
                translate([-50, 0]) square([100, 100], center = true);
            }
        }
    }

    module driving_ring_side_profile_2d()
    {
        polygon([
            // Cube
            [_dr_outer_r, _h/2],
            [0, _h/2],
            [0, -_h/2],
            [_dr_outer_r, -_h/2],

            // Inset
            [_dr_outer_r, -_h/4],
            [(_pip_inset_r + _dr_outer_r) / 2, -_h/8],
            [(_pip_inset_r + _dr_outer_r) / 2, +_h/8],
            [_dr_outer_r, _h/4],
        ]);
    }
}
