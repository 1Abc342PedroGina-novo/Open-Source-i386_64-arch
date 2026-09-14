// SPDX License Indentifier: GPL-3.0 
// x64 Subtract operations, file local: core/instruction/i386/sub.v 
module SUBx1(A, B, borrow_in, borrow_out, diff);

input A, B, borrow_in;
output diff, borrow_out;

// É obrigatório declarar as conexões internas como wire
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


module SUBx64(num1, num2, diff, overflow);

input signed [63:0] num1, num2;
output signed [63:0] diff;
output overflow;

// Declaração do vetor de borrows (vai de 0 até 64)
wire [64:0] b; 

assign b[0] = 1'b0;

genvar x;
generate 
    for(x = 0; x < 64; x = x + 1)
    begin : sub_loop // OBRIGATÓRIO: Nomear o bloco interno do generate
        SUBx1 M1(
            .A(num1[x]), 
            .B(num2[x]), 
            .borrow_in(b[x]), 
            .borrow_out(b[x+1]), 
            .diff(diff[x])
        );
    end
endgenerate

// O overflow em subtratores com sinal também pode ser validado 
// comparando o sinal dos blocos finais
xor X1(overflow, b[64], b[63]);

endmodule
