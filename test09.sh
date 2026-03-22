#!/usr/bin/dash

# branching, labels, appending and inserting

basic_insert=$(seq 1 5 | python3 pied.py '3i IHAVEBEENINSERTED')
expected_insert=$(seq 1 5 | 2041 pied '3i IHAVEBEENINSERTED')
if [ "$basic_insert" != "$expected_insert" ]; then
    echo "expected: $expected_insert"
    echo "produced: $basic_insert"
    exit 1
fi

basic_append=$(seq 1 5 | python3 pied.py '3a IHAVEBEENAPPENDED')
expected_append=$(seq 1 5 | 2041 pied '3a IHAVEBEENAPPENDED')
if [ "$basic_append" != "$expected_append" ]; then
    echo "expected: $expected_append"
    echo "produced: $basic_append"
    exit 1
fi

basic_change=$(seq 1 20 | python3 pied.py '3c IHAVEBEENCHANGED')
expected_change=$(seq 1 20 | 2041 pied '3c IHAVEBEENCHANGED')
if [ "$basic_change" != "$expected_change" ]; then
    echo "expected: $expected_change"
    echo "produced: $basic_change"
    exit 1
fi

basic_change_range=$(seq 1 20 | python3 pied.py '3,20c IHAVEBEENCHANGED')
expected_change_range=$(seq 1 20 | 2041 pied '3,20c IHAVEBEENCHANGED')
if [ "$basic_change_range" != "$expected_change_range" ]; then
    echo "expected: $expected_change_range"
    echo "produced: $basic_change_range"
    exit 1
fi

delete_whole_string=$(seq 1 20 | python3 pied.py ':start; s/.//; t start')
expected_delete_whole_string=$(seq 1 20 | 2041 pied ':start; s/.//; t start')
if [ "$delete_whole_string" != "$expected_delete_whole_string" ]; then
    echo "expected: $expected_delete_whole_string"
    echo "produced: $delete_whole_string"
    exit 1
fi

skip_to_end=$(seq 1 20 | python3 pied.py 'b end; s/.*//; :end')
expected_skip_to_end=$(seq 1 20 | 2041 pied 'b end; s/.*//; :end')
if [ "$skip_to_end" != "$expected_skip_to_end" ]; then
    echo "expected: $expected_skip_to_end"
    echo "produced: $skip_to_end"
    exit 1
fi
