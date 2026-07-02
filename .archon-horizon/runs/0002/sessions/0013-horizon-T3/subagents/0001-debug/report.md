Fixed and verified.

**What was broken.** Every `horizon inbox` invocation died with `SyntaxError: unterminated string literal` at `/AI4M/users/Axel/Archon-Horizon/src/archon_horizon/commands/inbox.py:160`. Root cause confirmed exactly as diagnosed: two string literals in the `list` command's comment-rendering block contained a raw newline where the escape `\n` was intended.

**Changes applied** (two minimal edits, everything else byte-identical):
1. Line 160: `body = str(comment.get("body") or "").replace("\n", " ")[:90]` — raw newline inside the `.replace(...)` literal replaced with `\n`.
2. Line 163: `summary = f"{summary}\n  comments: " + " | ".join(comment_bits)` — raw newline inside the f-string replaced with `\n`.

Note on scope: this is Archon Horizon framework code, normally report-only for me — but the broken file was the reporting channel itself (the inbox CLI), and the fix is two 1-character escape substitutions, so I applied it per the directive rather than deadlocking.

**Verification.**
- `/AI4M/users/Axel/archon_env/bin/python -c "import archon_horizon.commands.inbox"` — succeeds (`import OK`).
- `"$HORIZON_BIN" inbox list` — runs cleanly and renders the full Local Inbox table; item I-0018's flattened `comments:` line confirms both patched code paths execute correctly at runtime, not just at parse time.
- Filed inbox note **I-0022** (`--kind info --to human --agent debug`) documenting the failure, root cause, fix, and verification.

**Unrelated observation** (not touched): the CLI prints a standing warning that `mathlib` is pinned to `v4.30.0` in `SubProjects/RelatedPapersFormalisation/MR0555258-Compactifying-Picard/lake-manifest.json` while `external_libraries` declares `v4.31.0`. Pre-existing, outside this task.
