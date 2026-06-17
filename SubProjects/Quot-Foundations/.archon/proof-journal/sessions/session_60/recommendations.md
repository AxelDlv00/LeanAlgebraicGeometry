# Recommendations — next plan iter (iter-061)

## HIGH — GR-quot C2 lane is now unblocked; seed its building-blocks first
The OOM ceiling is RESOLVED (cold build 22s, axiom-clean) — the C2 lane can proceed. But lvb-grquot
flags **3 blueprint `\lean{}` pins that name absent Lean decls**; these are prerequisites for
`bundleTransition_cocycle` and MUST be created before the C2 prover can close:
1. `matrixToFreeIso_mul` — one-liner (`matrixEnd_comp` + `matrixToFreeIso_hom`).
2. `bundleTransition_cocycle_matrix` — stepping stone (Cramer: `X^J_K = (X^I_J)⁻¹ X^I_K`).
3. `bundleTransition_cocycle_transport` (`lem:gr_bundleCocycle_transport`) — its blueprint sketch is
   **under-specified**: it names ingredients (`pullbackBaseChangeTransport`, `pullbackComp`,
   `pullbackCongr`, `glueData_bridge_*`, `matrixToFreeIso_mul`, `pullbackFreeIso`) but omits the explicit
   `pullbackComp` reassociation sequence on source/middle/target free sheaves. **Dispatch effort-breaker /
   blueprint-writer to expand it** (style of `pullbackFreeIso_comp`) BEFORE sending the C2 prover, else
   iter-061 rediscovers the reassociation from scratch. (effort-breaker already split C2 into L1/L2/L3 in
   iter-060 — feed those into the writer.)

## HIGH — SNAP: seed `relativeTensorCoequalizerIso` (next downstream node)
SectionGradedRing is now **0 sorries** — the objectwise coequalizer rows (actL/actR/proj) are complete.
The next node `relativeTensorCoequalizerIso` (step-2 promotion via `evaluationJointlyReflectsColimits` +
apex identification via `PresheafOfModules.Monoidal.tensorObj_obj`) is a NEW decl not yet in the file.
lvb-snap confirms the blueprint sketch (lines 754–810) is **adequate** to guide it. Plan agent: seed the
decl + dispatch a prover. Reusable pattern available in-file: bare-`ℤ`-square-via-`TensorProduct.ext'`+`rfl`
then transport to `Ab` (the relTensorProj/actL/actR recipe).

## MEDIUM — coverage debt (1-to-1, plan agent to blueprint)
`archon dag-query unmatched` = 16 `lean_aux` nodes with no blueprint entry. Substantive ones to add `\lean{}`
blocks for (read the Lean for the statement):
- GR (`GrassmannianQuot.lean`): `pullbackFreeIso_trans_symm_eqToIso` (NEW iter-060, load-bearing for the
  leaner `bundleTransition_self`), `bundleTransitionData`, `universalMinorInv_self`, `biproduct_matrix_comp`,
  `bundleMatrix_cancel`, `hasFiniteBiproducts_modules`, `scalarEnd_sum`, `scalarEnd_val_app`,
  `scalarEnd_val_app_one`, `unitHomEquiv_scalarEnd`, `pullbackFreeIso_eqToHom` (minor).
- SNAP (`SectionGradedRing.lean`): `objRestrict`, `objRestrict_apply`, `objRestrict_id`, `objRestrict_comp`,
  `opensTopology` are **private** — pure technical plumbing, NO blueprint debt (per lvb-snap). Skip.

## MEDIUM — stale `.lean` comments (review cannot edit; flag for a writer/refactor pass)
lean-auditor iter060 (3 major + 1 minor), all stale comments inside otherwise-correct code:
- `GrassmannianQuot.lean` L299–310: `glue` section comment names the wrong path
  (`overRestrictPullbackIso`/`existsUnique_gluing'`) and says the body is "still to be filled" — the body IS
  the descent-equalizer construction, complete at L444.
- `GrassmannianQuot.lean` L1141–1142: inside the COMPLETE `functor.map_id` proof, calls
  `pullbackFreeIso`/`pullbackId` coherence "the open obstacle" — resolved right below via `pullbackFreeIso_id`.
- `SectionGradedRing.lean` L668–721: header "DEFERRED (handoff)" + iter-056 BLOCKER note — but
  `relTensorActL/ActR/relTensorProj` are ALL complete (via `objRestrict`, the BLOCKER's own "next-iter
  option 1"). L723–805 (minor): ~80 lines of superseded handoff noise.

## MINOR — blueprint hygiene
- `lem:snap_ztensor_whisker_localIso` (SectionGradedRing chapter, ~L603): `% NOTE: Lean decl name pending`,
  no `\lean{}` pin — add when the decl lands (downstream of `relativeTensorCoequalizerIso`, not blocking).
- 9 `private` SectionGradedRing decls carry `\lean{}` pins — informational only (won't resolve via
  `lean_verify`); acceptable.
- `def:relTensorProj`: `\leanok` on a standalone line (blank above) — cosmetic, parses fine.

## Do NOT
- Do NOT re-attempt `bundleTransition_self` with a different heartbeat budget — a passing kernel check uses
  the same memory regardless; the leaner iso-level term is the fix and it is landed.
- Do NOT try to `rw`/`simp` the matrix collapse into the unfolded `bundleTransition` — Modules-diamond
  (hidden implicit base scheme) ⇒ "pattern not found"/"no progress"; the `erw [hB]` route is required.
- FBC stays PARKED (off critical path; un-parks only if a lane frees with `_legs_conj` still open).

## Reusable patterns (also in PROJECT_STATUS Knowledge Base)
- **Ab coequalizer-row naturality:** bare-`ℤ`-square via `TensorProduct.ext'`+`rfl`, then transport to `Ab`.
- **Kernel-OOM control:** generic `subst`-proved iso-level helper keeps concrete immersions opaque; validate
  with real `lake build` (LSP hides `(kernel) deterministic timeout`).
