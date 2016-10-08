# !/bin/bash
# Program :
#	作业处理工具-分类与重命名作业
# Config_FILE: hwt.config
# History :
# 2016/10/08		kumho		First release
#

# 分类作业:
#   根据关键词(k)搜索目录(p)中匹配的文件名,并移动到新建的关键词目录内
# 格式: hwt p -c -k keyword1 keyword2 ... keywordn  
# 重命名作业:
#   搜索文件名中的学号与姓名,如果没学号,则去学号-姓名文件中查找
#   最后重命名文件为学号-姓名
# 格式: hwt p -r

# 设置PATH变量
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# 设置字符集
LANG=C.UTF-8
export LANG


# 配置文件 
CONFIGFILE="hwt.config"
# 读取配置文件
# 进入当前脚本文件的目录
exe_path=$(pwd)  # 暂存执行此命令时的路径
cd $(dirname $0) 
conf_path="$(pwd)/${CONFIGFILE}"
cd $exe_path

# help显示命令 
[ $1 == "-h" ] && echo '分类作业: hwt path -c keyword1 keyword2 keywordN' && echo '重命名作业: hwt path -r' && exit 0

# 处理命令接收的参数
echo $@ | egrep '(.* )? *(-c( +.*)+|-r)' &>/dev/null
[ $? -eq 1 ] && echo "请输入正确的参数" && echo '分类作业: hwt path -c keyword1 keyword2 keywordN' && echo '重命名作业: hwt path -r' && exit 1

##  获取相应的参数
dir='.'    # 需处理的目录
flag_opt=-1  # 判断是分类(0)还是重命名(1)操作,错误则为-1
index_opt_c=-1 #分类(-c)变量的位置
keyword='' # 分类操作使用的关键字

echo $1 | egrep '(-c|-r)' &>/dev/null 
[ $? -eq 1 ] && dir=$1 # path存在,将其赋值给dir
[ ! -d $dir ] && echo "目录${dir}不存在" && exit 1 #目录不存在则退出 
cd $dir
dirname=$(basename $(pwd)) # 获取处理目录名

i=0
for param in $@
do 
  i=$(($i+1))
  case $param in 
      -c)
        flag_opt=0
        index_opt_c=$i 
        ;;
      -r) flag_opt=1 ;;    
       *)[ $index_opt_c -ne -1 ]&&keyword="${keyword}_${param}" ;;
  esac
done
keyword=$(echo $keyword | cut -c 2-)  # 捕获关键字,形如"keyword1_keyword2_..._keywordn"
[ $flag_opt -eq -1 ] && echo "错误操作,请输入正确参数" && exit 1

## 分类操作
classify(){
  # 创建目录
  dir_keyword="hwt_${keyword}"
  [ ! -d $dir_keyword ] && mkdir -p $dir_keyword && echo "创建目录:${dir_keyword}" 

  # 切割关键字串,生成匹配命令式
  grep_cmd=""
  arr=(${keyword//_/ })
  for word in ${arr[@]}
  do 
    grep_cmd="${grep_cmd}| grep \"${word}\""
  done
  grep_cmd=$(echo $grep_cmd | cut -c 2-)
  # 遍历文件,获取匹配的文件
  match_cmd='ls | grep -v "hwt_" | eval $grep_cmd'

  echo "开始转移文件..."
  sum=$(eval $match_cmd | wc -l)
  eval $match_cmd | xargs -i echo "{}   =>  $dir_keyword/"
  echo "...完成。 共${sum}个文件"

  # 真正转移操作
  eval $match_cmd | xargs -i mv {} $dir_keyword   
}

## 重命名操作
rename_files(){
  # 格式化文件名,删除文件名中的空格
  rename 's/ *//g' *

  # 获取班级名册
  register=$(cat $conf_path | egrep -i "^register" | cut -d ":" -f 2)
  [ -z $register ] && echo "请在文件${CONFIGFILE}中配置班级名册文件" && exit 1 

  tmp_dir="hwt_tmp" # 暂存目录
  # 创建暂存目录
  mkdir -p ${tmp_dir}

  echo "开始重命名文件..."
  sum=0
  for aStu in $(cat $register)
  do 
    name=$(echo $aStu | cut -d "-" -f 2)
    aStu_file=""
    aStu_file=$(find . -maxdepth 1 | grep $name) 
    [ -z ${aStu_file} ] && continue
    if [ -d ${aStu_file}  ] ; then 
      mv $aStu_file "${tmp_dir}/${aStu}" 
      echo "${aStu_file}   =>  ${tmp_dir}/${aStu}  "
    else 
      echo ${aStu_file} | egrep -o -i "\.[a-zA-Z]*$" | xargs -i mv $aStu_file "${tmp_dir}/${aStu}{}"
      echo "${aStu_file}   =>  ${tmp_dir}/${aStu}(.*) "
    fi  
    sum=$(($sum+1))
  done
  echo "... 完成。共${sum}个文件"
}



case $flag_opt in 
  0) classify ;;
  1) rename_files ;;
esac


exit 0
