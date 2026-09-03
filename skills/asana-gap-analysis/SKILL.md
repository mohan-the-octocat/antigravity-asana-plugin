---
name: asana-gap-analysis
description: >
  Run a tool capability gap analysis on the local Asana MCP server.
  Compares implemented tools against Customer Engineering and workflow requirements,
  reporting missing endpoints and priority tiers.
---

# Asana MCP Server — Gap Analysis Skill

Use this skill to audit the tools implemented in the local Asana MCP server and produce a prioritized gap report.

## Procedure

1. Read `src/index.ts` to extract the complete list of registered tools from `ListToolsRequestSchema`.
2. Compare the tool list against Asana API endpoints and CE practice requirements:
   - **Workspaces & Organizations**: `get_workspaces`, `get_workspace`, `get_workspace_users`
   - **Teams**: `get_teams`, `get_team`, `get_team_users`
   - **Projects**: `get_projects`, `get_project`, `create_project`, `update_project`, `delete_project`
   - **Sections**: `get_sections`, `create_section`, `update_section`, `delete_section`
   - **Tasks**: `get_tasks`, `get_task_details`, `create_task`, `create_subtask`, `update_task`, `delete_task`, `add_task_to_project`, `remove_task_from_project`
   - **Custom Fields**: `get_custom_fields`, `create_custom_field`, `update_custom_field`
   - **Templates**: `get_project_templates`, `create_project_from_template`, `scaffold_project_from_definition`
   - **Goals & Portfolios**: `get_goals`, `get_goal_details`, `get_portfolios`, `get_portfolio_items`
3. Classify missing endpoints into priority tiers:
   - **Tier 1 (High)**: Essential task/project management operations.
   - **Tier 2 (Medium)**: Portfolios, tags, or team management operations.
   - **Tier 3 (Low)**: Audit logs, webhooks, or niche admin APIs.
4. Output a clean structured markdown report with actionable recommendations and next steps.
