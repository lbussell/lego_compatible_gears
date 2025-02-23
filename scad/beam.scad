use <common.scad>

include <dimensions.scad>

$fn = 35;

render() beam();

module beam(length = 5, width = 1, center = false)
{
    height = 1;

    f_height = studs(height);
    f_length = studs(length);
    f_width = studs(width);

    s_height = cstuds(height);
    s_length = cstuds(length);
    s_width = cstuds(width);

    c_r = s_height / 2;
    f_r = f_height / 2;

    t = center ? [-f_length/2, -f_width/2, -f_height/2] : [0, 0, 0];
    render() translate(t) beam_impl();

    module beam_impl()
    {
        difference()
        {
            hull()
            {
                beam_cyl(0, 0);
                beam_cyl(length-1, 0);
            }

            pin_connectors();
        }
    }

    module pin_connectors()
    {
        for (i = [0:length-1])
        {
            pin_con(i, 0);
        }
    }

    module beam_cyl(x, y)
    {
        s_x = studs(x);
        s_y = studs(y);

        translate([s_x, s_y, 0])
        translate([f_r, f_width - stud_clearance, c_r + stud_clearance])
        rotate([90, 0, 0])
        cylinder(h = s_width, r = c_r);
    }

    module pin_con(x, y)
    {
        translate([studs(x), studs(y), 0])
        translate([studs(1/2), studs(1/2), studs(1/2)])
        rotate([90, 0, 0])
        pin_connector(center = true);
    }
}

module pin_connector(center = false)
{
    length = 1;
    s_length = studs(length);

    pin_hole_r = pin_hole_d / 2;

    t = center ? [0, 0, -s_length / 2] : [0, 0, 0];

    translate(t) union()
    {
        cylinder(h = s_length, r = pin_hole_r);
        translate([0, 0, pin_con_depth/2])
        cylinder(h = pin_con_depth, r = pin_hole_r + pin_con_width, center = true);
        translate([0, 0, s_length - pin_con_depth/2])
        cylinder(h = pin_con_depth, r = pin_hole_r + pin_con_width, center = true);
    }
}

module preview()
    if ($preview) color("yellowgreen", 0.4) children();
