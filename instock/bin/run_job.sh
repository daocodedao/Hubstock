#!/bin/sh


# /usr/local/bin/python3 /data/work/Hubstock/instock/job/execute_daily_job.py

# 获取脚本所在目录
script_dir=`pwd`
# 获取项目根目录（脚本目录的上一级目录）
base_dir="$( cd "$script_dir/.." && pwd )"
echo "base_dir: $base_dir"
cd $base_dir
. $base_dir/instock/bin/colors.sh

jobDir="${base_dir}/job"
echo "jobDir: $jobDir"
pythonPath=${base_dir}/venv/bin/python
. $base_dir/instock/bin/colors.sh


logName=execute_daily_job
jobName=execute_daily_job.py

TAILPID=`ps aux | grep "$jobName" | grep -v grep | awk '{print $2}'`
echo "${YELLOW}check $jobName pid $TAILPID ${NOCOLOR}"
[ "0$TAILPID" != "0" ] && kill -9 $TAILPID

# 默认操作为 restart，如果有参数且为 stop，则只执行停止操作
action=${1:-restart}

# 如果操作为 stop，则到此结束
if [ "$action" = "stop" ]; then
    echo "${GREEN}已完成停止操作${NOCOLOR}"
    exit 0
fi

mkdir -p logs

echo "${YELLOW}nohup $pythonPath $jobDir/$jobName > logs/${logName}.log 2>&1 &${NOCOLOR}"
nohup $pythonPath $jobDir/$jobName > logs/${logName}.log 2>&1 &


echo ------整体作业 支持批量作业------
echo 当前时间作业 python execute_daily_job.py
echo 1个时间作业 python execute_daily_job.py 2023-03-01
echo N个时间作业 python execute_daily_job.py 2023-03-01,2023-03-02
echo 区间作业 python execute_daily_job.py 2023-03-01 2023-03-21
echo ------单功能作业 除了创建数据库 其他都支持批量作业------
echo 创建数据库作业 python init_job.py
echo 综合选股作业 python selection_data_daily_job.py
echo 基础数据实时作业 python basic_data_daily_job.py
echo 基础数据收盘2小时后作业 python backtest_data_daily_job.py
echo 基础数据非实时作业 python basic_data_other_daily_job.py
echo 指标数据作业 python indicators_data_daily_job.py
echo K线形态作业 klinepattern_data_daily_job.py
echo 策略数据作业 python strategy_data_daily_job.py
echo 回测数据 python backtest_data_daily_job.py
echo ------正在执行作业中 请等待------
