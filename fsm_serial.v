module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    parameter NO_OF_DATA_BITS = 8;
	parameter start=0,data=1,stop=2,ds=3,discard=4;
    reg [2:0] state,next_state;
    reg [3:0] dc,dc_next;
    always @(posedge clk)
        if (reset) state <= start;
    	else state <= next_state;
    always @(posedge clk)
        dc <= dc_next;
    assign done = (state == ds);
    always @(*) begin
        next_state = state;
        dc_next = 0;
        case (state)
            start : if (~in) next_state = data;
            data : begin
                if(dc==(NO_OF_DATA_BITS-1))
                    next_state =stop;
                dc_next = dc + 1;
            end
            stop: if(in) next_state = ds; else next_state = discard;
            ds: if(~in) next_state = data; else next_state = start;
            discard: if(in) next_state = start;
        endcase
    end
endmodule

