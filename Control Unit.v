module controlUnit(
	input [15:0] instr,
	input zero,
	output reg reg_write, wb_src,
	output reg[3:0] alu_op,
	output reg[1:0] pc_src
);

always @(*) begin
	// Default safe values
        reg_write = 1'b0;
        alu_op    = 4'b0000;
        pc_src    = 2'b00;
        wb_src    = 1'b0;
	case (instr[15:14])
		2'b00: begin 
			reg_write = 1'b1;
			alu_op = instr[13:10];
			wb_src = 1'b0; // load to the register file
			pc_src = 2'b00;
		end
		2'b01: begin
			reg_write = 1'b1;
			alu_op = 4'b0000;
			wb_src = 1'b1; //immediate load to the instruction memory
			pc_src = 2'b00;
		end
		2'b10: begin
			if (instr[13:12] == 2'b00) begin // JUMP
				reg_write = 1'b0;
				alu_op = 4'b0000;
				wb_src = 1'b0;
				pc_src = 2'b01;
			end else if (instr[13:12] == 2'b01) begin // BRANCH IF EQUAL
				reg_write = 1'b0;
				alu_op = 4'b0001;
				wb_src = 1'b0;
				pc_src = zero ? 2'b10 : 2'b00;
			end else if (instr[13:12] == 2'b10) begin // BRANCH IF NOT EQUAL
				reg_write = 1'b0;
				alu_op = 4'b0001;
				wb_src = 1'b0;
				pc_src = !zero ? 2'b10 : 2'b00;
			end
		end
		2'b11: begin
			if (instr[13:12] == 2'b00) begin
				reg_write = 1'b0;
				alu_op = 4'b0000;
				wb_src = 1'b0;
				pc_src = 2'b11;
			end else begin
				reg_write = 1'b0;
				alu_op = 4'b0000;
				wb_src = 1'b0;
				pc_src = 2'b00;
			end
		end
	endcase
end

endmodule
