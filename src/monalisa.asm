// Start with shared definitions...
include "Megaprocessor_defs.asm";

// *****************************************            
// Ensure the SGX libraries start at an address which
// won't conflict with our code.
org 0x4000;
include "sgx/sgx.asm";


// *****************************************            
// Our code...
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

        jsr     sgx_graphics_DrawSurface_clearScreen;


        ld.w    r2, #INT_RAM_START + 16;
        ld.w    r3, #TXT_MONA;
        jsr     sgx_graphics_Font_draw;

        // Prepare the image
        ld.w    r3, #IMG_MONA_LISA;
        jsr     sgx_graphics_DrawSurface_setFillTexture;

        // Draw the image
        ld.w    r2, #INT_RAM_START + 48;
        jsr     sgx_graphics_DrawSurface_fillPoint;


        ld.w    r2, #INT_RAM_START + 48 + 170;
        ld.w    r3, #TXT_LISA;
        jsr     sgx_graphics_Font_draw;


busy_loop:
        // head
        ld.b    r0, #0;
        jmp busy_loop;

    

TXT_MONA equ $;
    db 4;
    db FONT_UC_M, FONT_LC_O, FONT_LC_N, FONT_LC_A;

TXT_LISA equ $;
    db 4;
    db FONT_UC_L, FONT_LC_I, FONT_LC_S, FONT_LC_A;

IMG_MONA_LISA        equ     $;
    db 4, 164;  // width of image (in bytes), height of image (in rows)
    db 0,0,0,0,0,128,3,0,0,240,15,0,0,248,63,0,0,252,127,0,0,230,126,0,0,6,254,0,0,2,252,0,0,2,248,1,0,3,240,1,0,131,255,1,0,207,247,1,0,11,240,1,128,3,240,1,128,3,240,3,128,83,248,3,128,99,248,3,128,119,248,3,128,79,252,3,128,15,254,3,128,159,255,3,128,63,243,7,0,63,224,7,0,63,192,15,0,31,192,15,0,15,192,31,0,7,192,31,0,3,192,63,192,1,192,63,224,0,192,63,240,0,192,127,248,1,240,127,120,3,248,127,252,62,252,1,254,23,127,0,254,63,31,0,254,255,7,0,192,255,3,0,0,248,0,0,0,96,0,0,0,0,0,0;
