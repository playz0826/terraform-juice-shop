使用terraform來建立juice-shop VM
- 跑來腳本後大約需等待20分鐘讓VM去安裝Juice-shop
- 等待約20分鐘後再用外部IP加3000即可存取juice-shop的網頁
- 若網頁沒有起來，可SSH至GCE內，使用sudo journalctl -u google-startup-scripts.service，查看腳本跑的狀態
