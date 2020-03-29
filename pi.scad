chars = "ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ALATOO ";
spirals = 8;
petals_per_spiral = 6; 
scaling_factor = 15;
thread_height = 40;
error = 0.01;
scale_flower = 0.3;
PI = 3.14159;
chars_per_circle = 40;
radius = 70;
step_angle = 360 / chars_per_circle;
circumference = 2 * PI * radius;
char_size = circumference / chars_per_circle+2;
z_offset_per_char = char_size / 40;
char_thickness = 5;
line_thickness = char_size / 8;
line_angle_offset = -atan((char_size - line_thickness)/circumference);
difference(){
    cylinder(h=5,r=radius+12);
    translate([0,0,-1])
    cylinder(h=7,r=10);
}





function fibonacci(n) = 
    n == 0 || n == 1 ? n : (
	    fibonacci(n - 1) + fibonacci(n - 2)
	);
	
	
module petal(radius, thickness) {
    $fn = 24;
	translate([-radius * 1.5, 0, radius * 2]) rotate([90, 120, 90]) intersection() {
		difference() {
			sphere(radius * 2);
			sphere(radius * 2 - thickness);
		}

		linear_extrude(radius * 5) hull() {
			translate([radius * 1.25, 0, 0]) circle(radius / 3);
			translate([-1.1 * radius, 0, 0]) circle(radius / 3);
			circle(radius * 0.85);
		}
	}
}
	
module golden_spiral_for_pentals(from, to) {
    if(from <= to) {
		f1 = fibonacci(from);
		f2 = fibonacci(from + 1);
		
		offset = f1 - f2;

		translate([0, 0, offset * 1.8]) rotate([-5, 40, 10])
		    petal(-offset, -offset / 6);

		translate([0, offset, 0]) rotate(90) 
			golden_spiral_for_pentals(from + 1, to);

	}
}


include <threads.scad>;
radius_lotus = scaling_factor*(fibonacci(petals_per_spiral+1) - fibonacci(petals_per_spiral));


rotate([0,90,0])
translate([0,0,radius+thread_height*scale_flower/2])
scale(scale_flower)
translate([200,0,0])difference () {
   cylinder (d=radius_lotus+6+error, h=thread_height/2);
    translate([0,0,-1])
   metric_thread (diameter=radius_lotus+error, pitch=6, length=thread_height/2+6, internal=true);
};
rotate([0,90,0])
translate([0,0,-(radius+thread_height*scale_flower/2+7)])
scale(scale_flower)
translate([200,0,0])difference () {
   cylinder (d=radius_lotus+6+error, h=thread_height/2);
    translate([0,0,-1])
   metric_thread (diameter=radius_lotus+error, pitch=6, length=thread_height/2+6, internal=true);
};
difference(){
    difference(){
        
        
        translate([0,0,10])
        for(i = [0 : len(chars) - 1]) {
            rotate(i * step_angle) 
                translate([0, radius + char_size / 2, -z_offset_per_char * i]) 
                    rotate([90, 0, 180]) linear_extrude(char_thickness) union() {
                        text(
                            chars[i], 
                            font = "Courier New; Style = Bold", 
                            size = char_size, 
                            valign = "center", halign = "center"
                        );
                        rotate([0, 0, line_angle_offset]) translate([0, char_size / 2, 0])
                            square([char_size * 1.106, line_thickness], center = true);
                    }
        };
        translate([0,0,4])
        cylinder(h=20,r=radius+20);
    }

    rotate([0,90,0])
    translate([0,0,radius+thread_height*scale_flower/2])
    scale(scale_flower)
    translate([200,0,0])
       cylinder (d=radius_lotus+6+error, h=thread_height/2);
    rotate([0,90,0])
translate([0,0,-(radius+thread_height*scale_flower/2+7)])
scale(scale_flower)
translate([200,0,2])
   cylinder (d=radius_lotus+6+error, h=thread_height/2);
    


}

