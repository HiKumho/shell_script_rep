# !/bin/bash
# Program :
# 	This program shows the file name, params
# History :
# 2016/08/04		root		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

echo "The script name : $0 "
echo "The script has $# params : $@"


i=1
for var in $@
do
	echo "The ${i}st param : $var"
	i=$(($i+1))
done
exit 0

#if [ "$#" -ge  "2" ] ; then
#	echo "The 1st param : $1 and 2st param : $2"
#fi
