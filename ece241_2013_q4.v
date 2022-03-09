module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
	parameter A=0,M=1,N=2,O=3,P=4,Q=5,R=6;
    reg [2:0] state,next_state;
    reg FR1,FR2,FR3,DFR;
    assign fr1 = FR1;
    assign fr2 = FR2;
    assign fr3 = FR3;
    assign dfr = DFR;
    always @(posedge clk)
        if (reset) state <= A;
    	else state <= next_state;
    always @(*) begin
        next_state = state;
        case (state)
            A: if (s[1]) next_state =  M;
            M: 
                if (s[2]) next_state = O;
            	else if (~s[1]) next_state = N;
            O:
                if (s[3]) next_state = Q;
            	else if (~s[2]) next_state = P;
            Q: if (~s[3]) next_state = R;
            N: if (s[1]) next_state = M;
            P : 
                if (s[2]) next_state = O;
            	else if(~s[1]) next_state =N;
            R: 
                if (s[3]) next_state = Q;
            else if(~s[2]) next_state = P;
        endcase
    end
    always @(*)
        case (state)
        	A: begin
                FR1 = 1;
            	FR2 = 1;
                FR3 = 1;
                DFR = 1;
            end
            M: begin
                FR1 = 1;
            	FR2 = 1;
                FR3 = 0;
                DFR = 0;
            end
            N: begin
                FR1 = 1;
            	FR2 = 1;
                FR3 = 1;
                DFR = 1;
            end
            O: begin
                FR1 = 1;
            	FR2 = 0;
                FR3 = 0;
                DFR = 0;
            end
            P: begin
                FR1 = 1;
            	FR2 = 1;
                FR3 = 0;
                DFR = 1;
            end
            Q: begin
                FR1 = 0;
            	FR2 = 0;
                FR3 = 0;
                DFR = 0;
            end
            R: begin
                FR1 = 1;
            	FR2 = 0;
                FR3 = 0;
                DFR = 1;
            end
            default: begin
                FR1 = 0;
            	FR2 = 0;
                FR3 = 0;
                DFR = 0;
            end
        endcase
endmodule
