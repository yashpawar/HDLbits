module top_module (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q);
    reg [3:0] state,next_state;
    always @(posedge clk) state <= next_state;
    assign next_state = count_ena?(state-1):(shift_ena?{state[2:0],data}:state);
    assign q = state;
endmodule
