# Asana Plugin for Jetski & Google Antigravity

A native agent plugin for **Jetski** and **Google Antigravity** that integrates Asana workspaces, projects, tasks, custom fields, and templates into agent workflows.

---

## Plugin Overview

This plugin packages an Asana Model Context Protocol (MCP) server, model context rules, and developer skills into a single, cohesive bundle:

```
asana-plugin/
├── plugin.json                 # Jetski & Antigravity plugin manifest
├── mcp_config.json             # MCP server declaration (stdio transport)
├── package.json                # Dependencies and build scripts
├── tsconfig.json               # TypeScript configuration
├── src/
│   └── index.ts                # Asana MCP server implementation (18 tools)
├── dist/
│   └── index.js                # Compiled executable JavaScript
├── rules/
│   └── asana.md                # Progressive-disclosure rules (trigger: model_decision)
├── skills/
│   ├── asana-admin/
│   │   └── SKILL.md            # Maintenance and tool extension skill (/asana-admin)
│   └── asana-gap-analysis/
│       └── SKILL.md            # Tool capability gap analysis skill (/asana-gap-analysis)
└── tests/
    └── asana-mcp.test.ts       # Vitest unit test suite (mocked Asana SDK)
```

---

## Available Asana Tools (MCP)

The MCP server exposes 18 generic, un-scoped Asana tools:

| Category | Tool | Description |
|---|---|---|
| **Workspaces & Teams** | `get_workspaces` | List all workspaces accessible by the user |
| | `get_teams` | List all teams within a workspace (`workspace_gid`) |
| **Projects** | `get_projects` | List projects scoped to a team or workspace |
| | `create_project` | Create a new project in a team (`team_gid`) |
| **Tasks & Subtasks** | `get_tasks` | List tasks within a specific project (`project_gid`) |
| | `get_task_details` | Retrieve full details of a task by `task_gid` |
| | `create_task` | Create a task with optional project, section, or custom fields |
| | `create_subtask` | Create a subtask under a parent task |
| | `update_task` | Update task fields or custom fields |
| **Sections** | `get_sections` | List sections within a project |
| | `create_section` | Create a new section within a project |
| **Custom Fields** | `get_custom_fields` | List custom fields in a workspace (with optional prefix filter) |
| | `create_custom_field` | Create an org-level custom field (text, enum, number, multi-select) |
| **Templates & Scaffolding**| `get_project_templates` | List available project templates for a team |
| | `create_project_from_template` | Instantiate a template and poll until completion |
| | `scaffold_project_from_definition` | Recursively create project, sections, tasks, and subtasks from JSON |
| **Goals** | `get_goals` | List goals within a workspace or team |
| | `get_goal_details` | Retrieve full details of a specific goal |

---

## Skills & Slash Commands

- **`/asana-admin` (`skills/asana-admin/SKILL.md`)**:
  Guides the agent to audit, implement, test, and verify new Asana API endpoints in `src/index.ts`.
- **`/asana-gap-analysis` (`skills/asana-gap-analysis/SKILL.md`)**:
  Performs an automated gap analysis comparing implemented tools against Asana API endpoints and CE requirements.

---

## Configuration & Authentication

The MCP server requires an **Asana Personal Access Token**:
1. Log into Asana → **My Settings** → **Apps** → **Manage Developer Apps** → **Personal Access Tokens**.
2. Generate a new token.
3. Export it in your shell environment or set it in your agent configuration:
   ```bash
   export ASANA_ACCESS_TOKEN="your_personal_access_token"
   ```
4. *(Optional)* Set a default team GID:
   ```bash
   export ASANA_TEAM_GID="1234567890"
   ```

---

## Installation

### Option 1: Global Installation (Jetski & Antigravity)
Symlink or copy this repository into your global agent plugins directory:

```bash
# For Jetski:
mkdir -p ~/.gemini/config/plugins/
ln -s ~/repos/asana-plugin ~/.gemini/config/plugins/asana

# For Antigravity:
mkdir -p ~/.gemini/antigravity/plugins/
ln -s ~/repos/asana-plugin ~/.gemini/antigravity/plugins/asana
```

### Option 2: Workspace-Level Installation
Symlink or copy into your workspace's `_agents/plugins/` (Jetski) or `.agents/plugins/` (Antigravity):

```bash
mkdir -p /path/to/workspace/_agents/plugins/
ln -s ~/repos/asana-plugin /path/to/workspace/_agents/plugins/asana
```

---

## Build & Testing

```bash
# Install dependencies
npm install

# Compile TypeScript to dist/index.js
npm run build

# Run Vitest test suite
npm test
```

---

## License

Apache-2.0
