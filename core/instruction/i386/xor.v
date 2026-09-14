// SPDX License Indentifier : GPL-3.0 */
// xor - x64 instruction, local: core/i386/xor.v
// 1. Módulo base de 1 bit (Primitivo ou Comportamental)
module xor_1bit (
    input a,
    input b,
    output out
);
    xor (out, a, b); // Usa a porta nativa do Verilog
endmodule

// 2. Módulo principal de 64 bits que gera a estrutura
module XORx64 (
    input signed [63:0] num1,
    input signed [63:0] num2,
    output signed [63:0] result
);

    // O genvar deve ser declarado para o bloco de geração
    genvar i;

    // Bloco generate explícito com labels obrigatórios pelas normas modernas
    generate
        for (i = 0; i < 64; i = i + 1) begin : g_xor_block
            // Instanciação estrutural do submódulo bit a bit
            xor_1bit bit_instance (
                .a(num1[i]),
                .b(num2[i]),
                .out(result[i])
            );
        end
    endgenerate

endmodule
