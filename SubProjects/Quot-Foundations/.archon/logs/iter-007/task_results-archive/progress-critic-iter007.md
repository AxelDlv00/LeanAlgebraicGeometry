# Progress Critic Report

## Slug
iter007

## Iteration
007

## Routes audited

### Route: FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 3 → 4 → (dag, iter-005) → 4. Across the K=4-iter window (003–006),
  sorry count went from 3 to 4 — **net +1**. The last two prover iters (004 and 006) show zero
  downward movement: 4→4. No sorry has been eliminated on this route since iter-003.
- **Helper accumulation**: iter-003 added ~7 declarations (L1/L2/L3 + structural helpers).
  iter-004 added ~5 declarations (`base_change_regroup_linearEquiv`, `base_change_mate_regroupEquiv`
  partial, `base_change_mate_generator_trace_eq` typed sorry, `base_change_mate_generator_trace`
  closed, `pushforward_base_change_mate_cancelBaseChange` closed). iter-006 added 0 net declarations
  (`ext x` structural reduction is not a declaration; `RegroupHelper.lean` was a plan-phase refactor,
  not a prover output). Total: ~12 helpers added across 2 prover iters with net sorry +1.
- **Prover dispatch pattern**: 1 file for 3 consecutive prover iters (iters 002, 003, 004, 006 —
  single lane each time).
- **Recurring blockers**:
  - "opaque-instance wall (`letI := inferInstanceAs` ⇒ no `SMulZeroClass` synthesis)" — iter-004
    (reported as carrier-instance wall) and iter-006 (confirmed definitively, 2 prover iters).
  - **New iter-006 finding (escalation):** the `base_change_mate_regroupEquiv.map_smul'`
    "one-liner closes it" hypothesis, carried as "[verified by prover]" in PROGRESS.md for 3 iters,
    was definitively **refuted** in iter-006. Root cause: the tensor carrier `(A⊗[R]R')⊗[A]M` over
    `leftAlgebra` vs. over `restrictScalars includeLeftRingHom` are **different types**, not defeq
    even across import boundaries. The `eT` bridge is mathematically essential and was never
    eliminable. The PROGRESS.md plan directive was incorrect, and the blueprint's proof prescription
    for `base_change_mate_regroupEquiv` is currently **wrong** (it prescribes the one-liner that
    will never typecheck). This is a blueprint correctness issue, not merely an undeployed fix.
  - "Mathlib-absent mate-unwinding coherence / adjoint-mate trace" — iter-004 (first real attempt
    deferred) and iter-006 (per-generator identity confirmed Mathlib-absent, 3-step trace needed;
    2 prover iters with no partial proof body).
- **Avoidance patterns**: none currently active. The 2-iter lag on the `map_smul'` refactor (noted
  in iter-006 report) resolved when the refactor was deployed. The more significant issue is the
  plan carrying a wrong "[verified by prover]" annotation for 2 consecutive iter cycles (iters 005
  and 006 plan), which directed the iter-006 prover to attempt a provably impossible route first.
- **Prover status pattern**: PARTIAL (iter-003), PARTIAL (iter-004), PARTIAL (iter-006) —
  **three consecutive PARTIAL statuses across the K-window's prover iters**.
- **Throughput**: OVER_BUDGET. STRATEGY.md estimates 3–5 iters for FBC-A ACTIVE phase. Phase
  entered ACTIVE at iter-002. Iter-007 is the 6th iteration in this phase (5 elapsed). The sorry
  count at phase entry was ~3; it stands at 4 — **up, not down**. The route is past the upper
  bound of the estimate with residues now confirmed Mathlib-absent. The iter-007 planner's response
  (defer prover, blueprint expansion) does not count toward prover progress; the estimate must be
  revised upward.
- **Verdict**: **CHURNING**
  - Triggered by: PARTIAL prover status ×3 (standalone criterion, met verbatim).
  - Confirming signals: helpers added in 2 of last 2 prover iters with sorry count net +1; recurring
    opaque-instance blocker ×2 prover iters; sorry count flat at 4 across last 2 prover iters.
  - Escalation note: the "one-liner closes it" hypothesis that the plan carried as verified was
    WRONG — the iter-006 prover performed the one-liner attempt that the plan directed and found it
    mathematically unsound. This is a new dimension: the CHURNING is no longer just "undeployed
    fix" but "the prescribed fix is incorrect and the blueprint must be rewritten." The severity is
    higher than iter-006's CHURNING finding.
