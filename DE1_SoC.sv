//Nithya Subramanian
//Feburary 9th 2025
//EE 371
//Lab 3, Task 2

//DE1_SoC is the top level module of this project and it initilizes 
//VGA_frambuffer and line_drawer module to draw any line from point x
//to point y on a VGA display. 
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = SW;
	
	logic [9:0] x0, x1, x, clear_all;
	logic [8:0] y0, y1, y;
	logic frame_start;
	logic pixel_color;
	
	logic drawNow;
	assign drawNow = SW[9];

	
	
	//////// DOUBLE_FRAME_BUFFER ////////
	logic dfb_en;
	assign dfb_en = 1'b0;
	/////////////////////////////////////
	
	
	logic rst_clear, rst_animate;
	logic	inProgress, clr_draw;

	button_press button (.A(~KEY[3]), .out(clr_draw), .clk(CLOCK_50));
	
	clear_display clearDraw (.clear(clr_draw), .clk(CLOCK_50), .inProgress(inProgress), .resetDraw(rst_clear), .x(clear_all));

	//A bus that holds all coordinates for each variable
	logic [9:0] x0_base, x1_base;
	logic [8:0] y0_base, y1_base;
	 

	 // Assigns what action should be completed based on the values
	assign x0_base = inProgress ? clear_all : x0;
	assign y0_base = inProgress ? 0 : y0;
	assign x1_base = inProgress ? clear_all : x1;
	assign y1_base = inProgress ? 480 : y1;
	
	assign pixel_color = inProgress ? 1'b0 : 1'b1;

	//creates a RAM that holds points needed to draw 
	logic [9:0] x0_points [0:5];
	logic [8:0] y0_points [0:5];
	logic [9:0] x1_points [0:5];
	logic [8:0] y1_points [0:5];
	 
	assign x0_points[0] = 240;
	assign x0_points[1] = 340;
	assign x0_points[2] = 340;
	assign x0_points[3] = 240;
	assign x0_points[4] = 240;
	assign x0_points[5] = 290;
	
	assign y0_points[0] = 340;
	assign y0_points[1] = 340;
	assign y0_points[2] = 240;
	assign y0_points[3] = 240;
	assign y0_points[4] = 290;
	assign y0_points[5] = 340;
	
	assign x1_points[0] = 240;
	assign x1_points[1] = 240;
	assign x1_points[2] = 180;
	assign x1_points[3] = 180;
	assign x1_points[4] = 240;
	assign x1_points[5] = 350;
	
	assign y1_points[0] = 240;
	assign y1_points[1] = 180;
	assign y1_points[2] = 180;
	assign y1_points[3] = 240;
	assign y1_points[4] = 350;
	assign y1_points[5] = 240;
   
	//initilizes VGA_framebuffer
	VGA_framebuffer fb(
	  .clk(CLOCK_50), .rst(1'b0), .x, .y,
	  .pixel_color, .pixel_write(1'b1), .dfb_en(), .frame_start,
	  .VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS,
	  .VGA_BLANK_N, .VGA_SYNC_N);

	//initilizes line_drawer
	line_drawer lines (
	  .clk(CLOCK_50), 
	  .reset(rst_clear | rst_animate),
	  .x0(x0_base), .y0(y0_base), .x1(x1_base), .y1(y1_base), .x, .y);

	integer counter, index;

	//uses different signals to find whether the machine should draw, clear ect. it also uses
	//a counter to slow down the time taken to update the machine
	always_ff @(posedge CLOCK_50) begin
		if (clr_draw) begin
			counter <= 0;
			index <= 0;
			x0 <= 0;
         y0 <= 0;
         x1 <= 0;
         y1 <= 0;
		end
		
      else if (counter == 1) begin
			counter <= counter + 1;
         rst_animate <= 1'b1;
      end
      
		else if (counter == 5) begin
         counter <= counter + 1;
         rst_animate <= 1'b0;
      end
            
		else if (counter == (50000000 / 2)) begin
			counter <= 0;
         
			if (index < 5) begin
				index <= index + 1;
			end
					
			else begin
				index <= 0;
			end 
				
				x0 <= x0_points[index];
				y0 <= y0_points[index];
				x1 <= x1_points[index];
				y1 <= y1_points[index];
      end	
		
		else if (drawNow) begin
			counter <= counter + 1;
		end
	end
endmodule
    

//a testbench for DE1_SoC that simulates/test all situations in that testbench
module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;

	logic CLOCK_50;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .CLOCK_50, 
	.VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	
	logic reset;
	assign KEY[3] = ~reset;
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		CLOCK_50 <= 100;
		forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
		//check line when reset is on and SW[9] is 0 (black)
		reset <= 1; SW[9] <= 0; repeat (10) @(posedge CLOCK_50);
		
		//check line drawing when reset off and SW[9] is 1 (white)
		reset <= 0; SW[9] <= 1; repeat (100) @(posedge CLOCK_50);
	
		$stop;
	end
endmodule
	
