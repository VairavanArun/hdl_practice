module testbench();
  logic [31:0]a,b;
  logic [31:0]y;
  pattern dut(a,b,y);//rename module
  initial begin 
    a = 0'hFFFF37DF; b= 0'hABCDEF6F; #10;
    if (y !== 0'h1FFF02CB ) $display("test 1 failed.");
    a = 0'hDA5D35D5; b= 0'hCCE5A0BA; #10;
    if (y !== 0'h100820A) $display("test 2 failed.");
    a=0'hDA5D35D5; b = 0'hCCE5A048; #10;
    if (y !== 0'h402000) $display("test 3 failed.");
    a=0'h5A5525D5; b=0'hCCE5A026; #10;
    if (y !== 0'h4000000) $display("test 4 failed");
    a=0'hB0F72DD5; b=0'hFFF5A014 ; #10;
    if (y !== 0'h0000000) $display("test 5 failed");
    a=0'h49042514; b=0'hFFF5A060 ; #10;
    if (y !== 0'h12594841) $display("test 6 failed");
    a=0'hD5555555; b=0'hFFF5A075 ; #10;
    if (y !== 0'h15555555) $display("test 7 failed");
    a=0'hDF605A6B; b=0'hF0F0F05F ; #10;
    if (y !== 0'h13400208) $display("test 8 failed");
    a=0'hDF605A6B; b=0'hF0F0F01F ; #10;
    if (y !== 0'h3000000) $display("test 9 failed");
    a=0'hDF605A6B; b=0'hF0F0F010 ; #10;
    if (y !== 0'h38000) $display("test 10 failed");
  end
endmodule