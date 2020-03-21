spirals = 8;
petals_per_spiral = 6; 
scaling_factor = 10;
thread_height = 100;
error = 0.01;
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

module lotus(spirals, petals_per_spiral) {
    $fn = 24;

    step_angle = 360 / spirals;
	for(i = [0:spirals - 1]) {
		rotate(step_angle * i) 
		    golden_spiral_for_pentals(1, petals_per_spiral);
	}

	fib_diff = fibonacci(petals_per_spiral) - fibonacci(petals_per_spiral - 1);


	translate([0, 0, -fib_diff]) scale([1, 1, fib_diff]) sphere(1);
	translate([0, 0, -fib_diff * 2.25]) difference() {
		sphere(fib_diff);
		translate([-fib_diff, -fib_diff, -fib_diff * 2]) cube(fib_diff * 2);
	}
}
include <threads.scad>;
radius_lotus = scaling_factor*(fibonacci(petals_per_spiral+1) - fibonacci(petals_per_spiral));
union(){
    scale(scaling_factor)
    translate([0,0,11.3])
    lotus(spirals, petals_per_spiral + 1);
    translate([0,0,-thread_height])
    metric_thread(diameter=radius_lotus+error,pitch=6,length=thread_height);
}

translate([200,0,0])difference () {
   cylinder (d=radius_lotus+6+error, h=thread_height/2);
   metric_thread (diameter=radius_lotus+error, pitch=6, length=thread_height/2+4, internal=true);
}