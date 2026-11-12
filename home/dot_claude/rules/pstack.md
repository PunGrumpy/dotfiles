# pstack models in Claude Code

pstack skills read their per-role models from `~/.cursor/rules/pstack-models.mdc`. That file is a Cursor rule, so Claude Code doesn't load it on its own. Before a pstack skill spawns a subagent, read that file and use the role's line as the skill says. `/setup-pstack` writes the file, and it stays the only place where models are chosen.

A slug is `<model>-<effort>`, for example `claude-opus-5-5-max`. Where the skills say "Task tool" and `model`, spawn the subagent like this:

- **`claude-*`, inside a T3 Code thread** (the `t3-code` MCP tools are available): use `delegate_task` with `target: {model: "<model>", options: {effort: "<effort>"}}`. Leave out `providerInstanceId` so the child runs on the current thread's provider. Every delegate runs with `runtimeMode: "full-access"`; never use approval-required in T3 Code (it stalls an unattended run on its first permission request). Readonly roles (judges, reviewers, investigators) get `role: "review"` and a brief that forbids edits, commits and installs. Send panel runners and swarm workers in one batch with `mode: "async"`.
- **`claude-*`, outside T3**: use the Agent tool. Map `claude-opus-*` → `opus`, `claude-fable-*` → `fable`, `claude-sonnet-*` → `sonnet`, `claude-haiku-*` → `haiku`. The effort can't be set, so the subagent uses the session's effort.
- **`gpt-*`, `grok-*` and other non-Claude entries**: don't delegate to another provider. Run that seat on `claude-opus-5-5-max` and say so.
- **`inherit-parent` or `auto`**: use the Agent tool with no `model`.
