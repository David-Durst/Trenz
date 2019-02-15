//BITS of 3 is pixel size 8, BITS of 4 is pixel size 16, etc
module app #(parameter IN_BITS=4,parameter OUT_BITS=3) (
    input clk,
    input rst_n,
    input [63:0] din,
    input din_valid,
    output din_ready,
    
    output [63:0] dout,
    output dout_valid,
    input dout_ready
);

  localparam PIXELWIDTH_IN = 1<<IN_BITS;
  localparam PIXELWIDTH_OUT = 1<<OUT_BITS;

  wire [PIXELWIDTH_IN-1:0] pixel_in;
  wire pixel_in_valid;
  wire pixel_in_ready;
  
  serializer #(.INLOGBITS(6), .OUTLOGBITS(IN_BITS)) serinst(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(din_valid),
    .in_ready(din_ready),
    .in_data(din[63:0]),
    .out_valid(pixel_in_valid),
    .out_ready(pixel_in_ready),
    .out_data(pixel_in)
  );
 
  //Deserializer
  wire [PIXELWIDTH_OUT-1:0] pixel_out;
  wire pixel_out_valid;
  wire pixel_out_ready;


  //Here is the app.
  //assign pixel_in_ready = pixel_out_ready;
  //assign pixel_out_valid = pixel_in_valid;
  //assign pixel_out = pixel_in+1'b1; //Dummy program to just add 1 to each pixel
  downsampleStencilChain1Per32_Circuit adderCirc(
    .CE(1'b1),
    .CLK(clk),
    .I0(pixel_in[7:0]),
    .I1(pixel_in[15:8]),
    .O0(pixel_out[7:0]),
    .ready_data_in(pixel_in_ready),
    .ready_data_out(pixel_out_ready),
    .valid_data_in(pixel_in_valid),
    .valid_data_out(pixel_out_valid)
  );

  
  deserializer #(.INLOGBITS(OUT_BITS), .OUTLOGBITS(6)) deserinst(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(pixel_out_valid),
    .in_ready(pixel_out_ready),
    .in_data(pixel_out),
    .out_valid(dout_valid),
    .out_ready(dout_ready),
    .out_data(dout[63:0])
  );

endmodule
