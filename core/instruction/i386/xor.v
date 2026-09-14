// SPDX License Indentifier : GPL-3.0 */
// xor - x64 instruction, local: core/i386/xor.v
// 1. Módulo base de 1 bit (Primitivo ou Comportamental)
// Módulo base de 1 bit para operação lógica
module XORx1(A, B, out);
    input A, B;
    output out;

    // Porta primitiva nativa do Verilog
    xor X1(out, A, B);
endmodule


// Módulo principal x64 estruturado por geração
module XORx64(num1, num2, result);

input signed [63:0] num1, num2;
output signed [63:0] result;

genvar x;
generate
    for(x = 0; x < 64; x = x + 1)
    begin : xor_loop
        // Instanciação e mapeamento físico bit a bit
        XORx1 M1(
            .A(num1[x]),
            .B(num2[x]),
            .out(result[x])
        );
    end
endgenerate

endmodule
