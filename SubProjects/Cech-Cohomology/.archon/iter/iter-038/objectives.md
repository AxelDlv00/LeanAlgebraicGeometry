# Iter-038 objectives

## Dispatched (1 prover lane)

1. **`AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`** [mathlib-build] — build **B3**
   `overBasicOpenIsoRestrict` (via B3a/B3b/B3c) + **B4** `presentationModulesRestrictBasicOpen`.
   Blueprint `lem:restrict_over_compat` (B3 sketch now carries B3a/b/c) + `lem:presentation_modulesRestrictBasicOpen`.
   HARD GATE cleared (blueprint-reviewer `iter038`). Recipe: PROGRESS Current Objectives §1 + `analogies/bridge.md`.
   - B3a: structure-sheaf compat `φ/ψ/H₁/H₂` via `(specBasicOpen g).ι.appIso` (same `appIso` as `restrictFunctor`).
   - B3b: `pushforwardPushforwardEquivalence` at the continuous `overEquivalence (specBasicOpen g)` site equiv.
   - B3c: transport `↥D(g)`→`Spec R_g` via `restrictFunctor (basicOpenIsoSpecAway g).inv`; compose.
   - B4: `(presentationOverBasicOpen …).ofIsIso (overBasicOpenIsoRestrict …).hom`, pin `.{u,u,u}`.
   - Traps (iter-037 prover): IsContinuous needs `W.left` literal; pin `ofIsIso.{u,u,u}`; pin counit
     `preimageIso` with B explicit; `set_option backward.isDefEq.respectTransparency false`.

## NOT dispatched (with reason)
- `QcohTildeSections.lean` — B1 done; keystone-assembly lane import-blocked on B3/B4 (this iter). Resumes
  next iter after B3/B4 land. No honest parallel work.
- 02KG tops (`affine_serre_vanishing`, `affine_cech_vanishing_qcoh`) + P5a `cech_augmented_resolution` —
  FALSE-ready / gated on the unconditional keystone. Dispatching would burn a lane.

## Subagents dispatched this phase
- progress-critic `iter038` → CONVERGING (mandatory).
- blueprint-writer `b3decomp` → B3 sketch + coverage-debt blocks + `\uses` fixes.
- blueprint-clean `b3` → 2 purity edits.
- blueprint-reviewer `iter038` → HARD GATE CLEARS for B3/B4 (mandatory + fast path).
