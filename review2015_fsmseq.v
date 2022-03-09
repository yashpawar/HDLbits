module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);
	parameter s0=0,s1=1,s11=2,s110=3,s1101=4;
    reg [2:0] state , next_state;
    always @(posedge clk)
        if(reset) state <= s0;
    	else state <= next_state;
    always @(*) begin
        next_state = state;
        case (state)
            s0:if(data) next_state = s1;
            s1:if(data) next_state = s11;else next_state = s0;
            s11:if (~data) next_state = s110; else next_state = s11;
            s110:if (data) next_state = s1101; else next_state = s0;
            s1101: next_state = s1101;
        endcase
    end
    assign start_shifting = (state == s1101);
endmodule
