// SPDX License Indentifier: GPL-3.0 
//Copyright (C) 2026 Pedro Emanuel
//Test Alu64 Module
`timescale 1ns/1ps
'include "alu64.v"

module tb_ALU64();

    reg clk;
    reg rst_n;
    reg [1:0] op_select;
    reg signed [63:0] src1;
    reg signed [63:0] src2;

    wire signed [63:0] alu_out;
    wire overflow_out;
    wire carry_out;

    // Instanciação da ULA Síncrona
    ALU64 dut (
        .clk(clk),
        .rst_n(rst_n),
        .op_select(op_select),
        .src1(src1),
        .src2(src2),
        .alu_out(alu_out),
        .overflow_out(overflow_out),
        .carry_out(carry_out)
    );

    // Gerador de Clock (Período de 10ns)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_ALU64);

        clk = 0;
        rst_n = 0; 
        op_select = 2'b00;
        src1 = 64'b0;
        src2 = 64'b0;

        $monitor("Tempo: %0t ns | Reset: %b | Op: %b | Saída: 64'h%h | Ovf: %b", $time, rst_n, op_select, alu_out, overflow_out);

        // Libera o reset
        #12 rst_n = 1;

        // --- TESTE 1: Subtração com estouro positivo ---
        src1 = 64'h7FFF_FFFF_FFFF_FFFF;
        src2 = 64'h8000_0000_0000_0000;
        op_select = 2'b00;

        // --- TESTE 2: Mudança para XOR ---
        #10;
        src1 = 64'hAAAA_AAAA_AAAA_AAAA;
        src2 = 64'h5555_5555_5555_5555;
        op_select = 2'b01; 

        #10;
        #10 $finish;
    end

endmodule
