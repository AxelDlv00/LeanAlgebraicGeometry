# Lean Auditor Directive

## Slug
review145

## Scope (files)
All `.lean` files under the project tree:

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean`
- everything under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/` (depth-first; do not skip)

Use `find` / `Glob` to enumerate exhaustively. Read every file.

## Focus areas (optional)

1. **`AlgebraicJacobian/Cotangent/ChartAlgebra.lean`** (NEW iter-145). Five
   declarations carry `: True := sorry` placeholder signatures. The file
   header documents this as intentional iter-145 scaffolding pending
   iter-146 signature commitment, with explicit `TODO iter-146` markers
   on every block. Audit these carefully: are the placeholder shapes
   acceptable scaffolding (the directive explicitly authorised them
   citing the iter-128–iter-131 cotangent body-shape refactor as a
   cautionary tale on committing wrong signatures prematurely), or do
   they cross into excuse-comment territory? Five separate top-level
   `: True := sorry` placeholders is unusual; you must judge whether
   the scaffolding-is-honest reading holds or whether this is
   weakened-wrong-definition pattern in a new costume.

2. **`AlgebraicJacobian/Cotangent/GrpObj.lean`** (excised iter-145). The
   file shrank from ~903 → ~631 LOC with the deletion of five
   declarations (three named excise targets + two dependency cascade
   targets). Audit for: stale section-header `/-! ... -/` prose
   referencing deleted declarations; stale comment blocks; orphan
   helpers (`shearMulRight`, `shearMulRight_hom_fst`,
   `shearMulRight_hom_snd`, `schemeHomRingCompatibility`,
   `isIso_of_app_iso_module`,
   `relativeDifferentialsPresheaf_restrict_along_identity_section`)
   that the iter-145 refactor identified as no-longer-consumed but
   chose not to delete (decision preserved for iter-146 cosmetic
   pass).

3. `AlgebraicJacobian/Jacobian.lean` and `AlgebraicJacobian/RigidityKbar.lean` —
   intentionally-gated scaffolds. Confirm that comment status banners
   are accurate to the current state.

## Known issues
- `Cotangent/GrpObj.lean` orphan-helper list per the iter-145 refactor
  report is intentional; flag if you concur they are now uncalled, but
  do not re-flag them as critical unless the audit finds new evidence
  of pollution.
- Two iter-145 EXCISE breadcrumb comment blocks inside `GrpObj.lean`
  (around the L297-area and the L428–L525-area) record the iter-145
  excise reason + pointer to `ChartAlgebra.lean`. These are intentional
  audit breadcrumbs; do not flag them as stale unless they actively
  mislead a reader.

Write your report per the descriptor's template.
