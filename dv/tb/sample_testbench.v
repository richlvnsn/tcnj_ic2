`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:26:10 04/30/2015
// Design Name:   ram_1024x32
// Module Name:   H:/xilinx/ram_1024x32/tb_ram_1024x32.v
// Project Name:  ram_1024x32
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ram_1024x32
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_ram_1024x32;

    // Inputs
    reg CLOCK;
    reg [10:0] ADDR;
    wire [31:0] DATA_OUT;

    reg RESET;
    
    reg [31:0] DATA_PATTERN;
    reg [31:0] DATA_PATTERN_d1;  // Delayed by 1 clock cycle
    
    always @ (posedge CLOCK)
    begin
    
        if (RESET || ADDR[9:0] == 10'h3FF)
        begin
            DATA_PATTERN        <= 32'b0;  // Init to zero
            DATA_PATTERN_d1     <= 32'b0;  // Init to zero
        end
        else
        begin
            DATA_PATTERN[31] <= ~ DATA_PATTERN[0];      // Make Johnson counter by rotating
                                                        // complement of LSB back to MSB
                                                        
            DATA_PATTERN[30:0] <= DATA_PATTERN[31:1];   // Shift the rest of the bits right
            
            DATA_PATTERN_d1 <= DATA_PATTERN;            // Delay 32-bits of data by 1 clock cycle, for checking reads
        end
        
    end
    
    always @ (posedge CLOCK)
    begin
    
        if (RESET)
            ADDR <= 10'b0;
        
        else
            ADDR <= ADDR + 1;
    end
    
    always @ (posedge CLOCK)    
    begin
    
        if (~RESET)
        begin
            if (ADDR[10])
			begin
                // When ADDR[10] is '1', then we're in the reading phase of the test, and we can check the
                // module output against the expected result.
                if (ADDR[9:0] != 10'd0)
                begin
                    if (DATA_OUT === DATA_PATTERN_d1)
                    begin
                        // Passed this actual/expected data comparison
                        $display ("ADDR=%H pass", ADDR[9:0]-1);
                    end
                    else
                    begin
                        // Verification failure due to data mismatch
                        $display ("Failed at ADDR=%H, expected %b, got %b", ADDR[9:0]-1, DATA_PATTERN_d1, DATA_OUT);
                        $display ("\n\n*** FAIL ***");
                        $finish;
                    end
                end
                if (ADDR == 11'h7FF)
                begin
                    // If we've made it to the last comparison then the entire test passed

                    #1500;                          // Allow 1.5 more clock cycles, for last cycle to finish
                    $display ("\n\n*** PASS ***");
                    $finish;
                end
            end
        end
    end

    // Instantiate the Unit Under Test (UUT)
    ram_1024x32 uut (
        .CLOCK(CLOCK), 
        .ADDR(ADDR[9:0]), 
        .WRITE_EN(~ADDR[10]), 
        .DATA_IN(DATA_PATTERN), 
        .DATA_OUT(DATA_OUT)
    );

    
    initial
    begin
        CLOCK = 1;
        
        while (1)
        begin
            #500;
            CLOCK = ~ CLOCK;
        end
    end

    initial
    begin
        RESET = 1;
        #1500;
        RESET = 0;
    end
 
endmodule

