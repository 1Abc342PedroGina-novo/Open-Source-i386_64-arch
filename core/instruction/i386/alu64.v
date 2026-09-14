// SPDX License Indentifier: GPL-3.0 
//Copyright (C) 2026 Pedro Emanuel
//Alu64 Module, file: core/instruction/i386/alu64.v

'include "sub.v"
'include "xor.v"

module ALU64(
    input clk,                      // Sinal de Clock
    input rst_n,                    // Reset ativo em nível baixo (padrão Intel)
    input [1:0] op_select,          // 00 = SUB, 01 = XOR
    input signed [63:0] src1, src2, // Entradas de dados
    output reg signed [63:0] alu_out, // Saídas registradas (síncronas)
    output reg overflow_out,
    output reg carry_out
);

    // Fios internos para conectar os blocos combinacionais
    wire signed [63:0] sub_res, xor_res;
    wire sub_ovf, sub_cry;

    // Instanciação dos blocos combinacionais
    SUBx64 sub_unit (.num1(src1), .num2(src2), .diff(sub_res), .overflow(sub_ovf), .carry_out(sub_cry));
    XORx64 xor_unit (.num1(src1), .num2(src2), .result(xor_res));

    // Bloco sequencial síncrono (Flip-Flops)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Condição de Reset: Zera todas as saídas
            alu_out      <= 64'b0;
            overflow_out <= 1'b0;
            carry_out    <= 1'b0;
        end else begin
            // Na borda de subida do clock, amostra a operação selecionada
            case (op_select)
                2'b00: begin // Operação de Subtração
                    alu_out      <= sub_res;
                    overflow_out <= sub_ovf;
                    carry_out    <= sub_cry;
                end
                2'b01: begin // Operação de XOR
                    alu_out      <= xor_res;
                    overflow_out <= 1'b0; // XOR não gera overflow
                    carry_out    <= 1'b0; // XOR não gera carry
                end
                default: begin
                    alu_out      <= 64'b0;
                    overflow_out <= 1'b0;
                    carry_out    <= 1'b0;
                end
           endcase // CORREÇÃO AQUI: Mudado de </case> para endcase
        end
    end

endmodule
