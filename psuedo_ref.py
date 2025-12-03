"""
Psuedocode for reference

Reserved Registers:

R0 = 0

R1 = Return
R2 = Jump target

R3 = BPM Clock
    Counts from 1 to 16 (for each beat through the program) at the specified BPM
R4 = Last beat
    We need to keep track of the last beet on every iteration of our main loop so we know when
    we've entered a new beat. Once entering a new beat, some processes need to be updated (ie bitstream module)

R5 = Cursor coordinates
    For vga

R6 = Recent Keypress (including new key status)

R7 = play/pause

Reserved bram addresses:

mem(0-15):
    Words 0-15 hold information about each individual beat, 1-16, for the audio output.

    This includes but is not limited to:
        - What sounds are muted/unmuted

    On every new beat, the bitstream audio generator will load one of these words and output audio accordingly

mem[16-19]
    Words 16-19 hold information about which beats are toggled on the entire array, this information
    is loaded by the VGA

r8
    Holds the current bpm, for modification by keypress
"""
import os
import threading
import time
from pynput import keyboard

r = [0] * 16        # mimic regfile, zeroed out
mem = [0] * 1024    # mimic bram

vga_bpm = 0
vga_array = [0] * 64
vga_cursor = 0

KEYMAP = {
    'w':        0b000,
    'a':        0b001,
    's':        0b010,
    'd':        0b011,
    'enter':    0b100,
    'up':       0b101,
    'down':     0b110,
    'space':    0b111,
}


"""
Main function that handles initialization. First lines of executed code in program.
"""
def init():

    global r
    global mem
    global vga_bpm
    global vga_array
    global vga_cursor
    r[12] = 0
    r[3] = 1

    r[4] = -1 # set r4 (last beat) to -1 so on first iteration we enter new_beat()

    r[5] = 0  # set r5, cursor location, to 0. R5 is a value 0 - 63, where 0 is top left, 63 is bottom right
              # 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15
              # 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
              # .......

    r[7] = 0  # don't play on init

    mem[0:15] = [0] * 16    # all sounds toggled off, first four bits of each word correspond, top to bottom,
                    # to what sounds is on



    mem[16:19] = [0] * 4  # all sounds toggled off # all beats are toggled off for vga, each bit corresponds to a bit, on or off, again
                   # top left to bottom right

    vga_array = 0  # for visual purposes, same as mem[16:19]


    r[8] = 100  # initial bpm = 100

    # Start beat timer in parallel with CPU main loop
    threading.Thread(target=bpm_thread, daemon=True).start()

    # Start keyboard listener
    start_keypress_thread()

    # Start CPU main loop
    main_loop()

    return

"""
Main infinite loop that handles control logic and manages system calls
"""
def main_loop():

    global r
    global mem
    global vga_bpm
    global vga_array
    global vga_cursor

    while True:
        if r[3] != r[4]:    # if current beat != last beat,
            new_beat()

        r[4] = r[3]         # R4 is set to R3, so we can keep track of the last beat and if we've entered a new beat

        if r[6] >> 3:       # Check msb of R5 (keypress reg) which tells us if we've received a new key
            keypress(r[6])          # Handle the new keypress
            r[6] = r[6] & 0b0111    # Zero out msb, new keypress has been handled

        vga_bpm = r[8]
        vga_cursor = r[5]

        draw()


"""
Handles one of 8 key presses...

w, a, s, d, enter, up_arr, down_arr, space
"""
def keypress(key):

    global r
    global mem
    global vga_bpm
    global vga_array
    global vga_cursor

    match key:
        case 0b1000:  # w



            if r[5] >= 16:  # Check if not in top row
                r[5] -= 16
        case 0b1001:  # a
            if r[5] % 16 != 0:  # Check if not in leftmost column
                r[5] -= 1
        case 0b1010:  # s
            if r[5] < 48:  # Check if not in bottom row (48-63)
                r[5] += 16
        case 0b1011:  # d
            if r[5] % 16 != 15:  # Check if not in rightmost column
                r[5] += 1

        case 0b1100:
            sys_toggle(r[5])

            """ 'enter' triggers system call 'toggle' which handles the toggling
                of a certain beat the array.

                'tog' will be a psuedo assembly instruction that takes an 
                int 0-63, as input and will adjust the ram for vga and bitstream accordingly
            """

        case 0b1101:
            r[8] += 5     # up arrow increments bpm by 5

        case 0b1110:
            r[8] -= 5     # down arrow decrements bpm by 5

        case 0b1111:
            r[7] = ~r[7]    # toggle play/pause

    return 0

"""
Handles system calls when main_loop enters a new beat
"""
def new_beat():

    global r
    global mem
    global vga_bpm
    global vga_array
    global vga_cursor

    # If mainloop has entered a new beat, we need to update the audio bitstream generator



    return 0

"""
Draws VGA
"""
def draw():
    # Performs necessary updates to vga input
    os.system('clear || cls')  # Try clear, if that fails try cls

    global r
    global mem

    global vga_bpm
    global vga_array
    global vga_cursor

    """
    VGA needs input from:

        - Beat array (mem[16-19])
        - Cursor (R5)
        - Current beat (R3)
        - BPM (R4)

    Draw will simply load these values into VGA input and then enable VGA to draw the next frame
    """

    print(f"Cursor Location: {vga_cursor}")
    print(f"Current Beat: {r[3]}")
    print(f"Current BPM: {vga_bpm}")

    print(f"")
    print(f"")

    print("Beat Grid (X = on, . = off):")
    # 4 rows x 16 columns
    for row in range(4):
        line = ""
        for col in range(16):
            bit_index = row * 16 + col

            # Show cursor position
            if bit_index == vga_cursor:
                if (vga_array >> bit_index) & 1:
                    line += "[X]"
                else:
                    line += "[.]"
            else:
                if (vga_array >> bit_index) & 1:
                    line += "X "
                else:
                    line += ". "
        print(line)



    return 0


def sys_toggle(r):
    global vga_array

    vga_array ^= (1 << r)   # toggle corresponding bit in vga_array, which is mem[16:19]
    # toggle corresponding bit in bitstream array, mem[0:15]

    return 0


def bpm_thread():
    global r

    while True:
        bpm = r[8]                      # BPM register
        beat_duration = 60.0 / bpm      # seconds per beat

        time.sleep(beat_duration)       # wait until next beat

        # increment beat counter r3 = 1..16
        r[3] += 1
        if r[3] > 16:
            r[3] = 1

def start_keypress_thread():
    listener = keyboard.Listener(
        on_press=handle_keypress,
        suppress=False
    )
    listener.daemon = True
    listener.start()


def handle_keypress(key):
    global r

    try:
        # letter keys
        k = key.char
    except AttributeError:
        # special keys
        if key == keyboard.Key.enter:
            k = 'enter'
        elif key == keyboard.Key.up:
            k = 'up'
        elif key == keyboard.Key.down:
            k = 'down'
        elif key == keyboard.Key.space:
            k = 'space'
        else:
            return  # ignore other keys

    if k in KEYMAP:
        keycode = KEYMAP[k]
        # bit 3 = "new event"
        r[6] = (1 << 3) | keycode



if __name__ == "__main__":
    init()



"""
Notes:

    - Were going to want to hard-wire dedicated registers to some modules, like for vga and bpm
    - VGA is always drawing, its just a matter of updating its inputs?
    

"""



