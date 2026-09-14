// SPDX-License-Identifier: GPL-3.0
// x64 Add operations, file local: core/instruction/i386/add.v

module ADDx1(A, B, C, S, carry);
    input A, B, C;
    output S, carry;
    wire w1, w2, w3;

    xor(w1, A, B);
    xor(S, w1, C);
    and(w2, A, B);
    and(w3, w1, C);
    or(carry, w3, w2);
endmodule  


module ADDx64(A, B, sum, OF, carry_out); // Adicionado carry_out para completar o RFLAGS do x64

input signed [63:0] A;
input signed [63:0] B;
output signed [63:0] sum;
output OF;
output carry_out; // O último carry representa o Carry Flag (CF) na soma

wire [64:0] carry;

assign carry[0] = 1'b0;

genvar j;
generate 
    for(j = 0; j < 64; j = j + 1)
    begin : add_loop // OBRIGATÓRIO: Nomear o bloco interno do generate
        ADDx1 A11(
            .A(A[j]), 
            .B(B[j]), 
            .C(carry[j]), 
            .S(sum[j]), 
            .carry(carry[j+1])
        );
    end
endgenerate

// Lógica de Overflow (OF) perfeitamente implementada por portas primitivas
   assign OF = (A[63] == B[63]) && (sum[63] != A[63]);
    assign carry_out = carry[64];

// Atribuição do Carry Out final
assign carry_out = carry[64];

endmodule
