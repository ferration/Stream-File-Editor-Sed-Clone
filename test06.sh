#!/usr/bin/dash

# address ranges test

simple_number_range=$(seq 1 10 | python3 pied.py '2,5d')
expected_simple_number_range=$(seq 1 10 | 2041 pied '2,5d')
if [ "$simple_number_range" != "$expected_simple_number_range" ]; then
  echo "expected: $expected_simple_number_range"
  echo "produced: $simple_number_range"
  exit 1
fi

simple_number_range_regex=$(seq 1 20 | python3 pied.py '/2/,/5/d')
expected_simple_number_range_regex=$(seq 1 20 | 2041 pied '/2/,/5/d')
if [ "$simple_number_range_regex" != "$expected_simple_number_range_regex" ]; then
  echo "expected: $expected_simple_number_range_regex"
  echo "produced: $simple_number_range_regex"
  exit 1
fi

end_range_number=$(seq 1 20 | python3 pied.py '/2/,4d')
expected_end_range_number=$(seq 1 20 | 2041 pied '/2/,4d')
if [ "$end_range_number" != "$expected_end_range_number" ]; then
  echo "expected: $expected_end_range_number"
  echo "produced: $end_range_number"
  exit 1
fi

end_range_number_regex=$(seq 1 20 | python3 pied.py '2,/5/d')
expected_end_range_number_regex=$(seq 1 20 | 2041 pied '2,/5/d')
if [ "$end_range_number_regex" != "$expected_end_range_number_regex" ]; then
  echo "expected: $expected_end_range_number_regex"
  echo "produced: $end_range_number_regex"
  exit 1
fi

# last line range
last_line_range=$(seq 1 20 | python3 pied.py '2,$d')
expected_last_line_range=$(seq 1 20 | 2041 pied '2,$d')
if [ "$last_line_range" != "$expected_last_line_range" ]; then
  echo "expected: $expected_last_line_range"
  echo "produced: $last_line_range"
  exit 1
fi

