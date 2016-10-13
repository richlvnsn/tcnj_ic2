`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2016 10:18:20 PM
// Design Name: 
// Module Name: RAM
// Project Name: Front-End Design for RISC-V based Chip
// Target Devices: 
// Tool Versions: 
// Description: RAM to be used for instruction and data memory.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RAM(clk, r_wn, address, data_in, data_out);

input clk;
input r_wn;
input [11:0] address;
input [31:0] data_in;
output [31:0] data_out;

reg [31:0] memory_array [0:1023];
reg [31:0] data_out;

always @(posedge clk) begin
    if (r_wn) begin
        assign data_out = memory_array[address];
    end else begin
        memory_array[address] = data_in;
    end
end

endmodule
