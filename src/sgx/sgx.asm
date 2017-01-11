include "sgx/gfx.asm";
include "sgx/surface.asm";
include "sgx/font.asm";

sgx_init:
        jmp 	sgx_graphics_init;
