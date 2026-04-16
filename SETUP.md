# Setup Guide

## Plugin Installation

```bash
claude plugin marketplace add aliir74/cortex
claude plugin install cortex
```

## Skill-Specific Prerequisites

### babysit-pr

Requires the GitHub CLI:

```bash
brew install gh
gh auth login
```

### clickup-cli

Requires the ClickUp CLI ([source](https://github.com/triptechtravel/clickup-cli)):

```bash
brew install triptechtravel/tap/clickup
```

Authenticate: `clickup auth login`

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

### slack-cli

Requires the `agent-slack` CLI on your `PATH`. The skill is written for an
`agent-slack`-style command surface (`agent-slack message list`,
`agent-slack message send`, etc.).

> TODO: replace this block with the exact install command for the
> `agent-slack` distribution you use. A common pattern is to install via
> Bun (`bun install -g <package>`) and source the binary path in your
> shell init.

Authenticate by importing credentials from Slack Desktop:

```bash
agent-slack auth import-desktop
agent-slack auth test
```

### bird-cli

Requires the `bird` CLI for X/Twitter. Install via Bun:

```bash
bun install -g bird
```

Verify auth:

```bash
bird whoami
```

If `bird` is configured for explicit credentials (`cookieSource: []` in
`~/.config/bird/config.json5`), populate `~/.config/bird/accounts.json`
with `ct0` and `auth_token` per account.

### tgcli

Requires the `tgcli` CLI:

```bash
brew install kfastov/tap/tgcli
```

First-time setup needs API credentials from <https://my.telegram.org/apps>:

```bash
tgcli auth
tgcli doctor
```

### glab-cli

Requires the GitLab CLI:

```bash
brew install glab
glab auth login
```

For self-hosted GitLab, point the CLI at the right host:

```bash
glab config set -g host gitlab.example.com
```
