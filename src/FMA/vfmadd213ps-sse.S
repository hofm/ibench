#define INSTR vfmadd213ps
#define NINST 6
#define N edi
#define i r8d


.intel_syntax noprefix
.globl ninst
.data
ninst:
.long NINST
.text
.globl latency
.type latency, @function
.align 32
latency:
        push      rbp
        mov       rbp, rsp
        xor       i, i
        test      N, N
        jle       done
        # create SP 1.0
        vpcmpeqw xmm0, xmm0, xmm0       # all ones
        vpslld xmm0, xmm0, 25           # logical left shift: 11111110..0 (25 = 32 - (8 - 1))
        vpsrld xmm0, xmm0, 2            # logical right shift: 1 bit for sign; leading mantissa bit is zero
        # copy SP 1.0
        vmovaps xmm1, xmm0

        # Mark registers SSE
        movaps xmm0, xmm0
        movaps xmm1, xmm1

loop:
        inc       i
        INSTR     xmm0, xmm1, xmm1
        INSTR     xmm0, xmm1, xmm1
        INSTR     xmm0, xmm1, xmm1
        cmp       i, N
        INSTR     xmm0, xmm1, xmm1
        INSTR     xmm0, xmm1, xmm1
        INSTR     xmm0, xmm1, xmm1
        jl        loop
done:
        mov  rsp, rbp
        pop rbp
        ret
.size latency, .-latency
