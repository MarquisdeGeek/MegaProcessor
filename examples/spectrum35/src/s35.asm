// Start with shared definitions...
include "Megaprocessor_defs.asm";

// *****************************************            
// Ensure the SGX libraries start at an address which
// won't conflict with our code.
org 0x4000;
include "sgx/sgx.asm";
include "zxspectrum_font.asm";

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

scrcount   equ $;
         db 0;

sgx_scroll1:
        ld.w    r0, #16;
        st.w    (scrcount), r0;

sgx_scroll1m:

        ld.w    r2, #INT_RAM_START + 0;
        ld.w    r3, #INT_RAM_START + 16;

        ld.w    r1, #30;    // because we move words, not bytes
scroll_loop:
        ld.w    r0, (r3++);
        st.w    (r2++), r0;
        ld.w    r0, (r3++);
        st.w    (r2++), r0;
        ld.w    r0, (r3++);
        st.w    (r2++), r0;
        ld.w    r0, (r3++);
        st.w    (r2++), r0;

        addq    r1, #-1;
        bne     scroll_loop;

        // Make two blank lines
        ld.w    r0, #0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;

        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;

         ld.w    r0,(scrcount);
         addq    r0, #-1;
        st.w    (scrcount), r0;
          bne  sgx_scroll1m;

        ret;


scr2count   equ $;
         db 0;

sgx_scroll2:
         ld.w   r3, #256;
         ld.w    r2, #INT_RAM_START + 0;

sgx_scroll2loop:
        ld.b    r0,(r2);
        lsr     r0, #1;
        st.b    (r2),r0;


        addq    r2, #1;
        addq    r3, #-1;
        bne     sgx_scroll2loop;


        ret;


sgx_scroll2x8:
        ld.b r0, #8;
        st.b (scr2count), r0;
sgx_scroll2x8loop:
        jsr sgx_scroll2;
        ld.b r0,(scr2count);
        addq    r0, #-1;
        st.b (scr2count), r0;
        bne     sgx_scroll2x8loop;
        ret;
       
// *****************************************     
textSpectrum35:
        ld.w    r2, #INT_RAM_START + 16;
        ld.w    r3, #TXT_MONA;
        jsr     sgx_graphics_Font_draw;

        ld.w    r2, #INT_RAM_START + 48 + 170 - 2;
        ld.w    r3, #TXT_LISA;
        jsr     sgx_graphics_Font_draw;

        ret;

jsw_anim_count  equ $;
        db 0;

start:
        // give ourselves a stack
        ld.w    r0,#0x2000;
        move    sp,r0;
        
        // Initialize the font and other parameters
        jsr     sgx_init;

        ld.w    r3, #SPECTRUM_FONT_STANDARD;
        jsr     sgx_graphics_DrawSurface_setCurrentFont;

pic1:

        jsr     sgx_graphics_DrawSurface_clearScreen;


        ld.b    r0, #16;
        st.b    (jsw_anim_count), r0;



jsw_anim_loop:

        // Draw the image
        ld.w    r3, #IMG_S35_G1;
        jsr     sgx_graphics_DrawSurface_setFillTexture;
        ld.w    r2, #INT_RAM_START + 32;
        jsr     sgx_graphics_DrawSurface_fillPoint;
        jsr     delay_anim;

        ld.w    r3, #IMG_S35_G2;
        jsr     sgx_graphics_DrawSurface_setFillTexture;
        ld.w    r2, #INT_RAM_START + 32;
        jsr     sgx_graphics_DrawSurface_fillPoint;
        jsr     delay_anim;

        ld.w    r3, #IMG_S35_G1;
        jsr     sgx_graphics_DrawSurface_setFillTexture;
        ld.w    r2, #INT_RAM_START + 32;
        jsr     sgx_graphics_DrawSurface_fillPoint;
        jsr     delay_anim;

        ld.w    r3, #IMG_S35_G3;
        jsr     sgx_graphics_DrawSurface_setFillTexture;
        ld.w    r2, #INT_RAM_START + 32;
        jsr     sgx_graphics_DrawSurface_fillPoint;
        jsr     delay_anim;

        ld.b    r0,(jsw_anim_count);
        addq    r0, #-1;
        st.b    (jsw_anim_count), r0;
        bne     jsw_anim_loop;
       



        jsr     sgx_graphics_DrawSurface_clearScreen;
        jsr     textSpectrum35;
        // Prepare the image
        ld.w    r3, #IMG_MONA_LISA;
        jsr     sgx_graphics_DrawSurface_setFillTexture;

        // Draw the image
        ld.w    r2, #INT_RAM_START + 48;
        jsr     sgx_graphics_DrawSurface_fillPoint;

        jsr     sgx_scroll2x8;



