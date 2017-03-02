`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:45:22 02/06/2017
// Design Name:   timing
// Module Name:   C:/Users/Hunter/Reg_ISE/timing_test.v
// Project Name:  Reg_ISE
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

module timing_test;

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
		// Initialize Inputs
		clk = 0;
		reset = 0;
		ro_trig_start = 0;
		ro_trig_halt = 0;
		ro_mode = 0;
		ro_termcount = 0;

		// Wait 100 ns for global reset to finish
		#100;
		ro_mode = 1'b1;
		ro_termcount = 10;
		
		#5;
		ro_trig_start = 1'b1;
        
        #5;
        ro_trig_start = 1'b0;
		// Add stimulus here

	end
	
	always
	   #5 clk = !clk;
endmodule

