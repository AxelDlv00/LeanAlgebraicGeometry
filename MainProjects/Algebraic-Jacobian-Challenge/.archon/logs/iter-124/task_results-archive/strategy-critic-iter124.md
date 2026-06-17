# Strategy Critic Report

## Slug
iter124

## Iteration
124

## Routes audited

### Route: M1 — Bridge presheaf ↔ algebra-Kähler (OFF the critical path)

- **Goal-alignment**: FAIL — M1 is openly OFF the critical path for closing the protected chain; it introduces a new `sorry` and then closes it. The project's stated goal is the nine protected declarations, all of which `lean_verify` to one `sorryAx` rooted at `Jacobian.lean:179`. M1 does not touch that chain. The strategy admits this in plain prose.
- **Mathematical soundness**: PASS — the algebra-Kähler bridge as stated (LinearEquiv at the `appLE` level, using `IsLocalization.of_le` + `FormallyUnramified.of_isLocalization` + `KaehlerDifferential.exact_mapBaseChange_map`) is a sound, standard construction. Mathlib lemmas named are verified to exist.
- **Sunk-cost reasoning detected**: yes — multiple instances; see § Sunk-cost flags below.
- **Phantom prerequisites**: none new; M1's named Mathlib levers all verify.
- **Effort honesty**: under-counted — M1.b's original budget was "2–3 iter / 100–250 LOC" and iter-124 will be the **third** consecutive iter on M1.b (after iter-122 PARTIAL, iter-123 PARTIAL). The "3-iter" upper bound is being met *with one residual `sorry` still open*. The strategy is silent on what happens at iter 4, 5, … of the same step.
- **Verdict**: **CHALLENGE**
  - The route itself is sound, but the project's *decision to spend iter-124 on it* is not defensible against the planner's own pre-committed pivot rule (see Must-Fix § 1).

### Route: M2 — Genus-0 witness `genusZeroWitness`

- **Goal-alignment**: PASS — closing `genusZeroWitness` IS half of the genus-stratified body of `nonempty_jacobianWitness`. Direct progress on the protected chain.
- **Mathematical soundness**: PARTIAL — the C(k) ≠ ∅ / C(k) = ∅ split is mathematically correct; the base-change-to-k̄ + descent argument is the textbook treatment for Brauer–Severi obstructions. The M2.d (RR-path) decomposition is honest. The M2.d-alt char-p hazard is now acknowledged; the three handling options are real but each is itself substantial work.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: three (M2.c Galois descent of morphism equality, M2.d-alt abelian-variety cotangent triviality, base-change-to-k̄ rational-point existence `geomIrred.exists_kalg_pt`). All three were scheduled for iter-124 spot-checks and **none have been resolved**. My own quick `lean_leansearch` confirms all three still appear absent from Mathlib (see § Prerequisite verification). The strategy estimates for M2.c (3–6 iter) and M2.d-alt (10–20 iter) hinge on these prereqs existing; if absent (as appears likely), the estimates revise upward by 2–4× as the strategy itself notes.
- **Effort honesty**: probably under-counted on M2.a — the "Rigidity.lean refactor" gating M2.a is mentioned but never scoped. The strategy treats it as "iter-124 plan-phase deliverable iff M1.b CHURNING repeats," but the refactor's size determines whether M2.a's 2–3-iter estimate is realistic. A 2-iter prover lane on a step that depends on a multi-iter refactor that hasn't been scoped is a planning gap.
- **Verdict**: **CHALLENGE**

### Route: M3 — Positive-genus witness `positiveGenusWitness`

- **Goal-alignment**: PASS — closes the other half of `nonempty_jacobianWitness`.
- **Mathematical soundness**: PASS — Route A (Picard via FGA) and Route B (Sym^n + Stein) are both textbook, and the top-3 gating pieces per route are correctly named.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none unverified that aren't already labeled gaps.
- **Effort honesty**: reasonable — the iter-123 audit's per-piece numbers (Route A ~6500 LOC, Route B ~9000 LOC) are realistic for the named scope; I have no quarrel with them. Both exceed the 5000-LOC hard-fallback threshold.
- **Verdict**: **CHALLENGE** — the hard-fallback rule said escalation triggers automatically when the threshold is exceeded; iter-123's audit met the trigger. Deferring escalation to "iter-124 plan-phase deliverable" instead of firing it in iter-123 is a one-iter procedural slip. Also, the escalation message to the user has not been drafted; without a concrete proposal (e.g., "post an upstream PR for Relative Spec; pivot to M2.a in the wait window; accept a named axiom if upstream rejects"), the user has nothing to act on. See Must-Fix § 3.

