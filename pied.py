#!/usr/bin/env python3

import argparse
import re
import sys


def main(args):
    is_silent = True if args.n else False
    if args.f:
        try:
            f = open(args.f)
        except:
            print("pied: error")
            sys.exit(1)

        command = f.read()
    else:
        command = args.sed_command
    if args.files:
        input = ""
        for file in args.files:
            try:
                f = open(file)
                input += f.read()
                f.close()
            except:
                print("pied: error")
                sys.exit(1)
        input = iter(input.splitlines())
    else:
        input = sys.stdin
    output = {}
    i = 1
    try:
        current_line = next(input)
    except:
        sys.exit(1)
    try:
        next_line = next(input)
    except:
        next_line = None
    split_commands = []
    for line in command.splitlines():
        split_commands = split_commands + command_parser(line)
    split_command_labels = {}
    for split_command in split_commands:
        if split_command["type"] == "label":
            split_command_labels[split_command["label"]] = split_command
    in_range = []
    in_change = []
    for split_command in split_commands:
        ## initialise the ranges for each command
        in_range.append(False)
        in_change.append(False)

    result_lines = []

    while current_line is not None:
        successful_sub = False
        is_last = next_line is None
        output[i] = {
            "line": current_line.strip(),
            "print": None,
            "quit": False,
            "delete": False,
            "append": None,
            "insert": None,
        }
        command_no = 0
        while command_no < len(split_commands):
            (
                successful_sub,
                jump_to,
                in_change[command_no],
                in_range[command_no],
            ) = apply_command(
                split_commands[command_no],
                output[i]["line"],
                output,
                i,
                is_last,
                in_range[command_no],
                in_change[command_no],
                successful_sub,
            )
            if output[i]["quit"] is True:
                break
            if output[i]["print"] is not None and output[i]["delete"] is False:
                result_lines.append((i, output[i]["print"]))
                output[i]["print"] = None
            if jump_to is not None:
                # we need to jump to a specific command in split_commands
                jump_to_command = split_command_labels[jump_to]
                command_no = split_commands.index(jump_to_command)
                continue
            command_no += 1

        if output[i]["quit"] is True:
            if not is_silent:
                result_lines.append((i, output[i]["line"]))
            if output[i]["print"] is not None:
                result_lines.append((i, output[i]["print"]))
            break
        if output[i]["delete"] is True:
            try:
                current_line = next_line
                next_line = next(input)
            except:
                next_line = None
            i += 1
            continue
        if output[i]["insert"] is not None:
            result_lines.append((i, output[i]["insert"]))
        if is_silent:
            if output[i]["print"] is not None:
                result_lines.append((i, output[i]["print"]))
        else:
            if output[i]["print"] is not None:
                result_lines.append((i, output[i]["print"]))
            result_lines.append((i, output[i]["line"]))
        if output[i]["append"] is not None:
            result_lines.append((i, output[i]["append"]))
        try:
            current_line = next_line
            next_line = next(input)
        except:
            next_line = None
        i += 1

    # print the results
    if args.i:

        # compute the ranges of the files
        file_ranges = {}
        start = 1
        for file in args.files:
            with open(file, "r") as f:
                lines = f.readlines()
                file_ranges[file] = range(start, start + len(lines))

                start += len(lines)

        # compile lines and then write to corresponding files
        for file in args.files:
            line_range = file_ranges[file]
            modified_content = []
            for line_number, content in result_lines:
                if line_number in line_range:
                    modified_content.append(content + "\n")
            with open(file, "w") as f:
                f.writelines(modified_content)

    else:
        for result in result_lines:
            content = result[1]
            print(content)


