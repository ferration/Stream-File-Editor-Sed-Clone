#!/usr/bin/dash

# testing for delims and other characters in the input

basic_slash=$(echo "a/b/c" | python3 pied.py 's/\//THISWASASLASH/')
basic_slash_expected=$(echo "a/b/c" | 2041 pied 's/\//THISWASASLASH/')
if [ "$basic_slash" != "$basic_slash_expected" ]; then
    echo "expected: $basic_slash_expected"
    echo "produced: $basic_slash"
    exit 1
fi

basic_pipe=$(echo "a|b|c" | python3 pied.py 's/\|/THISWASAPIPE/')
basic_pipe_expected=$(echo "a|b|c" | 2041 pied 's/\|/THISWASAPIPE/')
if [ "$basic_pipe" != "$basic_pipe_expected" ]; then
    echo "expected: $basic_pipe_expected"
    echo "produced: $basic_pipe"
    exit 1
fi

basic_command_seperator=$(echo "a;b;c" | python3 pied.py 's/\;/THISWASACOMMANDSEPARATOR/')
basic_command_seperator_expected=$(echo "a;b;c" | 2041 pied 's/\;/THISWASACOMMANDSEPARATOR/')
if [ "$basic_command_seperator" != "$basic_command_seperator_expected" ]; then
    echo "expected: $basic_command_seperator_expected"
    echo "produced: $basic_command_seperator"
    exit 1
fi

backslash_input=$(echo "a\\b\\c" | python3 pied.py 's/\\/THISWASABACKSLASH/')
backslash_input_expected=$(echo "a\\b\\c" | 2041 pied 's/\\/THISWASABACKSLASH/')
if [ "$backslash_input" != "$backslash_input_expected" ]; then
    echo "expected: $backslash_input_expected"
    echo "produced: $backslash_input"
    exit 1
fi