/*
 * Testbench for testing all the functionalities of the controller
 * in the muticycle mips CPU
 */

typedef struct {
    logic [5:0] opcode;
    logic [5:0] funct;
} opcode_function_t;

typedef enum opcode_function_t {LW    = '{6'b100011, 6'b000000},
                                SW    = '{6'b101011, 6'b000000},
                                BEQ   = '{6'b000100, 6'b000000},
                                ADDI  = '{6'b001000, 6'b000000},
                                J     = '{6'b000010, 6'b000000},
                                BLE   = '{6'b000110, 6'b000000},
                                ADD   = '{6'b000000, 6'b100000},
                                SUB   = '{6'b000000, 6'b100010},
                                OR    = '{6'b000000, 6'b100101},
                                AND   = '{6'b000000, 6'b100100},
                                SLT   = '{6'b000000, 6'b101010},
                                SLTU  = '{6'b000000, 6'b101011}} opcode_function_e;


typedef struct {
    opcode_function_e opc_func;
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
                        JEX     = 4'b1011,	// State 11
                        } state_e;

module controllertest_tb();

    logic clk, reset;
    //10 instructions, 4 branch instructions (branch taken), 3 branch instructions (branch not taken)
    controller_input_t controller_input[17] = '{'{LW,   1'b0, 1'b0, 1'b0, 4'd5},
                                                '{SW,   1'b0, 1'b0, 1'b0, 4'd4},
                                                '{BEQ,  1'b1, 1'b0, 1'b0, 4'd3}, //BEQ taken
                                                '{BEQ,  1'b0, 1'b0, 1'b0, 4'd3}, //BEQ not taken
                                                '{BLE,  1'b1, 1'b0, 1'b0, 4'd3}, //BLE taken (equal)
                                                '{BLE,  1'b0, 1'b0, 1'b1, 4'd3}, //BLE taken (Overflow without negative)
                                                '{BLE,  1'b0, 1'b1, 1'b0, 4'd3}, //BLE taken (Negative without overflow)
                                                '{BLE,  1'b0, 1'b1, 1'b1, 4'd3}, //BLE not taken (negative and overflow)
                                                '{BLE,  1'b0, 1'b0, 1'b0, 4'd3}, //BLE not taken (greater than)
                                                '{ADDI, 1'b0, 1'b0, 1'b0, 4'd4},
                                                '{J,    1'b0, 1'b0, 1'b0, 4'd3},
                                                '{ADD,  1'b0, 1'b0, 1'b0, 4'd4},
                                                '{SUB,  1'b0, 1'b0, 1'b0, 4'd4},
                                                '{OR,   1'b0, 1'b0, 1'b0, 4'd4},
                                                '{AND,  1'b0, 1'b0, 1'b0, 4'd4},
                                                '{SLT,  1'b0, 1'b0, 1'b0, 4'd4},
                                                '{SLTU, 1'b0, 1'b0, 1'b0, 4'd4}}; 
    
    logic [5:0] opcode, funct;
    logic zero, negative, overflow;
    logic pcen, memwrite, irwrite, regwrite;
    logic       alusrca, iord, memtoreg, regdst;
    logic [1:0] alusrcb, pcsrc;
    logic [2:0] alucontrol;
    logic [14:0] control_word;
    state_e state, nextstate;
    logic [31:0] input_index;

    assign control_word = {pcen, memwrite, irwrite, regwrite, 
                           alusrca, iord, memtoreg, regdst,
                           alusrcb, pcsrc, aluop};

    
    controller dut(clk, reset, opcode, funct, zero, negative, overflow, 
                   pcen, memwrite, irwrite, regwrite,
                   alusrca, iord, memtoreg, regdst,
                   alusrcb, pcsrc,
                   alucontrol);

    
    initial begin
        input_index = 0;
        reset = 1;
        #10;
        reset = 0;
    end

    always begin
        clk = 1;
        #10;
        clk = 0;
        #10;
    end

    always @(posedge clk) begin
        if !(reset) begin
            if (input_index === 18) $stop;
            opcode   = controller_input[input_index].opc_func.opcode;
            funct    = controller_input[input_index].opc_func.funct;
            zero     = controller_input[input_index].zero;
            negative = controller_input[input_index].negative;
            overflow = controller_input[input_index].overflow; 
        end
    end

    always @(posedge clk) begin
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
                                if ((nextstate !== BEQEX) | (control_word !== 15'h0030) )) begin
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
                                if((nexstate !== ADDIEX) | (control_word !== 15'h0030)) begin
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
                    if ((nextstate !== MEMWB) | (control_word !== )) begin
                        $display("Simulation Failed!");
                        $stop;
                    end

                MEMWB: begin
                        if ((nextstate !== FETCH) | (control_word !== )) begin
                            $display("Simulation Failed!");
                            $stop;
                        end
                        input_index = input_index + 1;
                       end

                MEMWR: begin
                        if ((nextstate !== FETCH) | (control_word !== )) begin
                            $display("Simulation Failed!");
                            $stop;
                        end
                        input_index = input_index + 1;
                    end

                RTYPEEX: begin
                        if ((nextstate !== RTYPEWB) | (control_word !== )) begin
                            $display("Simulation Failed!");
                            $stop;
                        end
                    end
                
                RTYPEWB: begin
                        if ((nextstate !== FETCH) | (control_word !== )) begin
                            $display("Simulation Failed!");
                            $stop;
                        end
                        input_index = input_index + 1;
                    end
                
                BEQEX: begin
                        if ((next_state !== FETCH) | (control_word !== )) begin
                            $display("Simulation Failed!");
                            $stop;
                        end
                        input_index = input_index + 1;
                    end

                ADDIEX:
                    if ((next_state !== ADDIWB) | (control_word !== )) begin
                        $display("Simulation Failed!");
                        $stop;
                    end
                
                ADDIWB: begin
                    if ((next_state !== FETCH) | (control_word !== )) begin
                        $display("Simulation Failed!");
                        $stop;
                    end
                    input_index = input_index + 1;
                end

                JEX: begin
                    if ((next_state !== FETCH) | (control_word !== )) begin
                        $display("Simulation Failed!");
                        $stop;
                    end
                    input_index = input_index + 1;
                end
            endcase
        end
    end

endmodule