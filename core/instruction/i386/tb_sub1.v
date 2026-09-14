// SPDX License Indentifier: GPL-3.0 
// x64 verificate subtract instruction and generate dump 
`timescale 10ps/1ps
`include "sub.v" // Inclui o seu arquivo com os módulos SUBx1 e SUBx64

module tb_SUBx1();

reg A, B, borrow_in;
wire diff, borrow_out;
integer x;

// Instanciação
SUBx1 SUB1(
    .A(A), 
    .B(B), 
    .borrow_in(borrow_in), 
    .borrow_out(borrow_out), 
    .diff(diff)
);

initial begin
    $dumpfile("dump.vcd"); // No EDA Playground, use obrigatoriamente "dump.vcd"
    $dumpvars(0, tb_SUBx1);

    {A, B, borrow_in} = 3'b000;

    for(x = 0; x <= 7; x = x + 1)
    begin
        #10 {A, B, borrow_in} = x[2:0];
    end

    #10;
    $finish;
end

initial begin
    $display("Tempo\t\t A B Bi\t\tBo Diff");
    $monitor("time = %0t\t\t %b %b %b\t\t%b  %b", $time, A, B, borrow_in, borrow_out, diff);
end

endmodule

module tb_SUBx64();

reg signed [63:0] a;
reg signed [63:0] b;

wire signed [63:0] diff;
wire OF;
wire CF; // Criado para receber o carry_out do circuito

// Instanciação corrigida usando ligações nomeadas (mais seguro)
SUBx64 AT22(
    .num1(a),
    .num2(b),
    .diff(diff),
    .overflow(OF),
    .carry_out(CF) // Conectando o quinto pino necessário
);

initial
    begin
        // No EDA Playground, use obrigatoriamente "dump.vcd" para o gráfico abrir
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_SUBx64);
        
        a = 64'b0;
        b = 64'b0;
        
        // Monitor das variáveis formatado para melhor leitura no log
        $monitor("time: %0d\n a  : %b\t%d\n b  : %b\t%d\n a-b: %b\t%d\n overflow=%b  carry=%b\n ", $time, a, a, b, b, diff, diff, OF, CF);

        // Caso de Borda 1: Máximo Positivo - Máximo Positivo (Deve dar 0, OF=0)
        #10
        a = 64'h7FFF_FFFF_FFFF_FFFF; // Usando Hexadecimal para encurtar o código
        b = 64'h7FFF_FFFF_FFFF_FFFF;

        // Caso de Borda 2: Mínimo Negativo - Mínimo Negativo (Deve dar 0, OF=0)
        #10
        a = 64'h8000_0000_0000_0000;
        b = 64'h8000_0000_0000_0000;

        // Caso de Borda 3: Máximo Positivo - Mínimo Negativo (ESTOURA! OF=1)
        // Conta: (Grande Positivo) - (Grande Negativo) -> Vira uma Soma gigante positiva que estoura para negativo
        #10
        a = 64'h7FFF_FFFF_FFFF_FFFF;
        b = 64'h8000_0000_0000_0000;

        // Caso de Borda 4: Mínimo Negativo - Máximo Positivo (ESTOURA! OF=1)
        // Conta: (Grande Negativo) - (Grande Positivo) -> Vira uma Subtração que estoura o limite negativo
        #10
        a = 64'h8000_0000_0000_0000;
        b = 64'h7FFF_FFFF_FFFF_FFFF;
        
        // Finaliza a simulação de forma limpa gerando o arquivo gráfico
        #10;
        $finish;
    end
endmodule
