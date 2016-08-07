# !/bin/bash
# Program :
# This program will read usernames for adding users in system from users.txt
# History :
# 2016/08/07		kumho		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

# for log file
logfile="usersadd.log"

# read usernames from users.txt
usersfile=users.txt
[ ! -f $usersfile ] && echo "The $usersfile doesn't exist." &&exit 1
usernames=$(cat $usersfile)

# start to add users
echo "" >> $logfile
echo "starting add users. date : $(date +"%Y/%m/%d %T")" >> $logfile
for username in $usernames
do
	echo "adding user: $username" >> $logfile
	# useradd : create home dir and specify shell
	useradd -m -s /bin/bash $username  &>>$logfile
	# the password is same as the username.
	# the system not support passwd --stdin, so you can also do that or
	# (printf "${username}\n${username}\n" | passwd $username)
	echo "${username}:${username}" | chpasswd -m  &>>$logfile
	# request user for changing passwd at sign in
	chage -d 0 $username   &>>$logfile
	echo "added user: $username">> $logfile
done
echo "end add users. date : $(date +"%Y/%m/%d %T")">>$logfile

