`timescale 1ps/1ps

module gemm_top
#(DATA_WIDTH = 32,
  MATRIX_WIDTH = 4,
  MATRIX_HEIGHT = 4,
  MATRIX_ADJUST = 4)(
    input iclk, irst,
    input[DATA_WIDTH-1:0] alpha, beta,
    input real a_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1],
    input real b_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1],
    input real c_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1],
    output real result_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1]
);


    real tmp_matrix[0:MATRIX_HEIGH-1][0:MATRIX_WIDTH-1];
    real sum;
    integer i, j, k;

    always@(posedge iclk)begin
        if(irst)begin
            sum <= 32'h0000
            tmp_matrix <= c_matrix;
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