- **Primary corrective**: **Blueprint expansion — fix the regroupEquiv proof prescription and
  decompose generator_trace_eq.** The blueprint chapter for `base_change_mate_regroupEquiv` must
  be rewritten to replace the one-liner prescription with the transparent-instance approach: expose
  `SMulZeroClass R' (extendScalars obj)` explicitly, use `TensorProduct.induction_on`, and apply
  the `ModuleCat.restrictScalars.smul_def` → `ModuleCat.ExtendScalars.smul_tmul` →
  `Algebra.TensorProduct.tmul_mul_tmul` reduction chain (all lemmas confirmed present in Mathlib
  by the iter-006 prover). Separately, `base_change_mate_generator_trace_eq` must be decomposed
  into 3 named sub-lemmas (unit value, `f_*`-reindex, `(g^*⊣g_*)` transpose) — the per-generator
  identity is not closeable as a monolith.
- **Secondary corrective**: Blueprint expansion for `generator_trace_eq` is actually prerequisite
  to re-dispatching the prover at all. The two items are ordered: (1) rewrite `regroupEquiv`
  prescription, (2) split `generator_trace_eq` into sub-lemmas, (3) dispatch prover. Do not
  dispatch until both blueprint items are in place.

---

### Route: GF-alg — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- **Sorry trajectory**: 5 → 4 → (dag, iter-005) → 4. Across the K=4-iter window (003–006), sorry
  count went from 5 to 4 — net -1. However, the net reduction came entirely from iter-004 (L3
  chain, 4 axiom-clean lemmas); the last two prover iters show zero downward movement: 4→4.
- **Helper accumulation**: iter-003 added ~5 helpers (L1–L5 scaffold + L1 proved). iter-004 added 4
  helpers (L3a/L3b/L3c/L3-assembly all axiom-clean). iter-006 added 0 net helpers (the L5
  strong-induction restructure is a structural rewrite of an existing proof body, not a new
  declaration). Total: ~9 helpers added; 5 sorry-eliminations across iters 003–004; 0 in iter-006.
- **Prover dispatch pattern**: 1 file for 3 consecutive prover iters (002, 003, 004, 006 — single
  lane each time). Note: L4 and L5 are independent within the file; no parallel-file split was
  warranted per the iter-006 serial-bottleneck analysis, which this report confirms.
- **Recurring blockers**:
  - "generic-rank SES `0→A_g[X]^m→N_g→T→0` Mathlib-absent" — iter-003 (first stub), iter-004
    (torsion sub-case closed but generic-rank branch sorry), iter-006 (strong-induction IH now in
    scope but SES construction confirmed Mathlib-absent after searching `lean_leansearch` +
    `lean_local_search`). **3 consecutive prover iters.** Under the STUCK criterion, this alone
    would trigger a STUCK finding; see below.
  - "denominator-clearing descent Mathlib-absent (L4)" — iter-003 (stub), iter-004 (Step-2
    unresolved), iter-006 (not attempted; documented as Mathlib-absent). **3 consecutive prover
    iters.**
- **Avoidance patterns**: The L5 structural restructure-to-strong-induction was identified as a
  "correctness blocker" in the iter-006 progress-critic report and correctly deployed in iter-006.
  No avoidance is currently active — the iter-006 corrective was executed as directed.
- **Prover status pattern**: PARTIAL (iter-003), PARTIAL (iter-004), PARTIAL (iter-006) —
  **three consecutive PARTIAL statuses**.
