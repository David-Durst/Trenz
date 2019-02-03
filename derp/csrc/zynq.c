/*
 * This test application is to read/write data directly from/to the device 
 * from userspace. 
 * 
 */
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <assert.h>
#include <stdbool.h>
#include "zynqlib.h"


uint32_t frame_size = 640*480;

int main(int argc, char *argv[]) {

    unsigned gpio_addr = MMIO_STARTADDR;
    
    unsigned buf0_addr = 0x30008000;
    
    unsigned  buf1_addr = buf0_addr + frame_size;
    
    unsigned page_size = sysconf(_SC_PAGESIZE);
    
    int fd = open ("/dev/mem", O_RDWR);
    if (fd < 1) {
        perror(argv[0]);
        return -1;
    }

    void* buf0_ptr = mmap(NULL, frame_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, buf0_addr);
    if (buf0_ptr == MAP_FAILED) {
        printf("FAILED mmap for buf0 %x\n",buf0_addr);
        exit(1);
    }
    
    void* buf1_ptr = mmap(NULL, frame_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, buf1_addr);
    if (buf1_ptr == MAP_FAILED) {
        printf("FAILED mmap for buf0 %x\n",buf1_addr);
        exit(1);
    }


    //TODO Write image into buf0_ptr



    //Write a simple pattern into write location for debugging
    for(uint32_t i=0;i<frame_size*4; i++ ) {
        *(unsigned char*)(buf0_ptr+i)= i%256; 
    }
    
    // mmap the device into memory 
    // This mmaps the control region (the MMIO for the control registers).
    void * gpioptr = mmap(NULL, page_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, gpio_addr);
    if (gpioptr == MAP_FAILED) {
        printf("FAILED mmap for gpio_addr %x\n",gpio_addr);
        exit(1);
    }
   
    volatile Conf * conf = (Conf*) gpioptr;

    write_mmio(conf, MMIO_TRIBUF_ADDR(0), buf0_addr,0);
    write_mmio(conf, MMIO_FRAME_BYTES(0), frame_size,0);
    write_mmio(conf, MMIO_TRIBUF_ADDR(1), buf1_addr,0);
    write_mmio(conf, MMIO_FRAME_BYTES(1), frame_size,0);
    
    printf("STARTING STREAM\n");
    fflush(stdout);
    
    write_mmio(conf, MMIO_CMD, CMD_START,0);
    
    for (int i=0; i<5; i++) {
      printf("Sleeping %d",i);
      fflush(stdout);
      sleep(1);
    }
    write_mmio(conf, MMIO_CMD, CMD_STOP,0);
    printf("STOPPING STREAM\n");
    fflush(stdout);
    sleep(1);
  return 0;
}



