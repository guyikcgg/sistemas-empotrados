file hello.elf
shell make check-openocd

conn

greset
wait
monitor load_image hello.elf
wait

b *0x400000
grestart

c
