module line_animation(clk, reset, x0, x1, y0, y1);
	input logic clk, reset;
	output logic [9:0] x0, x1;
	output logic [8:0] y0, y1;
	
	logic [9:0] x_moveTo, y_moveTo;
	logic [25:0] counter;

	
	always_ff @(posedge clk or posedge reset) begin
		if(reset) begin
			counter <= 0;
		end 
		
		else begin
			counter <= counter + 1;
			if(counter == 5000000) begin
				counter <= 0;
			end
		end
	end
	
	assign x0 = 50;
	assign y0 = 100;
	assign x1 = 100 % 640;
	assign y1 = 480;
	
endmodule 
