$fn = 50;

stud_l = 8;
stud_clearance = 0.1;

piston_r = studs(0.62);

engine_block_l = studs(6);
engine_block_w = studs(2);
engine_block_h = studs(2);
engine_block_piston_r = studs(0.6);

num_pistons = 4;

wall_thickness = 1.1;

piston_separation = studs(1 + 1/3);

fudge = 0.1;

engine_block();

module engine_block()
{
    mount_inner_r = (4.8) / 2;
    mount_outer_r = mount_inner_r + 1.6;

    // temp_offset = engine_block_l - studs(4);

    center_horiz = engine_block_w / 2;
    center_vert = engine_block_h / 2;
    center_len = engine_block_l / 2;
    mount_offset_horiz = studs(1);
    mount_offset_vert = studs(1) - (4.8 / 2);

    difference()
    {
        union()
        {
            linear_extrude(height = engine_block_h) simple_engine_block_2d();

            hull()
            {
                translate([
                    center_horiz - mount_offset_horiz,
                    center_len - engine_block_l/2 + studs(1/2),
                    mount_offset_vert])
                rotate([90, 0, 0])
                cylinder(h = studs(1), r = mount_outer_r, center = true);

                translate([
                    center_horiz - mount_offset_horiz,
                    center_len - engine_block_l/2 + studs(1/2),
                    mount_offset_vert / 2])
                cube([mount_outer_r * 2, mount_outer_r * 2, mount_offset_vert], center = true);

                translate([
                    center_horiz + mount_offset_horiz,
                    center_len - engine_block_l/2 + studs(1/2),
                    mount_offset_vert])
                rotate([90, 0, 0])
                cylinder(h = studs(1), r = mount_outer_r, center = true);

                translate([
                    center_horiz + mount_offset_horiz,
                    center_len - engine_block_l/2 + studs(1/2),
                    mount_offset_vert / 2])
                cube([mount_outer_r * 2, mount_outer_r * 2, mount_offset_vert], center = true);
            }

            hull()
            {
                translate([
                    center_horiz - mount_offset_horiz,
                    center_len + engine_block_l/2 - studs(1/2),
                    mount_offset_vert])
                rotate([90, 0, 0])
                cylinder(h = studs(1), r = mount_outer_r, center = true);

                translate([
                    center_horiz - mount_offset_horiz,
                    center_len + engine_block_l/2 - studs(1/2),
                    mount_offset_vert / 2])
                cube([mount_outer_r * 2, mount_outer_r * 2, mount_offset_vert], center = true);

                translate([
                    center_horiz + mount_offset_horiz,
                    center_len + engine_block_l/2 - studs(1/2),
                    mount_offset_vert])
                rotate([90, 0, 0])
                cylinder(h = studs(1), r = mount_outer_r, center = true);

                translate([
                    center_horiz + mount_offset_horiz,
                    center_len + engine_block_l/2 - studs(1/2),
                    mount_offset_vert / 2])
                cube([mount_outer_r * 2, mount_outer_r * 2, mount_offset_vert], center = true);
            }
        }

        translate([
            center_horiz - mount_offset_horiz, 
            center_len - engine_block_l/2 + studs(1/2), 
            mount_offset_vert])
        rotate([90, 0, 0])
        positive_axle_hole(l = studs(1));

        translate([center_horiz + mount_offset_horiz,
            center_len - engine_block_l/2 + studs(1/2), 
            mount_offset_vert])
        rotate([90, 0, 0])
        positive_axle_hole(l = studs(1));

        translate([
            center_horiz - mount_offset_horiz, 
            center_len + engine_block_l/2 - studs(1/2), 
            mount_offset_vert])
        rotate([90, 0, 0])
        positive_axle_hole(l = studs(1));

        translate([center_horiz + mount_offset_horiz,
            center_len + engine_block_l/2 - studs(1/2), 
            mount_offset_vert])
        rotate([90, 0, 0])
        positive_axle_hole(l = studs(1));

        for (i = [0:num_pistons - 1])
        {
            translate([engine_block_w / 2, studs(1) + i * piston_separation, -fudge])
            cylinder(h = engine_block_h + 2*fudge, r = piston_r);
        }

        intrusion = studs(0.9) + fudge;
        translate([0, 0, engine_block_h - intrusion / 2 + fudge])
            linear_extrude(height = intrusion, center = true)
            engine_block_inset();
    }
}

module simple_engine_block_2d()
{
    piston_r = studs(0.6);
    corner_radius = studs(1/2);

    difference()
    {
        offset(r = corner_radius) offset(r = -corner_radius)
        square([engine_block_w, engine_block_l]);
    }
}

module engine_block_inset()
{
    corner_radius = studs(1/2);

    difference()
    {
        // simple_engine_block_2d();
        offset(delta = -wall_thickness) 
        block();
    }

    module block()
    {
        difference ()
        {
            simple_engine_block_2d();
            for (i = [0:num_pistons - 1])
            {
                translate([engine_block_w / 2, studs(1) + i * piston_separation, 0])
                circle(r = piston_r);
            }
        }
    }
}

module positive_axle_hole(l = studs(1))
{
    axle_hole_inner_d = 5.1;
    axle_hole_inner_r = axle_hole_inner_d / 2;
    depth = 0.7;
    width = 0.6;

    union()
    {
        cylinder(h = l + fudge, r = axle_hole_inner_r, center = true);
        translate([0, 0, -l / 2])
        cylinder(h = 2*depth, r = axle_hole_inner_r + width, center = true);
        translate([0, 0, l / 2])
        cylinder(h = 2*depth, r = axle_hole_inner_r + width, center = true);
    }
}

function studs(n) = n * stud_l;

function c_studs(n) = n * stud_l - 2 * stud_clearance;
