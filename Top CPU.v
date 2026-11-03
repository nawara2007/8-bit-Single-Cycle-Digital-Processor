module topCPU (
	input wire clk, reset, serial_in,
	output wire[5:0] pc_out,
	output wire[15:0] instr,
	output wire zero, reg_write
	// output are wires in top-layer modules
);

/*--- internal wires ---*/

//for program counter:
wire [5:0]  target;
wire [1:0]  pc_src;

// for ALU:
wire [3:0]  alu_op;
wire [7:0]  alu_result;

//for register file:
wire [1:0]  wr_addr;
wire [7:0]  wr_data;

wire [1:0]  rd_addr1;
wire [1:0]  rd_addr2;
wire [7:0]  rd_data1;
wire [7:0]  rd_data2;

//for wb-src MUX & control unit:
wire wb_src;
wire [7:0]  immediate;


/*--- assignments ---*/
assign target = instr[5:0];

assign immediate = instr[11:4];

//rd is [9:8] if R-type, rd is [13:12] if I-type
assign wr_addr = (instr[15:14] == 2'b01) ? instr[13:12] : instr[9:8];

// rs1 & rs2  are [11:10] & [9:8] if Branch instruction
//rs1 & rs2 are [7:6] & [5:4] if R-type
assign rd_addr1 = (instr[15:14] == 2'b10) ? instr[11:10] : instr[7:6];
assign rd_addr2 = (instr[15:14] == 2'b10) ? instr[9:8]   : instr[5:4];

// load to register files from the immediate or the alu_result (write-back source)
assign wr_data = (wb_src) ? immediate : alu_result;


/*--- Modules Instantiation --*/
programCounter pc_inst (
	.clk(clk),
	.reset(reset),
	.pc_src(pc_src),
	.target(target),
	.pc_out(pc_out)
);

IMEM imem_inst (
	.addr(pc_out),
	.instr(instr)
);

ALU #(.n(8)) alu_inst (
	.a(rd_data1),
	.b(rd_data2),
	.opcode(alu_op),
	.serial_in(serial_in),
	.result(alu_result),
	.zero(zero)
);

registerFile #(.addr_width(2), .data_width(8)) rf_inst(
	.clk(clk),
	.rst(reset),
	.wr_en(reg_write),
	.wr_addr(wr_addr),
	.wr_data(wr_data),
	.rd_addr1(rd_addr1),
	.rd_addr2(rd_addr2),
	.rd_data1(rd_data1),
	.rd_data2(rd_data2)
);

controlUnit cu_inst (
	.instr(instr),
	.zero(zero),
	.reg_write(reg_write),
	.wb_src(wb_src),
	.alu_op(alu_op),
	.pc_src(pc_src)
	
);

endmodule