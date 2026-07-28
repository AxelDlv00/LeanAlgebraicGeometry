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
private: true
title: AlgebraicGeometry.precomp_eq_of_eq
type: lean
updated: '2026-07-28T13:22:16'
---
private lemma precomp_eq_of_eq {C : Type*} [Category C] {W Y Z : C}
    (e : W ⟶ Y) {f g : Y ⟶ Z} (h : f = g) : e ≫ f = e ≫ g :=
  congrArg (fun w => e ≫ w) h

/-! ### The `coreIso_comm` chain (`lem:coreIso_comm_leg` → `lem:coreIso_comm_coface` →
`lem:coreIso_comm_sum` → `lem:coreIso_comm`), built bottom-up per the iter-072 effort-break. -/