//BITS of 3 is pixel size 8, BITS of 4 is pixel size 16, etc
module app #(parameter BITS=3) (
    input clk,
    input rst_n,
    input [63:0] din,
    input din_valid,
    output din_ready,
    
    output [63:0] dout,
    output dout_valid,
    input dout_ready
);

  localparam PIXELWIDTH = 1<<BITS;

  wire [PIXELWIDTH-1:0] pixel_in;
  wire pixel_in_valid;
  wire pixel_in_ready;
  
  serializer #(.INLOGBITS(6), .OUTLOGBITS(BITS)) serinst(
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
  wire [PIXELWIDTH-1:0] pixel_out;
  wire pixel_out_valid;
  wire pixel_out_ready;


  //Here is the app.
  assign pixel_in_ready = pixel_out_ready;
  assign pixel_out_valid = pixel_in_valid;
  assign pixel_out = pixel_in+1'b1; //Dummy program to just add 1 to each pixel

  
  deserializer #(.INLOGBITS(BITS), .OUTLOGBITS(6)) deserinst(
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
