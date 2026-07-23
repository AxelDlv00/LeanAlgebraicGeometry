---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.sheafificationCounitIso
docstring: 'The counit isomorphism of the module sheafification adjunction: sheafifying

  the underlying presheaf of a sheaf of modules returns the sheaf itself.  This is

  an isomorphism because the counit of `sheafification ⊣ toPresheafOfModules` is

  invertible (the right adjoint `SheafOfModules.forget` is fully faithful).  It is

  the launching pad for the left-unitor base case of `tensorPowAdd`.'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.sheafificationCounitIso
type: lean
updated: '2026-07-16T21:14:27'
---
private noncomputable def sheafificationCounitIso (G : X.Modules) :
    sheafification.obj ((toPresheafOfModules X).obj G) ≅ G :=
  (asIso (PresheafOfModules.sheafificationAdjunction
    (𝟙 X.ringCatSheaf.obj)).counit).app G