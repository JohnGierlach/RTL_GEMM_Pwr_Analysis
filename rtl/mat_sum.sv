module mat_sum
#(DATA_WIDTH = 64,
  MATRIX_WIDTH = 4,
  MATRIX_HEIGHT = 4,
  MATRIX_ADJUST = 4)(
    input iclk, irst,
    input logic signed [DATA_WIDTH-1:0] ia_matrix_tile,
    input logic signed [DATA_WIDTH-1:0] ib_matrix_tile,
    output[DATA_WIDTH-1:0] osum
);

assign osum = (ia_matrix_tile * ib_matrix_tile);

endmodule