### Route: Sequencing (overall iter-by-iter plan)

- **Goal-alignment**: FAIL on the multi-month horizon — if M3 escalates to upstream PRs (weeks to months of wait), the strategy's sequencing has no productive work plan for the wait window. M2.a + Rigidity refactor are the obvious fillers but are queued *behind* M1.b in the current ordering.
- **Mathematical soundness**: n/a.
- **Sunk-cost reasoning detected**: yes (see § Sunk-cost flags).
- **Verdict**: **CHALLENGE**

## Alternative routes (suggested)

### Alternative: Pivot to M2.a + Rigidity refactor NOW, without waiting for the iter-124 CHURNING verdict

- **What it looks like**: Iter-124 plan agent skips the M1.b prover lane this iter, dispatches the `Rigidity.lean` refactor-scoping subagent (an analysis task, no Lean-source edits), and queues M2.a as the iter-125 prover lane. The Rigidity refactor itself runs iter-125. M2.a as a prover lane runs iter-126. In parallel, iter-124 fires the M3 user-escalation deliverable (long overdue from iter-123).
- **Why it might be cheaper or sounder**: M2.a is on the critical path; M1 is not. The strategy's own "critical-path preference" rule implies M2.a should be prioritized when it is workable. The Rigidity refactor blocking M2.a is not work that gets cheaper by being deferred. Doing it now while M1.b is also viable means the project has a parallel lane ready if M1.b returns PARTIAL again at iter-124's close.
- **What the current strategy may have rejected**: the strategy treats the pivot rule as procedurally gated ("requires 2 CHURNING verdicts"). The fresh-reader objection is that the spirit of the rule has clearly fired — iter-118, iter-119, iter-122, iter-123 all PARTIAL on the same chain (`appLE_isLocalization` body) — and rule-lawyering one more iter delays an obviously-needed pivot.
- **Severity of the omission**: **critical**

### Alternative: Escalate to the user with a named-axiom proposal alongside the upstream-PR proposal

- **What it looks like**: The iter-124 M3 escalation message presents the user with three options, not one: (i) post upstream PRs and continue with M2.a + Rigidity refactor in the wait window, (ii) accept a named project axiom for the protected chain (signature unchanged; `lean_verify`s to one named axiom + kernel axioms), (iii) some hybrid. The user picks.
- **Why it might be cheaper or sounder**: The strategy unilaterally rules out option (ii) citing a plan-agent standing rule ("never propose adding new axioms") that, on its face, conflicts with the user pivot directive (which IS the iter-121 user instruction). The fresh-reader view: the plan agent's standing rule should not override a user directive that explicitly asks the loop to operate differently. If the iter-122 critic considered named-axiom worth raising as an alternative end-state, the user — not the agent — should decide whether it's on the table. Escalating with a single forced choice ("post PRs and wait months") is not honest escalation.
- **What the current strategy may have rejected**: the local-takes-precedence framing argument is plausible but worth user confirmation. The strategy's appeal to the standing rule reads as the agent overriding the user's prior instruction without asking.
- **Severity of the omission**: **major**

### Alternative: Treat M1 as off-loop work (separate branch / PR), not loop work

