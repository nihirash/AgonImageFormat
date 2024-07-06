MAX_ARGS:   EQU     1
    include "crt.inc"
_main:
    ld hl, (argv)
    ld de, buffer
    ld bc, $fff0
    MOSCALL MOS_LOAD
    
    or a
    jp nz, cant_load

    xor a
    ld hl, buffer
    call agon_image_load
    jp nz, wrong_file

    ld hl, @show
    ld bc, @end - @show
    rst.lil $18

    MOSCALL MOS_GET_KEY

    ld hl, @clear
    ld bc, @clear_end - @clear
    rst.lil $18

    jp exit
@show:
    db 12, 23, 1, 0
    db "* Press any key for exit * "
    db 23, 27, 3
    dw 16, 16
@end:

@clear:
    db 23, 0, $A0, $ff, $ff, 2
    db 23, 1, 1
    db 12
    db "Bye!", 13, 10
@clear_end:


wrong_file:
    PRINTZ @msg
    jp exit
@msg:
    db 13, 10
    db "Wrong file provided!", 13, 10, 0

cant_load:
    PRINTZ @msg
    jp exit
@msg:
    db 13, 10
    db "Can't load file!", 13, 10, 0


no_args:
    PRINTZ @msg
    jp exit
@msg:
    db 13, 10
    db "Agon Graphics Image format viewer", 13, 10
    db "(c) 2024 Aleksandr Sharikhin ", 13, 10
    db 13, 10
    db "Usage: agi-view <filename>",13, 10, 0


    include "vdp-loader.asm"

buffer:
    db 0
