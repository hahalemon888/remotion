# 使用 Node 18 Alpine 版本
FROM node:18-alpine

# 安装系统依赖
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# 设置环境变量
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    NODE_ENV=production

# 设置工作目录
WORKDIR /app

# 创建目录结构
RUN mkdir -p src

# 创建简单的 Remotion 入口文件
RUN echo 'import { registerRoot } from "remotion"; \
import { MyComposition } from "./MyComposition"; \
 \
registerRoot(() => { \
  return <MyComposition />; \
});' > src/index.ts

# 创建简单的示例组件
RUN echo 'import React from "react"; \
import { AbsoluteFill } from "remotion"; \
 \
export const MyComposition: React.FC = () => { \
  return ( \
    <AbsoluteFill \
      style={{ \
        justifyContent: "center", \
        alignItems: "center", \
        fontSize: 60, \
        backgroundColor: "#000", \
        color: "#fff", \
      }} \
    > \
      Remotion Render Server \
    </AbsoluteFill> \
  ); \
};' > src/MyComposition.tsx

# 创建 package.json
RUN echo '{ \
  "name": "remotion-server", \
  "version": "1.0.0", \
  "scripts": { \
    "start": "remotion studio src/index.ts --port=3000" \
  }, \
  "dependencies": { \
    "remotion": "^4.0.0", \
    "@remotion/cli": "^4.0.0", \
    "@remotion/renderer": "^4.0.0", \
    "@remotion/bundler": "^4.0.0", \
    "react": "^18.0.0", \
    "react-dom": "^18.0.0" \
  } \
}' > package.json

# 安装依赖
RUN npm install --legacy-peer-deps

# 复制源代码（如果需要）
COPY . .

# 暴露端口
EXPOSE 3000

# 启动命令 - 指定入口点
CMD ["npx", "remotion", "studio", "src/index.ts", "--port=3000"]
