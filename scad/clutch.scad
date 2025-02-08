
total_diameter = 14.0;
total_width = 7.8;
wall_thickness = 1.0;
dog_width = 0.8;
dog_intrusion = 0.7;
axle_hole_diameter = 5.0;
axle_inset_width = 1.0 / 2;
axle_inset_depth = 0.7;

/* [Hidden] */
$fn = 50;

clutch();

module clutch()
{
    interior_diameter = total_diameter - (2 * wall_thickness); 

    axle_hole_outer_diameter = axle_hole_diameter + (wall_thickness * 2);

    difference()
    {
        union()
        {
            hollow_cylinder();
            cylinder(h = total_width, r = axle_hole_outer_diameter / 2, center = true);
            dogs();
        }

        // Axle hole
        cylinder(h = total_width, r = axle_hole_diameter / 2, center = true);

        // Axle inset
        translate(v = [0, 0, (total_width / 2) - (axle_inset_depth / 2)]) 
        cylinder(h = axle_inset_depth, r = (axle_hole_diameter / 2) + axle_inset_width, center = true);
        translate(v = [0, 0, -(total_width / 2) + (axle_inset_depth / 2)]) 
        cylinder(h = axle_inset_depth, r = (axle_hole_diameter / 2) + axle_inset_width, center = true);
    }

    module hollow_cylinder()
    {
        difference()
        {
            cylinder(h = total_width, r = total_diameter / 2, center = true);
            translate(v = [0, 0, -wall_thickness / 2]) 
            cylinder(h = total_width - wall_thickness, r = interior_diameter / 2, center = true);
        }
    }

    module dogs() 
    {
        offset = (interior_diameter / 2) - (dog_intrusion / 2);

        union()
        {
            translate(v = [ offset, 0, 0]) dog();
            translate(v = [-offset, 0, 0]) dog();
            translate(v = [0,  offset, 0]) rotate(a = 90) dog();
            translate(v = [0, -offset, 0]) rotate(a = 90) dog();
        }

        module dog()
        {
            cube([dog_width, dog_intrusion, total_width], center = true);
        }
    }

    module axle_hole(length = length)
    {
        outer_diameter = axle_hole_diameter + (wall_thickness * 2);

        difference()
        {
            cylinder(h = length, r = outer_diameter / 2, center = true);
            cylinder(h = length, r = axle_hole_diameter / 2, center = true);
        }
    }

}

function clutch_outer_diameter() = total_diameter;
