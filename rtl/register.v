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
 
 
module register(clk, reset, addr, wben, r_wn, wdata, ro_gpio_pinstate, rdata, rf_gpio_datareg, rf_gpio_tristate, rf_gpio_interrupt_mask);

input clk;                                  //Master Clock
input reset;                                //Reset

input [ 4:2] addr;                          // 3 bits-wide register address
                                            // Can address 8 register, each 32-bits (total register space is 32-bytes)
                                            // One address specifies one 32-bit register
input [ 3:0] wben;			                // write byte enable bits                            
input r_wn;      			                // Read-WriteNOT
input [31:0] wdata;                         // the data to write
input [15:0] ro_gpio_pinstate;              // Pin state input

output reg [31:0] rdata;                    //Data read from the register

//GPIO Outputs
output reg [15:0] rf_gpio_datareg;
output reg [15:0] rf_gpio_tristate;
output reg [15:0] rf_gpio_interrupt_mask;

reg [31:0] ro_cname = 32'h48524a44;        // Read-only chip name (team initials, HRJD)
reg [31:0] ro_cversion = 32'h00000001;     // Read-only chip info, 8 bits each: Major, Minor, Bugfix, Development
reg [31:0] rf_scratch;

always @(posedge clk)
    if (reset)
        begin
            rf_gpio_tristate <= 0; 
            rf_gpio_datareg <= 0;
            rf_gpio_interrupt_mask <= 0;
            rf_scratch <= 0;
            rdata <= 0;
        end 
    else begin
        if (r_wn)                           //Reading Enabled
            begin
                case(addr)
                    3'b000: rdata <= ro_cname;
                    3'b001: rdata <= ro_cversion;
                    3'b010: rdata <= {16'b0, rf_gpio_tristate}; //Since these are 16 bits, we need to pad them.
                    3'b011: rdata <= {16'b0, ro_gpio_pinstate};
                    3'b100: rdata <= {16'b0, rf_gpio_interrupt_mask};
                    3'b101: rdata <= {16'b0, rf_gpio_datareg};
                    3'b110: rdata <= rf_scratch;
                endcase
            end
        else                          //Write Enabled
            begin   
                case(addr)
                    3'b010: begin
                        if (wben[0]
                            rf_gpio_tristate[7:0] <= wdata[7:0];
                        if (wben[1])
                            rf_gpio_tristate[15:8] <= wdata[15:8];
                    end

                    3'b100: begin
                        if (wben[0])
                            rf_gpio_interrupt_mask[7:0] <= wdata[7:0];
                        if (wben[1])
                            rf_gpio_interrupt_mask[15:8] <= wdata[15:8];
                    end

                    3'b101: begin
                        if (wben[0])
                            rf_gpio_datareg[7:0] <= wdata[7:0];
                        if (wben[1])
                            rf_gpio_datareg[15:8] <= wdata[15:8];
                    end

                    3'b110: begin
                        if (wben[0])
                            rf_scratch[7:0] <= wdata[7:0];
                        if (wben[1])
                            rf_scratch[15:8] <= wdata[15:8];
                        if (wben[2]
                            rf_scratch[23:16] <= wdata[23:16];
                        if (wben[3])
                            rf_scratch[31:24] <= wdata[31:24];
                    end
                endcase
            end
    end

endmodule