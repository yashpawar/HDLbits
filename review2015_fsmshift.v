module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    parameter A=0,B=1,C=2,D=3,E=4;
    reg [2:0] state,next_state;
    always @(posedge clk)
        if (reset) state <= A;
    	else state <= next_state;
    always @(*) begin
        next_state = state;
        case (state)
            A: next_state = B;
            B: next_state = C;
            C: next_state = D;
            D: next_state = E;
            E: next_state = E;
        endcase
    end
    assign shift_ena = (state != E);
endmodule
