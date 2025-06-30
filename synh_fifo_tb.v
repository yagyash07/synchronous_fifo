`timescale 1ps/1ps

`define clk_period 10
module sync_fifo_tb();
    parameter DEPTH=8;
    reg clk,rst_n;
    reg wr_en_i,rd_en_i;
    reg[7:0]data_i;

    wire [7:0] data_o;
    wire full_o ,empty_o;

sync_fifo #(DEPTH) uut(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en_i(wr_en_i),
    .data_i(data_i),
    .rd_en_i(rd_en_i),
    .data_o(data_o),
    .full_o(full_o),
    .empty_o(empty_o)

);
initial clk=1'b1;
always #(`clk_period/2) clk=~clk;

integer i;
initial begin
     rst_n=1'b1;

     wr_en_i=1'b0;
     rd_en_i=1'b0;

     data_i=8'b0;

     #(`clk_period);
     rst_n=1'b0;    //reset system

     #(`clk_period);
     rst_n=1'b1;  //finish reset

     //write data
     wr_en_i=1'b1;
     rd_en_i=1'b0;

     for(i=0; i<8; i=i+1) begin
        data_i=i;
        #(`clk_period);
     end

     //read data
     wr_en_i=1'b0;
     rd_en_i=1'b1;

     for(i=0; i<8; i=i+1) begin
        #(`clk_period);
     end

     wr_en_i=1'b1;
     rd_en_i=1'b0;

     for(i=0; i<8; i=i+1) begin
        data_i=i;
        #(`clk_period);
     end
     #(`clk_period);
     #(`clk_period);
     #(`clk_period);

     $stop;
end

endmodule





