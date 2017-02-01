`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// The College of New Jersey
// Engineer: Dan Sarnelli
// 
// Create Date: 11/16/2016 04:58:54 PM
// Module Name: chip
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
//////////////////////////////////////////////////////////////////////////////////


module chip(clk, reset, miso);

// Chip IOs
input clk, reset, miso;

// SPI connections
wire spi_hready, spi_hresp, core_rst, spi_clk, mosi, ss, spi_hwrite, spi_hmastlock;
wire [1:0] spi_htrans;
wire [2:0] spi_hsize, spi_hburst;
wire [3:0] spi_hprot;
wire [31:0] spi_hrdata, spi_haddr, spi_hwdata;

// RISC-V Core connections

// Router connections

// RAM connections

// Register connections

// Implementing the modules

spi_loader spi( .clk(clk),
                .reset(reset),
                .miso(miso),
                .spi_hready(spi_hready),
                .spi_hrdata(spi_hrdata),
                .core_rst(core_rst),
                .spi_clk(spi_clk),
                .mosi(mosi),
                .ss(ss),
                .spi_haddr(spi_haddr),
                .spi_hwrite(spi_hwrite),
                .spi_hsize(spi_hsize),
                .spi_hburst(spi_hburst),
                .spi_hmastlock(spi_hmastlock),
                .spi_hprot(spi_hprot),
                .spi_htrans(spi_htrans),
                .spi_hwdata(spi_hwdata));

endmodule

