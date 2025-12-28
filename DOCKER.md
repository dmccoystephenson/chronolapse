# Docker Setup for Chronolapse

This guide provides detailed instructions for running Chronolapse using Docker.

## Prerequisites

- Docker Engine 20.10 or higher
- Docker Compose 1.29 or higher (or Docker Compose v2)
- X11 server (for GUI display)
  - Linux: Usually pre-installed
  - macOS: Install XQuartz
  - Windows: Install VcXsrv or Xming

**Note:** The `docker-compose.yml` file does not include a `version:` field as it is [deprecated in Docker Compose v2](https://docs.docker.com/compose/compose-file/04-version-and-name/) and ignored by recent versions.

## Quick Start

### Linux

1. Allow Docker to connect to X11:
```bash
xhost +local:docker
```

2. Start Chronolapse:
```bash
docker compose up
```

3. To run in background:
```bash
docker compose up -d
```

4. View logs:
```bash
docker compose logs -f
```

5. Stop Chronolapse:
```bash
docker compose down
```

### macOS

1. Install and start XQuartz:
```bash
brew install --cask xquartz
```

2. Configure XQuartz:
   - Open XQuartz
   - Go to Preferences > Security
   - Enable "Allow connections from network clients"
   - Restart XQuartz

3. Allow X11 forwarding:
```bash
xhost + 127.0.0.1
```

4. Set DISPLAY variable:
```bash
export DISPLAY=:0
```

5. Start Chronolapse:
```bash
docker compose up
```

### Windows

1. Install VcXsrv or Xming

2. Start X server with:
   - Display number: 0
   - "Disable access control" enabled

3. Set DISPLAY variable in PowerShell:
```powershell
$env:DISPLAY="host.docker.internal:0"
```

4. Update docker-compose.yml:
```yaml
environment:
  - DISPLAY=host.docker.internal:0
```

5. Start Chronolapse:
```cmd
docker compose up
```

## Building the Image

### Build from Dockerfile

```bash
docker build -t chronolapse:latest .
```

### Build with Docker Compose

```bash
docker compose build
```

### Build with custom tag

```bash
docker build -t chronolapse:custom-tag .
```

## Running Manually

### Basic Run

```bash
docker run -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  chronolapse:latest
```

### With Webcam Access

```bash
docker run -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  --device /dev/video0:/dev/video0 \
  chronolapse:latest
```

### With Data Persistence

```bash
docker run -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v $(pwd)/screenshots:/app/screenshots \
  -v $(pwd)/webcam:/app/webcam \
  -v $(pwd)/videos:/app/videos \
  -v $(pwd)/chronolapse.config:/app/chronolapse.config \
  chronolapse:latest
```

### With Custom Command Line Options

```bash
docker run -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  chronolapse:latest \
  python chronolapse.py -a -v
```

## Configuration

### Volume Mounts

The default `docker-compose.yml` mounts the following directories:

- `./screenshots` - Screenshot captures
- `./webcam` - Webcam captures
- `./videos` - Rendered videos
- `./chronolapse.config` - Configuration file

### Environment Variables

- `DISPLAY` - X11 display server (default: `:0`)
- `PYTHONUNBUFFERED` - Python output buffering (default: `1`)

### Device Access

To enable webcam access, uncomment or add in `docker-compose.yml`:

```yaml
devices:
  - /dev/video0:/dev/video0
```

For multiple webcams:

```yaml
devices:
  - /dev/video0:/dev/video0
  - /dev/video1:/dev/video1
```

## Customizing docker-compose.yml

### Change Display Number

```yaml
environment:
  - DISPLAY=:1  # Use display :1 instead of :0
```

### Add Resource Limits

```yaml
deploy:
  resources:
    limits:
      cpus: '2'
      memory: 2G
    reservations:
      cpus: '1'
      memory: 1G
```

### Run as Specific User

```yaml
user: "1000:1000"  # Replace with your UID:GID
```

### Change Network Mode

```yaml
network_mode: bridge  # Default Docker network instead of host
```

## Troubleshooting

### GUI Not Displaying

**Issue:** Application starts but no window appears

**Solutions:**

1. Check X11 permissions:
```bash
xhost +local:docker
```

2. Verify DISPLAY variable:
```bash
echo $DISPLAY
```

3. Test X11 connection:
```bash
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  alpine sh -c "apk add --no-cache xeyes && xeyes"
```

### Webcam Not Found

**Issue:** Cannot access webcam in container

**Solutions:**

1. Check device exists:
```bash
ls -l /dev/video*
```

2. Verify permissions:
```bash
sudo chmod 666 /dev/video0
```

3. Add user to video group:
```bash
sudo usermod -aG video $USER
```

4. Check device is not in use:
```bash
lsof /dev/video0
```

### Permission Denied on Volumes

**Issue:** Cannot write to mounted directories

**Solutions:**

1. Check directory permissions:
```bash
chmod 777 screenshots webcam videos
```

2. Run container with user ID:
```yaml
user: "${UID}:${GID}"
```

3. Set ownership:
```bash
sudo chown -R $USER:$USER screenshots webcam videos
```

### Container Keeps Restarting

**Issue:** Container exits immediately

**Solutions:**

1. Check logs:
```bash
docker compose logs
```

2. Run in foreground:
```bash
docker compose up
```

3. Override entrypoint:
```bash
docker run -it --rm chronolapse:latest /bin/bash
```

### Cannot Connect to Docker Daemon

**Issue:** Permission denied when running docker

**Solutions:**

1. Add user to docker group:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

2. Use sudo:
```bash
sudo docker compose up
```

## Advanced Usage

### Multi-stage Build

To reduce image size, the Dockerfile uses multi-stage builds. Customize for your needs:

```dockerfile
FROM python:3.9-slim AS builder
# Build dependencies
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

FROM python:3.9-slim
# Copy only wheels
COPY --from=builder /wheels /wheels
RUN pip install --no-cache /wheels/*
```

### Using with docker-compose profiles

Add profiles to run different configurations:

```yaml
services:
  chronolapse-dev:
    profiles: ["dev"]
    # Development configuration
  
  chronolapse-prod:
    profiles: ["prod"]
    # Production configuration
```

Run with profile:
```bash
docker compose --profile dev up
```

### Health Checks

Add health check to docker-compose.yml:

```yaml
healthcheck:
  test: ["CMD", "pgrep", "python"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### Automated Restart

Configure restart policy:

```yaml
restart: unless-stopped  # Always restart unless manually stopped
# or
restart: on-failure      # Restart only on failure
# or
restart: always          # Always restart
```

## Best Practices

1. **Use Docker Compose** for easier management
2. **Mount volumes** for data persistence
3. **Limit resources** to prevent system overload
4. **Use specific tags** instead of `latest` for production
5. **Regular updates** to base images for security patches
6. **Environment files** for sensitive configuration:

```bash
# Create .env file
DISPLAY=:0
UID=1000
GID=1000

# Reference in docker-compose.yml
environment:
  - DISPLAY=${DISPLAY}
user: "${UID}:${GID}"
```

## Security Considerations

1. **Avoid privileged mode** when possible
2. **Use specific device access** instead of `--privileged`
3. **Run as non-root user** when possible
4. **Keep base images updated**
5. **Scan images for vulnerabilities**:

```bash
docker scan chronolapse:latest
```

## Cleanup

### Remove containers and volumes

```bash
docker compose down -v
```

### Remove images

```bash
docker rmi chronolapse:latest
```

### Clean up Docker system

```bash
docker system prune -a
```

## Getting Help

- Check application logs: `docker compose logs -f`
- Run with verbose output: `docker compose run chronolapse python chronolapse.py -v`
- Debug mode: `docker compose run chronolapse python chronolapse.py -d`
- [GitHub Issues](https://github.com/dmccoystephenson/chronolapse/issues)
