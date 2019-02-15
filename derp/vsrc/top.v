`include "macros.vh"
module top
  (
    inout [53:0] MIO,
    inout PS_SRSTB,
    inout PS_CLK,
    inout PS_PORB,
    inout DDR_Clk,
    inout DDR_Clk_n,
    inout DDR_CKE,
    inout DDR_CS_n,
    inout DDR_RAS_n,
    inout DDR_CAS_n,
    output DDR_WEB,
    inout [2:0] DDR_BankAddr,
    inout [14:0] DDR_Addr,
    inout DDR_ODT,
    inout DDR_DRSTB,
    inout [31:0] DDR_DQ,
    inout [3:0] DDR_DM,
    inout [3:0] DDR_DQS,
    inout [3:0] DDR_DQS_n,
    inout DDR_VRN,
    inout DDR_VRP
  );
    
    `include "ps7_include.vh";
    
 

    wire FCLK0;
    BUFG bufg0(.I(FCLKCLK[0]),.O(FCLK0));
    
    wire rst_n;
    assign ARESETN = FCLKRESETN[0];
    assign rst_n = ARESETN;

    // debug counters
    
    
    
    wire [31:0] MMIO_CMD;
    wire [31:0] MMIO_CAM0_CMD;
    wire [31:0] MMIO_CAM1_CMD;
    wire [31:0] MMIO_FRAME_BYTES0;
    wire [31:0] MMIO_TRIBUF_ADDR0;
    wire [31:0] MMIO_FRAME_BYTES1;
    wire [31:0] MMIO_TRIBUF_ADDR1;
    wire [31:0] MMIO_FRAME_BYTES2;
    wire [31:0] MMIO_TRIBUF_ADDR2;

    wire [31:0] debug[15:0];

    wire [31:0] MMIO_PIPE0;
    wire [31:0] MMIO_PIPE1;
    wire [31:0] MMIO_PIPE2;
    wire [31:0] MMIO_PIPE3;

    MMIO_slave mmio(
        .fclk(FCLK0),
        .rst_n(rst_n),
        .S_AXI_ACLK(S2M_GP0_AXI_ACLK),
        .S_AXI_ARADDR(S2M_GP0_AXI_ARADDR), 
        .S_AXI_ARID(S2M_GP0_AXI_ARID),  
        .S_AXI_ARREADY(S2M_GP0_AXI_ARREADY), 
        .S_AXI_ARVALID(S2M_GP0_AXI_ARVALID), 
        .S_AXI_AWADDR(S2M_GP0_AXI_AWADDR), 
        .S_AXI_AWID(S2M_GP0_AXI_AWID), 
        .S_AXI_AWREADY(S2M_GP0_AXI_AWREADY), 
        .S_AXI_AWVALID(S2M_GP0_AXI_AWVALID), 
        .S_AXI_BID(S2M_GP0_AXI_BID), 
        .S_AXI_BREADY(S2M_GP0_AXI_BREADY), 
        .S_AXI_BRESP(S2M_GP0_AXI_BRESP), 
        .S_AXI_BVALID(S2M_GP0_AXI_BVALID), 
        .S_AXI_RDATA(S2M_GP0_AXI_RDATA), 
        .S_AXI_RID(S2M_GP0_AXI_RID), 
        .S_AXI_RLAST(S2M_GP0_AXI_RLAST), 
        .S_AXI_RREADY(S2M_GP0_AXI_RREADY), 
        .S_AXI_RRESP(S2M_GP0_AXI_RRESP), 
        .S_AXI_RVALID(S2M_GP0_AXI_RVALID), 
        .S_AXI_WDATA(S2M_GP0_AXI_WDATA), 
        .S_AXI_WREADY(S2M_GP0_AXI_WREADY), 
        .S_AXI_WSTRB(S2M_GP0_AXI_WSTRB), 
        .S_AXI_WVALID(S2M_GP0_AXI_WVALID),

        .MMIO_CMD(MMIO_CMD[31:0]),
        .MMIO_CAM0_CMD(MMIO_CAM0_CMD[31:0]),
        .MMIO_CAM1_CMD(MMIO_CAM1_CMD[31:0]),
        .MMIO_FRAME_BYTES0(MMIO_FRAME_BYTES0[31:0]),
        .MMIO_TRIBUF_ADDR0(MMIO_TRIBUF_ADDR0[31:0]),
        .MMIO_FRAME_BYTES1(MMIO_FRAME_BYTES1[31:0]),
        .MMIO_TRIBUF_ADDR1(MMIO_TRIBUF_ADDR1[31:0]),
        .MMIO_FRAME_BYTES2(),
        .MMIO_TRIBUF_ADDR2(),
        .MMIO_PIPE0(MMIO_PIPE0[31:0]),
        .MMIO_PIPE1(MMIO_PIPE1[31:0]),
        .MMIO_PIPE2(MMIO_PIPE2[31:0]),
        .MMIO_PIPE3(MMIO_PIPE3[31:0]),
        .debug0(debug[0]), 
        .debug1(debug[1]), 
        .debug2(debug[2]), 
        .debug3(debug[3]), 
        .debug4(debug[4]), 
        .debug5(debug[5]), 
        .debug6(debug[6]), 
        .debug7(debug[7]), 
        .debug8(debug[8]), 
        .debug9(debug[9]), 
        .debug10(debug[10]), 
        .debug11(debug[11]), 
        .debug12(debug[12]), 
        .debug13(debug[13]), 
        .debug14(debug[14]), 
        .debug15(debug[15]), 
        
        .rw_cam0_cmd_valid(), 
        .rw_cam0_resp('h0),// {err,rw,addr,data}
        .rw_cam0_resp_valid(1'h0),
        
        .rw_cam1_cmd_valid(), 
        .rw_cam1_resp('h0),// {err,rw,addr,data}
        .rw_cam1_resp_valid(1'h0),
        
        .MMIO_IRQ()
    );


    wire startall;
    wire stopall;
    assign startall = (MMIO_CMD == `CMD_START);
    assign stopall = (MMIO_CMD == `CMD_STOP);

    wire load_addr;
    wire rd_frame_ready;
    wire wr_frame_ready;

    //Small FSM to load the addresses
    localparam IDLE=2'h0, AXI_WAIT=2'b1, LOAD_ADDR=2'h2;
    reg [1:0] CS;
    reg [1:0] NS;
    always @(*) begin
      case(CS)
        IDLE: begin
          NS = startall ? AXI_WAIT : IDLE;
        end
        AXI_WAIT: begin
          NS = rd_frame_ready & wr_frame_ready ? LOAD_ADDR : AXI_WAIT;
        end
        LOAD_ADDR: begin
          NS = IDLE;
        end
      endcase
    end
    `REG(FCLK0, CS, IDLE, NS)
    assign load_addr = CS==LOAD_ADDR;

    wire [63:0] dramr2app_data;
    wire dramr2app_valid;
    wire dramr2app_ready;

    DramReaderBuf preapp_reader(
        .fclk(FCLK0),
        .rst_n(rst_n),
        
        .M2S_AXI_ACLK(), // clock is already driven
        .M2S_AXI_ARADDR(M2S_HP2_AXI_ARADDR),
        .M2S_AXI_ARREADY(M2S_HP2_AXI_ARREADY),
        .M2S_AXI_ARVALID(M2S_HP2_AXI_ARVALID),
        .M2S_AXI_RDATA(M2S_HP2_AXI_RDATA),
        .M2S_AXI_RREADY(M2S_HP2_AXI_RREADY),
        .M2S_AXI_RRESP(M2S_HP2_AXI_RRESP),
        .M2S_AXI_RVALID(M2S_HP2_AXI_RVALID),
        .M2S_AXI_RLAST(M2S_HP2_AXI_RLAST),
        .M2S_AXI_ARLEN(M2S_HP2_AXI_ARLEN),
        .M2S_AXI_ARSIZE(M2S_HP2_AXI_ARSIZE),
        .M2S_AXI_ARBURST(M2S_HP2_AXI_ARBURST),
        
        .rd_frame_valid(load_addr),
        .rd_frame_ready(rd_frame_ready),
        .rd_FRAME_BYTES(MMIO_FRAME_BYTES0[31:0]),
        .rd_BUF_ADDR(MMIO_TRIBUF_ADDR0[31:0]),

        .debug_astate(),

        .dout_ready(dramr2app_ready),
        .dout_valid(dramr2app_valid),
        .dout(dramr2app_data[63:0])
    );

    wire [63:0] app2dramw_data;
    wire app2dramw_valid;
    wire app2dramw_ready;


    app myapp(
        .clk(FCLK0),
        .rst_n(rst_n),
        .din(dramr2app_data[63:0]),
        .din_valid(dramr2app_valid),
        .din_ready(dramr2app_ready),
        .dout(app2dramw_data[63:0]),
        .dout_valid(app2dramw_valid),
        .dout_ready(app2dramw_ready)
    );

    DramWriterBuf app_writer(
        .fclk(FCLK0),
        .rst_n(rst_n),
        
        .M2S_AXI_ACLK(M2S_HP2_AXI_ACLK),
        .M2S_AXI_AWADDR(M2S_HP2_AXI_AWADDR),
        .M2S_AXI_AWREADY(M2S_HP2_AXI_AWREADY),
        .M2S_AXI_AWVALID(M2S_HP2_AXI_AWVALID),
        .M2S_AXI_WDATA(M2S_HP2_AXI_WDATA),
        .M2S_AXI_WREADY(M2S_HP2_AXI_WREADY),
        .M2S_AXI_WVALID(M2S_HP2_AXI_WVALID),
        .M2S_AXI_WLAST(M2S_HP2_AXI_WLAST),
        .M2S_AXI_WSTRB(M2S_HP2_AXI_WSTRB),
        
        .M2S_AXI_BRESP(M2S_HP2_AXI_BRESP),
        .M2S_AXI_BREADY(M2S_HP2_AXI_BREADY),
        .M2S_AXI_BVALID(M2S_HP2_AXI_BVALID),
        
        .M2S_AXI_AWLEN(M2S_HP2_AXI_AWLEN),
        .M2S_AXI_AWSIZE(M2S_HP2_AXI_AWSIZE),
        .M2S_AXI_AWBURST(M2S_HP2_AXI_AWBURST),
        
        .wr_frame_valid(load_addr),
        .wr_frame_ready(wr_frame_ready),
        .wr_FRAME_BYTES(MMIO_FRAME_BYTES1[31:0]),
        .wr_BUF_ADDR(MMIO_TRIBUF_ADDR1[31:0]),
    
        .debug_astate(),

        .din_valid(app2dramw_valid),
        .din_ready(app2dramw_ready),
        .din(app2dramw_data[63:0])
    );

endmodule : top

