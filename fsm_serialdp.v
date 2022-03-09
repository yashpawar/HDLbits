module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //
    parameter NO_OF_DATA_BITS = 8;
	parameter start=0,data=1,stop=2,ds=3,discard=4,pc=5;
    reg [2:0] state,next_state;
    reg [3:0] dc,dc_next;
    
    wire in_bits,parval;
    assign in_bits = (state == data)|(state == pc);
    parity u0 (
        .clk(clk),
        .reset(~in_bits),
        .in(in),
        .odd(parval)
    );
    reg par_reg;
    always @(posedge clk)
        if (state == stop) par_reg <= parval;
    
    always @(posedge clk)
        if (reset) state <= start;
    	else state <= next_state;
    always @(posedge clk)
        dc <= dc_next;
    assign done = (state == ds) & par_reg;
    always @(*) begin
        next_state = state;
        dc_next = 0;
        case (state)
            start : if (~in) next_state = data;
            data : begin
                if(dc==(NO_OF_DATA_BITS-1))
                    next_state = pc;
                dc_next = dc + 1;
            end
            pc : next_state = stop;
            stop: if(in) next_state = ds; else next_state = discard;
            ds: if(~in) next_state = data; else next_state = start;
            discard: if(in) next_state = start;
        endcase
    end
    // New: Datapath to latch input bits.
    reg [7:0] sr,sr_next;
    assign out_byte = sr;
    always @(posedge clk) sr <= sr_next;
    always @(*) begin
        sr_next = sr;
        if (state == data) begin
            sr_next = {in,sr[7:1]};
        end
    end

endmodule

