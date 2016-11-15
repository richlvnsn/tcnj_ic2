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
    clk, reset, SPI_change,
    // SPI Loader IOs
    spi_hready, spi_hrest, spi_hrdata, spi_haddr, spi_hwrite, spi_hsize, spi_hburst, spi_hmastlock, spi_hprot, spi_htrans, spi_hwdata,
    // RISC-V Core IOs (Instruction Memory)
    imem_hready, imem_hresp, imem_hrdata, imem_haddr, imem_hwrite, imem_hsize, imem_hburst, imem_hmastlock, imem_hprot, imem_htrans, imem_hwdata,
    // RISC-V Core IOs (Data Memory)
    dmem_hready, dmem_hresp, dmem_hrdata, dmem_haddr, dmem_hwrite, dmem_hsize, dmem_hburst, dmem_hmastlock, dmem_hprot, dmem_htrans, dmem_hwdata,
    // Register IOs
    reg_read, reg_write, reg_addr, reg_wben, reg_rwn,
    // RAM IOs (Instruction Memory)
    inst_read, inst_write, inst_addr, inst_rwn,
    // RAM IOs (Data Memory)
    data_read, data_write, data_addr, data_rwn
);

input clk, reset, SPI_change;

// SPI Loader IOs
input [31:0] spi_haddr, spi_hwdata;
input [3:0] spi_hprot;
input [2:0] spi_hsize, spi_hburst;
input [1:0] spi_htrans;
input spi_hwrite, spi_hmastlock;

output [31:0] spi_hrdata;
output spi_hready, spi_hrest;

reg spi_hready;

// RISC-V Core IOs (Instruction Memory)
input [31:0] imem_haddr, imem_hwdata;
input [3:0] imem_hprot;
input [2:0] imem_hsize, imem_hburst;
input [1:0] imem_htrans;
input imem_hwrite, imem_hmastlock;

output [31:0] imem_hrdata;
output imem_hready, imem_hresp;

reg [31:0] imem_hrdata;
reg imem_hready, imem_hresp;

// RISC-V Core IOs (Data Memory)
input [31:0] dmem_haddr, dmem_hwdata;
input [3:0] dmem_hprot;
input [2:0] dmem_hsize, dmem_hburst;
input [1:0] dmem_htrans;
input dmem_hwrite, dmem_hmastlock;

output [31:0] dmem_hrdata;
output dmem_hready, dmem_hresp;

reg [31:0] dmem_hrdata;
reg dmem_hready, dmem_hresp;

// Register IOs
input [31:0] reg_read;

output [31:0] reg_write;
output [3:0] reg_addr, reg_wben;
output reg_rwn;

reg [31:0] reg_write;
reg [3:0] reg_addr, reg_wben;
reg reg_rwn;

// RAM IOs (Instruction Memory)
input [31:0] inst_read;

output [31:0] inst_write;
output [13:0] inst_addr;
output inst_rwn;

reg [31:0] inst_write;
reg [13:0] inst_addr;
reg inst_rwn;

// RAM IOs (Data Memory)
input [31:0] data_read;

output [31:0] data_write;
output [13:0] data_addr;
output data_rwn;

reg [31:0] data_write;
reg [13:0] data_addr;
reg data_rwn;

// Intermediate Registers
reg SPI_mode = 1;

always @ (posedge clk) begin
    if (SPI_mode) begin
        // All code for SPI communication
        if (spi_haddr[15] == 0) begin
            if (spi_haddr[14] == 0) begin
                inst_write = spi_hwdata;
                inst_addr = spi_haddr[13:0];
                inst_rwn = 0;
            end else begin
                data_write = spi_hwdata;
                data_addr = spi_haddr[13:0];
                data_rwn = 0;
            end
        end else begin
            reg_write = spi_hwdata;
            reg_addr = spi_haddr[3:0];
            reg_rwn = 0;
        end
        
        // Checking to change modes
        if (SPI_change == 1) begin
            SPI_mode = 0;
        end
    end else begin
        // All code for other forms of routing
        
    end
end

endmodule