pic2:
        // Prepare the image
        ld.w    r3, #IMG_DIZZY;
        jsr     sgx_graphics_DrawSurface_setFillTexture;

        // Draw the image
        ld.w    r2, #INT_RAM_START + 48;
        jsr     sgx_graphics_DrawSurface_fillPoint;

        jsr     textSpectrum35;
        jsr     delay10;


pic3:
        // Prepare the image
        ld.w    r3, #IMG_CHUCKIE;
        jsr     sgx_graphics_DrawSurface_setFillTexture;

        // Draw the image
        ld.w    r2, #INT_RAM_START + 48;
        jsr     sgx_graphics_DrawSurface_fillPoint;

        jsr     delay10;


pic4:
        // Prepare the IMG_YEARR
        ld.w    r3, #IMG_YEARR;
        jsr     sgx_graphics_DrawSurface_setFillTexture;

        // Draw the image
        ld.w    r2, #INT_RAM_START + 8;
        jsr     sgx_graphics_DrawSurface_fillPoint;

        jsr     delay10;
        jsr     sgx_scroll1;


pic5: // sinclair
        ld.w    r3, #IMG_SINCLAIR;
        jsr     sgx_graphics_DrawSurface_setFillTexture;

        // Draw the image
        ld.w    r2, #INT_RAM_START + 0;
        jsr     sgx_graphics_DrawSurface_fillPoint;
        ld.w    r2, #INT_RAM_START + 96;
        jsr     sgx_graphics_DrawSurface_fillPoint;
        ld.w    r2, #INT_RAM_START + 192;
        jsr     sgx_graphics_DrawSurface_fillPoint;

        jsr     delay10;
        jsr     sgx_scroll2;



pic6:
        ld.w    r3, #IMG_WILLY;
        jsr     sgx_graphics_DrawSurface_setFillTexture;

        // Draw the image
        ld.w    r2, #INT_RAM_START + 16;
        jsr     sgx_graphics_DrawSurface_fillPoint;

       jsr     delay10;



        jmp pic1;


delay_anim:
        ld.w    r1, #200;
        jmp     sgx_sleep;

delay10:
        ld.w    r1, #2000;
        jmp     sgx_sleep;





TXT_MONA equ $;
    db 4;
    db FONT_UC_S, FONT_LC_P, FONT_LC_E, FONT_LC_C;

TXT_LISA equ $;
    db 4;
    db FONT_UC_T, FONT_LC_R, FONT_LC_U, FONT_LC_M;

IMG_MONA_LISA        equ     $;
    db 4, 160;  // width of image (in bytes), height of image (in rows)
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,30,0,0,0,255,1,0,128,255,31,0,128,255,255,0,192,253,255,15,224,223,255,127,224,125,255,63,240,247,247,63,240,127,255,61,248,239,247,63,252,252,94,31,252,239,255,13,240,127,223,7,128,255,253,1;
    db 0,252,223,9,0,224,127,0,0,0,127,7,0,0,120,7,0,0,224,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,224,227,15,0,16,36,0,0,0,227,7,0,0,0,0,0,0,4,8,0,16,36,8,0,224,195,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;

IMG_DIZZY   equ $;
    db 4, 160;
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,224,15,0,0,240,31,0,0,248,63,0,0,248,63,0,0,24,49,0,0,12,97,0,0,108,109,0,56,12,97,56,124,142,227,124,120,255,255,61,112,255,255,29,0,239,239,1,0,31,240,1,0,62,248,0,0,252;
    db 126,0,1,252,127,64,129,240,159,32,129,0,128,1,133,0,128,9,196,56,56,72,190,8,32,68,160,96,96,70,193,244,114,66,195,1,0,216,38,1,128,156,0,0,8,32,0,0,16,16,72,128,195,8,0,0,0,132,0,0,0,0,32,65,0,16,64,0,0,4,2,0,1,0,18,0,2,128,0,0,0,0;

