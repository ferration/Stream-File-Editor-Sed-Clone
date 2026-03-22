#!/usr/bin/dash

# -n testing

print_basic_n=$(seq 1 5 | python3 pied.py -n '4d')
expected_basic_n=$(seq 1 5 | 2041 pied -n '4d')
if [ "$print_basic_n" != "$expected_basic_n" ]; then
    echo "expected: $expected_basic_n"
    echo "produced: $print_basic_n"
    exit 1
fi

delete_basic_n=$(seq 1 5 | python3 pied.py -n '4d')
expected_delete_basic_n=$(seq 1 5 | 2041 pied -n '4d')
if [ "$delete_basic_n" != "$expected_delete_basic_n" ]; then
    echo "expected: $expected_delete_basic_n"
    echo "produced: $delete_basic_n"
    exit 1
fi

substitute_basic_n=$(seq 1 5 | python3 pied.py -n '4s/4/5/')
expected_substitute_basic_n=$(seq 1 5 | 2041 pied -n '4s/4/5/')
if [ "$substitute_basic_n" != "$expected_substitute_basic_n" ]; then
    echo "expected: $expected_substitute_basic_n"
    echo "produced: $substitute_basic_n"
    exit 1
fi

# -n with print
print_basic_n_print=$(seq 1 5 | python3 pied.py -n '4p')
expected_print_basic_n_print=$(seq 1 5 | 2041 pied -n '4p')
if [ "$print_basic_n_print" != "$expected_print_basic_n_print" ]; then
    echo "expected: $expected_print_basic_n_print"
    echo "produced: $print_basic_n_print"
    exit 1
fi