- **What it looks like**: M1 is a clean Mathlib-contribution candidate. Instead of consuming loop iterations on it, mark it as "ready-to-extract; track in `analogies/` for an off-loop hand-formalization by the mathematician or as a separate AI-tool run." Loop iterations focus exclusively on the critical-path work for the protected chain.
- **Why it might be cheaper or sounder**: The user pivot directive ("act as a Mathlib contributor") does not require *every loop iteration* to be a Mathlib-contribution iteration. Being a contributor across the project's lifetime is consistent with the loop budget being spent on the actual goal. M1 is the kind of work that benefits from focused, batched effort by a single contributor over a long uninterrupted session, not a stop-and-start drip across many loop iterations (which is what we observe: 6 iters from iter-118 to iter-123 with the same partial state).
- **What the current strategy may have rejected**: unclear from prose. The strategy reads as if "Mathlib contribution" and "loop budget" are the same thing. They aren't.
- **Severity of the omission**: **major**

## Sunk-cost flags

- `Iter-122 chose M1 over M2.a (rigidity over k̄, the smallest on-critical-path step) for two reasons: (i) M1's blueprint was fully detailed with analogist-verified Mathlib alignment` — Why this is sunk-cost: "the blueprint is detailed because we've worked on it" is sunk-cost reasoning that the prior critic flagged; the strategy explicitly acknowledges this but then continues to lean on the resulting detail to justify continuation rather than fixing the root cause (M2.a's prerequisite Rigidity refactor was never scoped). Recommendation: scope the Rigidity refactor this iter; pivot to M2.a on its own merits.

- `iter-124 continues M1.b (does NOT fire the M2.a pivot)` based on `substantial Step 1+3+4 closure (well, Step 1+4 with Step 3 deferred-but-tightly-scoped)` — Why this is sunk-cost: the iter-123 pre-commitment was "Step 1+3+4 closure"; the actual outcome is Step 1+4 closure with Step 3 *packaged into a new residual sorry*. The parenthetical "well, ..." reveals the planner is aware Step 3 was not actually closed. Relabelling "Step 1+4 with Step 3 deferred" as "substantial Step 1+3+4 closure" is moving the goalposts to permit continuation. Recommendation: hold the planner to the pre-committed standard. Iter-124 should pivot per the original rule, or the strategy should rewrite the pre-commitment honestly (e.g., "continue M1.b if at most one residual sorry remains after iter-123") rather than mid-flight reinterpreting "substantial."

- `Iter-123 progress-critic returned CHURNING on M1 ... this is the FIRST CHURNING verdict ... Iter-123 ... continues M1.b. Iter-124 plan agent is committed to ... pivot to M2.a only if CHURNING continues into iter-124 (the rule's 2+ iters trigger fires)` — Why this is sunk-cost: the planner is using strict procedural reading of the pivot rule ("needs another CHURNING verdict") to justify one more iter on M1.b when the underlying signal (4 of last 6 iters PARTIAL on the same theorem) clearly indicates the pivot is overdue. The 2-iter rule was meant as a *floor*, not a *ceiling*. Recommendation: when the pattern is unambiguous, pivot without waiting for procedural compliance.

## Prerequisite verification

| Mathlib name | Status |
|---|---|
| `IsLocalization.of_le` | **VERIFIED** (`Mathlib.RingTheory.Localization.Defs`) |
| `KaehlerDifferential.exact_mapBaseChange_map` | **VERIFIED** (`Mathlib.RingTheory.Kaehler.Basic`) |
| `KaehlerDifferential.range_mapBaseChange` | **VERIFIED** (companion lemma; equivalent formulation) |
| `Algebra.FormallyEtale.subsingleton_kaehlerDifferential` | **VERIFIED** (the closer analogue Mathlib actually has for what M1.c needs; cite this rather than only `FormallyUnramified.of_isLocalization`) |
| `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` | VERIFIED per prior strategy claim (not re-checked) |
| `IsAffineOpen.appLE_eq_away_map` | VERIFIED per prior strategy claim (not re-checked) |
| `AlgebraicGeometry.Scheme.descent_morphism` / `Scheme.Pullback.descent_morphismEq` / `IsLocalGalois.descent_morphism` (M2.c) | **MISSING / PHANTOM** — `Mathlib.AlgebraicGeometry.Morphisms.Descent` exists, but its hits are about descent of morphism *properties* (`IsLocalAtTarget.descendsAlong`, `HasRingHomProperty.descendsAlong`), not descent of morphism *equality*. The specific "two scheme morphisms equal iff equal after Galois base change" lemma was not located. |
| `AbelianVariety.cotangent_trivial` / `GroupScheme.Omega_trivial` (M2.d-alt) | **MISSING / PHANTOM** — no hits. Mathlib has cotangent infrastructure for Kähler differentials but nothing packaged as abelian-variety cotangent triviality. |
| `geomIrred.exists_kalg_pt` (M2 base-change) | **MISSING / PHANTOM** — no hits. `Algebra.IsGeometricallyReduced` machinery exists but not the "geometrically irreducible ⇒ has alg-closure rational point" witness lemma. |

Three of the three phantom prereqs the iter-123 critic flagged remain unverified after the iter-124 spot-check that this critic conducted on the planner's behalf. The strategy's M2.c and M2.d-alt effort estimates are therefore unreliable — both should revise upward per the strategy's own contingency clauses, or the strategy should commit to building the missing infrastructure as named sub-tasks.

## Must-fix-this-iter

1. **Route M1 — CHALLENGE**: Either pivot to M2.a now (preferred — see Alternative § 1) or rewrite the iter-123 pre-commitment honestly. The current rephrasing of "Step 1+4 with Step 3 deferred" as "substantial Step 1+3+4 closure" violates the pre-commitment as written; the planner must either honor the original commitment and pivot, or amend the commitment with a documented rationale in `iter/iter-124/plan.md` that names the rule change explicitly.

2. **Route M2 — CHALLENGE**: Three phantom prereqs remain unverified (M2.c Galois-descent-of-morphism-equality, M2.d-alt abelian-variety cotangent triviality, `geomIrred.exists_kalg_pt`). The iter-124 plan must either (a) run the spot-checks this iter and update STRATEGY.md M2.c / M2.d-alt estimates if missing, or (b) explicitly defer the M2.c / M2.d work past iter-130 (the strategy's own date) with an acknowledgement that the estimates are unreliable until checked. Also: scope the `Rigidity.lean` refactor that gates M2.a — its size is currently unknown but determines whether M2.a's 2–3-iter estimate is realistic.

3. **Route M3 — CHALLENGE**: User escalation should fire **this iter** (the iter-123 audit already met the hard-fallback trigger; the strategy text labels it as already triggered: "user escalation is triggered for iter-124"). The escalation message must present at least two options — upstream-PR-and-wait *and* named-axiom — and let the user pick rather than the agent forcing a single choice. The strategy's appeal to a plan-agent standing rule against named axioms should be referred to the user, not unilaterally enforced.

4. **Sequencing — CHALLENGE**: The strategy lacks a "multi-month wait window" plan. If M3 escalates to upstream PRs taking weeks-to-months, the loop needs an iter-by-iter activity for that window. M2.a + Rigidity refactor + M2.c + M2.d-alt spot-checks are the obvious queue. The current "M2.a as a prover lane is then iter-126+" sequencing is too lazy — name a concrete iter-124 / iter-125 / iter-126 sequence that fills the wait window, rather than deferring sequencing decisions to the iter that triggers them.

5. **Alternative § 3 (M1 as off-loop work) — major**: Strategy should explicitly address whether the user pivot directive requires *every* loop iter to be Mathlib-contribution-shaped, or whether Mathlib-contribution work can be tracked off-loop while loop iters focus on the protected chain. This re-framing alone could free 3–5 iters' worth of budget for the critical path.

## Overall verdict

A fresh mathematician would **not** approve this strategy as-is. The roadmap itself (M1/M2/M3 decomposition, sub-step naming, prereq inventory) is reasonable, but the **iter-124 execution decisions** layered on top are flawed in three ways: (1) the pivot rule that should fire this iter is being procedurally rule-lawyered to permit one more iter of off-critical-path work; (2) the M3 user escalation that the strategy itself says is "triggered for iter-124" is presented as a single forced option (upstream PR + wait) rather than as honest options including a named-axiom path; (3) the three phantom prereqs flagged last iter remain unverified and the planner is set to dispatch a third prover lane on M1.b without resolving them. The strategy is one honest mid-iter pivot away from being sound; without that pivot it continues a pattern the prior critic correctly flagged.

