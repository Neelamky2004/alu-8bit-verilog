`timescale 1ns/1ps

module tb_alu8;

    reg  [7:0] a, b;
    reg  [2:0] op;
    wire [7:0] y;
    wire zero, carry, negative, overflow;

    reg  [7:0] exp_y;
    reg        exp_c, exp_v;
    reg  [8:0] t;

    integer errors = 0;
    integer tests  = 0;
    integer i;

    alu8 dut (
        .a(a), .b(b), .op(op),
        .y(y), .zero(zero), .carry(carry),
        .negative(negative), .overflow(overflow)
    );

    task ref_model;
        begin
            exp_c = 0;
            exp_v = 0;
            case (op)
                3'b000: begin t = a + b; exp_y = t[7:0]; exp_c = t[8];
                              exp_v = (a[7] == b[7]) && (exp_y[7] != a[7]); end
                3'b001: begin t = {1'b0, a} - {1'b0, b}; exp_y = t[7:0]; exp_c = t[8];
                              exp_v = (a[7] != b[7]) && (exp_y[7] != a[7]); end
                3'b010: exp_y = a & b;
                3'b011: exp_y = a | b;
                3'b100: exp_y = a ^ b;
                3'b101: exp_y = ~a;
                3'b110: begin exp_y = a << 1; exp_c = a[7]; end
                3'b111: begin exp_y = a >> 1; exp_c = a[0]; end
            endcase
        end
    endtask

    task check;
        begin
            #5;
            ref_model;
            tests = tests + 1;
            if (y !== exp_y || carry !== exp_c || overflow !== exp_v ||
                zero !== (exp_y == 0) || negative !== exp_y[7]) begin
                errors = errors + 1;
                $display("FAIL op=%b a=%h b=%h | y=%h c=%b v=%b | exp y=%h c=%b v=%b",
                         op, a, b, y, carry, overflow, exp_y, exp_c, exp_v);
            end
        end
    endtask

    task apply(input [2:0] o, input [7:0] x, input [7:0] z);
        begin
            op = o; a = x; b = z;
            check;
        end
    endtask

    initial begin
        $dumpfile("alu8.vcd");
        $dumpvars(0, tb_alu8);

        apply(3'b000, 8'h7F, 8'h01);
        apply(3'b000, 8'hFF, 8'h01);
        apply(3'b000, 8'h80, 8'h80);
        apply(3'b001, 8'h00, 8'h01);
        apply(3'b001, 8'h80, 8'h01);
        apply(3'b001, 8'h55, 8'h55);
        apply(3'b010, 8'hF0, 8'h0F);
        apply(3'b011, 8'hA0, 8'h05);
        apply(3'b100, 8'hFF, 8'hFF);
        apply(3'b101, 8'hFF, 8'h00);
        apply(3'b110, 8'h81, 8'h00);
        apply(3'b111, 8'h01, 8'h00);

        for (i = 0; i < 2000; i = i + 1) begin
            apply($random, $random, $random);
        end

        $display("--------------------------------");
        $display("Tests run : %0d", tests);
        $display("Errors    : %0d", errors);
        if (errors == 0) $display("RESULT    : PASS");
        else             $display("RESULT    : FAIL");
        $finish;
    end

endmodule
