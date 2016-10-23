`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2016 05:51:07 PM
// Design Name: 
// Module Name: RAM_test_2
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


module RAM_test_2();

//Inputs
reg clk;
reg r_wn;
reg [11:0] address;
reg [31:0] data_in;

//Outputs
wire [31:0] data_out;

//Integer writing test
integer count;

RAM small_bank (
    .clk(clk),
    .r_wn(r_wn),
    .address(address),
    .data_in(data_in),
    .data_out(data_out)
);

initial begin
    count = 0;
    clk = 0;
    r_wn = 0;
    address = 12'h000;
    data_in = 32'h00000000;
    
    forever begin
        #5 clk = ~clk;
        
        if (count == 1) begin
            address = 12'h000;
            data_in = 32'habcd0123;
        end
        
        if (count == 2) begin
            address = 12'h001;
            data_in = 32'hffeeddcc;
        end
        
        if (count == 3 || count == 5) begin
            r_wn = 1;
            address = 12'h000;
        end
        
        if (count == 4) begin
            r_wn = 0;
            address = 12'h000;
            data_in = 32'h01234567;
        end
        
        if (clk) begin
            count = count + 1;
        end
    end
end

endmodule

