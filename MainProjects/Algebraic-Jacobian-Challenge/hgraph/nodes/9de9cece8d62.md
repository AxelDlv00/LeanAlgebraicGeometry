---
author: sync
content_type: definition
created: '2026-07-28T02:46:09'
decl: AlgebraicGeometry.picardJacobianWitnessOfIsAlgClosed
docstring: '**The witness over an algebraically closed field: a genuine `k̄` theorem.**


  The same assembly as `picardJacobianWitnessOfHasRationalPoint`, with the rational
  point

  supplied by the theorem `hasRationalPoint_of_curve_of_isAlgClosed` rather than assumed.
  Over

  `k̄` a smooth proper geometrically irreducible curve really does have a rational
  point — the

  curve is a nonempty Jacobson space and its closed points are rational — so this
  definition

  records what the `picSharp` route actually reaches, with nothing false anywhere
  in it.


  **It is not the headline** (owner decision of 2026-07-28, protection I-0491 clause
  4). It is

  a theorem about algebraically closed base fields, and the challenge asks for an
  arbitrary

  one; that statement is `picardJacobianWitness`, which is built on the étale-sheafified

  functor and does not pass through this definition or through

  `picardJacobianWitnessOfHasRationalPoint`.


  Its obligations are those of the `picSharp` route with the rational point discharged:

  `Scheme.picSchemeOfHasRationalPoint`''s content (i.e. `Scheme.fgaPicardRepresentability`),

  `Pic0.smooth`, `Pic0.proper`, and the two `picSharp`-shaped leaves

  `smoothOfRelativeDimension_genus_pic0` / `isAlbanese_pic0`. Discharging the rational
  point

  does not remove the representability gate — it makes it *fire* instead of being
  assumed,

  since `Scheme.Pic0Scheme` carries `[Scheme.HasPicScheme C]` — so the count does
  not shrink

  here either. What it buys is that every obligation is of the ordinary kind.


  Both are kept: this one records what the `picSharp` route reaches over `k̄`, and
  the

  headline states what the project claims over an arbitrary field.'
file: AlgebraicJacobian/Jacobian.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picardJacobianWitnessOfIsAlgClosed
type: lean
updated: '2026-07-28T14:03:57'
---
noncomputable def picardJacobianWitnessOfIsAlgClosed [IsAlgClosed k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C :=
  haveI := hasRationalPoint_of_curve_of_isAlgClosed C
  picardJacobianWitnessOfHasRationalPoint C