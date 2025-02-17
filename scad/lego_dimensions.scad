
// System //

// Spacing between two studs on the same brick
stud_spacing = 8;
// The clearance on each side of a brick
stud_clearance = 0.1;

// Technic //

// Inner diameter of a technic pin hole - this is allegedly 4.85
pin_hole_d = 5.1;
pin_con_depth = 0.7;
pin_con_width = 0.6;
pin_con_d = pin_hole_d + 2*pin_con_width;

true_pin_hole_d = 5.0;
true_pin_hole_r = true_pin_hole_d / 2;

// Width of each spoke of technic axle
axle_spoke_w = 1.95;
// Outer diameter of bushings, etc. that have an interior pin/axle hole
pin_hole_outer_d = true_pin_hole_d + 2;

// Technic gear module is always 1
gear_module = 1;
