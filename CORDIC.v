module sine_cosine( input clock, input signed [15:0] angle,input reset,input modes);

wire signed [15:0] arc_tan [0:14];
reg signed [15:0] sine;
integer count = 0;
assign arc_tan[00] = 16'b0010000000000000;
assign arc_tan[01] = 16'b0001001011100100;
assign arc_tan[02] = 16'b0000100111111011;
assign arc_tan[03] = 16'b0000010100010001;
assign arc_tan[04] = 16'b0000001010001011;
assign arc_tan[05] = 16'b0000000101000101;
assign arc_tan[06] = 16'b0000000010100010;
assign arc_tan[07] = 16'b0000000001010001;
assign arc_tan[08] = 16'b0000000000101000;
assign arc_tan[09] = 16'b0000000000010100;
assign arc_tan[10] = 16'b0000000000001010;
assign arc_tan[11] = 16'b0000000000000101;
assign arc_tan[12] = 16'b0000000000000010;
assign arc_tan[13] = 16'b0000000000000001;
assign arc_tan[14] = 16'b0000000000000000;

reg signed [15:0] x0;
reg signed [15:0] y0;
reg signed [15:0] x1;
reg signed [15:0] x2;
reg signed [15:0] y1;
reg signed [15:0] y2;
reg signed [15:0] z;
reg signed [15:0] z0;


always @(reset,angle)
	begin
	if(reset)
		begin
		 x0<=16'b0100101100110001;
		 y0<=16'b0000000000000000;
		 z0<=angle;
		 end
	else
		z0<=angle;	 
	end
	


always @ (posedge clock)
begin
	
	count <= count+1;
	if(count == 0) 
		begin
		x1<=x0;
		y1<=y0;
		z <=z0;
		end
   else if(count == 1)
		begin
			if(z[15])
			begin 
			 x2 <= x1 + y1;
			 y2 <= y1 - x1;
			 z <= z + arc_tan[00];
			 
			end
			else
			begin
			 x2 <= x1 - y1;
			 y2 <= y1 + x1;
			 z  <= z - arc_tan[00];
			 end
  	end
	
	else if(count%2==0)
		begin
			x1<=x2;
			y1<=y2;
		end
   else if(count == 31)
		begin
			sine <= y2;
			cosine <= x2;
		end
	
	else 
		begin 
		 if(z[15])
		 begin 
			 
		   x2 <= x1 + (y1>>>(count>>>1));
			y2 <= y1 - (x1>>>(count>>>1));
			z  <= z + (arc_tan[count>>>1]);
		
			sine <= x2;
			cosine <= y2;
		   end
		 
		 else
		 begin
			 x2 <= x1 - (y1>>>(count>>>1));
			 y2 <= y1 + (x1>>>(count>>>1));
			 z  <= z - (arc_tan[count>>>1]);
			
			 sine <= y2;
			 cosine <= x2;
		 end
		end
	
		 
	end
	endmodule
	

	