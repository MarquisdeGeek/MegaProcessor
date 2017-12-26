
sgx_graphics_init:
        ld.w    r3, #SGX_FONT_STANDARD;
        jsr     sgx_graphics_DrawSurface_setCurrentFont;
		ret;


sgx_fx_scroll_counter   equ $;
         db 0;
         db 0;


include "sgx/fx/scroll_up.asm";
include "sgx/fx/scroll_down.asm";
include "sgx/fx/scroll_right.asm";
include "sgx/fx/invert.asm";
include "sgx/fx/dissolve.asm";
