# Antigravity Asana Plugin (`Antigravity-Asana-Plugin`)

A native agent plugin for **Google Antigravity** that connects Asana workspaces, projects, tasks, custom fields, and templates directly into agent workflows.

---

## Plugin Overview

This plugin packages an Asana Model Context Protocol (MCP) server, model context rules, and developer skills into a single, cohesive bundle:

```
Antigravity-Asana-Plugin/
├── plugin.json                 # Antigravity plugin manifest
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
│   ├── asana/
│   │   └── SKILL.md            # Daily task & project orchestration skill (/asana)
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

- **`/asana` (`skills/asana/SKILL.md`)**:
  Day-to-day Asana assistant: searches projects/tasks, creates action items, updates statuses, and resolves human names to GIDs automatically.
- **`/asana-admin` (`skills/asana-admin/SKILL.md`)**:
  Admin/developer skill: audits, implements, tests, and verifies new Asana API endpoints in `src/index.ts`.
- **`/asana-gap-analysis` (`skills/asana-gap-analysis/SKILL.md`)**:
  Performs an automated gap analysis comparing implemented tools against Asana API endpoints and CE requirements.

---

## Configuration & Scoping

This plugin is designed to operate within a specific **Asana Workspace** and **Team**.

| Variable | Description |
|---|---|
| `ASANA_ACCESS_TOKEN` | Required. Your Asana Personal Access Token. |
| `ASANA_WORKSPACE_GID`| Pinned Asana Workspace GID (e.g. `1213807836434812`). |
| `ASANA_TEAM_GID` | Pinned Asana Team GID (e.g. `1213807836434813`). |
| `ASANA_STRICT_SCOPE` | When `true`, enforces strict boundary protection (rejection of cross-workspace/team operations). |

---

## Installation & Setup

### Method 1: Automated Scoped Installer (Recommended)
Use the included `install.sh` script to configure your pinned workspace and team, build the project, and symlink it to Antigravity:

```bash
cd ~/repos/Antigravity-Asana-Plugin

# Interactive setup:
./install.sh

# Or with CLI flags:
./install.sh \
  --workspace-gid 1213807836434812 \
  --team-gid 1213807836434813 \
  --strict true
```

### Method 2: Manual Installation
1. Compile the server:
   ```bash
   npm install && npm run build
   ```
2. Symlink the repository to Antigravity:
   ```bash
   mkdir -p ~/.gemini/antigravity/plugins/
   ln -s ~/repos/Antigravity-Asana-Plugin ~/.gemini/antigravity/plugins/asana
   ```
3. Set your environment variables in your local `.env` file (see `.env.example`).

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
