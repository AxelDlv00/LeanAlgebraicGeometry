---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.tensorBraiding
docstring: 'The braiding isomorphism `F ⊗ G ≅ G ⊗ F` of the sheaf tensor product,

  descended through sheafification from the symmetric braiding on

  `X.PresheafOfModules` (`PresheafOfModules.monoidalCategory`).  Axiom-clean: the

  braiding is pure sheafification-functoriality of the presheaf-level braiding, so

  no monoidal structure on `X.Modules` is required.  This is the symmetry used in

  the inductive step of `tensorPowAdd`.'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.tensorBraiding
type: lean
updated: '2026-07-24T03:02:11'
---
private noncomputable def tensorBraiding (F G : X.Modules) :
    sheafTensorObj F G ≅ sheafTensorObj G F :=
  sheafification.mapIso
    (BraidedCategory.braiding (C := MonoidalPresheaf X)
      ((toPresheafOfModules X).obj F) ((toPresheafOfModules X).obj G))

/-! ### Lax-monoidal global sections: the section multiplication

The global-sections functor `Γ(X, -)` is only *lax* monoidal: a pair of global
sections does not commute with sheafification, so the multiplication is a map,
not an isomorphism.  It is nonetheless `Γ(X, 𝒪_X)`-linear and is the data the
section graded ring is built from. -/