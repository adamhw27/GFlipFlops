import sys
import re

labels = {}     # key = label name, value = instruction address or line number
lineCount = 0   # Number of pure bytecode lines


def assemble_line(line):
    args = line.split()

    # Return empty for \n or labels
    if len(args) == 0 or args[-1].endswith(":"):
        return ""

    opcode = args[0]
    rdst = ""
    rsrc = ""
    imm = False
    branch = False
    jump = False

    # Opcode
    opcode = args[0]

    if opcode == "add":
        opcode = "05"
    elif opcode == "addi":
        opcode = "5x"
    elif opcode == "addu":
        opcode = "06"
    elif opcode == "addui":
        opcode = "6x"
    elif opcode == "addc":
        opcode = "07"
    elif opcode == "addci":
        opcode = "7x"
    elif opcode == "mul":
        opcode = "0E"
    elif opcode == "muli":
        opcode = "Ex"
    elif opcode == "sub":
        opcode = "09"
    elif opcode == "subi":
        opcode = "9x"
    elif opcode == "subc":
        opcode = "0A"
    elif opcode == "subci":
        opcode = "Ax"
    elif opcode == "cmp":
        opcode = "0B"
    elif opcode == "cmpi":
        opcode = "Bx"
    elif opcode == "and":
        opcode = "01"
    elif opcode == "andi":
        opcode = "1x"
    elif opcode == "or":
        opcode = "02"
    elif opcode == "ori":
        opcode = "2x"
    elif opcode == "xor":
        opcode = "03"
    elif opcode == "xori":
        opcode = "3x"
    elif opcode == "movi":
        opcode = "Dx"
    elif opcode == "lsh":
        opcode = "88"
    elif opcode == "lshi":
        opcode = "8x"
    elif opcode == "ashu":
        opcode = "8F"
    elif opcode == "ashui":
        opcode = "8x"
    elif opcode == "load":
        opcode = "40"
    elif opcode == "store":
        opcode = "44"


    elif opcode[0] == "b" or opcode[0] == "j":

        # Branch instruction
        if opcode[0] == "b":
            opcode = "Cx"
            branch = True

        # Jump instruction
        else:
            opcode = "4C"
            jump = True

        if opcode[1] == "e":
            rdst = "0"
        elif opcode[:2] == "ne":
            rdst = "1"
        elif opcode[:2] == "lt":
            rdst = "C"
        elif opcode[:2] == "lo":
            rdst = "A"
        elif opcode[:2] == "ge":
            rdst = "D"
        elif opcode[:2] == "hs":
            rdst = "B"
        else:
            rdst = "E"

    # Psuedo instructions
    elif opcode == "call" or opcode == "ret" or opcode == "mov" or opcode == "li" or opcode == "nop":
        return psuedo(args)

    else:
        print(f"Unknown opcode {opcode}")
        sys.exit(1)

    # Rdst
    rdst = int(args[1][1])

    # Rsrc
    rsrc = ""
    immVal = ""

    if not (branch or jump): # check if two input instruction
        if args[2][0] == "r":
            rsrc = int(args[2][1])
        else:
            imm = True
            immVal = int(args[2])

    # Two input instructions
    elif jump:
        rsrc = int(args[1][1])

    elif branch:
        immVal = int(args[1])
        imm = True

    # Concatenate
    bytecode = ""

    # Imm or branch
    if imm or branch:
        bytecode += opcode[0]
        bytecode += f"{rdst:X}"
        bytecode += f"{immVal:02X}"
        bytecode += f"\t//{line}\n"

    # Rtype or jump
    else:
        bytecode += opcode[0]
        bytecode += f"{rdst:X}"
        bytecode += opcode[1]
        bytecode += f"{rsrc:X}"
        bytecode += f"\t// {line}\n"

    return bytecode


def assemble_file(input_path, output_path):

    with open(input_path, 'r') as infile, open(output_path, 'w') as outfile:
        for line in infile:
            bytecode = assemble_line(line.strip())
            outfile.write(f"{bytecode}")


