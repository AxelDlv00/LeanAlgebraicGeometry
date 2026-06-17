# Lean Audit Report

## Slug
iter061

## Iteration
061

## Scope
- files audited: 1
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (7-way private helper duplication)
- **excuse-comments**: none

- **notes**:

  **New closed theorems (iter-061 additions)**

  - `matrixToFreeIso_mul` (lines 219–224): Clean one-liner via `matrixToFreeIso_hom` + `matrixEnd_comp`. Correct.

  - `bundleTransition_cocycle_matrix` (lines 816–878): Substantive proof (~60 LOC) reducing the Cramer-inverse cocycle over the triple-overlap ring to the I-minor of `cocycle_imageMatrix_eq'`. Strategy is sound; proof carries through the `hcol`, `hsplit`, `hχ`, `e1`, `hXJI` decomposition and closes without sorry. Axiom-clean.

  **The C2 sorry in `bundleTransition_cocycle` (lines 891–945)**

  - The theorem signature is the exact `_hC2` hypothesis of `Scheme.Modules.glue` instantiated at `theGlueData`/`bundleTransitionData`. Honest and non-laundering.
  - The `apply Iso.ext` at line 915 is legitimate proof scaffolding: it reduces the iso-level equality to a `.hom` morphism equality, which is where L3 (the matrixEnd-under-pullback naturality) must operate. The sorry at line 945 sits correctly at the resulting `.hom` goal.
  - The NOTE comment (lines 888–944) is a detailed, accurate roadmap: it correctly identifies L1 and L2 as done and states the MISSING piece (part (a) the pullback naturality of `matrixEnd`, part (b) the `ΓSpecIso` alignment). **This is an honest sorry, not a laundering sorry.**

  **Seven ported `'` private helpers (lines 675–809)**

  - `mul_submatrix_col'` (675–678) vs `mul_submatrix_col` in GrassmannianCells.lean (165–168): **identical signature and proof body**.
  - `map_nonsing_inv'` (681–686) vs `map_nonsing_inv` (300–305): **identical**.
  - `map_map_eq_of_comp'` (689–693) vs `map_map_eq_of_comp` (479–482): **identical**.
  - `isUnit_algebraMap_away_left'` (696–701) vs `isUnit_algebraMap_away_left` (402–407): **identical**.
  - `inv_mul_inv_mul_cancel'` (704–708) vs `inv_mul_inv_mul_cancel` (514–518): **identical**.
  - `imageMatrix_map_eq'` (711–734) vs `imageMatrix_map_eq` (487–510): **same signature**; proof body adapts by calling the primed helper names (`map_map_eq_of_comp'`, `map_nonsing_inv'`) instead of the originals — necessary because the originals are private.
  - `cocycle_imageMatrix_eq'` (739–809) vs `cocycle_imageMatrix_eq` (524–599): **same signature**; proof body calls the primed helper names throughout — same reason.

  The root cause of all seven duplicates is that the originals are declared `private` in GrassmannianCells.lean and are therefore inaccessible even through the import. This is a known Lean 4 scoping constraint. The docstrings on each ported copy explicitly state "Port of `GrassmannianCells.xxx` (private there)." so the duplication is acknowledged, not hidden.

  **Stale section header NOTE (lines 319–323)**

  The `/-! ## Gluing a sheaf of modules ... -/` section header (lines 311–323) contains:
  ```
  NOTE (scaffold): the body and the module-cocycle hypotheses on `g` are still to be filled;
  the transition data `g` (per-overlap pullback isos) is recorded in the signature, the
  multiplicative cocycle conditions remain to be added before the construction is closed.
  ```
  Both claims are now false: the `glue` definition at lines 394–456 has a complete body (`equalizer a b`), and the cocycle hypotheses `_hC1` / `_hC2` ARE present in the signature (lines 401–418). This NOTE was accurate at an earlier iteration but was never removed and now actively misleads readers into thinking the code is incomplete.

  **Remaining honest sorries (not this iter's additions, noted for completeness)**

  - `universalQuotient` (line 965): `:= sorry` with an accurate NOTE that it rides on the bundle cocycle.
  - `tautologicalQuotient` (line 976): `:= sorry` with an accurate NOTE.
  - `represents` (line 1470): `:= sorry` with an accurate NOTE.
  All three are downstream dependents of `bundleTransition_cocycle` and will be resolved once L3 is closed.

## Must-fix-this-iter

None. No excuse-comments on load-bearing declarations, no weakened/wrong definitions, no suspect bodies.

## Major

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:319–323` — **Stale scaffold NOTE in section header**: claims `glue`'s body and cocycle conditions are "still to be filled" and "remain to be added", but both are fully in place (body = `equalizer a b`, conditions = `_hC1`/`_hC2` in signature). Misleads readers about the completeness of `Scheme.Modules.glue`.

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:675–809` — **Seven verbatim private helper duplicates** (`mul_submatrix_col'`, `map_nonsing_inv'`, `map_map_eq_of_comp'`, `isUnit_algebraMap_away_left'`, `inv_mul_inv_mul_cancel'`, `imageMatrix_map_eq'`, `cocycle_imageMatrix_eq'`), each an exact copy of a private lemma in `GrassmannianCells.lean`. Caused by `private` scoping preventing cross-file access. No signature drift; acknowledgement comments are present. Remediation: make the seven originals in GrassmannianCells.lean non-private (or move them to a shared section not under `private`).

## Minor

None.

## Excuse-comments (always called out separately)

None. All scaffold NOTEs accurately describe the actual state of the code; none admit incorrect/wrong definitions.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 0
- **excuse-comments**: 0

Overall verdict: GrassmannianQuot.lean is axiom-clean and mathematically sound for iter-061; the two major findings (one stale section-header NOTE, one acknowledged 7-way private duplication) are structural debt that does not block downstream work.
