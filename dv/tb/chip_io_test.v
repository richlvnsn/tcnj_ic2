`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:17:17 11/29/2016
// Design Name:   chip_io
// Module Name:   C:/Users/Hunter/Documents/GitHub/tcnj_ic2/dv/tb/chip_io_test.v
// Project Name:  chip_io
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: chip_io
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module chip_io_test;

	// Inputs
	reg clk;
	reg spi_clk;
	reg spi_en;
	reg miso;
	reg mosi;
	reg [15:0] gpio_ts;
	reg [15:0] gpio_dr;
	reg [15:0] gpio_input;

	// Outputs
	wire clk_out;
	wire spi_clk_out;
	wire spi_en_out;
	wire miso_out;
	wire mosi_out;
	wire [15:0] gpio_ps;

	// Instantiate the Unit Under Test (UUT)
	chip_io uut (
		.clk(clk), 
		.clk_out(clk_out), 
		.spi_clk(spi_clk), 
		.spi_clk_out(spi_clk_out), 
		.spi_en(spi_en), 
		.spi_en_out(spi_en_out), 
		.miso(miso), 
		.miso_out(miso_out), 
		.mosi(mosi), 
		.mosi_out(mosi_out), 
		.gpio_ps(gpio_ps), 
		.gpio_ts(gpio_ts), 
		.gpio_dr(gpio_dr), 
		.gpio_input(gpio_input)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		spi_clk = 0;
		spi_en = 0;
		miso = 0;
		mosi = 0;
		gpio_ts = 0;
		gpio_dr = 0;
		gpio_input = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#25;
		spi_clk = 1;
		#25;
		spi_en = 1;
		#25;
		miso = 1;
		#25;
		mosi = 1;
		#25;
		gpio_ts = 1;
		#25;
		gpio_dr = 1;
		#25;
		gpio_input = 1;
		#50;
		gpio_dr = 0;
		#50;
		gpio_ts = 0;
		

	end
	
	always
	#5 clk = !clk;
      
endmodule

