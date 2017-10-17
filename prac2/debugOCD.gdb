target remote localhost:3333

monitor soft_reset_halt
load hello.elf 0x00400000
b _start
b loop

