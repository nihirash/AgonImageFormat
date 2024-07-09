MAX_ARGS:   EQU     3
    include "crt.inc"
_main:
    ld hl, (argv)
    call read_hex
    ld hl, (argv + 3)
    call agon_image_load_from_file
    or a
    jp z, exit
    cp 1
    jp z, cant_load
    
    cp 2
    jp z, wrong_file

    ld hl, @unhandled
    ld bc, 0
    xor a
    rst.lil $18
    jp exit
@unhandled:
    db 13, 10, "Some unhandled error happens", 13, 10, 0

read_hex:
	ld		a, (hl)
    cp 'a'
    jr c, @uc
    cp 'z'
    jr nc, @uc
    sub a, 32
@uc:
    call @hex
    add	a, a
    add	a, a
    add	a, a
    add	a, a
    ld	d, a
    inc	hl
    ld	a, (hl)
    call @hex
    or d
    inc hl
    ret
@hex:
    sub		a, '0'
    cp		10
    ret		c
    sub		a,'A'-'0'-10
    ret


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
    db "Agon Graphics Image format loader", 13, 10
    db "(c) 2024 Aleksandr Sharikhin ", 13, 10
    db 13, 10
    db "Usage: agi-load <number-of-buffer> <filename>",13, 10, 0


    include "../agon-image-file-loader.asm"