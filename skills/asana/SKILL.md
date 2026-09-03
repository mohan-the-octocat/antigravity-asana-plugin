---
name: asana
description: >
  Manage, query, create, and update Asana tasks, projects, sections, and goals.
  Activate whenever the user mentions Asana, requests project or task status,
  wants to file or update action items, or invokes the /asana slash command.
---

# Asana Workflow & Task Management Skill

Use this skill to autonomously navigate and execute user requests in Asana using the local Asana MCP tools.

## Core Directives
1. **Always Use Asana MCP Tools**: Always use the provided MCP tools (`get_workspaces`, `get_teams`, `get_projects`, `get_tasks`, `create_task`, `update_task`, etc.) to interact with Asana. Never ask the user to run external scripts or API calls.
2. **Never Prompt the User for GIDs**: The active Workspace and Team are pre-configured at install time in the environment (`ASANA_WORKSPACE_GID` and `ASANA_TEAM_GID`). When `workspace_gid` or `team_gid` are omitted, the MCP server automatically applies these defaults.
3. **Hierarchy & Context**:
   - The agent operates directly within the pinned workspace and team.
   - You can jump straight to listing projects or templates without needing to discover or select a workspace/team.
   - Call `get_sections` with `project_gid` to inspect available sections (e.g., "Backlog", "In Progress", "Done").

---

## Playbooks

### 1. Listing & Searching Tasks
When the user asks to see tasks (e.g. *"Show my open tasks in the Retail project"*):
1. Resolve the `project_gid` via `get_projects`.
2. Call `get_tasks` passing `project_gid`.
3. If details (assignee, due date, notes, custom fields) are needed, call `get_task_details` for matching tasks.
4. Present the output in a clean markdown table:
   | Task Name | Section | Due Date | Completed | Task GID |
   |---|---|---|---|---|
5. Summarize key blockers or immediate due dates.

### 2. Creating Tasks & Action Items
When the user wants to log an action item (e.g. *"Add a task to follow up on the security review in Asana"*):
1. Identify the target project from context or list recent projects with `get_projects`.
2. List project sections with `get_sections` and select the appropriate section.
3. Call `create_task` with:
   - `name`: Clear, action-oriented title (`[CATEGORY] Title - Details`).
   - `workspace`: Resolved `workspace_gid`.
   - `projects`: Array containing the `project_gid`.
   - `section`: Optional `section_gid` (or use memberships).
   - `notes`: Markdown or rich text description with background context.
   - `due_on`: Date string in `YYYY-MM-DD` format if specified.
4. If subtasks were requested, call `create_subtask` using the returned parent `gid`.
5. Confirm creation to the user, providing the task name, section, and web URL:
   `https://app.asana.com/0/<project_gid>/<task_gid>`

### 3. Updating Tasks & Marking Completion
When the user asks to complete or modify a task:
1. Search for the task by name using `get_tasks`.
2. Call `update_task` with `task_gid` and the updated fields (e.g. `completed: true`, new `notes`, or updated `custom_fields`).
3. Confirm the update clearly to the user.

### 4. Scaffolding Projects & Templates
When the user asks to create an entire project structure:
1. Check `get_project_templates` to see if a matching template exists. If so, call `create_project_from_template`.
2. Otherwise, call `scaffold_project_from_definition` with a structured JSON containing project name, sections, tasks, and subtasks.
