# !/bin/bash
# Program :
#     User inputs his first name and last name. Program show full name.	
# History :
# 2016/08/04		Kumho		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

# read user inputed frist name and last name.
while [ "$firstname" == "" ]
do
	read -p "Please input your frist name: " firstname
done

while [ "$lastname" == "" ]
do
	read -p "Please input your last name: " lastname
done

# printd full name.
echo "Your full name : $firstname $lastname"
exit 0
