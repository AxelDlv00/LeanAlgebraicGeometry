# Progress Critic Directive

## Slug
iter132

## Iter
132

## Active routes / files under review

### Route 1: `AlgebraicJacobian/Cotangent/GrpObj.lean` (piece (i.a))

- **Started at iter**: 128
- **Iters audited**: 128, 129, 130, 131 (full 4-iter window; K = 4)

#### Sorry counts per iter (in this file only; project total in parens)
- iter-128: 0 (3) — file created; body landed in 1 prover lane.
- iter-129: 0 (3) — plan-phase-only refactor (rename + signature relax);
  no body change.
- iter-130: 0 (3) — prover lane swapped body to Replacement (B)
  chart-base-change form.
- iter-131: 0 (3) — refactor lane reshaped body from `by`-tactic
  (Classical.choice) to pure-term `noncomputable def` (Classical.choose-chain);
  added strong acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars`.

#### Helpers/declarations added per iter
- iter-128: 1 (`AlgebraicGeometry.GrpObj.lieAlgebra`) — definition + body.
- iter-129: 0 (renamed `lieAlgebra` → `cotangentSpaceAtIdentity`;
  signature relaxed; no new declarations).
- iter-130: 0 (body of `cotangentSpaceAtIdentity` swapped; no new declarations).
- iter-131: 1 (`cotangentSpaceAtIdentity_eq_extendScalars` — strong
  acceptance lemma closing by `refine … rfl⟩`).

#### Prover statuses per iter
- iter-128: COMPLETE — body landed kernel-clean, passed iter-128 acceptance
  test. (Later flagged by iter-129 mathlib-analogist as **mathematically
  degenerate**: body collapses to zero `k`-module for the entire consumer
  class.)
- iter-129: NO PROVER DISPATCH — plan-phase-only fix-up iter (refactor
  + critics + blueprint-writer + analogist; no prover lane).
- iter-130: COMPLETE — body swapped to Replacement (B), passes iter-130
  acceptance test on literal terms (≥30 LOC, references
  `smooth_locally_free_omega` + `Algebra.IsStandardSmoothOfRelativeDimension`,
  not `simp`-only). (Later flagged by iter-130 lean-auditor as
  **structurally opaque past `Nonempty`**: outer `Classical.choice`
  wrapping discards the chart-base-changed Kähler module's accessibility
  for the deferred rank lemma.)
- iter-131: NO PROVER DISPATCH (refactor + critics + analogist + writer).
  The refactor lane delivered a pure-term `noncomputable def` body
  + strong acceptance lemma that closes by `rfl` (testable deliverable
  per the iter-131 strategy-critic's must-fix Q2). The prover dispatched
  was a no-op (the iter-131 task_result reports "COMPLETE; no proof
  work needed; minor docstring cleanup only" — the loop scheduled a
  prover this iter but the iter-131 plan explicitly stated NO prover
  dispatch and the refactor agent had already landed all changes).

#### Recurring blocker phrases
- "Classical.choice / `Nonempty` opacity" — appears in iter-130 review
  must-fix (lean-auditor) and iter-131 mathlib-analogist's
  ALIGN_WITH_MATHLIB verdict on the iter-130 body (`Init/Classical.lean:19-32`
  kernel-level fact). The iter-131 refactor lane addressed this by
  switching to `Classical.choose`-chain pattern; the iter-131 strong
  acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars` closes
  by `refine … rfl⟩` empirically. Resolved iter-131.
- "computes zero `k`-module / kernel-clean but mathematically degenerate"
  — appears in iter-129 mathlib-analogist verdict on the iter-128
  body. Resolved iter-130 by Replacement (B) body swap.
- "deferred to next iter / blueprint-writer staged" — appears in iter-131
  for the RigidityKbar.tex Piece (i.a) writer (deferred to iter-132 by
  directive override). Iter-132 will dispatch.

#### Planner's current proposal for this iter

Iter-132 fires a prover lane on `AlgebraicJacobian/Cotangent/GrpObj.lean`
to **scaffold + close** the rank lemma `cotangentSpaceAtIdentity_finrank_eq`
against the iter-131 refactored body. The closure chain is documented
end-to-end in `analogies/cotangent-body-shape.md` § "Rank-lemma closure
chain end-to-end" (6 steps; all `[verified]`):

