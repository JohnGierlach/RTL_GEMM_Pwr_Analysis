`timescale 1ps/1ps

module gemm_top
#(DATA_WIDTH = 64,
  MATRIX_WIDTH = 4,
  MATRIX_HEIGHT = 4,
  MATRIX_ADJUST = 4)(
    input iclk, irst, istart,
    input[DATA_WIDTH-1:0] ialpha, ibeta,
    input logic signed [DATA_WIDTH-1:0] ia_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1],
    input logic signed [DATA_WIDTH-1:0] ib_matrix [0:MATRIX_ADJUST-1][0:MATRIX_WIDTH-1],
    input logic signed [DATA_WIDTH-1:0] ic_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_ADJUST-1],
    output reg[DATA_WIDTH-1:0] oresult_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1],
    output obusy, odone
);
    
    // State Transition parameters
    localparam IDLE = 0, COMPUTE = 1, DONE = 2;
    
    reg[DATA_WIDTH-1:0] tmp_matrix [0:MATRIX_HEIGHT-1][0:MATRIX_WIDTH-1];
    reg[1:0] state, next_state;
    reg[DATA_WIDTH-1:0] partial_sum [0:MATRIX_WIDTH-1];
    reg[DATA_WIDTH-1:0] sum;
    int i, j;
    

    // Generate the matrix sum module in parallel
    genvar gen_k;
    generate
        for(gen_k = 0; gen_k < MATRIX_WIDTH; gen_k = gen_k + 1)begin:gendgenerate
            mat_sum #(
                .DATA_WIDTH(DATA_WIDTH)
            ) mat_sum_inst (
                .iclk(iclk),
                .irst(irst),
                .ia_matrix_tile(ia_matrix[i][gen_k]),
                .ib_matrix_tile(ib_matrix[gen_k][j]),
                .osum(partial_sum[gen_k])
            );
        end
    endgenerate

    // Add partial sums
    always@(*)begin
        sum = 0;
        for(int k = 0; k < MATRIX_WIDTH; k = k + 1)begin
            sum = sum + partial_sum[k];
        end
    end

    // State Transition Logic
    always@(*)begin
        case(state)
            IDLE: next_state = (istart) ? COMPUTE : IDLE;
            COMPUTE: next_state = (i == MATRIX_HEIGHT-1) && 
                                  (j == MATRIX_WIDTH-1) ? DONE : COMPUTE;
            DONE: next_state = IDLE;
        endcase
    end
    
    
    always@(posedge iclk)begin
        if(irst)
            state <= IDLE;
        
        else
            state <= next_state;
    end
    
    always@(posedge iclk)begin
        if(irst)begin
            i <= 0;
            j <= 0;
            for(i = 0; i < MATRIX_HEIGHT; i = i + 1) begin
                for(j = 0; j < MATRIX_WIDTH; j = j + 1)
                    tmp_matrix[i][j] <= ic_matrix[i][j];
            end
        end
        
        // Compute the matrix
        else if(state == COMPUTE)begin
            
                if(j < MATRIX_WIDTH)begin
                    tmp_matrix[i][j] <= (ialpha * sum) + (ibeta * tmp_matrix[i][j]);
                    j <= j + 1;
                end
                   
                else begin
                    j <= 0;
                    if(i < MATRIX_HEIGHT)
                        i <= i + 1;
                    else
                        i <= 0;
                end
        end

        else if(state == DONE)begin
            foreach (oresult_matrix[i,j]) oresult_matrix[i][j] <= tmp_matrix[i][j];
            i <= 0;
            j <= 0;
        end 
    end
    
    
    assign obusy = state == COMPUTE;
    assign odone = state == DONE;

endmodule