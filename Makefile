# keep make from deleting these intermediates
.SECONDARY:

ZYNQ_ADDR=192.168.42.50
ZYNQ_WRITE_PATH=/tmp
ZYNQ_PASS=1234

DERP_PASS=fake

all: zynq.run

clean:
	@rm snap* ||:

app.v:
	python app.py
	@sshpass -p $(DERP_PASS) scp app.v rdaly@derp.stanford.edu:~/mthon/app/.

system.bit:
	@sshpass -p $(DERP_PASS) scp rdaly@derp.stanford.edu:~/mthon/system.bit .
	@sshpass -p $(DERP_PASS) scp rdaly@derp.stanford.edu:~/mthon/csrc/zynq .

zynq.run: system.bit
	@sshpass -p $(ZYNQ_PASS) ssh root@$(ZYNQ_ADDR) "echo 'fclk0' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_export" ||:
	@sshpass -p $(ZYNQ_PASS) ssh root@$(ZYNQ_ADDR) "echo 'fclk1' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_export" ||:
	@sshpass -p $(ZYNQ_PASS) ssh root@$(ZYNQ_ADDR) "echo '100000000' > /sys/class/fclk/fclk0/set_rate"
	@sshpass -p $(ZYNQ_PASS) ssh root@$(ZYNQ_ADDR) "echo '96000000' > /sys/class/fclk/fclk1/set_rate"
	@sshpass -p $(ZYNQ_PASS) scp system.bit zynq root@$(ZYNQ_ADDR):$(ZYNQ_WRITE_PATH)/.
	@sshpass -p $(ZYNQ_PASS) ssh root@$(ZYNQ_ADDR) "cat $(ZYNQ_WRITE_PATH)/system.bit > /dev/xdevcfg"
	@sshpass -p $(ZYNQ_PASS) ssh root@$(ZYNQ_ADDR) "$(ZYNQ_WRITE_PATH)/zynq 0 0 0" 
	@sshpass -p $(ZYNQ_PASS) ssh root@$(ZYNQ_ADDR) "echo 'fclk0' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_unexport" ||:
	@sshpass -p $(ZYNQ_PASS) ssh root@$(ZYNQ_ADDR) "echo 'fclk1' > /sys/devices/amba.0/f8007000.ps7-dev-cfg/fclk_unexport" ||:

%.open: %.raw
	terra ../misc/raw2bmp.t $*.raw $*.bmp out/campipe_ov7660.metadata.lua 0
	@convert $*.bmp -flip $*.bmp
	open $*.bmp

cam.v:
	terra campipe_ov7660.t
	terra ../misc/raw2bmp.t out/campipe_ov7660.raw out/campipe_ov7660.bmp out/campipe_ov7660.metadata.lua 0
	@cp out/campipe_ov7660.axi.v out/cam.v
