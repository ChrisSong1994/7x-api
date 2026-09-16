WEBSITE_DIR = ./website
SERVER_DIR = ./server

DOCKER_IMAGE ?= 7x-api
DOCKER_TAG ?= latest
DOCKERFILE ?= docker/Dockerfile
DOCKER_PLATFORM ?=
DOCKER_PLATFORMS ?= linux/amd64,linux/arm64

.PHONY: all build-frontend start-backend dev dev-api dev-web build docker-build docker-buildx docker-up docker-down docker-clean

all: build-frontend start-backend

# 安装前端依赖
install-frontend:
	@echo "Installing frontend dependencies..."
	@cd $(WEBSITE_DIR) && pnpm install

# 构建前端
build-frontend:
	@echo "Building frontend..."
	@cd $(WEBSITE_DIR) && pnpm install && pnpm run build

# 启动后端（开发）
start-backend:
	@echo "Starting backend dev server..."
	@cd $(SERVER_DIR) && go run main.go

# 启动前端（开发）
start-frontend:
	@echo "Starting frontend dev server..."
	@cd $(WEBSITE_DIR) && pnpm run dev

# 本地开发 - 后端 Docker 服务
dev-api:
	@echo "Starting backend services (docker)..."
	@docker compose -f docker-compose.dev.yml up -d

# 本地开发 - 前端
dev-web:
	@echo "Starting frontend dev server..."
	@cd $(WEBSITE_DIR) && pnpm install && pnpm run dev

# 本地开发 - 全部（先启动后端 Docker，再启动前端 dev server）
dev: dev-api dev-web

# 生产构建 - 前端 + 后端二进制
build: build-frontend
	@echo "Building backend binary..."
	@cd $(SERVER_DIR) && go build -o server .

# Docker 构建（生产，前后端合一）
# 默认构建当前平台镜像: make docker-build
# 指定镜像名和标签: make docker-build DOCKER_IMAGE=chrissong1994/7x-api DOCKER_TAG=v1.0.0
# 指定目标平台: make docker-build DOCKER_PLATFORM=linux/amd64
docker-build:
	@echo "Building Docker image $(DOCKER_IMAGE):$(DOCKER_TAG)..."
	@docker build $(if $(strip $(DOCKER_PLATFORM)),--platform $(DOCKER_PLATFORM),) -t $(DOCKER_IMAGE):$(DOCKER_TAG) -f $(DOCKERFILE) .

# Docker 多架构构建并推送（需要先 docker login）
# 用法: make docker-buildx DOCKER_IMAGE=chrissong1994/7x-api DOCKER_TAG=v1.0.0
docker-buildx:
	@echo "Building and pushing multi-arch Docker image $(DOCKER_IMAGE):$(DOCKER_TAG) ($(DOCKER_PLATFORMS))..."
	@docker buildx build --platform $(DOCKER_PLATFORMS) -t $(DOCKER_IMAGE):$(DOCKER_TAG) -f $(DOCKERFILE) --push .

# Docker 启动（生产）
docker-up:
	@echo "Starting combined Docker app and dependencies..."
	@docker compose up -d

# Docker 停止
docker-down:
	@echo "Stopping Docker services..."
	@docker compose down

# Docker 停止并清理数据
docker-clean:
	@echo "Stopping Docker services and cleaning data..."
	@docker compose down -v