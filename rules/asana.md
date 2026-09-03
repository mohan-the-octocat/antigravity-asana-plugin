---
trigger: model_decision
description: "Rules, parameter conventions, and scoping constraints when interacting with Asana workspaces, projects, and tasks."
---

# Asana Tool Rules & Context

## Scoping & Pinned Context
- **Workspace & Team Binding**: When pre-configured via `ASANA_WORKSPACE_GID` and `ASANA_TEAM_GID`, this plugin operates strictly within the designated Workspace and Team.
- **Automatic Fallback**: You do not need to ask the user for Workspace or Team GIDs. The MCP server automatically applies the configured environment defaults when `workspace_gid` or `team_gid` are omitted.
- **Strict Boundary**: Never query or create resources outside the pinned workspace and team. Calls targeting other workspaces or teams will be rejected when strict scoping is active.

## Resolution Principles
- When listing projects or templates, the query is automatically scoped to the configured team.
- When creating tasks, custom fields, or projects, the target workspace/team defaults to the configured scope.
- Users speak in human-friendly names (e.g. "Retail POC", "Customer Onboarding"). Autonomously resolve project and section names within the configured workspace/team.

## Available Tools Reference
- `get_workspaces`: List workspaces (filtered to pinned workspace under strict scope).
- `get_teams`: List teams (filtered to pinned team under strict scope).
- `get_projects`: Retrieve projects scoped to the active team or workspace.
- `get_tasks`: List tasks in a specified project by `project_gid`.
- `get_task_details`: Get full details of a specific task by `task_gid`.
- `get_goals`: List goals within the scoped workspace or team.
- `get_goal_details`: Get full details of a specific goal by `goal_gid`.
- `create_task`: Create a task in the scoped workspace with optional project, section, or custom fields.
- `create_subtask`: Create a subtask under a parent task.
- `update_task`: Update fields or custom fields of a task.
- `create_project`: Create a project within the scoped team.
- `get_sections`: List sections in a project.
- `create_section`: Create a section in a project.
- `get_custom_fields`: List custom fields in the scoped workspace.
- `create_custom_field`: Create an organization-level custom field.
- `get_project_templates`: Find templates available for the scoped team.
- `create_project_from_template`: Instantiate a template in the scoped team.
- `scaffold_project_from_definition`: Recursively create structured project, sections, tasks, and subtasks in the scoped workspace and team.
