wget -e use_proxy=yes -e http_proxy=http://127.0.0.1:1087 https://github.com/ta-lib/ta-lib/releases/download/v0.6.4/ta-lib_0.6.4_arm64.deb
sudo dpkg -i ta-lib_0.6.4_arm64.deb  
pip install TA-Lib