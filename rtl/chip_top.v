`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// The College of New Jersey
// Engineer: Richard Levenson
//
// Create Date: 02/11/2017 02:53:48 PM
// Module Name: chip_top
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
//////////////////////////////////////////////////////////////////////////////////

module chip_top(
        input clk,
        input reset,
        output spi_clk_out, 
        output spi_en_out, 
        input miso,
        output mosi_out,
        inout [15:0] gpio_input
);

wire clk_out;
wire clk_div2;
//wire spi_clk_out;
wire spi_clk;
wire spi_en;
wire miso_out;
//wire mosi_out;
wire mosi;
wire [15:0] gpio_ps;
wire [15:0] gpio_ts;
wire [15:0] gpio_dr;

clk_div clk_div
  (
 // Clock in ports
  .clk_in1(clk),
  // Clock out ports  
  .clk_out1(clk_div2),
  // Status and control signals               
  .reset(~reset) 
  );

chip_io chip_io(
            .clk(clk_div2),
            .clk_out(clk_out),
            .reset(reset),
            .reset_out(reset_out),
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

chip chip(
            .clk(clk_out),
            .reset(reset_out),
            .miso(miso_out),
            .ss(spi_en),
            .mosi(mosi),
            .spi_clk(spi_clk),
            .ro_gpio_pinstate(gpio_ps),
            .rf_gpio_datareg(gpio_dr),
            .rf_gpio_tristate(gpio_ts)
);

endmodule
