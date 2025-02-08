
function studs(n) = 8 * n - (0.1 * 2);

module tapered_cylinder(r_outer, r_inner, total_h, h_inner)
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
