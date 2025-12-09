# VSCode Troubleshooting Guide

## Observed Issues
1. `Kubectl command failed` popup
2. `The command "node" needed to run context? was not found.`
3. Occasional high CPU usage from multiple `code` processes (seen >25%)

## Root Causes & Fixes
### 1. Kubectl Command Failed
Likely causes:
- kubectl not installed or not in PATH
- Context referencing stale cluster config
- Kubernetes extension polling unreachable API server

Fix:
```bash
# Verify install
which kubectl || echo 'kubectl missing'
# If missing (Ubuntu/Debian):
sudo curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl version --client

# Reset contexts if stale
kubectl config get-contexts
kubectl config delete-context <old>
```
If not actively using Kubernetes in this session: disable the VSCode Kubernetes extension to reduce background calls.

### 2. Node Not Found
Extensions requiring Node (TypeScript/ESLint tooling, some AI plugins) fail if `node` binary absent.

Install Node.js (lightweight):
```bash
# Using NodeSource (LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
```
Or minimal tarball:
```bash
VERSION=22.11.0
curl -LO https://nodejs.org/dist/v$VERSION/node-v$VERSION-linux-x64.tar.xz
sudo tar -xJf node-v$VERSION-linux-x64.tar.xz -C /usr/local --strip-components=1
node -v
```
If you intentionally want to keep system lean: disable extensions depending on Node (TypeScript server, ESLint) and rely on basic editing until needed.

### 3. High VSCode CPU Usage
Causes:
- Too many workspace watchers in a huge repo (>10k files)
- Extensions scanning (Git history, indexing, AI features)
- Large diff calculations in an oversized `.git` directory (>60GB)

Mitigations:
- Close unused VSCode windows (each spawns separate electron + extension host)
- Disable heavy extensions (GitLens, Kubernetes, AI indexing) temporarily
- Exclude large folders via settings:
  Settings > Files: Exclude
  Add patterns:
  - `**/.git/**`
  - `**/backups/**`
  - `**/benchmark_history/**`
  - `**/x0tta6bl4_previous/**` (if not needed)

Add to `.vscode/settings.json`:
```json
{
  "files.watcherExclude": {
    "**/.git/**": true,
    "**/backups/**": true,
    "**/benchmark_history/**": true,
    "**/x0tta6bl4_previous/**": true
  },
  "files.exclude": {
    "**/x0tta6bl4_previous/**": true
  }
}
```

## Performance Tips
- Use the new `monitoring/lightwatch.py` to observe CPU/memory while editing.
- If load > cores*2 and CPU moderate: suspect IO saturation (large file ops or deletion).
- Avoid running recursive size scans over entire mount (`du -ah /mnt/...`). Prefer targeted: `du -sh path/* | sort -h | tail`.

## Extension Hygiene
Identify top extension resource usage:
1. Open Command Palette > Developer: Show Running Extensions.
2. Disable any with high activation time you don't need right now.

## Git Directory Bloat
A 69GB `.git` will slow file watchers and Git operations.
Short-term relief:
```bash
git gc --prune=now --aggressive
```
Note: Run only when enough free disk exists. Can free significant space + reduce CPU cost of GitLens.

## When to Reboot VSCode
- Memory usage per `code` process > 1GB and rising
- Extension host crashes repeatedly
- UI lag > 3–5 seconds on simple actions

## Escalation Checklist
1. Tail `monitoring/resource_metrics.summary`
2. Identify top PID(s) using >50% CPU
3. If VSCode extension host is culprit: disable extensions sequentially
4. If disk critical: prune old backups first

---
Updated: 2025-11-04
