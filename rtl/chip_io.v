`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The College of New Jersey
// Engineer: Hunter Dubel
//
// Create Date: 10/09/2016 08:44:25 PM
// Module Name: register
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
// Description:
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
 
 
module chip_io(clk, clk_out, spi_clk, spi_clk_out, spi_en, spi_en_out, miso, miso_out, mosi, mosi_out, gpio_ps, gpio_ts, gpio_dr, gpio_input);

input clk;                                  //Master Clock
input spi_clk;                              //SPI Clock
input spi_en;                               //SPI Enable
input miso;                                 //
input mosi;                                 //
input [15:0] gpio_input;                           //Input from GPIO
input [15:0] gpio_dr;                              //GPIO DataReg
input [15:0] gpio_ts;                              //GPIO Tristate

output wire clk_out;                        
output wire spi_clk_out;
output wire spi_en_out;
output wire miso_out;
output wire mosi_out;
output wire [15:0] gpio_ps;

wire pinwire;

assign clk_out = clk;
assign spi_clk_out = spi_clk;
assign spi_en_out = spi_en;
assign miso_out = miso;
assign mosi_out = mosi;

assign pinwire = (gpio_ts) ? gpio_dr : 1'bz;
assign gpio_ps = pinwire;

endmodule