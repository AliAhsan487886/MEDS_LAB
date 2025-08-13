    .section .text
    .globl _start

_start:
    la a0, num
    lw a0, 0(a0)

    # Call factorial
    jal ra, factorial

    la t0, result
    sw a0, 0(t0)

    j write_tohost

# Recursive factorial function
factorial:
    addi sp, sp, -8        # make space on stack
    sw ra, 4(sp)           # save return address
    sw a0, 0(sp)           # save num

    # if (num <= 1) return 1
    li t0, 1
    ble a0, t0, base_case

    # Recursive case: factorial(num-1)
    addi a0, a0, -1
    jal ra, factorial      # call factorial(num-1)

    lw t1, 0(sp)           
    mul a0, a0, t1
    j end_factorial

base_case:
    li a0, 1               # return 1

end_factorial:
    lw ra, 4(sp)           # restore return address
    addi sp, sp, 8         # free stack space
    jr ra                  # return

# End program by writing to 'tohost'
write_tohost:
    li x1, 1
    sw x1, tohost, t5
    j write_tohost

    .section .data
    .align 4
num:    .word 5            # input number
result: .word 0            # result storage

    .align 12
    .section ".tohost","aw",@progbits
    .align 4
    .global tohost
tohost: .dword 0
    .align 4
    .global fromhost
fromhost: .dword 0
