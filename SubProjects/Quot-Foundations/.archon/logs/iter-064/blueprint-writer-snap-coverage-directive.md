# Blueprint-writer directive — Picard_SectionGradedRing.tex coverage debt + localIso pin

Chapter: `blueprint/src/chapters/Picard_SectionGradedRing.tex` (Lean file
`AlgebraicJacobian/Picard/SectionGradedRing.lean`).

## Task 1 — coverage-debt blocks (6 Lean decls with no blueprint entry)
Add one terse block each (project-bespoke, NO `% SOURCE` lines needed; statement + `\label` +
`\lean{}` + accurate `\uses{}` + one-line informal proof). Read the decl sites in the Lean file
to state them faithfully and derive the real `\uses{}`:
- `AlgebraicGeometry.Scheme.Modules.objRestrict` (def) and its three simp lemmas
  `objRestrict_apply`, `objRestrict_comp`, `objRestrict_id` — the abelian-carrier restriction
  map of a presheaf of modules along an inclusion of opens (the iter-060 carrier-gap fix).
  Suggested labels: `def:snap_objRestrict`, `lem:snap_objRestrict_apply/_comp/_id`.
- `AlgebraicGeometry.Scheme.Modules.opensTopology` (def) — the Grothendieck topology on
  `Opens X` used by the sheafification discussion. Label `def:snap_opensTopology`.
- `AlgebraicGeometry.Scheme.Modules.relTensorActL_proj_eq` — the cofork condition
  `relTensorActL ≫ relTensorProj = relTensorActR ≫ relTensorProj`; it is the Lean realisation of
  the cofork-condition paragraph of `lem:relativeTensor_as_coequalizer`'s proof. Label
  `lem:snap_relTensorActL_proj_eq`; `\uses` should include `def:relTensorActL`,
  `def:relTensorActR`, `def:relTensorProj`, `lem:relativeTensor_objectwise_coequalizer`.
Place each block adjacent to the existing material it supports; wire parents' `\uses{}` only
where genuinely accurate.

## Task 2 — pin `lem:snap_ztensor_whisker_localIso`
The block (~L604) has a `% NOTE: Lean decl name pending` and no `\lean{}`. A scaffolder is
creating the declaration `AlgebraicGeometry.Scheme.Modules.ztensor_whisker_localIso` THIS phase.
Add `\lean{AlgebraicGeometry.Scheme.Modules.ztensor_whisker_localIso}` and drop the pending NOTE.

## Constraints
- Do NOT alter the statements of `lem:isIso_sheafification_whiskerRight_unit`,
  `lem:relativeTensor_as_coequalizer`, or any existing block's mathematical content.
- NEVER add/remove `\leanok`. `\mathlibok` only if you author a genuine new Mathlib anchor
  (none expected here).
- Keep prose math-only — no Lean tactic syntax in visible text.