IMG_CHUCKIE   equ $;
    db 4, 160;
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,120,0,0,0,124,0,0,0,124,0,0,0,124,0,0,240,255,15,0,0,116,0,0,0,100,0,0,0,124,0,0,0,56,0,0,0,56,0,0,0,127,0,0,128,207,0,0,128,191,0,0,0,191,0,0,0,190,0,0,0,124,0,224,128,132,0,240,0,0,0;
    db 248,7,67,0,252,15,0,0,252,15,0,0,252,15,0,0,252,15,0,0,248,7,0,0,240,0,0,0,224,0,0,0,0,0,0,0,0,0,0,0,248,249,207,63,0,0,0,0,228,63,255,249,0,0,0,0,0,0,0,0,60,255,249,207,0,0,0,0,0,0,0,0,0,0,0,0;


IMG_YEARR   equ $;
    db 4, 240;
    db 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,254,0,0,32,255,3,0,192,195,2,0,0,225,3,0,0,27,2,0,0,197,3,0,248,102,1,0;
    db 254,0,1,0,255,128,1,128,255,128,0,128,255,113,0,192,255,243,0,192,247,255,1,192,247,255,1,192,251,216,3,192,59,208,3,192,31,208,3,192,7,239,3,192,135,31,3,192,195,7,2,192,227,129,3,192,31,96,0,192,27,56,0,0,29,254;
    db 0,0,63,255,3,0,255,251,7,0,255,247,7,0,254,239,31,0,248,223,31,0,224,255,31,0,224,223,31,0,248,223,15,0,254,199,15,0,255,99,15,192,255,96,15,192,126,224,15,64,61,192,7,64,204,254,7,64,88,59,14,64,176,45,24,128,224;
    db 54,32,0,31,192,63,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255;




IMG_SINCLAIR   equ $;
    db 4, 40;
  db 0, 0, 0, 0, 128, 0, 8, 4, 0, 0, 8, 0, 184, 220, 233, 116, 140, 222, 136, 53, 140, 82, 136, 21, 188, 82, 232, 20, 160, 82, 40, 21; 
db 188, 210, 233, 21, 0, 0, 0, 0;  

    db 255,255,255,255,127,255,247,251,255,255,247,255,71,35,22,139,115,33,119,202,115,173,119,234,67,173,23,235,95,173,215,234,67,45,22,234,255,255,255,255;


IMG_WILLY       equ $;
    db 4, 240;

db 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 240, 31, 0, 0, 240, 31, 0, 0, 240, 31, 0, 0, 248, 31, 0, 0, 254, 127, 0; 
db 0, 254, 127, 0, 0, 48, 31, 0, 0, 48, 31, 0, 0, 48, 31, 0, 0, 254, 31, 0, 0, 254, 31, 0, 0, 240, 31, 0, 0, 240, 31, 0; 
db 0, 240, 31, 0, 0, 192, 3, 0, 0, 192, 7, 0, 0, 240, 31, 0, 0, 240, 31, 0, 0, 240, 31, 0, 0, 254, 127, 0, 0, 254, 127, 0; 
db 0, 254, 127, 0, 0, 254, 127, 0, 0, 62, 255, 0, 128, 63, 255, 3, 128, 63, 255, 3, 128, 199, 255, 3, 128, 199, 255, 3, 0, 240, 31, 0; 
db 0, 240, 31, 0, 0, 56, 31, 0, 0, 62, 127, 0, 0, 62, 127, 0, 0, 254, 120, 0, 0, 254, 120, 0, 0, 62, 120, 0, 128, 63, 127, 0; 
db 128, 63, 127, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 140, 49, 99, 140, 140, 49, 103, 140, 0, 0, 0, 0, 115, 198, 24, 115; 
db 115, 198, 24, 115, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;


