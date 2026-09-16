<div align="center">

<img src="./7x-api-logo.png" alt="AI Gateway Logo" width="200" />

# AI Gateway

**企业级 AI API 网关与管理平台**

<p align="center">
  <strong>简体中文</strong> | <a href="./README.md">English</a>
</p>

</div>

## 项目简介

AI Gateway 是一个大语言模型统一 API 网关，将多个上游 AI 服务商聚合在标准化接口后。提供用户管理、计费、限流和管理后台等功能。

## 快速开始

### Docker Compose（推荐）

前后端使用同一个 Docker 镜像构建和运行，Nginx 在容器内同时提供前端静态资源、反向代理和后端 API 服务。

```bash
# 克隆项目
git clone <your-repo-url>
cd my-7x-api

# 构建并启动前后端合一的应用服务及依赖
docker compose up -d --build
```

部署完成后，访问 `http://localhost` 即可使用。

### Docker 命令

```bash
# 构建前后端合一的镜像
docker build -t chrissong1994/7x-api:latest -f docker/Dockerfile .

# 使用 SQLite（默认），运行前后端合一的服务
docker run --name 7x-api -d --restart always \
  -p 80:80 \
  -e TZ=Asia/Shanghai \
  -v ./data:/app/data \
  -v ./logs:/app/logs \
  chrissong1994/7x-api:latest
```

## 主要特性

### 核心功能

- 现代化 UI 设计
- 多语言支持（中文、英文）
- 数据可视化看板
- 令牌分组与模型限制
- 用户管理

### 支付与计费

- 在线充值（易支付、Stripe）
- 按量计费
- 灵活的计费策略配置

### 授权与安全

- OAuth 登录（GitHub、Discord、OIDC）
- WebAuthn/Passkeys 支持
- 令牌额度管理

### API 支持

- OpenAI 兼容 API
- Claude Messages
- Google Gemini
- Rerank 模型（Cohere、Jina）

## 部署

### 部署要求

| 组件 | 要求 |
|------|------|
| 本地数据库 | SQLite |
| 远程数据库 | MySQL ≥ 5.7.8 或 PostgreSQL ≥ 9.6 |
| 容器引擎 | Docker / Docker Compose |

### 环境变量

| 变量 | 说明 | 默认值 |
|----------|-------------|---------|
| `SESSION_SECRET` | 会话密钥（多实例部署必须） | - |
| `CRYPTO_SECRET` | 加密密钥（Redis 必须） | - |
| `SQL_DSN` | 数据库连接字符串 | - |
| `REDIS_CONN_STRING` | Redis 连接字符串 | - |
| `STREAMING_TIMEOUT` | 流式超时时间（秒） | `300` |

## 许可证

本项目采用商业许可证，保留所有权利。
