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
 
 
module register(clk, rst_n, addr, r_wn, wdata, rdata, rf_gpio_datareg);
   
    input clk;  //Master Clock
    input reset;    //Reset
    input [4:0] addr;  //10 bit register address
    input [31:0] r_wn;  //Read-WriteNOT
    input [31:0] wdata; //The data to write
   
    output reg [31:0] rdata;    //Data read from the register
 
    // Register outputs
    output reg [15:0] rf_gpio_datareg;
   
    reg [31:0] rf_cname = ;        // Read-only chip name (team initials)
    reg [31:0] rf_cversion = ;     // Read-only chip info, 8 bits each: version, major, minor, bugfix
    reg [15:0] rf_gpio_tristate;
    reg [15:0] rf_gpio_pinstate;
    reg [15:0] rf_gpio_interrupt_mask;
    reg [31:0] rf_scratch;
   
    always @ (posedge clk)
        if(reset)  //If reset is True
        begin
            //Initialize Resest code
        end else if (~r_wn) //If write is true  //end else if (wxfc && ~r_wn)
        begin
            case(addr)
                5'b00000: rdata <= rf_cname;
                5'b00001: rdata <= rf_cversion;
                5'b00010: rdata <= rf_gpio_tristate;
                5'b00011: rdata <= rf_gpio_pinstate;
                5'b00100: rdata <= rf_gpio_interrupt_mask;
                5'b00101: rdata <= rf_scratch
            endcase
        end
       
    always @ (posedge clk)
        begin
            if (~reset)
                begin
                rdata <= 0; //Initialize read data as 0
                end
                //rxfc <= wxfc & r_wn; //Uses a reading handshake for an actual value read.    
                if(r_wn); //if(wxfc & r_wn);
                begin
                case(addr)
                     5'b00010: rf_gpio_tristate <= wdata;
                     5'b00011: rf_gpio_pinstate <= wdata;
                     5'b00100: rf_gpio_interrupt_mask <= wdata;
                     5'b00101: rf_scratch <= wdata;
                endcase
                end
        end
endmodule