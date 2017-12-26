
sgx_fx_scroll_up_1_screen:
        ld.w    r0, #64;
sgx_fx_scroll_up_1_screen_loop:
        st.w    (sgx_fx_scroll_counter), r0;

        jsr     sgx_fx_scroll_up_1;

        ld.w    r0,(sgx_fx_scroll_counter);
        addq    r0, #-1;
        bne     sgx_fx_scroll_up_1_screen_loop;

        ret;  

sgx_fx_scroll_up_1:
        ld.w    r2, #INT_RAM_START + 0;
        ld.w    r3, #INT_RAM_START + 4;

        ld.w    r1, #63;    // row counter
sgx_fx_scroll_up_1_loop:
        ld.w    r0, (r3++);
        st.w    (r2++), r0;
        ld.w    r0, (r3++);
        st.w    (r2++), r0;

        addq    r1, #-1;
        bne     sgx_fx_scroll_up_1_loop;

        // Make a blank lines
        ld.w    r0, #0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;

        ret;


sgx_fx_scroll_up_2_screen:
        ld.w    r0, #32;
sgx_fx_scroll_up_2_screen_loop:
        st.w    (sgx_fx_scroll_counter), r0;
        jsr     sgx_fx_scroll_up_2;

        ld.w    r0,(sgx_fx_scroll_counter);
        addq    r0, #-1;
        bne     sgx_fx_scroll_up_2_screen_loop;

        ret;


sgx_fx_scroll_up_2:
        ld.w    r2, #INT_RAM_START + 0;
        ld.w    r3, #INT_RAM_START + 8;

        ld.w    r1, #62;    // because we move words, not bytes
sgx_fx_scroll_up_2_loop:
        ld.w    r0, (r3++);
        st.w    (r2++), r0;
        ld.w    r0, (r3++);
        st.w    (r2++), r0;

        addq    r1, #-1;
        bne     sgx_fx_scroll_up_2_loop;

        // Make two blank lines
        ld.w    r0, #0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;

        ret;


sgx_fx_scroll_up_4_screen:
        ld.w    r0, #16;
sgx_fx_scroll_up_4_screen_loop:        
        st.w    (sgx_fx_scroll_counter), r0;

        jsr     sgx_fx_scroll_up_4;

        ld.w    r0,(sgx_fx_scroll_counter);
        addq    r0, #-1;
        bne     sgx_fx_scroll_up_4_screen_loop;
        ret;

sgx_fx_scroll_up_4:
        ld.w    r2, #INT_RAM_START + 0;
        ld.w    r3, #INT_RAM_START + 16;

        ld.w    r1, #60;    // because we move words, not bytes
sgx_fx_scroll_up_4_loop:
        ld.w    r0, (r3++);
        st.w    (r2++), r0;
        ld.w    r0, (r3++);
        st.w    (r2++), r0;

        addq    r1, #-1;
        bne     sgx_fx_scroll_up_4_loop;

        // Make four blank lines
        ld.w    r0, #0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;

        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;
        st.w    (r2++), r0;

        ret;
