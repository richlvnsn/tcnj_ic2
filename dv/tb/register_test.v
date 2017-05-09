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
	reg [5:2] addr;
	reg [3:0] wben;
	reg r_wn;
	reg [31:0] wdata;
	reg [15:0] ro_gpio_pinstate;
	reg ro_mode;
	reg [31:0] ro_termcount;

	// Outputs
	wire [31:0] rdata;
	wire [15:0] rf_gpio_datareg;
	wire [15:0] rf_gpio_tristate;
	wire [15:0] rf_gpio_interrupt_mask;
	wire rf_trig_start;
	wire rf_trig_halt;
	wire rf_status;
	wire [31:0] rf_currcount;
	
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
		.rf_mode(rf_mode),
		.rf_termcount(rf_termcount), 
		.rdata(rdata), 
		.rf_gpio_datareg(rf_gpio_datareg), 
		.rf_gpio_tristate(rf_gpio_tristate), 
		.rf_gpio_interrupt_mask(rf_gpio_interrupt_mask),
		.rf_trig_start(rf_trig_start),
		.rf_trig_halt(rf_trig_halt),
		.ro_status(ro_status),
		.ro_currcount(ro_currcount)
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
            ro_mode = 0;
            ro_termcount = 0;
    end
    
    always @ (posedge clk)
    begin
        //Check Writing
        addr = count;
        wdata = count;
        count = count +1;
        if (addr == 4'b1101) begin
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

