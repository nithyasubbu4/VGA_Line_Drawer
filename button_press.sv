//Nithya Subramanian
//Feburary 9th 2025
//EE 371
//Lab 3, Task 2

//button_press is to ensure that a users button value is 
//not overlooked or missed. Takes in button input value A
// and clk and outputs with 1-bit signal out. 
module button_press (A, out, clk);
	input logic A, clk;
	output logic out;
	
	logic buttonValue, inputValue;
	
	// put the input logic through 2 D_FFs to clean up
	always_ff @(posedge clk) begin
		buttonValue <= A;
		inputValue <= buttonValue;
	end
	
	enum {noPress, holdPress} ps, ns;
	
	//if a button is pressed the value is held until the 
	//the button is realeased
	always_comb begin
		case(ps)
			noPress: 
				if (inputValue) 
					ns = holdPress;
				
				else 
					ns = noPress;
			
			holdPress: 
				if (inputValue) 
					ns = holdPress;
				else 
					ns = noPress;
		endcase
	end
	
	// Combinatinal logic that figures out what the output value 
	//should be based on the state it is in
	always_comb begin
		case (ps)
			noPress: 
				if (inputValue) 
					out = 1'b1;
				
				else 
					out = 1'b0;
			
			holdPress: 
				out = 1'b0;
		endcase
	end
	
	// Tells the machine what state to go to after present
	always_ff @(posedge clk) begin
			ps <= ns;
	end
endmodule 

//a testbench for button_press that simulates/test all situations in that testbench
module button_press_testbench();
	logic A, clk, out;
	logic CLOCK_50;
	
	button_press dut (.A(A), .clk(CLOCK_50), .out(out));
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
	
		//simulate random times of button presses
		A <= 0; repeat(7); @(posedge CLOCK_50);
		A <= 1; repeat(3) @(posedge CLOCK_50);
		A <= 0; repeat(5) @(posedge CLOCK_50);
		A <= 1; repeat(1) @(posedge CLOCK_50);
		A <= 0; repeat(6) @(posedge CLOCK_50);
		A <= 1; repeat(4) @(posedge CLOCK_50);
		A <= 0; repeat(2) @(posedge CLOCK_50);
		$stop;
	end
endmodule 