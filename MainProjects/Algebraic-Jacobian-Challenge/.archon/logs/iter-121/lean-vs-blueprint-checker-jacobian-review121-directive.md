# Lean ↔ Blueprint Checker Directive

## Slug
jacobian-review121

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean

## Blueprint chapter
blueprint/src/chapters/Jacobian.tex

## Known issues

The Lean file was NOT touched in iter-121 (no prover dispatch this
iter). The blueprint chapter `Jacobian.tex` had the `(C.2)` sub-step
in the proof of `thm:nonempty_jacobianWitness` expanded from a single
sentence to a ~110-LOC nested itemize with seven sub-steps
(C.2.a–C.2.g) covering: rigidity statement over `k̄`, reduction to
the project's `GrpObj.eq_of_eqOnOpen`, image-dimension argument,
classical input (Mumford / Hartshorne dual abelian variety),
scheme-vs-set promotion, Galois descent from `k̄` to `k`, and a
provisional Mathlib-gap declaration name
`AlgebraicGeometry.AbelianVariety.constant_of_P1_map`.

The single project sorry `nonempty_jacobianWitness:Jacobian.lean:179`
is unchanged this iter — the strategy's M2 milestone is queued
behind M1 (bridge work).

Two stale phrases were left in `Jacobian.tex` per the writer's
out-of-scope rule:

- Line 376: still uses old `Hom(ℙ¹_k, A) = A(k)` framing in
  "Mathlib infrastructure summary" bullet (γ).
- Line 387: still uses old `Hom(ℙ¹_k, A) = A(k)` framing in
  "Layer I — direct definition" enumerate item.

These are known to the planner; flag them as major if you confirm
they still drift but don't escalate beyond major.

Pre-known: the writer flagged that `GrpObj.eq_of_eqOnOpen` (the
rigidity lemma) requires the source to be a *group scheme*, which
`ℙ¹_{k̄}` is not. The C.2.b sub-step honestly documents this
mismatch and proposes a future refactor of `Rigidity.lean` to drop
the source-side group-scheme hypothesis. This is a forward design
issue and NOT a defect of the iter-121 chapter rewrite; do not
flag as must-fix.

Focus your bidirectional check on:
1. Is the `\lean{AlgebraicGeometry.Scheme.nonempty_jacobianWitness}`
   target in the Lean file aligned with what the chapter prose now
   claims?
2. Does the chapter's expanded C.2 sub-step prose match the
   protected-signature reality of `nonempty_jacobianWitness`
   (no genus parameter, no `k`-rational point hypothesis, but quantifies
   over a smooth proper geometrically irreducible curve over `Spec k`)?
3. The other Jacobian.lean declarations (`JacobianWitness` struct,
   `isAlbaneseFor` field, etc.) — do their corresponding `\lean{...}`
   blocks in `Jacobian.tex` still resolve correctly after the chapter
   rewrite?

Severity: must-fix-this-iter ONLY if the rewrite introduced a
mathematical incorrectness in the chapter (e.g. claims something
that does not match the protected signature). Cosmetic terseness at
lines 376/387 is major at most.
