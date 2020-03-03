#!/bin/bash
#@example ./run.sh

work_dir=$(dirname $0)
input="$(cat $work_dir/input.txt)"

while read -r line || [ -n "$line" ]; do
  value=`echo $line | awk '{print $1}'`
  name=`echo $line | awk '{print $2}'`
  input=${input//$value/\$\{$name\}}
done < $work_dir/rule.txt

echo "$input"