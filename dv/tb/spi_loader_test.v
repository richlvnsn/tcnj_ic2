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


module spi_loader_test;
    reg clk, reset, miso, spi_hready, spi_hresp; 
    reg [31:0] spi_hrdata;
    wire core_rst, spi_clk, mosi, ss, spien, spi_hwrite, spi_mastlock;
    wire [31:0] spi_haddr, spi_hwdata; 
    wire [3:0] spi_hprot;
    wire [2:0] spi_hsize, spi_hburst;
    wire [1:0] spi_htrans;
  
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
        .spien(spien),
        .spi_haddr(spi_haddr),
        .spi_hwrite(spi_hwrite),
        .spi_hsize(spi_hsize),
        .spi_hburst(spi_hburst),
        .spi_hmastlock(spi_mastlock),
        .spi_hprot(spi_hprot),
        .spi_htrans(spi_htrans),
        .spi_hwdata(spi_hwdata)
        );
    initial 
    begin 
        clk = 0; 
        reset = 0; 
        miso = 0; 
        spi_hready = 1;
        spi_hresp = 0;
        spi_hrdata = 0;
        
        #2.5 reset = 1;
        
        #2.5 reset = 0;
        
        // miso left at 0 for instruction and address phases
        
        // bits for parse_num_bytes[7:0]
        #2400 miso = 0; 
        
        #100 miso = 0;
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        // bits for parse_num_bytes[15:8]
        #100 miso = 0; 
        
        #100 miso = 0;
                
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 1; // set the number of bits to 32K
        
        // bits for parse_start_addr[7:0]
        #100 miso = 0; 
        
        #100 miso = 0;
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        // bits for parse_start_addr[15:8]
        #100 miso = 0; 
        
        #100 miso = 1; // set the start address to 0x200
                
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        #100 miso = 0; 
        
        // bits for cur_word_in, pipe_reg, spi_hwdata...
        
        #100 miso = 1;
        
        #100 miso = 0;
    end 
    always 
        #2.5  clk =  ! clk; //200 MHz master clock
endmodule
