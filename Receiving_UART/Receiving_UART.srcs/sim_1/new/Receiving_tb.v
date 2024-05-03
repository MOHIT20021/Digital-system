`timescale 1ns / 10ps

module tb_Receiving;
reg slow_clk=0;
reg clk=0;
reg Rx_data=1;
reg RESET;
wire [7:0] Data;
wire is_full;
receiver UUT (
    .clk(slow_clk),
    .Rx_data(Rx_data),.reset(RESET),
    .Data(Data),
    .is_full(is_full)
);

always #10 clk=~clk;
always #0.1 slow_clk =~ slow_clk;
initial 
begin
    #10;
    RESET=0;
    // Test case 1: Sending a byte 10101101
    Rx_data = 0; // Start bit
    #10;
    Rx_data = 1; // Data bit 0
    #10;
    Rx_data = 0; // Data bit 1
    #10;
    Rx_data = 1; // Data bit 2
    #10;
    Rx_data = 1; // Data bit 3
    #10;
    Rx_data = 0; // Data bit 4
    #10;
    Rx_data = 1; // Data bit 5
    #10;
    Rx_data = 0; // Data bit 6
    #10;
    Rx_data = 1; // Data bit 7
    #10;
    Rx_data = 1; // Stop bit
    #50;
    RESET=1;#2;
    Rx_data=0;#1;

    Rx_data=1;#5;
    RESET=0;
    
    // Test case 2: Sending a byte 11011001
    Rx_data = 0; // Start bit
    #10;
    Rx_data = 1; // Data bit 0
    #10;
    Rx_data = 0; // Data bit 1
    #10;
    Rx_data = 0; // Data bit 2
    #10;
    Rx_data = 1; // Data bit 3
    #10;
    Rx_data = 1; // Data bit 4
    #10;
    Rx_data = 0; // Data bit 5
    #10;
    Rx_data = 1; // Data bit 6
    #10;
    Rx_data = 1; // Data bit 7
    #10;
    Rx_data = 1; // Stop bit
    #50;
    
    
    RESET=1;#2;
    Rx_data=0;#1;
 
    // Test case 1: Sending a byte 10101101
    Rx_data = 0; // Start bit
    #10;
    Rx_data = 1; // Data bit 0
    #10;
    Rx_data = 0; // Data bit 1
    #10;
    Rx_data = 1; // Data bit 2
    #10;
    Rx_data = 1; // Data bit 3
    #10;
    Rx_data = 0; // Data bit 4
    #10;
    Rx_data = 1; // Data bit 5
    #10;
    Rx_data = 0; // Data bit 6
    #10;
    Rx_data = 1; // Data bit 7
    #10;
    Rx_data = 1; // Stop bit
    #50;
    
    

    // Display the output
    $display("Data: %h", Data);

    // Test case 2: No data received
    Rx_data = 1; // Idle state
    #20
    $finish;
end

endmodule
