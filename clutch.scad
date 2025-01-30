
total_diameter = 14.0;
total_width = 7.8;
wall_thickness = 1.0;
dog_width = 0.8;
dog_intrusion = 0.7;

/* [Hidden] */
axle_hole_diameter = 5.0;


clutch();


module clutch()
{
    hollow_cylinder();

    module hollow_cylinder()
    {
        interior_diameter = total_diameter - (2 * wall_thickness); 

        difference()
        {
            cylinder(h = total_width, r = total_diameter / 2, center = true);
            translate(v = [0, 0, -wall_thickness / 2]) 
            cylinder(h = total_width - wall_thickness, r = interior_diameter / 2, center = true);
        }
    }
}
