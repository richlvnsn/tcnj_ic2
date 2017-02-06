`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2017 01:56:28 PM
// Design Name: 
// Module Name: Router_test
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


module Router_test();

//Inputs
reg clk;
reg reset;
reg SPI_change;

// SPI Loader IOs
reg [31:0] spi_haddr, spi_hwdata;
reg [3:0] spi_hprot;
reg [2:0] spi_hsize, spi_hburst;
reg [1:0] spi_htrans;
reg spi_hwrite, spi_hmastlock;

wire [31:0] spi_hrdata;
wire spi_hready, spi_hresp;

// RISC-V Core IOs (Instruction Memory)
reg [31:0] imem_haddr, imem_hwdata;
reg [3:0] imem_hprot;
reg [2:0] imem_hsize, imem_hburst;
reg [1:0] imem_htrans;
reg imem_hwrite, imem_hmastlock;

wire [31:0] imem_hrdata;
wire imem_hready, imem_hresp;

// RISC-V Core IOs (Data Memory)
reg [31:0] dmem_haddr, dmem_hwdata;
reg [3:0] dmem_hprot;
reg [2:0] dmem_hsize, dmem_hburst;
reg [1:0] dmem_htrans;
reg dmem_hwrite, dmem_hmastlock;

wire [31:0] dmem_hrdata;
wire dmem_hready, dmem_hresp;

// Register IOs
reg [31:0] reg_read;

wire [31:0] reg_write;
wire [3:0] reg_addr, reg_wben;
wire reg_rwn;

// RAM IOs (Instruction Memory)
reg [31:0] inst_read;

wire [31:0] inst_write;
wire [13:0] inst_addr;
wire [3:0] inst_wben;
wire inst_rwn;

// RAM IOs (Data Memory)
reg [31:0] data_read;

wire [31:0] data_write;
wire [13:0] data_addr;
wire [3:0] data_wben;
wire data_rwn;

//Integer writing test
integer count;

Router router (
    .clk(clk),
    .reset(reset),
    .SPI_change(SPI_change),
    
    // SPI Loader IOs
    .spi_haddr(spi_haddr),
    .spi_hwdata(spi_hwdata),
    .spi_hprot(spi_hprot),
    .spi_hsize(spi_hsize),
    .spi_hburst(spi_hburst),
    .spi_htrans(spi_htrans),
    .spi_hwrite(spi_hwrite),
    .spi_hmastlock(spi_hmastlock),
    .spi_hrdata(spi_hrdata),
    .spi_hready(spi_hready),
    .spi_hresp(spi_hresp),
    
    // RISC-V Core IOs (Instruction Memory)
    .imem_haddr(imem_haddr),
    .imem_hwdata(imem_hwdata),
    .imem_hprot(imem_hprot),
    .imem_hsize(imem_hsize),
    .imem_hburst(imem_hburst),
    .imem_htrans(imem_htrans),
    .imem_hwrite(imem_hwrite),
    .imem_hmastlock(imem_hmastlock),
    .imem_hrdata(imem_hrdata),
    .imem_hready(imem_hready),
    .imem_hresp(imem_hresp),
    
    // RISC-V Core IOs (Data Memory)
    .dmem_haddr(dmem_haddr),
    .dmem_hwdata(dmem_hwdata),
    .dmem_hprot(dmem_hprot),
    .dmem_hsize(dmem_hsize),
    .dmem_hburst(dmem_hburst),
    .dmem_htrans(dmem_htrans),
    .dmem_hwrite(dmem_hwrite),
    .dmem_hmastlock(dmem_hmastlock),
    .dmem_hrdata(dmem_hrdata),
    .dmem_hready(dmem_hready),
    .dmem_hresp(dmem_hresp),
    
    // Register IOs
    .reg_read(reg_read),
    .reg_write(reg_write),
    .reg_addr(reg_addr),
    .reg_wben(reg_wben),
    .reg_rwn(reg_rwn),
    
    // RAM IOs (Instruction Memory)
    .inst_read(inst_read),
    .inst_write(inst_write),
    .inst_addr(inst_addr),
    .inst_wben(inst_wben),
    .inst_rwn(inst_rwn),
    
    // RAM IOs (Data Memory)
    .data_read(data_read),
    .data_write(data_write),
    .data_addr(data_addr),
    .data_wben(data_wben),
    .data_rwn(data_rwn)
);

initial begin
    count = 0;
    clk = 0;
    reset = 0;
    SPI_change = 0;
    
    spi_haddr = 32'h00000000;
    spi_hwdata = 32'h01234567;
    spi_hsize = 3'b010;
    spi_htrans = 2'b10;
    spi_hwrite = 1;
    
    forever begin
        #5 clk = ~clk;
        
        if (count == 1) begin
            spi_haddr = 32'h00000001;
        end
        
        if (count == 2) begin
            spi_haddr = 32'h00000002;
        end
        
        if (count == 3) begin
            spi_haddr = 32'h00004003;
        end
        
        if (count == 4) begin
            spi_haddr = 32'h00004004;
        end
        
        if (clk) begin
            count = count + 1;
        end
    end
end

endmodule

