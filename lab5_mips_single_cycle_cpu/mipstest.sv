// Example testbench for MIPS processor

module testbench();

  logic        clk;
  logic        reset;

  logic [31:0] writedata, dataadr;
  logic        memwrite;

  // instantiate device to be tested
  top dut(clk, reset, writedata, dataadr, memwrite);
  
  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // check that 7 gets written to address 84
  always@(negedge clk)
    begin
      if(memwrite) begin
        $display("Dataadr: %h, Writedata: %h", dataadr, writedata);
        if(dataadr === 16 & writedata === -6) begin
          $display("Simulation succeeded");
          $stop;
        end else if ((dataadr !== 20) & (dataadr !== 24) & (dataadr !== 28) & (dataadr !== 32) & (dataadr !== 36) & (dataadr !== 40)) begin
          $display("Simulation failed");
          $stop;
        end
      end
    end
endmodule



