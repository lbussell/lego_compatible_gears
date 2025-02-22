use <common.scad>
use <beam.scad>
include <dimensions.scad>

tow_ball_clearance = 0.1;
connector_clearance = 0.1;
num_beams = 3;

angleX = 60;
angleY = 60;

/* [Hidden] */
$fn = 50;

render() shifter_travel(angleX, angleY);

// The basic idea is that we'll take a lego element, 32034
// https://www.bricklink.com/v2/catalog/catalogitem.page?P=32034
// and rotate it around its center point.
// We should create a sphere which provides enough clearance for the connector 
// to spin freely about its center.
module shifter_travel(angleX, angleY, tow_ball_clearance = 0.0, connector_clearance = 0.0)
{
    tow_ball_r = tow_ball_d / 2 + tow_ball_clearance;

    shifter_travel(angleX, angleY);

    *difference()
    {
        beams();
        shifter_travel(angleX, angleY);
    }

    // Y angle = side to side movement
    // X angle = front to back movement
    module shifter_travel(angleX = 60, angleY = 60, columns = 3)
    {
        if (columns == 3)
        {
            rotated_shifter(y = angleY);
            rotated_shifter(x = angleX);
            rotate([0, -angleY/2, 0]) rotated_shifter(x = angleX);
            rotate([0, angleY/2, 0]) rotated_shifter(x = angleX);
        }
        else if (columns == 2)
        {
            rotated_shifter(y = angleY);
            rotate([0, -angleY/2, 0]) rotated_shifter(x = angleX);
            rotate([0, angleY/2, 0]) rotated_shifter(x = angleX);
        }

        module rotated_shifter(x = 0, y = 0)
        {
            rotate_all(x, y)
            {
                shifter_connector(scoop=true);
                translate([0, 0, -studs(2)]) tow_ball();
                translate([0, 0, -studs(2)]) tow_ball_pin();
            }

            module rotate_all(x = 0, y = 0)
            {
                if (x != 0)
                {
                    for (c = [0 : $children-1])
                    {
                        rotate_x(x) children(c);
                    }
                }

                if (y != 0)
                {
                    for (c = [0 : $children-1])
                    {
                        rotate_y(y) children(c);
                    }
                }
            }

            module rotate_x(angle)
            {
                for (i = [0 : $children-1])
                {
                    rotate([0, 0, 90])
                    rotate_extrude_3d(angle = angle, start = -angle/2)
                    rotate([0, 0, 90])
                    children(i);
                }
            }

            module rotate_y(angle)
            {
                for (i = [0 : $children-1])
                {
                    rotate_extrude_3d(angle = angle, start = -angle/2)
                    children(i);
                }
            }
        }
    }

    module rotate_extrude_3d(angle = 90, start = 0)
    {
        end = start + angle;
        step = 5;

        union()
        {
            for (i = [start : step : end - step])
            {
                hull()
                {
                    rotate([0, i, 0]) children();
                    rotate([0, i + step, 0]) children();
                }
            }
        }
    }

    module shifter_travel_impl(angle)
    {
        rotate([90, 90, 0])
            rotate_extrude(angle = angle, start = -angle/2)
            shifter_2d_x_only();

        module shifter_2d_x_only()
        {
            intersection()
            {
                translate([0, -studs(1.5)])
                square([studs(3), studs(3)]);
                shifter_2d();
            }
        }
    }

    module shifter_2d()
    {
        projection(cut = true)
            rotate([0, -90, 0])
            shifter();
    }

    module shifter()
    {
        union()
        {
            shifter_connector();

            translate([0, 0, studs(-2)])
                union()
                {
                    tow_ball_pin();
                    tow_ball();
                }
        }
    }

    module shifter_connector(scoop = false)
    {
        // The element 32034 1x1x3 studs.
        shifter_h = studs(3);
        shifter_w = studs(1);
        shifter_l = studs(1);

        difference()
        {
            cube([shifter_w, shifter_l, shifter_h], center = true);

            if (scoop)
            {
                scoop();
            }
        }

        module scoop()
        {
            d = studs(0.6);
            translate([d, d, 0])
                cylinder(h = shifter_h, r = tow_ball_r, center = true);
            translate([-d, d, 0])
                cylinder(h = shifter_h, r = tow_ball_r, center = true);
            translate([d, -d, 0])
                cylinder(h = shifter_h, r = tow_ball_r, center = true);
            translate([-d, -d, 0])
                cylinder(h = shifter_h, r = tow_ball_r, center = true);
        }
    }

    module tow_ball_pin() cylinder(r = tow_ball_r/2, h = studs(1.5));
    module tow_ball() sphere(r = tow_ball_r);

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
                // color("olivedrab")
                actual_beam(length = _beam_l);

            translate([studs(1), 0, studs(-2)])
                // color("royalblue")
                actual_beam(length = _beam_l);

            translate([studs(-1), 0, studs(-2)])
                // color("palevioletred")
                actual_beam(length = _beam_l);
        }
        else if (num_beams == 2)
        {
            translate([studs(0.5), 0, studs(-2)])
                // color("royalblue")
                actual_beam(length = _beam_l);

            translate([studs(-0.5), 0, studs(-2)])
                // color("palevioletred")
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
