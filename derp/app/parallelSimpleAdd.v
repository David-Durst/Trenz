module coreir_const #(parameter value=1, parameter width=1) (
  output [width-1:0] out
);
  assign out = value;

endmodule  // coreir_const

module coreir_add #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 + in1;

endmodule  // coreir_add

module parallelSimpleAdd_Circuit (
  input  CE,
  input  CLK,
  input [7:0] I0,
  input [7:0] I1,
  input [7:0] I2,
  input [7:0] I3,
  output [7:0] O0,
  output [7:0] O1,
  output [7:0] O2,
  output [7:0] O3,
  output  ready_data_in,
  input  ready_data_out,
  input  valid_data_in,
  output  valid_data_out
);


  // Instancing generated Module: coreir.add(width:8)
  wire [7:0] coreir_add8_inst0__in0;
  wire [7:0] coreir_add8_inst0__in1;
  wire [7:0] coreir_add8_inst0__out;
  coreir_add #(.width(8)) coreir_add8_inst0(
    .in0(coreir_add8_inst0__in0),
    .in1(coreir_add8_inst0__in1),
    .out(coreir_add8_inst0__out)
  );

  // Instancing generated Module: coreir.add(width:8)
  wire [7:0] coreir_add8_inst1__in0;
  wire [7:0] coreir_add8_inst1__in1;
  wire [7:0] coreir_add8_inst1__out;
  coreir_add #(.width(8)) coreir_add8_inst1(
    .in0(coreir_add8_inst1__in0),
    .in1(coreir_add8_inst1__in1),
    .out(coreir_add8_inst1__out)
  );

  // Instancing generated Module: coreir.add(width:8)
  wire [7:0] coreir_add8_inst2__in0;
  wire [7:0] coreir_add8_inst2__in1;
  wire [7:0] coreir_add8_inst2__out;
  coreir_add #(.width(8)) coreir_add8_inst2(
    .in0(coreir_add8_inst2__in0),
    .in1(coreir_add8_inst2__in1),
    .out(coreir_add8_inst2__out)
  );

  // Instancing generated Module: coreir.add(width:8)
  wire [7:0] coreir_add8_inst3__in0;
  wire [7:0] coreir_add8_inst3__in1;
  wire [7:0] coreir_add8_inst3__out;
  coreir_add #(.width(8)) coreir_add8_inst3(
    .in0(coreir_add8_inst3__in0),
    .in1(coreir_add8_inst3__in1),
    .out(coreir_add8_inst3__out)
  );

  // Instancing generated Module: coreir.const(width:8)
  wire [7:0] coreir_const81_inst0__out;
  coreir_const #(.value(8'h01),.width(8)) coreir_const81_inst0(
    .out(coreir_const81_inst0__out)
  );

  // Instancing generated Module: coreir.const(width:8)
  wire [7:0] coreir_const81_inst1__out;
  coreir_const #(.value(8'h01),.width(8)) coreir_const81_inst1(
    .out(coreir_const81_inst1__out)
  );

  // Instancing generated Module: coreir.const(width:8)
  wire [7:0] coreir_const81_inst2__out;
  coreir_const #(.value(8'h01),.width(8)) coreir_const81_inst2(
    .out(coreir_const81_inst2__out)
  );

  // Instancing generated Module: coreir.const(width:8)
  wire [7:0] coreir_const81_inst3__out;
  coreir_const #(.value(8'h01),.width(8)) coreir_const81_inst3(
    .out(coreir_const81_inst3__out)
  );

  assign coreir_add8_inst0__in0[7:0] = I0[7:0];

  assign coreir_add8_inst0__in1[7:0] = coreir_const81_inst0__out[7:0];

  assign O0[7:0] = coreir_add8_inst0__out[7:0];

  assign coreir_add8_inst1__in0[7:0] = I1[7:0];

  assign coreir_add8_inst1__in1[7:0] = coreir_const81_inst1__out[7:0];

  assign O1[7:0] = coreir_add8_inst1__out[7:0];

  assign coreir_add8_inst2__in0[7:0] = I2[7:0];

  assign coreir_add8_inst2__in1[7:0] = coreir_const81_inst2__out[7:0];

  assign O2[7:0] = coreir_add8_inst2__out[7:0];

  assign coreir_add8_inst3__in0[7:0] = I3[7:0];

  assign coreir_add8_inst3__in1[7:0] = coreir_const81_inst3__out[7:0];

  assign O3[7:0] = coreir_add8_inst3__out[7:0];

  assign ready_data_in = ready_data_out;

  assign valid_data_out = valid_data_in;


endmodule  // parallelSimpleAdd_Circuit

