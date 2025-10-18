# 使用 Node 18（bullseye 版本以支持 Remotion 的 Chromium）
FROM node:18-bullseye-slim

# 设置工作目录
WORKDIR /app

# 仅拷贝依赖文件
COPY packages/studio-server/package*.json ./packages/studio-server/

# 安装依赖（先安装，利用缓存）
WORKDIR /app/packages/studio-server
RUN npm install --legacy-peer-deps

# 现在拷贝剩余代码，但排除 node_modules
WORKDIR /app
COPY . .

# 再次确保 node_modules 未被覆盖（有时多层 COPY 会清空）
RUN ls packages/studio-server/node_modules/remotion || npm install --legacy-peer-deps

# 切回 studio-server 目录
WORKDIR /app/packages/studio-server

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["npm", "start"]
