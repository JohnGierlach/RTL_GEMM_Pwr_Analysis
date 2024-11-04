module gemm_tb();
    
    parameter DATA_WIDTH = 64, MATRIX_WIDTH = 4, MATRIX_HEIGHT = 4, MATRIX_ADJUST = 4;
    
    reg iclk, irst, istart;
    logic signed [DATA_WIDTH-1:0] ia_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1];
    logic signed [DATA_WIDTH-1:0] ib_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1];
    logic signed [DATA_WIDTH-1:0] ic_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1];
    reg[DATA_WIDTH-1:0] ialpha, ibeta;

    wire[DATA_WIDTH-1:0] oresult_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1];
    wire obusy, odone;


    gemm_top UUT(.iclk(iclk),
                 .irst(irst),
                 .istart(istart),
                 .ialpha(ialpha),
                 .ibeta(ibeta),
                 .ia_matrix(ia_matrix),
                 .ib_matrix(ib_matrix),
                 .ic_matrix(ic_matrix),
                 .oresult_matrix(oresult_matrix),
                 .obusy(obusy),
                 .odone(odone));
    
    real A_tmp, B_tmp, C_tmp;
    integer i, j, A_file, B_file, C_file;
    initial begin

        A_file = $fopen("C:/Users/JohnG/Desktop/Codes/Projects/RTL_GEMM_Pwr_Consumption/RTL_GEMM_Pwr_Analysis/sw/matrix_vals/A_Matrix.txt", "r");
        B_file = $fopen("C:/Users/JohnG/Desktop/Codes/Projects/RTL_GEMM_Pwr_Consumption/RTL_GEMM_Pwr_Analysis/sw/matrix_vals/B_Matrix.txt", "r");
        C_file = $fopen("C:/Users/JohnG/Desktop/Codes/Projects/RTL_GEMM_Pwr_Consumption/RTL_GEMM_Pwr_Analysis/sw/matrix_vals/C_Matrix.txt", "r");

        for(i = 0; i < MATRIX_HEIGHT; i = i + 1)begin
            for(j = 0; j < MATRIX_WIDTH; j = j + 1)begin
                $fscanf(A_file, "%f", A_tmp);
                $fscanf(B_file, "%f", B_tmp);
                $fscanf(C_file, "%f", C_tmp);
                
                ia_matrix[i][j] = A_tmp;
                ib_matrix[i][j] = B_tmp;
                ic_matrix[i][j] = C_tmp;
                
            end
        end

        irst = 1;
        iclk = 1;
        ialpha = 1;
        ibeta = 1;
        istart = 0;
        #10
        istart = 1;
        irst = 0;
        #10;
    end
    
    always@(posedge iclk)begin
        if(odone)
            istart = 0;
        
        if(oresult_matrix[0][0] != 0)
            $finish;
    end
    
    always #10 iclk = ~iclk;

endmodule