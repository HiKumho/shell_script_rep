# !/bin/bash
# Program :
#	test /root/test/logical .
#	1) No exist > touch 
#	2) Exist    > if it's file, remove and mkdir.
#		    > if it's dir, remove
# History :
# 2016/08/04		root		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

dir=/root/test
file=${dir}/logical

# if $file doesn't exist
test ! -e $file && test -e $dir || mkdir $dir && touch $file && exit 0  
# if $file existed
test -f $file &&  rm -r $file && mkdir $file && exit 0
test -d $file && rm -r $file && exit 0





