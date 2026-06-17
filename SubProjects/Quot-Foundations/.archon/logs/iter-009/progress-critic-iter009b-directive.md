# Progress Critic Directive

## Slug
iter009b

## What to assess
Convergence (CONVERGING / CHURNING / STUCK / UNCLEAR) per active route, and a
dispatch-sanity check on the planner's proposed iter-009 objective list. K=4 window
(iters 005–008). Note: iters 005 and 007 ran NO prover on FBC/GF (deferred for blueprint
decomposition), so "no movement" in those iters is by design, not stall.

## Route: FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
Signals (sorry count in the file / status / helpers):
- iter-005: no prover (dag-only iter).
- iter-006: sorry 4→4. PARTIAL. The imported one-liner for `map_smul'` was REFUTED
  (different tensor carrier TYPES, not a diamond). Only an `ext x` reduction landed.
- iter-007: no prover (deferred — blueprint decomposition of the mate crux).
- iter-008: sorry 4→5. PARTIAL. `map_smul'` substantively PROVEN on tmul/add branches
  (first end-to-end route-(a) execution); split into 2 trivial `r'•0=0` zero-branches that
  remain sorry. The 3 mate sub-lemmas were NOT created — prover refused (they had no
  `% LEAN SIGNATURE` blocks; fabricating types is banned).
- Recurring blocker phrases: "opaque `_aux` Module R' instance wall blocks `smul_zero` on
  the zero branches"; "3 mate sub-lemmas untyped".
- STRATEGY `Iters left` = 3–4; route entered its current phase (direct-on-sections) at iter-003.
- Planner's iter-009 disposition: **FBC NOT dispatched** — deferred ONE iter for a route swap.
  A strategy-critic CHALLENGE (iter-009) + a mathlib-analogist report (iter-009) converged that
  the adjoint-mate tower is the wrong path; this iter a blueprint-writer executes the swap (drop
  the 3 mate sub-lemmas; fix `regroupEquiv`'s core to the natively-R'-linear
  `Algebra.IsPushout.cancelBaseChange`, eliminating `map_smul'`; replace the trace identity with
  one section-level `Γ(θ)=lTensor R' η_M`). FBC prover dispatches next iter on the rewritten chapter.

## Route: GF-alg — `AlgebraicJacobian/Picard/FlatteningStratification.lean`
Signals:
- iter-005: no prover.
- iter-006: sorry 4→4. PARTIAL. Strong-induction skeleton (`Nat.strong_induction_on`) landed.
- iter-007: no prover (deferred — blueprint decomposition).
- iter-008: sorry 4→5. **2 sub-lemmas PROVED axiom-clean** (`gf_generic_rank_ses`,
  `gf_clear_one_denominator`); L5 induction restructured to generalize the BASE DOMAIN `A`
  (the named iter-006 root cause); `gf_torsion_reindex` created with a sorry (Mathlib-absent
  single-variable Nagata engine).
- Recurring blocker phrase: "single-variable MvPolynomial Nagata elimination engine is
  Mathlib-absent".
- STRATEGY `Iters left` = 3–4; route entered current phase at iter-002.
- Planner's iter-009 disposition: **GF NOT dispatched** — deferred ONE iter. An effort-breaker
  (iter-009) already decomposed `gf_torsion_reindex` in the blueprint into 4 sub-lemmas
  (annihilator extraction, Nagata change-of-vars, a Mathlib anchor, and the shared
  single-variable elimination engine + a short assembly). GF prover dispatches next iter to
  build those bottom-up (mathlib-build).

## Route: GrassmannianCells — `AlgebraicJacobian/Picard/GrassmannianCells.lean`
Signals:
- iter-007: `affineChart` landed axiom-clean (file went to 0 real sorry).
- iter-008: dispatched as a third lane (`def:gr_transition`) but committed ZERO edits and
  wrote NO task_result — the lane produced nothing (anomaly; budget spent, nothing delivered).
- STRATEGY `Iters left` (QUOT-defs) = 4–7; phase started iter-007.
- Planner's iter-009 proposal: **re-dispatch** `def:gr_transition` (Cramer-inverse transition
  ring hom), gate-cleared iter-007, a leandag ready-frontier node. [mathlib-build]

## Route: QUOT-A — `AlgebraicJacobian/Picard/QuotScheme.lean`
Signals:
- iter-007: `Module.annihilator_isLocalizedModule_eq_map` engine lemma landed axiom-clean; the
  two definitional targets (`annihilator`, `sectionGradedRing`) blocked on Mathlib infra.
- iter-008: deferred — a blueprint-writer round added the annihilator sub-build (QCoh→
  IsLocalizedModule bridge `lem:qcoh_section_localization_basicOpen` + re-wired
  `def:modules_annihilator` to require QCoh finite-type F).
- STRATEGY `Iters left` (QUOT-defs) = 4–7.
- Planner's iter-009 proposal: **dispatch** the bridge `qcoh_section_localization_basicOpen`
  (a leandag ready-frontier node) → assemble `Scheme.Modules.annihilator`, IF this iter's
  blueprint-reviewer clears `Picard_QuotScheme.tex`. [mathlib-build]

## Proposed iter-009 `## Current Objectives` (file count + basenames)
2 prover lanes: `GrassmannianCells.lean` (def:gr_transition, mathlib-build) +
`QuotScheme.lean` (qcoh bridge → annihilator, mathlib-build, contingent on the blueprint
gate). FBC + GF deferred ONE iter while their iter-009 correctives (route-swap writer / already-
landed effort-break) get a blueprint-review cycle; both dispatch next iter.

## Question for you
For each route give a verdict. In particular: (1) is GF genuinely CONVERGING (so effort-breaking
the shared engine is the right corrective) rather than STUCK (which would force a route pivot)?
(2) Is deferring FBC + GF ONE iter to execute the must-fix correctives (route swap / effort-break)
the right response, or does it read as avoidance? (3) Is the GrassmannianCells re-dispatch + QUOT-A
dispatch a sound, non-thrashing use of this iter's two prover lanes?
