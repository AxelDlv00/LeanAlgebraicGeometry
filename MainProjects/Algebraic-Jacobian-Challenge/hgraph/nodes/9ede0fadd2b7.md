---
author: sync
content_type: definition
created: '2026-07-28T13:22:16'
decl: AlgebraicGeometry.Scheme.PicScheme.classOfSection
docstring: '**The relative Picard class of a `k`-rational point of `Pic_{C/k}`** —
  sorry-free.


  Representability at the trivial test object `T = Spec k`. A section `lambda` of

  `(PicScheme C).hom` is a morphism `Over.mk (𝟙 (Spec k)) ⟶ PicScheme C` in `Over
  (Spec k)`,

  and `representable`''s `homEquiv` sends it to a class in

  `Pic(C ×_k Spec k)/π^* Pic(Spec k)`. Nothing is chosen and nothing is open here;
  this is the

  transport step that the old Quot route was going to perform by extracting a representing

  sheaf.'
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.classOfSection
type: lean
updated: '2026-07-28T13:22:16'
---
noncomputable def classOfSection {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    (lambda : Spec (.of k) ⟶ (PicScheme C).left)
    (hlambda : lambda ≫ (PicScheme C).hom = 𝟙 (Spec (.of k))) :
    (PicSharp.relPresheaf C).obj (Opposite.op (Over.mk (𝟙 (Spec (.of k))))) :=
  (PicScheme.representable C).homEquiv
    (Over.homMk lambda hlambda : Over.mk (𝟙 (Spec (.of k))) ⟶ PicScheme C)