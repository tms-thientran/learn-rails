# 🚀 HƯỚNG DẪN DEPLOY RAILS 8 VỚI KAMAL

## ⚡ TÓM TẮT NHANH

```bash
# 1. Setup server (on server)
ssh ubuntu@YOUR_IP
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker ubuntu
exit && ssh ubuntu@YOUR_IP
docker run --rm hello-world  # Test

# 2. Config local (on local)
# Edit config/deploy.yml với IP và username
# Edit .kamal/secrets với tokens và passwords

# 3. Build & Deploy (on local)
docker builder prune -a -f
docker build --no-cache -t ghcr.io/USERNAME/learn-rails:latest .
docker push ghcr.io/USERNAME/learn-rails:latest
kamal setup

# 4. Access
http://YOUR_SERVER_IP
```

---

## 📋 YÊU CẦU TRƯỚC KHI DEPLOY

### 1. Server Requirements
- Ubuntu 22.04+ hoặc Debian
- Docker đã cài đặt
- SSH access (port 22)
- Tối thiểu: 2GB RAM, 2 CPU cores, 20GB disk
- IP tĩnh hoặc domain name

### 2. Local Requirements
- Ruby 3.4.7
- Docker (để build images)
- Git

## 🔧 CÀI ĐẶT

### Bước 1: Chuẩn Bị Server

#### A. Nếu server dùng user **ubuntu** (AWS, DigitalOcean, etc.)

```bash
# SSH vào server
ssh ubuntu@YOUR_SERVER_IP

# Cài Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Thêm user ubuntu vào docker group
sudo usermod -aG docker ubuntu

# QUAN TRỌNG: Logout và login lại để áp dụng group
exit
ssh ubuntu@YOUR_SERVER_IP

# Kiểm tra Docker đã hoạt động (không cần sudo)
docker --version
docker compose version
docker ps

# Cho phép Docker chạy khi khởi động
sudo systemctl enable docker
sudo systemctl start docker
```

#### B. Nếu server dùng user **root**

```bash
# SSH vào server
ssh root@YOUR_SERVER_IP

# Cài Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Kiểm tra Docker đã cài
docker --version
docker compose version

# Cho phép Docker chạy khi khởi động
systemctl enable docker
systemctl start docker
```

**Lưu ý quan trọng cho Ubuntu user:**
- User phải có quyền `sudo`
- User phải trong `docker` group (không cần sudo để chạy docker)
- Phải logout/login lại sau khi thêm vào docker group

### Bước 2: Tạo GitHub Personal Access Token

1. Vào GitHub: Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Đặt tên: `Kamal Deploy`
4. Chọn quyền:
   - ✅ `write:packages`
   - ✅ `read:packages`
   - ✅ `delete:packages`
5. Click "Generate token" và **LÀ LƯU TOKEN**

### Bước 3: Cấu Hình Local

#### 3.1. Cập nhật `config/deploy.yml`

Thay các giá trị sau:

```yaml
# Thay YOUR_SERVER_IP bằng IP server thật
servers:
  web:
    - 123.45.67.89  # IP server của bạn

# Thay YOUR_GITHUB_USERNAME
image: username/note_forge
registry:
  username: username

# Nếu dùng user ubuntu (không phải root)
ssh:
  user: ubuntu  # Hoặc ec2-user cho AWS, admin cho Google Cloud
```

**Các user phổ biến theo platform:**
- AWS EC2: `ubuntu`, `ec2-user`, hoặc `admin`
- DigitalOcean: `root` hoặc custom user bạn tạo
- Google Cloud: `ubuntu` hoặc username của bạn
- Linode: `root` hoặc custom user
- Vultr: `root` hoặc custom user

#### 3.2. Tạo file `.kamal/secrets`

```bash
# Tạo thư mục
mkdir -p .kamal

# Copy template
cp .kamal/secrets.example .kamal/secrets

# Sửa file .kamal/secrets
nano .kamal/secrets
```

Điền thông tin vào `.kamal/secrets`:

```bash
# GitHub Personal Access Token (từ bước 2)
KAMAL_REGISTRY_PASSWORD="ghp_xxxxxxxxxxxxxxxxxxxx"

# Rails Master Key (từ config/master.key)
RAILS_MASTER_KEY="$(cat config/master.key)"

# MySQL Root Password (tự đặt, tối thiểu 16 ký tự)
MYSQL_ROOT_PASSWORD="your_strong_password_here_123456"

# Database Password (giống MYSQL_ROOT_PASSWORD)
DB_PASSWORD="your_strong_password_here_123456"
```

#### 3.3. Kiểm tra kết nối SSH

