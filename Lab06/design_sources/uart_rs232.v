`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 12:50:22
// Design Name: 
// Module Name: uart_rs232
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


module uart_rs232(
    // save data for seven segment
    output reg [7:0] last_valid_data,
    output RsTx,
    input RsRx,
    input clk
    );
    
    reg signal_to_tx, last_receive;
    reg [7:0] data_to_tx;
    wire [7:0] data_from_rx;
    wire finish_send, finish_receive, baudrateClk;
    
    clkToBaudrate baudrateClockDivider(baudrateClk, clk);
    rs232_rx receiver(finish_receive, data_from_rx, RsRx, baudrateClk);
    rs232_tx transmitter(finish_send, RsTx, data_to_tx, signal_to_tx, baudrateClk);
    
    always @(posedge baudrateClk) begin
        if (signal_to_tx) begin
        // need only 1 bit signal to start sending
            signal_to_tx = 0;
        end
        if (~last_receive & finish_receive) begin
        // if finished recieve signal change from 0 -> 1 = start sending
        // (our system protocol)
            data_to_tx = data_from_rx;
            // send start signal to tx
            signal_to_tx = 1;
            // save data for seven segment
            last_valid_data = data_to_tx;
        end
        // keep track of receive signal
        last_receive = finish_receive;
    end
    
endmodule
