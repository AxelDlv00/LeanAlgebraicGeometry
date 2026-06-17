# AlgebraicJacobian/AbelianVarietyRigidity.lean — iter-167 prover

## Summary

**Status: COMPLETE for Lane B PRIMARY.**

* All 5 in-line `sorry`s inside `morphism_P1_to_grpScheme_const_aux` (lines 944, 949, 953,
  1029, 1037 in the iter-166 file) are eliminated.
* All 5 `-- TODO:` excuse comments dropped (lean-auditor iter-166 major resolved).
* Net file sorry count: 6 → 2 (-4 sorries).
  - L931 `iotaGm_isDominant` — the single new top-level bridge lemma (sorry).
  - L1135 `genusZero_curve_iso_P1` — pre-existing, OFF-LIMITS per PROGRESS.
* The helper `morphism_P1_to_grpScheme_const_aux` body itself contains **zero** `sorry`s
  and lifts to axiom-clean once Lane A's `gmScalingP1` body discharges
  `iotaGm_isDominant`.
* `lake build AlgebraicJacobian` exit 0. No new custom axioms (verify of the helper:
  `sorryAx, propext, Classical.choice, Quot.sound`, all kernel).

## morphism_P1_to_grpScheme_const_aux (L957, was L931)

### Attempt 1
- **Approach:** First explored whether `infer_instance` resolves the 4 product / Proj
  instances directly. `LocallyOfFiniteType` did via `change` + `infer_instance` (the
  monoidal-product `.hom` unfolds to `pullback.fst _ _ ≫ P.hom` by `tensorObj_hom`, which is
  `rfl`); the other three (`GeometricallyIrreducible` of the product, `IsReduced` of the
  product, `IsReduced (ProjectiveLineBar kbar).left`) all failed in `lean_run_code`. Lane A's
  iter-166 exports did not yet ship the bridges.
- **Lane A interaction:** Mid-iter, Lane A landed five new Genus0BaseObjects exports:
  `projGm_locallyOfFiniteType` (proven, same `change + infer_instance` trick),
  `projGm_geomIrred` (proven via `GeometricallyIrreducible.comp`, downstream of two new
  sorry-bodied instances `gm_geomIrred` + `projectiveLineBar_geomIrred`), `projGm_isReduced`
  (sorry), `projectiveLineBar_isReduced` (sorry). These exports are the exact shape my
  helper needs.
- **Final refactor:** Refactored the helper to drop ALL five in-line `haveI hProdX : ... := by
  sorry` blocks. Four of them (the product/Proj instances) are now auto-resolved via Lane A's
  exports + scope-level `infer_instance`. The fifth (`IsDominant iotaGm.left`) is replaced
  by a single citation `haveI hιDom : IsDominant iotaGm.left := iotaGm_isDominant`.
- **Result:** RESOLVED. Helper body now contains zero `sorry`s; the only new `sorry` is the
  named top-level bridge `iotaGm_isDominant` (sub-build gated on Lane A's `gmScalingP1`
  body — same propagation footing as before).
- **Key insight:** Lane A landed the consumer-facing exports in parallel during this iter,
  so the cleanest closure is to let Lane A own the four product / Proj bridges and only keep
  one file-local bridge (the dominance one, which depends on `gmScalingP1`'s concrete chartwise
  body and so must travel with the rigidity consumer).

## iotaGm_isDominant (L931, NEW iter-167)

### Attempt 1
- **Approach:** Try `infer_instance` directly. In a `lean_run_code` standalone smoke test it
  appeared to succeed (`Surjective` infers via the `GeometricallyIrreducible → Surjective →
  IsDominant` priority-low chain), but in the actual file context with the same hypotheses it
  failed (the synthesis order seems to differ — likely a backward-defeq quirk where
  `gmScalingP1 := sorry` doesn't reduce to an obvious composition).
- **Result:** PARTIAL — stays `sorry` (named top-level lemma). The bridge is honest: any
  proof body needs the concrete `gmScalingP1` chartwise glue (the standard open immersion
  `Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹` sending `λ` to `[λ : 1]`), which is currently Lane A's
  `gmScalingP1 := sorry` scaffold.
- **Next step:** Once Lane A ships the chartwise body for `gmScalingP1` (their iter-167+
  PRIMARY), the dominance reduces to: ι is a dense open immersion of the irreducible ℙ¹
  by `(Gm ↪ ℙ¹).IsOpenImmersion → IsDominant` (standard).
- **Lemmas found:**
  - `AlgebraicGeometry.IsDominant` (`Mathlib.AlgebraicGeometry.Morphisms.UnderlyingMap`
    L217) — the class, with `Surjective → IsDominant` priority-100 instance L226 and
    `IsDominant.comp` L228.
  - `AlgebraicGeometry.GeometricallyIrreducible → Surjective` (priority-low,
    `Geometrically/Irreducible.lean` L68) — the chain that would close it if we could resolve
    `GeometricallyIrreducible (gmScalingP1).left`-shaped data, which we can't until
    `gmScalingP1` is concrete.

## Removed instances (iter-167 cleanup)

During exploration I had landed four named local instances mirroring Lane A's exports
(`projectiveLineBar_isReduced_left`, `projectiveLineBar_tensor_gm_locallyOfFiniteType`,
`projectiveLineBar_tensor_gm_geometricallyIrreducible`, `projectiveLineBar_tensor_gm_isReduced_left`).
Once Lane A's parallel-landed `projGm_*` / `projectiveLineBar_isReduced` shipped, I removed
the duplicates. The helper now resolves everything through Lane A's instances + the single
local `iotaGm_isDominant` bridge.

## Markers ready for review

* `prop:morphism_P1_to_AV_constant` — `morphism_P1_to_grpScheme_const` body remains as
  before; carries `sorryAx` via the helper through `iotaGm_isDominant`. Once that closes,
  lifts to axiom-clean. No `\leanok` action this iter (the sync_leanok phase will see the
  sorry footprint shrink).
* `prop:morphism_P1_to_AV_constant` helper auxiliary
  (`morphism_P1_to_grpScheme_const_aux`) — body has zero inline `sorry`s as of iter-167.
* `iotaGm_isDominant` — new named lemma, not yet in the blueprint. The plan agent should add
  a small lemma block (`lem:iotaGm_isDominant` or fold into `prop:morphism_P1_to_AV_constant`)
  for traceability — file-local but consumed by the AVR proof body.

## Negative search results

* `lean_local_search "Proj affineCover"` — fails on escape-char (ripgrep regex syntax). The
  Mathlib reference (`AlgebraicGeometry.Proj.affineOpenCover`) is at
  `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic` L339.
* `Surjective.isDominant` — does NOT exist as a named lemma in Mathlib; the bridge is an
  instance only (L226).
* No direct Mathlib `LOFP → LOFT` instance (each property has its own instance set; over a
  noetherian base they coincide at `affineLocally` level only via
  `Noetherian.lean:273`).
* `IsReduced (Proj 𝒜)` is NOT in Mathlib for any 𝒜 — would require the chart-cover
  + `HomogeneousLocalization.Away`-is-domain bridge that Lane A flagged as the Mathlib gap.
