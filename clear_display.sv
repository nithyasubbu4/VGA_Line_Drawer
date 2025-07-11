//Nithya Subramanian
//Feburary 9th 2025
//EE 371
//Lab 3, Task 2

//clear_display takes in 1-bit valyes clear, clk. inProgress output
// tells the mdoule if the display needs to be cleared inProgress
//tells the module if a draw is still in progress and so the clear
//needs to happen and then a cycle of the same coordinates occur 
//which is the output value resetDraw, the x output ist the coordinate
//that the dispaly is on. 
module clear_display (clear, clk, inProgress, resetDraw, x);
    input logic clear, clk;
    output logic [9:0] x;
    output logic inProgress;
    output logic resetDraw;
    
	 integer counter;
    logic enable;
    
	 //uses the enable and counter signals to decide what action
	 //the user wants us to take. counter is used to slow down the
	 //actions and increments occuring
    always_ff @(posedge clk) begin
		if (inProgress) begin
			if (clear) begin
				counter <= 0;
            enable <= 1'b0;
            resetDraw <= 1'b1;
          end
            
          else if (counter == 5) begin
                counter <= counter + 1;
                resetDraw <= 1'b0;
          end
            
          else if (counter == 350) begin
                counter <= 0;
                enable <= 1'b1;
                resetDraw <= 1'b1;
          end
          
			 else begin
                counter <= counter + 1;
                enable <= 1'b0;
          end
		end 
			
		else begin
			resetDraw <= 1'b0;  // End drawing when x reaches 641
		end
	end
		
		//if the clear is on the x coordinate should reset to 0 while
		//the inProgress coordinate should be 1 since a reset is happneing
		//but if not the x should increment by 1 unless it gets to the last
		//index then the clear has completed. 
		always_ff @(posedge clk) begin
			if(clear) begin
				x <= 0;
				inProgress <= 1'b1;
			end
			
			else if (enable & x < 641) begin
				x <= x + 1;
			end
			
			else if (x == 641) begin
				inProgress <= 1'b0;
			end
		end
endmodule 

//a testbench for clear_display that simulates/test all situations in that testbench
module clear_display_testbench();
	logic clear, clk;
   logic [9:0] x;
   logic inProgress;
   logic resetDraw;	
	
	clear_display dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin 
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin 
		clear <= 1; 		repeat(5)      @(posedge clk);
		clear <= 0; 		repeat(500000) @(posedge clk);
		clear <= 1; 		repeat(5)      @(posedge clk);
		clear <= 0; 		repeat(500000) @(posedge clk);
		$stop;
	end
endmodule
