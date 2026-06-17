# Progress-critic directive — iter-057

Two active prover routes toward the protected goal `cech_computes_higherDirectImage` (Route A:
acyclic-resolution comparison). Assess convergence per route. K = 4 iters (053–056).

## Route 1 — P5a-resolution `cechAugmented_exact` (Sub-brick A, file `CechSectionIdentification.lean`)
Goal: prove the augmented Čech complex resolves F; reduced to the per-degree section identification
`Γ(V,pushPullObj F Y_p) ≅ ∏_σ Γ(U_σ∩V,F)` (Sub-brick A, 6 stubs) + a contractibility.

Signals:
- iter-053: `cechAugmented_exact` object layer wired to residual `hSec`. PARTIAL. sorry +0 net.
- iter-054: residual reshaped via new helper `isZero_homology_of_homotopy_id_zero`. PARTIAL. helpers +1.
- iter-055: shared file `CechSectionIdentification.lean` scaffolded with 6 stubs; `Dependent` engine
  de-privatized. PARTIAL. sorry +6 (scaffold stubs); shipped RED, fixed in iter-056 plan phase.
- iter-056: Stub 3 (`pushPull_leg_sections`) CLOSED axiom-clean. Stubs 5/6 found PROVABLY FALSE as
  specified (non-augmented complex not contractible; consumer needs the AUGMENTED complex — airtight
  counterexample, auditor-confirmed). Stub 1 (`cechBackbone_left_sigma`) BLOCKED on a missing-Mathlib
  scheme-level coproduct/fibre-product distribution (≫150 LOC, "not a one-session item"); Stub 2/4
  chained behind Stub 1. PARTIAL. sorry 11→10 (Stub 3 closed). helpers +1.
- Recurring blocker phrases: "Stub 1 needs scheme coproduct over fibre product — Mathlib lacks it";
  "Stubs 5/6 false-spec → re-state to augmented complex `D'_aug`"; "augmentation node needs sheaf
  equalizer, depHomotopy engine only covers degrees ≥1".

STRATEGY: P5a-resolution `Iters left` = ~3–5; entered current ("stubs") phase at iter-055.

## Route 2 — P5a-consumer open-immersion acyclicity → Need#2 (file `AffineSerreVanishing.lean`)
Goal: affine open immersions are f_*-acyclic; corrected iter-056 to a two-need split (Need#2 =
enlarge affine cover-system basis to all affine opens; Need#1 = whole-scheme isoSpec Ext transport).

Signals:
- iter-053: `OpenImmersionPushforward._acyclic` reduction wired. PARTIAL.
- iter-054: +1 helper, both tops reduced to a shared bridge. PARTIAL. helpers +1.
- iter-055: +5 corepresentability helpers; `_acyclic` leaf reshaped to `IsZero(Ext^q(jShriekOU(j⁻¹W),H))`.
  PARTIAL. helpers +5.
- iter-056: ROUTE CORRECTED — mathlib-analogist proved the naive open-subscheme transport is the
  restriction-of-injectives WALL; adopted the two-need split. Built 7 axiom-clean decls in
  `AffineSerreVanishing.lean` (`affineCoverSystemGeneral` + cofinality/surjectivity generalizations +
  reduction tops), reducing Need#2 end-to-end to ONE isolated hypothesis `htilde` = general-affine-open
  standard-cover Čech vanishing of the tilde sheaf. PARTIAL. sorry 0→0 (residual is a hypothesis).
  helpers +7.
- Recurring blocker phrases: "change-of-scheme seed `htilde` (V≅SpecΓ(V)), ~150–300 LOC, comparable to
  QcohTildeSections"; "general affine V is not D(f) for any single f → `_of_localizationAway` tool does
  not apply"; "analogist's 'no new gap' estimate missed that `cech_eq_cohomology_of_basis` also consumes
  HasVanishingHigherCech".

STRATEGY: P5a-consumer `Iters left` = ~3–5; entered current ("split") phase at iter-056.

## This iter's proposed objectives (2 files)
1. `AffineSerreVanishing.lean` (or a new split file) — build the change-of-scheme seed `htilde`
   (general-affine-open standard-cover Čech vanishing of tilde via V≅SpecΓ(V)). [mathlib-build]
2. `CechSectionIdentification.lean` — build Stub 1 (the missing-Mathlib scheme coproduct/fibre-product
   distribution primitive) in mathlib-build mode (after a blueprint re-spec of Stubs 5/6 clears the gate).

## What I need from you
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with the corrective TYPE if not converging.
Specifically: both routes have now isolated a genuine, sound, multi-iter build (Route 1: scheme-coproduct
Mathlib gap; Route 2: change-of-ring section-Čech seed). Is dispatching provers at these isolated builds
this iter genuine convergence, or is it churn (helpers accumulating without the residual shrinking)?
Flag if either proposed objective is the wrong next step.
