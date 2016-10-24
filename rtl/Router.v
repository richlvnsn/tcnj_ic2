`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2016 07:45:40 PM
// Design Name: 
// Module Name: Router
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Router(
    clk,
    // SPI Loader IOs
    spi_hready, spi_hrest, spi_hrdata, spi_haddr, spi_hwrite, spi_hsize, spi_hburst, spi_hmastlock, spi_hprot, spi_htrans, spi_hwdata,
    // RISC-V Core IOs
    // Register IOs
    // RAM IOs
);

input clk;

//SPI Loader IOs
input [31:0] spi_haddr;
input [31:0] spi_hwdata;
input [3:0] spi_hprot;
input [2:0] spi_hsize;
input [2:0] spi_hburst;
input [1:0] spi_htrans;
input spi_hwrite;
input spi_hmastlock;

output [31:0] spi_hrdata;
output spi_hready;
output spi_hrest;

// RISC-V Core IOs
// Register IOs
// RAM IOs

endmodule

