#!/bin/sh
set -e

cd /app

# Go 后端为主进程
./server --log-dir /app/logs &
SERVER_PID=$!
nginx -g "daemon off;" &
NGINX_PID=$!

# docker stop → tini 转发 SIGTERM → 这里再转发给 server/nginx，优雅停机
trap 'kill -TERM $SERVER_PID $NGINX_PID 2>/dev/null' TERM INT

# 等待 server 退出；trap 打断 wait 时循环续等，直到 server 真正退出
while kill -0 $SERVER_PID 2>/dev/null; do
  wait $SERVER_PID
done
SERVER_EXIT=$?

# server 退出（正常/崩溃）后关停 nginx，并以 server 的退出码退出，交给 Docker restart policy 恢复
kill -TERM $NGINX_PID 2>/dev/null
wait $NGINX_PID 2>/dev/null
exit $SERVER_EXIT
