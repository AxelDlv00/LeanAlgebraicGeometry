---
author: sync
content_type: theorem
created: '2026-07-29T15:31:33'
decl: AlgebraicGeometry.JacobianData.isIso_hom_of_isTerminal
docstring: 'The structure morphism of a **terminal** object of `Over (Spec k)` is
  an isomorphism:

  a terminal object is canonically the base itself (`Over.mkIdTerminal`), and transporting

  the identity along that iso gives `IsIso J.hom`.'
file: AlgebraicJacobian/Albanese/Genus0Terminal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.JacobianData.isIso_hom_of_isTerminal
type: lean
updated: '2026-07-30T15:45:59'
---
theorem isIso_hom_of_isTerminal {J : Over (Spec (.of k))} (hJ : IsTerminal J) :
    IsIso J.hom := by
  have e : J ≅ Over.mk (𝟙 (Spec (.of k))) := hJ.uniqueUpToIso Over.mkIdTerminal
  have hwJ : e.hom.left ≫ (Over.mk (𝟙 (Spec (.of k)))).hom = J.hom := Over.w e.hom
  haveI : IsIso e.hom.left := ((Over.forget _).mapIso e).isIso_hom
  haveI : IsIso (Over.mk (𝟙 (Spec (.of k)))).hom := by
    change IsIso (𝟙 (Spec (.of k))); infer_instance
  rw [← hwJ]; infer_instance