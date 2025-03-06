use <common/util.scad>
use <driving_ring_interface.scad>

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

    render()
    {
        color("darkcyan", 1) driving_ring();
        color("peru", 1) shift_fork();
    }

    module driving_ring()
    {
        _inner_r = drac_outer_r + 1 + Driving_Ring_Axle_Connector_Clearance;

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

        module inset()
        {
            _outer_r = dr_inner_r;
            _inner_inner_r = drac_outer_r - 1;

            translate([0, 0, _h/4])
            cylinder(h = _h/4, r1 = _inner_r, r2 = _outer_r);

            translate([0, 0, -_h/2])
            cylinder(h = _h/4, r1 = _outer_r, r2 = _inner_r);

            translate([0, 0, _h/8])
            cylinder(h = _h/8, r1 = _inner_inner_r, r2 = _inner_r);

            translate([0, 0, -_h/4])
            cylinder(h = _h/8, r1 = _inner_r, r2 = _inner_inner_r);
        }

        module clutch_teeth()
        {
            _outer_r = dr_inner_r;
            _clutch_extrusion = _outer_r - _inner_r - 0.25;

            mirror([0, 0, 1])
            repeatInCircle(n = 4, di = 90)
            translate([_outer_r - _clutch_extrusion/2, 0, 0])
            cube([_clutch_extrusion, clutch_teeth_width, _h + fudge], center = true);
        }
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
