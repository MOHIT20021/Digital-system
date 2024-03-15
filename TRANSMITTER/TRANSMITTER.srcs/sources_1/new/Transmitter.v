`timescale 1ns / 10ps

//parameter bit_size= 8;   // same time change reg_index range so it can accomadoate the bit size enter over here
module Transmitter (
    input clk,             // System clock
    input reset,         // Reset signal (active low)
    input [7:0] data_in,   // Data to be transmitted
    input send_data,
    output reg tx_out,
    output reg is_transmitted   // UART transmit output
);

parameter max_baud_count=10417;
parameter IDEAL =2'b00;
parameter start_bit = 2'b01;
parameter DATA =2'b10;
parameter stop_bit = 2'b11;

reg [1:0]STATE;
reg [14:0]Baud_counter=0;
reg [2:0] reg_index=0;  // change here after changing bit_size if needed

always@(posedge clk ,posedge reset)
begin

if (reset)
begin
tx_out <=1; 
STATE<=IDEAL;
Baud_counter<=0;
reg_index<=0;
is_transmitted<=0;
end
else
begin
case(STATE)
IDEAL :
    begin
    tx_out<=1;
    reg_index<=0;
    if (send_data & !is_transmitted)
        begin
            if (Baud_counter < (max_baud_count)/2)
                    begin
                    Baud_counter <= Baud_counter+1;
                    STATE <= IDEAL;
                    end
            else
                begin
                Baud_counter<=0;
                STATE <= start_bit;

                end
        end
    else
        begin
        STATE<=IDEAL;
        Baud_counter<=0;
        end
            
    end 
start_bit :
    begin
    if (Baud_counter < ( max_baud_count))
        begin
        is_transmitted <=0;
        Baud_counter <=Baud_counter +1;
        tx_out <=0;
        reg_index<=0;
        STATE <= start_bit;
        end
    else
        begin
        Baud_counter<=0;
        STATE<=DATA;
        end
    end
    
DATA :
    begin
    if (Baud_counter < ( max_baud_count))
        begin
        Baud_counter<= Baud_counter+1;
        tx_out <= data_in[reg_index];
        STATE <=DATA;
        end
    else 
        begin
        Baud_counter <=0;
        if ( reg_index<7)
            begin
            reg_index <= reg_index+1;
            STATE <=DATA;
            end
        else
            begin
            reg_index <=0;
            STATE <=stop_bit;
            end
         end
    end
stop_bit :
    begin
    if (Baud_counter < ( max_baud_count))
        begin 
//        is_transmitted <=1;
        tx_out <= 1;
        Baud_counter <= Baud_counter+1;
        STATE <= stop_bit;
        end
    
    else
        begin
        is_transmitted <=1;
        Baud_counter <=0;
        STATE <= IDEAL;
        end
    
    end
default :
begin 
    tx_out<=1;
    is_transmitted<=0;
    STATE <= IDEAL;
    Baud_counter <=0;
    reg_index <=0;

end

endcase
end
end
endmodule