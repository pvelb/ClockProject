

module blinking (

    input CLOCK_50,
    output reg [6:0] catodes,
	output reg[3:0] digits,
    output reg secondsPoint,
	output reg [9:0] seconds
);
	 reg [15:0] counter;
	 reg [8:0] secCounter;
	 reg clock500;
	 
	 
	 reg [6:0] symb0;//Symbols memory
	 reg [6:0] symb1;
	 reg [6:0] symb2;
	 reg [6:0] symb3;
	 
	 reg[3:0] sec60ones;
	 reg[3:0] sec60decs;
	 reg[3:0] min60ones;
	 reg[3:0] min60decs;
	 initial begin
			digits=4'b1110;
			catodes=7'b1111111;
			symb0=7'b1111111;
			symb1=7'b1111111;
			symb2=7'b1111111;
			symb3=7'b1111111;
			secondsPoint=1'b0;
			seconds=10'b1111111111;
		 end
	
    always @ (posedge CLOCK_50) begin//clock prescalrer
        counter <= counter + 1'b1;
		  if (counter==49999)begin
				counter<=0;
				clock500<=~clock500;
		  end
    end
	 
	always @ (posedge clock500) begin//dinamic indication
			case(digits)  
			4'b1110: begin	digits=4'b1101; catodes<=symb2; 	end//2
			4'b1101: begin digits=4'b1011; catodes<=symb1;  end//1     
			4'b1011: begin digits=4'b0111; catodes<=symb0;  end//0    
			4'b0111: begin digits=4'b1110; catodes<=symb3; 	end//3
			default: begin digits=4'b1110; catodes<=7'b1111111;  	end
			endcase
			
			secCounter<=secCounter+ 1'b1;//to 1/2 seconds prescaler
			if(secCounter==249)begin//250
			secCounter<=0;
			secondsPoint<=~secondsPoint;
			end
	 end
	 
	always @ (negedge secondsPoint) begin//seconds counter
			seconds<=seconds+1'b1;
			sec60ones<=sec60ones+1'b1;
			if(sec60ones==9)begin
				sec60ones<=4'b0000;
				sec60decs<=sec60decs+1'b1;
			end
			
			if(sec60decs==5 && sec60ones==9)begin
				sec60decs<=4'b0000;
				min60ones<=min60ones+1'b1;
			end
			if(min60ones==9 && sec60decs==5 && sec60ones==9)begin
				min60ones<=4'b0000;
				min60decs<=min60decs+1'b1;
			end
			if(min60decs==5 && min60ones==9 && sec60decs==5 && sec60ones==9)begin
				min60decs<=4'b0000;
			end
			case(sec60ones)  
			4'b0000: symb3<=7'b0001000;//0	
			4'b0001: symb3<=7'b1101110;//1   
			4'b0010: symb3<=7'b0010010;//2     
			4'b0011: symb3<=7'b1000010;//3 
			4'b0100: symb3<=7'b1100100;//4
			4'b0101: symb3<=7'b1000001;//5 
			4'b0110: symb3<=7'b0000001;//6 
			4'b0111: symb3<=7'b1101010;//7 
			4'b1000: symb3<=7'b0000000;//8
			4'b1001: symb3<=7'b1000000;//9 
			default: symb3<=7'b1111111;  	
			endcase
			case(sec60decs)  
			4'b0000: symb2<=7'b0001000;//0	
			4'b0001: symb2<=7'b1101110;//1   
			4'b0010: symb2<=7'b0010010;//2     
			4'b0011: symb2<=7'b1000010;//3 
			4'b0100: symb2<=7'b1100100;//4
			4'b0101: symb2<=7'b1000001;//5 
			4'b0110: symb2<=7'b0000001;//6 
			4'b0111: symb2<=7'b1101010;//7 
			4'b1000: symb2<=7'b0000000;//8
			4'b1001: symb2<=7'b1000000;//9 
			default: symb2<=7'b1111111;  	
			endcase
			case(min60ones)  
			4'b0000: symb1<=7'b0001000;//0	
			4'b0001: symb1<=7'b1101110;//1   
			4'b0010: symb1<=7'b0010010;//2     
			4'b0011: symb1<=7'b1000010;//3 
			4'b0100: symb1<=7'b1100100;//4
			4'b0101: symb1<=7'b1000001;//5 
			4'b0110: symb1<=7'b0000001;//6 
			4'b0111: symb1<=7'b1101010;//7 
			4'b1000: symb1<=7'b0000000;//8
			4'b1001: symb1<=7'b1000000;//9 
			default: symb1<=7'b1111111;  	
			endcase
			case(min60decs)  
			4'b0000: symb0<=7'b0001000;//0	
			4'b0001: symb0<=7'b1101110;//1   
			4'b0010: symb0<=7'b0010010;//2     
			4'b0011: symb0<=7'b1000010;//3 
			4'b0100: symb0<=7'b1100100;//4
			4'b0101: symb0<=7'b1000001;//5 
			4'b0110: symb0<=7'b0000001;//6 
			4'b0111: symb0<=7'b1101010;//7 
			4'b1000: symb0<=7'b0000000;//8
			4'b1001: symb0<=7'b1000000;//9 
			default: symb0<=7'b1111111;  	
			endcase
			
	 end

endmodule


module segDecoder(sin, sout);
input wire [3:0] sin;
output wire [6:0] sout;
reg [6:0] symb0;

  always @ (sin)
  begin
   case(min60decs)  
		4'b0000: symb0<=7'b0001000;//0	
		4'b0001: symb0<=7'b1101110;//1   
		4'b0010: symb0<=7'b0010010;//2     
		4'b0011: symb0<=7'b1000010;//3 
		4'b0100: symb0<=7'b1100100;//4
		4'b0101: symb0<=7'b1000001;//5 
		4'b0110: symb0<=7'b0000001;//6 
		4'b0111: symb0<=7'b1101010;//7 
		4'b1000: symb0<=7'b0000000;//8
		4'b1001: symb0<=7'b1000000;//9 
		default: symb0<=7'b1111111;  	
		endcase
  end 

  assign sout = symb0;

endmodule

module cntr #(parameter width=4) (clk, res, out);

input wire clk, res;
output reg [width-1:0] out; initial out <= {width{1'b0}};

always @(posedge clk or posedge res) begin
  if (res) begin
    out <= 0;
  end else begin 
    out <= out + 1'b1;
  end
end

endmodule
