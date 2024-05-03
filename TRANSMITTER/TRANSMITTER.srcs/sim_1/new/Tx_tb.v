`timescale 1ns / 10ps


module Tx_tb(
);
reg slow_clk=0;
reg clk=0;

reg reset,send;

reg [7:0] data_in;

wire tx_out;
wire is_complete;



Transmitter uut(.clk(slow_clk),.reset(reset),.data_in(data_in),.send(send),.tx_out(tx_out),.is_complete(is_complete));

always #10 clk = ~clk;
always #1 slow_clk = ~slow_clk;


initial
begin 

reset=1; data_in=8'b10101010;send=0;#5;

reset=0; data_in=8'b10101010;send=0;#2;
reset=0; data_in=8'b10101010;send=1;#120;
//reset=0; data_in=8'b10101010;send=1;#100;

//reset=0; data_in=8'b10101010;send=0;#50;
reset=1; data_in=8'b10110110;send=0;#5;

reset=0; data_in=8'b10110110;send=0;#2;
reset=0; data_in=8'b10110110;send=1;#120;

$finish();
end
endmodule
