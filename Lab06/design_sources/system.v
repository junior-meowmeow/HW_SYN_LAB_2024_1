`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 12:40:40
// Design Name: 
// Module Name: system
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


module system(
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output wire RsTx, //uart (USB-RS232)
    input wire RsRx, //uart (USB-RS232)
    input clk
    );
    
    wire [7:0] last_valid_data;
    
    // UART Module (Using USB-RS232)
    uart_rs232 uart(last_valid_data, RsTx, RsRx, clk);
    
    // Seven Segment
    reg [7:0] char3,char2,char1,char0; // left to right
    
    wire an0,an1,an2,an3; // anode for seven-segment
    assign an={an3,an2,an1,an0};
    
    // Clock (For TDM) 10ns * 2^19 ~ 5ms
    // (All four digits should be driven once every 1-16 ms)
    wire tdmClk;
    clkDividerN #(19) tdmClkDivider(tdmClk, clk);
    
    // Seven Segment Module
    quadSevenSeg sevenSegment(seg,dp,an0,an1,an2,an3,char0,char1,char2,char3,tdmClk);
    
    // Segment Data Changes
    always @(posedge tdmClk) begin
        char0 = last_valid_data;
        // char 1-3 is not used rignt now
        char1 = " ";
        char2 = " ";
        char3 = " ";
    end
    
endmodule
