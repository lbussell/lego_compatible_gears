include <../common/dimensions.scad>

module axle_connector_with_relief_2d(use_small_relief = false)
{
    union()
    {
        relief_2d(small = use_small_relief);
        axle_connector_2d();
    }
}

module axle_connector_2d()
{
    intersection()
    {
        circle(r = true_pin_hole_d / 2);
        connector();
    }

    module connector()
    {
        connector_slot();
        rotate([0, 0, 90]) connector_slot();
    }

    module connector_slot(length = true_pin_hole_d)
    {
        union()
        {
            square([length, axle_spoke_w], center = true);
        }
    }
}

module relief_2d(small = false)
{
    relief_d = small ? 0.95 * pin_hole_outer_d : 1.5 * true_pin_hole_d;
    relief_w = axle_spoke_w / 2;
    relief_r = relief_d / 2;

    intersection()
    {
        // round the outside of the relief holes
        circle(r = relief_r);

        union()
        {
            for (i = [0, 1])
            {
                rotate([0, 0, i * 90])
                square([relief_d, relief_w], center = true);
            }
        }
    }
}
