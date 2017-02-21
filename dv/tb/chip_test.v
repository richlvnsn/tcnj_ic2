`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2016 07:28:09 PM
// Design Name: 
// Module Name: chip_test
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

`include "C:\hdl\tcnj_ic2_integration\tcnj_ic2_integration.srcs\sim_1\imports\SPI EEPROM Verilog Model\M95XXX_Parameters.v"

module chip_test;
    reg clk, reset, w, hold, vcc, vss;
    wire spi_clk, mosi, miso, ss;
    wire [15:0] gpio_input;
    
    //wire c,d,q,s,w,hold,vcc,vss;
    
    //-------------------------------------
    M95XXX U_M95XXX(
                        .C(spi_clk),
                        .D(mosi),
                        .Q(miso),
                        .S(ss),
                        .W(w),
                        .HOLD(hold),
                        .VCC(vcc),
                        .VSS(vss)
                     );
  
    chip_top uut(
        .clk(clk),
        .miso(miso),
        .reset(reset),
        .spi_clk_out(spi_clk),
        .mosi_out(mosi),
        .spi_en_out(ss),
        .gpio_input(gpio_input)
        );
        
        M95XXX_Macro_mux M95XXX_Macro_mux();
    initial 
    begin 
        $readmemh("walking_spi.hex",U_M95XXX.memory);
        //gpio_input = 0;
        clk = 0; 
        reset = 1; 
        w = 1;      // Tied to 1 to prevent write protect
        hold = 1;   // Tied to 1 to prevent hold
        vcc = 1;
        vss = 0;
        
        #1 reset = 0;
        #5 reset = 1;
        
    end 
    always 
        #2.5  clk =  ! clk; //200 MHz master clock
endmodule
