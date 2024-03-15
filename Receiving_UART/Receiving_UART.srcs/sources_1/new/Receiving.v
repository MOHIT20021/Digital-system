`timescale 1ns / 10ps
//parameter bit_size= 8;   // same time change reg_index range so it can accomadoate the bit size enter over here

module Receiving(
input clk,
input Rx_data,reset,
output reg [7:0] Data,
output reg is_received  
);


parameter max_baud_count=10417;
parameter IDEAL =2'b00;
parameter start_bit = 2'b01;
parameter stop_bit = 2'b10;

reg [1:0]STATE;
reg [14:0]Baud_counter=0;
reg [31:0] reg_index;     // change here after changing bit_size if needed


always@(posedge clk,posedge reset)
begin 
if (reset)
begin
Data<=0;
Baud_counter<=0;
reg_index<=0;
is_received <=0;
end
else
begin
case(STATE)
IDEAL : 
    begin 
    is_received<=0;
    reg_index<=0;
    if (Rx_data==0)
        begin 
        if (Baud_counter<(max_baud_count)/2)
            begin 
            Baud_counter<=Baud_counter+1;
            is_received<=0;
            STATE <=IDEAL;
            end
        else 
            begin
            STATE<=start_bit;
            Baud_counter<=0;
            end
        end
    end
        
start_bit :
      begin
      if (Baud_counter <(max_baud_count))
          begin
          Baud_counter <=Baud_counter+1;
          STATE<=start_bit;
          end
      else
          begin
            Baud_counter <= 0;
            Data[reg_index] <= Rx_data;
          if (reg_index<7)
              begin
              reg_index <= reg_index+1;
              STATE <= start_bit;
              end
          else
              begin
              is_received <= 0;
              reg_index <= 0;
              Baud_counter <= 0;
              STATE <= stop_bit;
              end
           end
      end

stop_bit :
        begin
        if (Baud_counter <(max_baud_count))
            begin
            Baud_counter <= Baud_counter+1;
            STATE <= stop_bit;
            end
        else 
            begin
            Baud_counter <=0;
            STATE <= IDEAL;
            is_received <=1;
            end
        end            
default :
    begin
    STATE <= IDEAL;
    Baud_counter <=0;
    reg_index <=0;
    is_received <=0;
    end
endcase  
end
end
endmodule


