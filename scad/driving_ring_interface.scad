use <common/util.scad>
include <common/dimensions.scad>

driving_ring_interface();

module driving_ring_interface()
{
    fudge = -1;
    square_size = 2.5;

    difference()
    {
        circle(r = drac_outer_r + 1);

        repeatInCircle(n = 4, di = 1/2)
            translate([drac_outer_r - fudge, 0, 0]) 
            rotate([0, 0, 45])
            square([square_size, square_size], center = true);
    }
}
