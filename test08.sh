#!/usr/bin/dash

# inplace flag testing

seq 1 5 > five.txt
seq 1 2 > two.txt
echo "hello" > hello.txt
echo "world" > world.txt

basic_one_five=$(python3 pied.py -i '2d' five.txt)
basic_one_five_output=$(cat five.txt)
seq 1 5 > five.txt
expected_basic_one_five=$(2041 pied -i '2d' five.txt)
expected_basic_one_five_output=$(cat five.txt)

if [ "$basic_one_five" != "$expected_basic_one_five" ]; then
    echo "expected: $expected_basic_one_five"
    echo "produced: $basic_one_five"
    exit 1
fi

if [ "$basic_one_five_output" != "$expected_basic_one_five_output" ]; then
    echo "expected: $expected_basic_one_five_output"
    echo "produced: $basic_one_five_output"
    exit 1
fi

seq 1 5 > five.txt
basic_two_five=$(python3 pied.py -i '/2/d' five.txt two.txt)
basic_two_five_output=$(cat five.txt two.txt)
seq 1 5 > five.txt
seq 1 2 > two.txt
expected_basic_two_five=$(2041 pied -i '/2/d' five.txt two.txt)
expected_basic_two_five_output=$(cat five.txt two.txt)
if [ "$basic_two_five" != "$expected_basic_two_five" ]; then
    echo "expected: $expected_basic_two_five"
    echo "produced: $basic_two_five"
    exit 1
fi
if [ "$basic_two_five_output" != "$expected_basic_two_five_output" ]; then
    echo "expected: $expected_basic_two_five_output"
    echo "produced: $basic_two_five_output"
    exit 1
fi


basic_hello_world=$(python3 pied.py -i '/2/d' hello.txt world.txt)
basic_hello_world_output=$(cat hello.txt world.txt)
echo "hello" > hello.txt
echo "world" > world.txt
expected_basic_hello_world=$(2041 pied -i '/2/d' hello.txt world.txt)
expected_basic_hello_world_output=$(cat hello.txt world.txt)
if [ "$basic_hello_world" != "$expected_basic_hello_world" ]; then
    echo "expected: $expected_basic_hello_world"
    echo "produced: $basic_hello_world"
    exit 1
fi
if [ "$basic_hello_world_output" != "$expected_basic_hello_world_output" ]; then
    echo "expected: $expected_basic_hello_world_output"
    echo "produced: $basic_hello_world_output"
    exit 1
fi

# cleanup
rm five.txt
rm two.txt
rm hello.txt
rm world.txt