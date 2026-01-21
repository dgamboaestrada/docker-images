# Keybase Git Docker Image

Docker image with Keybase CLI and Git for secure repository access. This image allows you to work with Git repositories stored in Keybase's encrypted filesystem.

## Features

- **Keybase CLI**: Full Keybase command-line interface installed and configured
- **Git**: Latest Git for repository operations
- **Secure**: Runs as non-root user for enhanced security
- **Manual Keybase Initialization**: Keybase login script available for one-time setup
- **Persistent Sessions**: Keybase authentication data can be persisted via volume mounts

## Build

To build the image, run:

```bash
docker build -t keybase-git .
```

Or with a specific tag:

```bash
docker build -t keybase-git:ubuntu-22.04 .
```

## Usage

### Initializing Keybase (First Time Only)

Keybase initialization is **not automatic**. You need to run the initialization script manually the first time, or whenever you need to re-authenticate.

**Important**: Use persistent volumes for Keybase data so you don't need to re-authenticate on every container start.

```bash
# Run the Keybase initialization script
docker run -it --rm \
  -e KEYBASE_USERNAME=your_username \
  -e KEYBASE_PAPERKEY=your_paper_key \
  -v $(pwd)/keybase-config:/home/gituser/.config/keybase \
  -v $(pwd)/keybase-cache:/home/gituser/.cache/keybase \
  keybase-git \
  /app/keybase-init.sh
```

After the first initialization, if you use persistent volumes, Keybase will remain authenticated and you won't need to run the script again.

### Using Keybase After Initialization

Once Keybase is initialized and you're using persistent volumes, you can use the container normally:

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -v $(pwd)/keybase-config:/home/gituser/.config/keybase \
  -v $(pwd)/keybase-cache:/home/gituser/.cache/keybase \
  keybase-git
```

**Note**: You only need to run `/app/keybase-init.sh` once (or when re-authenticating). After that, Keybase will work automatically as long as the volumes are mounted.

### Complete Example: First Time Setup

1. **Initialize Keybase** (first time only):
```bash
docker run -it --rm \
  -e KEYBASE_USERNAME=your_username \
  -e KEYBASE_PAPERKEY=your_paper_key \
  -v $(pwd)/keybase-config:/home/gituser/.config/keybase \
  -v $(pwd)/keybase-cache:/home/gituser/.cache/keybase \
  keybase-git \
  /app/keybase-init.sh
```

2. **Use the container** (after initialization):
```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -v $(pwd)/keybase-config:/home/gituser/.config/keybase \
  -v $(pwd)/keybase-cache:/home/gituser/.cache/keybase \
  keybase-git
```

### Using Keybase Repositories

Once Keybase is initialized, you can access Keybase repositories:

```bash
# Access private repositories
cd /keybase/private/your_username/your_repo

# Access public repositories
cd /keybase/public/your_username/your_repo
```

### Custom Git Configuration

Override Git user configuration with environment variables:

```bash
docker run -it --rm \
  -e KEYBASE_USERNAME=your_username \
  -e KEYBASE_PAPERKEY=your_paper_key \
  -e GIT_USER_NAME="Your Name" \
  -e GIT_USER_EMAIL="your.email@example.com" \
  keybase-git
```

## Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `KEYBASE_USERNAME` | Your Keybase username (for keybase-init.sh) | Yes (for Keybase init) | - |
| `KEYBASE_PAPERKEY` | Your Keybase paper key (for keybase-init.sh) | Yes (for Keybase init) | - |
| `GIT_USER_NAME` | Git user name | No | "Keybase Git User" |
| `GIT_USER_EMAIL` | Git user email | No | "keybase@localhost" |
| `TZ` | Timezone | No | UTC |

## Getting Your Keybase Paper Key

1. Open the Keybase app
2. Go to **Settings** → **Account** → **Paper Key**
3. Generate or copy your paper key
4. Keep it secure - it's used for authentication

## Volume Mounts

### Keybase Configuration (Recommended)

- `/home/gituser/.config/keybase`: Keybase configuration data
- `/home/gituser/.cache/keybase`: Keybase cache data

Mounting these volumes allows you to persist Keybase authentication across container restarts, avoiding the need to re-authenticate each time.

### Workspace

- `/workspace`: Working directory for your repositories

## Examples

### Clone a Keybase Repository

```bash
# Make sure Keybase is initialized first (see "Initializing Keybase" section above)
docker run -it --rm \
  -v $(pwd):/workspace \
  -v $(pwd)/keybase-config:/home/gituser/.config/keybase \
  -v $(pwd)/keybase-cache:/home/gituser/.cache/keybase \
  keybase-git \
  bash -c "cd /workspace && git clone /keybase/private/your_username/your_repo"
```

### Run Git Operations

```bash
# Make sure Keybase is initialized first (see "Initializing Keybase" section above)
docker run -it --rm \
  -v $(pwd):/workspace \
  -v $(pwd)/keybase-config:/home/gituser/.config/keybase \
  -v $(pwd)/keybase-cache:/home/gituser/.cache/keybase \
  keybase-git \
  bash -c "cd /workspace/your_repo && git status && git pull"
```

## Troubleshooting

### Keybase Login Fails

- Verify your `KEYBASE_USERNAME` and `KEYBASE_PAPERKEY` are correct when running `/app/keybase-init.sh`
- Ensure the paper key is valid and not expired
- Check that Keybase service is running: `keybase service status`
- Make sure you're using persistent volumes for Keybase data
- If login fails, try running the initialization script again

### Keybase Service Not Running

- The Keybase service is started by the `/app/keybase-init.sh` script
- Check service status: `keybase service status`
- Restart service: `keybase service restart`
- If the service isn't running, run `/app/keybase-init.sh` again

### Permission Denied with Keybase Repositories

- Ensure Keybase is properly initialized and logged in
- Verify you have access to the Keybase repositories
- Check that volumes are mounted with correct permissions

### Git Configuration Issues

- Override Git user configuration with `GIT_USER_NAME` and `GIT_USER_EMAIL` environment variables
- Check current Git config: `git config --list`

## Security Notes

- **Paper Key Security**: Never commit your paper key to version control
- **Volume Permissions**: Ensure Keybase configuration volumes have appropriate permissions
- **Non-Root User**: The container runs as a non-root user (`gituser`) for enhanced security
- **Environment Variables**: Use Docker secrets or environment files for sensitive data in production

## Base Image

- **Ubuntu**: 22.04 LTS

## License

This Docker image is provided as-is for use with Keybase and Git operations.

