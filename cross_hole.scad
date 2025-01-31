
fillet_radius = 0.20;
cross_hole_diameter = 5.15;
cross_width = 1.95;

module cross_hole(length, wall_thickness)
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

function cross_hole_outer_diameter(wall_thickness) =
    2 * (cross_hole_diameter / 2 + wall_thickness);
