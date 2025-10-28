`timescale 1ns / 1ps

module tb_Display_sprite;

    // Inputs
    reg clk = 0;

    // Outputs
    wire HS;
    wire VS;
    wire [11:0] vgaRGB;

    // Instantiate the Unit Under Test (UUT)
    Display_sprite uut (
        .clk(clk),
        .HS(HS),
        .VS(VS),
        .vgaRGB(vgaRGB)
    );

    // Clock generation
    // The VGA driver inside will generate its own pixel clock (25 MHz),
    // so you just drive the Basys3 100 MHz board clock here.
    always #5 clk = ~clk;  // 100 MHz => 10 ns period

    // Simulation control
    initial begin
        // Run long enough to see a few HS and VS pulses
        #10000000;  // simulate 10 ms
        $stop;
    end

endmodule