- **Throughput**: SLIPPING. STRATEGY.md estimates 3–5 iters for GF-alg ACTIVE phase. Phase entered
  ACTIVE at iter-003. Iter-007 is the 5th iteration in this phase (4 elapsed). 4 sorries remain
  with both active ones (L4, L5) confirmed Mathlib-absent. The route is within the estimate range
  (4 ≤ 5) but at the upper bound with no closure in sight without blueprint decomposition first.

  **STUCK boundary note**: the generic-rank SES recurring blocker has persisted for 3 prover iters,
  which technically satisfies the STUCK rule ("recurring blocker phrase across ≥3 iters"). However,
  the iter-006 structural advance (IH now verifiably in scope) distinguishes GF-alg from a
  completely stalled route — the L5 strong-induction skeleton IS the structural prerequisite for
  the SES application. I am classifying this CHURNING (not STUCK) based on the iter-006 structural
  progress, but it is at the STUCK boundary: if the blueprint expansion does not produce closeable
  sub-lemma obligations in iter-007, the correct escalation next iter is STUCK.

- **Verdict**: **CHURNING** (at the STUCK boundary; re-assess next iter)
  - Triggered by: PARTIAL prover status ×3 (standalone criterion).
  - Confirming signals: helpers added in 2 of last 2 prover iters with sorry flat at 4 over last 2
    prover iters; 2 recurring Mathlib-absent blockers each ×3 prover iters.
  - Mitigating signal: the L5 restructure landed in iter-006 addresses the iter-006 corrective and
    creates genuine structural precondition (IH in scope) for the SES application.
- **Primary corrective**: **Blueprint expansion — decompose L5 dévissage and L4 denominator-clearing
  into named sub-lemmas.** The iter-006 prover's own effort-break recommendation is exact: L5 →
  `gf_generic_rank_ses` (SES construction `0→A_g[X]^m→N_g→T→0`), `gf_torsion_reindex`
  (re-presents T over `MvPolynomial (Fin m') A`, `m' < d`), thin assembly applying IH + L3 splice.
  L4 → `gf_clear_one_denominator` (single integral-dependence equation) + Finset-fold to common
  denominator + AlgHom assembly. Exact type signatures must be checked against the Noether
  normalisation output (`exists_finite_inj_algHom_of_fg`) before stubbing, as the iter-006 prover
  notes the signatures depend on the generic-rank API choice.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (QuotScheme.lean + GrassmannianCells.lean); cap: 10
- **FBC-A and GF-alg status**: correctly deferred — both require blueprint expansion before prover
  dispatch; they are not "ready" files in the standard sense (blueprint prescription for `map_smul'`
  is wrong; both SES cruxes need sub-lemma decomposition first)
- **Ready but not dispatched**: none — the QUOT-defs frontier files (leandag-cleared, blueprint
  complete+correct per blueprint-reviewer iter-006) are exactly the 2 lanes being opened
- **Over the cap**: no
- **Under-dispatch finding**: no — the 2 files dispatched cover the currently-provable frontier;
  FBC and GF are gated on blueprint work, not available for prover dispatch this iter
- **Verdict**: OK — file count 2, within cap 10, no under-dispatch. The QUOT-defs `[prover-mode:
  mathlib-build]` assignments are sound: chapters are blueprint-complete, tasks are
  definition-building (lower risk), and these lanes run independently while the blueprint writers
  address FBC/GF cruxes in parallel.

---

## Must-fix-this-iter

- **FBC-A: CHURNING — primary corrective: blueprint expansion, two items.** (1) Rewrite the
  `base_change_mate_regroupEquiv` proof prescription in `Cohomology_FlatBaseChange.tex` — the
  current "one-liner via `RegroupHelper`" prescription is mathematically wrong (iter-006 prover
  confirmed definitively). Replace with the transparent-instance recipe using
  `TensorProduct.induction_on` + `ExtendScalars.smul_tmul` + `restrictScalars.smul_def` +
  `tmul_mul_tmul`. (2) Decompose `base_change_mate_generator_trace_eq` into 3 named sub-lemmas
  (unit-value, `f_*`-reindex, `(g^*⊣g_*)` transpose) before the next prover dispatch. Both items
  are prerequisites; neither can be skipped.
- **GF-alg: CHURNING — primary corrective: blueprint expansion.** Decompose L5 dévissage into
  `gf_generic_rank_ses` + `gf_torsion_reindex` + assembly, and L4 into `gf_clear_one_denominator`
  + Finset-fold + AlgHom assembly. The iter-006 prover explicitly flagged the exact type-signature
  dependency on `exists_finite_inj_algHom_of_fg` output — the blueprint writer must check the
  generic-rank API choice and confirm types before stubbing. Do not dispatch a prover until both
  L5 sub-lemmas and L4 sub-lemmas are spec'd with concrete Lean types in the blueprint.
