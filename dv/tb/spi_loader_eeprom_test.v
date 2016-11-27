`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2016 07:28:09 PM
// Design Name: 
// Module Name: spi_loader_test
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

//`include "C:/Users/Rich/OneDrive/Documents/College/Fall\ 2016/ELC\ 495\ Senior\ Project\ I/spi_loader/spi_loader.srcs/sim_2/imports/SPI\ EEPROM\ Verilog\ Model/M95XXX_Parameters.v"
`include "C:\Users\Rich\OneDrive\Documents\College\Fall 2016\ELC 495 Senior Project I\spi_loader\spi_loader.srcs\sim_2\imports\SPI EEPROM Verilog Model\M95XXX_Parameters.v"

module spi_loader_test;
    reg clk, reset, spi_hready, spi_hresp, w, hold, vcc, vss;
    reg [31:0] spi_hrdata;
    wire core_rst, spi_clk, mosi, miso, ss, spi_hwrite, spi_mastlock;
    wire [31:0] spi_haddr, spi_hwdata; 
    wire [3:0] spi_hprot;
    wire [2:0] spi_hsize, spi_hburst;
    wire [1:0] spi_htrans;
    
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
  
    spi_loader uut(
        .clk(clk),
        .miso(miso),
        .spi_hready(spi_hready),
        .spi_hresp(spi_hresp),
        .spi_hrdata(spi_hrdata),
        .reset(reset),
        .core_rst(core_rst),
        .spi_clk(spi_clk),
        .mosi(mosi),
        .ss(ss),
        .spi_haddr(spi_haddr),
        .spi_hwrite(spi_hwrite),
        .spi_hsize(spi_hsize),
        .spi_hburst(spi_hburst),
        .spi_hmastlock(spi_mastlock),
        .spi_hprot(spi_hprot),
        .spi_htrans(spi_htrans),
        .spi_hwdata(spi_hwdata)
        );
        
        M95XXX_Macro_mux M95XXX_Macro_mux();
    initial 
    begin 
        $readmemh("M95XXX_Initial.dat",U_M95XXX.memory);
        clk = 0; 
        reset = 0; 
        spi_hready = 1;
        spi_hresp = 0;
        spi_hrdata = 0;
        w = 1;      // Tied to 1 to prevent write protect
        hold = 1;   // Tied to 1 to prevent hold
        vcc = 1;
        vss = 0;
        
        #1 reset = 1;
        #5 reset = 0;
        
    end 
    always 
        #2.5  clk =  ! clk; //200 MHz master clock
endmodule
