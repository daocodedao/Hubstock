#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import time
import datetime
import concurrent.futures
import logging
import os.path
import sys

# 在项目运行时，临时将项目路径添加到环境变量
cpath_current = os.path.dirname(os.path.dirname(__file__))  # 获取当前文件的上级目录
cpath = os.path.abspath(os.path.join(cpath_current, os.pardir))  # 获取项目根目录
sys.path.append(cpath)  # 将项目根目录添加到系统路径
log_path = os.path.join(cpath_current, 'log')  # 设置日志文件路径
if not os.path.exists(log_path):
    os.makedirs(log_path)  # 如果日志目录不存在，则创建
logging.basicConfig(format='%(asctime)s %(message)s', filename=os.path.join(log_path, 'stock_execute_job.log'))  # 配置日志格式和文件
logging.getLogger().setLevel(logging.INFO)  # 设置日志级别为INFO
# 导入各个任务模块
import init_job as bj  # 初始化任务
import basic_data_daily_job as hdj  # 基础数据日常任务
import basic_data_other_daily_job as hdtj  # 其他基础数据日常任务
import basic_data_after_close_daily_job as acdj  # 收盘后基础数据日常任务
import indicators_data_daily_job as gdj  # 指标数据日常任务
import strategy_data_daily_job as sdj  # 策略数据日常任务
import backtest_data_daily_job as bdj  # 回测数据日常任务
import klinepattern_data_daily_job as kdj  # K线形态数据日常任务
import selection_data_daily_job as sddj  # 选股数据日常任务

__author__ = 'myh '
__date__ = '2023/3/10 '


def main():
    """
    主函数：执行所有股票数据处理任务
    """
    start = time.time()  # 记录开始时间
    _start = datetime.datetime.now()  # 获取当前时间
    logging.info("######## 任务执行时间: %s #######" % _start.strftime("%Y-%m-%d %H:%M:%S.%f"))
    
    # 第1步创建数据库
    logging.info("######## 开始 init_job 任务 #######")
    bj.main()
    
    logging.info("第2.1步创建股票基础数据表")
    hdj.main()
    
    logging.info("第2.2步创建综合股票数据表")
    sddj.main()
    # 使用线程池并行执行任务
    with concurrent.futures.ThreadPoolExecutor() as executor:  
        logging.info("第3.1步创建股票其它基础数据表")
        executor.submit(hdtj.main)
        
        logging.info("第3.2步创建股票指标数据表")
        executor.submit(gdj.main)
        
        logging.info("第4步创建股票k线形态表")
        executor.submit(kdj.main)
        
        logging.info("第5步创建股票策略数据表")
        executor.submit(sdj.main)

    logging.info("第6步创建股票回测")
    bdj.main()

    logging.info("第7步创建股票闭盘后才有的数据")
    acdj.main()

    logging.info("######## 完成任务, 使用时间: %s 秒 #######" % (time.time() - start))  # 记录任务完成时间和总耗时


# main函数入口
if __name__ == '__main__':
    main()
