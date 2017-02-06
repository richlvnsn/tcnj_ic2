`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// The College of New Jersey
// Engineer: Dan Sarnelli, Richard Levenson
// 
// Create Date: 11/16/2016 04:58:54 PM
// Module Name: chip
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
//////////////////////////////////////////////////////////////////////////////////


module chip(//Chip I/O
            input clk,
            input reset,
            input miso,
            input ss,
            output mosi,
            output spi_clk
            );



// SPI connections
wire spi_hready, spi_hresp, core_rst, spi_hwrite, spi_hmastlock;
wire [1:0] spi_htrans;
wire [2:0] spi_hsize, spi_hburst;
wire [3:0] spi_hprot;
wire [31:0] spi_hrdata, spi_haddr, spi_hwdata;

// RISC-V Core connections
wire [23:0] ext_interrupts;
wire [31:0] imem_haddr;
wire imem_hwrite;
wire [2:0] imem_hsize;
wire [2:0] imem_hburst;
wire imem_hmastlock;
wire [3:0] imem_hprot;
wire [1:0] imem_htrans;
wire [31:0] imem_hwdata;
wire [31:0] imem_hrdata;
wire imem_hready;
wire imem_hresp;
wire [31:0] dmem_haddr;
wire dmem_hwrite;
wire [2:0] dmem_hsize;
wire [2:0] dmem_hburst;
wire dmem_hmastlock;
wire [3:0] dmem_hprot;
wire [1:0] dmem_htrans;
wire [31:0] dmem_hwdata;
wire [31:0] dmem_hrdata;
wire dmem_hready;
wire dmem_hresp;
wire htif_reset;
wire htif_id;
wire htif_pcr_req_valid;
wire htif_pcr_req_ready;
wire htif_pcr_req_rw;
wire [11:0] htif_pcr_req_addr;
wire [63:0] htif_pcr_req_data;
wire htif_pcr_resp_valid;
wire htif_pcr_resp_ready;
wire [63:0] htif_pcr_resp_data;
wire htif_ipi_req_ready;
wire htif_ipi_req_valid;
wire htif_ipi_req_data;
wire htif_ipi_resp_ready;
wire htif_ipi_resp_valid;
wire htif_ipi_resp_data;

// Router connections

wire [31:0] reg_read;
wire [31:0] reg_write;
wire [2:0] reg_addr;
wire reg_rwn;
wire [3:0] reg_wben;

wire [31:0] inst_read;
wire [31:0] inst_write;
wire [13:0] inst_addr;
wire inst_rwn;
wire [3:0] inst_wben;

wire [31:0] data_read;
wire [31:0] data_write;
wire [13:0] data_addr;
wire data_rwn;
wire [3:0] data_wben;

// RAM connections
wire iram0_rwn;
wire iram1_rwn;
wire iram2_rwn;
wire iram3_rwn;

wire dram0_rwn;
wire dram1_rwn;
wire dram2_rwn;
wire dram3_rwn;

// Register connections
wire [15:0] ro_gpio_pinstate;
wire [15:0] rf_gpio_datareg;
wire [15:0] rf_gpio_tristate;
wire [15:0] rf_gpio_interrupt_mask;

// Implementing the modules

// RISC-V Core

assign htif_reset = ~(core_rst && reset);
vscale_core core(   .clk(clk),
                    .ext_interrupts(ext_interrupts),
                    // Router (Instruction Memory AHB Lines)
                    .imem_haddr(imem_haddr),
                    .imem_hwrite(imem_hwrite),
                    .imem_hsize(imem_hsize),
                    .imem_hburst(imem_hburst),
                    .imem_hmastlock(imem_hmastlock),
                    .imem_hprot(imem_hprot),
                    .imem_htrans(imem_htrans),
                    .imem_hwdata(imem_hwdata),
                    .imem_hrdata(imem_hrdata),
                    .imem_hready(imem_hready),
                    .imem_hresp(imem_hresp),
                    // Router (Data Memory AHB Lines)
                    .dmem_haddr(dmem_haddr),
                    .dmem_hwrite(dmem_hwrite),
                    .dmem_hsize(dmem_hsize),
                    .dmem_hburst(dmem_hburst),
                    .dmem_hmastlock(dmem_hmastlock),
                    .dmem_hprot(dmem_hprot),
                    .dmem_htrans(dmem_htrans),
                    .dmem_hwdata(dmem_hwdata),
                    .dmem_hrdata(dmem_hrdata),
                    .dmem_hready(dmem_hready),
                    .dmem_hresp(dmem_hresp),
                    // OR Gate (SPI Loader core_rst OR global reset)
                    .htif_reset(htif_reset),
                    // Unused (Host/Target Interface for debugging)
                    .htif_id(htif_id),
                    .htif_pcr_req_valid(htif_pcr_req_valid),
                    .htif_pcr_req_ready(htif_pcr_req_ready),
                    .htif_pcr_req_rw(htif_pcr_req_rw),
                    .htif_pcr_req_addr(htif_pcr_req_addr),
                    .htif_pcr_req_data(htif_pcr_req_data),
                    .htif_pcr_resp_valid(htif_pcr_resp_valid),
                    .htif_pcr_resp_ready(htif_pcr_resp_ready),
                    .htif_pcr_resp_data(htif_pcr_resp_data),
                    .htif_ipi_req_ready(htif_ipi_req_ready),
                    .htif_ipi_req_valid(htif_ipi_req_valid),
                    .htif_ipi_req_data(htif_ipi_req_data),
                    .htif_ipi_resp_ready(htif_ipi_resp_ready),
                    .htif_ipi_resp_valid(htif_ipi_resp_valid),
                    .htif_ipi_resp_data(htif_ipi_resp_data)
);
                    
// Router
Router router(  .clk(clk),
                .reset(~reset),
                .SPI_change(core_rst),
                // SPI Loader IOs
                .spi_hready(spi_hready),
                .spi_hresp(spi_hresp),
                .spi_hrdata(spi_hrdata),
                .spi_haddr(spi_haddr),
                .spi_hwrite(spi_hwrite),
                .spi_hsize(spi_hsize),
                .spi_hburst(spi_hburst),
                .spi_hmastlock(spi_hmastlock),
                .spi_hprot(spi_hprot),
                .spi_htrans(spi_htrans),
                .spi_hwdata(spi_hwdata),
                // RISC-V Core IOs (Instruction Memory)
                .imem_hready(imem_hready),
                .imem_hresp(imem_hresp),
                .imem_hrdata(imem_hrdata),
                .imem_haddr(imem_haddr),
                .imem_hwrite(imem_hwrite),
                .imem_hsize(imem_hsize),
                .imem_hburst(imem_hburst),
                .imem_hmastlock(imem_hmastlock),
                .imem_hprot(imem_hprot),
                .imem_htrans(imem_htrans),
                .imem_hwdata(imem_hwdata),
                // RISC-V Core IOs (Data Memory)
                .dmem_hready(dmem_hready),
                .dmem_hresp(dmem_hresp),
                .dmem_hrdata(dmem_hrdata),
                .dmem_haddr(dmem_haddr),
                .dmem_hwrite(dmem_hwrite),
                .dmem_hsize(dmem_hsize),
                .dmem_hburst(dmem_hburst),
                .dmem_hmastlock(dmem_hmastlock),
                .dmem_hprot(dmem_hprot),
                .dmem_htrans(dmem_htrans),
                .dmem_hwdata(dmem_hwdata),
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
                .inst_rwn(inst_rwn),
                .inst_wben(inst_wben),
                // RAM IOs (Data Memory)
                .data_read(data_read),
                .data_write(data_write),
                .data_addr(data_addr),
                .data_rwn(data_rwn),
                .data_wben(data_wben)
);

// RAM
// Instruction RAM
assign iram0_rwn = inst_rwn || ~inst_wben[0];
RAM iram0(  .clk(clk), 
            .r_wn(iram0_rwn),
            .address(inst_addr),
            .data_in(inst_write[7:0]),
            .data_out(inst_read[7:0])
);
assign iram1_rwn = inst_rwn || ~inst_wben[1];
RAM iram1(  .clk(clk), 
            .r_wn(iram1_rwn),
            .address(inst_addr),
            .data_in(inst_write[15:8]),
            .data_out(inst_read[15:8])
);
assign iram2_rwn = inst_rwn || ~inst_wben[2];
RAM iram2(  .clk(clk), 
            .r_wn(iram2_rwn),
            .address(inst_addr),
            .data_in(inst_write[23:16]),
            .data_out(inst_read[23:16])
);
assign iram3_rwn = inst_rwn || ~inst_wben[3];
RAM iram3(  .clk(clk), 
            .r_wn(iram3_rwn),
            .address(inst_addr),
            .data_in(inst_write[31:24]),
            .data_out(inst_read[31:24])
);
// Data RAM
assign dram0_rwn = data_rwn || ~data_wben[0];
RAM dram0(  .clk(clk), 
            .r_wn(dram0_rwn),
            .address(data_addr),
            .data_in(data_write[7:0]),
            .data_out(data_read[7:0])
);
assign dram1_rwn = data_rwn || ~data_wben[1];
RAM dram1(  .clk(clk), 
            .r_wn(dram1_rwn),
            .address(data_addr),
            .data_in(data_write[15:8]),
            .data_out(data_read[15:8])
);
assign dram2_rwn = data_rwn || ~data_wben[2];
RAM dram2(  .clk(clk), 
            .r_wn(dram2_rwn),
            .address(data_addr),
            .data_in(data_write[23:16]),
            .data_out(data_read[23:16])
);
assign dram3_rwn = data_rwn || ~data_wben[3];
RAM dram3(  .clk(clk), 
            .r_wn(dram3_rwn),
            .address(data_addr),
            .data_in(data_write[31:24]),
            .data_out(data_read[31:24])
);

// Registers
register register(  .clk(clk),
                    .reset(~reset), 
                    .addr(reg_addr),
                    .wben(reg_wben),
                    .r_wn(reg_rwn),
                    .wdata(reg_write),
                    .ro_gpio_pinstate(ro_gpio_pinstate),
                    .rdata(reg_read),
                    .rf_gpio_datareg(rf_gpio_datareg),
                    .rf_gpio_tristate(rf_gpio_tristate),
                    .rf_gpio_interrupt_mask(rf_gpio_interrupt_mask)
);


// SPI Loader
spi_loader spi( .clk(clk),
                .reset(reset),
                .miso(miso),
                .spi_hready(spi_hready),
                .spi_hrdata(spi_hrdata),
                .core_rst(core_rst),    // Core (reset signal)
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
                .spi_hwdata(spi_hwdata)
);
          

endmodule

