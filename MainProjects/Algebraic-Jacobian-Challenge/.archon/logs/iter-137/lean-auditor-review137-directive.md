# Lean Auditor Directive

## Slug
review137

## Scope (files)
all `.lean` files under `AlgebraicJacobian/`.

## Focus areas (optional)
Pay extra attention to `AlgebraicJacobian/Cotangent/GrpObj.lean`. This is the
only file edited this iteration. The edits were **docstring-only** — no
signature changes, no body changes, no new declarations. The 4 docstring
sites updated are:

- L427–L450 (section header for the piece (i.b) helper sub-lemmas block)
- L479–L499 (docstring of `relativeDifferentialsPresheaf_basechange_along_proj_two`)
- L525–L527 (docstring of `relativeDifferentialsPresheaf_restrict_along_identity_section`)
- L616–L623 (docstring of `mulRight_globalises_cotangent`)

Each describes the iter-137 PARTIAL outcome on `_basechange_along_proj_two`
(L500) and the inverse-direction-via-adjunction analysis. Audit specifically
for: (a) whether the new docstrings contain excuse-comments ("temporary",
"will fix later", etc.) that would be classified as red flags, (b) whether
the new prose accurately describes the body state (body is `sorry`; analysis
notes are forward-looking statements about iter-138+ work, not lies about
the current body), and (c) whether the file as a whole still satisfies the
audit checklist.

The body of `_basechange_along_proj_two` remains `:= sorry` (line 508) — this
is an iter-135 honest-scaffold sorry with intended-type signature, NOT a
hollow tautology placeholder. Likewise for `mulRight_globalises_cotangent`
(L635). These honest-scaffold sorries are sorry_analyzer-visible and are
the iter-138+ work targets.

## Known issues
- 5 known sorries in the project (`Jacobian.lean:197`, `Jacobian.lean:223`,
  `Cotangent/GrpObj.lean:508`, `Cotangent/GrpObj.lean:635`,
  `RigidityKbar.lean:87`). These are honest scaffolds with intended-type
  signatures — do NOT re-flag as must-fix.
- File-header line anchors in `Cotangent/GrpObj.lean` at L61/L107/L146/L155/L160
  carry stale "line 198/244 below" references from iter-135 — known carry-over
  drift, do NOT re-flag (will refresh once line numbers stabilise after Step 2
  closure).
- Pre-existing long-line linter warning on `Jacobian.lean:275` — protected
  signature, do NOT reformat.

## Report path
`.archon/task_results/lean-auditor-review137.md`
