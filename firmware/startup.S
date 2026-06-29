.section .text.init

.globl _start

_start:
    la   sp, _stack_top        # Initialise stack pointer
    # la   gp, __global_pointer$ # Set global pointer
    la   t0, _bss_start
    la   t1, _bss_end

_bss_loop:
    bge  t0, t1, _bss_done
    sw   zero, 0(t0)
    addi t0, t0, 4
    j    _bss_loop

_bss_done:
    call main

_hang:
    j    _hang                 # Trap if main() returns

# gp commented out for now since linker script doesn't define a global pointer and its unneeded at this phase (2)
# .data also not being copied in linker script from ROM to RAM because unneeded as no gp.