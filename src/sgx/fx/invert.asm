
sgx_fx_invert:
         ld.w   r3, #128;
         ld.w   r2, #INT_RAM_START + 0;

sgx_fx_invert_loop:
        ld.w    r0,(r2);
        inv     r0;
        st.w    (r2++), r0;

        addq    r3, #-1;
        bne     sgx_fx_invert_loop;

        ret;
