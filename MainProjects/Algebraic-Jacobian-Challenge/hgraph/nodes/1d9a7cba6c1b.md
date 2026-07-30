---
author: sync
content_type: theorem
created: '2026-07-30T08:42:03'
decl: AlgebraicGeometry.Scheme.PicScheme.equivariantToClass_injective
docstring: '**The second leg is injective.** `rep.homEquiv` is an equivalence and

  `Over.homMk` is injective in its underlying map, so forgetting equivariance

  does not merge two morphisms — it only fails to be *surjective*.


  An earlier draft of this file''s docstrings said only "the second leg is a map,
  not

  a bijection", which leaves the reader to guess which half fails, and then said the

  missing half was "the characterisation of the image, which is campaign `G1`". The

  second sentence is **withdrawn**: the image is characterised outright by

  `range_equivariantToClass`, and surjectivity can even *hold*

  (`surjective_equivariantToClass_of_subsingleton`). Injectivity is what this lemma

  adds; see the module docstring for what `G1` is actually owed.'
file: AlgebraicJacobian/Picard/PicEtQuotientHom.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.equivariantToClass_injective
type: lean
updated: '2026-07-30T09:17:02'
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