def apply_command(
    command, input, output, line_number, is_last, in_range, in_change, successful_sub
):
    is_address, in_range = address_handler(
        command, input, line_number, is_last, in_range
    )
    if not is_address:
        return successful_sub, None, in_change, in_range
    if command["type"] == "q":
        q(output, line_number)
    elif command["type"] == "p":
        p(output, line_number)
    elif command["type"] == "d":
        d(output, line_number)
    elif command["type"] == "s":
        successful_sub = s(
            output,
            line_number,
            command["search"],
            command["replacement"],
            command["is_global"],
        )
    elif command["type"] == "a":
        a(output, line_number, command["text"])
    elif command["type"] == "i":
        i(output, line_number, command["text"])
    elif command["type"] == "c":
        in_change = c(
            output,
            line_number,
            command["text"],
            command["address_two"],
            in_range,
            in_change,
        )
    elif command["type"] == "label":
        return successful_sub, None, in_change, in_range
    elif command["type"] == "t":
        successful_sub, jump_to = t(successful_sub, command["label"])
        return successful_sub, jump_to, in_change, in_range
    elif command["type"] == "b":
        return successful_sub, command["label"], in_change, in_range
    else:
        print("pied: command line: invalid command")
        sys.exit(1)
    return successful_sub, None, in_change, in_range


def command_parser(command):
    parsed_commands = []
    while command is not None:
        if command.startswith("#") or command == "":
            return []
        prelim_regex = r"\s*(?P<address_one>(\d+|/([^/]|\\/)*?/|\$))?\s*(,\s*(?P<address_two>(\d+|/([^/]|\\/)*?/|\$))\s*)?(?P<type>([qpdsaic]))"
        full_regex = re.match(prelim_regex, command)
        if full_regex:
            address_one = full_regex.group("address_one")
            address_two = full_regex.group("address_two")
            type = full_regex.group("type")
        else:
            label_regex = r"\s*:\s*(?P<label>(([^;]|\\;)*))\s*"
            full_regex = re.match(label_regex, command)
            if full_regex:
                type = "label"
                label = full_regex.group("label")
                parsed_commands.append({"type": type, "label": label})
            else:
                branch_address_regex = r"(?P<address_one>(\d+|/([^/]|\\/)*?/|\$))?\s*(,\s*(?P<address_two>(\d+|/([^/]|\\/)*?/|\$))\s*)?"
                branch_regex = r"\s*(?P<type>([bt]))\s*(?P<label>(([^;]|\\;))*)\s*"
                full_regex = re.match(branch_address_regex + branch_regex, command)
                if full_regex:
                    address_one = full_regex.group("address_one")
                    address_two = full_regex.group("address_two")
                    type = full_regex.group("type")
                    label = full_regex.group("label")
                else:
                    print("pied: command line: invalid command")
                    sys.exit(1)
                parsed_commands.append(
                    {
                        "address_one": address_one,
                        "address_two": address_two,
                        "type": type,
                        "label": label,
                    }
                )
        if type == "s":
            delim_regex = (
                rf"\s*({address_one})?\s*(,\s*({address_two}))?({type})(?P<delim>.)"
            )
            delim = re.escape(re.match(delim_regex, command).group("delim"))
            address_part = rf"\s*({address_one})?\s*(,\s*({address_two}))?"
            substitute_part = rf"({type})({delim})(?P<search>([^\\{delim}]|\\{delim}|\\.)*?){delim}(?P<replacement>([^\\{delim}]|\\{delim}|\\.)*?){delim}\s*(?P<is_global>g?)"
            full_command = address_part + substitute_part
            full_regex = re.match(full_command, command)
            # remove backslash from escaped delim
            search = re.sub(rf"\\{delim}", rf"{delim}", full_regex.group("search"))
            replacement = re.sub(
                rf"\\{delim}",
                rf"{delim}",
                full_regex.group("replacement"),
            )
            is_global = full_regex.group("is_global")
            parsed_commands.append(
                {
                    "address_one": address_one,
                    "address_two": address_two,
                    "type": type,
                    "search": search,
                    "replacement": replacement,
                    "is_global": is_global,
                }
            )
        elif type in ["a", "i", "c"]:
            remaining = command[full_regex.end() :]
            text = re.match(r"\s*(?P<text>(.*))", remaining)
            if text:
                text = text.group("text")
                parsed_commands.append(
                    {
                        "address_one": address_one,
                        "address_two": address_two,
                        "type": type,
                        "text": text,
                    }
                )
            else:
                print("pied: command line: invalid command")
                sys.exit(1)
        elif type in ["q", "p", "d"]:
            parsed_commands.append(
                {"address_one": address_one, "address_two": address_two, "type": type}
            )

        remaining = command[full_regex.end() :]
        next_command_regex = rf"\s*(;(?P<next_command>.*))?"
        next_command = re.match(next_command_regex, remaining)
        if next_command is not None:
            next_command = next_command.group("next_command")

        command = next_command
    return parsed_commands


