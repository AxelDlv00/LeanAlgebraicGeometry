---
author: sync
content_type: theorem
created: '2026-07-31T14:47:56'
decl: AlgebraicGeometry.Scheme.fgaPicardRepresentability_of_projective
docstring: '**The seam, verbatim, from the projective antecedent** — the statement
  of

  `Scheme.fgaPicardRepresentability` character for character.


  Composing §5.2 with `Scheme.fgaPicardRepresentability_of_pointedPicSharpRep`

  (`Picard/PicEtPointedReduction.lean`). So the project''s central `sorry` now follows
  by

  `exact` from *projectivity* of the pointed Picard scheme, uniformly in the base
  field —

  an antecedent whose *mathematical* notion is standard, though every Lean definition
  in it

  (`Scheme.Hom.IsProjective`, `PicScheme.picSharp`, `Scheme.HasRationalPoint`) is

  project-local.


  **AND ITS ANTECEDENT IS REFUTED AT THE INTENDED OBJECT — read §5.5 before consuming

  this.** `PointedPicSharpRepProjective` demands projectivity of the scheme representing

  the *whole* of `picSharp`, and §5.5 shows that forces `CompactSpace`, which the

  degree-graded Picard scheme is not. So this theorem is a true implication with a
  false

  antecedent: it does not bring the seam closer and must not be reported as doing
  so. The

  usable output of this file is §3 and §4, which never mention the ambient Picard
  scheme.


  An earlier revision of this docstring said the antecedent contains "no condition
  invented

  in this project anywhere in it" and framed §5 as merely renaming the hypothesis.
  Both

  were wrong, and the second was the expensive one: the restatement is not conservative,
  it

  is a strengthening into falsity. Corrected here rather than only in a report.'
file: AlgebraicJacobian/Picard/QuasiProjectiveFiniteInAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.fgaPicardRepresentability_of_projective
type: lean
updated: '2026-07-31T14:47:56'
---
theorem fgaPicardRepresentability_of_projective {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    (H : PointedPicSharpRepProjective.{u}) :
    (∃ X : Over (Spec (CommRingCat.of k)),
        Nonempty ((PicScheme.picEt C).RepresentableBy X) ∧
          LocallyOfFiniteType X.hom ∧ IsSeparated X.hom)
      ∧ (Scheme.HasRationalPoint C → IsIso (PicScheme.picEtComparison C)) :=
  fgaPicardRepresentability_of_pointedPicSharpRep C (pointedPicSharpRep_of_projective H)

/-! ## §5.5. §5's antecedent is REFUTED at the object it is about

Landed as theorems rather than left as a caveat, because a caveat is what let the
overclaim through in the first place. A fresh-context audit of §5 found this; both
statements below were reproduced before the correction was accepted.
-/