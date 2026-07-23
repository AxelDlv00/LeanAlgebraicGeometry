---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.constMap
docstring: 'The structural ring map `k → Γ(C, 𝒪_C)` of a `k`-curve `C`, obtained from
  the

  structure morphism `C.hom : C ⟶ Spec k` on global sections, transported across

  `Γ(Spec k, ⊤) ≅ k`.'
file: AlgebraicJacobian/Picard/SectionRingUniversal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.constMap
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def constMap (C : Over (Spec (CommRingCat.of k))) :
    CommRingCat.of k ⟶ Γ(C.left, ⊤) :=
  (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ C.hom.appTop

/-- The `k`-algebra structure on `Γ(C, 𝒪_C)` induced by the structure morphism. -/
noncomputable scoped instance globalSectionsAlgebra (C : Over (Spec (CommRingCat.of k))) :
    Algebra k Γ(C.left, ⊤) :=
  (constMap C).hom.toAlgebra