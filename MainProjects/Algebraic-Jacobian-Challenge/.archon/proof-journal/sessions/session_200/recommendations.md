# Recommendations for iter-201 plan agent

## CRITICAL — must address iter-201

### CRIT-0 — Lane WD-A4a Sub-build 2 next dispatch

The iter-200 Sub-build 1 (open-immersion stalk-bridge) landed 8
axiom-clean substrate decls. The Sub-build 2 (Ring.ordFrac transport
across stalk iso) is now the binding sub-build for closing L535
parent sorry. Per the Lane WD prover handoff:

```lean
lemma Ring.ordFrac_ringEquiv {R S : Type*} [CommRing R] [IsDomain R]
    [IsNoetherianRing R] [Ring.KrullDimLE 1 R]
    [CommRing S] [IsDomain S] [IsNoetherianRing S] [Ring.KrullDimLE 1 S]
    (e : R ≃+* S) (K_R K_S : Type*) [Field K_R] [Field K_S]
    [Algebra R K_R] [IsFractionRing R K_R]
    [Algebra S K_S] [IsFractionRing S K_S]
    (e_K : K_R ≃+* K_S)  -- compatible with e on R-image
    (x : K_R) :
    Ring.ordFrac S (e_K x) = (Multiplicative.ofAdd ∘ ...) (Ring.ordFrac R x)
```

~30-50 LOC project-side; clean Mathlib upstream PR candidate. Dispatch
as a mathlib-build lane on `RiemannRoch/WeilDivisor.lean`.

### CRIT-1 — Lane COE iter-201+ main effort

Substrate Step 1+2 + Step 3 additive form landed iter-200. The
**substantive iter-201+ residual** is the Jacobian-regular-sequence
witness (Stacks 00SW / 00OW). Per Lane COE prover handoff:

```lean
-- ~30-60 LOC project-side, all Mathlib pieces EXIST
Algebra.SubmersivePresentation.relations_isRegular_in_localization
  -- via Algebra.SubmersivePresentation.jacobian_isUnit (EXISTS)
  --   + RingTheory.Sequence.isRegular_cons_iff (EXISTS)
  --   + IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal (EXISTS)
```

Then scheme-to-algebra bridge for `isRegularLocalRing_stalk_of_smooth`
L1061 inline closure (extract `SubmersivePresentation` from
`Algebra.IsStandardSmooth (Γ(Spec, U)) (Γ(X.left, V))` chain + identify
max ideal at z). Dispatch as a 2-helper-budget mathlib-build lane;
the closure cascades to Lane T32 re-engagement (binding trigger met).

### CRIT-2 — Lane AB iter-201+ Stacks 00MF route

The iter-200 ALIGN_WITH_MATHLIB pivot landed 4 substrate helpers
axiom-clean. Step (iii) inductive assembly is blocked on Stacks 00MF
(`pd M > 0 ⟹ depth M < depth R`) — ~150-200 LOC Mathlib gap
candidate; a clean upstream PR target.

**Alternative iter-201+ exploration**: a refined LES analysis to prove
`depth K ≤ depth M + 1` directly via Ext connecting-map injectivity
would obviate 00MF for the AB use case. Consider dispatching a
mathlib-analogist `ab-00mf-vs-les` to assess viability before
committing a prover lane.

**Dead ends (do NOT retry, per iter-200 task report)**:
- The literal `ChainComplex ℕ (ModuleCat R)` carrier route is **doubly
  confirmed DEAD**: 3-4× over budget AND blocked on a separate
  termination-of-syzygy-tower lemma absent in Mathlib b80f227.
- The classical Stacks 090V path (induct on `depth M`; use 00MF base +
  snake lemma on minimal resolution) is gap-blocked at both
  ingredients.

## HIGH — chapter expansions needed (plan-agent edits)

### MED-3 — Lane COE blueprint expansion

Per Lane COE prover handoff, the chapter needs (a) new `\lean{...}`
pins for the 7 iter-200 substrate decls (prefixed
`AlgebraicGeometry.Scheme.`); (b) new subsection
`\subsec:stage6_iib_substrate_iter200` documenting Step 1+2 closures
+ iter-201+ residual (Jacobian-regular-sequence witness); (c) update
Stage 6.A description to note Step 2 polynomial-side has now landed
axiom-clean via these private helpers.

