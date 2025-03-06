// https://github.com/dpellegr/PolyGear
use <PolyGear.scad>
use <../common/util.scad>
use <../clutch.scad>
use <../cross_hole.scad>

include <../common/dimensions.scad>
use <axle_connector.scad>

num_teeth = 16;
length = cstuds(1);
gear_ratio = 1/2;
is_clutch = false;
center = true;
chamfer = false;

drac_clearance = 0.15;

small_gear_cutoff = 12;
clutch_wall = general_wall;
clutch_teeth = 4;

/* [Hidden] */
$fn = 100;
debug = false;
fudge = 0.1;


render()
    custom_clutch_gear(
        num_teeth,
        length,
        gear_ratio,
        is_clutch,
        center,
        chamfer);


module custom_clutch_gear(
    num_teeth,
    length = cstuds(1),
    gear_ratio = 3/4,
    is_clutch = false,
    center = false,
    chamfer = false)
{
    chamfer_angle = chamfer ? 45 : 0;
    chamfer_shift = -1;

    use_small_relief = num_teeth <= small_gear_cutoff;

    support_width = 2.0;

    gear_length =  cstuds(1) * (gear_ratio);

    inner_padding = 2.5;
    inner_r = num_teeth / 2 - inner_padding;

    clutch_inner_r = drac_outer_r + drac_clearance;
    clutch_outer_r = clutch_inner_r + clutch_wall;

    difference()
    {
        gear_assembly();
        connector();
    }

    module gear_assembly()
    {
        union()
        {
            gear_body();
            if (is_clutch)
            {
                linear_extrude(length, center = true) clutch_2d();
            }
            else
            {
                axle_connector_holder();
            }
        }

        module axle_connector_holder()
        {
            linear_extrude(height = length, center = true)
            {
                if (num_teeth > small_gear_cutoff)
                {
                    union()
                    {
                        hull() offset(delta=1) axle_connector_2d();
                        offset(delta=1) relief_2d(small = use_small_relief);
                    }
                }
                else
                {  
                    circle(r = 4.35);
                }
            }
        }

        module gear_body()
        {
            is_hollow = !is_clutch && num_teeth > small_gear_cutoff;

            z_offset =
                center ? 0 : -length / 2 + gear_length / 2;

            translate([0, 0, z_offset])
            {
                gear(is_hollow = is_hollow);

                if (is_hollow)
                {
                    support();
                }
            }

            module support() union()
            {
                for (i = [0,1]) 
                {
                    rotate([0, 0, i * 90])
                    cube([support_width, 2 * inner_r, gear_length], center = true);
                }
            }

            module gear(is_hollow = false) 
            {
                if (is_hollow)
                {
                    difference()
                    {
                        gear_impl();
                        cylinder(h = length, r = inner_r, center = true);
                    }
                }
                else
                {
                    gear_impl();
                }

                module gear_impl()
                    spur_gear(
                        n = num_teeth, 
                        w = gear_length, 
                        chamfer = chamfer_angle, 
                        chamfer_shift = chamfer_shift, 
                        pressure_angle = 20, 
                        helix_angle = 0,
                        x = 0,
                        type = 1,
                        add = 0);
            }
        }

    }

    module connector()
    {
        if (is_clutch)
        {
            cylinder(h = length + fudge, r = clutch_inner_r, center = true);
        }
        else
        {
        linear_extrude(height = length + fudge, center = true)
            axle_connector_with_relief_2d(use_small_relief = use_small_relief);
        }
    }

    module clutch_2d()
    {
        difference()
        {
            clutch_body();
            circle(r = clutch_inner_r);
        }

        module clutch_body()
        {
            union()
            {
                circle(r = clutch_outer_r);
                clutch_teeth();
            }

            module clutch_teeth()
            {
                repeatInCircle(n = clutch_teeth, di = 0)
                    translate([0, -clutch_teeth_width / 2, 0])
                    square([clutch_outer_r + clutch_extrusion, clutch_teeth_width]);
            }
        }
    }

}
