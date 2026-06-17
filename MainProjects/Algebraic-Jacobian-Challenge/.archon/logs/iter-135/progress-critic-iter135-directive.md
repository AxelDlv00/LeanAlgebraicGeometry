# Directive — progress-critic iter-135

## Slug

iter135

## Active routes for this audit

Four routes. Per descriptor, you assess each as
CONVERGING / CHURNING / STUCK / UNCLEAR based on signals from the last
K iters (K = 5 for this audit, iter-131 through iter-135 plan-phase pre-Wave-2).

### Route 1: `AlgebraicJacobian/Cotangent/GrpObj.lean` piece (i.a)

Last 5 iters signals:

- iter-131 (plan + prover): body refactor of `cotangentSpaceAtIdentity`
  to pure-term `Classical.choose`-chain `noncomputable def` +
  acceptance-shape lemma `cotangentSpaceAtIdentity_eq_extendScalars`
  closes by `rfl`. **Sorry delta**: 0 (refactor only). LOC delta:
  ~+10 (chapter line was already there; the lemma is a closure of an
  existing scaffolded declaration). Status: PARTIAL → COMPLETE for
  refactor scope.
- iter-132 (plan + prover): closure of `cotangentSpaceAtIdentity_finrank_eq`
  rank lemma against the iter-131 body. **Sorry delta**: 0 (new closed
  declaration, no `sorry`). LOC delta: +65. Status: COMPLETE. **Route 1
  flipped CHURNING (iter-128→iter-131 5-iter watch) → CONVERGING.**
- iter-133 (plan + parallel-writer + parallel-refactor; NO PROVER):
  refactor lane on Cotangent/GrpObj.lean — 5 docstring refreshes + 1
  style nit. **Sorry delta**: 0. LOC delta: 285 → 296 (+11).
  Status: COMPLETE (refactor).
- iter-134 (plan + prover; piece (i.a) untouched, prover lane on
  piece (i.b)): no edits to piece (i.a) declarations. **Sorry delta**:
  0 (preserved). Status: COMPLETE-preserved.
- iter-135 (this iter, plan-phase pre-Wave-2): no edits planned to
  piece (i.a) declarations; the Wave-2 refactor on this file targets
  the iter-134 placeholder theorems at lines 449–574 only.

**Recurring blocker phrases**: none active. Iter-128→iter-131 had
"Classical.choice as outermost head symbol" / "value-level vs
structural-shape" patterns; all resolved iter-131. Iter-132 closed the
rank lemma cleanly with no recurring blocker.

### Route 2: `AlgebraicJacobian/Jacobian.lean` M2

Last 5 iters signals:

- iter-131: no edits (deferred). Sorry count: 2. Status: deferred-by-design.
- iter-132: no edits (deferred). Sorry count: 2. Status: deferred-by-design.
- iter-133: no edits (deferred). Sorry count: 2. Status: deferred-by-design.
- iter-134 (plan-phase Wave-2 refactor): `refactor-positiveGenusWitness-scaffold-iter134`
  inserted `positiveGenusWitness C (hg : 0 < genus C)` stub at lines
  194–215 with `sorry` body + full docstring. **Sorry delta**: 2 → 3.
  LOC delta: +21. Status: COMPLETE (scaffold). M3 off-critical-path
  (user-escalation-pending).
- iter-135 (this iter, plan-phase): no Lean edits planned.

**Recurring blocker phrases**: none. M3 is user-escalation-pending per
`analogies/m3-route-audit.md`.

### Route 3: `AlgebraicJacobian/RigidityKbar.lean` M2.a

Last 5 iters signals:

- iter-131 → iter-135: no edits (deferred). Sorry count: 1
  (`rigidity_over_kbar`). Status: deferred-by-design (closure gated on
  shared cotangent-vanishing pile pieces (i.b)+(i.c)+(ii)+(iii)).

**Recurring blocker phrases**: none. Deferral is well-named.

### Route 4: `AlgebraicJacobian/Cotangent/GrpObj.lean` piece (i.b)

Last 5 iters signals (this route was opened at iter-133):

- iter-131 / iter-132: not yet active.
- iter-133 (plan + parallel-writer; NO PROVER on this route): blueprint
  hardening of `RigidityKbar.tex` § Piece (i.b) +
  `mathlib-analogist-mulright-globalises-iter133` (PROCEED with sheaf-
  level RHS, 2 NEEDS_MATHLIB_GAP_FILL sub-pieces). Lean file: no edits.
  Status: PREP (analogist + blueprint).
- iter-134 (plan + prover; FIRST prover lane on this route): 7 new
  declarations added to Cotangent/GrpObj.lean (296 → 574 LOC, +278 LOC):
  - Step 1 substantively closed: `shearMulRight` + 2 `@[simps]`
    companions + helper `schemeHomRingCompatibility`. ~50 LOC honest
    closure (`shearMulRight` 35 LOC + 2 companions 6 LOC + helper 3
    LOC). Kernel-only axioms.
  - Steps 2 / 3 / Main: **3 hollow placeholder theorems** typed
    `Nonempty (Scheme.relativeDifferentialsPresheaf G.hom ≅
    Scheme.relativeDifferentialsPresheaf G.hom)` with body `⟨Iso.refl _⟩`.
    Intended types in docstrings only. **Sorry delta**: 0 (no `sorry`
    introduced; but no substantive content either on 3 of 4 sub-pieces).
  - Status reported by prover: PARTIAL (Step 1 fully closed; Steps 2–4
    as placeholders).
  - Both iter-134 review-phase audits classified the placeholder pattern
    as must-fix-this-iter (lean-auditor + lean-vs-blueprint-checker).
- iter-135 (this iter, plan-phase pre-Wave-2): no prover dispatch this
  iter. Wave-2 refactor to honest sorry-bodied scaffolds is planned.

**Recurring blocker phrases**: iter-134 prover's task-result names:
"the intended `PresheafOfModules.pullback`-based signature involves
substantial infrastructure that is the subject of the multi-iter
NEEDS_MATHLIB_GAP_FILL work" — this is the placeholder-justification
language. The iter-134+ handoff in the prover's task result names
"Sharpen the φ_str / φ_η compatibility morphisms for use with
`PresheafOfModules.pullback`" as the iter-135+ work; the iter-135 plan
agent is dispatching a fresh mathlib-analogist on exactly those 4 φ
morphisms in parallel with this audit.

## What you decide

For each route, render verdict CONVERGING / CHURNING / STUCK / UNCLEAR
per the descriptor's rubric. For Route 4 specifically, the question is:
does iter-134's "Step 1 substantive + 3 hollow placeholders" outcome
constitute progress, or is the placeholder pattern itself an early
helper-churn signal? The iter-135 plan agent's response (refactor to
honest scaffolds, no prover this iter) is one corrective; you may name
a different corrective if your read of the signals suggests one.

## Context discipline

You read ONLY this directive. Do NOT read STRATEGY.md (strategy-critic's
territory), blueprint chapters (blueprint-reviewer's territory), or
iter sidecars. Do NOT read full `task_results/` files; this directive
extracted the per-iter signals.

You MAY use `lean_diagnostic_messages` to spot-check current Lean state
if you want a sanity check on the signals listed above.

## Output

Standard progress-critic report shape per
`.archon/subagents/progress-critic.md`. Save to
`.archon/task_results/progress-critic-iter135.md`.
