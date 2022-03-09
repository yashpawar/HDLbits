module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
	parameter s0=0,s1=1,s11=2,s110=3,s1101=4,sh1=5,sh2=6,sh3=7,cn=8,dn=9;
    reg [3:0] state , next_state;
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
            s1101: next_state = sh1;
            sh1: next_state = sh2;
            sh2: next_state = sh3;
            sh3: next_state = cn;
            cn:if(done_counting) next_state = dn;
            dn:if(ack) next_state=s0;
        endcase
    end
    assign shift_ena = (state == s1101)|(state == sh1)|(state == sh2)|(state == sh3);
    assign counting = (state==cn);
    assign done = (state==dn);
endmodule
