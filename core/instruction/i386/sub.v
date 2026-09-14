// SPDX License Indentifier: GPL-3.0 
// x64 Subtract operations, file local: core/instruction/i386/sub.v 

module SUBx1(A, B, borrow_in, borrow_out, diff);

input A, B, borrow_in;
output diff, borrow_out;

// Declaração explícita das conexões internas
wire w1, w2, w3, w4, w5;

// calculating difference
xor X1(w1, A, B);
xor X2(diff, w1, borrow_in);

// calculating borrow_out
xnor XN1(w2, A, B);
and A1(w3, borrow_in, w2);

not NT1(w4, A);
and A2(w5, w4, B);
or O1(borrow_out, w3, w5);

endmodule 


module SUBx64(num1, num2, diff, overflow, carry_out);

input signed [63:0] num1, num2;
output signed [63:0] diff;
output overflow;
output carry_out; // No x64, o último borrow funciona como o Carry/Borrow Flag (CF)

// Declaração do vetor de borrows
wire [64:0] b; 

assign b[0] = 1'b0;

genvar x;
generate 
    for(x = 0; x < 64; x = x + 1)
    begin : sub_loop
        SUBx1 M1(
            .A(num1[x]), 
            .B(num2[x]), 
            .borrow_in(b[x]), 
            .borrow_out(b[x+1]), 
            .diff(diff[x])
        );
    end
endgenerate

// O último borrow (b[64]) é o próprio Carry Flag (CF) do x64 para unsigned
assign carry_out = b[64];

// CORREÇÃO DO OVERFLOW (OF):
// Ajustado para operador lógico de curto-circuito (&&), ideal para flags de controle.
assign overflow = (num1[63] ^ num2[63]) && (diff[63] ^ num1[63]);

endmodule
