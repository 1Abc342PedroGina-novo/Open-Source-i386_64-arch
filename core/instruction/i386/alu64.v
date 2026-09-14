// SPDX License Indentifier: GPL-3.0 
//Copyright (C) 2026 Pedro Emanuel
//Alu64 Module, file: core/instruction/i386/alu64.v

'include "sub.v"
'include "xor.v"
'include "add.v"
'include "and.v"

module ALU64(
    input clk,                      
    input rst_n,                    
    input [1:0] op_select,          
    input signed [63:0] src1, src2, 
    output reg signed [63:0] alu_out, 
    output reg overflow_out,
    output reg carry_out
);

    wire signed [63:0] sub_res, xor_res, add_res, and_res;
    wire sub_ovf, sub_cry, add_ovf, add_cry;

    SUBx64 sub_unit (.num1(src1), .num2(src2), .diff(sub_res), .overflow(sub_ovf), .carry_out(sub_cry));
    XORx64 xor_unit (.num1(src1), .num2(src2), .result(xor_res));
    ADDx64 add_unit (.A(src1), .B(src2), .sum(add_res), .OF(add_ovf), .carry_out(add_cry));
    ANDx64 and_unit (.A(src1), .B(src2), .out(and_res));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alu_out      <= 64'b0;
            overflow_out <= 1'b0;
            carry_out    <= 1'b0;
        end else begin
            case (op_select)
                2'b00: begin 
                    alu_out      <= sub_res;
                    overflow_out <= sub_ovf;
                    carry_out    <= sub_cry;
                end
                2'b01: begin 
                    alu_out      <= xor_res;
                    overflow_out <= 1'b0; 
                    carry_out    <= 1'b0; 
                end
                2'b10: begin 
                    alu_out      <= add_res;
                    overflow_out <= add_ovf;
                    carry_out    <= add_cry;
                end
                2'b11: begin 
                    alu_out      <= and_res;
                    overflow_out <= 1'b0; 
                    carry_out    <= 1'b0; 
                end
            endcase
        end
    end
endmodule
