module ALU
#(parameter n = 8)
(
	input wire [n-1:0] a, b,
	input wire [3:0] opcode,
	input wire serial_in,
	output reg [n-1:0] result,
	output wire zero
);

// Use blocking assignments (=) for combinational logic
always @ (*) begin
	case(opcode)
		4'b0000 : result = a + b;
		4'b0001 : result = a - b;
		4'b0010 : begin
			if(b!=0) 
				result = a / b; 
			else 
				result = 0;
		end
		4'b0011 : result = a * b;
		4'b0100 : result = {a[n-2:0], serial_in};
		4'b0101 : result = {a[n-2:0], a[n-1]};
		4'b0110 : result = ~a;
		4'b0111 : result = a + 1;
		4'b1001 : result = ~b;
		4'b1010 : result = (a & b);
		4'b1011 : result = ~(a & b);
		4'b1100 : result = ~(a | b);
		4'b1101 : result = a | b;
		4'b1110 : result = a ^ b;
		4'b1111 : result = a ^~ b;
		default : result = 0;
	endcase
end

assign zero = (result==0);

endmodule