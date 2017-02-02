`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// The College of New Jersey
// Engineer: Hunter Dubel
//
// Create Date: 10/09/2016 08:44:25 PM
// Module Name: register
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
//////////////////////////////////////////////////////////////////////////////////
 
module register(clk, reset, addr, wben, r_wn, wdata, ro_gpio_pinstate, rdata, rf_gpio_datareg, rf_gpio_tristate, rf_gpio_interrupt_mask, rf_trig_start, rf_trig_halt, ro_mode, ro_termcount, rf_status, rf_currcount);

input clk;                                  //Master Clock
input reset;                                //Reset

input [ 5:2] addr;                          // 4 bits-wide register address
                                            // Can address 12 register, each 32-bits (total register space is 32-bytes)
                                            // One address specifies one 32-bit register
input [ 3:0] wben;			                // write byte enable bits                            
input r_wn;      			                // Read-WriteNOT
input [31:0] wdata;                         // the data to write
input [15:0] ro_gpio_pinstate;              // Pin state input

//Register inputs from Timing Block
input ro_mode;
input [31:0] ro_termcount;

output reg [31:0] rdata;                    //Data read from the register

//GPIO Outputs
output reg [15:0] rf_gpio_datareg;
output reg [15:0] rf_gpio_tristate;
output reg [15:0] rf_gpio_interrupt_mask;

//Timing Block Outputs
output reg rf_trig_start;
output reg rf_trig_halt;
output reg rf_status;
output reg [31:0] rf_currcount;

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
            rf_trig_start <= 0;
            rf_trig_halt <= 0;
            rf_status <= 0;
            rf_currcount <= 0;
            rdata <= 0;
        end 
    else begin
        if (r_wn)                           //Reading Enabled
            begin
                case(addr)
                    4'b0000: rdata <= ro_cname;
                    4'b0001: rdata <= ro_cversion;
                    4'b0010: rdata <= {16'b0, rf_gpio_tristate}; //Since these are 16 bits, we need to pad them.
                    4'b0011: rdata <= {16'b0, ro_gpio_pinstate};
                    4'b0100: rdata <= {16'b0, rf_gpio_interrupt_mask};
                    4'b0101: rdata <= {16'b0, rf_gpio_datareg};
                    4'b0110: rdata <= rf_scratch;
                    4'b0111: rdata <= {31'b0, rf_trig_start};
                    4'b1000: rdata <= {31'b0, rf_trig_halt};
                    4'b1001: rdata <= {31'b0, ro_mode};
                    4'b1010: rdata <= ro_termcount;
                    4'b1011: rdata <= {31'b0, rf_status};
                    4'b1100: rdata <= rf_currcount;
                endcase
            end
        else                          //Write Enabled
            begin   
                case(addr)
                    4'b0010: begin
                        if (wben[0])
                            rf_gpio_tristate[7:0] <= wdata[7:0];
                        if (wben[1])
                            rf_gpio_tristate[15:8] <= wdata[15:8];
                    end

                    4'b0100: begin
                        if (wben[0])
                            rf_gpio_interrupt_mask[7:0] <= wdata[7:0];
                        if (wben[1])
                            rf_gpio_interrupt_mask[15:8] <= wdata[15:8];
                    end

                    4'b0101: begin
                        if (wben[0])
                            rf_gpio_datareg[7:0] <= wdata[7:0];
                        if (wben[1])
                            rf_gpio_datareg[15:8] <= wdata[15:8];
                    end

                    4'b0110: begin
                        if (wben[0])
                            rf_scratch[7:0] <= wdata[7:0];
                        if (wben[1])
                            rf_scratch[15:8] <= wdata[15:8];
                        if (wben[2])
                            rf_scratch[23:16] <= wdata[23:16];
                        if (wben[3])
                            rf_scratch[31:24] <= wdata[31:24];
                    end
                    
                    4'b0111: begin
                        if (wben[0])
                            rf_trig_start <= wdata[0];
                        end
                        
                    4'b1000: begin
                        if (wben[0])
                            rf_trig_halt <= wdata[0];
                        end
                    
                    4'b1011: begin
                        if (wben[0])
                            rf_status <= wdata[0];
                        end
                    
                    4'b1100: begin
                       if (wben[0])
                           rf_currcount[7:0] <= wdata[7:0];
                       if (wben[1])
                           rf_currcount[15:8] <= wdata[15:8];
                       if (wben[2])
                           rf_currcount[23:16] <= wdata[23:16];
                       if (wben[3])
                           rf_currcount[31:24] <= wdata[31:24];
                   end 
                endcase
            end
    end

endmodule