`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// The College of New Jersey
// Engineer: Dan Sarnelli
// 
// Create Date: 10/05/2016 10:18:20 PM
// Module Name: RAM
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
//////////////////////////////////////////////////////////////////////////////////


module RAM(clk, r_wn, address, data_in, data_out);

input clk;
input r_wn;
input [11:0] address;
input [7:0] data_in;
output [7:0] data_out;

reg [7:0] memory_array [0:4095];
reg [7:0] data_out;

always @(posedge clk) begin
    if (!r_wn) memory_array[address] <= data_in;
end

always @ (*) begin
    if (r_wn) data_out <= memory_array[address];
end

endmodule
