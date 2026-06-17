# Iter-035 objectives

## Lane 1 — `TildeExactness.lean` [mathlib-build] — assemble `tildePreservesFiniteLimits`
- 01I8 Route-P P3. Gate cleared (fast-path scoped re-review of `lem:tilde_preserves_kernels`).
- Build: (A) package the Ab stalk map `σ_x` as `R`-linear (`StructureSheaf.germₗ` + Γ-linearity of
  `Scheme.Modules.Hom.app`; insert a `show … : (tilde N).presheaf.stalk x` ascription to beat the HSMul
  synthesis friction); (2) identify `σ_x` with `IsLocalizedModule.map …` via `tilde_stalkFunctor_map_toStalk`
  + `IsLocalizedModule.ext`, injectivity from `tilde_toStalk_map_injective`; (B)+(C) assemble
  `PreservesFiniteLimits (~ ⋙ toPresheaf)` via the jointly-reflecting stalk family, compose with the DONE
  `tildePreservesFiniteLimits_of_toPresheaf`.
- Avoid the `ModuleCat R`-valued stalk route (DEAD — Mathlib privacy).
- Expected: COMPLETE (named target lands) or PARTIAL with the R-linear `σ_x` packaging + identification done.

## Lane 2 — `QcohRestrictBasicOpen.lean` (NEW) [mathlib-build] — P1a restriction chain
- 01I8 Route-P P1a. Build bottom-up:
  - `modulesRestrictBasicOpen` (+ `modulesRestrictBasicOpenIso`): `F|_{D(f)}` as a `Spec R_f`-module via
    `Scheme.Modules.restrict` [verified] + `basicOpenIsoSpecAway` [verified]; `R_f = Localization.Away f`.
  - `tilde_restrict_basicOpen`: `~M|_{D(f)} ≅ ~(M_f)`.
  - `presentation_restrict_basicOpen`: presentations restrict to `Spec R_g`.
- Do NOT attempt `isQuasicoherent_restrict_basicOpen` (assembly step under-specified).
- Verify `lake env lean QcohRestrictBasicOpen.lean` EXIT 0 standalone (barrel import wired next iter).
- Expected: `modulesRestrictBasicOpen` (+iso) at least; go up the chain as far as it compiles axiom-clean.

## Not dispatched (FALSE-ready guard)
- `lem:affine_cech_vanishing_qcoh`, `lem:cech_augmented_resolution` — "Ready" in graph but `\uses`
  under-declares the real 01I8 / `affine_serre_vanishing` dependence. Blocked.

## Correctness fix landed this plan phase (refactor)
- `affineCoverSystem.Cov` tightened to carry `D(f)=⨆ᵢD(gᵢ)`; `affine_surj_of_vanishing` re-signed. Axiom-clean.
