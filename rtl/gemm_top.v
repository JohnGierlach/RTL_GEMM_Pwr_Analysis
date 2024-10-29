`timescale 1ps/1ps

module gemm_top
#(DATA_WIDTH = 32,
  MATRIX_WIDTH = 4,
  MATRIX_HEIGHT = 4,
  MATRIX_ADJUST = 4)(
    input iclk, irst,
    input[DATA_WIDTH-1:0] alpha, beta,
    input[DATA_WIDTH-1:0] a_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1],
    input[DATA_WIDTH-1:0] b_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1],
    input[DATA_WIDTH-1:0] c_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1],
    output[DATA_WIDTH-1:0] result_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1]
);


endmodule