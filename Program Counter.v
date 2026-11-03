module programCounter (
	input clk, reset,
	input[1:0] pc_src, 
	input[5:0] target,
	output reg[5:0] pc_out
);

// pc_src --> 00 = PC+1, 01 = jump target, 10 = branch target, 11 = hold(HALT) 

always @(posedge clk) begin
	if(reset) begin
		pc_out <= 6'b000000;
	end else begin
		case(pc_src)
			2'b00: pc_out <=  pc_out + 6'b000001;
			2'b01: pc_out <= target;
			2'b10: pc_out <= target;
			2'b11: pc_out <= pc_out;
			default: pc_out <= pc_out;
		endcase
	end
		
end

endmodule









