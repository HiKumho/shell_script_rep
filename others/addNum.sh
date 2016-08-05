# !/bin/bash
# Program :
#	User input a positive integer,it will cal sum=1+2+3+...+num
# History :
# 2016/08/04		root		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

# read user input a num
while [ "$num" == "" ] 
do
	read -p "Please input a positive integer :" num
	echo $(($num+1)) &> /dev/null
	if [ $? -ne 0 ] ; then
		num=0
	fi
	[ $num -le 0 ] && num="" 
done

sum=0
for (( i=1 ; i <= $num ; i=i+1 ))
do
	sum=$(($sum+$i))	
done

echo "sum=1+2+3+...+n=${sum}"
