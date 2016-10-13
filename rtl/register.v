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


module register(clk, rst_n, addr, r_wn, wdata, rdata);
    
    input clk;  //Master Clock
    input rst_n;    //Reset-Not
    input [6:0] addr;  //10 bit register address
    input [31:0] r_wn;  //Read-WriteNOT
    input [31:0] wdata; //The data to write
    
    output reg [31:0] rdata;    //Data read from the register

    reg [31:0] rf_cname, rf_cversion;    //Chip Name & version
    reg [31:0] rf_output00, rf_tristate00, rf_pinstate00, rf_datareg00, rf_interrupt00;
    reg [31:0] rf_output01, rf_tristate01, rf_pinstate01, rf_datareg01, rf_interrupt01;
    reg [31:0] rf_output02, rf_tristate02, rf_pinstate02, rf_datareg02, rf_interrupt02;
    reg [31:0] rf_output03, rf_tristate03, rf_pinstate03, rf_datareg03, rf_interrupt03;
    reg [31:0] rf_output04, rf_tristate04, rf_pinstate04, rf_datareg04, rf_interrupt04;
    reg [31:0] rf_output05, rf_tristate05, rf_pinstate05, rf_datareg05, rf_interrupt05;
    reg [31:0] rf_output06, rf_tristate06, rf_pinstate06, rf_datareg06, rf_interrupt06;
    reg [31:0] rf_output07, rf_tristate07, rf_pinstate07, rf_datareg07, rf_interrupt07;
    reg [31:0] rf_output08, rf_tristate08, rf_pinstate08, rf_datareg08, rf_interrupt08;
    reg [31:0] rf_output09, rf_tristate09, rf_pinstate09, rf_datareg09, rf_interrupt09;
    reg [31:0] rf_output10, rf_tristate10, rf_pinstate10, rf_datareg10, rf_interrupt10;
    reg [31:0] rf_output11, rf_tristate11, rf_pinstate11, rf_datareg11, rf_interrupt11;
    reg [31:0] rf_output12, rf_tristate12, rf_pinstate12, rf_datareg12, rf_interrupt12;
    reg [31:0] rf_output13, rf_tristate13, rf_pinstate13, rf_datareg13, rf_interrupt13;
    reg [31:0] rf_output14, rf_tristate14, rf_pinstate14, rf_datareg14, rf_interrupt14;
    reg [31:0] rf_output15, rf_tristate15, rf_pinstate15, rf_datareg15, rf_interrupt15;
    
    always @ (posedge clk or negedge rst_n)
        if(~rst_n)  //If reset is True
        begin
            //Initialize Resest code
        end else if (~r_wn) //If write is true  //end else if (wxfc && ~r_wn)
        begin
            case(addr)
                7'b0000000: rdata <= rf_cname;
                7'b0000001: rdata <= rf_cversion;
                7'b0000010: rdata <= rf_output00;
                7'b0000011: rdata <= rf_tristate00;
            endcase
        end
        
    always @ (posedge clk)
        begin
            if (~rst_n)
                begin
                rdata <= 0; //Initialize read data as 0
                end
                
                //rxfc <= wxfc & r_wn; //Uses a reading handshake for an actual value read.
                
                if(r_wn); //if(wxfc & r_wn);
                begin
                case(addr)
                     7'b0000010: rf_output00 <= wdata;
                     7'b0000011: rf_tristate00 <=wdata;
                     7'b0000100: rf_pinstate00 <=wdata;
                endcase
                end
        end
endmodule
