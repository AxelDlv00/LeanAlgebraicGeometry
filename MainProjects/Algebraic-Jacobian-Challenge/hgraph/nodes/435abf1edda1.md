---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.RelativeTensorCoequalizer.aR
docstring: Right action map as a morphism of abelian groups.
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.RelativeTensorCoequalizer.aR
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def aR :
    AddCommGrpCat.of (M ⊗[ℤ] (S ⊗[ℤ] N)) ⟶ AddCommGrpCat.of (M ⊗[ℤ] N) :=
  AddCommGrpCat.ofHom (actRmap S M N).toAddMonoidHom