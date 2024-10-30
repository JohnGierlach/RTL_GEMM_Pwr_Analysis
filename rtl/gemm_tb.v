module gemm_tb();
    
    parameter DATA_WIDTH = 32, MATRIX_WIDTH = 4, MATRIX_HEIGHT = 4, MATRIX_ADJUST = 4;
    
    reg iclk, irst;
    real a_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1];
    real b_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1];
    real c_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1];
    reg [DATA_WIDTH-1:0] alpha, beta;

    wire real result_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1];


    gemm_top UUT(.iclk(iclk),
                 .irst(irst),
                 .alpha(alpha),
                 .beta(beta),
                 .a_matrix(a_matrix),
                 .b_matrix(b_matrix),
                 .c_matrix(c_matrix),
                 .result_matrix(result_matrix));
    
    real A_tmp, B_tmp, C_tmp;
    integer i, j, file;
    initial begin

        A_file $fopen("C:/Users/JohnG/Desktop/Codes/Projects/RTL_GEMM_Pwr_Consumption/RTL_GEMM_Pwr_Analysis/sw/matrix_vals/A_Matrix", "r");
        B_file $fopen("C:/Users/JohnG/Desktop/Codes/Projects/RTL_GEMM_Pwr_Consumption/RTL_GEMM_Pwr_Analysis/sw/matrix_vals/B_Matrix", "r");
        C_file $fopen("C:/Users/JohnG/Desktop/Codes/Projects/RTL_GEMM_Pwr_Consumption/RTL_GEMM_Pwr_Analysis/sw/matrix_vals/C_Matrix", "r");

        for(i = 0; i < MATRIX_HEIGH; i = i + 1)begin
            for(j = 0; j < MATRIX_WIDTH; j = j + 1)begin
                $fscanf(A_file, "%f", A_tmp);
                $fscanf(B_file, "%f", B_tmp);
                $fscanf(C_file, "%f", C_tmp);
                
                a_matrix[i][j] = A_tmp;
                b_matrix[i][j] = B_tmp;
                c_matrix[i][j] = C_tmp;
                
            end
        end

        irst = 1;
        iclk = 1;
        alpha = 1;
        beta = 1;
        #10
        irst = 0;
        #10
    end

    always #10 iclk = ~iclk;

endmodule