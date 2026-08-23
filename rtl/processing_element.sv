`timescale 1ns / 1ps

module processing_element #(
      parameter DATA_WIDTH = 8,
      parameter ACC_WIDTH  = 32
)(
      input  logic                          clk,
      input  logic                          rst_n,
      input  logic                          clr_acc,
      input  logic                          en_mac,
  input  logic signed [DATA_WIDTH-1:0]  in_a,     // Activation input (streamed horizontally)
  input  logic signed [DATA_WIDTH-1:0]  in_b,     // Weight input (streamed vertically)
  output logic signed [DATA_WIDTH-1:0]  out_a,    // Pass-through activation
  output logic signed [DATA_WIDTH-1:0]  out_b,    // Pass-through weight
  output logic signed [ACC_WIDTH-1:0]   accum_out // Accumulated partial sum
);

  logic signed [ACC_WIDTH-1:0] acc_reg;
  logic signed [DATA_WIDTH-1:0] reg_a, reg_b;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
                  acc_reg <= '0;
                  reg_a   <= '0;
                  reg_b   <= '0;
    end else begin
                  reg_a <= in_a;
                  reg_b <= in_b;

      if (clr_acc) begin
                        acc_reg <= in_a * in_b;
      end else if (en_mac) begin
        acc_reg <= acc_reg + (in_a * in_b);
      end
    end
  end

      assign out_a     = reg_a;
      assign out_b     = reg_b;
      assign accum_out = acc_reg;

endmodule
