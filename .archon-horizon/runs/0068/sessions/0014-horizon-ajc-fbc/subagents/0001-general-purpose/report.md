Read the file /tmp/fbc_plan.md and carry out exactly the task it specifies. It is a self-contained Lean 4 proof-plumbing task with a verified mathematical plan; your job is to make the tactic script go through.

Critical process notes:
- File as you go: if you make partial progress and then run low on budget, write your findings out BEFORE you stop. Do not stall silently — a previous session in this workspace had two subagents die producing 187 bytes and nothing filed.
- Use the lean-lsp MCP tools for the edit loop (lean_diagnostic_messages, lean_goal, lean_multi_attempt). Do not run `lake build`.
- Never introduce a new `sorry` and never alter the lemma STATEMENT to make it easier. If the statement seems wrong, say so explicitly rather than quietly changing it.
- Your final message must include the final proof text and the verbatim final `lean_diagnostic_messages` output.
