# ✅ 使用 Debian 而非 Alpine，Remotion 需要完整 glibc 环境和 Chromium 依赖
FROM node:18-bullseye

# 安装 Remotion 所需的系统依赖（Chromium + 字体）
RUN apt-get update && \
    apt-get install -y chromium fonts-noto-color-emoji fonts-noto-cjk fonts-noto && \
    rm -rf /var/lib/apt/lists/*

# 设置环境变量供 Remotion 使用 Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# 设置工作目录
WORKDIR /app

# 复制依赖文件
COPY packages/studio-server/package*.json ./packages/studio-server/

# 安装依赖
WORKDIR /app/packages/studio-server
RUN npm install --legacy-peer-deps

# 拷贝源代码
WORKDIR /app
COPY . .

# 再次验证 remotion 是否安装成功
RUN ls packages/studio-server/node_modules/remotion || npm install --legacy-peer-deps

# 切换回运行目录
WORKDIR /app/packages/studio-server

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["npm", "start"]
