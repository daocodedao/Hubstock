#!/bin/bash
# https://ta-lib.org/install/#macos-build-from-source

# 获取脚本所在目录
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# 获取项目根目录（脚本目录的上一级目录）
base_dir="$( cd "$script_dir/../.." && pwd )"
echo $base_dir
cd $base_dir

pythonPath=${base_dir}/venv/bin/pip

jobDir="${base_dir}/instock/bin"
echo "jobDir: $jobDir"

# linux 版本
sudo dpkg -i ${jobDir}/ta-lib_0.6.4_amd64.deb  
$pythonPath install TA-Lib