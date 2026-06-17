# iter-028 review

## Overall progress this iter
- **Total sorry**: 2 → 2 (no regression). Both intentional/frozen: superseded relative-form
  `CechAcyclic.lean:110` (`affine`) + frozen P5b `CechHigherDirectImage.lean:679`.
  `CechToCohomology.lean` itself is 0 sorry.
- **Build**: GREEN. `CechToCohomology.lean` → `lake env lean … EXIT 0`. Root barrel imports both
  `AbsoluteCohomology` and `CechToCohomology` (`AlgebraicJacobian.lean:9-10`) — the iter-027 orphan
  must-fix is resolved.
- **Lanes planned 1, ran 1** (`CechToCohomology.lean`, mathlib-build).
- **+7 axiom-clean declarations**; **0 new sorries**; **6 named blueprint targets landed** (the new
  helpers `sectionsFunctor`, `CovDatum`, `injSES`/`injSES_shortExact` are the +4 unmatched debt).
- `archon dag-query`: **gaps = 0**, **unmatched = 4** (all new helpers).

## The headline: the entire Stacks-01EO comparison chain landed in ONE lane, beyond the hedge
Fifth consecutive strong iter. The plan drove the whole remaining 01EO chain in a single mathlib-build
lane with a hedge requiring only L3 + the two defs + the per-face SES. The prover **exceeded the
hedge**: per-face SES (`faceShortComplex_shortExact_of_sheaf_ses`) + L3
(`absoluteCohomology_one_eq_zero_of_basis`) + `BasisCovSystem`/`HasVanishingHigherCech` + L4 dimension-
shift induction (`absoluteCohomology_eq_zero_of_basis`) + the top comparison theorem
(`cech_eq_cohomology_of_basis`) all landed axiom-clean. With L1/L2 (iter-027), 01EO is **complete**.
Zero churn, zero new sorries, zero blockers on what was attempted.

## This iter's analysis
- **Honest, clean convergence.** No new mathematics was forced; the dominant cost was Lean-engineering
  friction — functor-instance synthesis through a `def` (`unfold; infer_instance`), the
  `ShortComplex.ShortExact.mk hex` assembly pattern (anonymous constructor was fragile), the project-
  `Ext` overload trap (`attribute [local instance] hasExtModules`), and `@[reducible]` on
  `injSES`/`HasVanishingHigherCech` for defeq unfolding under induction. All are now KB patterns.
- **No Lean-side must-fix from any audit.** lean-auditor `iter028`: 0 critical / 0 major / 4 minor,
  all decls axiom-clean; it independently confirmed the `BasisCovSystem` fields non-vacuous, the
  `[EnoughInjectives]` hypothesis genuine (used, not a vacuity trick), and the `hasExtModules` local
  instance a documented perf annotation. lvb `cechtocohom-iter028`: 0 Lean red flags, all proofs
  faithful.
- **The real `EnoughInjectives` gap is honestly carried, not papered.** L4 + top take
  `[EnoughInjectives X.Modules]` as an explicit hypothesis because the instance is genuinely absent in
  Mathlib (whnf-timeout even at `maxHeartbeats 2000000`; would need `IsGrothendieckAbelian
  (SheafOfModules R)`). This is the project's P5a convention, not a weakening — the obligation is
  visible in the signature and threads to downstream consumers.

## The blueprint lag — 3 major lvb items, all writer-side (planner's iter-029 job)
The Lean landed in a more concrete shape than the blueprint prose anticipated:
1. `def:basis_cov_system` prose describes condition (2) as raw cofinality and omits the
   `injective_acyclic` field; the Lean carries two sheaf-theoretic fields. The prose's "no derived-
   functor machinery" claim is now false for the Lean. → blueprint-writer reconcile (HARD-GATE before
   the 02KG lane).
2. `[EnoughInjectives X.Modules]` missing from the blueprint statements of L4 / top. → add it.
3. (Resolved by me) 3 stale `% NOTE: not yet formalized` annotations on now-landed blocks — stripped
   this iter.

These are the only must-fix items, and none is a Lean defect — the Lean is right, the prose lags. The
01EO chapter clears the gate for what was attempted; the reconcile is needed before the *next* lane
(02KG) consumes the chapter.

## Coverage / markers
- **Manual marker edits**: stripped 3 stale `% NOTE: not yet formalized` lines on `def:basis_cov_system`,
  `def:has_vanishing_higher_cech`, `lem:face_ses_of_sheaf_ses` (all now landed + `\leanok`). No
  `\mathlibok` / `\lean{...}` rename / `\notready` changes needed — all 6 chain pins already match the
  landed names.
- `unmatched` = 4 (`sectionsFunctor`, `CovDatum`, `injSES`, `injSES_shortExact`) — listed in
  recommendations for the planner to blueprint.
- blueprint-doctor: clean.
- `sync_leanok` iter=28: added 15 / removed 2 (healthy); the iter-025/026 `\leanok` mis-removal anomaly
  did not recur.

## Frontier ahead
01EO complete. After the blueprint reconcile (#1, #2) + coverage (4 helpers): the ready frontier is
**02KG affine Serre vanishing** — instantiate `BasisCovSystem` at affine opens / standard covers
(discharge `surj_of_vanishing` via `ses_cech_h1` + cofinality, `injective_acyclic` via
`injective_cech_acyclic`; a cover-representation bridge `X.OpenCover`/`coverOpen 𝒰` → `CovDatum` is
required), then the frozen P5b `cech_computes_higherDirectImage`. The single residual infrastructure
gap is `IsGrothendieckAbelian (SheafOfModules R)` ⇒ `EnoughInjectives X.Modules` (carried as a
hypothesis until built).
