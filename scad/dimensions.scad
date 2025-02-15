include <lego_dimensions.scad>;

// Generic part wall thickness - just to avoid magic numbers
general_wall = 1;

// DRAC = driving_ring_axle_connector
drac_wall =    general_wall;
drac_outer_r = true_pin_hole_r + drac_wall;

clutch_extrusion = 1;
clutch_teeth_width = 0.8;