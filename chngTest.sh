#!/bin/bash

# check if a test file was specified
if [ $# -ne 1 ]
then
	echo "incorrect number of arguments -- must specify test file name"
	echo "./chngTest [filename]"
	exit
fi

testPath="test_programs/$1" 		       # path to the new test file
instPath="include/inst_mem.in" # path to inst_mem.in file

# check if specified test file exists
if [ -f "$testPath" ]
then
	:
else
	echo "invalid test file name"
	exit
fi

# if previous inst_mem.in exists then remove it
if [ -f "$instPath" ]
then
	rm $instPath
fi

# cp test file from test_programs directory into the include directory - call it inst_mem.in
cp $testPath $instPath



