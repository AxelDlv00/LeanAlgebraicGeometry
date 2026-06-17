# Recommendations — next plan iter (post iter-061)

## 1. HIGH — GR C2/L3: standalone iter-062, build the two named infra pieces
`bundleTransition_cocycle` (C2, L891) is the lone GR frontier; L1+L2 are in hand (axiom-clean). The
sorry is honest; closing it needs net-new diamond infrastructure (read `informal/bundleTransition_cocycle_L3_transport.md` first):
- **(a)** matrixEnd-under-pullback naturality: `(pullback p).map (matrixEnd M) = pullbackFreeIso.hom ≫ matrixEnd (p.appTop.mapMatrix M) ≫ pullbackFreeIso.inv`. Crux = `scalarEnd` naturality under `Scheme.Modules.pullback`, conjugated by `pullbackObjUnitToUnit` (the diamond).
- **(b)** base-change bridge identifying scheme-pullback maps `Γ(U^I_J)⟶Γ(V_IJK)` with L1's ring homs `cocycleΘ`/`awayIncl` (via `ΓSpecIso` naturality + how `theGlueData` is built).
Each ~50–100 LOC term-mode. The planner already pre-broke C2 → L1/L2/L3 (effort-breaker iter-060). Consider an effort-breaker pass on **L3 alone** (fine granularity) to split (a) vs (b) into separate frontier lemmas before the prover — the `scalarEnd`-naturality crux (a) is the genuinely hard half. `apply Iso.ext` already lands as the partial.

## 2. MEDIUM — kill the recurring multi-pin `\leanok` strip (sync gap, 2 iters running)
`sync_leanok` strips the manual `\leanok` on `lem:relativeTensor_objectwise_coequalizer` (22-name `\lean{}`) EVERY iter; review re-applies it. Same class now affects `def:gr_rankQuotient` (8-name). The deterministic script can't evaluate multi-`\lean{}` fields. Structural fix options for the planner: (a) split each multi-pin block into per-name sub-blocks (one `\lean{}` each) so sync can evaluate them; or (b) flag to the user that `sync_leanok` needs multi-pin support. Until fixed, review will keep manually overriding — log it but it's avoidable churn.

## 3. MEDIUM — consolidate the 7 private GrassmannianCells ports (visibility-only)
L1 needed 7 verbatim `… '` copies of `private` GrassmannianCells helpers (`cocycle_imageMatrix_eq'`, `imageMatrix_map_eq'`, `inv_mul_inv_mul_cancel'`, `isUnit_algebraMap_away_left'`, `map_map_eq_of_comp'`, `map_nonsing_inv'`, `mul_submatrix_col'`). No signature drift. Clean fix = a refactor making the 7 Cells originals **non-private**, then delete the ports from GrassmannianQuot. Removes the duplication AND the coverage debt (item 4). Pure visibility change — no signature/proof change; cheap refactor subagent target.

## 4. LOW — 1:1 coverage debt (unmatched=18)
No blueprint entry for these `lean_aux` decls. Most are `private` helpers (low priority per the private-decl doctrine). Disposition:
- **7 ported `'` helpers** (this iter): resolve via item 3 (delete ports) rather than blueprinting duplicates.
- **GR carryover privates:** `scalarEnd_val_app`, `scalarEnd_val_app_one`, `unitHomEquiv_scalarEnd`, `biproduct_matrix_comp`, `bundleMatrix_cancel`, `hasFiniteBiproducts_modules` — planner may mark `private` (hygiene) or add thin `\lean{}` blocks.
- **SNAP carryover privates:** `objRestrict`/`_apply`/`_comp`/`_id`, `opensTopology` — already private per iter-058 ("no debt").

## 5. LOW — stale `.lean` comment (review can't edit `.lean`)
GrassmannianQuot.lean L319–323 section header `/-! ## Gluing a sheaf of modules … -/` claims `glue`'s body + cocycle conditions are "still to be filled" — both are done (glue closed iter-056). The prover or planner should refresh this NOTE next time the file is opened (cosmetic).

## Do NOT re-assign
- `universalQuotient` / `tautologicalQuotient` / `represents` (GrassmannianQuot): gated on C2 (`glue` needs `_hC2`). Not attemptable until `bundleTransition_cocycle` closes. Their statement-block `\leanok` is correct (formalized, sorry present) — NOT a marker bug.
- FBC `_legs_conj`: parked, off critical path (unchanged); un-parks only if GF+QUOT+GR all close with it open.
