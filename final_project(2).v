module final_project(
	output reg [7:0] DATA_R, DATA_G, DATA_B,
	output reg [6:0] Dis_7,
	output reg [2:0] COMM,
	output reg [1:0] COMM_CLK,
	output enable,
	input CLK, clear, Up, Down, Left, Right, Select
);
	reg [7:0] game [7:0];
	reg [7:0] user [7:0];
	reg [7:0] safe [7:0];
	reg [6:0] seg1, seg2;
	reg [3:0] BCD_s, BCD_m;
	reg up, down, left, right, select;
	byte cnt, cnt1, col, row;
	integer touch, cntSafe;
	
	segment7 S0(BCD_s, A0,B0,C0,D0,E0,F0,G0);
	segment7 S1(BCD_m, A1,B1,C1,D1,E1,F1,G1);
	divfreq div0(CLK, CLK_div);
	divfreq1 div1(CLK, CLK_time);
	divfreq2 div2(CLK, CLK_game);

	initial
		begin
			BCD_m = 0; BCD_s = 0;
			col = 0; row = 0;
			touch = 0; cntSafe = 0;
			safe[0] = 8'b11111111;
			safe[1] = 8'b11111111;
			safe[2] = 8'b11111111;
			safe[3] = 8'b11111111;
			safe[4] = 8'b11111111;
			safe[5] = 8'b11111111;
			safe[6] = 8'b11111111;
			safe[7] = 8'b11111111;
			DATA_R = 8'b11111111;
			DATA_G = 8'b11111111;
			DATA_B = 8'b11111111;
			game[0] = 8'b01111101;
			game[1] = 8'b11011110;
			game[2] = 8'b11111111;
			game[3] = 8'b11101111;
			game[4] = 8'b01110111;
			game[5] = 8'b11111101;
			game[6] = 8'b11111111;
			game[7] = 8'b11101110;
			/*game[0] = 8'b00000001;
			game[1] = 8'b00000000;
			game[2] = 8'b00000000;
			game[3] = 8'b00000000;
			game[4] = 8'b00000000;
			game[5] = 8'b00000000;
			game[6] = 8'b00000000;
			game[7] = 8'b00000000;*/
			user[0] = 8'b11111110;
			user[1] = 8'b11111111;
			user[2] = 8'b11111111;
			user[3] = 8'b11111111;
			user[4] = 8'b11111111;
			user[5] = 8'b11111111;
			user[6] = 8'b11111111;
			user[7] = 8'b11111111;
			cnt1 = 0;
		end

	always@(posedge CLK_div)
		begin
			seg1[0] = A0;
			seg1[1] = B0;
			seg1[2] = C0;
			seg1[3] = D0;
			seg1[4] = E0;
			seg1[5] = F0;
			seg1[6] = G0;
		
			seg2[0] = A1;
			seg2[1] = B1;
			seg2[2] = C1;
			seg2[3] = D1;
			seg2[4] = E1;
			seg2[5] = F1;
			seg2[6] = G1;
		
			if(cnt1 == 0)
				begin
					Dis_7 <= seg1;
					COMM_CLK[1] <= 1'b1;
					COMM_CLK[0] <= 1'b0;
					cnt1 <= 1'b1;
				end
			else if(cnt1 == 1)
				begin
					Dis_7 <= seg2;
					COMM_CLK[1] <= 1'b0;
					COMM_CLK[0] <= 1'b1;
					cnt1 <= 1'b0;
				end
		end
		
	always@(posedge CLK_time, posedge clear)
		begin
			if(clear)
				begin
					BCD_m = 3'b0;
					BCD_s = 4'b0;
				end
			else
				begin
					if(touch < 3)
						begin
							if(BCD_s >= 9)
								begin
									BCD_s <= 0;
									BCD_m <= BCD_m + 1;
								end
							else
								BCD_s <= BCD_s + 1;
							if(BCD_m >= 9) BCD_m <= 0;
						end
				end
		end
		
	always@(posedge CLK_div)
		begin
			if(cnt >= 7)
				cnt <= 0;
			else
				cnt <= cnt + 1;
			COMM = cnt;
			enable = 1'b1;
			
			if(clear == 1)
				DATA_R <= 8'b11111111;
				DATA_B <= 8'b11111111;
			if(touch < 1 && cntSafe < 54)
				begin
					DATA_B <= user[cnt];
					DATA_G <= safe[cnt];
				end
			else
				begin
					DATA_R <= game[cnt];
					DATA_B <= game[cnt];

				end
		end
			
	always@(posedge CLK_game)
		begin
			up = Up; down = Down; left = Left; right = Right;
			select = Select;
			
			if(clear == 1)
				begin
					touch = 0; cntSafe = 0;
					col = 0; row = 0;
					game[0] = 8'b01111101;
					game[1] = 8'b11011110;
					game[2] = 8'b11111111;
					game[3] = 8'b11101111;
					game[4] = 8'b01110111;
					game[5] = 8'b11111101;
					game[6] = 8'b11111111;
					game[7] = 8'b11101110;
					/*game[0] = 8'b00000001;
					game[1] = 8'b00000000;
					game[2] = 8'b00000000;
					game[3] = 8'b00000000;
					game[4] = 8'b00000000;
					game[5] = 8'b00000000;
					game[6] = 8'b00000000;
					game[7] = 8'b00000000;*/
					user[0] = 8'b11111110;
					user[1] = 8'b11111111;
					user[2] = 8'b11111111;
					user[3] = 8'b11111111;
					user[4] = 8'b11111111;
					user[5] = 8'b11111111;
					user[6] = 8'b11111111;
					user[7] = 8'b11111111;
					safe[0] = 8'b11111111;
					safe[1] = 8'b11111111;
					safe[2] = 8'b11111111;
					safe[3] = 8'b11111111;
					safe[4] = 8'b11111111;
					safe[5] = 8'b11111111;
					safe[6] = 8'b11111111;
					safe[7] = 8'b11111111;
				end
				
			if(touch < 1 && cntSafe < 54)
				begin
					if((up == 1) && (row != 0))
						begin
							user[col][row] = 1'b1;
							row = row - 1;
						end
					if((down == 1) && (row != 7))
						begin
							user[col][row] = 1'b1;
							row = row + 1;
						end
					if((left == 1) && (col != 0))
						begin
							user[col][row] = 1'b1;
							col = col - 1;
						end
					if((right == 1) && (col != 7))
						begin
							user[col][row] = 1'b1;
							col = col + 1;
						end
					user[col][row] = 1'b0;
					
					if((select == 1) && (game[col][row] == 1))
						begin
							safe[col][row] = 1'b0;
							cntSafe = cntSafe + 1;
						end
					if((select == 1) && (game[col][row] == 0))
						touch = touch + 1;
				end
			else if(cntSafe == 54)
				begin
					safe[0] = 8'b11111111;
					safe[1] = 8'b11111111;
					safe[2] = 8'b11111111;
					safe[3] = 8'b11111111;
					safe[4] = 8'b11111111;
					safe[5] = 8'b11111111;
					safe[6] = 8'b11111111;
					safe[7] = 8'b11111111;
					
					game[0] = 8'b11100011;
					game[1] = 8'b11011101;
					game[2] = 8'b10111101;
					game[3] = 8'b01111011;
					game[4] = 8'b01111011;
					game[5] = 8'b10111101;
					game[6] = 8'b11011101;
					game[7] = 8'b11100011;
				end
			else
				begin
					safe[0] = 8'b11111111;
					safe[1] = 8'b11111111;
					safe[2] = 8'b11111111;
					safe[3] = 8'b11111111;
					safe[4] = 8'b11111111;
					safe[5] = 8'b11111111;
					safe[6] = 8'b11111111;
					safe[7] = 8'b11111111;
					
					game[0] = 8'b01111110;
					game[1] = 8'b10111101;
					game[2] = 8'b11011011;
					game[3] = 8'b11100111;
					game[4] = 8'b11100111;
					game[5] = 8'b11011011;
					game[6] = 8'b10111101;
					game[7] = 8'b01111110;
				end
		end
