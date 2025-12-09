# 🚀 GitHub App Quick Setup Guide

**Time to complete:** 10 minutes  
**Prerequisites:** GitHub account with admin access to a repository

---

## Step 1: Create GitHub App (5 minutes)

### 1.1 Navigate to GitHub Apps Settings

1. Go to your GitHub profile → **Settings**
2. Scroll down to **Developer settings** (left sidebar)
3. Click **GitHub Apps** → **New GitHub App**

### 1.2 Fill Basic Information

```
App name: x0tta6bl4-[your-username]
Homepage URL: https://x0tta6bl4.dev
Description: Automated bug detection for pull requests
```

### 1.3 Configure Webhook

```
Webhook URL: https://your-server.com/webhook/github
Webhook secret: [generate strong random string]
```

**Generate webhook secret:**
```bash
python3 -c "import secrets; print(secrets.token_hex(32))"
```

Copy this secret - you'll need it later!

### 1.4 Set Permissions

**Repository permissions:**
- ✅ **Contents:** Read-only
- ✅ **Pull requests:** Read & write
- ✅ **Metadata:** Read-only

**Subscribe to events:**
- ✅ Pull request

### 1.5 Create the App

Click **Create GitHub App** button at the bottom.

---

## Step 2: Generate Private Key (2 minutes)

### 2.1 Download Private Key

1. After creating the app, scroll down to **Private keys**
2. Click **Generate a private key**
3. Save the `.pem` file securely (you'll need this!)

### 2.2 Note Your App ID

On the app settings page, find:
- **App ID** (top of page, e.g., `123456`)
- Copy this number

---

## Step 3: Install App on Repository (1 minute)

### 3.1 Install App

1. On your GitHub App settings page, click **Install App** (left sidebar)
2. Select the repositories you want to analyze
3. Click **Install**

### 3.2 Get Installation ID

After installation, look at the URL:
```
https://github.com/settings/installations/12345678
                                          ^^^^^^^^
                                     This is your Installation ID
```

Copy this Installation ID.

---

## Step 4: Configure x0tta6bl4 Server (2 minutes)

### 4.1 Set Environment Variables

Create `.env` file:

```bash
# GitHub App Configuration
GITHUB_APP_ID=123456
GITHUB_WEBHOOK_SECRET=your_webhook_secret_from_step_1.3
GITHUB_PRIVATE_KEY_PATH=/path/to/your-app.private-key.pem
GITHUB_INSTALLATION_ID=12345678

# Server Configuration
PORT=8000
HOST=0.0.0.0
```

### 4.2 Start Webhook Server

**Using Docker (recommended):**

```bash
docker run -d \
  --name x0tta6bl4-webhooks \
  -p 8000:8000 \
  --env-file .env \
  x0tta6bl4/webhooks:latest
```

**Using Python:**

```bash
source .venv/bin/activate
python webhook_server.py
```

Server will start on `http://localhost:8000`

---

## Step 5: Test the Integration (2 minutes)

### 5.1 Create Test PR

1. Go to your repository
2. Create a new branch: `git checkout -b test-x0tta6bl4`
3. Make a simple code change
4. Push and create a Pull Request

### 5.2 Check for Comment

Within 5-10 seconds, you should see:
- ✅ A comment from your GitHub App bot
- ✅ Analysis results with severity levels
- ✅ Line numbers for detected issues

**Example comment:**
```markdown
## 🔍 x0tta6bl4 Bug Analysis

Analyzed 3 files and found 5 potential issues:

🔴 Severity 5: 2 issue(s)
🟡 Severity 3: 3 issue(s)

### 📋 Details:
...
```

---

## 🔧 Troubleshooting

### Issue: "Webhook delivery failed (401)"

**Cause:** Webhook secret mismatch

**Fix:**
1. Verify `GITHUB_WEBHOOK_SECRET` in `.env` matches GitHub App webhook secret
2. Restart webhook server
3. Re-deliver webhook from GitHub (Settings → Recent Deliveries → Redeliver)

### Issue: "No comment posted on PR"

**Cause:** Missing permissions

**Fix:**
1. Go to GitHub App settings
2. Check **Permissions** → **Pull requests** is "Read & write"
3. Reinstall the app on your repository

### Issue: "Connection refused"

**Cause:** Webhook URL not accessible

**Fix:**
1. Make sure your server is running: `curl http://localhost:8000/health`
2. If using ngrok for testing: `ngrok http 8000`
3. Update webhook URL in GitHub App settings with ngrok URL

---

## 🎉 Success Checklist

- ✅ GitHub App created
- ✅ Webhook secret configured
- ✅ Private key downloaded
- ✅ App installed on repository
- ✅ Webhook server running
- ✅ Test PR commented successfully

**You're ready to use x0tta6bl4!** 🚀

---

## 📞 Need Help?

- 📧 Email: support@x0tta6bl4.dev
- 💬 Discord: [Join community](https://discord.gg/x0tta6bl4)
- 📚 Full docs: [docs.x0tta6bl4.dev](https://docs.x0tta6bl4.dev)

---

## 🔐 Security Best Practices

1. **Never commit `.env` file** - Add to `.gitignore`
2. **Rotate webhook secret regularly** - Every 90 days
3. **Use HTTPS only** - No HTTP in production
4. **Limit app permissions** - Only what's needed
5. **Monitor webhook logs** - Check for suspicious activity

---

## 💰 Upgrade to Professional

Want more features?

- 🔒 **8 Security Detectors** (SQL injection, XSS, etc.)
- ⚡ **Priority Analysis** (<5 seconds)
- 📊 **Advanced Metrics** (trends, reports)
- 🎯 **Custom Rules** (your team's standards)
- 💬 **Priority Support** (2-hour response time)

[Upgrade to Professional €99/month →](https://x0tta6bl4.dev/pricing)

---

**Last updated:** 4 November 2025  
**Version:** 1.0
