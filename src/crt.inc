    ASSUME ADL=1
    org $40000
    jp _start

argc:
    db 0
argv:
    dl 0
    
    align 64
    db "MOS" ; Header
    db 00    ; Version
    db 01 	 ; ADL

_start:
    push ix
    push iy
    ld (stack_save), sp

    ld ix,argv
    call _parse_args
    
    di
    ld a, mb
    ld (old_mb), a
    xor a
    ld mb, a
    ei


    ld a,c
    ld (argc), a
    or a
    jp z, no_args
    
    jp _main
    
exit:
    di
    ld a, (old_mb)
    ld mb, a
    
    ld sp, (stack_save)

    pop iy
    pop ix

    ld hl, 0
    ei
    ret

old_mb:
    db 0

stack_save:
    dl 0

_parse_args:
    call _skip_spaces
    ld bc,0
    ld b,MAX_ARGS
_parse1:
    push bc
    push hl
    call _get_token
    ld a,c
    pop de
    pop bc
    and a
    ret z

    ld (ix+0),de
    push hl
    pop de
    call _skip_spaces
    xor a
    ld (de),a
    inc ix
    inc ix
    inc ix
    inc c
    ld a, c
    cp b
    jr c,_parse1
    ret

_get_token:
    ld c,0
@loop:
    ld a,(hl)
    or a
    ret z

    cp 13
    ret z

    cp 32
    ret z

    inc hl
    inc c

    jr @loop

_skip_spaces:
    ld a,(hl)
    cp 32
    ret nz
    inc hl
    jr _skip_spaces

    macro MOSCALL func
    ld a, func
    rst.lil $08
    endmacro

    macro PRINTZ ptr    
    ld hl, ptr
    ld bc, 0
    xor a
    rst.lil $18
    endmacro

MOS_LOAD:       equ     $01
MOS_GET_KEY:    equ     $00