```bash
# Nếu dùng ubuntu user
ssh ubuntu@YOUR_SERVER_IP "echo 'SSH OK'"

# Hoặc nếu dùng root
ssh root@YOUR_SERVER_IP "echo 'SSH OK'"

# Test docker không cần sudo (quan trọng!)
ssh ubuntu@YOUR_SERVER_IP "docker ps"
# Nếu lỗi "permission denied" → chưa thêm vào docker group
```

### Bước 4: Verify Docker Setup Trên Server

**QUAN TRỌNG:** Phải verify Docker hoạt động đúng trước khi chạy Kamal!

#### 4.1. Kiểm tra Docker đã cài đúng

```bash
# SSH vào server
ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_SERVER_IP

# Check Docker version
docker --version
# Expected: Docker version 24.x.x hoặc cao hơn

# Check Docker Compose
docker compose version
# Expected: Docker Compose version v2.x.x

# Check Docker đang chạy
docker info
# Nếu lỗi "Cannot connect to the Docker daemon" → Docker chưa chạy

# Check user trong docker group
groups
# PHẢI thấy "docker" trong list
```

#### 4.2. Nếu Docker chưa được cài

```bash
# Cài Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Thêm user vào docker group
sudo usermod -aG docker $USER

# QUAN TRỌNG: Logout và login lại
exit

# Login lại
ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_SERVER_IP

# Verify lại
docker ps
# Phải chạy được không cần sudo
```

#### 4.3. Test Docker hoạt động

```bash
# Test pull và run một image nhỏ
docker run --rm hello-world

# Expected output: "Hello from Docker!"

# Test docker network
docker network ls
# Phải thấy bridge, host, none

# Check disk space (cần ít nhất 10GB free)
df -h
# Check dòng / hoặc /var
```

#### 4.4. Enable Docker khởi động cùng hệ thống

```bash
# Enable Docker service
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker

# Check status
sudo systemctl status docker
# Phải thấy: active (running)
```

#### 4.5. Test SSH từ local (không login vào server)

```bash
# Test từ máy local của bạn
ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_SERVER_IP "docker ps"
# Phải chạy được và hiện empty list

ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_SERVER_IP "docker info"
# Phải hiện thông tin Docker

ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_SERVER_IP "docker network ls"
# Phải hiện danh sách networks
```

#### 4.6. Checklist trước khi chạy Kamal

- [ ] ✅ Docker version >= 20.10
- [ ] ✅ Docker Compose version >= 2.0
- [ ] ✅ User trong docker group (chạy `groups` thấy "docker")
- [ ] ✅ `docker ps` chạy được không cần sudo
- [ ] ✅ `docker run --rm hello-world` thành công
- [ ] ✅ Disk space còn >= 10GB
- [ ] ✅ SSH từ local chạy `docker ps` được
- [ ] ✅ Firewall cho phép port 22, 80, 443

**Nếu tất cả checklist ✅ → Tiếp tục Bước 5**

### Bước 5: Setup Lần Đầu Với Kamal

#### 5.1. Build và Push Docker Image

```bash
# Từ máy local của bạn (trong project directory)

# Login vào GitHub Container Registry
echo "YOUR_GITHUB_TOKEN" | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# Build image (có thể mất 5-10 phút lần đầu)
docker build --no-cache -t ghcr.io/YOUR_USERNAME/learn-rails:latest .

# Push lên registry
docker push ghcr.io/YOUR_USERNAME/learn-rails:latest

# Hoặc dùng Kamal (khuyến nghị)
kamal build push
```

#### 5.2. Deploy Accessories (MySQL, Redis)

```bash
# Boot MySQL và Redis trước
kamal accessory boot all

# Wait 30 giây cho MySQL khởi động
sleep 30

# Check status
kamal accessory details all

# Check logs nếu cần
kamal accessory logs db
kamal accessory logs redis
```

#### 5.3. Deploy Application

```bash
# Deploy app lần đầu
kamal deploy

# Quá trình này sẽ:
# - Pull Docker image từ registry
# - Create containers (web, sidekiq)
# - Setup database (create, migrate)
# - Start services
```

#### 5.4. Hoặc Setup Tất Cả Một Lần

```bash
# Setup toàn bộ (accessories + app)
kamal setup

# Lệnh này sẽ chạy tất cả các bước trên tự động
```

**Lưu ý:** Lần đầu sẽ mất 10-15 phút vì phải build image và download dependencies.

### Bước 6: Kiểm Tra Deploy

```bash
# Xem status
kamal app details

# Xem logs
kamal app logs

# Xem logs của Sidekiq
kamal app logs -r job
```

## 🌐 TRUY CẬP ỨNG DỤNG

Sau khi deploy xong, truy cập:

```
http://YOUR_SERVER_IP
```

