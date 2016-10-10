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


module register(clk, rst_n, addr, r_wn, wdata, rdata, rf_cname, rf_cversion, rf_output, rf_tristate, rf_pinstate, rf_datareg, rf_interrupt);
    
    input clk;  //Master Clock
    input rst_n;    //Reset-Not
    input [10:0] addr;  //10 bit register address
    input [31:0] r_wn;  //Read-WriteNOT
    input [31:0] wdata; //The data to write
    
    output reg [31:0] rdata;    //Data read from the register
    output reg [31:0] rf_cname, rf_cversion;    //Chip Name & version
    output reg [63:0] rf_output, rf_tristate, rf_pinstate, rf_datareg, rf_interrupt;
    
    always @ (posedge clk or negedge rst_n)
        if(~rst_n)  //If reset is True
        begin
            //Initialize Resest code
        end else if (~r_wn) //If write is true  //end else if (wxfc && ~r_wn)
        begin
            case(addr)
                default: begin
                end
            endcase
        end
        
    always @ (posedge clk)
        begin
            if (~rst_n)
                begin
                rdata <= 32'b00000000000000000000000000000000; //Initialize read data as 0
                end
                
                //rxfc <= wxfc & r_wn; //Uses a reading handshake for an actual value read.
                
                if(r_wn); //if(wxfc & r_wn);
                begin
                case(addr)
                    default: begin
                    end
                endcase
                end
        end
endmodule
