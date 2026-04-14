# Claude Developer Tools

A Claude Code plugin with developer productivity skills — PR monitoring, project management, research, browser-based verification, and more.

## Setup

### 1. Add the marketplace

```bash
claude plugin marketplace add aliir74/claude-developer-tools
```

### 2. Install the plugin

```bash
claude plugin install developer-tools
```

After this, updates pull automatically at Claude Code startup.

## Available Skills

Invoke skills with `/developer-tools:<skill-name>`.

### User-Invoked

| Skill | Description | Usage |
|-------|-------------|-------|
| `babysit-pr` | Monitor a PR — auto-fix CI failures, address review feedback, track deploys | `/loop 5m /developer-tools:babysit-pr #123` |
| `clickup-cli` | ClickUp CLI operations — tasks, comments, search, sprints, time tracking | `/developer-tools:clickup-cli` |
| `verify-deployment` | Verify deployed code in preview/staging via browser automation | `/developer-tools:verify-deployment CU-abc123` |
| `deploy-preview` | Trigger preview deployment and monitor for deploy URL | `/developer-tools:deploy-preview` |
| `codex-ask` | Get a second opinion from OpenAI Codex CLI | `/developer-tools:codex-ask Is this approach correct?` |
| `session-handoff` | Generate structured handoff document for another agent/engineer | `/developer-tools:session-handoff` |

### Auto-Triggered

These skills activate automatically when Claude detects you're working in a relevant area:

| Skill | Triggers When |
|-------|---------------|
| `deep-research` | Researching topics — "what's the latest on X", "research X for me" |
| `dd-security-vulns` | Reviewing Datadog CSM vulnerability findings |
| `create-permission-hook` | Creating permission hooks for CLI tools |
| `gws-cli` | Interacting with Google Workspace (Gmail, Calendar, Drive, Sheets) |

## Shared Hooks

### ClickUp Permission Gate

Auto-allows read-only ClickUp commands (`task view`, `task list`, `task search`, etc.). Write operations (`task edit`, `comment add`, `status set`) prompt for user confirmation.

### Google Workspace Permission Gate

Auto-allows read-only Google Workspace commands (`+triage`, `+agenda`, `+read`, message list/get). Write operations (`+send`, `+insert`, event create/update/delete) prompt for user confirmation.

## Prerequisites

Some skills require external CLI tools. See [SETUP.md](SETUP.md) for installation instructions.

| Skill | Requires |
|-------|----------|
| `babysit-pr` | `gh` (GitHub CLI) |
| `clickup-cli` | `clickup` (ClickUp CLI) |
| `verify-deployment` | `agent-browser`, `clickup`, `gh` — see [SETUP.md](SETUP.md) |
| `deploy-preview` | `gh` (GitHub CLI) |
| `gws-cli` | `gws` (Google Workspace CLI) |
| `codex-ask` | `codex` (OpenAI Codex CLI) |
| `dd-security-vulns` | Datadog API credentials |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add new skills and the PR process.

## License

MIT
