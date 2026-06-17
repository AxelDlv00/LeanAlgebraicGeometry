# Project Progress

## Current Stage

prover

## Stages
- [x] init
- [x] autoformalize
- [ ] prover
- [ ] polish

## End-state overview

**Zero inline `sorry` in the dependency cone of the seed declarations + kernel-only axioms.**
This subproject bundles two Čech-independent (i=0) legs extracted from the parent
*Quot-Foundations* `thm:fga_pic_representability` cone:

- **FBC-B** — flat base change for the pushforward of a quasi-coherent sheaf in degree 0.
- **SNAP** — the section graded ring `Γ_*(X,L)`.

Seeds: `thm:flat_base_change_pushforward`, `thm:fbcb_global_direct`,
`lem:affine_base_change_pushforward`, `lem:sectionGradedRing_gcommSemiring`,
`lem:sectionGradedModule_gmodule`. Full arc in STRATEGY.md.

## Current Objectives

TWO independent frontier lanes (different files, no edit race). **NEVER positional
`rw`/`simp`/`erw` under the `X.Modules`/Scheme-cat diamond**; use term-mode
(`.trans`/`congrArg`/applied `map_smul`) + the `change`-to-nested-application lever for the
value-ModuleCat diamond.

1. **`AlgebraicJacobian/Picard/SectionGradedRing.lean`** — SNAP graded assembly.
   - Fill the cast/coherence bricks bottom-up: `sectionsCast`, `sectionsCast_refl`,
     `gradedMonoid_eq_of_cast`, the `GradedMonoid.GMul`/`GOne` instance bodies, then the 4
     cast-mediated coherence Eqs `sectionsMul_one_mul`/`_mul_one`/`_mul_assoc`/`_mul_comm`
     (= `lem:sectionMul_coherent`).
   - THEN build the `GMonoid`/`GSemiring`/`GCommSemiring`/`Gmodule` assembly instances
     mirroring `TensorPower.Basic` field-for-field (`gnpow` defaulted; bilinearity FREE) —
     this lands `lem:sectionGradedRing_gcommSemiring` + `lem:sectionGradedModule_gmodule`.
   - Blueprint: `chapters/Picard_SectionGradedRing.tex`. [prover-mode: prove]

2. **`AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean`** — FBC-B DIRECT capstone.
   - `Modules.baseChangeGammaPullbackEquiv` (`thm:fbcb_global_direct`):
     `Γ(X,F)⊗_A B ≃ₗ[B] Γ(X', F')`. Proof per blueprint 3-step: LHS is LITERALLY
     `baseChangeGammaEquiv F U hU B`'s domain (start there) → transport the RHS eqLocus to
     `gammaModA F' ⊤` via `gammaTopEquivEqLocus` applied to `F' = (Scheme.Modules.pullback g').obj F`
     and the base-changed cover, identifying base-changed legs with `F'`'s restriction legs via
     `pullback_spec_tilde_iso` (01I9) + `affine_base_change_pushforward` [both DONE in
     FlatBaseChange.lean]. RHS `B`-module is `restrictScalars` along
     `pullbackGroundRingAlg B : B → groundRing X'` (no `Algebra B (groundRing X')` instance needed).
   - Blueprint: `chapters/Cohomology_FlatBaseChange.tex` (`thm:fbcb_global_direct`). [prover-mode: prove]

## Queued — NEXT iters

- **FBC-B reduction lemma + capstone wiring.** Scaffold `flatBaseChange_isIso_iff_gammaTensorComparison`
  (`lem:flat_base_change_reduce_global_sections`), reconciling the abstract pullback-square
  parametrization of `pushforwardBaseChangeMap` with the direct-`B` parametrization; then fill
  `affineBaseChange_pushforward_iso` / `flatBaseChange_pushforward_isIso` from
  `baseChangeGammaPullbackEquiv` (signatures movable between files).
- The retained `base_change_mate_*` declarations in FlatBaseChange.lean are off-path **riders**
  (kept only because proved legs still reference their signatures). The mate route is ABANDONED;
  do not re-attempt it. They may be trimmed once the named legs are filled via the direct route.

## Standing notes

- **Prover model:** `opus`. Re-pin a `fable` lane only with valid creds.
- **Import architecture:** root `AlgebraicJacobian.lean` imports each leaf; provers add decls to
  EXISTING files. FlatBaseChangeGlobal imports FlatBaseChange (one-way); FlatBaseChange imports
  RegroupHelper. SectionGradedRing is standalone.
- **Cold-build:** validate with real `lake build AlgebraicJacobian.Cohomology.FlatBaseChangeGlobal` /
  `...Picard.SectionGradedRing` (LSP hides `(kernel) deterministic timeout`); do NOT reintroduce
  `maxHeartbeats 1e6`.
- **No LLM API key in env** — use blueprint + Mathlib search + the analogist subagent.
- **SNAP do-not-retry:** full `MonoidalCategory (SheafOfModules)` / strong-monoidal sheafification
  NOT needed; the crux is CLOSED. Stalkwise + "presheaf+Γ-at-end" routes are DEAD. Carrier:
  `AddCommGrpCat` NOT `AddCommGrp`; a `have` mentioning `P ⊗ Q` must spell
  `MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q`. `sectionsMul_assoc_unit` = FOUR
  cast-mediated component Eqs (NOT one GradedMonoid Eq, NOT a raw HEq).
- **FBC do-not-retry:** the mate keystone `_legs_conj` (+`_gstar_transpose`) is ABANDONED — do NOT
  re-attempt it. Named legs route via FBC-B direct (`baseChangeGammaPullbackEquiv`). RHS `B`-module
  is `restrictScalars` along `B → groundRing X'`; do NOT chase `groundRing X' = B` (that is the
  theorem at `F = O_X`, a consequence not a hypothesis).
- **Merge-back discipline:** never rename kept decls/labels/paths; never add `\leanok` by hand.
  Advisory freeze (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`): keep
  SIGNATURES stable, fill BODIES freely (movable between files preserving signature).
