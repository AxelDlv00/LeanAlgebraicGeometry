# Iter-065 objectives

2 prover lanes, both default `prove` mode (targeted single-leaf). Blueprint gate CLEARS for both files
(blueprint-reviewer `rescope065`, `correct: true`, 0 must-fix).

## Lane 1 — `CechSectionIdentification.lean` (prove)
Close the 2 remaining `pushPull_coprod_prod` induction leaves:
- `pushPull_coprod_prod_empty` (sorry 983) — residual `IsZero ((Scheme.Modules.pullback q).obj F)` over the
  empty/initial scheme `∐ PEmpty`; close via presheaf-of-modules `IsZero`-from-pointwise (`toPresheaf`
  faithfulness + subsingleton structure-sheaf sections over the empty scheme). ~40–60 LOC.
- `coprodToProd_isIso_of_equiv` (sorry 999) — whiskerEquiv reindex; NOW blueprint-backed
  (`lem:coprodToProd_isIso_of_equiv`). `Sigma.whiskerEquiv`/`Pi.whiskerEquiv` + `pushPullObjCongr` + `Pi.π`
  projection chase (`coprodToProdMap_comp_π`). ~80 LOC, same `erw`/forward-fold technique as the Option step.
- Both ⟹ Stub 2 `pushPull_sigma_iso` axiom-clean → attempt Stub 4 `pushPull_eval_prod_iso`.
- Housekeeping: prune stale comment ~698; comment the `synthInstance.maxHeartbeats` override ~1165.
- Confirm ONLY with `lake env lean`.

## Lane 2 — `OpenImmersionPushforward.lean` (prove)
Close the keystone φ'' + cascade:
- `sliceReverseRingMap` φ'' (sorry 607) — codomain bridge: part (a) `Functor.sheafPushforwardContinuousComp'`
  for `eqv.inverse = Over.post ⋙ Over.map (unitIso.inv)`; part (b) the object-relabel iso
  `X.ringCatSheaf.over (φ.hom⁻¹ᵁ Vᵢ) ≅ (sheafPushforwardContinuous (Over.map (unitIso.inv.app Uᵢ))).obj
  (X.ringCatSheaf.over Uᵢ)`. ~40–80 LOC (the genuine depth).
- Cascade once φ'' concrete: H₁ (649)/H₂ (660) = `eqToHom = eqToHom` squares; pullbackIso section-id (692) =
  rfl-clean `pushforward_obj_obj`. All four ⟹ `_acyclic` fully sorry-free.
- Housekeeping: fix the `case hqc` "in full" comment ~861–862 (→ "modulo the 4 leaf sorries").
- If `_acyclic` closes, attempt `_comp` (934) + the EnoughInjectives connector (~6 LOC).
- STUCK-WATCH: if φ'' part (b) stalls, hand off the precise residual (do NOT brute-force). Confirm with `lake env lean`.
