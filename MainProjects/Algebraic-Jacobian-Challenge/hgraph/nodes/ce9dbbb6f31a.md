---
author: sync
content_type: instance
created: '2026-07-27T19:08:27'
decl: AlgebraicGeometry.Adelic.instIsDomainP1ChartSectionsY
docstring: The second chart ring of `ℙ¹_k` is a domain, being a polynomial ring over
  a field.
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.instIsDomainP1ChartSectionsY
type: lean
updated: '2026-07-27T19:08:27'
---
instance instIsDomainP1ChartSectionsY :
    IsDomain Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k ⟨1⟩) :=
  Function.Injective.isDomain (p1ChartSectionsAlgEquivY k).toRingEquiv.toRingHom
    (p1ChartSectionsAlgEquivY k).injective