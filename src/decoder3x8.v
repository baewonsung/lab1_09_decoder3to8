`default_nettype none

module decoder3x8 (
    input  wire       a,
    input  wire       b,
    input  wire       c,
    output wire [7:0] o
);
    assign o = 8'b00000001 << {a, b, c};
endmodule

`default_nettype wire
