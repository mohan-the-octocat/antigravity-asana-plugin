---
name: asana-admin
description: >
  Asana Admin skill for maintaining, auditing, and extending the Asana MCP server.
  Activate when the user asks to audit the MCP server's capabilities, implement missing
  Asana API endpoints, or add unit tests for new Asana tools.
---

# Asana Admin Skill — MCP Server Maintenance & Extension Guide

## Your Role in This Skill
You are an expert TypeScript/MCP engineer and Asana API specialist. Your job is to:
1. **Audit** the Asana MCP server at `src/index.ts`.
2. **Identify Gaps** in supported endpoints compared to requirements.
3. **Extend the MCP Server** dynamically by implementing missing tools following established patterns.
4. **Extend the Test Suite** in `tests/asana-mcp.test.ts` to fully cover newly implemented tools under happy and error paths.
5. **Compile and Verify** the modifications using local build and test scripts (`npm run build` and `npm test`).

---

## Server Location & Key Files

| Artifact | Path |
|---|---|
| Source file | `src/index.ts` |
| Compiled output | `dist/index.js` |
| Test suite | `tests/asana-mcp.test.ts` |
| Plugin manifest | `plugin.json` |
| MCP configuration | `mcp_config.json` |
| Rules file | `rules/asana.md` |

---

## Implemented Tools (Vanilla Asana Bridge)

The server implements 18 generic tools:
1. `get_workspaces` — List workspaces.
2. `get_teams` — List teams in a workspace.
3. `get_projects` — List projects scoped to a team or workspace.
4. `get_tasks` — List tasks within a specific project.
5. `get_task_details` — Retrieve full details of a specific task by ID.
6. `get_goals` — List goals scoped to a team or workspace.
7. `get_goal_details` — Retrieve full details of a specific goal by ID.
8. `create_task` — Create a task in a workspace, optional project, section, or custom fields.
9. `create_subtask` — Create a subtask for a parent task.
10. `update_task` — Update fields or custom fields of a task.
11. `create_project` — Create a project within a team.
12. `get_sections` — List sections in a project.
13. `create_section` — Create a section in a project.
14. `get_custom_fields` — List or filter custom fields in a workspace.
15. `create_custom_field` — Create a workspace custom field.
16. `get_project_templates` — Find templates available for a team.
17. `create_project_from_template` — Instantiate a template.
18. `scaffold_project_from_definition` — Create structured project, sections, tasks, and subtasks from JSON definition.

---

## Extension Workflow

When adding support for a new Asana endpoint:

### Step 1: Research the Asana API & SDK
- Determine the official Node.js Asana SDK (`asana` npm package) class and method.
- Identify input parameters (types, optional vs required).
- Keep tools generic and vanilla (never hardcode team or workspace GIDs).

### Step 2: Instantiate the API Client
- Check if the Asana API class is instantiated at the top of `src/index.ts`.
- If missing, instantiate it (e.g. `const portfoliosApi = new Asana.PortfoliosApi();`).

### Step 3: Add the Tool Definition (Schema)
- Append the new tool's schema to `ListToolsRequestSchema` in `src/index.ts`.

### Step 4: Add the Execution Handler
- Append the implementation in `CallToolRequestSchema` in `src/index.ts`.
- Validate required parameters and return standard text JSON response.

### Step 5: Update the Test Suite
- In `tests/asana-mcp.test.ts`, add mock methods in the `vi.mock("asana")` block.
- Update the expected tool count in the registration test.
- Add unit test blocks for both happy path and missing parameter error cases.

### Step 6: Build and Run Tests
- Run `npm run build` to verify TypeScript compilation.
- Run `npm test` to verify 100% test pass rate.
