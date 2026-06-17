# Blueprint Doctor

## Orphan chapters

These `.tex` files exist under `blueprint/src/chapters/` but are NOT reachable from `content.tex` via `\input` (directly or transitively). They contribute nothing to the rendered blueprint and likely indicate either a forgotten `\input{...}` line in `content.tex` or stale chapter files left behind by a refactor.

- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

