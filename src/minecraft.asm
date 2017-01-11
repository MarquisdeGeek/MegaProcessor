// Start with shared definitions...
include "Megaprocessor_defs.asm";

// *****************************************            
// variables...
org 0x4000;
include "sgx/sgx.asm";


// *****************************************            
// Code...
        org  0;
        
// *****************************************            
// vectors
reset:       jmp    start;
             nop;
ext_int:     reti;
             nop;
             nop;
             nop;        
div_zero:    reti;
             nop;
             nop;
             nop;        
illegal:     reti;
             nop;
             nop;
             nop;

// *****************************************            
start:
        // give ourselves a stack
        ld.w    r0,#0x2000;
        move    sp,r0;
        
        // Initialize the font and other parameters
        jsr     sgx_init;

 
        
        ld.w    r3, #IMG_BRICK;
        jsr     sgx_graphics_DrawSurface_setFillTexture;

        ld.w    r2, #INT_RAM_START;
        ld.b    r0, #8;   // row count (in tiles)

next_wall_block:
        push    r0;
        ld.b    r1, #4;     // column count

next_wall_block_in_row:
        push    r1;
        push    r2;
        jsr     sgx_graphics_DrawSurface_fillPoint;
        pop     r2;
        pop     r1;

        inc     r2;

        dec     r1;
        bne     next_wall_block_in_row;

        pop     r0;

        // Skip the other 7 rows, since we've drawn them
        ld.w    r1, #28;
        add     r2, r1;

        dec     r0;
        bne     next_wall_block;


busy_loop:
        ld.b    r0, #0;
        jmp busy_loop;


IMG_BRICK   equ $;
    db 1, 8;        // number of bytes wide, number of rows
    db 128,128,128,255,8,8,8,255;

