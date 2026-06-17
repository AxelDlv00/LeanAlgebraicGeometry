# Refactor Report

## Slug
lane-i-localparameter-signature

## Status
COMPLETE

## Directive

### Problem
`AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
(WeilDivisor.lean, around L585) was mathematically false as stated after the
iter-191 plan-phase signature reshape. The reshape exposed `(t : K)` and
`(halg : algebraMap K K(C) t ≠ 0)` as explicit parameters but failed to add
the local-parameter constraint the Hartshorne II.6.9 identity requires.

Counter-witness: take `K = C.left.functionField`, `t = 1`; then `halg : 1 ≠ 0`
holds, `principal 1 _ = 0`, `positivePart 0 = 0`, `degree 0 = 0` (LHS), while
`Module.finrank K(C) K(C) = 1` (RHS).

### Changes Requested
1. Add `(hlp : ∃ Y : C.left.PrimeDivisor, Scheme.RationalMap.order Y (algebraMap K C.left.functionField t) = 1)`
   to the signature of `degree_positivePart_principal_eq_finrank` in
   `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`.
2. Update consumer `Hom.poleDivisor_degree_eq_finrank` in
   `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` to thread the new
   argument; close `?hlp` with a typed `sorry` (genuine iter-194+ owed work).
3. (Optional) Replace the inline soundness-concern comment block in
   WeilDivisor.lean L538-L582 with a one-paragraph note naming the iter-193
   fix.

## Changes Made

### File: AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **What:** Replaced the iter-191 "soundness concern" paragraph of the
  docstring (the one claiming the constraint is "threaded through the body
  proof") with an iter-193 paragraph that names the explicit `hlp`
  hypothesis and the counter-witness. Then added the new argument
  `(hlp : ∃ Y : C.left.PrimeDivisor,
    Scheme.RationalMap.order Y (algebraMap K C.left.functionField t) = 1)`
  to `degree_positivePart_principal_eq_finrank`, in the position requested
  by the directive (after `halg`, before the conclusion). The body
  (rewriting via `degree_positivePart_eq_sum_max` then `sorry`) is
  unchanged.
- **Why:** The original equation form is false at `K = K(C), t = 1`. The
  `hlp` hypothesis pins `t` to be a uniformiser at some closed point of
  `C` (project's elementary "local parameter" notion), which is what the
  affine-chart `Ideal.sum_ramification_inertia` chain requires.
- **Cascading:** Only `RationalCurveIso.lean` references this theorem;
  fixed there (see below). No other consumer in the project (verified by
  grep of `AlgebraicJacobian/` and `analogies/`).

### File: AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **What:** Rewrote the body of `Hom.poleDivisor_degree_eq_finrank` from
  `exact ... C (localParameterAtInfty kbar).val _` to
  `refine ... C (localParameterAtInfty kbar).val _ ?hlp` followed by a
  typed `sorry` carrying the new existential obligation. Added a brief
  comment naming the iter-194+ owed work and pointing to the
  affine-chart / smoothness-DVR justification.
- **Why:** Directive requires the consumer to thread the new
  `hlp` witness. The witness IS true at the call site (the smooth proper
  curve `C` has DVR stalks over `∞ ∈ ℙ¹`, and `(localParameterAtInfty kbar).val`
  pulls back to a uniformiser at every prime divisor above `∞`), but the
  proof requires affine-chart-at-`∞` machinery that is project-bespoke
  iter-194+ content.
- **Cascading:** None. `Hom.poleDivisor_degree_eq_finrank` is consumed
  downstream (by `morphism_degree_via_pole_divisor`) but only via its
  statement, not via a structural rewrite, so the iter-194+ sorry
  propagates implicitly without further signature changes.

## New Sorries Introduced
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:521` — the
  `Hom.poleDivisor_degree_eq_finrank` body now carries a typed sorry for
  the `?hlp` obligation: the existence of a prime divisor of `C` at which
  the pulled-back local parameter has order `1`. Genuine Hartshorne
  content owed iter-194+ (smoothness ⟹ DVR stalk ⟹ uniformiser has
  order 1 at the chosen point above `∞`).

Note: the existing sorry on `degree_positivePart_principal_eq_finrank` in
WeilDivisor.lean (line 586, was 663 pre-edit) is retained as-is — only
the signature changed.

## Compilation Status
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`: **compiles** (3 sorries: 226, 445, 586 — unchanged count from pre-refactor 3).
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`: **compiles** (2 sorries: 521, 721 — was 1, **delta +1** as predicted by the directive).
- `lake build AlgebraicJacobian` returns exit 0, full project builds clean (warnings only).
- Total project sorry count: **78** (matches directive prediction 77 → 78, net **+1**).
- No new axioms introduced. New `sorry` is the kernel `sorryAx` carrier, expected.

## Notes for Plan Agent

- **Mathematical justification was sufficient.** The directive named the exact
  counter-witness (`K = K(C), t = 1`) and the correct minimal local-parameter
  encoding (order-equals-1 at some prime divisor). I did not need to invent
  any encoding; I copied the directive's `∃ Y, order Y ... = 1` shape
  verbatim and the consumer call site fell out as a straight `refine ... ?hlp`
  with a typed sorry.
- **No unexpected complications.** Both files compiled on first build after
  edits, no LSP-level type-mismatch loops. The `algebraMap K C.left.functionField t`
  binding-shape inside the new existential matched the principal-divisor
  binding-shape exactly, so unification at the `refine` site was trivial.
- **The optional comment-block replacement (directive Change 3) was done.** I
  replaced just the "soundness concern" paragraph inside the existing
  docstring — not the surrounding multi-paragraph block — to preserve the
  body-recipe pointers to `Ideal.sum_ramification_inertia` and
  `analogies/ratcurveiso-pin2.md` Decision 2 that the iter-194+ prover will
  need. The inline `--` comment block inside the body (L598-L662, which
  documents the body-gap recipe step by step) is left intact because it
  remains accurate after the signature fix.
- **Suggested follow-up.** Iter-194+ owes two `sorry` closures, both gated
  on the same affine-chart-at-`∞` substrate:
  1. `WeilDivisor.lean:586` — the `degree_positivePart_principal_eq_finrank`
     body (~50-80 LOC chaining `Ideal.sum_ramification_inertia` +
     ramification-index ↔ prime-divisor-order bridge).
  2. `RationalCurveIso.lean:521` — exhibit the prime divisor `Y` above `∞`
     with `order Y (algebraMap _ _ (localParameterAtInfty kbar).val) = 1`.
  These are naturally co-routinable: the same affine-chart construction
  produces both the witness in (2) and the ramification-index identification
  in (1). A single prover assignment covering both pins is the natural
  decomposition.
- **Blueprint follow-up.** Per the directive, the blueprint chapter prose
  update (removing the `% NOTE (iter-192 review)` block in
  `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`) is plan-agent work,
  not refactor-agent work. I did not touch the `.tex` file.
