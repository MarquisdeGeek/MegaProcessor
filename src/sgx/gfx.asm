
sgx_graphics_init:
        ld.w    r3, #SGX_FONT_STANDARD;
        jsr     sgx_graphics_DrawSurface_setCurrentFont;
		ret;
