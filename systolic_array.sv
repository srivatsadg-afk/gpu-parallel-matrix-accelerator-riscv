`timescale 1ns / 1ps

module systolic_array #(
      parameter ARRAY_SIZE = 4,
      parameter DATA_WIDTH = 8,
      parameter ACC_WIDTH  = 32
)(
      input  logic                                clk,
      input  logic                                rst_n,
      input  logic                                clr_acc,
      input  logic                                en_mac,
  input  logic signed [DATA_WIDTH-1:0]        in_a [ARRAY_SIZE],
  input  logic signed [DATA_WIDTH-1:0]        in_b [ARRAY_SIZE],
  output logic signed [ACC_WIDTH-1:0]         out_c [ARRAY_SIZE][ARRAY_SIZE]
);

  logic signed [DATA_WIDTH-1:0] a_wire [ARRAY_SIZE][ARRAY_SIZE+1];
  logic signed [DATA_WIDTH-1:0] b_wire [ARRAY_SIZE+1][ARRAY_SIZE];

      genvar r, c;
      generate
        for (r = 0; r < ARRAY_SIZE; r++) begin : gen_in_a
          assign a_wire[r][0] = in_a[r];
        end
        for (c = 0; c < ARRAY_SIZE; c++) begin : gen_in_b
          assign b_wire[0][c] = in_b[c];
        end
      endgenerate

      generate
        for (r = 0; r < ARRAY_SIZE; r++) begin : row_gen
          for (c = 0; c < ARRAY_SIZE; c++) begin : col_gen
            processing_element #(
              .DATA_WIDTH(DATA_WIDTH),
              .ACC_WIDTH(ACC_WIDTH)
            ) pe_inst (
              .clk(clk),
              .rst_n(rst_n),
              .clr_acc(clr_acc),
              .en_mac(en_mac),
              .in_a(a_wire[r][c]),
              .in_b(b_wire[r][c]),
              .out_a(a_wire[r][c+1]),
              .out_b(b_wire[r+1][c]),
              .accum_out(out_c[r][c])
            );
          end
        end
      endgenerate

endmodule
