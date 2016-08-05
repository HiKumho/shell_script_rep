# !/bin/bash
# Program :
#	User input a filename, Program will check the flowing:
#	1. exist	2. file/dir	3. file permissions 
# History :
# 2016/08/04		root		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

# read a filename
while [ "$filename" == "" ]
do
 read -p \
 "Please input a filename, I will check the filename's type and permission:" \
 filename
done

# check the file if exist
test ! -e $filename && echo "$filename doesn't exist." && exit 1 

# check the filetype
test -f $filename && filetype="file"
test -d $filename && filetype="dir"

# check the filepermission
test -r $filename && perm="readable"
test -w $filename && perm="$perm writable"
test -x $filename && perm="$perm executable"

# printf the checked infomation
echo "The $filetype : $filename is $perm"

exit 0
