# Blueprint Writer Report

## Slug
coverage-debt

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:isScalarTower_restrictScalars_obj}`/`\lean{AlgebraicGeometry.isScalarTower_restrictScalars_obj}`
  — scalar-tower structure `IsScalarTower R S` on a bundled restriction-of-scalars module
  `(restrictScalars_{R→S}) M`; one-line proof via the algebra-map scalar-tower criterion. Placed
  immediately before the `tile_section_localization` NOTE/block. No external source (Archon/Mathlib
  glue) → no `% SOURCE` lines, per directive citation discipline.
- **Added lemma** `\lemma`/`\label{lem:tileReconcileEquiv}`/`\lean{AlgebraicGeometry.tileReconcileEquiv, …_apply, …_symm_apply}`
  — the `R`-linear reconciliation isomorphism `(restrictScalars_{R→R_g}) Γ_{R_g}(V, F_(g)) ≅ Γ_R(ι(V), F)`,
  identity on carriers, `R`-linearity = `tile_scalar_compat'`. `\uses{lem:tile_scalar_compat_genV,
  lem:modulesSpecToSheaf_smul_eq}` on both statement and proof. The two `private @[simp]` apply lemmas
  are bundled into this block's `\lean{...}` list (task 3). Placed immediately before
  `lem:tile_section_localization`. Archon-original scaffolding → no `% SOURCE` lines.
- **Bundled private helper** `AlgebraicGeometry.tile_restrict_map_apply` into the `\lean{...}` list of
  the `lem:tile_section_localization` statement block (task 3) — the `rfl` "tile restriction = F
  restriction over image opens" used in the transport.
- **Fixed dependencies** `lem:tile_section_localization` statement `\uses{}` — REMOVED
  `lem:qcoh_finite_presentation_cover` (Lean statement takes a presentation `P` directly; the edge
  belongs on `lem:qcoh_section_isLocalizedModule`, which already carries it). The descriptive prose
  `\ref{lem:qcoh_finite_presentation_cover}` (naming where `g` comes from) is kept — a textual
  cross-reference, not a dependency edge; mathematical content unchanged.
- **Fixed dependencies** `lem:tile_section_localization` proof `\uses{}` — REMOVED
  `lem:tile_scalar_compat` (V=⊤; the Lean proof routes the V=⊤ open through `tileReconcileEquiv`/
  `tile_scalar_compat'`, never calling the V=⊤ lemma directly), KEPT `lem:tile_scalar_compat_genV`,
  ADDED `lem:tileReconcileEquiv` and `lem:isScalarTower_restrictScalars_obj`.
- **Revised** `lem:tile_section_localization` proof prose — minimal Step-4 note that the two scalar
  reconciliations are packaged uniformly as `lem:tileReconcileEquiv`, and a Step-5 parenthetical that
  the scalar tower `R → R_g` is supplied structurally by `lem:isScalarTower_restrictScalars_obj`. These
  ground the two new `\uses{}` edges (math statement/sketch otherwise unchanged).

## Cross-references introduced
- `\uses{lem:tile_scalar_compat_genV, lem:modulesSpecToSheaf_smul_eq}` in `lem:tileReconcileEquiv`
  (statement + proof) — both labels exist in this chapter (verified, lines 4692 / 4412 pre-edit).
- `\uses{lem:tileReconcileEquiv, lem:isScalarTower_restrictScalars_obj}` added to
  `lem:tile_section_localization` proof — both new, same chapter.

## DAG verification (leandag / archon dag-query, post-rebuild)
- `archon dag-query unmatched`: dropped 6 → **1** (only the pre-existing dead
  `AlgebraicGeometry.CechAcyclic.affine` remains, effort ∞ / sorry). ✓
- `leandag build --json` → `unknown_uses: []` (no broken `\uses{}`). ✓
- `leandag query --isolated --chapter Cohomology_CechHigherDirectImage`: neither new node isolated —
  `tileReconcileEquiv` is used-by `tile_section_localization` and uses 2 prior lemmas;
  `isScalarTower_restrictScalars_obj` is now used-by `tile_section_localization`'s proof (Step-5 base-ring
  descent). (An interim `archon dag-query isolated` flagged `isScalarTower_…` from a stale cache; a
  `leandag build` rebuild cleared it.) ✓
- Statement `\uses{}` no longer contains `lem:qcoh_finite_presentation_cover`; proof `\uses{}` no longer
  contains `lem:tile_scalar_compat`, and contains `lem:tile_scalar_compat_genV` + `lem:tileReconcileEquiv`. ✓
- begin/end balance in the inserted region: 5 begins / 5 ends. ✓

## References consulted
None — this was a pure wire-up + coverage pass on Archon-original scaffolding; the two new blocks have
no external source (per directive: omit `% SOURCE` lines). Lean signatures were read directly from
`AlgebraicJacobian/Cohomology/QcohTildeSections.lean` (lines 1008–1139) to keep the informal statements
faithful to the actual decls.

## Macros needed (if any)
None. New blocks use only existing macros (`\Spec`, `\Gamma`, `\mathcal`, `\mathrm`, `\text`, `\widetilde`).

## Notes for Plan Agent
- The 5 Lean decls created by the iter-046 keystone landing now have 1-to-1 blueprint coverage; the
  only remaining `unmatched` node is `AlgebraicGeometry.CechAcyclic.affine` (a pre-existing dead/sorry
  decl, effort ∞) — out of scope here, but it is the last 1-to-1 gap and a candidate for a future
  cleanup (either give it a block or retire the decl).
- I went one edge beyond the directive's explicit task-4 proof-uses list: I added
  `lem:isScalarTower_restrictScalars_obj` to `lem:tile_section_localization`'s proof `\uses{}` (with a
  grounding Step-5 prose parenthetical). Rationale: the directive authorized an empty `\uses{}` on that
  new instance, which left it an isolated node; the writer mandate is to wire isolated nodes via the
  real missing edge, and the Step-5 base-ring descent genuinely consumes that `IsScalarTower R R_g`
  instance structurally. If you prefer it to remain a deliberately-isolated Mathlib-glue leaf, this one
  edge can be reverted.

## Strategy-modifying findings
None.