### MED-4 — Lane WD blueprint expansion

Per Lane WD prover handoff, add new section / subsection (suggested
title: `\section{Open-immersion descent for prime divisors}`) citing
Stacks 02IZ + iter-183 CoheightBridge substrate. Pin the 5
substantive substrate decls: `restrictToOpen`, `ofOpen`, `equivOpen`,
`stalkIso`, `IsRegularInCodimensionOne.instOpen`.

### MED-5 — Lane AB blueprint expansion

Per Lane AB prover handoff:
- Update `\subsec:ab_gap1_first_step` (or add a new sub-subsection
  `\subsubsec:ab_gap1_haspdlt_pivot`) noting the iter-200
  ALIGN_WITH_MATHLIB pivot reduces gap (1)'s "full chain complex"
  cost to 4 axiom-clean per-syzygy helpers; add `\lean{...}` pins
  for the 4 new `RingTheory.Module` helpers.
- Reclassify gap (3) (snake lemma on minimal resolution) from "open"
  to **OBVIATED** — the HasProjectiveDimensionLT SES-descent path
  obviates it entirely.
- Sketch a recipe for gap (2) Stacks 00MF (the binding closure gap)
  if a clean prose strategy is available; otherwise flag as iter-201+
  exploration target.

## MEDIUM — strategic items

### MED-6 — STRATEGY.md format-compliance pass

Iter-200 plan agent's response to iter-200 strategy-critic flagged
format compliance (316 → 331 lines this iter) as PARTIAL with a
deferred aggressive iter-201 pass: (a) move closure-history
parentheticals to iter sidecars; (b) shrink `## Routes` Candidate
(a) / Candidate (b) descriptions; (c) target ≤250 lines / ≤12 KB.
Plan agent task.

### MED-7 — IsEtale functor-of-points alternative for Pic⁰ pivot

Iter-200 strategy-critic CHALLENGE on Pic⁰ pivot named IsEtale FoP
alternative as investigation-pending. Dispatch a mathlib-analogist
`pic0-isetale-fop` to assess viability for arbitrary smooth proper
`C/k` (no fppf-section assumption); report to OSQ + Phases-table-row
decision.

### MED-8 — RPF / FGA dependency-cascade documentation

Iter-200 plan-phase progress-critic verdict was STUCK + OVER_BUDGET
on RPF and STUCK with dependency cascade on FGA. The iter-200 plan
agent's blueprint-writer `tensorobj-substrate-chapter` is the primary
corrective; iter-201 must verify the chapter yields at least 1
concrete sorry-closing prover round on RPF (i.e. iter-201 dispatches
a prover lane consuming the new `Picard_TensorObjSubstrate.tex`
chapter). If iter-201 RPF prover lane does not produce closure or
substantive structural advance, escalate to USER per the iter-200
progress-critic's recommendation.

## LOW — informational

### LOW-1 — Reusable proof patterns landed iter-200

Promoted to `PROJECT_STATUS.md ## Knowledge Base ### Proof Patterns`
this iter (4 new entries):

1. HasProjectiveDimensionLT SES descent (Mathlib-aligned syzygy
   descent for AB-style pd/depth arithmetic).
2. MvPolynomial maximal-ideal height = n via `finSuccEquiv` +
   `Polynomial.height_eq_height_add_one` + Jacobson contraction.
3. `Scheme.Opens.stalkIso` thin-wrap pattern for prime-divisor
   open-immersion descent.
4. MvPolynomial Step 3 additive form for regular-sequence dim drop
   (NO `HSub` on `WithBot ℕ∞`; the additive form is the natural API).

### LOW-2 — Plan-phase critic outcomes (for completeness)

The iter-200 plan-phase progress-critic, strategy-critic, blueprint-
reviewer, blueprint-writer (`tensorobj-substrate-chapter`), and
mathlib-analogist (`coe-stacks00oe`) all returned and were addressed
by the iter-200 plan agent per `iter/iter-200/plan.md` Sections
`## Strategy-critic route200 response`, `## Blueprint-reviewer iter200
response`, and the dispatch table at `## Subagent dispatches`.
Read those sections for the full plan-agent rationale before
finalising iter-201 strategy.

