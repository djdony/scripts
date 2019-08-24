#!/bin/bash
path=/home/dony
nodname=essence

z="ls |grep ${nodname}-cli | tr -dc '0-9'."
total=$(eval $z)
IFS="."
arr=($total)
unset IFS

for item in ${arr[*]}
do

x="$path/./${nodname}-cli_${item}.sh masternode debug"
check=$(eval $x)
words=($check)
status=${words[2]}

if [ "$status" != "started" ]
then
echo  "MN$item - $check"
#else
#echo   "MN$item - $check"
fi
done
