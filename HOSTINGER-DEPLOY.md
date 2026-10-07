# 🚀 Hostinger hPanel Deployment Guide - AI-HUMANIZER

## Overview

This guide walks you through deploying AI-HUMANIZER on Hostinger's hPanel using their Node.js application hosting.

---

## Prerequisites

- ✅ Hostinger account with hPanel access
- ✅ Domain purchased and pointed to Hostinger
- ✅ Node.js 18+ support enabled
- ✅ SSH access enabled
- ✅ Google Gemini API key

---

## Step 1: Access Hostinger hPanel

1. Go to https://hpanel.hostinger.com/
2. Log in with your credentials
3. Select your domain
4. Navigate to **Hosting → Node.js Applications** (or similar)

---

## Step 2: Create Node.js Application

### Via hPanel UI (If Available)

1. Click **Create Application** or **Add Application**
2. Select **Node.js** runtime
3. Choose **Node.js 18.x** or higher
4. Set application name: `ai-humanizer`
5. Set startup file: `server.js`
6. Set port: `3000` (internal)
7. Domain: Select your domain
8. Click **Create**

### Via SSH (Recommended)

If UI option isn't available, use SSH:

```bash
# 1. SSH into your Hostinger server
ssh -l username your-server-ip
# Or use SSH key if configured
ssh -i /path/to/key.pem username@your-server-ip

# 2. Navigate to your public_html or application directory
cd ~/public_html
# Or: cd ~/domains/your-domain.com (depending on Hostinger setup)

# 3. Clone the repository
git clone https://github.com/kenboi656-crypto/AI-Humanizer.git .

# 4. Install dependencies
npm install

# 5. Build the application
npm run build
```

---

## Step 3: Configure Environment Variables

### In hPanel UI

1. Go to **Application Settings** or **Environment Variables**
2. Add the following variables:

| Variable | Value | Required |
|----------|-------|----------|
| `NODE_ENV` | `production` | ✅ Yes |
| `PORT` | `3000` | ✅ Yes |
| `GEMINI_API_KEY` | Your API key from Google AI Studio | ✅ Yes |
| `APP_URL` | `https://your-domain.com` | ✅ Yes |
| `VITE_FIREBASE_API_KEY` | Firebase key | ⚠️ Optional |
| `VITE_FIREBASE_PROJECT_ID` | Firebase project ID | ⚠️ Optional |

### Via SSH

Create `.env` file:

```bash
cat > .env << 'EOF'
NODE_ENV=production
PORT=3000
GEMINI_API_KEY=sk-your-actual-key-here
APP_URL=https://your-domain.com
VITE_FIREBASE_API_KEY=AIzaSyBaVlAtDBTa5gf3VPXxyvcqT9Vwal8uJ3I
VITE_FIREBASE_AUTH_DOMAIN=gen-lang-client-0300116598.firebaseapp.com
VITE_FIREBASE_PROJECT_ID=gen-lang-client-0300116598
VITE_FIREBASE_STORAGE_BUCKET=gen-lang-client-0300116598.firebasestorage.app
VITE_FIREBASE_MESSAGING_SENDER_ID=69969058575
VITE_FIREBASE_APP_ID=1:69969058575:web:36da1907a987528ca9fc7a
VITE_FIREBASE_DATABASE_ID=ai-studio-remixhumanizetex-f2de70f2-57d7-4b27-8646-1ad83ceced3b
EOF
```

⚠️ **IMPORTANT**: Never commit `.env` file to git!

---

## Step 4: Deploy Application

### Option A: Automatic Deployment (Git)

1. In hPanel, enable **Git Deployment**
2. Connect GitHub account
3. Select repository: `kenboi656-crypto/AI-Humanizer`
4. Select branch: `main`
5. Set build command: `npm install && npm run build`
6. Set start command: `node server.js`
7. Enable **Auto Deploy on Push**

### Option B: Manual Deployment (SSH)

```bash
# Navigate to app directory
cd ~/public_html

# Pull latest code
git pull origin main

# Install/update dependencies
npm install

# Build
npm run build

# Restart application
# (Hostinger usually auto-restarts)
# Or manually restart via hPanel
```

---

## Step 5: Configure Reverse Proxy

Hostinger automatically sets up reverse proxy, but you can verify/configure:

### Check `.htaccess`

Verify `.htaccess` is in your public_html root:

```bash
cat .htaccess
```

It should contain proxy rules (included in this repo).

### If Using cPanel (Alternative)

1. Go to **cPanel → Apache Handlers**
2. Configure proxy to `http://localhost:3000`

