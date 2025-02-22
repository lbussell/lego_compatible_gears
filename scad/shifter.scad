use <common.scad>
use <beam.scad>
include <dimensions.scad>

tow_ball_clearance = 0.1;
connector_clearance = 0.1;
num_beams = 2;

/* [Hidden] */
$fn = 50;

render() shifter_cutout();

// The basic idea is that we'll take a lego element, 32034
// https://www.bricklink.com/v2/catalog/catalogitem.page?P=32034
// and rotate it around its center point.
// We should create a sphere which provides enough clearance for the connector 
// to spin freely about its center.
module shifter_cutout(tow_ball_clearance = 0.1, connector_clearance = 0.1)
{
    tow_ball_r = tow_ball_d / 2 + tow_ball_clearance;

    // actual_beam();
    difference()
    {
        beams();
        union()
        {
            connector_cutout();
            intersection()
            {
                translate([0, 0, studs(-2)]) allowed_travel();
                tow_ball_cutout();
            }
        }
    }

    module allowed_travel()
    {
        cube([studs(num_beams) - 2*studs(1/4), studs(1), studs(1)], center = true);
    }

    module beams()
    {
        difference()
        {
            beams();
            union()
            {
                connector_cutout();
                tow_ball_cutout();
            }
        }
    }

    module connector_cutout()
    {
        // The element 32034 1x1x3 studs.
        shifter_h = studs(3);
        shifter_w = studs(1);
        shifter_l = studs(1);

        // Calculate the distance from origin to the corner of the connector
        // which is the furthest away from the origin.
        shifter_sphere_r = sqrt(shifter_w^2 + shifter_l^2 + shifter_h^2) / 2 + connector_clearance;

        sphere(r = shifter_sphere_r);
    }

    module tow_ball_cutout()
    {
        union()
        {
            hull()
                rotate([90, 0, 0])
                rotate_extrude()
                translate([studs(2), 0, 0])
                circle(r = tow_ball_r);
        }
    }

    module beams()
    {
        _beam_l = 5;
        _beam_ls = studs(_beam_l);
        _beam_ws = studs(1);

        if (num_beams == 3)
        {
            translate([0, 0, studs(-2)])
                color("olivedrab")
                actual_beam(length = _beam_l);

            translate([studs(1), 0, studs(-2)])
                color("royalblue")
                actual_beam(length = _beam_l);

            translate([studs(-1), 0, studs(-2)])
                color("palevioletred")
                actual_beam(length = _beam_l);
        }
        else if (num_beams == 2)
        {
            translate([studs(0.5), 0, studs(-2)])
                color("royalblue")
                actual_beam(length = _beam_l);

            translate([studs(-0.5), 0, studs(-2)])
                color("palevioletred")
                actual_beam(length = _beam_l);
        }


        module beam_basic(length = 5)
        {
            _h = studs(1);
            _w = studs(1);
            _l = studs(length);

            color("olivedrab") cube([_w, _l, _h], center = true);
        }

        module actual_beam(length = 5)
        {
            cube([cstuds(1), cstuds(1), cstuds(1)], center = true);
                rotate([0, 0, 90])
                beam(length = length, center = true);
        }
    }
}
