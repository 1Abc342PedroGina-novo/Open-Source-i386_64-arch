// SPDX License Indentifier: GPL-3.0 
//Copyright (C) 2026 Pedro Emanuel
//Test Alu64 Module
`timescale 1ns/1ps
'include "alu64.v"

module tb_ALU64();
    reg clk; reg rst_n; reg [2:0] op_select; // Expandido para 3 bits
    reg signed [63:0] src1; reg signed [63:0] src2;
    wire signed [63:0] alu_out; wire overflow_out; wire carry_out;

    ALU64 dut (.clk(clk), .rst_n(rst_n), .op_select(op_select), .src1(src1), .src2(src2), .alu_out(alu_out), .overflow_out(overflow_out), .carry_out(carry_out));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump_alu64.vcd"); $dumpvars(0, tb_ALU64);
        clk = 0; rst_n = 0; op_select = 3'b000; src1 = 0; src2 = 0;

        $monitor("Tempo: %0t ns | Op: %b | Saída: 64'h%h | Ovf: %b", $time, op_select, alu_out, overflow_out);

        #12 rst_n = 1;

        // --- TESTE 1: Subtração ---
        src1 = 64'h7FFF_FFFF_FFFF_FFFF; src2 = 64'h8000_0000_0000_0000; op_select = 3'b000;

        // --- TESTE 2: XOR ---
        #10; src1 = 64'hAAAA_AAAA_AAAA_AAAA; src2 = 64'h5555_5555_5555_5555; op_select = 3'b001; 

        // --- TESTE 3: Soma ---
        #10; src1 = 64'h7FFF_FFFF_FFFF_FFFF; src2 = 64'h0000_0000_0000_0001; op_select = 3'b010; 

        // --- TESTE 4: AND ---
        #10; src1 = 64'hFFFF_FFFF_0000_0000; src2 = 64'h1234_5678_ABCD_EF01; op_select = 3'b011;

        // --- TESTE 5: Operação de OR (op_select = 100) ---
        // Combinando duas metades de bits para preencher o registrador síncrono
        #10;
        src1 = 64'h1234_5678_0000_0000;
        src2 = 64'h0000_0000_9ABC_DEF0;
        op_select = 3'b100;

        #15;
        $finish;
    end
endmodule
