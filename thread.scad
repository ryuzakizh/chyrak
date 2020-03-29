spirals = 8;
petals_per_spiral = 6; 
scaling_factor = 10;
thread_height = 100;
error = 0.01;
function fibonacci(n) = 
    n == 0 || n == 1 ? n : (
	    fibonacci(n - 1) + fibonacci(n - 2)
	);
	
include <threads.scad>;
radius_lotus = scaling_factor*(fibonacci(petals_per_spiral+1) - fibonacci(petals_per_spiral));

difference () {
   cylinder (d=radius_lotus+6+error, h=thread_height/2);
   metric_thread (diameter=radius_lotus+error, pitch=6, length=thread_height/2+4, internal=true);
}