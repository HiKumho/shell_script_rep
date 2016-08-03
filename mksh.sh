# !/bin/bash
# Program :
# 	This program makes a shell script file and code the style.
# History :
# 2016/08/03		Kumho		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family 
LANG=C.UTF-8
export LANG

# sets the name of the new script  file . default name : nwsh$date$random.sh
if [ "$1" == "" ] ; then
newfile="nwsh$(date +%y%m%d)$(echo $RANDOM).sh"
else 
newfile=$1
fi


# test if the file exists. if it  existed, then exit.
test  -e $newfile && echo "Don't make the file, because it existed." && exit 1

# new the file and make it readable and executable
touch $newfile && chmod a+rx $newfile || exit 1

# codes the style of the file
printf "# !/bin/bash\n"	 >  $newfile
printf "# Program :\n"	 >> $newfile
printf "#	\n"	 >> $newfile
printf "# History :\n" 	 >> $newfile
printf "# $(date +%Y/%m/%d)		$USER		First release\n" >> $newfile
printf "#\n" >> $newfile

exit 0
