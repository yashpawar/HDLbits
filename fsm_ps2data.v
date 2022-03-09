module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //
    
	parameter b1=0,b2=1,b3=2,ac=3;
    reg [1:0] state,next_state;
    // State transition logic (combinational)
    always @(*) begin
        next_state = state;
        case (state)
            b1: if (in[3]) next_state = b2;
            b2: next_state = b3;
            b3: next_state = ac;
            ac: if(in[3]) next_state = b2; else next_state = b1;
        endcase
    end
    // State flip-flops (sequential)
    always @(posedge clk)
        if (reset) state <= b1;
    	else state <= next_state;
    // Output logic
    assign done = (state == ac);
    
    // New: Datapath to store incoming bytes.
    reg [23:0] sr,sr_next;
    assign out_bytes = sr;
    always @(posedge clk)
        sr <= sr_next;
    always @(*) begin
        sr_next = sr;
        case (state)
            b1 : if (in[3]) sr_next = {sr[15:0],in};
            b2 : sr_next = {sr[15:0],in};
            b3 : sr_next = {sr[15:0],in};
            ac : if (in[3]) sr_next = {sr[15:0],in};
        endcase
    end

endmodule