1. `unfold cotangentSpaceAtIdentity` exposes the `let`-bound
   `Classical.choose` extractions.
2. `obtain ⟨_, _, _, _, _, _, hfree, hrank⟩` on `h.choose_spec.choose_spec.choose_spec`
   destructures the `smooth_locally_free_omega` existential's tuple.
3. `cotangentSpaceAtIdentity_eq_extendScalars` (the iter-131 strong
   acceptance lemma) supplies the rewrite handle to a
   `(ModuleCat.extendScalars _).obj _`-form.
4. `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
   gives rank `n` of the algebraic Kähler module over `Γ(G, V)`.
5. `Module.finrank_baseChange` brings the rank down to `k`.
6. `Module.finrank_eq_rank'` connects `Module.rank` to `Module.finrank`
   under `Module.Finite`.

Estimated iter-132 prover-lane LOC: 50–100 (per iter-129 analogist;
preserved as the original estimate). The iter-131 strategy-critic
flagged that the cumulative piece-(i.a) iter count enters iter-132 at 4
already, so iter-132's outcome is the **5th** body-shape interaction
with this declaration. If iter-132 returns PARTIAL or shows another
"different structural opacity class" defect, the META-PATTERN TRIPWIRE
arms.

### Route 2: `AlgebraicJacobian/Jacobian.lean`

- **Started at iter**: <piece-i scaffold iter-127>
- **Iters audited**: 127, 128, 129, 130, 131 (5-iter window; K = 5)

#### Sorry counts per iter (file)
- iter-127: 2 (`L192 genusZeroWitness` scaffold landed + `L211
  nonempty_jacobianWitness` carry).
- iter-128, 129, 130, 131: 2 (unchanged; both off-limits since their
  closure depends on downstream piece (i.a)/(ii)/(iii) lands).

#### Helpers/declarations per iter
- iter-127: 1 (`genusZeroWitness` scaffold).
- iter-128–131: 0.

#### Prover statuses per iter
- iter-127 through iter-131: NO PROVER DISPATCH (file is off-limits;
  closure gated on M2.a body iter-151+ per current sequencing).

#### Recurring blocker phrases
- (none — the deferral is intentional, not stuck.)

#### Planner's current proposal for this iter

File stays OFF-LIMITS iter-132. Two stale docstrings at L195+L226 were
already cleaned up by iter-131 refactor lane.

### Route 3: `AlgebraicJacobian/RigidityKbar.lean`

- **Started at iter**: 126
- **Iters audited**: 127, 128, 129, 130, 131 (5-iter window; K = 5)

#### Sorry counts per iter (file)
- iter-127 through iter-131: 1 (`L87 rigidity_over_kbar` scaffold,
  unchanged; closure gated on pile pieces (i.a)→(i.b)→(i.c)→(ii)→(iii)).

#### Helpers/declarations per iter
- iter-127 through iter-131: 0.

#### Prover statuses per iter
- iter-127 through iter-131: NO PROVER DISPATCH (file is gated
  downstream of piece (i.a) closure + pieces (i.b)+(i.c)+(ii)+(iii)
  per STRATEGY.md sequencing).

#### Recurring blocker phrases
- (none — deferral is intentional. The chapter prose is `correct: partial`
  per iter-131 blueprint-reviewer; iter-132 blueprint-writer dispatch
  will absorb that.)

#### Planner's current proposal for this iter

File stays OFF-LIMITS iter-132. The iter-132 blueprint-writer dispatch
on `RigidityKbar.tex` Piece (i.a) is plan-phase prose-only work; no
Lean prover lane on this file.

## Out of scope

- All `Cohomology/*.lean` files — DONE; not active prover lanes.
- `AbelJacobi.lean` — DONE; closed iter-125.
- `Rigidity.lean` — DONE; closed iter-125.
- `Differentials.lean` — DONE iter-126 excise; standalone utilities
  preserved.
- `Genus.lean` — DONE; closed iter-118.
