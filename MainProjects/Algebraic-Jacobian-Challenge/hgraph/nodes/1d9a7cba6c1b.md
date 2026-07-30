---
author: sync
content_type: theorem
created: '2026-07-30T08:42:03'
decl: AlgebraicGeometry.Scheme.PicScheme.equivariantToClass_injective
docstring: '**The second leg is injective.** `rep.homEquiv` is an equivalence and

  `Over.homMk` is injective in its underlying map, so forgetting equivariance

  does not merge two morphisms — it only fails to be *surjective*.


  This sharpens the residue and is the reason the composite below is injective

  rather than merely a map: what `G1` owes is not injectivity but the

  **characterisation of the image**, i.e. which `picEt (C_{k''})`-classes are

  `Γ`-invariant. An earlier draft of this file''s docstrings said only "the second
  leg

  is a map, not a bijection", which is true and leaves the reader to guess which half

  fails; this measures it.'
file: AlgebraicJacobian/Picard/PicEtQuotientHom.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.equivariantToClass_injective
type: lean
updated: '2026-07-30T08:42:03'
---
theorem equivariantToClass_injective
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (PicScheme.picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : AlgebraicJacobian.GaloisDescent.SemilinearGalAction k k' X'.left X'.hom)
    (T : Over (Spec (CommRingCat.of k))) :
    Function.Injective (equivariantToClass C rep ρ T) := by
  intro a b hab
  have h1 : (Over.homMk a.1 a.2.1 : PicScheme.baseTest (k' := k') T ⟶ X')
      = Over.homMk b.1 b.2.1 := rep.homEquiv.injective hab
  exact Subtype.ext (congrArg CategoryTheory.Over.Hom.left h1)