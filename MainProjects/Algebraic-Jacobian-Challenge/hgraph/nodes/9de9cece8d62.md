---
author: sync
content_type: definition
created: '2026-07-28T02:46:09'
decl: AlgebraicGeometry.picardJacobianWitnessOfIsAlgClosed
docstring: '**The witness over an algebraically closed field, free of the inconsistent
  leaf.**


  Identical to `picardJacobianWitness` except that the rational point is supplied
  by the

  theorem `hasRationalPoint_of_curve_of_isAlgClosed` rather than by the gap marker

  `hasRationalPoint_of_curve`. The distinction is not cosmetic and is the reason this

  definition exists separately.


  `hasRationalPoint_of_curve` is *false* as stated, so every consequence of

  `picardJacobianWitness` is a consequence of an inconsistent hypothesis: true, but
  with no

  content, and no axiom check can see the difference. Here the same assembly runs
  on a

  hypothesis that holds, so the four obligations it does rest on — `Pic0.smooth`,

  `Pic0.proper`, and leaves B and C — are the whole of what stands between this witness
  and

  an Albanese object for a curve over `k̄`. Closing those four closes this definition;
  closing

  them would *not* give `picardJacobianWitness` content over a general field, because
  leaf A

  must be replaced there rather than proved.


  Both are kept: this one records what is actually reachable, and the general one
  keeps the

  open decision visible where a reader of the headline meets it.'
file: AlgebraicJacobian/Jacobian.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picardJacobianWitnessOfIsAlgClosed
type: lean
updated: '2026-07-28T02:46:09'
---
noncomputable def picardJacobianWitnessOfIsAlgClosed [IsAlgClosed k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C := by
  haveI := hasRationalPoint_of_curve_of_isAlgClosed C
  exact
    { J := Scheme.Pic0Scheme C
      grpObj := (Scheme.Pic0.grpObj C).some
      proper := Scheme.Pic0.proper C
      smooth := Scheme.Pic0.smooth C
      geomIrred := Scheme.Pic0.geometricallyIrreducible C
      smoothGenus := smoothOfRelativeDimension_genus_pic0 C
      isAlbaneseFor := fun P => isAlbanese_pic0 C _ _ _ _ P }