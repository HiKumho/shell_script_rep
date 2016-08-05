# !/bin/bash
# Program :
#	This program show acounts in /etc/passwd
# History :
# 2016/08/04		root		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

passwd=/etc/passwd

cat $passwd | awk ' 
BEGIN {FS=":"}  
{printf "The %d account is \" %s \" \n",NR,$1}

'
exit 0
