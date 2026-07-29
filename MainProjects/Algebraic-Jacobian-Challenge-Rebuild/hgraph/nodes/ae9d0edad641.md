---
author: sync
content_type: lemma
created: '2026-07-17T16:57:11'
decl: AlgebraicGeometry.Scheme.PartialMap.fromSpecStalkOfMem_specializes
docstring: 'The stalk-to-target morphisms of a partial map are compatible with

  specialisation inside the domain.'
file: AlgebraicJacobian/Albanese/Milne33Pullback.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.PartialMap.fromSpecStalkOfMem_specializes
type: lean
updated: '2026-07-29T15:26:31'
---
lemma Scheme.PartialMap.fromSpecStalkOfMem_specializes
    {Y Z : Scheme.{u}} (g : Y.PartialMap Z) {P Q : ↥Y} (hsp : Q ⤳ P)
    (hP : P ∈ g.domain) (hQ : Q ∈ g.domain) :
    Spec.map (Y.presheaf.stalkSpecializes hsp) ≫ g.fromSpecStalkOfMem hP
      = g.fromSpecStalkOfMem hQ := by
  change Spec.map (Y.presheaf.stalkSpecializes hsp)
      ≫ g.domain.fromSpecStalkOfMem P hP ≫ g.hom
    = g.domain.fromSpecStalkOfMem Q hQ ≫ g.hom
  rw [← Category.assoc, Scheme.Opens.fromSpecStalkOfMem_specializes g.domain hsp hP hQ]