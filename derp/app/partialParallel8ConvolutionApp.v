//BITS of 3 is pixel size 8, BITS of 4 is pixel size 16, etc
module app #(parameter BITS=6) (
    input clk,
    input rst_n,
    input [63:0] din,
    input din_valid,
    output din_ready,
    
    output [63:0] dout,
    output dout_valid,
    input dout_ready
);
/*
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
*/

  //Here is the app.
  //assign pixel_in_ready = pixel_out_ready;
  //assign pixel_out_valid = pixel_in_valid;
  //assign pixel_out = pixel_in+1'b1; //Dummy program to just add 1 to each pixel
  partialParallel8Convolution_Circuit adderCirc(
    .CE(1'b1),
    .CLK(clk),
    .I0(din[7:0]),
    .I1(din[15:8]),
    .I2(din[23:16]),
    .I3(din[31:24]),
    .I4(din[39:32]),
    .I5(din[47:40]),
    .I6(din[55:48]),
    .I7(din[63:56]),
    .O0(dout[7:0]),
    .O1(dout[15:8]),
    .O2(dout[23:16]),
    .O3(dout[31:24]),
    .O4(dout[39:32]),
    .O5(dout[47:40]),
    .O6(dout[55:48]),
    .O7(dout[63:56]),
    .ready_data_in(din_ready),
    .ready_data_out(dout_ready),
    .valid_data_in(din_valid),
    .valid_data_out(dout_valid)
  );
/*
  
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
*/
endmodule
