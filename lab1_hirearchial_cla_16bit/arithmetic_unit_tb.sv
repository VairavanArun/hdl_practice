// This file contains the testbench for testing the arithmetic unit module

module arithmetic_unit_tb();
    logic [15:0] a, b, sum, diff;
    logic of_d, of_s, less_than;

    //Instantiate the arithmetic unit module
    arithmetic_unit au1(.A(a), .B(b), .Sum(sum), .Diff(diff), 
                        .OF_S(of_s), .OF_D(of_d), .LessThan(less_than));

    initial 
    begin
        a = 16'd0; b = 16'd0; #60;
        //Test case 1: a = 17000, b = -15800
        a = 16'd17000;  b = -16'd15800; #60;
        //Test case 2: a = -15, b = 20
        a = -16'd15;    b = 16'd20;     #60;
        //Test case 3: a = 21845, b = 10922
        a = 16'd21845;  b = 16'd10922;  #60;
        //Test case 4: a=-24580, b = -8192
        a = -16'd24580; b = -16'd8192;  #60;
        // Test case 5: a=24576, b = -8191
        a = 16'd24576;  b = -16'd8191;  #60;
        // Test case 6: a=-8192, b = 24577
        a = -16'd8192;  b = 16'd24577;  #60;
        // Test case 7: a=10000, b=23000
        a = 16'd10000;  b = 16'd23000;  #60;
        // Test case 8: -15000, b = -16000
        a = -16'd15000; b = -16'd16000; #60; 
    end
endmodule 