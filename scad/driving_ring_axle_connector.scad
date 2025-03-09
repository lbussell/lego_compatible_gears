use <gear/axle_connector.scad>
use <driving_ring_interface.scad>
use <common/util.scad>
include <common/dimensions.scad>

/* [Hidden] */
$fn = 50;

render() driving_ring_axle_connector();

module driving_ring_axle_connector()
{
    difference()
    {
        union()
        {
            tophalf();
            mirror([0, 0, 1]) tophalf();
        }
    }

    module tophalf()
    {
        r = drac_outer_r + 1;

        intersection()
        {
            linear_extrude(h=studs(1/2))
                driving_ring_interface();

            union()
            {
                cylinder(h=studs(1/3), r=r);
                translate([0,0, studs(1/3)])
                    cylinder(h=studs(1/6), r1=r, r2=drac_outer_r);
            }
        }

        translate([0, 0, studs(1/2)])
            bushing(studs(1));
    }

    module bushing(h)
        difference()
        {
            linear_extrude(h) 
                offset(drac_wall)
                connector();

            linear_extrude(h)
                connector();
        }

    module connector() axle_connector_2d();
}
