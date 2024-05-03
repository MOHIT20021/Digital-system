`timescale 1ns / 1ps
//parameter bit_size= 8;   // same time change reg_index range so it can accomadoate the bit size enter over here

module receiver (
input clk,
input Rx_data,reset,
output reg signed [7:0] Data,  // final received data
output reg is_received    // flag indicating data is received ( only high for l clock cycle)
);
parameter max_baud_count=10416;   //This is  the value for 9600 baudrate found by dividing (frequency of fpga)/Baudrate
 
//states
parameter IDEAL =2'b00;
parameter start_bit = 2'b01;
parameter stop_bit = 2'b10;

reg signed [7:0] INTER_DATA;  // variable that store received value
reg [1:0]STATE;   
reg [31:0]Baud_counter=0;  // counter for counting max baud count 

// it is the index on which received bit is stored 
reg [31:0] reg_index;     // change here after changing bit_size if needed 
  
reg [31:0] stop_count = 1.3*max_baud_count;  

always@(posedge clk,posedge reset)
begin 
   
    if (reset)
    begin
    INTER_DATA<=0;
    Baud_counter<=0;
    reg_index<=0;
    is_received<=0;
    end
    
    else
    begin
    
    case(STATE)
    IDEAL : 
    begin 
    is_received <=0;
    reg_index<=0;
    if (Rx_data==0)
        begin 
        if (Baud_counter<(max_baud_count)/2)
            begin 
            Baud_counter<=Baud_counter+1;
            is_received <=0;
            STATE <=IDEAL;
            end
        else 
            begin
            STATE<=start_bit;
            Baud_counter<=0;
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
      if (Baud_counter <(max_baud_count))
          begin
          Baud_counter <=Baud_counter+1;
          STATE<=start_bit;
          end
      else
          begin
            Baud_counter <= 0;
            INTER_DATA[reg_index] <= Rx_data;
          if (reg_index<7)
              begin
              reg_index <= reg_index+1;
              STATE <= start_bit;
              end
          else
              begin
         
              is_received  <= 0;
              reg_index <= 0;
              Baud_counter <= 0;
              STATE <= stop_bit;
              end
           end
      end
    
    stop_bit :
        begin
        if (Baud_counter <(stop_count))
            begin
            Baud_counter <= Baud_counter+1;
            STATE <= stop_bit;
            end
        else if (Baud_counter==stop_count)
            begin
            Data<=INTER_DATA;
            STATE <= IDEAL;
            Baud_counter<=0;
            is_received  <=1;
            
            end
         else begin end 
        end            
    default :
    begin
    STATE <= IDEAL;
    Baud_counter <=0;
    reg_index <=0;
    is_received  <=0;
    end
    endcase  
    end

 end 
// end
endmodule
    
    
