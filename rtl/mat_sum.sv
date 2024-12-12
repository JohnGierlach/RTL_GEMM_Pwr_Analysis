module mat_sum
#(DATA_WIDTH = 64,
  MATRIX_WIDTH = 4,
  MATRIX_HEIGHT = 4,
  MATRIX_ADJUST = 4)(
    input iclk, irst,
    input reg[DATA_WIDTH-1:0] icurr_sum;
    input logic signed [DATA_WIDTH-1:0] ia_matrix_tile,
    input logic signed [DATA_WIDTH-1:0] ib_matrix_tile,
    output reg[DATA_WIDTH-1:0] osum
);


reg[DATA_WIDTH-1:0] tmp_sum;


always@(posedge iclk)begin
  if(irst)
    tmp_sum <= 64'h0000;
  else
    tmp_sum <= icurr_sum + (ia_matrix_tile * ib_matrix_tile);
end

assign osum = tmp_sum;

endmodule