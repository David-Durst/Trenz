`include "macros.vh"
module topvga
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
    inout DDR_VRP,

    output VGA_VS_n,
    output VGA_HS_n,
    output [4:0] VGA_red,
    output [4:0] VGA_green,
    output [4:0] VGA_blue

  );
    
    `include "ps7_include.vh";
    
 

    wire FCLK0;
    BUFG bufg0(.I(FCLKCLK[0]),.O(FCLK0));
    wire FCLK1;
    BUFG bufg1(.I(FCLKCLK[1]),.O(FCLK1));
    
    wire rst_n;
    assign ARESETN = FCLKRESETN[0];
    assign rst_n = ARESETN;
 
    wire CLK_25M;
    wire CLK_24M;
    wire CLK_48M;
   
      
    ClkCtrl clks(
        .CLKIN_100M(FCLK0),
        .CLKIN_96M(FCLK1),
        .CLK_25M(CLK_25M),
        .CLK_24M(CLK_24M),
        .CLK_48M(CLK_48M),
        .rst_n(rst_n)
    );
    

    wire XCLK_DIV;
    
  
    // debug counters
    
    wire [31:0] cam_debug[3:0];
    
    wire [7:0] display_debug;
    
    wire [31:0] MMIO_CMD;
    wire [31:0] MMIO_CAM0_CMD;
    wire [31:0] MMIO_CAM1_CMD;
    wire [31:0] MMIO_FRAME_BYTES0;
    wire [31:0] MMIO_TRIBUF_ADDR0;
    wire [31:0] MMIO_FRAME_BYTES1;
    wire [31:0] MMIO_TRIBUF_ADDR1;
    wire [31:0] MMIO_FRAME_BYTES2;
    wire [31:0] MMIO_TRIBUF_ADDR2;

    wire rw_cam0_cmd_valid;
    wire [17:0] rw_cam0_resp;
    wire rw_cam0_resp_valid;
    
    wire rw_cam1_cmd_valid;
    wire [17:0] rw_cam1_resp;
    wire rw_cam1_resp_valid;
    

    wire [31:0] pipe_in_cnt;
    wire [31:0] pipe_out_cnt;
    wire [31:0] pipe_in_tot;
    wire [31:0] pipe_out_tot;

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
        .MMIO_FRAME_BYTES2(MMIO_FRAME_BYTES2[31:0]),
        .MMIO_TRIBUF_ADDR2(MMIO_TRIBUF_ADDR2[31:0]),
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
        
        .rw_cam0_cmd_valid(rw_cam0_cmd_valid), 
        .rw_cam0_resp(rw_cam0_resp[17:0]),// {err,rw,addr,data}
        .rw_cam0_resp_valid(rw_cam0_resp_valid),
        
        .rw_cam1_cmd_valid(rw_cam1_cmd_valid), 
        .rw_cam1_resp(rw_cam1_resp[17:0]),// {err,rw,addr,data}
        .rw_cam1_resp_valid(rw_cam1_resp_valid),
        
        .MMIO_IRQ()
    );


    wire startall;
    wire stopall;
    assign startall = (MMIO_CMD == `CMD_START);
    assign stopall = (MMIO_CMD == `CMD_STOP);


    
    // Writer
    wire wr_sync2; 
    wire wr_frame_valid2;
    wire wr_frame_ready2;
    wire [31:0] wr_FRAME_BYTES2;
    wire [31:0] wr_BUF_ADDR2;
    wire wr_frame_done2;
     
    //Read interface 
    wire rd_sync2; // allows you to sync frame reads
    wire rd_frame_valid2;
    wire rd_frame_ready2;
    wire [31:0] rd_FRAME_BYTES2;
    wire [31:0] rd_BUF_ADDR2;
    wire rd_frame_done2;

    assign wr_sync2 = 1'b1;
    assign rd_sync2 = 1'b1;

    tribuf_ctrl tribuf_ctrl2(

        .fclk(FCLK0),
        .rst_n(rst_n),

        //MMIO interface
        .start(startall),
        .stop(stopall),
        .FRAME_BYTES(MMIO_FRAME_BYTES2[31:0]),
        .TRIBUF_ADDR(MMIO_TRIBUF_ADDR2[31:0]),

        //Write interface (final renderer)
        
        .wr_sync(wr_sync2),
        .wr_frame_valid(wr_frame_valid2),
        .wr_frame_ready(wr_frame_ready2),
        .wr_FRAME_BYTES(wr_FRAME_BYTES2[31:0]),
        .wr_BUF_ADDR(wr_BUF_ADDR2[31:0]),
        .wr_frame_done(wr_frame_done2),
        //Read interface pipe
        .rd_sync(rd_sync2),
        .rd_frame_valid(rd_frame_valid2),
        .rd_frame_ready(rd_frame_ready2),
        .rd_FRAME_BYTES(rd_FRAME_BYTES2[31:0]),
        .rd_BUF_ADDR(rd_BUF_ADDR2[31:0]),
        .rd_frame_done(rd_frame_done2),

        .debug_wr_ptr(),
        .debug_wr_cs(),
        .debug_rd_cs(),
        .debug_rd_ptr()
    );
    
    wire [63:0] pipe2dramw_data;
    wire pipe2dramw_valid;
    wire pipe2dramw_ready;

    app myapp(
        .clk(FCLK0),
        .rst_n(rst_n),
        .data(pipe2dramw_data),
        .valid(pipe2dramw_valid),
        .ready(pipe2dramw_ready),
        .tap(MMIO_PIPE0)
    );

    DramWriterBuf pipe_writer2(
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
        
        .wr_frame_valid(wr_frame_valid2),
        .wr_frame_ready(wr_frame_ready2),
        .wr_FRAME_BYTES(wr_FRAME_BYTES2[31:0]),
        .wr_BUF_ADDR(wr_BUF_ADDR2[31:0]),
    
        .debug_astate(),

        .din_valid(pipe2dramw_valid),
        .din_ready(pipe2dramw_ready),
        .din(pipe2dramw_data[63:0])
    );


    //-----------------------------------------------------------------------------
    



    wire [31:0] cur_vga_addr;
    wire [7:0] VGA_red_full;
    wire [7:0] VGA_green_full;
    wire [7:0] VGA_blue_full;

    wire [31:0] vga_cmd;
    wire vga_cmd_valid;
    assign vga_cmd = startall ? `CMD_START : stopall ? `CMD_STOP : 32'h0;
    assign vga_cmd_valid = startall | stopall;
    
    wire dramr2display_burst_ready;
    wire dramr2display_valid;
    wire dramr2display_ready;
    wire [63:0] dramr2display_data;
    
    DramReader vga_reader2(
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
        
        .rd_frame_valid(rd_frame_valid2),
        .rd_frame_ready(rd_frame_ready2),
        .rd_FRAME_BYTES(rd_FRAME_BYTES2[31:0]),
        .rd_BUF_ADDR(rd_BUF_ADDR2[31:0]),

        .debug_astate(),

        .dout_burst_ready(dramr2display_burst_ready),
        .dout_ready(dramr2display_ready),
        .dout_valid(dramr2display_valid),
        .dout(dramr2display_data[63:0])
    );

    wire pvalid;

    display vga_display(
        .fclk(FCLK0),
        .rst_n(rst_n),
        .vgaclk(CLK_25M),
        
        .vga_cmd(vga_cmd),
        .vga_cmd_valid(vga_cmd_valid),
        .vga_cmd_ready(),

        .VGA_VS_n(VGA_VS_n),
        .VGA_HS_n(VGA_HS_n),
        .VGA_red(VGA_red_full[7:0]),
        .VGA_green(VGA_green_full[7:0]),
        .VGA_blue(VGA_blue_full[7:0]),
        .pvalid(pvalid),
        .sdata_burst_ready(dramr2display_burst_ready),
        .sdata_valid(dramr2display_valid),
        .sdata_ready(dramr2display_ready),
        .sdata(dramr2display_data[63:0]),

        .debug(display_debug[7:0])
    );
    
    assign VGA_red[4:0] = pvalid ? VGA_red_full[7:3] : 0;
    assign VGA_green[4:0] = pvalid ? VGA_green_full[7:3] : 0;
    assign VGA_blue[4:0] = pvalid ? VGA_blue_full[7:3] : 0;


endmodule : topvga

