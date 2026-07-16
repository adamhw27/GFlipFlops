# GFlipFlops — A Custom 16-bit CPU on FPGA

A semester-long project for **ECE 3710: Computer Design Lab** in which we designed a
16-bit processor from scratch in Verilog, implemented it on an Intel DE10-Standard
(Cyclone V) FPGA, and built a small hardware system around it: VGA graphics output
and an audio codec driver. We also wrote a Python assembler and toolchain so we could
write programs for the CPU and generate memory images for the board.

**Team:** Adam Welsh, Charbel Salloum, Ethan Palisoc, Harrison LeTourneau

---

## What it does

The processor implements a custom RISC-style instruction set (a CR16-like ISA). It
runs programs out of a dual-port block RAM, drives a VGA display through a glyph/tile
renderer, and plays audio samples out through the board's audio codec over I²C + I²S.

The working end-of-semester demo is a simple beat visualizer: an audio sample loops
continuously through the codec while an arrow glyph steps across a row of beat markers
on the VGA display. The arrow position (0–63) is driven by the two on-board push-buttons
(increment / decrement), and the program counter and a register value are shown on the
seven-segment displays.

> **Scope note:** a PS/2 keyboard interface (`IO/`) was written and is instantiated in
> the top-level, with the intent of letting a keyboard move the on-screen cursor. We were
> not able to get the PS/2 path working end-to-end, so it is **not** part of the final
> demo — the on-screen arrow is driven by the push-buttons instead. The PS/2 RTL is left
> in the tree as the work we did on it.

## Repository layout

| Directory  | Contents |
|------------|----------|
| `CPU/`     | The processor core — ALU, register bank, program counter, control FSM, instruction register, flag register, and the top-level `cpu.v` that wires it all together. Includes testbenches (`*_tb.v`) and the memory-init `.hex` files. |
| `VGA/`     | VGA controller, glyph generator, and the hard-coded VGA demo top (`HardCodedVga.v`) plus its glyph memory. |
| `Audio/`   | Audio codec pipeline — I²C configuration, I²S bit-stream transfer, PLL, and the audio sample data (`*BigEndian.txt`). |
| `IO/`      | PS/2 keyboard interface and its testbenches (attempted input path — see scope note above). |
| `Memory/`  | Standalone memory subsystem lab — dual-port RAM, memory FSM, and testbench. |
| `asm/`     | Python assembler toolchain (see below). |

## The assembler (`asm/`)

`assembler.py` turns human-readable assembly into the hex machine code the CPU's RAM is
initialized with. It supports the full ISA (arithmetic/logic `add`, `sub`, `and`, `or`,
`xor`, shifts, `cmp`, immediates, `load`/`store`, conditional branches `b<cond>`, jumps,
`call`/`ret`) plus pseudo-instructions (`mov`, `nop`, `li`, `call label`, `ret`) that
expand to real instructions and resolve labels in a two-pass assembly.

```bash
# Assemble a program to a .hex memory-init file
python3 asm/assembler.py asm/examples/keydemo.asm out.hex

# Generate VGA glyph memory from BitBox glyph source files
python3 asm/glyph_gen.py asm/glyphs/*.c glyph_mem.hex
```

`psuedo_ref.py` is a reference implementation documenting how each pseudo-instruction
expands. `asm/examples/keydemo.asm` is a sample program written for the (unfinished)
PS/2 keyboard-control path — a WASD cursor loop — kept as an example of assembler input.

## Building & simulating

The RTL targets Intel Quartus Prime (Cyclone V, DE10-Standard). Each subsystem folder
has its own Quartus project file (`.qpf`):

- **Full system:** open `CPU/cpu.qpf` in Quartus, compile, and program the `.sof` onto
  the board.
- **VGA demo only:** `CPU/vga.qpf` (revision `HardCodedVga`).
- **Memory lab:** `Memory/mem.qpf`.

Testbenches (`*_tb.v`) can be run in ModelSim/Questa. Build artifacts (`db/`,
`output_files/`, `*.sof`, reports, etc.) are intentionally **not** tracked — see
`.gitignore`.

---

## Course documentation

### Lab reports
| Lab # | Link |
|-------|------|
| Lab 2 | [Docs](https://docs.google.com/document/d/11_BU4a7-wSE5BG2NvkOzLhY-1c2RAl9WXuF7BSqPHQg/edit?usp=sharing) |
| Lab 3 | N/A |
| Lab 4 | [Docs](https://docs.google.com/document/d/1bckjfoFw4A0yanORHNYu_EW_T5ANWl84jE1VVcb9Pv0/edit?usp=sharing) |

### Presentation
| Item | Link |
|------|------|
| Final presentation | [Slides](https://docs.google.com/presentation/d/12W0ojzMeLCdvV4azCt1ubPPmtzy7e41zbRNlTCy8txc/edit?usp=sharing) |
| Ideas doc | [Doc](https://docs.google.com/document/d/1veeA8P4v4Ftli0vnvPyXPEp1xa0ob5lkidguDpAdzvs/edit?usp=sharing) |
