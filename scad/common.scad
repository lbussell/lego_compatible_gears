
include <lego_dimensions.scad>;

function studs(n) = n * stud_spacing;

function cstuds(n) = studs(n) - (2 * stud_clearance);

module bevel_cylinder(r_outer, r_inner, total_h, h_inner)
{
    h_outer = (total_h - h_inner) / 2;
    outer_offset = (h_inner + h_outer) / 2;

    cylinder(h = h_inner, r = r_outer, center = true);
    translate([0, 0, outer_offset])
    cylinder(h = h_outer, r1 = r_outer, r2 = r_inner, center = true);
    translate([0, 0, -outer_offset])
    cylinder(h = h_outer, r1 = r_inner, r2 = r_outer, center = true);
}

module repeatInCircle(n,di)
{
    for(i=[0:n-1])
        rotate([0,0,(i+di)*360/n]) children();
}

module preview()
{
    color("crimson", 0.3)
    children();
}

module stud_grid(x, y, z)
{
    for (i = [0:x-1])
    {
        for (j = [0:y-1])
        {
                translate([i * 8, j * 8])
                color("crimson", 0.3) sphere(r = 0.5, $fn = 10);
        }
    }
}
