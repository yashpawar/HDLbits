module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter L=0,LF=1,LD=2,R=3,RF=4,RD=5,S=6;
    reg [2:0] state,next_state;
    reg [4:0] fall_cnt,fall_cnt_next;
    always @(posedge clk,posedge areset)
        if (areset) begin
            state <= L;
            fall_cnt <= 0;
        end
    	else begin
            state <= next_state;
            fall_cnt <= fall_cnt_next;
        end
    always @(*) begin
        next_state = state;
        fall_cnt_next = 0;
        case (state)
        	L:
                if (ground) begin
                    if (dig) begin
                       next_state = LD; 
                    end
                    else begin
                        if (bump_left) next_state = R;
                    end
                end
            	else begin
                   next_state = LF; 
                end
            R:
                if (ground) begin
                    if (dig) begin
                       next_state = RD; 
                    end
                    else begin
                        if (bump_right) next_state = L;
                    end
                end
            	else begin
                   next_state = RF; 
                end
            LD: if(~ground) next_state = LF;
            RD: if(~ground) next_state = RF;
            LF: begin
                if(fall_cnt < 31) 
                    fall_cnt_next = fall_cnt + 1;
                else
                    fall_cnt_next = fall_cnt;
                if(ground) begin
                    if(fall_cnt < 20) next_state = L;
                    else next_state = S;
                end
            end
            RF: begin
                if(fall_cnt < 31) 
                    fall_cnt_next = fall_cnt + 1;
                else
                    fall_cnt_next = fall_cnt;
                if(ground) begin
                    if(fall_cnt < 20) next_state = R;
                    else next_state = S;
                end
            end
            S: next_state = S;
        endcase
    end
    assign walk_left = (state == L);
    assign walk_right = (state == R);
    assign aaah = (state == LF) | (state == RF);
    assign digging = (state == LD) | (state == RD);
endmodule
