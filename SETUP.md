# Setup Guide

## Plugin Installation

```bash
claude plugin marketplace add aliir74/claude-developer-tools
claude plugin install developer-tools
```

## Skill-Specific Prerequisites

### babysit-pr

Requires the GitHub CLI:

```bash
brew install gh
gh auth login
```

### clickup-cli

Requires the ClickUp CLI:

```bash
npm install -g @anthropic/clickup-cli
# or
brew install clickup-cli
```

Authenticate: `clickup auth login`

### verify-deployment

This skill verifies deployed code by interacting with preview/staging environments in a real browser. It requires:

1. **agent-browser** — headless browser automation CLI:
   ```bash
   npm install -g agent-browser
   agent-browser install  # downloads Chrome
   ```

2. **Claude Code Chrome Extension** (optional, for Segment Debugger verification):
   - Install from Claude Code settings or the Chrome Web Store
   - Required only when verifying analytics/Segment events via the Segment Debugger UI

3. **kubectl** — for checking backend logs in Kubernetes:
   ```bash
   brew install kubectl
   ```

4. **GitHub CLI** + **ClickUp CLI** — for fetching task details and PR info

### deploy-preview

Requires the GitHub CLI:

```bash
brew install gh
gh auth login
```

### gws-cli

Requires the Google Workspace CLI:

```bash
npm install -g @googleworkspace/cli
gws auth login
```

### codex-ask

Requires the OpenAI Codex CLI:

```bash
npm install -g @openai/codex
codex login
```

### dd-security-vulns

Requires Datadog API credentials. Set these environment variables (or store in a `.env` file):

```bash
export DD_API_KEY="your-api-key"
export DD_APP_KEY="your-app-key"
```

Get credentials from: Datadog > Organization Settings > API Keys / Application Keys
