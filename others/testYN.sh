# !/bin/bash
# Program :
#	This program show the user's choice
# History :
# 2016/08/04		root		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

# receive Y/N
read -p "Continue? (Y/N)" yn

# printf the user's choice

# no..if...else
#[ "$yn" == "Y" -o "$yn" == "y" ] && echo "Ok,continue" && exit 0
#[ "$yn" == "N" -o "$yn" == "n" ] && echo "Oh,interrupt" && exit 0
#echo "I don't kown what your choice is " && exit 1

# if...else 
#if [ "$yn" == "Y" -o "$yn" == "y" ]; then
#	echo "Ok,continue"
#elif [ "$yn" == "N" -o "$yn" == "n" ]; then
#	echo "Oh,interrupt"
#else 
#echo "I don't kown what your choice is " && exit 1
#fi

# case
case $yn in
  [Yy])
  	echo "Ok,continue"
  	;;
  [Nn])
  	echo "oh,interrupt"
  	;;
   * )
	echo "I don't kown what your choice is " && exit 1
   	;;
esac

exit 0


