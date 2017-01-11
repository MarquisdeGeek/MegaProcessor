// States
sgx_const_texture:	dw;


// Methods
sgx_graphics_DrawSurface_clearScreen:
        xor     r0, r0;
        ld.w    r2, #INT_RAM_START;
        ld.w    r1, #INT_RAM_LEN;
sgx_graphics_DrawSurface_clearScreen_loop:
        st.w    (r2++), r0;
        addq    r1, #-2;
        bne     sgx_graphics_DrawSurface_clearScreen_loop;
        ret;


sgx_graphics_DrawSurface_setFillTexture:
        st.w    (sgx_const_texture), r3;
        ret;


// draw point...x in r0, y in r1
// Taken from original samples
sgx_graphics_DrawSurface_plotPoint:
        // first we construct the byte ptr
        move    r2,r0;
        ld.w    r3,#INT_RAM_START;
        lsr r2,#3; // bit address to byte
        add r3,r2;
        lsl r1,#2; // y os byte offset
        add r3,r1;
        // and now the mask
        ld.b    r1,#1;
        ld.b    r2,#7;
        and r0,r2;
        lsl r1,r0;
        
        // and now apply
        ld.b    r0,(r3);
        xor r0,r1;
        st.b    (r3),r0;
        
        ret;

// IN
// r2 : screen memory
sgx_graphics_DrawSurface_fillPoint:
		ld.w    r3, (sgx_const_texture);

        ld.b    r1, (r3++);		// width (in bytes) of the image
        dec 	r1;
        beq		sgx_graphics_DrawSurface_fillPoint1;
        dec 	r1;
        beq		sgx_graphics_DrawSurface_fillPoint2;
        dec 	r1;
        beq		sgx_graphics_DrawSurface_fillPoint3;
        // So it must be 4-bytes wide

        ld.b    r1, (r3++);
sgx_graphics_DrawSurface_fillPoint_loop:
        ld.b    r0, (r3++);
        st.b    (r2++), r0;
        addq    r1,#-1;
        bne     sgx_graphics_DrawSurface_fillPoint_loop;
        ret;

// IN
// r2 : screen memory
sgx_graphics_DrawSurface_fillPoint1:
        ld.b    r1, (r3++);
sgx_graphics_DrawSurface_fillPoint1_loop:
        ld.b    r0, (r3++);
        st.b    (r2), r0;
        addq	r2, #2;
        addq	r2, #2;
        addq    r1, #-1;
        bne     sgx_graphics_DrawSurface_fillPoint1_loop;
        ret;

sgx_graphics_DrawSurface_fillPoint2:
        ld.b    r1, (r3++);
sgx_graphics_DrawSurface_fillPoint2_loop:
        ld.b    r0, (r3++);
        st.b    (r2++), r0;
        addq	r2, #2;
        addq    r1, #-1;
        bne     sgx_graphics_DrawSurface_fillPoint2_loop;
        ret;

sgx_graphics_DrawSurface_fillPoint3:
        ld.b    r1, (r3++);
sgx_graphics_DrawSurface_fillPoint3_loop:
        ld.b    r0, (r3++);
        st.b    (r2++), r0;
        addq	r2, #1;
        addq    r1, #-1;
        bne     sgx_graphics_DrawSurface_fillPoint3_loop;
        ret;


sgx_graphics_DrawSurface_drawLine2D:
        // TODO
        addq    r1,#-1;
	ret;
