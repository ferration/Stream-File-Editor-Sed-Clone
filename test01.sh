#!/usr/bin/dash

# print and substitute testing

basic_print=$(seq 1 5 | python3 pied.py '3p')
expected_basic_print=$(seq 1 5 | 2041 pied '3p')

if [ "$basic_print" != "$expected_basic_print" ]; then
  echo "expected: $expected_basic_print"
  echo "produced: $basic_print"
  exit 1
fi

basic_print_regex=$(seq 1 5 | python3 pied.py '/4/p')
expected_basic_print_regex=$(seq 1 5 | 2041 pied '/4/p')
if [ "$basic_print_regex" != "$expected_basic_print_regex" ]; then
  echo "expected: $expected_basic_print_regex"
  echo "produced: $basic_print_regex"
  exit 1
fi

# after substituting, print before should be the same
basic_print_sub=$(seq 1 5 | python3 pied.py '3p;s/4/5/')
expected_basic_print_sub=$(seq 1 5 | 2041 pied '3p;s/4/5/')
if [ "$basic_print_sub" != "$expected_basic_print_sub" ]; then
  echo "expected: $expected_basic_print_sub"
  echo "produced: $basic_print_sub"
  exit 1
fi

# after substituting, print after should be different
basic_print_sub_2=$(seq 1 5 | python3 pied.py '3p;s/4/5/g')
expected_basic_print_sub_2=$(seq 1 5 | 2041 pied '3p;s/4/5/g')
if [ "$basic_print_sub_2" != "$expected_basic_print_sub_2" ]; then
  echo "expected: $expected_basic_print_sub_2"
  echo "produced: $basic_print_sub_2"
  exit 1
fi

# global subtitution 
basic_print_sub_global=$(seq 10 20 | python3 pied.py '3p;s/1/5/g')
expected_basic_print_sub_global=$(seq 10 20 | 2041 pied '3p;s/1/5/g')
if [ "$basic_print_sub_global" != "$expected_basic_print_sub_global" ]; then
  echo "expected: $expected_basic_print_sub_global"
  echo "produced: $basic_print_sub_global"
  exit 1
fi

# non_global substitution
basic_print_sub_non_global=$(seq 10 20 | python3 pied.py '3p;s/1/5/')
expected_basic_print_sub_non_global=$(seq 10 20 | 2041 pied '3p;s/1/5/')
if [ "$basic_print_sub_non_global" != "$expected_basic_print_sub_non_global" ]; then
  echo "expected: $expected_basic_print_sub_non_global"
  echo "produced: $basic_print_sub_non_global"
  exit 1
fi

# many commands chained together
basic_print_many=$(seq 1 5 | python3 pied.py '3p;s/4/5/g;3p;s/5/4/g;3p;s/4/5/g;3p;s/5/4/g;3p;s/1/5/g;3p;s/5/4/g;3p;s/2/5/g;3p;s/5/4/g')
expected_basic_print_many=$(seq 1 5 | 2041 pied '3p;s/4/5/g;3p;s/5/4/g;3p;s/4/5/g;3p;s/5/4/g;3p;s/1/5/g;3p;s/5/4/g;3p;s/2/5/g;3p;s/5/4/g')
if [ "$basic_print_many" != "$expected_basic_print_many" ]; then
  echo "expected: $expected_basic_print_many"
  echo "produced: $basic_print_many"
  exit 1
fi