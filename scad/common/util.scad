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

module distribute(spacing = 16)
{
    for (c = [0 : $children-1])
    {
        translate([c * spacing, 0, 0])
        children(c);
    }
}

function vectorLength(v1,v2) = sqrt(
    (v2[0]-v1[0])*(v2[0]-v1[0])+
    (v2[1]-v1[1])*(v2[1]-v1[1])+
    (v2[2]-v1[2])*(v2[2]-v1[2]));

function lookAt(v1, v2) =
    let(v = v2-v1)
    [
       0,
       acos(v[2]/vectorLength(v1,v2)),
       atan2(v[1], v[0])
    ];

module serial_hull()
{
    for(i=[0:$children-2])
    {
        hull()
        {
            children(i);
            children(i+1);
        }
    }
}
