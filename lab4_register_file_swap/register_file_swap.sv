/*
 * This file contains the implementation of Register file swap
 * Swap operation is implemented between two registers in a register file
 * consisting of 8 registers
 */

module register_file_swap(input logic  clk, init,
                          input logic  swapxy,
                          input logic  [2:0]x,y,
                          output logic [3:0]r[7:0]);
    
    always_ff @(posedge clk, posedge init) 
    begin
          //check for init signal
        if (init)
        begin
            r[0] <= 4'd0;
            r[1] <= 4'd1;
            r[2] <= 4'd2;
            r[3] <= 4'd3;
            r[4] <= 4'd4;
            r[5] <= 4'd5;
            r[6] <= 4'd6;
            r[7] <= 4'd7;
        end
        else if(swapxy)
        begin
            r[x] <= r[y];
            r[y] <= r[x];
        end
    end

endmodule