---

## Step 6: SSL Certificate

✅ Hostinger automatically provides SSL via Let's Encrypt

1. In hPanel, go to **SSL/TLS**
2. Verify certificate is installed
3. Enable **Force HTTPS** (recommended)

---

## Step 7: Verification

### Check Application Status

1. In hPanel, go to **Applications**
2. Look for `ai-humanizer` - status should be **Running** (green)
3. View logs: Click on app → **View Logs**

### Test Endpoints

```bash
# Health check
curl https://your-domain.com/api/health

# Expected response:
# {"status":"healthy","timestamp":"...","version":"1.5.1","gemini":true}

# Test humanization
curl -X POST https://your-domain.com/api/humanize \
  -H "Content-Type: application/json" \
  -d '{"text": "This is AI text that needs humanization."}'
```

---

## Troubleshooting

### ❌ Application Not Starting

**Check logs:**
```bash
# SSH into server
ssh username@your-server

# Check Node.js logs
cat ~/logs/ai-humanizer.log
# Or
tail -f ~/logs/ai-humanizer.log
```

**Common issues:**
- Missing `GEMINI_API_KEY` → Set in hPanel environment variables
- Port 3000 in use → Change PORT in .env
- Dependencies not installed → Run `npm install`

### ❌ "Not Found" Error (404)

**Cause:** Routing issue  
**Fix:** Verify `.htaccess` is configured correctly

```bash
cat .htaccess | grep ProxyPassReverse
```

### ❌ CORS Errors

**Cause:** Origin mismatch  
**Fix:** Ensure `APP_URL` matches your domain:

```bash
# In .env
APP_URL=https://your-domain.com  # Must match exactly
```

### ❌ SSL Certificate Issues

**Solution:**
1. In hPanel, click **Renew SSL**
2. Wait 5-10 minutes
3. Clear browser cache and try again

---

## Performance Optimization

### Enable Caching

`.htaccess` already includes cache headers for assets.

Verify:
```bash
curl -I https://your-domain.com/assets/main.js
# Should show: Cache-Control: max-age=31536000
```

### Monitor Performance

1. In hPanel, go to **Performance Monitoring**
2. Check CPU, Memory, Bandwidth usage
3. Upgrade if needed

### Database/API Optimization

- Cache API responses
- Use CDN for static files
- Implement rate limiting (already in code)

---

## Maintenance

### Update Application

```bash
# SSH into server
cd ~/public_html

# Pull latest
git pull origin main

# Reinstall/update deps
npm install

# Rebuild
npm run build

# Restart (Hostinger auto-restarts after deploy)
```

### View Logs

```bash
# Error log
cat ~/logs/error.log

# Application log
cat ~/logs/ai-humanizer.log

# Real-time monitoring
tail -f ~/logs/ai-humanizer.log
```

### Restart Application

1. In hPanel → **Applications**
2. Find `ai-humanizer`
3. Click **Restart** button

---

## Security

✅ Already configured in code:
- HTTPS forced
- CORS headers set
- Environment variables protected
- Security headers included
- Input validation enabled

### Additional Steps

1. Change default Node.js user
2. Enable firewall rules
3. Set up regular backups
4. Monitor for suspicious activity

---

## Support Resources

- Hostinger hPanel Documentation: https://support.hostinger.com/
- Node.js Guide: https://support.hostinger.com/articles/how-to-install-nodejs
- Troubleshooting: https://support.hostinger.com/categories/hosting

---

## Quick Reference

**SSH Access:**
```bash
ssh username@your-server-ip
cd ~/public_html
```

**Check Status:**
```bash
node -v
npm -v
ls -la
cat .env  # View configuration
```

**Restart App:**
1. Via hPanel: Applications → Restart
2. Or SSH: Kill process and Hostinger auto-restarts

**View Logs:**
In hPanel → Application Logs

---

## Deployment Checklist

- [ ] Domain pointed to Hostinger
- [ ] SSH access enabled
- [ ] Node.js 18+ installed
- [ ] Repository cloned
- [ ] Dependencies installed (`npm install`)
- [ ] `.env` file created with GEMINI_API_KEY
- [ ] Application built (`npm run build`)
- [ ] Port 3000 configured
- [ ] SSL certificate active
- [ ] Reverse proxy working
- [ ] Health check passing (`/api/health`)
- [ ] Application responding on domain
- [ ] All features tested

---

**Version:** 1.5.1  
**Platform:** Hostinger hPanel  
**Status:** ✅ Production Ready  
**Last Updated:** October 2026