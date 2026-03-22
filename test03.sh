#!/usr/bin/dash

# more substitute testing

# any delimiter works
normal_slash=$(seq 1 5 | python3 pied.py 's/3/lol/')
expected_normal_slash=$(seq 1 5 | 2041 pied 's/3/lol/')

if [ "$normal_slash" != "$expected_normal_slash" ]; then
  echo "expected: $expected_normal_slash"
  echo "produced: $normal_slash"
  exit 1
fi

normal_pipe=$(seq 1 5 | python3 pied.py 's|3|lol|')
expected_normal_pipe=$(seq 1 5 | 2041 pied 's|3|lol|')
if [ "$normal_pipe" != "$expected_normal_pipe" ]; then
  echo "expected: $expected_normal_pipe"
  echo "produced: $normal_pipe"
  exit 1
fi

normal_hash=$(seq 1 5 | python3 pied.py 's#3#lol#')
expected_normal_hash=$(seq 1 5 | 2041 pied 's#3#lol#')
if [ "$normal_hash" != "$expected_normal_hash" ]; then
  echo "expected: $expected_normal_hash"
  echo "produced: $normal_hash"
  exit 1
fi

normal_X=$(seq 1 5 | python3 pied.py 'sX3XlolX')
expected_normal_X=$(seq 1 5 | 2041 pied 'sX3XlolX')
if [ "$normal_X" != "$expected_normal_X" ]; then
  echo "expected: $expected_normal_X"
  echo "produced: $normal_X"
  exit 1
fi


