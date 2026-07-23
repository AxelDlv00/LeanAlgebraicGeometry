---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.PicScheme.abelKernelBaseChangeIso
docstring: '**Kernel commutes with base change for a divisor family** (the mathematical

  heart of Abel-map naturality).  For a test map `g : T ⟶ T''` and a divisor family

  `x` over `T`, the ideal of the pulled-back family is the pullback of the ideal:

  `ker((g_C^* x).q) ≅ g_C^*(ker x.q)`.  Proof: `(pullbackAlong g.unop x).q` is

  `triangleIso.inv ≫ g_C^*(x.q)`, so its kernel agrees with `ker(g_C^* x.q)`

  (`kernelIsIsoComp`, precomposition by the iso `triangleIso.inv`); the

  **kernel–pullback comparison** `g_C^*(ker q) ⟶ ker(g_C^* q)` is an isomorphism

  under the divisor conditions (`Modules.isIso_pullbackKernelComparison`, whose

  side hypotheses are exactly the `DivFamily` fields `epi`, quasi-coherent source,

  `isFinitePresentation`, `flat`, `kerLocallyTrivial` over the cartesian

  `quotBaseSquare`).'
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.abelKernelBaseChangeIso
type: lean
updated: '2026-07-16T21:14:26'
---
private noncomputable def abelKernelBaseChangeIso {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    {T T' : (Over (Spec (.of k)))ᵒᵖ} (g : T ⟶ T') (x : DivFamily C.hom T.unop) :
    kernel ((DivFamily.pullbackAlong g.unop x).q) ≅
      (Scheme.Modules.pullback (quotBaseMap C.hom g.unop)).obj (kernel x.q) := by
  haveI hiso : IsIso (Modules.pullbackKernelComparison (quotBaseMap C.hom g.unop) x.q) :=
    Modules.isIso_pullbackKernelComparison (quotBaseSquare C.hom g.unop) x.q x.epi
      (pullback_isQuasicoherent_hom (pullback.fst C.hom T.unop.hom)
        (SheafOfModules.unit C.left.ringCatSheaf) inferInstance)
      x.isFinitePresentation x.flat x.kerLocallyTrivial
  exact kernelIsIsoComp
      (pullbackTriangleIso (quotBaseMap_fst C.hom g.unop)
        (SheafOfModules.unit C.left.ringCatSheaf)).inv
      ((Scheme.Modules.pullback (quotBaseMap C.hom g.unop)).map x.q) ≪≫
    (asIso (Modules.pullbackKernelComparison (quotBaseMap C.hom g.unop) x.q)).symm