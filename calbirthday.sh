# !/bin/bash
# Program :
#	It show how many days is it to your birthday from now
# History :
# 2016/08/04		root		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

# flag the operation code
mOptCode=0
# record nowday in second, this year, the month and the day of the month
mNowday_s=$(date +%s)
mNowday_y=$(date +%Y)
mNowday_m=$(date +%m)
# record birthday in second, the year, the month and the day of the month
mBirthday_s=""
mBirthday_y=""
mBirthday_mNd=""
# reacord birthday in this year
mBirthday_thisYear_s=""

# record the value that mBirthday_s-mNowday_s
mOff_s=""

# reads the user's birthday and check it.
mInputday=""
while [ "$mInputday" == "" ]
do
	read -p "Please input your birthday. eg.20001012 : " mInputday
	date --date=$mInputday &> /dev/null
	mOptCode=$?
	if [ $mOptCode -ne 0  ] ; then
		echo "The date was loaded incorrectly. please again"
		mInputday=""
	else 
		mBirthday_s=$(date --date=$mInputday +%s) &>/dev/null
		mBirthday_y=$(date --date=$mInputday +%Y) &>/dev/null
		mBirthday_mNd=$(date --date=$mInputday +%m%d) &>/dev/null
		mOff_s=$(($mBirthday_s-$mNowday_s))
		[ "$mOff_s" -gt "0" ] && echo "The date is future.please again"&& mInputday=""
	fi
done

# judge the birthyear is leap year. $1 is year
function isLeapYear(){
	if [ $(($1 % 4)) -eq 0 -a $(($1 % 100 )) -ne 0 ] || [ $(($1 % 400)) -eq 0 ]; then
		return 0
	else 
		return 1
	fi
}

# cal days from second and printf it
function caldays(){
	mOff_days=$(($1/60/60/24))
	mOff_hours=$((($1-$mOff_days*60*60*24)/60/60))
	echo "There are ${mOff_days}days.${mOff_hours}hours that comes your birthday!"
	return 0
}

# if the birthday is Feb.29 in leap year (02.29)
isLeapYear $mBirthday_y
mOptCode=$?
if [ $mOptCode -eq 0 -a "$mBirthday_mNd" == "0229" ] ; then
 	 # echo "The brithday is Feb.29 in leap year"
	 mOff_years=$((4-$mNowday_y%4))
	 
	 # if this year is leap year and the birthday doesn't pass
	 isLeapYear $mNowday_y
	 mOptCode=$?
	 if [ $mOptCode -eq 0 ] && [ "$mNowday_m" == "02" -o "$mNowday_m" == "01" ] ; then
	 	# echo "this year is leap year and birthday doen't pass"
		mBirthday_thisYear_s=$(date --date=${mNowday_y}${mBirthday_mNd} +%s)
	  	mOff_s=$(($mBirthday_thisYear_s-$mNowday_s))
		caldays mOff_s
	 else 
		#  if [ $mOff_years -ne 4 ] ; then 
		# this year isn't leap year
		mNextYear=$(($mNowday_y+$mOff_years))
		mBirthday_nextYear_s=$(date --date=${mNextYear}${mBirthday_mNd} +%s)
		mOff_s=$(($mBirthday_nextYear_s-$mNowday_s))
		caldays mOff_s
	 fi
	 
else
	 # echo "The brithday isn't Feb.29 in leap year"
	 mBirthday_thisYear_s=$(date --date=${mNowday_y}${mBirthday_mNd} +%s)
	 mOff_s=$(($mBirthday_thisYear_s-$mNowday_s))
	 # the birthday doesn't pass
	 if [ $mOff_s -ge 0 ] ; then
		caldays $mOff_s
	 else 
	 # the birthday has passed
	   	mNextYear=$(($mNowday_y+1))
		mBirthday_nextYear_s=$(date --date=${mNextYear}${mBirthday_mNd} +%s)
		mOff_s=$(($mBirthday_nextYear_s-$mNowday_s))
		caldays $mOff_s
	 fi

fi

exit 0