## 🔄 CÁC LỆNH THƯỜNG DÙNG

### Deploy Code Mới

```bash
# Deploy version mới
kamal deploy

# Deploy nhanh (không build lại assets)
kamal deploy --skip-assets
```

### Quản Lý Containers

```bash
# Xem trạng thái
kamal app details

# Restart app
kamal app restart

# Stop app
kamal app stop

# Start app
kamal app start
```

### Database

```bash
# Chạy migration
kamal app exec "bin/rails db:migrate"

# Vào Rails console
kamal console

# Vào database console
kamal dbc

# Seed data
kamal app exec "bin/rails db:seed"
```

### Logs

```bash
# Xem logs web
kamal app logs -f

# Xem logs Sidekiq
kamal app logs -r job -f

# Xem logs MySQL
kamal accessory logs db -f

# Xem logs Redis
kamal accessory logs redis -f
```

### Shell Access

```bash
# Vào shell của container
kamal app exec --interactive --reuse "bash"

# Hoặc dùng alias
kamal shell
```

## 🛠️ TROUBLESHOOTING

### Lỗi: "Cannot connect to server"

```bash
# Kiểm tra SSH với đúng user
ssh -v ubuntu@YOUR_SERVER_IP
# Hoặc
ssh -v root@YOUR_SERVER_IP

# Kiểm tra firewall
sudo ufw status
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

### Lỗi: "Permission denied" với Docker (Ubuntu user)

```bash
# SSH vào server
ssh ubuntu@YOUR_SERVER_IP

# Thêm user vào docker group
sudo usermod -aG docker ubuntu

# Logout và login lại
exit
ssh ubuntu@YOUR_SERVER_IP

# Test lại
docker ps  # Phải chạy được không cần sudo
```

### Lỗi: "Got permission denied while trying to connect to the Docker daemon socket"

Điều này xảy ra khi user chưa có quyền Docker. Fix:

```bash
# Trên server
ssh ubuntu@YOUR_SERVER_IP

# Check user có trong docker group chưa
groups
# Phải thấy "docker" trong list

# Nếu chưa có, thêm vào
sudo usermod -aG docker $USER

# Apply group ngay (không cần logout)
newgrp docker

# Hoặc logout/login
exit
ssh ubuntu@YOUR_SERVER_IP

# Verify
docker ps
```

### Lỗi: "Database connection failed"

```bash
# Restart MySQL accessory
kamal accessory restart db

# Xem logs MySQL
kamal accessory logs db

# Kiểm tra MySQL có chạy không
kamal accessory details db
```

### Lỗi: "Sidekiq not processing jobs"

```bash
# Xem logs Sidekiq
kamal app logs -r job

# Restart Sidekiq
kamal app restart -r job

# Kiểm tra Redis
kamal accessory details redis
```

### Lỗi: "Image push failed"

```bash
# Login lại vào registry
docker login ghcr.io -u YOUR_USERNAME

# Build lại image
kamal build push --verbose
```

### Reset Toàn Bộ (Cẩn thận!)

```bash
# Xóa tất cả containers
kamal app remove
kamal accessory remove db
kamal accessory remove redis

# Setup lại từ đầu
kamal setup
```

## 🔒 BẢO MẬT

### Enable SSL với Let's Encrypt

Uncomment trong `config/deploy.yml`:

```yaml
proxy:
  ssl: true
  host: yourdomain.com
```

Và trong `config/environments/production.rb`:

```ruby
config.assume_ssl = true
config.force_ssl = true
```

### Đổi MySQL Password

1. Update `.kamal/secrets`
2. Chạy:

```bash
kamal accessory restart db
kamal deploy
```

## 📊 MONITORING

### Xem tài nguyên

```bash
# SSH vào server
ssh root@YOUR_SERVER_IP

# Xem containers đang chạy
docker ps

# Xem resource usage
docker stats

# Xem disk usage
df -h
docker system df
```

### Cleanup

```bash
# Dọn dẹp images cũ
docker image prune -a

# Dọn dẹp volumes không dùng
docker volume prune
```

## 🎯 TIPS

1. **Backup Database trước khi deploy:**
   ```bash
   kamal app exec "bin/rails db:dump"
   ```

2. **Zero-downtime deployment:**
   Kamal tự động rolling restart, không downtime!

3. **Rollback nếu có lỗi:**
   ```bash
   kamal rollback VERSION
   ```

4. **Deploy từ nhánh khác:**
   ```bash
   kamal deploy --version=feature-branch
   ```

## 📞 HỖ TRỢ

- Kamal Documentation: https://kamal-deploy.org
- Rails Guides: https://guides.rubyonrails.org
- Docker Docs: https://docs.docker.com

---

✨ Chúc bạn deploy thành công!

