---
trigger: model_decision
description: "Rules, parameter conventions, and dynamic GID resolution when interacting with Asana workspaces, projects, and tasks."
---

# Asana Tool Rules & Context

## Scope — Generic Asana Bridge
This plugin provides an un-scoped bridge between the agent harness and the Asana API. It does NOT contain hardcoded team GIDs, default scopes, or client-side business logic.

- **Explicit Parameters**: All tools that list or create team and workspace resources (such as `get_projects`, `get_goals`, `create_project`, `get_project_templates`, `create_project_from_template`, and `scaffold_project_from_definition`) require explicit `team_gid` or `workspace_gid` parameters in the input payload.
- **No Scoping Fallbacks**: Do not call `get_projects()` or `get_goals()` without required scoping arguments (`workspace_gid` or `team_gid`).
- **Dynamic Resolution**: Always call `get_workspaces` first if you do not have a workspace GID. Use the returned workspace GID to list teams via `get_teams` to retrieve the relevant `team_gid`. Never guess GIDs or assume hardcoded defaults exist.

## Available Tools Reference
- `get_workspaces`: Retrieve all workspaces the authenticated user has access to. Call this first if you do not have a workspace GID.
- `get_teams`: Retrieve all teams in a specified workspace (`workspace_gid`). Use this to find the correct `team_gid`.
- `get_projects`: Retrieve projects scoped to `team_gid` or `workspace_gid`. At least one is required.
- `get_tasks`: List tasks in a specified project by `project_gid`.
- `get_task_details`: Get full details of a specific task by `task_gid`.
- `get_goals`: List goals within a workspace or team. At least one of `workspace_gid` or `team_gid` must be provided.
- `get_goal_details`: Get full details of a specific goal by `goal_gid`.
- `create_task`: Create a task in a workspace with optional project, section, or custom fields.
- `create_subtask`: Create a subtask under a parent task.
- `update_task`: Update fields or custom fields of a task.
- `create_project`: Create a project within a team (`team_gid`).
- `get_sections`: List sections in a project.
- `create_section`: Create a section in a project.
- `get_custom_fields`: List custom fields in a workspace, optionally filtered by prefix.
- `create_custom_field`: Create an organization-level custom field in a workspace.
- `get_project_templates`: Find templates available for a team.
- `create_project_from_template`: Instantiate a template (`team_gid`, `template_gid`).
- `scaffold_project_from_definition`: Recursively create structured project, sections, tasks, and subtasks from JSON definition.
