`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The College of New Jersey
// Engineer: Hunter Dubel
//
// Create Date: 11/13/2016 08:44:25 PM
// Module Name: chip_io
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
// Description:
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
 
 
module chip_io(clk, clk_out, reset, reset_out, spi_clk, spi_clk_out, spi_en, spi_en_out, miso, miso_out, mosi, mosi_out, gpio_ps, gpio_ts, gpio_dr, gpio_input);

input clk;                                  //Master Clock
input reset;
input spi_clk;                              //SPI Clock
input spi_en;                               //SPI Enable
input miso;                                 //Master In Slave Out
input mosi;                                 //Master Out Slave In
inout [15:0] gpio_input;                           //Input from GPIO
input [15:0] gpio_dr;                              //GPIO DataReg
input [15:0] gpio_ts;                              //GPIO Tristate

output wire clk_out;
output wire reset_out;
output wire spi_clk_out;
output wire spi_en_out;
output wire miso_out;
output wire mosi_out;
output wire [15:0] gpio_ps;

wire [15:0] pinwire;                              //Pinwire that is the output of the mux

assign clk_out = clk;
assign reset_out = reset;
assign spi_clk_out = spi_clk;
assign spi_en_out = spi_en;
assign miso_out = miso;
assign mosi_out = mosi;

assign pinwire = (gpio_ts) ? gpio_dr : 16'bz;       //MUX that controls the value of gpio_ts as either gpio_dr or hi-Z
assign gpio_ps = pinwire;                          //Output of the pinwire to gpio
assign gpio_input = pinwire;

endmodule