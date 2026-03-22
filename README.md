# `pied` – Python Stream Editor

A simplified implementation of the Unix `sed` stream editor in Python, supporting basic editing commands, addressing, and branching logic.

---

## Features

- **Command parsing:** Supports multiple `sed`-style commands including `s` (substitute), `d` (delete), `p` (print), `a` (append), `i` (insert), `c` (change), `q` (quit), and branching with `b` and `t`.
- **Addressing:** Line numbers, regex patterns, and `$` (last line) addressing supported.
- **Branching and labels:** Conditional (`t`) and unconditional (`b`) jumps using labels.
- **Multiple files & stdin support:** Apply scripts to one or more files or standard input.
- **In-place editing:** `-i` flag enables modifying files directly.
- **Silent mode:** `-n` flag suppresses automatic printing of lines, mimicking `sed -n`.
- **Object-oriented and modular design:** Command handling separated into functions for maintainability.

---

## Example Usage

### Command-line usage
```bash
python3 pied.py 's/old/new/g' example.txt
Replaces all occurrences of old with new in example.txt and prints to stdout.