// 48 height = 4*48 bytes = 192
// JSW - animation
// ld.w r2, #INT_RAM_START + 64; 
IMG_S35_G1 equ $; 
db 4, 192; 
db 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 128, 255, 255, 1, 128, 255, 255, 1; 
db 128, 255, 255, 1, 0, 252, 56, 0, 0, 252, 56, 0, 0, 252, 56, 0, 0, 252, 255, 1, 0, 252, 255, 1, 0, 252, 255, 1, 0, 252, 63, 0; 
db 0, 252, 63, 0, 0, 252, 63, 0, 0, 224, 7, 0, 0, 224, 7, 0, 0, 224, 7, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0; 
db 128, 255, 255, 1, 128, 255, 255, 1, 128, 255, 255, 1, 128, 255, 255, 1, 128, 255, 255, 1, 128, 255, 255, 1, 240, 255, 248, 15, 240, 255, 248, 15; 
db 240, 255, 248, 15, 240, 255, 199, 15, 240, 255, 199, 15, 240, 255, 199, 15, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 128, 255, 248, 1; 
db 128, 255, 248, 1, 128, 255, 248, 1, 128, 31, 255, 1, 128, 31, 255, 1, 128, 31, 255, 1, 128, 255, 248, 15, 128, 255, 248, 15, 128, 255, 248, 15;



IMG_S35_G2 equ $; 
db 4, 192; 
db 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 128, 255, 255, 1, 128, 255, 255, 1; 
db 128, 255, 255, 1, 0, 252, 56, 0, 0, 252, 56, 0, 0, 252, 56, 0, 0, 252, 255, 1, 0, 252, 255, 1, 0, 252, 255, 1, 0, 252, 63, 0; 
db 0, 252, 63, 0, 0, 252, 63, 0, 0, 224, 7, 0, 0, 224, 7, 0, 0, 224, 7, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0; 
db 128, 31, 255, 1, 128, 31, 255, 1, 128, 31, 255, 1, 128, 31, 255, 1, 128, 31, 255, 1, 128, 31, 255, 1, 128, 31, 255, 1, 128, 31, 255, 1; 
db 128, 31, 255, 1, 128, 255, 248, 1, 128, 255, 248, 1, 128, 255, 248, 1, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 224, 7, 0; 
db 0, 224, 7, 0, 0, 224, 7, 0, 0, 224, 7, 0, 0, 224, 7, 0, 0, 224, 7, 0, 0, 224, 63, 0, 0, 224, 63, 0, 0, 224, 63, 0; 

IMG_S35_G3 equ $; 
db 4, 192; 
db 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0, 128, 255, 255, 1, 128, 255, 255, 1; 
db 128, 255, 255, 1, 0, 252, 56, 0, 0, 252, 56, 0, 0, 252, 56, 0, 0, 252, 255, 1, 0, 252, 255, 1, 0, 252, 255, 1, 0, 252, 63, 0; 
db 0, 252, 63, 0, 0, 252, 63, 0, 0, 224, 7, 0, 0, 224, 7, 0, 0, 224, 7, 0, 0, 252, 63, 0, 0, 252, 63, 0, 0, 252, 63, 0; 
db 128, 255, 255, 1, 128, 255, 255, 1, 128, 255, 255, 1, 240, 255, 255, 15, 240, 255, 255, 15, 240, 255, 255, 15, 254, 255, 255, 127, 254, 255, 255, 127; 
db 254, 255, 255, 127, 126, 252, 63, 126, 126, 252, 63, 126, 126, 252, 63, 126, 0, 252, 255, 1, 0, 252, 255, 1, 0, 252, 255, 1, 128, 255, 248, 113; 
db 128, 255, 248, 113, 128, 255, 248, 113, 240, 3, 192, 127, 240, 3, 192, 127, 240, 3, 192, 127, 240, 31, 192, 15, 240, 31, 192, 15, 240, 31, 192, 15;


/*

C:\Users\steev\Documents\clients\self\code\assembly\MegaProcessor\src>C:\Users\s
teev\Downloads\Megaprocessor_sw\MPasm.exe s35
Pass #0...
Pass #1...
Pass #2...
Pass #3 [LAST]...
Assembler finished without error

C:\Users\steev\Documents\clients\self\code\assembly\MegaProcessor\src
*/