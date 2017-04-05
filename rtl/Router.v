`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// The College of New Jersey
// Engineer: Dan Sarnelli
// 
// Create Date: 10/23/2016 07:45:40 PM
// Module Name: Router
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
//////////////////////////////////////////////////////////////////////////////////


module Router(
    clk, reset, SPI_change,
    // SPI Loader IOs
    spi_hready, spi_hresp, spi_hrdata, spi_haddr, spi_hwrite, spi_hsize, spi_hburst, spi_hmastlock, spi_hprot, spi_htrans, spi_hwdata,
    // RISC-V Core IOs (Instruction Memory)
    imem_hready, imem_hresp, imem_hrdata, imem_haddr, imem_hwrite, imem_hsize, imem_hburst, imem_hmastlock, imem_hprot, imem_htrans, imem_hwdata,
    // RISC-V Core IOs (Data Memory)
    dmem_hready, dmem_hresp, dmem_hrdata, dmem_haddr, dmem_hwrite, dmem_hsize, dmem_hburst, dmem_hmastlock, dmem_hprot, dmem_htrans, dmem_hwdata,
    // Register IOs
    reg_read, reg_write, reg_addr, reg_wben, reg_rwn,
    // RAM IOs (Instruction Memory)
    inst_read, inst_write, inst_addr, inst_rwn, inst_wben,
    // RAM IOs (Data Memory)
    data_read, data_write, data_addr, data_rwn, data_wben
);

input clk, reset, SPI_change;

// SPI Loader IOs
input [31:0] spi_haddr, spi_hwdata;
input [3:0] spi_hprot;
input [2:0] spi_hsize, spi_hburst;
input [1:0] spi_htrans;
input spi_hwrite, spi_hmastlock;

output [31:0] spi_hrdata;
output spi_hready, spi_hresp;

reg spi_hready, spi_hresp;

// RISC-V Core IOs (Instruction Memory)
input [31:0] imem_haddr, imem_hwdata;
input [3:0] imem_hprot;
input [2:0] imem_hsize, imem_hburst;
input [1:0] imem_htrans;
input imem_hwrite, imem_hmastlock;

output [31:0] imem_hrdata;
output imem_hready, imem_hresp;

reg [31:0] imem_hrdata;
reg imem_hready, imem_hresp;

// RISC-V Core IOs (Data Memory)
input [31:0] dmem_haddr, dmem_hwdata;
input [3:0] dmem_hprot;
input [2:0] dmem_hsize, dmem_hburst;
input [1:0] dmem_htrans;
input dmem_hwrite, dmem_hmastlock;

output [31:0] dmem_hrdata;
output dmem_hready, dmem_hresp;

reg [31:0] dmem_hrdata;
reg dmem_hready, dmem_hresp;

// Register IOs
input [31:0] reg_read;

output [31:0] reg_write;
output [3:0] reg_addr, reg_wben;
output reg_rwn;

reg [31:0] reg_write;
reg [3:0] reg_wben;
reg [3:0] reg_addr;
reg reg_rwn;

// RAM IOs (Instruction Memory)
input [31:0] inst_read;

output [31:0] inst_write;
output [11:0] inst_addr;
output [3:0] inst_wben;
output inst_rwn;

reg [31:0] inst_write;
reg [11:0] inst_addr;
reg [3:0] inst_wben;
reg inst_rwn;

// RAM IOs (Data Memory)
input [31:0] data_read;

output [31:0] data_write;
output [11:0] data_addr;
output [3:0] data_wben;
output data_rwn;

reg [31:0] data_write;
reg [11:0] data_addr;
reg [3:0] data_wben;
reg data_rwn;

// Intermediate Registers
reg favor_imem = 1;
reg favor_dmem = 1;
reg favor_reg = 1;

// Delay pipeline registers
reg delay_mode = 0;
reg [31:0] int_haddr;
reg [31:0] int_imem_haddr_read;
reg [31:0] int_dmem_haddr_read;
reg [2:0] int_hsize;
reg [1:0] int_hready;
reg [1:0] int_imem_htrans;
reg [1:0] int_dmem_htrans;
reg int_source;

always @ (*) begin
    // Checking if arbitration is necessary
    if (int_imem_htrans == 2'b10 && int_dmem_htrans == 2'b10 && int_imem_haddr_read[15:14] == int_dmem_haddr_read[15:14]) begin
        if (int_imem_haddr_read[15] == 0) begin
            if (int_imem_haddr_read[14] == 0) begin
                // Instruction memory arbitration
                if (favor_imem) begin
                    // IMEM AHB to instruction communication
                    imem_hrdata <= inst_read;
                end else begin
                    // DMEM AHB to instruction communication
                    dmem_hrdata <= inst_read;
                end
            end else begin
                // Data memory arbitration
                if (favor_dmem) begin
                    // DMEM AHB to data communication
                    dmem_hrdata <= data_read;
                end else begin
                    // IMEM AHB to data communication
                    imem_hrdata <= data_read;
                end
            end
        end else begin
            // Register arbitration
            if (favor_reg) begin
                // DMEM AHB to register communication
                dmem_hrdata <= reg_read;
            end else begin
                // IMEM AHB to register communication
                imem_hrdata <= reg_read;
            end
        end
    end else begin
        if (int_imem_htrans == 2'b10) begin
            // Checking for register communication
            if (int_imem_haddr_read[15] == 0) begin
                // Checking for instruction or data communication
                if (int_imem_haddr_read[14] == 0) begin
                    // Instruction communication
                    imem_hrdata <= inst_read;
                end else begin
                    // Data communication
                    imem_hrdata <= data_read;
                end
            end else begin
                // Register communication
                imem_hrdata <= reg_read;
            end
        end
        
        if (int_dmem_htrans == 2'b10) begin
            // Checking for register communication
            if (int_dmem_haddr_read[15] == 0) begin
                // Checking for instruction or data communication
                if (int_dmem_haddr_read[14] == 0) begin
                    // Instruction communication
                    dmem_hrdata <= inst_read;
                end else begin
                    // Data communication
                    dmem_hrdata <= data_read;
                end
            end else begin
                // Register communication
                dmem_hrdata <= reg_read;
            end
        end
    end
end

always @ (posedge clk) begin
    // Checking for reset
    if (reset) begin
        spi_hready <= 0;
        imem_hready <= 0;
        dmem_hready <= 0;
        delay_mode <= 0;
    end else if (delay_mode) begin
        delay_mode <= 0;
        imem_hready <= int_hready[1];
        dmem_hready <= int_hready[0];
    
        if (int_source) begin
            // DMEM bus writing
            if (int_haddr[15] == 0) begin
                if (int_haddr[14] == 0) begin
                    inst_write <= dmem_hwdata;
                    inst_addr <= int_haddr[13:2];
                    inst_rwn <= 0;
                    
                    if (int_hsize == 3'b000) begin
                        if (int_haddr[1:0] == 2'b00) begin
                            inst_wben <= 4'b0001;
                        end else if (int_haddr[1:0] == 2'b01) begin
                            inst_wben <= 4'b0010;
                        end else if (int_haddr[1:0] == 2'b10) begin
                            inst_wben <= 4'b0100;
                        end else begin
                            inst_wben <= 4'b1000;
                        end
                    end else if (int_hsize == 3'b001) begin
                        if (int_haddr[1:0] == 2'b00) begin
                            inst_wben <= 4'b0011;
                        end else begin
                            inst_wben <= 4'b1100;
                        end
                    end else begin
                        inst_wben <= 4'b1111;
                    end
                end else begin
                    data_write <= dmem_hwdata;
                    data_addr <= int_haddr[13:2];
                    data_rwn <= 0;
                    
                    if (int_hsize == 3'b000) begin
                        if (int_haddr[1:0] == 2'b00) begin
                            data_wben <= 4'b0001;
                        end else if (int_haddr[1:0] == 2'b01) begin
                            data_wben <= 4'b0010;
                        end else if (int_haddr[1:0] == 2'b10) begin
                            data_wben <= 4'b0100;
                        end else begin
                            data_wben <= 4'b1000;
                        end
                    end else if (int_hsize == 3'b001) begin
                        if (int_haddr[1:0] == 2'b00) begin
                            data_wben <= 4'b0011;
                        end else begin
                            data_wben <= 4'b1100;
                        end
                    end else begin
                        data_wben <= 4'b1111;
                    end
                end
            end else begin
                reg_write <= dmem_hwdata;
                reg_addr <= int_haddr[5:2];
                reg_rwn <= 0;
                
                if (int_hsize == 3'b000) begin
                    if (int_haddr[1:0] == 2'b00) begin
                        reg_wben <= 4'b0001;
                    end else if (int_haddr[1:0] == 2'b01) begin
                        reg_wben <= 4'b0010;
                    end else if (int_haddr[1:0] == 2'b10) begin
                        reg_wben <= 4'b0100;
                    end else begin
                        reg_wben <= 4'b1000;
                    end
                end else if (int_hsize == 3'b001) begin
                    if (int_haddr[1:0] == 2'b00) begin
                        reg_wben <= 4'b0011;
                    end else begin
                        reg_wben <= 4'b1100;
                    end
                end else begin
                    reg_wben <= 4'b1111;
                end
            end
        end else begin
            // IMEM bus writing
            if (int_haddr[15] == 0) begin
                if (int_haddr[14] == 0) begin
                    inst_write <= imem_hwdata;
                    inst_addr <= int_haddr[13:2];
                    inst_rwn <= 0;
                    
                    if (int_hsize == 3'b000) begin
                        if (int_haddr[1:0] == 2'b00) begin
                            inst_wben <= 4'b0001;
                        end else if (int_haddr[1:0] == 2'b01) begin
                            inst_wben <= 4'b0010;
                        end else if (int_haddr[1:0] == 2'b10) begin
                            inst_wben <= 4'b0100;
                        end else begin
                            inst_wben <= 4'b1000;
                        end
                    end else if (int_hsize == 3'b001) begin
                        if (int_haddr[1:0] == 2'b00) begin
                            inst_wben <= 4'b0011;
                        end else begin
                            inst_wben <= 4'b1100;
                        end
                    end else begin
                        inst_wben <= 4'b1111;
                    end
                end else begin
                    data_write <= imem_hwdata;
                    data_addr <= int_haddr[13:2];
                    data_rwn <= 0;
                    
                    if (int_hsize == 3'b000) begin
                        if (int_haddr[1:0] == 2'b00) begin
                            data_wben <= 4'b0001;
                        end else if (int_haddr[1:0] == 2'b01) begin
                            data_wben <= 4'b0010;
                        end else if (int_haddr[1:0] == 2'b10) begin
                            data_wben <= 4'b0100;
                        end else begin
                            data_wben <= 4'b1000;
                        end
                    end else if (int_hsize == 3'b001) begin
                        if (int_haddr[1:0] == 2'b00) begin
                            data_wben <= 4'b0011;
                        end else begin
                            data_wben <= 4'b1100;
                        end
                    end else begin
                        data_wben <= 4'b1111;
                    end
                end
            end else begin
                reg_write <= imem_hwdata;
                reg_addr <= int_haddr[5:2];
                reg_rwn <= 0;
                
                if (int_hsize == 3'b000) begin
                    if (int_haddr[1:0] == 2'b00) begin
                        reg_wben <= 4'b0001;
                    end else if (int_haddr[1:0] == 2'b01) begin
                        reg_wben <= 4'b0010;
                    end else if (int_haddr[1:0] == 2'b10) begin
                        reg_wben <= 4'b0100;
                    end else begin
                        reg_wben <= 4'b1000;
                    end
                end else if (int_hsize == 3'b001) begin
                    if (int_haddr[1:0] == 2'b00) begin
                        reg_wben <= 4'b0011;
                    end else begin
                        reg_wben <= 4'b1100;
                    end
                end else begin
                    reg_wben <= 4'b1111;
                end
            end
        end
    end else if (!SPI_change) begin
        int_haddr <= spi_haddr;
        int_hsize <= spi_hsize;
        
        if (int_haddr[15] == 0) begin
            if (int_haddr[14] == 0) begin
                inst_write <= spi_hwdata;
                inst_addr <= int_haddr[13:2];
                inst_rwn <= 0;
                
                if (int_hsize == 3'b000) begin
                    if (int_haddr[1:0] == 2'b00) begin
                        inst_wben <= 4'b0001;
                    end else if (int_haddr[1:0] == 2'b01) begin
                        inst_wben <= 4'b0010;
                    end else if (int_haddr[1:0] == 2'b10) begin
                        inst_wben <= 4'b0100;
                    end else begin
                        inst_wben <= 4'b1000;
                    end
                end else if (int_hsize == 3'b001) begin
                    if (int_haddr[1:0] == 2'b00) begin
                        inst_wben <= 4'b0011;
                    end else begin
                        inst_wben <= 4'b1100;
                    end
                end else begin
                    inst_wben <= 4'b1111;
                end
            end else begin
                data_write <= spi_hwdata;
                data_addr <= int_haddr[13:2];
                data_rwn <= 0;
                
                if (int_hsize == 3'b000) begin
                    if (int_haddr[1:0] == 2'b00) begin
                        data_wben <= 4'b0001;
                    end else if (int_haddr[1:0] == 2'b01) begin
                        data_wben <= 4'b0010;
                    end else if (int_haddr[1:0] == 2'b10) begin
                        data_wben <= 4'b0100;
                    end else begin
                        data_wben <= 4'b1000;
                    end
                end else if (int_hsize == 3'b001) begin
                    if (int_haddr[1:0] == 2'b00) begin
                        data_wben <= 4'b0011;
                    end else begin
                        data_wben <= 4'b1100;
                    end
                end else begin
                    data_wben <= 4'b1111;
                end
            end
        end else begin
            reg_write <= spi_hwdata;
            reg_addr <= int_haddr[5:2];
            reg_rwn <= 0;
            
            if (int_hsize == 3'b000) begin
                if (int_haddr[1:0] == 2'b00) begin
                    reg_wben <= 4'b0001;
                end else if (int_haddr[1:0] == 2'b01) begin
                    reg_wben <= 4'b0010;
                end else if (int_haddr[1:0] == 2'b10) begin
                    reg_wben <= 4'b0100;
                end else begin
                    reg_wben <= 4'b1000;
                end
            end else if (int_hsize == 3'b001) begin
                if (int_haddr[1:0] == 2'b00) begin
                    reg_wben <= 4'b0011;
                end else begin
                    reg_wben <= 4'b1100;
                end
            end else begin
                reg_wben <= 4'b1111;
            end
        end
        
        // In this mode, the router should always be ready for a transfer and should always be OK
        spi_hready <= 1;
        spi_hresp <= 0;
    end else begin
        // Checking if arbitration is necessary
        if (imem_htrans == 2'b10 && dmem_htrans == 2'b10 && imem_haddr[15:14] == dmem_haddr[15:14]) begin
            if (imem_haddr[15] == 0) begin
                if (imem_haddr[14] == 0) begin
                    // Instruction memory arbitration
                    if (favor_imem) begin
                        // IMEM AHB to instruction communication
                        if (imem_hwrite) begin
                            int_haddr <= imem_haddr;
                            int_hsize <= imem_hsize;
                            
                            int_hready <= 2'b10;
                            int_source <= 0;
                            
                            delay_mode <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 0;
                            dmem_hready <= 0;
                        end else begin
                            int_imem_haddr_read <= imem_haddr;
                            int_imem_htrans <= imem_htrans;
                            inst_addr <= imem_haddr[13:2];
                            inst_rwn <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 1;
                            dmem_hready <= 0;
                        end
                    end else begin
                        // DMEM AHB to instruction communication
                        if (dmem_hwrite) begin
                            int_haddr <= dmem_haddr;
                            int_hsize <= dmem_hsize;
                            
                            int_hready <= 2'b01;
                            int_source <= 1;
                            
                            delay_mode <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 0;
                            dmem_hready <= 0;
                        end else begin
                            int_dmem_haddr_read <= dmem_haddr;
                            int_dmem_htrans <= dmem_htrans;
                            inst_addr <= dmem_haddr[13:2];
                            inst_rwn <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 0;
                            dmem_hready <= 1;
                        end
                    end
                    
                    // Switch arbitration mode
                    favor_imem <= !favor_imem;
                end else begin
                    // Data memory arbitration
                    if (favor_dmem) begin
                        // DMEM AHB to data communication
                        if (dmem_hwrite) begin
                            int_haddr <= dmem_haddr;
                            int_hsize <= dmem_hsize;
                            
                            int_hready <= 2'b01;
                            int_source <= 1;
                            
                            delay_mode <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 0;
                            dmem_hready <= 0;
                        end else begin
                            int_dmem_haddr_read <= dmem_haddr;
                            int_dmem_htrans <= dmem_htrans;
                            data_addr <= dmem_haddr[13:2];
                            data_rwn <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 0;
                            dmem_hready <= 1;
                        end
                    end else begin
                        // IMEM AHB to data communication
                        if (imem_hwrite) begin
                            int_haddr <= imem_haddr;
                            int_hsize <= imem_hsize;
                            
                            int_hready <= 2'b10;
                            int_source <= 0;
                            
                            delay_mode <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 0;
                            dmem_hready <= 0;
                        end else begin
                            int_imem_haddr_read <= imem_haddr;
                            int_imem_htrans <= imem_htrans;
                            data_addr <= imem_haddr[13:2];
                            inst_rwn <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 1;
                            dmem_hready <= 0;
                        end
                    end
                    
                    // Switch arbitration mode
                    favor_dmem <= !favor_dmem;
                end
            end else begin
                // Register arbitration
                if (favor_reg) begin
                    // DMEM AHB to register communication
                    if (dmem_hwrite) begin
                        int_haddr <= dmem_haddr;
                        int_hsize <= dmem_hsize;
                        
                        int_hready <= 2'b01;
                        int_source <= 1;
                        
                        delay_mode <= 1;
                        
                        // Responding to the buses
                        imem_hready <= 0;
                        dmem_hready <= 0;
                    end else begin
                        int_dmem_haddr_read <= dmem_haddr;
                        int_dmem_htrans <= dmem_htrans;
                        reg_addr <= dmem_haddr[5:2];
                        reg_rwn <= 1;
                        
                        // Responding to the buses
                        imem_hready <= 0;
                        dmem_hready <= 1;
                    end
                end else begin
                    // IMEM AHB to register communication
                    if (imem_hwrite) begin
                        int_haddr <= imem_haddr;
                        int_hsize <= imem_hsize;
                        
                        int_hready <= 2'b10;
                        int_source <= 0;
                        
                        delay_mode <= 1;
                        
                        // Responding to the buses
                        imem_hready <= 0;
                        dmem_hready <= 0;
                    end else begin
                        int_imem_haddr_read <= imem_haddr;
                        int_imem_htrans <= imem_htrans;
                        reg_addr <= imem_haddr[5:2];
                        reg_rwn <= 1;
                        
                        // Responding to the buses
                        imem_hready <= 1;
                        dmem_hready <= 0;
                    end
                end
                
                // Switch arbitration mode
                favor_reg <= !favor_reg;
            end
            
            // Assuming the signal response is always OK
            imem_hresp <= 0;
            dmem_hresp <= 0;
        end else begin
            // Instruction Memory bus routing
            if (imem_htrans == 2'b10) begin
                // Checking for register communication
                if (imem_haddr[15] == 0) begin
                    // Checking for instruction or data communication
                    if (imem_haddr[14] == 0) begin
                        // Instruction communication
                        if (imem_hwrite) begin
                            int_haddr <= imem_haddr;
                            int_hsize <= imem_hsize;
                            
                            int_hready <= 2'b11;
                            int_source <= 0;
                            
                            delay_mode <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 0;
                            dmem_hready <= 0;
                        end else begin
                            int_imem_haddr_read <= imem_haddr;
                            int_imem_htrans <= imem_htrans;
                            inst_addr <= imem_haddr[13:2];
                            inst_rwn <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 1;
                            dmem_hready <= 1;
                        end
                    end else begin
                        // Data communication
                        if (imem_hwrite) begin
                            int_haddr <= imem_haddr;
                            int_hsize <= imem_hsize;
                            
                            int_hready <= 2'b11;
                            int_source <= 0;
                            
                            delay_mode <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 0;
                            dmem_hready <= 0;
                        end else begin
                            int_imem_haddr_read <= imem_haddr;
                            int_imem_htrans <= imem_htrans;
                            data_addr <= imem_haddr[13:2];
                            data_rwn <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 1;
                            dmem_hready <= 1;
                        end
                    end
                end else begin
                    // Register communication
                    if (imem_hwrite) begin
                        int_haddr <= imem_haddr;
                        int_hsize <= imem_hsize;
                        
                        int_hready <= 2'b11;
                        int_source <= 0;
                        
                        delay_mode <= 1;
                        
                        // Responding to the buses
                        imem_hready <= 0;
                        dmem_hready <= 0;
                    end else begin
                        int_imem_haddr_read <= imem_haddr;
                        int_imem_htrans <= imem_htrans;
                        reg_addr <= imem_haddr[5:2];
                        reg_rwn <= 1;
                        
                        // Responding to the buses
                        imem_hready <= 1;
                        dmem_hready <= 1;
                    end
                end
            end
            
            // Data Memory bus routing
            if (dmem_htrans == 2'b10) begin
                // Checking for register communication
                if (dmem_haddr[15] == 0) begin
                    // Checking for instruction or data communication
                    if (dmem_haddr[14] == 0) begin
                        // Instruction communication
                        if (dmem_hwrite) begin
                            int_haddr <= dmem_haddr;
                            int_hsize <= dmem_hsize;
                            
                            int_hready <= 2'b11;
                            int_source <= 1;
                            
                            delay_mode <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 0;
                            dmem_hready <= 0;
                        end else begin
                            int_dmem_haddr_read <= dmem_haddr;
                            int_dmem_htrans <= dmem_htrans;
                            inst_addr <= dmem_haddr[13:2];
                            inst_rwn <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 1;
                            dmem_hready <= 1;
                        end
                    end else begin
                        // Data communication
                        if (dmem_hwrite) begin
                            int_haddr <= dmem_haddr;
                            int_hsize <= dmem_hsize;
                            
                            int_hready <= 2'b11;
                            int_source <= 1;
                            
                            delay_mode <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 0;
                            dmem_hready <= 0;
                        end else begin
                            int_dmem_haddr_read <= dmem_haddr;
                            int_dmem_htrans <= dmem_htrans;
                            data_addr <= dmem_haddr[13:2];
                            data_rwn <= 1;
                            
                            // Responding to the buses
                            imem_hready <= 1;
                            dmem_hready <= 1;
                        end
                    end
                end else begin
                    // Register communication
                    if (dmem_hwrite) begin
                        int_haddr <= dmem_haddr;
                        int_hsize <= dmem_hsize;
                        
                        int_hready <= 2'b11;
                        int_source <= 1;
                        
                        delay_mode <= 1;
                        
                        // Responding to the buses
                        imem_hready <= 0;
                        dmem_hready <= 0;
                    end else begin
                        int_dmem_haddr_read <= dmem_haddr;
                        int_dmem_htrans <= dmem_htrans;
                        reg_addr <= dmem_haddr[5:2];
                        reg_rwn <= 1;
                        
                        // Responding to the buses
                        imem_hready <= 1;
                        dmem_hready <= 1;
                    end
                end
            end
            
            // When not arbitrating, resp should always be OK
            imem_hresp <= 0;
            dmem_hresp <= 0;
        end
    end
end

endmodule

