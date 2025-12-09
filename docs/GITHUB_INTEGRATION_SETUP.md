# GitHub Integration Setup Guide

## 🚀 Quick Start: Enable GitHub PR Auto-Analysis

**Time to setup:** 5 minutes  
**Plan required:** PROFESSIONAL (€99/month) or ENTERPRISE

---

## 📋 Prerequisites

1. **GitHub repository** with admin access
2. **x0tta6bl4 PROFESSIONAL subscription** ([upgrade here](https://x0tta6bl4.dev/pricing))
3. **Server** to host webhook endpoint (or use our hosted service)

---

## 🔧 Setup Steps

### Step 1: Create GitHub App

1. Go to **GitHub Settings** → **Developer settings** → **GitHub Apps**
2. Click **"New GitHub App"**
3. Fill in the details:

```
App name: x0tta6bl4-pr-analyzer
Homepage URL: https://x0tta6bl4.dev
Webhook URL: https://your-server.com/webhook/github
Webhook secret: [generate random string]
```

4. **Permissions** (Repository permissions):
   - ✅ **Contents:** Read-only
   - ✅ **Pull requests:** Read & write
   - ✅ **Metadata:** Read-only

5. **Subscribe to events:**
   - ✅ Pull request (opened, synchronize, reopened)

6. Click **"Create GitHub App"**

7. **Generate private key:**
   - Scroll down → Click **"Generate a private key"**
   - Save the `.pem` file securely

8. **Get App ID and Installation ID:**
   - Note your **App ID** (shown on app page)
   - Install app on your repository
   - Note **Installation ID** from URL

### Step 2: Deploy Webhook Server

#### Option A: Use Our Hosted Service (Recommended)

1. Go to **[x0tta6bl4 Dashboard](https://dashboard.x0tta6bl4.dev)**
2. Navigate to **Integrations** → **GitHub**
3. Click **"Connect GitHub App"**
4. Enter your **GitHub App ID** and upload **private key**
5. Done! ✅

#### Option B: Self-Hosted (Advanced)

**Prerequisites:**
- Python 3.9+
- FastAPI, uvicorn, httpx

**Installation:**

```bash
# Clone repository
git clone https://github.com/x0tta6bl4/x0tta6bl4_paradox_zone.git
cd x0tta6bl4_paradox_zone

# Install dependencies
pip install -r requirements-webhook.txt

# Set environment variables
export GITHUB_WEBHOOK_SECRET="your-webhook-secret"
export GITHUB_TOKEN="your-github-token"

# Run server
python webhook_server.py
```

**Docker deployment:**

```bash
# Build image
docker build -f Dockerfile.webhook -t x0tta6bl4-webhooks .

# Run container
docker run -d \
  -p 8000:8000 \
  -e GITHUB_WEBHOOK_SECRET="your-secret" \
  -e GITHUB_TOKEN="your-token" \
  --name x0tta6bl4-webhooks \
  x0tta6bl4-webhooks
```

**Production deployment (with nginx):**

```nginx
# /etc/nginx/sites-available/x0tta6bl4-webhooks

upstream webhook_backend {
    server 127.0.0.1:8000;
}

server {
    listen 443 ssl http2;
    server_name webhooks.x0tta6bl4.dev;

    ssl_certificate /etc/letsencrypt/live/webhooks.x0tta6bl4.dev/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/webhooks.x0tta6bl4.dev/privkey.pem;

    location /webhook/github {
        proxy_pass http://webhook_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /health {
        proxy_pass http://webhook_backend;
    }
}
```

### Step 3: Test Integration

1. **Create a test PR** in your repository
2. **Check webhook delivery:**
   - Go to GitHub App settings
   - Click **"Advanced"** → **"Recent Deliveries"**
   - Verify response code is `200`

3. **Check PR comment:**
   - Open your test PR
   - You should see a comment from x0tta6bl4 with analysis results

**Example comment:**

```markdown
## 🔍 x0tta6bl4 Bug Analysis

Analyzed 3 files and found 5 potential issues:

🔴 Severity 5: 2 issue(s)
🟡 Severity 3: 3 issue(s)

### 📋 Details:

#### 📄 `src/app.py` (3 issue(s))

🔴 **Line 45:** Potential SQL injection vulnerability
...existing code...

---
*Powered by x0tta6bl4 - Catch bugs before production* 🚀
```

---

## 🎯 Features

### Automatic PR Analysis

When a PR is opened or updated, x0tta6bl4 automatically:

1. ✅ Fetches all changed files
2. ✅ Runs comprehensive bug detection
3. ✅ Posts detailed analysis as PR comment
4. ✅ Highlights severity levels (🔴 High, 🟡 Medium, 🟢 Low)

### Supported Languages

- Python (`.py`)
- JavaScript/TypeScript (`.js`, `.ts`, `.jsx`, `.tsx`)
- Java (`.java`)
- Go (`.go`)
- Rust (`.rs`)
- PHP (`.php`)

### Analysis Scope

**FREE tier:**
- ❌ GitHub integration not available

**STARTER tier (€29/month):**
- ❌ GitHub integration not available

**PROFESSIONAL tier (€99/month):**
- ✅ GitHub PR auto-analysis
- ✅ Up to 50,000 analyses/month
- ✅ 8 security detectors
- ✅ Priority support

**ENTERPRISE tier (€499/month):**
- ✅ Unlimited GitHub PR analysis
- ✅ Custom detectors
- ✅ On-premise deployment
- ✅ Dedicated support & SLA

---

## 🔒 Security

### Webhook Signature Verification

All webhooks are verified using **HMAC-SHA256** signatures:

```python
# Automatic verification in webhook_server.py
signature = request.headers.get('X-Hub-Signature-256')
expected = hmac.new(secret, body, hashlib.sha256).hexdigest()

if signature != f"sha256={expected}":
    raise HTTPException(401, "Invalid signature")
```

### Best Practices

1. **Keep webhook secret secure** - Never commit to git
2. **Use HTTPS only** - Encrypt webhook payloads in transit
3. **Rotate tokens regularly** - GitHub tokens expire
4. **Monitor webhook logs** - Track suspicious activity
5. **Rate limit** - Prevent abuse (60 req/min default)

---

## 📊 Monitoring & Logs

### Check Webhook Status

```bash
# Health check
curl https://your-server.com/health

# Response:
{
  "status": "healthy",
  "service": "x0tta6bl4-webhooks"
}
```

### View Logs

```bash
# Docker logs
docker logs -f x0tta6bl4-webhooks

# System logs (systemd)
journalctl -u x0tta6bl4-webhooks -f
```

### Metrics (Prometheus)

Webhook server exposes metrics at `/metrics`:

```
# HELP webhook_requests_total Total webhook requests
# TYPE webhook_requests_total counter
webhook_requests_total{status="success"} 1234

# HELP webhook_analysis_duration_seconds Webhook analysis duration
# TYPE webhook_analysis_duration_seconds histogram
webhook_analysis_duration_seconds_bucket{le="1.0"} 890
webhook_analysis_duration_seconds_bucket{le="5.0"} 1200
```

---

## 🐛 Troubleshooting

### Issue: "Invalid signature" error

**Cause:** Webhook secret mismatch

**Fix:**
1. Verify `GITHUB_WEBHOOK_SECRET` environment variable matches GitHub App secret
2. Check for trailing spaces in secret string
3. Regenerate webhook secret and update both sides

### Issue: PR comment not posted

**Cause:** Missing GitHub token permissions

**Fix:**
1. Verify GitHub token has **"repo"** scope
2. Check GitHub App permissions: **Pull requests: Read & write**
3. Reinstall GitHub App on repository

### Issue: "Rate limit exceeded"

**Cause:** Too many requests from same IP

**Fix:**
1. Increase rate limit in `webhook_server.py` (default 60/min)
2. Use load balancer with multiple IPs
3. Contact support for enterprise rate limits

### Issue: Analysis takes too long

**Cause:** Large PR with many files

**Fix:**
1. Files >100KB are automatically skipped
2. Only first 1000 lines of diff are analyzed
3. Consider breaking PR into smaller chunks

---

## 💡 Tips & Best Practices

### Optimize PR Analysis Speed

1. **Enable caching:**
   ```python
   # In webhook_server.py
   ENABLE_CACHE = True
   CACHE_TTL = 3600  # 1 hour
   ```

2. **Parallel analysis:**
   ```python
   # Already enabled by default
   MAX_WORKERS = 4  # Adjust based on CPU
   ```

3. **Skip unnecessary files:**
   ```yaml
   # .x0tta6bl4.yaml
   exclude:
     - tests/
     - docs/
     - vendor/
   ```

### Custom Analysis Rules

**ENTERPRISE tier only:**

```python
# custom_detectors.py
from src.detectors import BaseDetector

class CustomSecurityDetector(BaseDetector):
    def detect(self, code: str):
        # Your custom logic
        pass
```

### Integration with CI/CD

**GitHub Actions example:**

```yaml
# .github/workflows/pr-check.yml
name: x0tta6bl4 PR Check

on: [pull_request]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Wait for x0tta6bl4 analysis
        run: |
          # Webhook runs automatically
          echo "Analysis posted to PR comments"
```

---

## 📞 Support

- 📧 **Email:** support@x0tta6bl4.dev
- 💬 **Slack:** [Join community](https://x0tta6bl4.slack.com)
- 📚 **Docs:** [docs.x0tta6bl4.dev](https://docs.x0tta6bl4.dev)
- 🐛 **Issues:** [GitHub Issues](https://github.com/x0tta6bl4/x0tta6bl4/issues)

**Response time:**
- FREE: Community support (24-48h)
- STARTER: Email support (12-24h)
- PROFESSIONAL: Priority support (2-4h)
- ENTERPRISE: Dedicated support (30min)

---

## 🎉 Next Steps

1. ✅ **Complete setup** - Follow steps above
2. 📝 **Test with sample PR** - Verify analysis works
3. 🔒 **Enable security detectors** - Upgrade to PROFESSIONAL
4. 📊 **Monitor metrics** - Track analysis performance
5. 🚀 **Integrate with CI/CD** - Automate your workflow

**Ready to catch bugs before production?** [Start free trial](https://x0tta6bl4.dev/trial) 🚀
