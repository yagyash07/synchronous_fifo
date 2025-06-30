module sync_fifo#(parameter DEPTH = 8 )(
    input clk,
    input rst_n,
    input wr_en_i,
    input [7:0] data_i,
    output full_o,

    input rd_en_i,
    output reg[7:0] data_o,
    output empty_o
)

reg[7:0] mem[0:DEPTH -1];

reg[2:0] wr_ptr;
reg[2:0] rd_ptr;
reg[3:0] count;

assign full_o= (count== DEPTH);
// assign full_o= (count== DEPTH)?1:0;
assign empty_o= (count==0);

//-----handle with write process
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wr_ptr <=3'b0;
    end else begin
        if (wr_en_i ==1) begin
            mem [wr_ptr]<= data_i;
            wr_ptr<= wr_ptr+1;
        end
    end
end

//-handle with read process
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_ptr <=3'b0;
    end else begin
        if (rd_en_i ==1) begin
            data_o <=mem[rd_ptr];
            rd_ptr<= rd_ptr+1;
        end
    end
end

//handle with count
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count<= 4'b0;
    end else begin
        case ({wr_en_i,rd_en_i})
            2'b10 :count<=count+1;
            2'b01 :count<=count-1;
            2'b11 :count<=count+0;
            2'b00 :count<=count+0;
            default : count<count;
        endcase
    end
end
           
endmodule