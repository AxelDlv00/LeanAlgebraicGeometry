# Progress Critic Directive

## Slug
iter130

## Iter
130

## Active routes / files under review

### Route 1: piece (i.a) `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` body — primary iter-130 prover-lane candidate

- **File**: `AlgebraicJacobian/Cotangent/GrpObj.lean`
- **Iter-126**: not active (file did not exist)
- **Iter-127**: not active (file did not exist; staged in `RigidityKbar.tex` blueprint-writer pass for iter-128)
- **Iter-128**: file CREATED with `cotangentSpaceAtIdentity` body landed by prover lane. Status COMPLETE on the prover-self-report. Project sorry: 3 → 4 → 3 (scaffold +1, body close -1 same iter). `lake build` ✓.
- **Iter-129**: plan-phase-only iter. Refactor lane renamed `lieAlgebra` → `cotangentSpaceAtIdentity` + relaxed signature `[SmoothOfRelativeDimension 1]` → `{n : ℕ} [SmoothOfRelativeDimension n]`; body verbatim unchanged. Mathlib-analogist consult discovered the iter-128 body is **mathematically degenerate** (computes the zero `k`-module for every smooth proper geom-irr `G/k` with relative dim `n ≥ 1`). Project sorry unchanged at 3.
- **Helpers added this run**: 0 (the file contains exactly one substantive declaration `cotangentSpaceAtIdentity`).
- **Recurring blocker phrases**: "presheaf vs sheaf bridge" (strategy-critic-iter129 abstract; mathlib-analogist-iter129 concrete: presheaf-pullback at `op ⊤` collapses to `k` for proper geom-int `G/k`).
- **Iter-130 plan**: prover lane swaps body to Replacement (B) per `analogies/lieAlgebra-rank-bridge.md`; expected 200–400 LOC closure.
- **Sorry count trail**: this file is `0` sorries throughout iter-128/129 (kernel-clean, but the construction is wrong; "kernel-clean ≠ mathematically correct" lesson logged in iter-129 review).
- **Prover statuses (last K=3)**: iter-128 COMPLETE; iter-129 N/A (plan-only); iter-130 PENDING.

### Route 2: M2.a body `rigidity_over_kbar` (`AlgebraicJacobian/RigidityKbar.lean:75`)

- **Iter-126**: scaffold lands (the `sorry` body); project sorry 1 → 2.
- **Iter-127, iter-128, iter-129**: untouched; deliberately gated on shared cotangent-vanishing pile (i)+(ii)+(iii) which is in build phase.
- **Sorry count trail**: 1 sorry throughout iter-126/127/128/129.
- **Helpers added**: 0.
- **Prover statuses (last K=3)**: not active.
- **Iter-130 plan**: NOT scheduled this iter; gated on iter-150+ M2.a body close after pile pieces (i)+(ii)+(iii) land.

### Route 3: M2.b body `genusZeroWitness` (`AlgebraicJacobian/Jacobian.lean:188`)

- **Iter-126**: not yet active.
- **Iter-127**: scaffold lands with `sorry` body; project sorry 2 → 3.
- **Iter-128, iter-129**: untouched; gated on M2.a body close (route 2) + terminal-object infra.
- **Sorry count trail**: 1 sorry from iter-127 onward.
- **Helpers added**: 0.
- **Prover statuses (last K=3)**: not active.
- **Iter-130 plan**: NOT scheduled this iter; gated on iter-153+ closure after M2.a body lands.

## Specific verdict ask

The active-prover-route question is Route 1. Last K=3 iters' raw signals on Route 1:

- iter-128: prover dispatched. COMPLETE on prover-self-report (body landed). Project sorry on this file: 0. Helpers added: 0. The body was later discovered (iter-129 mathlib-analogist) to be mathematically degenerate.
- iter-129: plan-phase-only. Refactor lane (rename + signature relax). Mathlib-analogist returns ALIGN_WITH_MATHLIB on the body (must replace). Sorry count this file: 0. Helpers added: 0.
- iter-130 (staged): prover lane swaps body to Replacement (B). Expected COMPLETE.

**Question to you**: is the iter-128 → iter-129 → iter-130 trajectory on Route 1 CONVERGING (the iter-129 fix-up properly absorbed an empirically-discovered mathematical error, iter-130 corrects it cleanly), CHURNING (a re-do of iter-128's body is too similar in shape to count as new progress), STUCK (the route has not produced sorry-elimination since iter-128 close, and the iter-128 close was vacuous), or UNCLEAR? Routes 2 and 3 are deliberately dormant; verdict should be UNCLEAR (no fresh signal) or "deferred-by-design".

Also flag any META-PATTERN — iter-127 was plan-only, iter-128 was prover, iter-129 was plan-only, iter-130 is staged prover. Is the alternating pattern healthy or is it a sign that the loop is stuck in a "prover lands wrong + plan repairs" cycle?
