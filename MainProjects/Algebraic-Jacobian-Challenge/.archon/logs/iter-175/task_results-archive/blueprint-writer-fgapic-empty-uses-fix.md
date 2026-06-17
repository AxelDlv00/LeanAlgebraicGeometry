# blueprint-writer · fgapic-empty-uses-fix · iter-175

## Status
DONE — 2 empty `\uses{}` mentions neutralised in
`blueprint/src/chapters/Picard_FGAPicRepresentability.tex`. Zero
remaining empty `\uses{}` outside `%` comments. No other edits.

## Root cause

The 2 doctor-flagged matches were **not** annotations attached to
declaration blocks. They were **prose mentions** inside the
"Internal-consistency check" section that wrote the literal string
`\uses{}` while describing the dependency mechanism abstractly:

- **Line 619** (inside `\begin{itemize}`):
  `\cref{lem:smooth_proper_quotient} is a structural Archon-internal
  statement; no external \uses{}.`
- **Line 640** (closing paragraph):
  `the \uses{} pointers across the three chapters in lockstep.`

plastex was parsing both as real `\uses{}` commands with an empty
label list, emitting `Label '' could not be resolved` twice and
sending `leanblueprint depgraph` into infinite recursion.

A third match (line 11) is inside a `%` comment (`$\uses{}$`) and
plastex skips it — consistent with the doctor's count of 2.

## Fix

Both prose mentions were rewritten as monospace `\texttt{\textbackslash
uses}` so the technical reference is preserved in the rendered text
but plastex no longer parses a command:

```
-    statement; no external \uses{}.
+    statement; no external \texttt{\textbackslash uses} pointers.
```

```
-the \uses{} pointers across the three chapters in lockstep.
+the \texttt{\textbackslash uses} pointers across the three chapters in lockstep.
```

This is the "delete the empty `\uses{}` entry entirely" branch of the
directive (no real label could be inferred — there was nothing to
fill in; the writer was describing the `\uses` mechanism itself, not
declaring a dependency).

## Verification

1. `grep -n '\\uses{}' blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
   now returns **only** the line-11 match inside a `%` comment
   (skipped by plastex). The 2 prose mentions are gone.
2. Regex sweep for empty list slots (`\uses{a,,b}`, `\uses{,...`,
   `...,}`) returns zero matches — every real `\uses{...}` in the
   chapter has only non-empty comma-separated labels.
3. All real `\uses{...}` annotations (lines 74, 124, 170, 223, 406,
   453, 490) were untouched; their labels were not modified.

## Out-of-scope items respected

- No chapter prose rewritten.
- No new declaration blocks added.
- No `\label{...}` / `\lean{...}` / `\leanok` / `\mathlibok` lines
  changed.
- No sibling-chapter edits.

## Expected downstream

`leanblueprint depgraph` should no longer infinite-loop on this
chapter, `leanblueprint web` should build, and the doctor's
`malformed_refs` count for this file should drop 2 → 0.
