#!/bin/bash

# 获取脚本所在目录
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# 获取项目根目录（脚本目录的上一级目录）
base_dir="$( cd "$script_dir/../.." && pwd )"
echo $base_dir
cd $base_dir


jobDir="${base_dir}/instock/web"
echo $jobDir
pythonPath=${base_dir}/venv/bin/python

logName=web_service
jobName=web_service.py

. $base_dir/instock/bin/colors.sh

TAILPID=`ps aux | grep "$jobName" | grep -v grep | awk '{print $2}'`
echo "${YELLOW}check $jobName pid $TAILPID ${NOCOLOR}"
[ "0$TAILPID" != "0" ] && kill -9 $TAILPID

mkdir -p logs

echo "${YELLOW}nohup $pythonPath $jobDir/$jobName > logs/${logName}.log 2>&1 &${NOCOLOR}"
nohup $pythonPath $jobDir/$jobName > logs/${logName}.log 2>&1 &

echo ------Web服务已启动 请不要关闭------
echo 访问地址 : http://localhost:9988/
