#!/usr/bin/dash

# comments and whitespace testing

basic_comment=$(seq 1 5 | python3 pied.py '3d # comment')
expected_basic_comment=$(seq 1 5 | 2041 pied '3d # comment')
if [ "$basic_comment" != "$expected_basic_comment" ]; then
  echo "expected: $expected_basic_comment"
  echo "produced: $basic_comment"
  exit 1
fi

basic_whitespace=$(seq 1 5 | python3 pied.py '        3d    ')
expected_basic_whitespace=$(seq 1 5 | 2041 pied '        3d    ')
if [ "$basic_whitespace" != "$expected_basic_whitespace" ]; then
  echo "expected: $expected_basic_whitespace"
  echo "produced: $basic_whitespace"
  exit 1
fi

basic_whitespace_comment=$(seq 1 5 | python3 pied.py '        3d     # comment')
expected_basic_whitespace_comment=$(seq 1 5 | 2041 pied '        3d     # comment')
if [ "$basic_whitespace_comment" != "$expected_basic_whitespace_comment" ]; then
  echo "expected: $expected_basic_whitespace_comment"
  echo "produced: $basic_whitespace_comment"
  exit 1
fi

extensive_comment_whitespace=$(seq 1 5 | python3 pied.py '        3d     # comment # comment # comment # 4q;4p # comment # comment # comment # comment')
expected_extensive_comment_whitespace=$(seq 1 5 | 2041 pied '        3d     # comment # comment # comment # 4q;4p # comment # comment # comment # comment')
if [ "$extensive_comment_whitespace" != "$expected_extensive_comment_whitespace" ]; then
  echo "expected: $expected_extensive_comment_whitespace"
  echo "produced: $extensive_comment_whitespace"
  exit 1
fi

