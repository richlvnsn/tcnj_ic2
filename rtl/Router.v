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
    imem_hready, imem_hresp, dmem_hready, dmem_hresp, imem_hrdata, dmem_hrdata, imem_haddr, imem_hwrite, imem_hsize, imem_hburst, imem_hmastlock, imem_hprot, imem_htrans, dmem_haddr, dmem_hwrite, dmem_hsize, dmem_hburst, dmem_hmastlock, dmem_hprot, dmem_htrans, imem_hwdata, dmem_hwdata,
    // Register IOs
    reg_read, reg_write, reg_addr, reg_wben, reg_rwn,
    // RAM IOs
    inst_read, data_read, inst_write, data_write, inst_addr, data_addr, inst_rwn, data_rwn
);

input clk;

//SPI Loader IOs
input [31:0] spi_haddr, spi_hwdata;
input [3:0] spi_hprot;
input [2:0] spi_hsize, spi_hburst;
input [1:0] spi_htrans;
input spi_hwrite, spi_hmastlock;

output [31:0] spi_hrdata;
output spi_hready, spi_hrest;

// RISC-V Core IOs
input [31:0] imem_haddr, dmem_haddr, imem_hwdata, dmem_hwdata;
input [3:0] imem_hprot, dmem_hprot;
input [2:0] imem_hsize, dmem_hsize, imem_hburst, dmem_hburst;
input [1:0] imem_htrans, dmem_htrans;
input imem_hwrite, dmem_hwrite, imem_hmastlock, dmem_hmastlock;

output [31:0] imem_hrdata, dmem_hrdata;
output imem_hready, dmem_hready, imem_hresp, dmem_hresp;

// Register IOs
input [31:0] reg_read;

output [31:0] reg_write;
output [3:0] reg_addr, reg_wben;
output reg_rwn;

// RAM IOs
input [31:0] inst_read, data_read;

output [31:0] inst_write, data_write;
output [13:0] inst_addr, data_addr;
output inst_rwn, data_rwn;

endmodule

