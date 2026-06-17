# Effort-breaker directive — split `lem:gr_baseChange_bridge`

## Target
`lem:gr_baseChange_bridge` in `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (~L1096).
The 3-iter recurring GR-quot blocker ("needs Cells internals"): identify the global-sections
comorphisms of the glue datum's two projections and triple transition with the localised
coordinate-ring homomorphisms `awayInclLeft` / `awayInclRight` / `Θ_IJ` over which the matrix
cocycle `lem:gr_bundleCocycle_matrix` is stated.

## Granularity
One level: split into THREE sub-lemmas, one per identification —
(b1) first projection ↦ `awayInclLeft` (`def:gr_away_incl_left`);
(b2) second projection ↦ `awayInclRight` (`def:gr_away_incl_right`);
(b3) triple transition `t'_{IJK}` ↦ `Θ_IJ` (`def:gr_cocycle_theta_ij`).
If the affine-chart global-sections identification (`ΓSpecIso`-style: Γ of an affine chart ≅ its
coordinate ring, naturality turning a Spec morphism's comorphism into the inducing ring hom) is a
shared step, factor it as a fourth shared helper sub-lemma rather than repeating it three times.
The residual `lem:gr_baseChange_bridge` becomes the assembly consuming b1–b3.

## Proof structure
Cut along the existing proof block: the charts/overlaps are affine = Spec of localised coordinate
rings; the glue datum `def:gr_the_glue_data` assembles its `f`/`t`/`t'` as Spec morphisms of these
ring homs (`def:gr_transition`, chartIncl/chartTransition/chartTransition' in
`AlgebraicJacobian/Picard/GrassmannianCells.lean` — read the Lean file and
`blueprint/src/chapters/Picard_GrassmannianCells.tex` to cut at the TRUE seams of how `theGlueData`
(L1141), `chartTransition` (L703), `chartTransition'` (L834), `transitionMap` (L245),
`awayInclLeft/Right` (L310/322), `cocycleΘIJ` (L422) are actually assembled — all public decls).
Each sub-lemma must carry its own statement, informal proof, and accurate `\uses{}` (cross-chapter
refs to the Cells chapter labels are expected). New Lean names: propose them under
`AlgebraicGeometry.Grassmannian.baseChange_bridge_left/right/transition` (forward pins, decls not
yet realised — add the same `% NOTE: forward declaration` convention the chapter already uses).

## Constraints
Edit ONLY `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (write-domain enforced). Do NOT
touch `\leanok`. Keep `lem:gr_bundleCocycle_transport` / `lem:gr_bundleCocycle_mul` `\uses` lists
consistent with the new sub-lemma labels.
