# Logging System for Jules AI Agent Interactions

This directory (`jules/logs/`) contains logs and supporting documentation for interactions with the Jules AI agent.

## Main Log File

The primary log file for this project is:

-   **`projectlog.50701.001.yaml`**: This YAML file stores a chronological record of interactions, development notes, command executions, test results, backlogged items, and bot status updates. The naming convention `projectlog.<project_id>.<sequence_num>.yaml` is used.

## Log Structure

Log entries are structured in YAML format as a list of items. Each item is an object with common fields and type-specific fields.

### Common Fields for all Log Types:

-   `id`: A unique identifier for the log entry, typically in the format `<project_id>.<entry_num>.<type_abbreviation>`. Example: `50701.001.interact`.
-   `timestamp`: An ISO 8601 timestamp string (e.g., `YYYY-MM-DDTHH:MM:SSZ`).

### Defined Log Types:

1.  **`interact`**
    *   **Purpose**: Records direct interactions (prompts and responses) between the user and the Jules AI agent.
    *   **Fields**:
        *   `source`: `'user'` or `'agent'`
        *   `message`: The content of the interaction.

2.  **`dev`**
    *   **Purpose**: Records development-related actions, decisions, code changes, or significant findings during the agent's work.
    *   **Fields**:
        *   `component`: The specific module, file, or area of focus (e.g., `logging_setup`, `cpu_exploration`, `qemu_docker`).
        *   `message`: A summary of the development activity.
        *   `details`: (Optional) An object containing more structured information, like actions taken, files modified, or specific findings.

3.  **`run`**
    *   **Purpose**: Records the execution of commands, scripts, or tools by the agent.
    *   **Fields**:
        *   `component`: The component or context in which the command was run.
        *   `event`: A description of the event (e.g., `command_start`, `script_execution`).
        *   `script_name` (or `command`): The actual command or script that was executed.
        *   `details`: (Optional) An object for input parameters or output summaries.

4.  **`test`**
    *   **Purpose**: Records details about test executions.
    *   **Fields**:
        *   `test_case`: Name or description of the test case.
        *   `status`: Result of the test (e.g., `PASS`, `FAIL`, `SKIP`).
        *   `duration_ms`: (Optional) Duration of the test in milliseconds.
        *   `details`: (Optional) An object for more specific test outputs or failure reasons.

5.  **`backlog`**
    *   **Purpose**: Logs tasks, ideas, feature requests, or issues that are noted but not immediately actioned, to be reviewed later.
    *   **Fields**:
        *   `item_type`: Type of backlog item (e.g., `'feature_request'`, `'idea'`, `'task_deferred'`, `'bug_report'`).
        *   `summary`: A brief description of the backlogged item.
        *   `details`: (Optional) More detailed explanation, rationale, or links to relevant information.
        *   `priority`: (Optional) Priority level (e.g., `'low'`, `'medium'`, `'high'`).

6.  **`bot_status`**
    *   **Purpose**: Records the bot's snapshot of its current understanding, active plan, and context. This helps in synchronizing with human collaborators or future bot instances.
    *   **Fields**:
        *   `current_plan_step`: A description of the specific plan step the bot is currently working on or has just completed.
        *   `active_task_summary`: A brief summary of the bot's current high-level task.
        *   `blocked_on`: (Optional) If the bot is blocked, a description of what it's waiting for.
        *   `recent_decisions`: (Optional) A list of key decisions made recently.
        *   `overall_goal`: The overarching goal the bot is trying to achieve.

## Log Template

For a clean template showing the structure of these log types, see `template.000.yaml`.

## Log Management

Log files are intended to be additive. If log file management (like splitting large files) is needed, it should be performed manually.Tool output for `create_file_with_block`:
