`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:44:56 11/03/2016
// Design Name:   register
// Module Name:   C:/Xilinx/RegisterISE/register_test.v
// Project Name:  RegisterISE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: register
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module register_test;

	// Inputs
	reg clk;
	reg reset;
	reg [4:2] addr;
	reg [3:0] wben;
	reg r_wn;
	reg [31:0] wdata;
	reg [15:0] ro_gpio_pinstate;

	// Outputs
	wire [31:0] rdata;
	wire [15:0] rf_gpio_datareg;
	wire [15:0] rf_gpio_tristate;
	wire [15:0] rf_gpio_interrupt_mask;

	// Instantiate the Unit Under Test (UUT)
	register uut (
		.clk(clk), 
		.reset(reset), 
		.addr(addr), 
		.wben(wben), 
		.r_wn(r_wn), 
		.wdata(wdata), 
		.ro_gpio_pinstate(ro_gpio_pinstate), 
		.rdata(rdata), 
		.rf_gpio_datareg(rf_gpio_datareg), 
		.rf_gpio_tristate(rf_gpio_tristate), 
		.rf_gpio_interrupt_mask(rf_gpio_interrupt_mask)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		addr = 0;
		wben = 0;
		r_wn = 0;
		wdata = 0;
		ro_gpio_pinstate = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

