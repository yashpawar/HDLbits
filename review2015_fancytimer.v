module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );
    wire count_ena,count_ena1000,done_counting;
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
    wire shift_ena;
    assign shift_ena = (state == s1101)|(state == sh1)|(state == sh2)|(state == sh3);
    assign counting = (state==cn);
    assign done = (state==dn);
    
	wire cnt_ena,cnt_ena1000;
    reg [3:0] cnt,next_cnt;
    always @(posedge clk) cnt <= next_cnt;
    assign next_cnt = count_ena?(cnt-1):(shift_ena?{cnt[2:0],data}:cnt);
    
    reg [9:0] cnt1000,next_cnt1000;
    always @(posedge clk) cnt1000 <= next_cnt1000;
    assign next_cnt1000 = count_ena1000?((cnt1000 == 0)?(1000-1):(cnt1000-1)):(shift_ena?(1000-1):cnt1000);
    
    assign count_ena = (cnt1000 == 0) & count_ena1000;
    assign count_ena1000 = counting;
    assign done_counting = (cnt == 0) & (cnt1000 == 0);
    
    assign count = cnt;
endmodule
