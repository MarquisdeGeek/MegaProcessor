
sgx_fx_dissolve1:
	     ld.w   r1, #8;
sgx_fx_dissolve1_loop_outer:
         ld.w   r3, #256;
         ld.w   r2, #INT_RAM_START + 0;

sgx_fx_dissolve1_loop:
        ld.b    r0,(r2);
        add     r0, r0;
        st.b    (r2++), r0;

        addq    r3, #-1;
        bne     sgx_fx_dissolve1_loop;

        addq    r1, #-1;
        bne     sgx_fx_dissolve1_loop_outer;

        ret;
