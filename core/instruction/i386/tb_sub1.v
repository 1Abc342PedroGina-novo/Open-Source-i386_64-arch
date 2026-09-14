// x64 verificate subtract instru
`timescale 10ps/1ps
`include "sub.v" // Inclui o seu arquivo com os módulos SUBx1 e SUBx64

module tb_SUBx1();

reg A, B, borrow_in;
wire diff, borrow_out;
integer x;

// Instanciação usando conexões nomeadas (boa prática)
SUBx1 SUB1(
    .A(A), 
    .B(B), 
    .borrow_in(borrow_in), 
    .borrow_out(borrow_out), 
    .diff(diff)
);

initial begin
  $dumpfile("Dumpsb1.dump");
    $dumpvars(0, tb_SUBx1);

    // Inicializa os sinais zerados
    {A, B, borrow_in} = 3'b000;

    // Loop que passa por todas as 8 combinações da tabela verdade (0 a 7)
    for(x = 0; x <= 7; x = x + 1)
    begin
        #10 {A, B, borrow_in} = x[2:0];
    end

    // Tempo final para estabilização antes de fechar a simulação
    #10;
    $finish;
end

// O $monitor substitui o bloco always, evitando problemas de tempo de amostragem
initial begin
    $display("Tempo\t\t A B Bi\t\tBo Diff");
    $monitor("time = %0t\t\t %b %b %b\t\t%b  %b", $time, A, B, borrow_in, borrow_out, diff);
end

endmodule