- **FBC-A: OVER_BUDGET throughput.** STRATEGY.md estimates 3–5 iters for FBC-A ACTIVE phase; 5
  have elapsed (iters 002–006) with sorry count UP from entry (3→4) and 2 sorries confirmed
  Mathlib-absent. The strategy estimate must be revised upward — current residues (`map_smul'`
  transparent-instance proof + `generator_trace_eq` 3-step decomposition + `affineBaseChange_pushforward_iso`
  multi-hundred-LOC restriction-compatibility build) will require at minimum 2–3 more prover iters
  after the blueprint expansion. Revise FBC-A estimate to "2–4 iters left" AFTER the blueprint
  expansion landing in iter-007.

---

## Informational

### Dispatch correctness of the QUOT-defs opening

Opening `QuotScheme.lean` and `GrassmannianCells.lean` as `[prover-mode: mathlib-build]` lanes is
correct and not an avoidance pattern. The distinction: FBC/GF are being deferred WITH active
corrective work (blueprint writers dispatched this same iter); the QUOT lanes fill otherwise-idle
prover capacity on blueprint-ready, independently-gated work. This is genuine parallelism, not a
pivot-to-easier-work avoidance. If the blueprint writers do not deliver decomposed sub-lemmas for
FBC/GF this iter, the iter-008 plan must dispatch FBC and GF provers (not find another reason to
defer).

### GF-alg STUCK risk in iter-008

If the blueprint expansion in iter-007 fails to produce concretely-typed sub-lemma obligations for
`gf_generic_rank_ses` and `gf_torsion_reindex` (e.g. because the generic-rank API choice is
unresolved), then GF-alg must be reclassified STUCK in iter-008. The recurring blocker
(generic-rank SES Mathlib-absent, ×3 prover iters) already meets the STUCK threshold — the
iter-006 structural advance is the only mitigating signal, and it expires in the next prover iter
if no sorry is eliminated.

### FBC-A plan reliability note

The "[verified by prover]" annotation in the iter-006 PROGRESS.md was incorrect. The iter-006
prover correctly identified this and flagged it prominently ("Root cause (important — the
'[verified by prover]' premise in PROGRESS is incorrect for this pin)"). Future plan directives
should not carry "verified by prover" annotations for Lean tactic results across Mathlib pin
changes — the verification is pin-specific, and the annotation created false confidence that
misdirected the prover's first attempt this iter.

---

## Overall verdict

Both routes remain **CHURNING**. FBC-A's CHURNING is now more severe than iter-006's diagnosis:
the route carries a provably wrong proof prescription in the blueprint (the `map_smul'` one-liner
was definitively refuted in iter-006 as mathematically impossible at this pin), and sorry count is
net +1 over the 4-iter window. GF-alg's CHURNING sits at the STUCK boundary: the generic-rank SES
blocker is 3 prover iters old (meeting the STUCK threshold), held back from STUCK only by the
genuine L5 strong-induction structural advance in iter-006.

The planner's iter-007 dispatch response — defer both prover lanes and send blueprint writers to
decompose the cruxes, while opening QUOT-defs mathlib-build lanes in parallel — is the **correct
response**. It matches both routes' primary correctives and is not an avoidance pattern (blueprint
writers are active, not deferral without action). The must-fix items are:
(1) the FBC-A blueprint prescription rewrite (not just decomposition — the existing prescription
is wrong and must be replaced),
(2) GF-alg sub-lemma stubbing with correct Lean types (type-signature checking against the
Noether normalisation API is required before the stubs are safe to dispatch against),
(3) FBC-A throughput estimate revision in STRATEGY.md (the route is past the upper estimate bound
and the residue depth is larger than the original estimate assumed).

If iter-007's blueprint writers deliver correctly-typed sub-lemma stubs, iter-008 must dispatch
FBC-A and GF-alg provers immediately — a third consecutive plan-phase-only iter on these routes
would cross into the avoidance-pattern clause regardless of the QUOT-defs progress.
