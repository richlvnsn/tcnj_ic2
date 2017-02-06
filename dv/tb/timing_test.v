`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The College of New Jersey
// Engineer: Hunter Dubel
// 
// Create Date: 02/05/2017 11:24:23 PM
// Module Name: timing_test
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
//////////////////////////////////////////////////////////////////////////////////


module timing_test(

    //Inputs
    reg clk;
    reg reset;
    reg ro_trig_start;
    reg ro_trig_halt;
    reg [31:0] ro_termcount;
    
    //Outputs
    wire rf_status;
    wire [31:0] rf_currcount;
    wire rf_int;
    
    timing uut (
        .clk(clk),
        .reset(reset),
        .ro_trig_start(ro_trig_start),
        .ro_trig_halt(ro_trig_halt),
        .ro_termcount(ro_termcount),
        .rf_status(rf_status),
        .rf_currcount(rf_currcount),
        .rf_int(rf_int) 
    );
    
    initial begin
        clk = 0;
        reset = 0;
        ro_trig_start = 0;
        ro_trig_halt = 0;
        ro_mode = 0;
        ro_termcount = 0;
    end
    
    always @ (posedge clk)
    begin
    end
    
    initial begin
        while(1) begin
            #5 clk = ~clk;
            end
     end
    
endmodule
