# 🚀 DOCKER QUICK START

3 cách nhanh nhất để chạy Rails 8 app trong Docker.

## ⚡ CÁCH 1: Test Local với Docker Compose (30 giây)

```bash
# Chạy script có sẵn
./bin/docker_test

# Hoặc manual:
RAILS_MASTER_KEY=$(cat config/master.key) docker-compose up
```

**Truy cập:** http://localhost:3000

**Dừng:**
```bash
docker-compose down
```

---

## 🔨 CÁCH 2: Build Docker Image (5 phút)

```bash
# Chạy script
./bin/docker_build

# Image sẽ được tạo: note_forge:latest
```

**Kiểm tra image:**
```bash
docker images | grep note_forge
```

---

## ⬆️ CÁCH 3: Push Image lên Registry (cho deploy)

```bash
# Push lên Docker Hub hoặc GitHub Registry
./bin/docker_push

# Script sẽ hướng dẫn bạn từng bước
```

---

## 📋 Lệnh Thường Dùng

### Docker Compose:

```bash
# Start services
docker-compose up -d

# Xem logs
docker-compose logs -f web

# Rails console
docker-compose exec web bin/rails console

# Database migration
docker-compose exec web bin/rails db:migrate

# Stop all
docker-compose down
```

### Docker Image:

```bash
# Build
docker build -t note_forge:latest .

# List images
docker images

# Remove image
docker rmi note_forge:latest

# Clean up
docker system prune -a
```

---

## ✅ Checklist

- [ ] Docker Desktop đang chạy
- [ ] File `config/master.key` tồn tại
- [ ] Port 3000 không bị chiếm

---

## 🆘 Gặp Lỗi?

### "Cannot find master.key"
```bash
bin/rails credentials:edit
```

### "Port 3000 already in use"
```bash
lsof -i :3000
kill -9 PID
```

### "Docker daemon not running"
```bash
# macOS
open -a Docker

# Linux
sudo systemctl start docker
```

### Reset tất cả
```bash
docker-compose down -v
docker system prune -a
```
