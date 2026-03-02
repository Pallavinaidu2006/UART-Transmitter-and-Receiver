`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2025 10:24:28
// Design Name: 
// Module Name: receiver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module receiver(
    input clk_fpga,
    input rst,
    input RxD,
    output [7:0] RxD_data
    );
    
    reg shift;
    reg state,next_state;
    reg [3:0] bit_counter;
    reg [1:0] sample_counter;//frequency is 4times baudrate
    reg [13:0] baudrate_counter;//BR 9600
    reg [9:0] rxshift_reg;//[8:1]  data bits  and start,stop
    reg clr_bitcounter, inc_bitcounter,inc_samplecounter, clr_samplecounter;
    
    parameter clk_freq=100_000_000;
    parameter baud_rate=9_600;
    parameter div_sample=4;
    parameter div_counter= clk_freq/(baud_rate*div_sample);
    parameter mid_sample=(div_sample/2);
    parameter div_bit=10;
    
    assign RxD_data= rxshift_reg[8:1]; //databits
    
    always @(posedge clk_fpga)
    begin
    if(rst) begin
    state<=0;
    bit_counter<=0;
    baudrate_counter<=0;
    sample_counter<=0;
    end
    
    else begin
    baudrate_counter<=baudrate_counter+1;
    if (baudrate_counter>=div_counter-1) begin//if counter reach BR with sampling
    baudrate_counter <= 0;
    state<=next_state;
    
    if (shift)// if shift, then load the receiving data
    rxshift_reg<={RxD, rxshift_reg[9:1]};
    
    if(clr_samplecounter)
    sample_counter<=0;
    
    if(inc_samplecounter)
    sample_counter<=sample_counter+1;
    
    if(clr_bitcounter) 
    bit_counter<=0;
    
    if(inc_bitcounter)
    bit_counter<=bit_counter+1;
    
    end
    end
    end
    
    
    //fsm
    always @(posedge clk_fpga) begin
    shift<=0;
    clr_samplecounter<=0;
    inc_samplecounter<=0;
    clr_bitcounter<=0;
    inc_bitcounter<=0;
    next_state<=0;
    
    case(state)
    0: if(RxD)//  RxD should be low to start transitiion
    next_state<=0;
    else begin
    next_state<=1;
    clr_bitcounter<=1;
    clr_samplecounter<=1;
    end
    
    1: begin
    next_state<=1;
    if(sample_counter==mid_sample-1) shift<=1; //if samplecounter is 1, trigger shift
    if(sample_counter==div_sample-1) begin//if sample counter is 3 as 4
    if(bit_counter==div_bit-1) begin//check if bitcounter is [9:0] or not
    
    // now all the bits are received next the state should be idle again
    
    next_state<=0;
    end
    inc_bitcounter<=1;
    clr_samplecounter<=1;
    end
    else
    inc_samplecounter<=1;
    end
    
    default: next_state<=0;
    endcase
    
    end
  
endmodule
