module testbench();
  logic [31:0]a,b;
  logic [31:0]y;
  pattern_match dut(a,b,y);//rename module
  initial begin 
    a = 32'hFFFF37DF; b= 32'hABCDEF6F; #10;
    if (y !== 32'h1FFF02CB ) $display("test 1 failed.");
    a = 32'hDA5D35D5; b= 32'hCCE5A0BA; #10;
    if (y !== 32'h100820A) $display("test 2 failed.");
    a=32'hDA5D35D5; b = 32'hCCE5A048; #10;
    if (y !== 32'h402000) $display("test 3 failed.");
    a=32'h5A5525D5; b=32'hCCE5A026; #10;
    if (y !== 32'h4000000) $display("test 4 failed");
    a=32'hB0F72DD5; b=32'hFFF5A014 ; #10;
    if (y !== 32'h0000000) $display("test 5 failed");
    a=32'h49042514; b=32'hFFF5A060 ; #10;
    if (y !== 32'h12594841) $display("test 6 failed");
    a=32'hD5555555; b=32'hFFF5A075 ; #10;
    if (y !== 32'h15555555) $display("test 7 failed");
    a=32'hDF605A6B; b=32'hF0F0F05F ; #10;
    if (y !== 32'h13400208) $display("test 8 failed");
    a=32'hDF605A6B; b=32'hF0F0F01F ; #10;
    if (y !== 32'h3000000) $display("test 9 failed");
    a=32'hDF605A6B; b=32'hF0F0F010 ; #10;
    if (y !== 32'h38000) $display("test 10 failed");
  end
endmodule
