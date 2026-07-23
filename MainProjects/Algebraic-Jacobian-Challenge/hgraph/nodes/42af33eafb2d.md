---
author: sync
content_type: lemma
created: '2026-07-24T01:02:13'
decl: AlgebraicGeometry.precomp_eq_of_eq
docstring: 'Precomposition preserves equality of morphisms. Kept opaque so large categorical

  prefixes do not get duplicated in downstream proof terms.'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.precomp_eq_of_eq
type: lean
updated: '2026-07-24T03:02:09'
---
private lemma precomp_eq_of_eq {C : Type*} [Category C] {W Y Z : C}
    (e : W ⟶ Y) {f g : Y ⟶ Z} (h : f = g) : e ≫ f = e ≫ g :=
  congrArg (fun w => e ≫ w) h