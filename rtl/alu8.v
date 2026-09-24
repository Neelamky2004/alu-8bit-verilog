test
  indented
end`timescale 1ns/1ps

module alu8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] op,
    output reg  [7:0] y,
    output wire       zero,
    output reg        carry,
    output wire       negative,
    output reg        overflow
);

    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_AND = 3'b010;
    localparam OP_OR  = 3'b011;
    localparam OP_XOR = 3'b100;
    localparam OP_NOT = 3'b101;
    localparam OP_SHL = 3'b110;
    localparam OP_SHR = 3'b111;

    reg [8:0] tmp;

    always @(*) begin
        tmp      = 9'd0;
        y        = 8'd0;
        carry    = 1'b0;
        overflow = 1'b0;
        case (op)
            OP_ADD: begin
                tmp      = {1'b0, a} + {1'b0, b};
                y        = tmp[7:0];
                carry    = tmp[8];
                overflow = (a[7] == b[7]) && (y[7] != a[7]);
            end
            OP_SUB: begin
                tmp      = {1'b0, a} - {1'b0, b};
                y        = tmp[7:0];
                carry    = tmp[8];
                overflow = (a[7] != b[7]) && (y[7] != a[7]);
            end
            OP_AND: y = a & b;
            OP_OR:  y = a | b;
            OP_XOR: y = a ^ b;
            OP_NOT: y = ~a;
            OP_SHL: begin
                y     = a << 1;
                carry = a[7];
            end
            OP_SHR: begin
                y     = a >> 1;
                carry = a[0];
            end
            default: y = 8'd0;
        endcase
    end

    assign zero     = (y == 8'd0);
    assign negative = y[7];

endmodule
