# Setup instructions

## On your laptop (MacOS)
* Install `sshpass`
  * One option from https://gist.github.com/arunoda/7790979:  
    `brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb`
* Go to Networks pane in MacOS settings
    * Add a new interface and manually configure (Apple USB Ethernet Adapter), name = Trenz
    * Configure manually, IP Address = 192.168.42.51, Subnet Mask = 255.255.255.0
    * Check connection with ping
      ```
      ❯ ping 192.168.42.50
      PING 192.168.42.50 (192.168.42.50): 56 data bytes
      64 bytes from 192.168.42.50: icmp_seq=0 ttl=64 time=2.940 ms
      64 bytes from 192.168.42.50: icmp_seq=1 ttl=64 time=0.577 ms
      ```
    * Check with `ssh root@192.168.42.50`, password = 1234

## On derp
* Clone this repository
* Add `. /opt/Xilinx/14.7/ISE_DS/settings64.sh` to your `.profile` and source it
* In `Trenz/derp`, try `make`

## On MacOs
* In `Trenz/Mac`, update the makefile variables DERP_USER and DERP_PASS and TRENZ_PATH
* Type `make`, you should get dropped into an interactive prompt, in `Trenz/Mac` you should see `system.bit` and `zynq` copied from `derp`
* Try write `w 0 ffff` to change the screen color to tealish.
    ```
~/repos/Trenz/Mac master*
❯ make
STARTING STREAM
Entering Interactive mode!
Commands:
        Pipe reg read:  r <regNum>
        Pipe reg write: w <regNum> <value>
        Cam reg read:   cr <camid> <addr>
        Cam reg write:  cw <camid> <addr> <value>
        Save to disk:   s
        Help:           h
        Stop cmd:       <Anything else>
>w 0 ffff
WROTE 0xffff to pipe reg 0x00
>
    ```

