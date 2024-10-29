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


    reg[DATA_WIDTH-1:0] tmp_matrix[0:MATRIX_HEIGH-1][0:MATRIX_WIDTH-1];
    reg[DATA_WIDTH-1:0] sum;
    integer i, j, k;

    always@(posedge iclk)begin
        if(irst)begin
            sum <= 32'h0000;
            for(i = 0; i < MATRIX_HEIGH; i = i + 1)
                for(j = 0; j < MATRIX_WIDTH; j = j + 1)
                    tmp_matrix <= 32'h0000;
        end

        else begin
            for(i = 0; i < MATRIX_HEIGH; i = i + 1) begin
                for(j = 0; j < MATRIX_WIDTH; j = j + 1)begin
                    sum <= 32'h0000;
                    for(k = 0; k < MATRIX_ADJUST; k = k + 1)begin
                        sum <= sum + (A[i][k] + B[k][j]);
                    end
                    tmp_matrix[i][j] = alpha * sum + beta tmp_matrix[i][j];
                end
            end
        end
    end

    assign result_matrix = tmp_matrix;

endmodule