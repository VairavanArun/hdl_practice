/*
 * Testbench for testing all the functionalities of the controller
 * in the muticycle mips CPU
 */

typedef struct {
    logic [5:0] opcode;
    logic [5:0] funct;
} opcode_function_t;

typedef enum bit [6:0] {LW    = 6'b100011,
                        SW    = 6'b101011,
                        BEQ   = 6'b000100,
                        ADDI  = 6'b001000,
                        J     = 6'b000010,
                        BLE   = 6'b000110,
                        RTYPE   = 6'b000000} opcode_e;

typedef enum bit [6:0] {ITYPE = 6'b000000,
                        ADD = 6'b100000,
                        SUB = 6'b100010,
                        OR = 6'b100101,
                        AND = 6'b100100,
                        SLT = 6'b101010,
                        SLTU = 6'b101011} function_e;

typedef struct {
    opcode_function_t opc_func;
    logic zero, negative, overflow;
    logic [3:0] cycle_count;
} controller_input_t;

typedef enum bit [4:0] {FETCH   = 4'b0000,  // State 0
                        DECODE  = 4'b0001,  // State 1
                        MEMADR  = 4'b0010,	// State 2
                        MEMRD   = 4'b0011,	// State 3
                        MEMWB   = 4'b0100,	// State 4
                        MEMWR   = 4'b0101,	// State 5
                        RTYPEEX = 4'b0110,	// State 6
                        RTYPEWB = 4'b0111,	// State 7
                        BEQEX   = 4'b1000,	// State 8
                        ADDIEX  = 4'b1001,	// State 9
                        ADDIWB  = 4'b1010,	// state 10
                        JEX     = 4'b1011	// State 11
                        } state_e;

module controllertest_tb();

    logic clk, reset;
    //10 instructions, 4 branch instructions (branch taken), 3 branch instructions (branch not taken)
    controller_input_t controller_input[17] = '{'{'{LW, ITYPE},   1'b0, 1'b0, 1'b0, 4'd5},
                                                '{'{SW, ITYPE},   1'b0, 1'b0, 1'b0, 4'd4},
                                                '{'{BEQ, ITYPE},  1'b1, 1'b0, 1'b0, 4'd3}, //BEQ taken
                                                '{'{BEQ, ITYPE},  1'b0, 1'b0, 1'b0, 4'd3}, //BEQ not taken
                                                '{'{BLE, ITYPE},  1'b1, 1'b0, 1'b0, 4'd3}, //BLE taken (equal)
                                                '{'{BLE, ITYPE},  1'b0, 1'b0, 1'b1, 4'd3}, //BLE taken (Overflow without negative)
                                                '{'{BLE, ITYPE},  1'b0, 1'b1, 1'b0, 4'd3}, //BLE taken (Negative without overflow)
                                                '{'{BLE, ITYPE},  1'b0, 1'b1, 1'b1, 4'd3}, //BLE not taken (negative and overflow)
                                                '{'{BLE, ITYPE},  1'b0, 1'b0, 1'b0, 4'd3}, //BLE not taken (greater than)
                                                '{'{ADDI, ITYPE}, 1'b0, 1'b0, 1'b0, 4'd4},
                                                '{'{J, ITYPE},    1'b0, 1'b0, 1'b0, 4'd3},
                                                '{'{RTYPE, ADD},  1'b0, 1'b0, 1'b0, 4'd4},
                                                '{'{RTYPE, SUB},  1'b0, 1'b0, 1'b0, 4'd4},
                                                '{'{RTYPE, OR},   1'b0, 1'b0, 1'b0, 4'd4},
                                                '{'{RTYPE, AND},  1'b0, 1'b0, 1'b0, 4'd4},
                                                '{'{RTYPE, SLT},  1'b0, 1'b0, 1'b0, 4'd4},
                                                '{'{RTYPE, SLTU}, 1'b0, 1'b0, 1'b0, 4'd4}}; 
    
    logic [5:0] opcode, funct;
    logic zero, negative, overflow;
    logic pcen, memwrite, irwrite, regwrite;
    logic       alusrca, iord, memtoreg, regdst;
    logic [1:0] alusrcb, pcsrc, aluop;
    logic [2:0] alucontrol;
    logic [14:0] control_word;
    logic [3:0] state, nextstate;
    logic [31:0] input_index;
    logic branch;
    
    controller dut(clk, reset, opcode, funct, zero, negative, overflow, 
                   pcen, memwrite, irwrite, regwrite,
                   alusrca, iord, memtoreg, regdst,
                   alusrcb, pcsrc,
                   alucontrol);

    assign branch = dut.branch;
    assign state = dut.md.state;
    assign nextstate = dut.md.nextstate;
    assign aluop = dut.aluop;
    assign control_word = dut.md.controls;
    
    initial begin
        input_index = 0;
        reset = 1;
        #15;
        reset = 0;
    end

    always begin
        clk = 1;
        #10;
        clk = 0;
        #10;
    end

    always @(posedge clk) begin
        if (!reset) begin
            if (input_index === 31'd17) begin
                $display("Simulation Succeded!");
                $stop;
            end
            opcode   = controller_input[input_index].opc_func.opcode;
            funct    = controller_input[input_index].opc_func.funct;
            zero     = controller_input[input_index].zero;
            negative = controller_input[input_index].negative;
            overflow = controller_input[input_index].overflow; 
        end
    end

    always @(negedge clk) begin
        if (!reset) begin
            $display("Opcode: %h, Function: %h, Zero: %h, Negative: %h, Overflow: %h", opcode, funct, zero, negative, overflow);
            $display("State: %h, Next state: %h, Control word: %h", state, nextstate, control_word);
            case(state)
                FETCH:
                    if ((nextstate !== DECODE) | (control_word != 15'h5010)) begin
                        $display("Simulation Failed!");
                        $stop;
                    end
                DECODE: case(opcode)
                            controller_input[0].opc_func.opcode: begin //LW
                                if ((nextstate !== MEMADR) | (control_word !== 15'h0030)) begin
                                    $display("Simulation Failed!");
                                    $stop;
                                end
                            end

                            controller_input[1].opc_func.opcode: begin //SW
                                if ((nextstate !== MEMADR) | (control_word !== 15'h0030)) begin
                                    $display("Simulation Failed!");
                                    $stop;
                                end
                            end

                            controller_input[2].opc_func.opcode: begin //BEQ
                                if ((nextstate !== BEQEX) | (control_word !== 15'h0030)) begin
                                    $display("Simulation Failed!");
                                    $stop;
                                end
                            end

                            controller_input[4].opc_func.opcode: begin //BLE
                                if ((nextstate !== BEQEX) | (control_word !== 15'h0030) ) begin
                                    $display("Simulation Failed!");
                                    $stop;
                                end
                            end

                            controller_input[9].opc_func.opcode: begin //ADDI
                                if((nextstate !== ADDIEX) | (control_word !== 15'h0030)) begin
                                    $display("Simulation Failed!");
                                    $stop;
                                end
                            end

                            controller_input[10].opc_func.opcode: begin //J
                                if ((nextstate !== JEX) | (control_word !== 15'h0030)) begin
                                    $display("Simulation Failed!");
                                    $stop;
                                end
                            end

                            controller_input[11].opc_func.opcode: begin //R-Type
                                if ((nextstate !== RTYPEEX) | (control_word !== 15'h0030)) begin
                                    $display("Simulation Failed!");
                                    $stop;
                                end
                            end
                        endcase
                
                MEMRD:
                    if ((nextstate !== MEMWB) | (control_word !== 15'h0100)) begin
                        $display("Simulation Failed!");
                        $stop;
                    end

                MEMWB: begin
                        if ((nextstate !== FETCH) | (control_word !== 15'h0880)) begin
                            $display("Simulation Failed!");
                            $stop;
                        end
                        input_index = input_index + 1;
                       end

                MEMWR: begin
                        if ((nextstate !== FETCH) | (control_word !== 15'h2100)) begin
                            $display("Simulation Failed!");
                            $stop;
                        end
                        input_index = input_index + 1;
                    end

                RTYPEEX: begin
                        if ((nextstate !== RTYPEWB) | (control_word !== 15'h0402)) begin
                            $display("Simulation Failed!");
                            $stop;
                        end
                    end
                
                RTYPEWB: begin
                        if ((nextstate !== FETCH) | (control_word !== 15'h0840)) begin
                            $display("Simulation Failed!");
                            $stop;
                        end
                        input_index = input_index + 1;
                    end
                
                BEQEX: begin
                        if ((nextstate !== FETCH) | (control_word !== 15'h0605)) begin
                            $display("Simulation Failed!");
                            $stop;
                        end
                        input_index = input_index + 1;
                    end

                ADDIEX:
                    if ((nextstate !== ADDIWB) | (control_word !== 15'h0420)) begin
                        $display("Simulation Failed!");
                        $stop;
                    end
                
                ADDIWB: begin
                    if ((nextstate !== FETCH) | (control_word !== 15'h0800)) begin
                        $display("Simulation Failed!");
                        $stop;
                    end
                    input_index = input_index + 1;
                end

                JEX: begin
                    if ((nextstate !== FETCH) | (control_word !== 15'h4008)) begin
                        $display("Simulation Failed!");
                        $stop;
                    end
                    input_index = input_index + 1;
                end
            endcase
        end
    end

endmodule