// https://github.com/dpellegr/PolyGear
use <PolyGear.scad>

teeth = 16;
width_studs = 1;
width = studs(width_studs);
taper = true;

/* [Hidden] */
$fn = 50;
cross_hole_diameter = 5.15;
cross_width = 1.95;

axle_gear(num_teeth = teeth, width = width, taper = taper);

module axle_gear(num_teeth = 16, width = studs(1), taper = true)
{
  fillet_radius = 0.20;
  helix_angle = 0;
  wall_thickness = 1.0;
  magic_wall_number = 2.5;
  inner_space_diameter = num_teeth - magic_wall_number - (2 * wall_thickness);

  // Support structure
  support_length = (inner_space_diameter - cross_hole_diameter) / 2;
  support_start = cross_hole_diameter / 2 + support_length / 2;
  z = 0;

  small_r = inner_space_diameter / 2 + wall_thickness;
  big_r = (teeth  + magic_wall_number) / 2;

  intersection()
  {
    if (taper)
    {
      tapered_cylinder(big_r, small_r, width, width / 2);
    }

    union()
    {
      hollow_gear(num_teeth, width);
      cross_hole(width, wall_thickness, fillet_radius);

      translate([0,  support_start, z]) cube([wall_thickness, support_length, width], center = true);
      translate([0, -support_start, z]) cube([wall_thickness, support_length, width], center = true);
      translate([ support_start, 0, z]) cube([support_length, wall_thickness, width], center = true);
      translate([-support_start, 0, z]) cube([support_length, wall_thickness, width], center = true);
    }
  }

  module tapered_cylinder(r_outer, r_inner, h, h_inner)
  {
    h_outer = (h - h_inner) / 2;
    outer_offset = (h_inner + h_outer) / 2;

    cylinder(h = h_inner, r = r_outer, center = true);
    translate([0, 0, outer_offset])
    cylinder(h = h_outer, r1 = r_outer, r2 = r_inner, center = true);
    translate([0, 0, -outer_offset])
    cylinder(h = h_outer, r1 = r_inner, r2 = r_outer, center = true);
  }

  module hollow_gear(num_teeth, width)
  {
    fn = 10;
    difference()
    {
      spur_gear(
        n = num_teeth,
        w = width,
        helix_angle = helix_angle,
        $fn = fn);
      cylinder(
        h = width,
        r = inner_space_diameter / 2,
        center = true);
    }
  }
}

module cross_hole(length, wall_thickness, fillet_radius = 0.20)
{
  translate([0, 0, -length / 2])
  linear_extrude(length)
  cross_hole_2d();

  module cross_hole_2d()
  {
    difference()
    {
      circle(r = cross_hole_diameter / 2 + wall_thickness);
      difference()
      {
        cross_2d_filleted();
        difference()
        {
          // Create a tube that cuts off the excess of the cross hole to round the outside edges
          circle(r = cross_hole_diameter / 2 + wall_thickness);
          circle(r = cross_hole_diameter / 2);
        }
      }
    }
  }

  module cross_2d_filleted()
  {
    offset(r = -fillet_radius)
    offset(r = fillet_radius)
    cross_2d();
  }

  module cross_2d()
  {
    union()
    {
      square([cross_width, cross_hole_diameter], center = true);
      square([cross_hole_diameter, cross_width], center = true);
    }
  }
}

function studs(n) = 8 * n - (0.1 * 2);
