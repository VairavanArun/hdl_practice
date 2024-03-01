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
        clk = 1; #5; clk = 0; #5;
    end

    //initialize the registers
    initial
    begin
        //initiliaze the registers in negative edge to verify asynchronous initialization
        #5; 
        init = 1;
        swapxy = 0;
        #5;
        init = 0;
    end

    always @(posedge clk)
    begin
        #2;
        x <= 1;
        y <= 6;
    end

    always @(negedge clk)
    begin
        #1;
        init <= 1; 
        x <= 0;
        y <= 7; 
        swapxy <= 1;
        #3;
        init <= 0;
        #2
        swapxy <= 0; 
    end

endmodule