### LOW-3 — Review-phase subagents (iter-200 review) — outcomes merged

All 4 review-phase subagents returned. Summary:

- **lean-auditor `iter200`**: 44 files audited; **2 must-fix-this-iter
  (BOTH carry-over from iter-198/199)**, 2 major, 2 minor. The 19 new
  iter-200 substrate declarations are **all clean** — no
  headline-laundering patterns. Carry-overs:
  - `RelPicFunctor.lean:266-269` — `-- TODO (Scheme.Modules monoidal
    gate)` excuse-comment + `exact sorry` on `addCommGroup` instance
    body. Resolution requires the iter-201+ RPF prover lane (see
    MED-8) or USER-directed Mathlib upstream PR.
  - `AlbaneseUP.lean:179-183` — `bundle : Bundle C := sorry` typed-
    sorry on load-bearing carrier with "placeholder" excuse-comment
    docstring. Resolution gated on A.3 row chapter (Route C PAUSED;
    pending USER decision per `TO_USER.md`).
  Both have been escalated multiple iters; the iter-200 plan agent
  did not address them. **Recommend** the iter-201 plan agent either
  (a) take affirmative action (e.g., demote
  `RelPicFunctor.addCommGroup` instance to a non-instance lemma per
  the iter-193 KB pattern, since the carrier-soundness probe iter-199
  rejected placeholder bodies on this surface), or (b) explicitly
  document why action is impossible this iter.

- **lean-vs-blueprint-checker `wd-iter200`**: 15 declarations checked,
  all existing pins resolve, **0 broken pins**. 5 of the 8 new
  iter-200 substantive declarations lack `\lean{...}` pins
  (`restrictToOpen`, `ofOpen`, `equivOpen`, `stalkIso`, `instOpen`);
  no blueprint section exists for open-immersion descent. **Severity
  `soon`** — needed before iter-201+ Sub-build 2 prover dispatch.
  Action: see MED-4 above.

- **lean-vs-blueprint-checker `ab-iter200`**: 10 declarations checked,
  3 major blueprint-side findings, **0 must-fix Lean-side**. The 4
  new HasProjectiveDimensionLT helpers are entirely absent from the
  chapter; ALIGN_WITH_MATHLIB pivot undocumented; gap (3) marked
  OBVIATED in Lean docstring but still listed as "absent" in the
  blueprint table. **Plus** one unresolved blueprint→Lean **MAJOR**:
  `auslander_buchsbaum_formula_succ_pd` remains `private` in Lean
  despite a public `\lean{...}` pin in the blueprint (2-iter-old
  iter-199 NOTE explicitly named two resolution options; iter-200 took
  neither). Review agent added a follow-on `% NOTE iter-200 review`
  to the chapter calling this out for the iter-201 plan agent.
  Action: see MED-5 + new **MED-5a** below.

- **lean-vs-blueprint-checker `coe-iter200`**: 12 declarations checked,
  all existing pins resolve; 0 must-fix-this-iter; 3 `soon`
  (blueprint inadequacy for iter-201+ Jacobian-regular-sequence
  prover); 1 minor (stale decl name in Lean docstring at L659). The
  Stage 6.A description still reads "NEEDS-BRIDGE; ~200-300 LOC" when
  Steps 1+2 are done and Step 3 is partially scaffolded. Action: see
  MED-3 above.

### MED-5a — Resolve `auslander_buchsbaum_formula_succ_pd` private/public mismatch

Per iter-199 lean-vs-blueprint-checker NOTE and re-confirmed by
iter-200 ab-iter200 checker: the chapter pins
`\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}` but the Lean
declaration is `private` (now at L1517 post-iter-200 substrate
shift). `sync_leanok` may not resolve private decls cleanly. Two
options were named in iter-199 (preferred: drop `private` from the
Lean side). Iter-200 plan agent did not act. **iter-201 plan agent
must pick one and dispatch a refactor subagent (option 1) or remove
the pin (option 2)** — this is a 2-iter-stale must-fix-eventually
item that blocks marker hygiene.
