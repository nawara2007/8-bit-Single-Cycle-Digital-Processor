`timescale 1ns / 1ps
module topCPU_tp;

// inputs for uut
reg clk;
reg reset;
reg serial_in;

// outputs for uut 
wire [5:0] pc_out;
wire [15:0] instr;
wire zero;
wire reg_write;


//unit under test instantiate
topCPU uut (
	.clk(clk),
	.reset(reset),
	.serial_in(serial_in),
	.pc_out(pc_out),
	.instr(instr),
	.zero(zero),
	.reg_write(reg_write)

);

always #10 clk = ~clk; //clock generation cycle time_period = 20ns

//begin testing
initial begin

//initialize all values
clk = 0;
reset = 1;
serial_in = 0;

#40; //hold reset for two clock cycles to test it
reset = 0;

//moitor datapath
$monitor("Time=%0t | PC=%0d | Instr=%b | Zero=%b | RegWrite=%b", 
                 $time, pc_out, instr, zero, reg_write);

#250; // wait for all instructions to execute

//check for results

$display("\n================ FINAL REGISTER VALUES ================");
$display("R0 = %0d (Expected: 24)", uut.rf_inst.reg_file[0]);
$display("R1 = %0d (Expected: 3)", uut.rf_inst.reg_file[1]);
$display("R2 = %0d (Expected: 8)", uut.rf_inst.reg_file[2]);
$display("R3 = %0d (Expected: 6)", uut.rf_inst.reg_file[3]);
$display("Final PC = %0d (Expected: 14)", pc_out);
$display("=======================================================\n");


$stop;

end

endmodule
