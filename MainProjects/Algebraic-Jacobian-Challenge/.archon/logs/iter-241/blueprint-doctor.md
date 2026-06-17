# Blueprint Doctor

## Broken cross-references

These `\ref{...}` / `\uses{...}` / `\cref{...}` (etc.) calls point at labels that no `\label{...}` defines anywhere in the included tex tree. The dependency graph rendered by leanblueprint will draw a missing edge for each. Common causes: label typos (case mismatch, plural/singular), labels moved to an orphan chapter, or copy-paste of `\uses{...}` lists that weren't updated when targets renamed.

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
- `\uses{\leanok
  lem:fromTildeGamma_app_isIso_of_localized}` — no matching `\label`
- `\uses{\leanok
  lem:pushforward_spec_tilde_iso_conditional}` — no matching `\label`

