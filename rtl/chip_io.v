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

assign pinwire[0] = (gpio_ts[0]) ? gpio_dr[0] : 1'bz;       //MUX that controls the value of gpio_ts as either gpio_dr or hi-Z
assign pinwire[1] = (gpio_ts[1]) ? gpio_dr[1] : 1'bz;
assign pinwire[2] = (gpio_ts[2]) ? gpio_dr[2] : 1'bz;
assign pinwire[3] = (gpio_ts[3]) ? gpio_dr[3] : 1'bz;
assign pinwire[4] = (gpio_ts[4]) ? gpio_dr[4] : 1'bz;
assign pinwire[5] = (gpio_ts[5]) ? gpio_dr[5] : 1'bz;
assign pinwire[6] = (gpio_ts[6]) ? gpio_dr[6] : 1'bz;
assign pinwire[7] = (gpio_ts[7]) ? gpio_dr[7] : 1'bz;
assign pinwire[8] = (gpio_ts[8]) ? gpio_dr[8] : 1'bz;
assign pinwire[9] = (gpio_ts[9]) ? gpio_dr[9] : 1'bz;
assign pinwire[10] = (gpio_ts[10]) ? gpio_dr[10] : 1'bz;
assign pinwire[11] = (gpio_ts[11]) ? gpio_dr[11] : 1'bz;
assign pinwire[12] = (gpio_ts[12]) ? gpio_dr[12] : 1'bz;
assign pinwire[13] = (gpio_ts[13]) ? gpio_dr[13] : 1'bz;
assign pinwire[14] = (gpio_ts[14]) ? gpio_dr[14] : 1'bz;
assign pinwire[15] = (gpio_ts[15]) ? gpio_dr[15] : 1'bz;
assign gpio_ps = pinwire;                          //Output of the pinwire to gpio
assign gpio_input = pinwire;

endmodule