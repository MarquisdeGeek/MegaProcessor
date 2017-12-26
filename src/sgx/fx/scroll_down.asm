
sgx_fx_scroll_down_1_screen:
        ld.w    r0, #64;
sgx_fx_scroll_down_1_screen_loop:
        st.w    (sgx_fx_scroll_counter), r0;

        jsr     sgx_fx_scroll_down_1;

        ld.w    r0,(sgx_fx_scroll_counter);
        addq    r0, #-1;
        bne     sgx_fx_scroll_down_1_screen_loop;
        ret;

sgx_fx_scroll_down_1:
        ld.w    r2, #INT_RAM_START + 252;
        ld.w    r3, #INT_RAM_START + 248;

        ld.w    r1, #63;    // row counter
sgx_fx_scroll_down_1_loop:
        ld.w    r0, (r3++);
        st.w    (r2++), r0;
        ld.w    r0, (r3++);
        st.w    (r2++), r0;

        // Move back over the increments we've done (4 bytes)
        // and then move back 4 bytes for to go back 1 line.
        ld.w    r0, #8;
        sub     r2, r0;
        sub     r3, r0;
        addq    r1, #-1;
        bne     sgx_fx_scroll_down_1_loop;

        // Make a blank line at the top
        ld.w    r0, #0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;

        ret;


sgx_fx_scroll_down_2_screen:
        ld.w    r0, #32;
sgx_fx_scroll_down_2_screen_loop:
        st.w    (sgx_fx_scroll_counter), r0;

        jsr     sgx_fx_scroll_down_2;

        ld.w    r0,(sgx_fx_scroll_counter);
        addq    r0, #-1;
        bne     sgx_fx_scroll_down_2_screen_loop;
        ret;

sgx_fx_scroll_down_2:
        ld.w    r2, #INT_RAM_START + 248;
        ld.w    r3, #INT_RAM_START + 240;

        ld.w    r1, #31;    // row counter
sgx_fx_scroll_down_2_loop:
        ld.w    r0, (r3++);
        st.w    (r2++), r0;
        ld.w    r0, (r3++);
        st.w    (r2++), r0;
        ld.w    r0, (r3++);
        st.w    (r2++), r0;
        ld.w    r0, (r3++);
        st.w    (r2++), r0;

        // Move back over the increments we've done (8 bytes)
        // and then move back 8 bytes for to go back 2 line.
        ld.w    r0, #16;
        sub     r2, r0;
        sub     r3, r0;
        addq    r1, #-1;
        bne     sgx_fx_scroll_down_2_loop;

        // Make two blank lines at the top
        ld.w    r0, #0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;

        ret;

