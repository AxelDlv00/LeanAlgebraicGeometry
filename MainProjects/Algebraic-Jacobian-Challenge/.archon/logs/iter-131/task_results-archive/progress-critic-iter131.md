# Progress Critic Report

## Slug
iter131

## Iteration
131

## Routes audited

### Route: `AlgebraicJacobian/Cotangent/GrpObj.lean` (piece (i.a) `cotangentSpaceAtIdentity`)

- **Sorry trajectory**: 0 → 0 → 0 across iter-128/129/130. **The sorry count is the wrong metric for this route** — the declaration is sorry-free by construction (it's a `def`, not a `theorem`), so the loop never registers progress or regression via sorry deltas. The real metric is *whether the body has a shape the downstream rank lemma can close against*, and on that axis the route has gone 0 → 0 → 0 (defective → refactor-only → defective).
- **Helper accumulation**: 1 helper across 3 iters (the `cotangentSpaceAtIdentity` declaration itself, landed iter-128 then twice mutated). 0 *new* helpers, but the file grew 75 → 104 → 172 LOC and the single declared body has been rewritten end-to-end in 2 of the last 3 iters. Substantively this is **3 body-shape touches** (iter-128 closure body, iter-129 signature refactor, iter-130 body swap), with iter-131 proposing a 4th.
- **Recurring blockers**:
  - `"rank lemma unprovable against this body"` — appears in iter-129 mathlib-analogist verdict AND iter-130 lean-auditor must-fix. Same downstream lemma (`cotangentSpaceAtIdentity_finrank_eq`), two different upstream causes (zero-collapse, then opaque-Nonempty). **Two iters of the same downstream blocker.**
  - `"vacuity"` (root noun) — iter-129 names it "vacuity-by-zero-collapse"; iter-130 names it "vacuity-by-opaque-witness". The defect-class label is iterating; the defect is not closing.
- **Prover status pattern**: COMPLETE (iter-128) → no-dispatch (iter-129) → COMPLETE (iter-130). **Both COMPLETE results were rejected post-hoc** — iter-128 by iter-129 mathlib-analogist, iter-130 by iter-130 review-phase lean-auditor. The prover-side `lean_verify` check is kernel-clean both times; the failure is on a downstream accessibility axis the prover doesn't see.
- **Verdict**: **CHURNING**

  Verdict rule citation: the formal CHURNING rule requires "helpers added in ≥2 of last K iters AND no structural change." The numbers don't trigger that rule literally (only 1 helper across 3 iters). But the rule's *intent* — "the route adds work-and-corrections per iter but never delivers" — is satisfied with high confidence by the meta-pattern: 4 distinct body-shape interventions on one declaration across 4 consecutive iters, each cycle catching a different upstream defect class while the same downstream lemma stays blocked. This is the canonical churn shape, just expressed on the "body shape" axis instead of the "helper count" axis.

  I am applying the directive's instruction to "pick the worse verdict" and "not soften when signals point at churn."

- **Primary corrective**: **Mathlib analogy consult** — dispatch `mathlib-analogist` *before* the iter-131 refactor lane lands, with the specific question: *does the `Classical.choose`-chain body shape proposed in the iter-131 plan produce a body definitionally equal to (or rewriteable to) the named chart's algebraic Kähler module, such that `cotangentSpaceAtIdentity_finrank_eq` can close by `rfl`/`simp`/named-rewrite against it? If not, name the body shape that does, or name the replacement (A/C) that natively yields an accessible body.*

  Rationale: iter-131's plan is a third body-shape attempt under Replacement (B). The first two body shapes both passed kernel-only `lean_verify` and both later failed downstream accessibility checks. The plan agent's proposal goes directly to dispatch a refactor lane *without first validating that `Classical.choose` (the proposed fix) actually fixes the accessibility defect*. That is the same failure mode that produced the iter-128 and iter-130 wrong-body landings. If the analogist confirms `Classical.choose` exposes the witness structurally, the refactor is fine. If not, the planner needs to escalate to strategy-critic for a Replacement (A/C) pivot before burning a 3rd prover cycle.

- **Secondary correctives** (priority order, applied only if analogist comes back negative):
  1. **Re-dispatch strategy-critic mid-iter** with the question: "Replacement (B) has produced two structurally defective bodies across iter-128 and iter-130 on the same declaration. Is the (a') auto-revert trigger (currently wired to (i.b) shear-iso closure) under-specified, and should an additional trigger fire on repeated body-accessibility failure on (i.a)?" *(I cannot answer this directly — strategic soundness is strategy-critic's territory, per my context discipline. I name the question only.)*
  2. **Route pivot** — abandon (B) on this declaration, switch to (A) stalk-side or (C) sheafified, or to the fibre-free piece (i) reformulation. Only if both the analogist and strategy-critic point this way.

### Route: `AlgebraicJacobian/RigidityKbar.lean` (piece M2.a `rigidity_over_kbar` body)

- **Sorry trajectory**: 1 → 1 → 1 across iter-128/129/130. Deferred-by-design.
- **Helper accumulation**: 0 across 3 iters.
- **Recurring blockers**: None.
- **Prover status pattern**: no dispatch across 3 iters.
- **Verdict**: **UNCLEAR** — no proposed work this iter and no prover signal across the audit window. There is no convergence signal to read because the route is intentionally on hold pending upstream piece closure. This is a different shape from "stuck" — there's nothing being attempted, so nothing to converge or diverge.
- **Primary corrective**: None — the planner's "no work this iter" proposal is appropriate. Re-audit when the route is reactivated.

### Route: `AlgebraicJacobian/Jacobian.lean` (piece M2.b `genusZeroWitness` body + Phase-C `nonempty_jacobianWitness`)

- **Sorry trajectory**: 2 → 2 → 2 across iter-128/129/130. Deferred-by-design.
- **Helper accumulation**: 1 docstring rewrite (iter-129); 0 declarations.
- **Recurring blockers**: None.
- **Prover status pattern**: no dispatch across 3 iters.
- **Verdict**: **UNCLEAR** — same shape as RigidityKbar; deferred-by-design with no active prover dispatch. The lean-auditor's iter-130 flag on stale docstrings at L195+L226 is a hygiene fix the planner is correctly piggybacking onto the iter-131 refactor lane; that does not change the convergence read.
- **Primary corrective**: None — the planner's "no work this iter" proposal is appropriate.

## Must-fix-this-iter

- **Route `Cotangent/GrpObj.lean`**: **CHURNING** — primary corrective: dispatch `mathlib-analogist` BEFORE the refactor lane runs. Why: this is the 4th body-shape touch in 4 consecutive iters on the same declaration; the planner's proposed `Classical.choose`-chain has not been validated against the downstream rank lemma's accessibility requirement; landing it without that validation risks a 3rd kernel-clean-but-defective body and a 6th iter on this declaration.

## Informational

- **Route `RigidityKbar.lean`**: UNCLEAR (deferred-by-design, no work proposed).
- **Route `Jacobian.lean`**: UNCLEAR (deferred-by-design, no work proposed; piggybacked docstring hygiene fix on iter-131 refactor lane is appropriate).

## Answers to directive's specific questions

1. **Is the 2-cycle correction loop CHURNING?** Yes. Two prover dispatches on the same declaration, both kernel-clean COMPLETE, both rejected by downstream review for distinct-but-related accessibility defects, with the same downstream lemma blocked across both cycles. The shape is "delivers `COMPLETE` then has it pulled back" — that's churn even when the per-iter delta looks like progress.

2. **Should the (a') trigger fire now as a route pivot?** I cannot adjudicate strategy soundness — that's strategy-critic's territory and I am barred from reading STRATEGY.md. What I *can* signal: the same downstream lemma has been blocked across two different upstream body shapes under the same Replacement (B), which is a non-trivial structural data point. Whether that suffices to fire an auto-revert is a strategic question I am routing to strategy-critic as Secondary Corrective #1 on Route 1.

3. **Is the iter-131 refactor lane (without analogist consult) the right corrective?** **No.** The analogist consult must come FIRST. The proposed `Classical.choose` body is the third body shape under (B); the prior two both passed kernel checks and failed downstream. Without a mathlib-grounded confirmation that `Classical.choose` yields a body definitionally accessible to the rank-lemma closure chain (4 named Mathlib lemmas per the directive), iter-131 risks repeating the iter-128/iter-130 failure mode. Specifically named: `mathlib-analogist` consult on the proposed body's accessibility under the existing rank-bridge lemma chain.

4. **META-PATTERN: would the verdict change if this is the 4th iter on the same declaration with body-shape problems?** Yes, and the directive's framing here is exactly the signal I was relying on. The CHURNING verdict is the right read precisely *because* the meta-pattern is 4 iters × body-shape problems × same declaration × same downstream blocker. Without the meta-pattern, iter-130 → iter-131 alone looks like a normal correction cycle (one bad attempt, one repair). With the meta-pattern, it's the second such cycle, on the same declaration, with the residual downstream blocker not budging. That is the canonical "looks like progress, isn't" pattern this subagent exists to flag.

## Overall verdict

Of 3 routes audited, 1 is **CHURNING** (Route 1: `Cotangent/GrpObj.lean`), and 2 are **UNCLEAR** in the benign deferred-by-design sense (Routes 2–3). The iter-131 plan should NOT dispatch the refactor lane on Route 1 cold; it should dispatch `mathlib-analogist` first to validate the proposed `Classical.choose`-chain body actually closes the accessibility defect, and only then run the refactor lane — or, if the analogist comes back negative, re-dispatch `strategy-critic` mid-iter for a Replacement-(A)/(C) pivot decision before any further body-shape work on this declaration. The piggybacked Route 3 docstring hygiene fix is fine to run in parallel.
