`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:23:22 02/26/2017
// Design Name:   timer_verification
// Project Name:  
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: timing
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module timer_verification;

	// Inputs
	reg clk;
	reg reset;
	reg ro_trig_start;
	reg ro_trig_halt;
	reg ro_mode;
	reg [31:0] ro_termcount;

	// Outputs
	wire rf_status;
	wire [31:0] rf_currcount;
	wire rf_int;

	//Expected solutions from file
	reg ex_status;
	reg [31:0] ex_currcount;
	reg ex_int;

	reg [31:0] vectornum, errors;
	reg [3:0] testvectors[12:0];

	// Instantiate the Unit Under Test (UUT)
	timing uut (
		.clk(clk), 
		.reset(reset), 
		.ro_trig_start(ro_trig_start), 
		.ro_trig_halt(ro_trig_halt), 
		.ro_mode(ro_mode), 
		.ro_termcount(ro_termcount), 
		.rf_status(rf_status), 
		.rf_currcount(rf_currcount), 
		.rf_int(rf_int)
	);

	initial begin
		$readmemb("timer.tv", testvectors); //Read vectors in hex
		vectornum = 0; errors = 0;	//Initialize
		reset = 1; #27; reset = 0; 	//Apply reset wait
	end

	always @(posedge clk)
		begin
			#1; {ro_trig_start, ro_trig_halt, ro_mode, ro_termcount, ex_status, ex_currcount, ex_int} = testvectors[vectornum];
		end

	always @(negedge clk)	//Verifies that the output are matching the requested input.
		if (~reset)
		begin
			if (rf_status != ex_status)
			begin
				$display("Error: inputs = %b", {ro_trig_start, ro_trig_halt, ro_mode, ro_termcount, ex_status, ex_currcount, ex_int});
				$display("	outputs = %b (%b exp)", rf_status, ex_status);
				errors = errors + 1;
			end
			if (rf_currcount != ex_currcount)
			begin
				$display("Error: inputs = %b", {ro_trig_start, ro_trig_halt, ro_mode, ro_termcount, ex_status, ex_currcount, ex_int});
				$display("	outputs = %b (%b exp)", rf_currcount, ex_currcount);
				errors = errors + 1;
			end
			if (rf_int != rf_int)
			begin
				$display("Error: inputs = %b", {ro_trig_start, ro_trig_halt, ro_mode, ro_termcount, ex_status, ex_currcount, ex_int});
				$display("	outputs = %b (%b exp)", rf_int, ex_int
					);
				errors = errors + 1;
			end

			vectornum = vectornum + 1;
			if (testvectors[vectornum] == 4'bx)
			begin
				$display("%d tests compelted with %d errors", vectornum, errors);
				$finish;	//End simulation
			end
		end

	always
	   #5 clk = !clk;

endmodule

