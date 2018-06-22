CAMERA_ADDR=192.168.42.50
CAMERA_WRITE_PATH=/tmp
CAMERA_PASS=1234


all: system.bit zynq

clean:
	rm OUT_*
	rm -rf xst xlnx_auto_0_xdb _xmsgs
	rm system*
	rm *.ngc

zynq:
	$(MAKE) -C csrc
	cp csrc/zynq build/.

system.bit:
	cp collateral/* .
	cp ngc/* .
	xst -ifn system.xst | tee OUT_xst.log
	ngdbuild -nt timestamp -uc ps7_constraints.ucf -uc system.ucf -p xc7z020-clg484-1 system.ngc system.ngd | tee OUT_ngd.log
	map -detail -p xc7z020-clg484-1 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -mt off -ir off -pr off -lc off -power off -o system_map.ncd system.ngd system.pcf | tee OUT_map.txt
	par -w -ol high -mt off system_map.ncd system.ncd system.pcf | tee OUT_par.txt
	trce -v 3 -s 1 -n 3 -fastpaths -xml system.twx system.ncd -o system.twr system.pcf -ucf ps7_constraints.ucf -ucf system.ucf | tee OUT_trce.txt
	bitgen -w -g Binary:no -g CRC:Enable -g ProgPin:PullUp -g InitPin:Pullup -g TckPin:PullUp -g TdiPin:PullUp \
	  -g TdoPin:PullUp -g TmsPin:PullUp -g Disable_JTAG:No -g UnusedPin:PullDown -g UserID:0xFFFFFFFF -g OverTempPowerDown:Disable \
	  -g USR_ACCESS:None -g JTAG_XADC:Enable -g DCIUpdateMode:AsRequired -g StartUpClk:CClk -g DONE_cycle:4 -g GTS_cycle:5 -g GWE_cycle:6 \
	  -g Match_cycle:Auto -g Security:None -g ICAP_select:Auto -g DonePipe:Yes -g DriveDone:No system.ncd | tee OUT_bitgen.txt
