#!/usr/bin/dash

# quit and delete testing

basic_quit=$(seq 1 5 | python3 pied.py '3q')
expected_basic_quit=$(seq 1 5 | 2041 pied '3q')

if [ "$basic_quit" != "$expected_basic_quit" ]; then
  echo "expected: $expected_basic_quit"
  echo "produced: $basic_quit"
  exit 1
fi

basic_quit_regex=$(seq 1 5 | python3 pied.py '/4/q')
expected_basic_quit_regex=$(seq 1 5 | 2041 pied '/4/q')

if [ "$basic_quit_regex" != "$expected_basic_quit_regex" ]; then
  echo "expected: $expected_basic_quit_regex"
  echo "produced: $basic_quit_regex"
  exit 1
fi

# quitting on a deleted line
basic_quit_deleted=$(seq 1 5 | python3 pied.py '3d;3q')
expected_basic_quit_deleted=$(seq 1 5 | 2041 pied '3d;3q')
if [ "$basic_quit_deleted" != "$expected_basic_quit_deleted" ]; then
  echo "expected: $expected_basic_quit_deleted"
  echo "produced: $basic_quit_deleted"
  exit 1
fi

# quitting on a deleted line with regex
basic_quit_deleted_regex=$(seq 1 5 | python3 pied.py '/4/d;/4/q')
expected_basic_quit_deleted_regex=$(seq 1 5 | 2041 pied '/4/d;/4/q')
if [ "$basic_quit_deleted_regex" != "$expected_basic_quit_deleted_regex" ]; then
  echo "expected: $expected_basic_quit_deleted_regex"
  echo "produced: $basic_quit_deleted_regex"
  exit 1
fi

# quitting on a deleted line with regex and a second command
basic_quit_deleted_regex_2=$(seq 1 5 | python3 pied.py '/4/d;/4/q;3d')
expected_basic_quit_deleted_regex_2=$(seq 1 5 | 2041 pied '/4/d;/4/q;3d')
if [ "$basic_quit_deleted_regex_2" != "$expected_basic_quit_deleted_regex_2" ]; then
  echo "expected: $expected_basic_quit_deleted_regex_2"
  echo "produced: $basic_quit_deleted_regex_2"
  exit 1
fi

# infinite input
basic_quit_infinite=$(yes | python3 pied.py '3q')
expected_basic_quit_infinite=$(yes | 2041 pied '3q')
if [ "$basic_quit_infinite" != "$expected_basic_quit_infinite" ]; then
  echo "expected: $expected_basic_quit_infinite"
  echo "produced: $basic_quit_infinite"
  exit 1
fi