`timescale 1ns/1ps
`default_nettype none

module tb_decoder3x8;
    logic a;
    logic b;
    logic c;
    wire [7:0] o;

    integer n;
    integer checked;
    logic [7:0] expected;

    decoder3x8 dut (.a(a), .b(b), .c(c), .o(o));

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_decoder3x8);
        a = 1'b0;
        b = 1'b0;
        c = 1'b0;
        checked = 0;

        for (n = 0; n < 8; n = n + 1) begin
            {a, b, c} = n[2:0];
            expected = 8'b00000001 << n;
            #10;
            if (o !== expected)
                $fatal(1,
                    "LAB1_FAIL decoder3x8 case=%0d abc=%03b expected=%08b actual=%08b",
                    n, {a, b, c}, expected, o);
            checked = checked + 1;
        end

        if (checked != 8)
            $fatal(1, "LAB1_FAIL decoder3x8 checked=%0d expected_cases=8", checked);
        $display("LAB1_PASS decoder3x8 cases=%0d", checked);
        $finish;
    end

    initial begin
        #200;
        $fatal(1, "LAB1_FAIL decoder3x8 watchdog timeout");
    end
endmodule

`default_nettype wire
