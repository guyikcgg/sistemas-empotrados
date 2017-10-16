@
@ Sistemas Empotrados
@ El "hola mundo" en la Redwire EconoTAG
@

@
@ Constantes
@

        @ Registro de control de dirección del GPIO32-GPIO63
        .set GPIO_PAD_DIR0,    0x80000000
        .set GPIO_PAD_DIR1,    0x80000004

        @ Data on GPIO000-GPIO031
        .set GPIO_DATA0,       0x80000008

        @ Registro de activación de bits del GPIO32-GPIO63
        .set GPIO_DATA_SET0,   0x80000048
        .set GPIO_DATA_SET1,   0x8000004c

        @ Registro de limpieza de bits del GPIO32-GPIO63
        .set GPIO_DATA_RESET0, 0x80000050
        .set GPIO_DATA_RESET1, 0x80000054

        @ El led rojo está en el GPIO 44 (el bit 12 de los registros GPIO_X_1)
        .set LED_RED_MASK,     (1 << (44-32))
        .set LED_GREEN_MASK,   (1 << (45-32))

        @ Switches
        .set SW2_INPUT_MASK,   (1 << 27)
        .set SW3_INPUT_MASK,   (1 << 26)
        .set SW2_OUTPUT_MASK,  (1 << 23)
        .set SW3_OUTPUT_MASK,  (1 << 22)

        @ Retardo para el parpadeo
        .set DELAY,            0x00100000

@
@ Punto de entrada
@

        .code 32
        .text
        .global _start
        .type   _start, %function

_start:
        @ Configuramos el GPIO44 para que sea de salida
        ldr     r4, =GPIO_PAD_DIR1
        ldr     r5, =LED_RED_MASK
        ldr     r6, =LED_GREEN_MASK
        orr     r5, r5, r6
        str     r5, [r4]

        @ Configuramos el GPIO23 y GPIO022 para que sean de salida
@        ldr     r4, =GPIO_PAD_DIR0
@        ldr     r5, =SW2_OUTPUT_MASK
@        ldr     r6, =SW3_OUTPUT_MASK
@        orr     r5, r5, r6
@        str     r5, [r4]

        @ Direcciones de los registros GPIO_DATA_SET1 y GPIO_DATA_RESET1
        ldr     r6, =GPIO_DATA_SET1
        ldr     r7, =GPIO_DATA_RESET1

@        ldr     r5, =LED_GREEN_MASK

        b       loop

led_select:
        @ Check buttons
        ldr     r4, =GPIO_DATA0
        subs    r4, r4, #SW2_INPUT_MASK
        beq     green_led

red_led:
        ldr     r5, =LED_RED_MASK
        b       blink

green_led:
        @ Direcciones de los registros GPIO_DATA_SET1 y GPIO_DATA_RESET1
        ldr     r5, =LED_GREEN_MASK
        b       blink

loop:
@        b       led_select

blink:
        @ Encendemos el led
        str     r5, [r6]

        @ Pausa corta
        ldr     r0, =DELAY
        bl      pause

        @ Apagamos el led
        str     r5, [r7]

        @ Pausa corta
        ldr     r0, =DELAY
        bl      pause

        @ Bucle infinito
        b       loop

@
@ Función que produce un retardo
@ r0: iteraciones del retardo
@
        .type   pause, %function
pause:
        subs    r0, r0, #1
        bne     pause
        mov     pc, lr

