import re
import sys

# Check for correct number of arguments (at least 2: one or more input files + one output file)
if len(sys.argv) < 3:
    print("Usage: python3 glyph_gen.py <input_file1> [input_file2 ...] <output_file>")
    sys.exit(1)

# Get filenames from command-line arguments
# All arguments except the last are input files
input_filenames = sys.argv[1:-1]
output_filename = sys.argv[-1]

print(f"Processing {len(input_filenames)} input file(s)...")

# Read from all input files
all_hex_values = []
for input_filename in input_filenames:
    try:
        with open(input_filename, 'r') as f:
            piskel_data = f.read()
            # Extract all 8-digit hex values (0x followed by exactly 8 hex digits)
            hex_values = re.findall(r'0x[0-9a-fA-F]{8}', piskel_data)
            all_hex_values.extend(hex_values)
            print(f"  {input_filename}: found {len(hex_values)} values")
    except FileNotFoundError:
        print(f"Error: File '{input_filename}' not found")
        sys.exit(1)

# Process each value
args = []
for hex_val in all_hex_values:
    # Convert to integer
    val = int(hex_val, 16)

    # Extract bottom 6 hex digits (24 bits)
    bottom_6 = val & 0xFFFFFF

    # Create the cleaned value (keeping only the bottom 3 bytes)
    args.append(bottom_6)

# Print results to console
print(f"Total values: {len(args)}")

# Convert to 3-bit values
three_bit_values = []
for value in args:
    # Extract the three byte pairs
    pair_2 = (value >> 16) & 0xFF  # digits 5,4
    pair_1 = (value >> 8) & 0xFF  # digits 3,2
    pair_0 = value & 0xFF  # digits 1,0

    # Convert to bits (1 for ON/0xff, 0 for OFF/0x00)
    bit_2 = 1 if pair_2 == 0xff else 0
    bit_1 = 1 if pair_1 == 0xff else 0
    bit_0 = 1 if pair_0 == 0xff else 0

    # Combine into a 3-bit number
    three_bit_value = (bit_2 << 2) | (bit_1 << 1) | bit_0
    three_bit_values.append(three_bit_value)

# Open output file and write bytes
with open(output_filename, 'w') as outfile:
    for i in range(0, len(three_bit_values), 2):
        if i + 1 < len(three_bit_values):
            # Combine two 3-bit values into one byte (first value in upper bits)
            byte_value = (three_bit_values[i] << 4) | three_bit_values[i + 1]
            outfile.write(f"{byte_value:02x}\n")
        else:
            # Odd number of values, print the last one alone
            outfile.write(f"{three_bit_values[i]:x}0\n")

print(f"Output written to {output_filename}")