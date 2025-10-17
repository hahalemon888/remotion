# 使用官方 Node LTS 版本
FROM node:18-bullseye

# 设置工作目录
WORKDIR /app

# 拷贝 package 文件以便缓存依赖层
COPY package*.json ./

# 安装依赖
RUN npm install

# 拷贝其余项目文件
COPY . .

# 构建 Remotion 项目（可选，但推荐）
RUN npm run build

# 暴露端口（ClawCloud 会通过此端口访问）
EXPOSE 3000

# 启动 Remotion Render Server
# 注意：--port 必须与 ClawCloud 控制台中一致
CMD ["npx", "remotion", "render-server", "--port=3000"]
