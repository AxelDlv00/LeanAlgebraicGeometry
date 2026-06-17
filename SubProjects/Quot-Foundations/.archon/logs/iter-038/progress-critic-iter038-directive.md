# progress-critic directive — iter-038

Fresh-context convergence audit, per active route. Use ONLY the signals below — do NOT read STRATEGY.md,
blueprint chapters, or iter sidecars. Your question is convergence (is each route closing, or churning?),
not strategic soundness or math correctness.

## Route FBC — `base_change_mate_gstar_transpose` / `_legs_conj` (FlatBaseChange.lean)
- Phase entered: ~iter-034 (conjugate-counit vehicle). STRATEGY iters-left estimate: 1–4.
- Signals (last 4 iters), active `sorry` in file held at 4 throughout:
  - iter-034: conjugate foundation (conj-0) landed axiom-clean; +several helpers. sorry 4→4.
  - iter-035: atomized conjugate chain, 7 axiom-clean decls; `_legs` became a thin wrapper but the residual
    sorry MOVED into conj-2a (`_legs_conj`). sorry 4→4.
  - iter-036: step (b) `extendScalars_inner_value_counit`/`gstar_generator_close` landed axiom-clean. sorry 4→4.
  - iter-037: ASSEMBLY pass — NO code edits, NO new closed sub-lemma (investigation only). sorry 4→4.
    Pre-set tripwire FIRED.
  - Recurring blocker phrase: "dependent-motive wall — `codomain_read_legs` carries `hfst/hsnd` leg-equality
    proofs ⇒ `rw`/`subst` motive-not-type-correct; reframing keystone (conj-2b/2d + single-conjugateEquiv-
    component) unbuilt."
- Planner's iter-038 action for this route: NO prover. Dispatch a SHARPENED mathlib-analogist (cross-domain)
  to decide continue-the-conjugate-re-encoding vs. pivot-the-affine-iso-proof. (The prior analogist output
  `analogies/fbc-mate-reencode.md` already gave the re-encode recipe but it was never executed.)

## Route QUOT — gap1 Hfr chain (QuotScheme.lean)
- Phase entered: ongoing gap1 build. STRATEGY iters-left estimate: 3–6.
- Signals (last 4 iters), file `sorry` = 4 protected scaffold stubs (out of scope), unchanged:
  - iter-034: gap1 bridge C `overRestrictIso` axiom-clean.
  - iter-035: gap1-D cover-form keystone `isLocalizedModule_basicOpen_descent_of_cover` axiom-clean (+6 decls).
  - iter-036: `gammaPullbackTopIso` + general-in-U + naturality axiom-clean (whole `lem:pullback_gamma_top_iso`).
  - iter-037: bridges (I) `isLocalizedModule_of_ringEquiv_semilinear` + (II)
    `isLocalizedModule_restrictScalars_powers_algebraMap` axiom-clean; Hfr assembly deferred (1 named wall).
  - Pattern: steady axiom-clean infrastructure each iter; each iter names a single precise next ingredient.
- Planner's iter-038 action: prover (mathlib-build) on the semilinearity sub-build — build `σ_V` (open-
  immersion structure-sheaf ring iso) + prove `gammaPullbackImageIso.hom` is `σ_V`-semilinear, then chain to
  Hfr → named descent → gap1.

## Route GR — proper via valuative criterion (GrassmannianCells.lean)
- Phase entered: GR-proper. STRATEGY iters-left estimate: 1–2. File is 0-sorry (new decls each iter).
- Signals (last 4 iters):
  - iter-034: (GR-glue context) earlier.
  - iter-035: properness reduced to `ValuativeCriterion.Existence (toSpecZ)`; E3 ratio core landed.
  - iter-036: E1 chart-factorization + E2 minimal-valuation + E3-ratio-core landed axiom-clean.
  - iter-037: E3-FULL CLOSED — `det_one_updateCol` + `exists_minorDet_eq_free_entry` +
    `existence_factor_through_valuationRing` axiom-clean (the last matrix-algebra gap).
  - Pattern: closes a named sub-milestone (E1→E2→E3→E3full) each iter.
- Planner's iter-038 action: prover (mathlib-build) on E4 `existence_lift` (frontier-ready, deps done,
  concrete signature + full proof sketch in blueprint), then downstream `valuativeExistence_toSpecZ`→`isProper`.

## My proposed iter-038 `## Current Objectives` (2 prover files + 1 analogist)
1. `AlgebraicJacobian/Picard/QuotScheme.lean` — semilinearity sub-build (mathlib-build).
2. `AlgebraicJacobian/Picard/GrassmannianCells.lean` — E4 `existence_lift` (mathlib-build, scaffold new decl).
(FBC: no prover; analogist consult instead.)

## What I need
Per-route verdict CONVERGING / CHURNING / STUCK / UNCLEAR. In particular: confirm the FBC NO-PROVER +
analogist decision is the right response to the fired tripwire (vs. a prover round), and confirm QUOT/GR are
genuinely converging (not churning helpers). Name the corrective TYPE for any CHURNING/STUCK route.
