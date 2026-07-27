---
author: sync
content_type: definition
created: '2026-07-28T02:46:09'
decl: AlgebraicGeometry.picardJacobianWitnessOfIsAlgClosed
docstring: '**The witness over an algebraically closed field, free of the inconsistent
  leaf.**


  The same assembly as `picardJacobianWitness` — both are

  `picardJacobianWitnessOfHasRationalPoint` — differing in exactly one thing: the
  rational

  point is supplied by the theorem `hasRationalPoint_of_curve_of_isAlgClosed` rather
  than by

  the gap marker `hasRationalPoint_of_curve`. Since the shared assembly is now a single

  definition, that one difference is the *only* difference, which the elaborator checks

  rather than the reader. The distinction is not cosmetic and is the reason this

  definition exists separately.


  `hasRationalPoint_of_curve` is *false* as stated, so every consequence of

  `picardJacobianWitness` is a consequence of an inconsistent hypothesis: true, but
  with no

  content, and no axiom check can see the difference. Here the same assembly runs
  on a

  hypothesis that holds, so the obligations that remain are all *true statements awaiting

  proofs*: `Scheme.instHasPicScheme`, `Pic0.smooth`, `Pic0.proper`, and leaves B and
  C.

  Closing those five closes this definition; closing them would *not* give

  `picardJacobianWitness` content over a general field, because leaf A must be replaced
  there

  rather than proved.


  The count is **five, not four**, and the reason is worth stating because the natural

  arithmetic gets it wrong. Discharging leaf A does not remove the representability
  gate — it

  makes `instHasPicScheme` *fire* instead of being assumed, since `Scheme.Pic0Scheme`
  carries

  `[Scheme.HasPicScheme C]` and that `sorry`-bodied instance is its sole producer.
  Over a

  general field the gate sits *behind* leaf A, which is what makes counting it separately
  look

  like double-counting; over `k̄` it stands free. `scripts/axiom-frontier.lean` §0b
  measures

  this rather than asserting it: naming `Pic0Scheme` with leaf A discharged and neither

  `Pic0.smooth`, `Pic0.proper`, nor leaves B and C anywhere in the term still reports
  `sorryAx`,

  while the control that assumes the gate is clean. So what this definition buys is
  not a

  smaller count — it is that every remaining obligation is of the ordinary kind.


  Both are kept: this one records what is actually reachable, and the general one
  keeps the

  open decision visible where a reader of the headline meets it.'
file: AlgebraicJacobian/Jacobian.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picardJacobianWitnessOfIsAlgClosed
type: lean
updated: '2026-07-28T04:57:33'
---
noncomputable def picardJacobianWitnessOfIsAlgClosed [IsAlgClosed k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C :=
  haveI := hasRationalPoint_of_curve_of_isAlgClosed C
  picardJacobianWitnessOfHasRationalPoint C