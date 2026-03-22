#!/usr/bin/dash

# testing for -f script and input files

# setup
echo "/2/d" > two.pied
echo "/2/d    ; 4p" > twoprint.pied
echo "i am cooked" > invalid.pied 
seq 1 5 > two.txt
seq 1 10 > twoprint.txt
echo "bananas drive a man insane" > invalid.txt

two=$(seq 1 5 | python3 pied.py -f two.pied)
two_expected=$(seq 1 5 | 2041 pied -f two.pied)

if [ "$two" != "$two_expected" ]; then
    echo "expected: $two_expected"
    echo "produced: $two"
    exit 1
fi

twoprint=$(seq 1 5 | python3 pied.py -f twoprint.pied)
twoprint_expected=$(seq 1 5 | 2041 pied -f twoprint.pied)
if [ "$twoprint" != "$twoprint_expected" ]; then
    echo "expected: $twoprint_expected"
    echo "produced: $twoprint"
    exit 1
fi

invalid=$(seq 1 5 | python3 pied.py -f invalid.pied)
invalid_expected=$(seq 1 5 | 2041 pied -f invalid.pied)
if [ "$invalid" != "$invalid_expected" ]; then
    echo "expected: $invalid_expected"
    echo "produced: $invalid"
    exit 1
fi

# testing for -f script and input files
two_input=$(python3 pied.py -f two.pied two.txt)
two_input_expected=$(2041 pied -f two.pied two.txt)
if [ "$two_input" != "$two_input_expected" ]; then
    echo "expected: $two_input_expected"
    echo "produced: $two_input"
    exit 1
fi

twoprint_input=$(python3 pied.py -f twoprint.pied twoprint.txt)
twoprint_input_expected=$(2041 pied -f twoprint.pied twoprint.txt)
if [ "$twoprint_input" != "$twoprint_input_expected" ]; then
    echo "expected: $twoprint_input_expected"
    echo "produced: $twoprint_input"
    exit 1
fi

invalid_input=$(python3 pied.py -f invalid.pied invalid.txt)
invalid_input_expected=$(2041 pied -f invalid.pied invalid.txt)
if [ "$invalid_input" != "$invalid_input_expected" ]; then
    echo "expected: $invalid_input_expected"
    echo "produced: $invalid_input"
    exit 1
fi

# cleanup
rm two.pied
rm twoprint.pied
rm invalid.pied
rm two.txt
rm twoprint.txt
rm invalid.txt

