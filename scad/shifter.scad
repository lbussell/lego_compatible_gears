use <common.scad>
use <beam.scad>
include <dimensions.scad>

tow_ball_clearance = 0.1;
connector_clearance = 0.1;
num_beams = 3;
scoop = true;

angleX = 60;
angleY = 60;

/* [Hidden] */
$fn = 50;

render() shifter_travel(angleX, angleY, tow_ball_clearance, connector_clearance);

module shifter_travel(angleX, angleY, tow_ball_clearance = 0.0, connector_clearance = 0.0)
{
    tow_ball_r = tow_ball_d / 2 + tow_ball_clearance;

    distribute(spacing = 16)
    {
        cleared_beam(x = 0);
        cleared_beam(x = -1);
        cleared_beam(x = -0.5);
    }

    module shifted_shifter(x = 0)
    {
        step = 0.25;

        r() 
        {
            shifter_part1();
            shifter_part2();
            shifter_part3();
        }

        module r()
        {
            for (c = [0 : $children-1])
            {
                for (i = [-studs(1) : step : studs(1) - step])
                {
                    hull()
                    {
                        s([studs(x), i, studs(2)]) children(c);
                        s([studs(x), i + step, studs(2)]) children(c);
                    }
                }
            }
        }

        module s(v)
        {
            translate(v)
                rotate(lookAt(v, [0, 0, 0]))
                rotate([0, 180, 0])
                children();
        }
    }

    module shifter_part1() shifter_connector(scoop=scoop);
    module shifter_part2() translate([0, 0, -studs(2)]) tow_ball();
    module shifter_part3() translate([0, 0, -studs(2)]) tow_ball_pin();
        
    module cleared_beam(x = 0)
    {
        shifter_pos = [studs(x), 0, studs(2)];

        difference()
        {
            actual_beam(length = 5);

            shifted_shifter(x);

            translate([studs(x), 0, studs(2)])
            {
                if (x == 0)
                {
                    hull() rotated_shifter(y = 100);
                }
                else
                {
                    v = lookAt(shifter_pos, [0, 0, 0]);
                    y = 2*(180-v[1]);
                    echo(v);
                    echo(y);

                    hull() rotated_shifter(y = y);
                }
            }

            translate([0, studs(2), 0]) half_pin_connector();
            translate([0, studs(-2), 0]) half_pin_connector();
        }

        module half_pin_connector()
        {
            union()
            {
                translate([pin_con_depth / 2, 0, 0])
                    rotate([0, 90, 0])
                    cylinder(h = pin_con_depth, d = pin_con_d + pin_con_width/2, center = true);
                translate([-studs(0.5), -studs(0.5), -studs(0.5)])
                    cube([studs(0.5), studs(1), studs(1)]);
            }
        }
    }

    module s(v)
    {
        translate(v)
            rotate(lookAt(v, [0, 0, 0]))
            rotate([0, 180, 0])
            shifter();
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
    }

    module rotated_shifter(x = 0, y = 0)
    {
        rotate_all(x, y)
        {
            shifter_connector(scoop=scoop);
            translate([0, 0, -studs(2)]) tow_ball();
            translate([0, 0, -studs(2)]) tow_ball_pin();
        }

        module rotate_all(x = 0, y = 0)
        {
            union()
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
        shifter_h = studs(3) + 2*connector_clearance;
        shifter_w = studs(1) + 2*connector_clearance;
        shifter_l = studs(1) + 2*connector_clearance;

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
