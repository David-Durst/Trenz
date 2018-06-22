module app(
    input clk,
    input rst_n,
    output [63:0] data,
    output valid,
    input ready,
    input [31:0] tap
);

reg [63:0] pixel;
assign valid = 1'b1;
wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;

assign red = tap[7:0];
assign green = tap[15:8];
assign blue = tap[23:16];

wire [31:0] rgb;
assign rgb = {8'h0,red,green,blue};

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        pixel <= 'h0;
    end
    else begin
        pixel <= {rgb,rgb};
    end
end

assign data = pixel;

endmodule