endmodule

module segment7(input [0:3] a, output A,B,C,D,E,F,G);
	assign A = ~(a[0]&~a[1]&~a[2] | ~a[0]&a[2] | ~a[1]&~a[2]&~a[3] | ~a[0]&a[1]&a[3]),
	       B = ~(~a[0]&~a[1] | ~a[1]&~a[2] | ~a[0]&~a[2]&~a[3] | ~a[0]&a[2]&a[3]),
			 C = ~(~a[0]&a[1] | ~a[1]&~a[2] | ~a[0]&a[3]),
			 D = ~(a[0]&~a[1]&~a[2] | ~a[0]&~a[1]&a[2] | ~a[0]&a[2]&~a[3] | ~a[0]&a[1]&~a[2]&a[3] | ~a[1]&~a[2]&~a[3]),
			 E = ~(~a[1]&~a[2]&~a[3] | ~a[0]&a[2]&~a[3]),
			 F = ~(~a[0]&a[1]&~a[2] | ~a[0]&a[1]&~a[3] | a[0]&~a[1]&~a[2] | ~a[1]&~a[2]&~a[3]),
			 G = ~(a[0]&~a[1]&~a[2] | ~a[0]&~a[1]&a[2] | ~a[0]&a[1]&~a[2] | ~a[0]&a[2]&~a[3]);
endmodule

module divfreq(input CLK, output reg CLK_div);
  reg [24:0] Count;
  always @(posedge CLK)
    begin
      if(Count > 5000)
        begin
          Count <= 25'b0;
          CLK_div <= ~CLK_div;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule

module divfreq1(input CLK, output reg CLK_time);
  reg [25:0] Count;
  initial
    begin
      CLK_time = 0;
	 end	
		
  always @(posedge CLK)
    begin
      if(Count > 5000000)
        begin
          Count <= 25'b0;
          CLK_time <= ~CLK_time;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule

module divfreq2(input CLK, output reg CLK_game);
  reg [35:0] Count;
  initial
    begin
      CLK_game = 0;
	 end	
		
  always @(posedge CLK)
    begin
      if(Count > 3500000)
        begin
          Count <= 35'b0;
          CLK_game <= ~CLK_game;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule 