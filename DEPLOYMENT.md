# Deployment Guide - AI-Humanizer

## Quick Fix for "Not Found" Error

### The Problem
After deployment, you get a "404 Not Found" error when navigating to routes other than the root.

### The Solution
This is a Single Page Application (SPA) routing issue. All routes should serve `index.html` to let React handle routing.

---

## Deployment Platforms

### 1. Vercel (Recommended)

**Setup:**
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

**Configuration:** `vercel.json` handles routing automatically ✅

**Benefits:**
- Automatic HTTPS
- CDN included
- Environment variable management
- Automatic deployments on push

---

### 2. Netlify

**Setup:**
```bash
# Install Netlify CLI
npm i -g netlify-cli

# Deploy
netlify deploy --prod
```

**Configuration:** `netlify.toml` handles routing automatically ✅

**Benefits:**
- Free tier available
- Automatic builds
- Built-in DNS
- Form handling

---

### 3. Docker (Self-Hosted)

**Build and run:**
```bash
# Build image
docker build -t ai-humanizer:latest .

# Run container
docker run -p 3000:3000 \
  -e GEMINI_API_KEY=your_key \
  -e APP_URL=https://your-domain.com \
  ai-humanizer:latest
```

**Docker Compose:**
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      GEMINI_API_KEY: ${GEMINI_API_KEY}
      APP_URL: ${APP_URL}
      NODE_ENV: production
```

---

### 4. Traditional Node.js Server

**Setup on Linux/Ubuntu:**
```bash
# Clone and setup
git clone <your-repo>
cd AI-Humanizer
npm install
npm run build

# Using PM2 for process management
npm i -g pm2
pm2 start server.js --name "ai-humanizer"
pm2 save
pm2 startup
```

**Nginx Configuration:**
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

---

## Environment Variables

Set these in your deployment platform's environment configuration:

| Variable | Required | Example |
|----------|----------|---------|
| `GEMINI_API_KEY` | Yes | `sk-...` |
| `APP_URL` | Yes | `https://app.example.com` |
| `NODE_ENV` | No | `production` |
| `PORT` | No | `3000` |
| All `VITE_FIREBASE_*` | Yes | See .env.example |

---

## Build Process

```bash
# Development
npm run dev

# Build for production
npm run build
# Creates: dist/ (frontend) and server.js (backend)

# Start production server
npm run start
```

---

## Troubleshooting

### ❌ "Not Found" Error

**Cause:** Routes aren't being served index.html

**Fix:** Verify deployment config:
- ✅ Vercel: `vercel.json` exists
- ✅ Netlify: `netlify.toml` exists
- ✅ Custom: `server.ts` has SPA fallback route

### ❌ Environment Variables Missing

```bash
# Check production variables
echo "API Key: ${GEMINI_API_KEY}"
echo "App URL: ${APP_URL}"
```

### ❌ Build Fails

```bash
# Clean and rebuild
npm run clean
npm install
npm run build
```

### ❌ Static Files Not Serving

Ensure `dist/` folder contains compiled assets:
```bash
ls -la dist/
# Should show: index.html, assets/, etc.
```

---

## Health Checks

All deployments should respond to:
```bash
curl https://your-app.com/api/health
# Expected: {"status":"ok","timestamp":"..."}
```

---

## Performance Optimization

### Caching Headers (Already Configured)
- `index.html` - No cache (0s)
- `/assets/*` - Long cache (1 year)

### CDN Configuration
- Enable gzip compression
- Use modern image formats
- Minimize CSS/JS bundles
- Enable brotli compression (optional)

---

## Monitoring

### Logs
- **Vercel:** Dashboard → Deployments → Logs
- **Netlify:** Dashboard → Deploys → Deploy logs
- **Docker:** `docker logs container_id`
- **PM2:** `pm2 logs ai-humanizer`

### Errors
Check for:
- 404 Not Found → Routing misconfiguration
- 500 Internal Server → API error (check logs)
- CORS errors → Missing `APP_URL` header

---

## Security Checklist

- ✅ HTTPS enabled
- ✅ Environment variables not in code
- ✅ API keys secured
- ✅ CORS headers configured
- ✅ Rate limiting enabled (optional)
- ✅ Input validation on backend

---

## Support

For deployment issues:
1. Check logs in deployment platform
2. Verify environment variables are set
3. Ensure build completed successfully
4. Test `/api/health` endpoint

---

**Last Updated:** 2024  
**Version:** 1.5.1
