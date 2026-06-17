# Progress-critic directive — iter-031

Assess convergence per active prover route. Verdict per route: CONVERGING / CHURNING / STUCK / UNCLEAR.
For CHURNING/STUCK name the corrective TYPE.

## Route FBC — `Cohomology/FlatBaseChange.lean`

The crux sorry `base_change_mate_fstar_reindex_legs` (the affine base-change "inner reindex" identity),
plus its gated dependents `gstar_transpose`, affine, FBC-B. Last 4 prover rounds:

- R-026: sorry 5→4 (closed `inner_value_eq` via cascade). PARTIAL. blocker: "X.Modules instance diamond".
- R-028: 4→4. +2 helpers. PARTIAL. blocker: "keyed rewriting (rw/simp/erw) walled vs X.Modules diamond".
- R-029: 4→4. +0 new decls (diagnostic + cleanup riders). PARTIAL. blocker: "keyed rewriting CONCLUSIVELY
  dead — even rw of a rfl-true copy of the goal's own factor fails (kabstract can't see through the
  category/comp instance diamond)".
- R-030: 4→4. +1 helper (`link_distributeCollapse`, axiom-clean). PARTIAL. ADVANCE: the term-mode splice
  passed the step-(iii) distribution wall *inside the locked main goal* (blocked iters 026–029). Residual:
  eCancel telescoping of factors 2 & 4 against the unfolded codomain-read across the `gammaPushforwardIso`/
  `MidColl` transport layer — "the deep naturality core; needs more term-mode splicing than fit the budget".

Recurring blocker phrase: "X.Modules instance diamond defeats keyed rewriting". Mechanism (term-mode
`congrArg`/`.trans`/`exact` splice of shipped eCancel atoms) is now empirically validated and advancing the
sorry structurally each round, but the inline sorry COUNT has been 4 for 3 rounds.

STRATEGY row (FBC-A): Iters-left estimate = 2–3; phase entered iter-018 (≈13 elapsed); flagged OVER_BUDGET
with an explicit iter-032 user-escalation tripwire.

Proposed iter-031 objective: [fine-grained] build the 3 remaining legs-context wrapper lemmas
(`_link_cancelEUnit`, `_link_cancelPullbackComp`, `_link_survivor`) each as a standalone clean-term lemma
(single instance ⇒ no diamond), then assemble `_legs` by one closing splice; cascade `gstar_transpose`.
This continues the validated term-mode mechanism at finer granularity (not a reworded re-dispatch of keyed
rewriting). Is this churn, or a justified continuation?

## Route QUOT — `Picard/QuotScheme.lean` (gap1 cone)

Building "bridge C" (`overRestrictIso`) toward gap1 (`isIso_fromTildeΓ_of_isQuasicoherent`). The 4 inline
sorries are protected stubs (out of scope); progress is measured in axiom-clean infra decls toward gap1.

- R-026: +5 glue decls (G1-core reduced to the single lemma gap1).
- R-028: +2 axiom-clean helpers.
- R-029: +1 axiom-clean (finite-cover front `exists_finite_basicOpen_cover_le_quasicoherentData`).
- R-030: +6 axiom-clean (bridge C step 1: the over-site↔open-subspace sheaf-category equivalence
  `overEquivalence_sheafCongr` + 5 (co)continuity/dense-subsite instances) — filled an explicit Mathlib
  `Topology/Sheaves/Over.lean` TODO. Next obstacle now precisely identified: step 2 = geometric ring-sheaf
  identification (was topos-theoretic, now geometric). Prior STUCK belief "no restriction functor" proven
  FALSE (Mathlib has `Scheme.Modules.restrictFunctor`/`pullback`).

R-030 critic verdict was STUCK; corrective taken = mathlib-analogist consult (returned a corrected 4-step
decomposition C→P1→D→assemble), and R-030 then landed step 1 of C axiom-clean.

STRATEGY row (QUOT-defs): Iters-left = 4–8; phase ACTIVE (infra-gated); gap1 is the sub-build, now
decomposed into C (step1 done, step2-4 remain) → P1 → D (Stacks 01HA keystone) → assembly.

Proposed iter-031 objective: [mathlib-build] build bridge C step 2 (ring-sheaf identification) → step 3
(`pushforwardPushforwardEquivalence`) → step 4 (`restrictFunctorIsoPullback`) ⟹ `overRestrictIso`, as far
as axiom-clean progress allows; precise handoff if blocked. Converging or still stuck?

## Route GR — `Picard/GrassmannianCells.lean`

Building the glued Grassmannian scheme: standalone cocycle ring identity `Φ=id`, then `theGlueData`
(`Scheme.GlueData`), then `Grassmannian.scheme := theGlueData.glued`. File has 0 inline sorries (all
targets are NEW declarations that do not yet exist).

- R-026: +11 axiom-clean decls (transition layer + pullback iso).
- R-028: +4 axiom-clean (`t'`, `t_fac`, ring identity; cocycle reduced to the ring identity `Φ=id`).
- R-029: NO OUTPUT — no task_result, no edits.
- R-030: NO OUTPUT — no task_result, no edits.

IMPORTANT diagnostic the planner has CONFIRMED (do not mis-read R-029/R-030 as a math wall): the no-output
rounds were caused by the loop's no-op objective filter, which silently DROPS a 0-sorry file from the
prover dispatch unless the objective text carries a scaffold keyword. The prior GR objectives said
"NEW-declaration build" — which the filter's regex does NOT match — so the GR lane was never dispatched.
The planner has fixed the iter-031 objective wording to include the scaffold keyword (verified against the
filter regex in `sorry_count.py`), so GR WILL dispatch this iter. The math (cocycle categorical reduction
to a pure-ring identity) is already solved and documented in an in-file HANDOFF comment.

STRATEGY row (GR-glue): Iters-left = 1–3; phase ACTIVE; self-contained, no keystone dependency.

Proposed iter-031 objective: [mathlib-build] "scaffold + prove" the new declarations (cocycle ring identity,
`theGlueData`, `Grassmannian.scheme`). Given the diagnosis above, is the right read here UNCLEAR/CONVERGING
(dispatch bug now fixed) rather than STUCK (math wall)? Flag if you disagree with the dispatch-bug diagnosis.

## Dispatch sanity
3 files, one prover each, import-independent. Proposed objective basenames:
`FlatBaseChange.lean`, `QuotScheme.lean`, `GrassmannianCells.lean`.
