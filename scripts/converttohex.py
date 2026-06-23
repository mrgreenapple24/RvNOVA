#!/usr/bin/env python3

import sys

if len(sys.argv) != 3:
    print("Usage: python3 converttohex.py input.mem output.hex")
    sys.exit(1)

inp = sys.argv[1]
out = sys.argv[2]

with open(inp, "r") as f:
    tokens = []

    for line in f:
        line = line.strip()

        if not line:
            continue

        if line.startswith("@"):
            continue

        tokens.extend(line.split())

with open(out, "w") as f:

    for i in range(0, len(tokens), 4):

        if i + 3 >= len(tokens):
            break

        word = (
            tokens[i + 3]
            + tokens[i + 2]
            + tokens[i + 1]
            + tokens[i]
        )

        f.write(word.upper() + "\n")