def map_labels(input_path, output_path):

    global lineCount

    with open(input_path, 'r') as infile, open(output_path, 'w') as outfile:


        print(f"Mapping labels...")

        for line in infile:
            line = line.strip()
            args = line.split()

            print(f"{lineCount}) {line}", end = "\r")

            if len(args) == 0:
                # dont increment, empty line
                pass
            elif args[-1].endswith(":"):
                # increment and map where label is
                labels[line] = lineCount


            # Some instructions take up more than one line:

            elif args[0] == "call":
                lineCount += 4

            elif args[0] == "ret":
                lineCount += 3

            elif args[0] == "mov":
                lineCount += 3
            else:
                # regular instruciton, maps to one line
                lineCount += 1

        print(f"Wrote {lineCount} lines...  ")



def psuedo(args):

    bytecode = ""


    # elif opcode == "call" or opcode == "ret"
    # opcode == "mov" or opcode == "li" or opcode == "nop":

    # R15 is dedicated RA
    # R14 is dedicated TA

    if args[0] == "call":
        # Load label address into TA
        # J r14

        ta = labels[args[1] + ':']

        if ta > 255:    # Label address is too large for 2 digit hex
            ta -= 255
            ta_hex = f"{labels[args[1] + ':']:02X}"

            # move r14 TA

            inst = "0" + 'E' + "1" + '0' + f'\t// call {args[1]} -- using DOUBLE ADD for address > FF' + '\n'  # AND r14 R0
            bytecode += inst
            inst = "5" + 'E' + f'{ta_hex}' + '\n'  # addi r14 TA
            bytecode += inst
            inst = "5" + 'E' + 'FF' + '\n'  # addi r14 FF
            bytecode += inst

        else:
            ta_hex = f"{labels[args[1] + ':']:02X}"   # Target address at label

            # move r14 TA

            inst = "0" + 'E' + "1" + '0' + f'\t// call {args[1]}' + '\n'  # AND r14 R0
            bytecode += inst
            inst = "5" + 'E' +  f'{ta_hex}' + '\n'  # addi r14 TA
            bytecode += inst

            inst = "0" + '0' + "2" + '0' + '\n' # OR R0 R0 ---- NOP so that call psuedos are always same length
            bytecode += inst

        # j r14

        inst = "4" + 'E' + 'C' + 'E' + '\n'  # j r14

        return bytecode + inst


    elif args[0] == "ret":    # ret psuedo instruction


        # mov r14 r15

        inst = "0" + 'E' + "1" + '0' + f'\t// ret' + '\n'  # AND r14 R0
        bytecode += inst
        inst = "0" + 'E' + '5' + 'F' + '\n'  # add r14 r15
        bytecode += inst

        # j r14

        inst = "4" + 'E' + 'C' + 'E' + '\n'   # j r14

        return bytecode + inst

    elif args[0] == "mov":
        # 0 out reg with AND RTHIS R0
        # add reg into this one

        rdst = int(args[1][1:])  # grab everything after 'r'
        rsrc = int(args[2][1:])
        rdst_hex = f"{rdst:X}"  # one hex digit 0–F
        rsrc_hex = f"{rsrc:X}"

        inst = "0" + rdst_hex + "1" + '0' + f'\t// mov {args[1]} {args[2]}' + '\n'     # and Rdst R0

        bytecode += inst

        inst  = "0" + rdst_hex + '5' + rsrc_hex + '\n'           # add rdst rsrc

        return bytecode + inst

    elif args[0] == "li":
        pass

    elif args[0] == "nop":
        inst = "0" + '0' + "2" + '0' + f'\t// nop' + '\n'  # OR R0 R0

        return inst

    return bytecode


def main():
    if len(sys.argv) != 3:
        print("Pass two input files")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]

    map_labels(input_path, output_path)
    assemble_file(input_path, output_path)
    print(f"Assembled {input_path} → {output_path}")

if __name__ == "__main__":
    main()