/*
 * This file contains the test bench to test register file swapping operation
 */

module testbench();
    logic clk;
    logic init, swapxy;
    logic [2:0]x,y;
    logic [3:0]r[7:0];

    //instantiate the module
    register_file_swap rf_swap(clk, init, swapxy, x, y, r);

    //define clock behavior
    always 
    begin
        clk = 1; #10; clk = 0; #10;
    end

    //initialize the registers
    initial
    begin
        //initiliaze the registers in negative edge to verify asynchronous initialization
        x = 3'd0; y = 3'd0; swapxy = 1'b0; init = 1'b0;
        #15; 

        //Initiliaze the registers
        init = 1'b1; #20; init = 1'b0;

        //Test case 1
        swapxy = 1'b1;
        x = 3'd0; y = 3'd7; #20;
        x = 3'd1; y = 3'd6; #20;
        x = 3'd2; y = 3'd5; #20;
        x = 3'd3; y = 3'd4; #7;
        swapxy = 1'b0;

        #8; init = 1'b1; #7; init = 1'b0;

        //Test case 2
        swapxy = 1'b1;
        x = 3'd0; y = 3'd7; #20;
        x = 3'd1; y = 3'd6; #20;
        x = 3'd2; y = 3'd5; #20;
        x = 3'd3; y = 3'd4; #20;
        swapxy = 1'b0;

        #15; init = 1'b1; #5; init = 1'b0;

        swapxy = 1'b1;
        x = 3'd0; y = 3'd3; #20;
        x = 3'd2; y = 3'd5; #20;
        x = 3'd3; y = 3'd6; #20;
        x = 3'd4; y = 3'd6; #20;
        x = 3'd5; y = 3'd7; #20;
        x = 3'd6; y = 3'd7; #20;
        swapxy = 1'b0;
    end

endmodule