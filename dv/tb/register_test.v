`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: The College of New Jersey
// Engineer: Hunter Dubel
//
// Create Date:   13:44:56 11/03/2016
// Module Name:   register_test.v
// Project Name:  RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
////////////////////////////////////////////////////////////////////////////////

module register_test;

	// Inputs
	reg clk;
	reg reset;
	reg [4:2] addr;
	reg [3:0] wben;
	reg r_wn;
	reg [31:0] wdata;
	reg [15:0] ro_gpio_pinstate;

	// Outputs
	wire [31:0] rdata;
	wire [15:0] rf_gpio_datareg;
	wire [15:0] rf_gpio_tristate;
	wire [15:0] rf_gpio_interrupt_mask;
	
	integer count;

	// Instantiate the Unit Under Test (UUT)
	register uut (
		.clk(clk), 
		.reset(reset), 
		.addr(addr), 
		.wben(wben), 
		.r_wn(r_wn), 
		.wdata(wdata), 
		.ro_gpio_pinstate(ro_gpio_pinstate), 
		.rdata(rdata), 
		.rf_gpio_datareg(rf_gpio_datareg), 
		.rf_gpio_tristate(rf_gpio_tristate), 
		.rf_gpio_interrupt_mask(rf_gpio_interrupt_mask)
	);

    initial begin
            clk = 0;
            count = 0;
            reset = 0;
            addr = 0;
            wben = 0;
            r_wn = 0;
            wdata = 0;
            ro_gpio_pinstate = 0;
    end
    
    always @ (posedge clk)
    begin
        //Check Writing
        addr = count;
        wdata = count;
        count = count +1;
        if (addr == 3'b111) begin
            if (wben == 4'b1111) begin
                if (r_wn == 0) begin
                    r_wn = 1;
                end
                else begin
                    r_wn = 0;
                end
                wben = 0;
            end
            else begin
                count = 0;
                wben = wben + 1;
            end
        end
    end
    
    initial begin
        while(1) begin
            #5 clk = ~clk;
        end
    end
    
    endmodule

