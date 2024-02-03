module testbench();
    logic [15:0] A,B;
    logic Cin;
    logic [15:0] Sum;
    logic Cout;

    assign Cin = 0;

    ppa_16bit DUT(A, B, Cin, Sum, Cout);

    initial begin
        A = 16'h0; B = 16'h0; #60;
        A = 16'h0321; B = 16'h0132; #60;
        A = 16'hFFFF; B = 16'h0001; #60;
        A = 16'h0001; B = 16'hFFFF; #60;
        A = 16'hAAAA; B = 16'h5555; #60;
        A = 16'h5555; B = 16'hAAAA; #60;
        A = 16'h8000; B = 16'h7FFF; #60;
        A = 16'h8000; B = 16'h0001; #60;
        A = 16'h7FFF; B = 16'h7000; #60;
    end

endmodule 
