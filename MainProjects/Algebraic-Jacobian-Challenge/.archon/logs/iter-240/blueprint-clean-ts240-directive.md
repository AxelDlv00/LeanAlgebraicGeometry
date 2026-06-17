# Blueprint Clean Directive — ts240

## Chapters edited this iter (clean both)
1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — section
   `sec:tensorobj_pullback_monoidality` was rewritten (route pivot): the dead
   sectionwise-`extendScalars` recipe replaced by the Route Z local-chart-finality
   proofs for `lem:pullback_tensor_iso` (Phase 2, now descoped to a POINTWISE
   comparison iso — the full `CoreMonoidal.ofOplaxMonoidal` packaging is explicitly
   off-path) and `lem:pullback_unit_iso` (Phase 1, the cheap unit comparison); the
   section intro was rewritten; `lem:isinvertible_pullback` and all Stacks
   `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks were kept verbatim.
2. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — two new
   `\lean{}`-pinned Archon-original blocks added (`lem:gammaPushforwardIsoAt`,
   `lem:tildeRestriction_isLocalizedModule`); a "natural in the open" paragraph +
   an honest-restriction-of-scalars paragraph + an upstream-alignment `% NOTE:`
   added to the `lem:pushforward_spec_tilde_iso` proof.

## What to do (standard blueprint-clean pass on both chapters)
- Strip any Lean leakage / tactic syntax that crept into rendered prose (Mathlib
  identifiers as `\texttt{…}` are fine; tactic invocations like `algebraize`,
  `letI`, `simp`, `refine` are NOT — flag/strip if any appear in rendered text).
- Strip any per-iteration / project-history narrative from rendered prose
  (iter-NNN references, "this iter", attempt logs). Keep it math-only.
- VALIDATE the `% SOURCE QUOTE` blocks against the cited local source files
  (`references/stacks-modules.tex` for the two Stacks lemmas) — confirm
  byte-accuracy; the writer reports them unchanged but verify.
- Do NOT add or remove `\leanok` / `\mathlibok` markers.
- Do NOT delete the new `\lean{}` pins on the two FlatBaseChange blocks.
- Confirm no `\uses{}` cycles were introduced (the writer reports
  `lem:pullback_unit_iso` no longer depends on `lem:pullback_tensor_iso`).

## Authorized write-domain
Both chapter files above + `references/**` (for source-quote validation / a child
reference-retriever if a quote needs re-fetching).
