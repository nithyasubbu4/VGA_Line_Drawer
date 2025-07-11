//Nithya Subramanian
//Feburary 9th 2025
//EE 371
//Lab 3, Task 1 and 2

//This module line_drawer has input signals clk and reset which are 1-bit inputs
//as well as two coordinates x and y that are 10 and 9 bit inputs(respectivley) 
//x0, x1, y0, y1 are the start and end coordinates of the line. This module
//outputs 2 signals- x (10 bit) and y (9 bit) which correspond to the coordinate
//pair (x, y). This module given these inputs will use the Bresenham's line algo
//to draw a line between the two sets of input coordinates given (x0, x1, y0, y1).
//The module will use a certain amount of clock cyles(dependednt on length of line)
//as each clock cyle as one pixel is drawn.
module line_drawer(
	input logic clk, reset,
	
	// x and y coordinates for the start and end points of the line
	input logic [9:0]	x0, x1, 
	input logic [8:0] y0, y1,

	//outputs cooresponding to the coordinate pair (x, y)
	output logic [9:0] x,
	output logic [8:0] y 
	);
	
	//internal registers
	logic is_steep;
	logic signed [10:0] delta_x;
	logic signed [9:0] delta_y;
	
	logic signed [11:0] error;
	
	logic signed [10:0] x_start, x_end;
	logic signed [9:0] y_start, y_end;
	
	integer x_step, y_step;
	
	//Registers that help with iteration
	logic [9:0] x_curr;
	logic [8:0] y_curr;
	
	//finds the gap between the x and y coordinates and
	//uses that to find if the line is steep
	assign delta_x = (x0 > x1) ? (x0 - x1) : (x1 - x0);
	assign delta_y = (y0 > y1) ? (y0 - y1) : (y1 - y0);
	assign is_steep = (delta_y > delta_x) ? 1'b1 : 1'b0;
	
	always_comb begin
		
		//if steep start with moving from the smaller y value
		if(is_steep) begin
			x_start = (y0 <= y1) ? x0 : x1;
			y_start = (y0 <= y1) ? y0 : y1;
			x_end = (y0 > y1) ? x0 : x1;
			y_end = (y0 > y1) ? y0 : y1;
		end
		
		//if not steep start on smaller x
		else begin
			x_start = (x0 <= x1) ? x0 : x1;
			y_start = (x0 <= x1) ? y0 : y1;
			x_end = (x0 > x1) ? x0 : x1;
			y_end = (x0 > x1) ? y0 : y1;
		end
	end
	
	//to see if the line has positive or negative slope
	assign y_step = (y_end > y_start) ? 1 : -1;
	assign x_step = (x_end > x_start) ? 1 : -1;
	
	//logic for how the line is drawn depending on if the line is steep
	//or gradual. If the line is steep it is drawn by increasing the y 
	//coordinate by one and the x by x_step, if it is not it is drawn by 
	//increasing the x by one and y by y_step
	always_ff @(posedge clk) begin
		
		if(reset) begin 
			x <= x_start;
			y <= y_start;
			
			error <= (is_steep) ? -delta_y / 2 : -delta_x / 2;
		end
		
		//if line is step it increases y by one
		else if ((is_steep == 1) & (y != y_end)) begin
			y <= y + 1;
			
			if((error + delta_x) >= 0) begin
				x <= x + x_step;
				error <= error + (delta_x - delta_y);
			end 
			
			else 
				error <= error + delta_x;
		end
		
		//if line is gradual it increases x by one
		else if (x != x_end) begin
			x <= x + 1;
			
			if((error + delta_y) >= 0) begin
				y <= y + y_step;
				error <= error + (delta_y - delta_x);
			end
			
			else
				error <= error + delta_y;
		end
	end
endmodule

//testbench of line_drawer module that simulates/tests all scenarios for this module
module line_drawer_testbench();
	logic clk, reset;
	logic [9:0]	x0, x1; 
	logic [8:0] y0, y1;
	logic [9:0] x;
	logic [8:0] y;
	
	line_drawer dut (.clk(clk), .reset(reset), .x0(x0), .x1(x1), .y0(y0), .y1(y1), .x(x), .y(y));
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		//draws a horizontal line from x = 0 to x = 15
		reset <= 1; x0 <= 0; y0 <= 3; x1 <= 15; y1 <= 3; repeat(2) @(posedge clk);
		reset <= 0; repeat(20) @(posedge clk);
		
		//draws a vertical line from y = 0 to y = 15
		reset <= 1; x0 <= 3; y0 <= 0; x1 <= 3; y1 <= 15; repeat(2) @(posedge clk);
		reset <= 0; x0 <= 3; y0 <= 0; x1 <= 3; y1 <= 15; repeat(10) @(posedge clk);
		
		//draws a diagonal line starting from origin with positive slope
		reset <= 1; x0 <= 0; y0 <= 0; x1 <= 15; y1 <= 15; repeat(2) @(posedge clk);
		reset <= 0; x0 <= 0; y0 <= 0; x1 <= 15; y1 <= 15; repeat(10) @(posedge clk);
		
		//draws a diagonal line starting from y axis with positive steep slope
		reset <= 1; x0 <= 0; y0 <= 3; x1 <= 11; y1 <= 18; repeat(2) @(posedge clk);
		reset <= 0; x0 <= 0; y0 <= 3; x1 <= 11; y1 <= 18; repeat(10) @(posedge clk);
		
		//draws a diagonal starting from y axis with negative steep slope
		reset <= 1; x0 <= 0; y0 <= 27; x1 <= 7; y1 <= 3; repeat(2) @(posedge clk);
		reset <= 0;	x0 <= 0; y0 <= 27; x1 <= 7; y1 <= 3; repeat(10) @(posedge clk);
		
		//draws a line with a positive gradual slope
		reset <= 1; x0 <= 1; y0 <= 0; x1 <= 27; y1 <= 9; repeat(2) @(posedge clk);
		reset <= 0; x0 <= 1; y0 <= 0; x1 <= 27; y1 <= 9; repeat(10) @(posedge clk);

		//draws a line with a negative gradual slope		
		reset <= 1; x0 <= 1; y0 <= 9; x1 <= 27; y1 <= 0; repeat(2) @(posedge clk);
		reset <= 0; x0 <= 0; y0 <= 3; x1 <= 15; y1 <= 3; repeat(10) @(posedge clk);
		$stop;
	end
endmodule 