def address_handler(command, input, i, is_last, in_range):
    if command["type"] in ["label"]:
        return True, False
    if command["address_two"] is None:
        return check_address(command["address_one"], input, i, is_last), True
    else:
        start_match = check_address(command["address_one"], input, i, is_last)
        end_match = check_address(command["address_two"], input, i, is_last)
        if re.fullmatch(r"\d+", command["address_two"]):
            if i > int(command["address_two"]):
                return True if start_match else False, False
        if not in_range and start_match:
            return True, True
        if in_range and end_match:
            return True, False
        else:
            return in_range, in_range


def check_address(address, input, i, is_last):
    if address == None:
        return True
    elif re.fullmatch(r"(\d+)", address):
        return i == int(address)
    elif re.fullmatch(r"/(.*)/", address):
        pattern = re.fullmatch(r"/(.*?)/", address).group(1)
        if re.search(pattern, input):
            return True
    elif re.fullmatch(r"\$", address):
        return is_last
    else:
        print("pied: command line: invalid command")
        sys.exit(1)


def q(output, i):
    if output[i]["delete"] == False:
        output[i]["quit"] = True


def p(output, i):
    output[i]["print"] = output[i]["line"]


def d(output, i):
    if output[i]["quit"] == False:
        output[i]["delete"] = True


def s(output, i, search, replacement, is_global):
    sub = re.subn(search, replacement, output[i]["line"], 0 if is_global else 1)
    output[i]["line"] = sub[0]
    if sub[1] != 0:
        return True
    else:
        return False


def a(output, i, text):
    if output[i]["append"] is None:
        output[i]["append"] = text
    else:
        output[i]["append"] += f"\n{text}"


def i(output, i, text):
    if output[i]["insert"] is None:
        output[i]["insert"] = text
    else:
        output[i]["insert"] += f"\n{text}"


def c(output, i, text, address_two, in_range, in_change):
    if address_two is None:
        output[i]["line"] = text
    else:
        if not in_range and in_change:
            in_change = False
            output[i]["delete"] = True
        elif in_range and not in_change:
            in_change = True
            output[i]["line"] = text
        elif in_change:
            output[i]["delete"] = True
        return in_change


def t(successful_sub, label):
    if successful_sub:
        return False, label
    else:
        return successful_sub, None


class SilentErrorParser(argparse.ArgumentParser):
    def error(self, message):
        self.print_usage(sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    parser = SilentErrorParser(
        prog="pied",
        usage="pied [-i] [-n] [-f <script-file> | <sed-command>] [<files>...]",
    )

    parser.add_argument("-i", action="store_true")
    parser.add_argument("-n", action="store_true")
    parser.add_argument("-f")
    parser.add_argument("args", nargs="*")
    args = parser.parse_args()
    if args.f is not None:
        args.sed_command = None
        args.files = args.args
    else:
        if args.args:
            args.sed_command = args.args[0]
            args.files = args.args[1:]
        else:
            parser.print_usage()
            sys.exit(1)
    main(args)
