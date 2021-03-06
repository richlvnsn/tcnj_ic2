`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The College of New Jersey
// Engineer: Richard Levenson
// 
// Create Date: 10/04/2016 04:52:21 PM
// Module Name: spi_loader
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
//////////////////////////////////////////////////////////////////////////////////

module spi_loader(
    input clk,
    input reset,
    input miso,
    input spi_hready,
    input spi_hresp,
    input [31:0] spi_hrdata,
    output core_rst,
    output reg spi_clk,
    output reg mosi,
    output reg ss,
    output reg [31:0] spi_haddr,
    output reg spi_hwrite,
    output [2:0] spi_hsize,
    output [2:0] spi_hburst,
    output spi_hmastlock,
    output [3:0] spi_hprot,
    output [1:0] spi_htrans,
    output reg [31:0] spi_hwdata
    );
    
    ////////////////////////
    // SPI Interface
    ////////////////////////
    wire spi_pipe_en;
    reg [4:0] spi_div_ctr;
    reg [18:0] spi_bit_ctr;
    reg [7:0] cmd_byte = 8'h3;
    reg _mosi;
    
    assign spi_pipe_en = (spi_div_ctr == 0);
    
    // Update SPI clk, mosi, and SPI select (ss)
    always @ (posedge clk)
        if (!reset)
        begin
            spi_clk <= 1;
            mosi <= 0;
            ss <= 1;
        end
        else
        begin
            spi_clk <= (spi_div_ctr < 10);
            mosi <= _mosi;
            ss <= 0;
        end 
    
    // Counter used to divide the master clock by 20
    always @(posedge clk) 
    begin
        if (!reset)
        begin
            spi_div_ctr <= 0;
        end else if (spi_div_ctr < 19)
        begin
            spi_div_ctr <= spi_div_ctr + 1;
        end else
        begin
            spi_div_ctr <= 0;
        end
    end
    
    // Counter used to track the number of bits sent/received over the SPI EEPROM
    always @ (posedge clk)
    begin
        if (!reset) 
        begin
            spi_bit_ctr <= 0;
        end else
        begin
            if (spi_pipe_en && !core_rst) spi_bit_ctr <= spi_bit_ctr + 1;
            //if (spi_bit_ctr >= 262168) spi_bit_ctr <= 0; //max value is (1B instruction + 2B address + 32KB data)*8 bits/byte = 262168
        end
    end
    
    // Sends the READ instruction to the EEPROM
    always @ (posedge clk)
    begin
        if (!reset)
            _mosi <= 0;
        else if (spi_pipe_en)
            if (spi_bit_ctr < 8)
                _mosi <= cmd_byte[7-spi_bit_ctr]; // READ instruction
            else
                _mosi <= 1'b0;
    end
    
    reg [7:0]   cur_byte_in;
    reg [31:0]  cur_word_in;
    reg [31:0]  pipe_reg;
    reg [15:0]  parse_num_bytes;
    reg [15:0]  parse_start_addr;
    
    // De-serializes and processes input data
    always @ (posedge clk)
    begin
        if (!reset) 
        begin
            cur_byte_in <= 0;
            cur_word_in <= 0;
            pipe_reg <= 0;
            parse_num_bytes <= 0;
            parse_start_addr <= 0;
            spi_haddr <= 32'h00000000 - 4;  // Default to start address 0x200
            spi_hwdata <= 0;
            spi_hwrite <= 0;
        end else 
        begin
            // Handle AHB hwrite and hwdata signals
            if (spi_hready)    // Wait for ready signal from slave
            begin
                if (spi_hwrite)     // Wait for write signal
                begin
                    spi_hwdata <= pipe_reg; // Load write data from pipeline register
                    spi_hwrite <= 0;        // Deassert write signal
                end
            end
            // Parse input from MISO
            if (spi_pipe_en)
            begin
                cur_byte_in[7 - ((spi_bit_ctr - 1) & 8'h7)] <= miso;    // De-serializing into bytes
                if (spi_bit_ctr == (32 + 1))
                    parse_num_bytes[7:0] <= cur_byte_in;    // Setting the lower byte of the half-word containing the number of bytes of data to read
                else if (spi_bit_ctr == (40 + 1))
                    parse_num_bytes[15:8] <= cur_byte_in;   // Setting the upper byte of the half-word containing the number of bytes of data to read
                else if (spi_bit_ctr == (48 + 1))
                    parse_start_addr[7:0] <= cur_byte_in;   // Setting the lower byte of the half-word containing the data start address
                else if (spi_bit_ctr == (56 + 1))
                    parse_start_addr[15:8] <= cur_byte_in;  // Setting the upper byte of the half-word containing the data start address
                else if (spi_bit_ctr == (64 + 1))
                    cur_word_in[7:0] <= cur_byte_in;        // Parsing the first word of data
                else if (spi_bit_ctr == (72 + 1))
                    cur_word_in[15:8] <= cur_byte_in;
                else if (spi_bit_ctr == (80 + 1))
                    cur_word_in[23:16] <= cur_byte_in;
                else if (spi_bit_ctr == (88 + 1))
                begin
                    cur_word_in[31:24] <= cur_byte_in;
                end
                else if ((spi_bit_ctr > (88 + 1)) && ((spi_bit_ctr-1) % 32 == 0)) //Parsing words of data
                begin
                    cur_word_in[7:0] <= cur_byte_in;    // Parse lowest byte
                    pipe_reg <= cur_word_in;            // Load pipeline register with previous word
                    if (~core_rst) spi_hwrite <= 1;     // Assert hwrite to begin basic AHB-Lite transfer
                                                        // and only allow writing when core is being held at reset
                    spi_haddr <= spi_haddr + 4;
                end
                else if ((spi_bit_ctr > (88 + 1)) && ((spi_bit_ctr-1) % 32 == 8))
                    cur_word_in[15:8] <= cur_byte_in;   // Parse second byte
                else if ((spi_bit_ctr > (88 + 1)) && ((spi_bit_ctr-1) % 32 == 16))
                    cur_word_in[23:16] <= cur_byte_in;  // Parse third byte
                else if ((spi_bit_ctr > (88 + 1)) && ((spi_bit_ctr-1) % 32 == 24))
                begin
                    cur_word_in[31:24] <= cur_byte_in;  // Parse fourth byte
                end
            end
        end
    end
    
    ////////////////////////
    // AHB Interface
    ////////////////////////
    
    assign spi_hburst = 3'd0;   // Single bursts only
    assign spi_hmastlock = 1'd0;    // No master lock
    assign spi_hprot = 4'b0011; // Non-cacheable, non-bufferable, privileged, data access as recommended in the 
                                // ARM AHB-Lite documentation for masters that are not capable of generating accurate 
                                // protection information
    assign spi_hsize = 3'b010;  // AHB-Lite transfer size corresponding to 32-bit Word transfers
    assign spi_htrans = 2'b10;  // Nonesequential AHB Lite transfer type
    
    ////////////////////////
    // Core Reset
    ////////////////////////
    assign core_rst = ~(spi_bit_ctr < (24 + 32 + parse_num_bytes*8));  // 24 bits for MOSI read command and address
                                                                    // plus 32 bits for parse_num_bits and start_addr
                                                                    // plus number of bits to parse
endmodule
