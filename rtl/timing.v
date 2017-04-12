`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// The College of New Jersey
// Engineer: Hunter Dubel
//
// Create Date: 10/09/2016 08:44:25 PM
// Module Name: timing
// Project Name: RISC-V ASIC Microcontroller
// Target Devices: Artix-7 Nexys 4
//////////////////////////////////////////////////////////////////////////////////
 
 
module timing(clk, reset, ro_trig_start, ro_trig_halt, ro_mode, ro_termcount, rf_status, rf_currcount, rf_int);

    input clk;      //Master Clock
    input reset;    //Reset
    
    input ro_trig_start;
    input ro_trig_halt;
    input ro_mode;
    input [31:0] ro_termcount;
    
    output reg rf_status;
    output reg [31:0] rf_currcount = 0;
    output reg rf_int;

    always @(posedge clk)
    begin          
        //Reset Triggers
        if (reset)
            begin
                rf_status <= 0;
                rf_currcount <= 0;
                rf_int <= 0;
            end
        else begin
	    	if (rf_int)
            	rf_int <= 1'b0;

            if (ro_trig_start && !rf_status)  //On Trigger Start
                begin
                    rf_status <= 1'b1;
                    rf_currcount <= 0;
                end
            else if (ro_trig_halt) begin //On Trigger Halt
                rf_status <= 0;
            end
            
	        if (rf_status)	//If Status is Running
	        begin
	            if (ro_mode) //If Continuous
	            begin 
	                if (rf_currcount == ro_termcount)
	                begin
	                    rf_int <= 1'b1;
	                    rf_currcount <= 1'b0;
	                end else
	                rf_currcount <= rf_currcount + 1'b1;
	            end else //One Shot
	            begin
	                if (rf_currcount == ro_termcount)
	                begin
	                    rf_int <= 1'b1;
	                    rf_status <= 0;
	                end else
	                rf_currcount <= rf_currcount + 1'b1;
	        	end 
	    	end
    	end
    end
endmodule