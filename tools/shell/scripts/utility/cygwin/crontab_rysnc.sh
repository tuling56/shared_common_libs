#########################################################################
# File Name: crontab_rsync.sh
# Description:更新同步文件和文件夹
# Author:tuling56
# State:
# Created_Time: 2017年8月18日
# Last modified: 2017年8月18日
#########################################################################
#!/bin/bash
dir=`dirname $0` && dir=`cd $dir && pwd`
BASH_WORKSPACE=${BASH_WORKSPACE:-"/cygdrive/e/OneDrive - std.uestc.edu.cn/Code/Git/shared_common_libs/tools/shell/scripts/utility"}
source "${BASH_WORKSPACE}/common/global_var.sh"
source "${BASH_WORKSPACE}/common/global_fun.sh"
cd $dir

echo $(date +%F\ %T)

#set -e

# [本地|->远程]管道文件同步
function rsync_pipeline()
{
	iinfo "同步本地之间的pipelines...."
	local src=/cygdrive/e/Code/Git/Python/Projects/xmp/media_lib/lichaotest/lichaotest/pipelines.py
	local dst=/cygdrive/e/Code/Git/Python/Projects/xmp/media_lib/https_spider/https_spider/pipelines.py
	cmp_mv_file $src $dst

	iinfo "同步本pipelines到远程...."
	rdst_1="/home/yjm/Projects/python/pythondev/Projects/xmp/media_lib/lichaotest/lichaotest/pipelines.py"
	rdst_2="/home/yjm/Projects/python/pythondev/Projects/xmp/media_lib/https_spider/https_spider/pipelines.py"
	# rsync.exe -u -e 'ssh -i ~/.ssh/id_rsa -p 122' -avP $src root@localhost:$rdst_1
	# rsync.exe -u -e 'ssh -i ~/.ssh/id_rsa -p 122' -avP $src root@localhost:$rdst_2
}

# [本地]本目录下的程序同步到shell版本管理库
function rsync_shell()
{
	iinfo "同步cygwin的定时脚本到shell版本库"
	rsync.exe -u -avP ./*.py  "$BASH_WORSPACE/cygwin"
	rsync.exe -u -avP ./*.sh  "$BASH_WORKSPACE/cygwin"
}

# [本地->远程]数据库同步
function rsync_db()
{
	echo "# [本地->远程]数据库同步....."
	MYSQL="mysql -uroot -proot -N"
	ALecsSQL="mysql -h47.995.195.31 -uroot -p123 -Dstudy"
	ALyosSQL="mysql -hbdm295290494.my3w.com -ubdm295290494  -pyunosa112233 -Dbdm295290494_db"

	# 方式1：
	${MYSQL} -e "select * from study.datatype" > hhah
	${ALecsSQL} 

	# 方法2:
	mysqldump -uroot -proot study > study.sql
	${ALecsSQL} < study.sql
	rm -f study.sql


	return 0
}

# [本地->远程]查询sql同步
function rsync_query()
{
	echo "# [本地->远程]查询sql同步....."
	local_sql='/cygdrive/c/Users/xl/Documents/Navicat/MySQL/servers/*'
	remote_sql='/home/yjm/Projects/mysql/sql'

	rsync.exe -u -e 'ssh -i /cygdrive/c/Users/xl/.ssh/id_rsa' -avP --delete $local_sql root@47.95.195.31:$remote_sql
}

# [本地->OneDrive]文档图片等同步
function rsync_docimg()
{
	echo "[本地->OneDrive]文档图片等同步...."
	local local_dimg='/cygdrive/c/Users/xl/Downloads/Documents/表情包'
	local remote_dimg='/cygdrive/e/OneDrive/图片'

	rsync.exe -avP "$local_dimg" "$remote_dimg"
}

# [本地->OneDrive]gitbash的配置同步(有问题未解决)
function rsync_gitbash()
{
	echo "[本地->OneDrive]gitbash的配置同步...."
	local local_conf='"/cygdrive/c/Program Files/Git/etc/bash.bashrc" "/cygdrive/c/Program Files/Git/etc/vimrc"'
	local remote_conf='"/cygdrive/e/OneDrive - std.uestc.edu.cn/Code/Git/mdotfiles/git/gitbash/"'
	rsync.exe -avP "$local_conf" "$remote_conf"
}


#################################### 主程序入口
# rsync_pipeline
rsync_shell
#rsync_db
rsync_query
rsync_docimg
#rsync_gitbash


exit 0