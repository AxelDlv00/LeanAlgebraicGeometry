# iter-018 review

## Overall progress this iter
- **Total sorry**: 2 → 2 (no regression). Both intentional: superseded relative-form
  `CechAcyclic.affine` (line 74/109, left per Q4) + frozen P5b assembly (CechHigherDirectImage:771).
- **Build**: GREEN, 8323 jobs. The iter-018 plan's keyword fix worked — all 4 noop-exempt lanes
  dispatched and ran (recovering from iter-017's `failed_all_noop`).
- **+36 axiom-clean declarations** across 4 parallel lanes; **0 new sorries**; 1 broken-on-entry
  proof repaired (FreePresheafComplex `cechFree_d_comp_aug`). **0 named lane targets landed.**

## Branches advanced
- **P3 L1 (`CechAcyclic.lean`, +22)**: the away-localisation comparison algebra (`AwayComparison`,
  11) + the concrete Čech localised maps with the three compatibilities (`CechLocalized`, 11,
  ending `cechLocalized_exact`). This is precisely the *hardest, most-uncertain* sub-task the L1
  analysis identified (`δ`/`c` construction + `hu`/`hsh`/`hcomm` discharge). Section-form target
  not yet built; remaining is `D•` + `exact_of_isLocalized_span` + the section/`tilde`/01I8 chain.
- **P3b free (`FreePresheafComplex.lean`, +3 +1 repair)**: the augmentation chain map
  `cechFreeComplexAug : K(𝒰)_• ⟶ O_𝒰[0]`, so the quasi-iso target is now `QuasiIso (cechFreeComplexAug)`.
  Target `cechFreeComplex_quasiIso` not built (the ~250–450 LOC homotopy + objectwise reduction).
- **P3b bridge (`CechBridge.lean`, +5)**: the entire mathematical core of the hom-identification
  (cosimplicial `Hom(K_•,F)` via `.rightOp ⋙ preadditiveYoneda`, per-degree iso, naturality,
  projection-characterisation). Target `cechComplex_hom_identification` held back **operationally**
  (imported FreePresheafComplex broken mid-session — now compiles) with a complete assembly recipe.
- **P5a (`HigherDirectImagePresheaf.lean`, NEW file, +6)**: the reusable Stacks-01XJ engine
  `homologyIsoSheafify` + the resolution form `higherDirectImage_iso_sheafify_presheafHomology`.
  Named absolute-cohomology-presheaf target not built (a deliberate Decision-1 fork avoidance);
  resolves to a planner re-sign.

## This iter's analysis
- **"0 named targets landed" is NOT churn.** Every lane added substantial axiom-clean
  sub-infrastructure that strictly shrinks the residual and rephrases its target. Three of the four
  handed off with the named target *now genuinely reachable* (CechBridge: just type the recipe;
  FreePresheafComplex: port the homotopy; P5a: a planner re-sign). Only CechAcyclic remains
  multi-step. The lane that came closest, CechBridge, was blocked purely by a *concurrent-lane build
  breakage* (FreePresheafComplex), which is now resolved — so next iter has a clear shortest path.
- **The dominant tactical theme was defeq-not-syntactic carrier mismatch** (3 of 4 lanes). The
  prover responses (fresh-elaborated `have`; `erw` + term-mode) are now Knowledge-Base patterns.
- **No code-quality regressions.** lean-auditor: 0 must-fix, 0 excuse-comments, no axioms, no
  suspect bodies; all 36 decls `#print axioms`-clean. The two lvb "must-fix" entries on CechAcyclic
  are both the *pre-known* superseded-sorry / not-yet-built-section-target state, explicitly
  acknowledged in the directive — not new defects.
- **The real review signal is administrative/blueprint, not mathematical:**
  1. **`HigherDirectImagePresheaf.lean` is orphaned** — not imported by the root `AlgebraicJacobian.lean`
     barrel. It builds standalone and leandag scans it, but it must be added to the root (refactor).
  2. **P5a design fork** — the named `\lean{}` target doesn't exist; I added a `% NOTE` flagging the
     built resolution form + pending re-sign. Planner must decide (recommend option 1).
  3. **44-node coverage debt** — all new helpers uncovered; listed in recommendations for bundling.
  4. **4 actively-misleading stale comments** (AcyclicResolution, CechHigherDirectImage, PresheafCech)
     describe proved decls as open — refactor cleanup.
  5. **Broken `\uses{...CombinatorialCech.depDiff_exact}`** (blueprint-doctor) — a raw Lean name in a
     `\uses` with no matching `\label`.

## Subagent dispatches
- lean-auditor `iter018` (whole project) + lean-vs-blueprint-checker ×4 (one per prover-touched file).
  All 5 dispatched and returned; findings landed in recommendations.md (HIGH/MEDIUM) and summary.md.

## Markers
- 1 `% NOTE` added at `lem:higher_direct_image_presheaf` (design fork: `\lean{}` target absent,
  resolution form built, re-sign pending). No `\mathlibok` (no pure Mathlib re-exports among the new
  decls). No `\leanok` touched (sync_leanok ran for iter 18: +1/−2). No stale `\notready` found.
