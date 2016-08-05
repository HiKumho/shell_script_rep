# !/bin/bash
# Program :
#s 	This program show username and current directory.
# History :
# 2016/08/04		kumho		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

# show username and current dirdirectory
username=$(whoami)
curdir=$(pwd)

echo "user : ${username} and current directory : ${curdir}"
exit 0
