#! /bin/bash

if [[ "$#" -ne 1 ]]; then
	echo "usage: $0 [/path/to/minishell]" 2>&1
	exit 1
fi

ms=$1
n=1

GREEN='\033[0;32m'
RED='\033[0;31m'
END='\033[0m'

OK="${GREEN} OK ${END}"
KO="${RED} KO ${END}"


function test_stdout {
	echo $1 | bash > bashtmp 2>&1
	echo $1 | "$ms" 2>&1 | grep -v minishell > mstmp
	
	echo -n "test $n: " 
	diff -q bashtmp mstmp > /dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo -e $KO "expected: $(cat bashtmp) | got: $(cat mstmp)"
	else
		echo -e $OK
	fi
	((n++))
}

function test_status {
	echo -n "test $n: "
	echo "$1" | bash >/dev/null 2>&1
	tmp=$?
	echo "$1" | "$ms" >/dev/null 2>&1
	pstat=("${PIPESTATUS[@]}")
	if [[ ${pstat[1]} -ne $tmp ]]; then
		echo -e $KO
	else
		echo -e $OK
	fi
	((n++))
}

# EVALUATION SHEET

# ==== TEST 1 ====

echo "======== ECHO ========="

test_stdout 'echo            1              2                3'
test_stdout '            echo  echo echo echo'


echo "======== EXIT ========="


# ==== TEST 2 ====
test_status 'exit 45'
test_status 'exit jejeje'
test_status 'exit 1 2 3 4'
test_status 'exit -3'

# ==== TEST 3 ====

echo "======== STATUS ========="

test_status "/bin/ls keloke"
test_status "/bin/ls cat cat cat cat cat"
test_status "grep cd ls env"
test_status "'expr $? + $?'"

# ==== TEST 4 ====

echo "======== DQ ========="

test_stdout 'echo "4 2"   " 0"'
test_stdout 'echo "   "Hello "World "'
test_stdout 'echo cat "|" keloke'
test_stdout 'echo "cat lol.c | cat > lol.c"'
test_stdout 'echo "|>><<>>!|<dsad|| ||| >"'
test_stdout 'echo "echo "echo "echo """'
test_stdout 'echo $USER'
test_stdout 'echo '"'"''$USER''"'"''

# ==== TEST 4 ====

echo "======== SQ ========="

test_stdout "echo '\$USER'"
test_stdout "echo '<>><<|>|<'"
test_stdout "echo '<>><<|>|'"
test_stdout "echo '|'"
test_stdout "echo '<'"
test_stdout "echo 42 '|' cat -e"
# test_stdout "cat ''"
# test_stdout "'echo hello'"

# ==== TEST 5 ====

echo "======== RP ========="

test_stdout "../../../../../../../../../usr/bin/ls"
test_stdout "../minishell-tests/../../../../../../../../usr/bin/ls"
test_stdout "./aux.sh"

# ==== TEST 6 ====

echo "======== REDIR ========="
test_status "echo > >"
test_status "<"

echo "======== ENVARS ========="
test_stdout "echo \$PATH"
test_stdout "echo '\$PATH'"
test_status "\$USER"

rm bashtmp
rm mstmp
