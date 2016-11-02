`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: The College of New Jersey
// Engineer: Hunter Dubel
//
// Create Date:   12:26:10 04/30/2015
// Design Name:   register_test
// Module Name:   register_test.v
// Project Name:  register_test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: register_test
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module register_test();

    //Inputs
    reg clock, reset;
    reg [4:2] addr;
    reg [3:0] wben;
    reg [31:0] r_wn, wdata;
    reg [15:0] ro_gpio_pinstate;

    //Outputs
    wire [31:0] rdata;
    wire [15:0] rf_gpio_tristate, rf_gpio_datareg, rf_gpio_interrupt_mask;
    
    register uut(
        .clock(clock),
        .reset(reset),
        .addr(addr),
        .wben(wben),
        .r_wn(r_wn),
        .wdata(wdata),
        .ro_gpio_pinstate(ro_gpio_pinstate),
        .rdata(rdata),
        .rf_gpio_tristate(rf_gpio_tristate),
        .rf_gpio_datareg(rf_gpio_datareg),
        .rf_gpio_interrupt_mask(rf_gpio_interrupt_mask)
        );

    initial
    begin
        clock = 0;
        reset = 1;
        addr = 0;
        wben = 0;
        r_wn = 1;
        wdata = 0;
        ro_gpio_pinstate = 0;

        #50
        reset = 0;

        #100 //First Event
        addr = 3'b000;

        #100 //Second Event
        addr = 3'b001;

    end

    always
        #5 clock = ! clock;

endmodule

