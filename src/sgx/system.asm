
sgx_halt:
        nop;
        jmp     sgx_halt;


        // Pass the time to wait in r1, usually 200-2000
sgx_sleep:
        nop;  /* You can't have two labels without an instruction in between */
sgx_sleep_delay_loop:
        addq    r1, #-1;
        bne     sgx_sleep_delay_loop;
        ret;
