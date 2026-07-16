init:
    li r5 0           // Initialize cursor to position 0 (top left)
    // TODO: Initialize memory locations 0-19 to 0

    call main_loop      // Start main loop



main_loop:
    call keypress
    j main_loop

keypress:
    lps2             // Load PS2 keyboard into r6

    // Check if 3rd bit (bit 3) is set, indicating key is pressed
    mov r11 r6          // Copy r6 to r11
    andi r11 8          // r11 = r11 & 0b1000 (mask bit 3)
    cmpi r11 0          // Compare with 0
    jeq keypress_ret    // If bit 3 is 0, return (no key pressed)

    // Mask off the lower 3 bits to get key code
    mov r10 r6          // Copy r6 to r10
    andi r10 7          // r10 = r10 & 0b0111 (get key code)

    // Check for 'w' (0b000)
    cmpi r10 0
    jne check_a
    subi r5 16          // Move cursor up one row
    hdl
    ret

check_a:
    // Check for 'a' (0b001)
    cmpi r10 1
    jne check_s
    subi r5 1           // Move cursor left
    hdl
    ret

check_s:
    // Check for 's' (0b010)
    cmpi r10 2
    jne check_d
    addi r5 16          // Move cursor down one row
    hdl
    ret

check_d:
    // Check for 'd' (0b011)
    cmpi r10 3
    jne keypress_ret
    addi r5 1           // Move cursor right
    hdl
    ret
