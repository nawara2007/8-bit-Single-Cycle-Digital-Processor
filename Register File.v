module registerFile 
#(parameter addr_width = 2, data_width = 8)
(
	input clk, rst, wr_en,
	input[addr_width-1:0] wr_addr,
	input[data_width-1:0] wr_data,
	input[addr_width-1:0] rd_addr1, rd_addr2,
	output[data_width-1:0] rd_data1, rd_data2
);

localparam no_of_registers = (1<<addr_width);
//that means number of register equal 2^addr_width
reg [data_width-1:0] reg_file [0:no_of_registers-1];

assign rd_data1 = reg_file[rd_addr1];
assign rd_data2 = reg_file[rd_addr2];

integer i;
always@(posedge clk)
begin
	if(rst) 
	begin
		for(i=0; i < no_of_registers;i = i+1)
			reg_file[i] <= {data_width{1'b0}}; 
	end else if(wr_en)
	begin
		reg_file[wr_addr] <= wr_data;
	end
		
end

endmodule