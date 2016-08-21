# !/bin/bash
# Program :
#    This program will new a finger file of important files and check it.
# History :
# 2016/08/21		root		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

# the file inclue important files 
impFiles=important.file
# the output and check finger file
fingerFile=finger.file
# the temporary file for checking the fingerFile
fingerFile_tmp=finger.tmp.file

# remove the old fingerFile and new it
function newFingerFile(){
	[ ! -f ${impFiles} ] && echo "The important.file not exist" && exit 1
	# overwrite the finger.file
	[ -f ${fingerFile} ] && chattr -i ${fingerFile} && printf ""> ${fingerFile}  2>/dev/null
	for fileName in $(cat ${impFiles})
	do
		# check the fileName
		echo ${fileName} | egrep "^\ ?*/" &>/dev/null
	 	# [ $? -eq 0 ] && echo $fileName
		[ $? -ne 0 ] && continue
		# output the md5 key
		md5sum ${fileName} >> ${fingerFile} 2>/dev/null
	done
	chattr +i ${fingerFile}
}

# check the fingerFile
function checkFingerFile(){
	[ ! -f ${impFiles} ] && echo "The important.file not exist" && exit 1
	for fileName in $(cat ${impFiles})
	do
		# check the fileName
		echo ${fileName} | egrep "^\ ?*/" &>/dev/null
	 	# [ $? -eq 0 ] && echo $fileName
		[ $? -ne 0 ] && continue
		# output the md5 key
		md5sum ${fileName} >> ${fingerFile_tmp} 2>/dev/null
	done

	diffTest=$(diff ${fingerFile} ${fingerFile_tmp})
	[ ! -z  "$diffTest" ] && echo ${diffTest} | mail -s "finger trouble.." root

	rm -r ${fingerFile_tmp}
}

[ $# -eq 0 ] && echo "Please input parameter (new|check)" && exit 1

for param in $@
do
	case $param in
		[nN][eE][wW]) 
			newFingerFile
		;;
		[cC][hH][eE][cC][kK])
			checkFingerFile
		;;
		*)	echo "Please input correct parameter"
		;;
	esac
done


