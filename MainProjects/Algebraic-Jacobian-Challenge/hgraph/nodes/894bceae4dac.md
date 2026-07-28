---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.tensorObjAssoc_associator_counit_coherence_stage2
docstring: 'Stage 2 of the coherence: after the interchange-law reordering (`whisker_exchange`),
  push the

  canonical associator to the front (associator naturality) and hand off to the tail
  lemma.

  A separate

  declaration so its single `simp` + handoff `exact` fit one heartbeat budget.'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Modules.tensorObjAssoc_associator_counit_coherence_stage2
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma tensorObjAssoc_associator_counit_coherence_stage2
    {M : Type*} [Category M] [MonoidalCategory M]
    {A B C A' B' C' P Q R D E : M}
    (eA : A' ≅ A) (eB : B' ≅ B) (eC : C' ≅ C) (eR : R ≅ Q)
    (m1 : D ⟶ P ⊗ C') (m3 : P ⟶ A' ⊗ B') (m4 : B' ⊗ C' ⟶ Q) (m5 : A' ⊗ R ⟶ E) :
    m1 ≫ m3 ▷ C' ≫ eA.hom ▷ B' ▷ C' ≫ (A ◁ eB.hom) ▷ C' ≫ (A ⊗ B) ◁ eC.hom ≫
        (α_ A B C).hom ≫ eA.inv ▷ (B ⊗ C) ≫ A' ◁ eB.inv ▷ C ≫ A' ◁ B' ◁ eC.inv ≫
        A' ◁ m4 ≫ A' ◁ eR.inv ≫ m5
      = m1 ≫ m3 ▷ C' ≫ (α_ A' B' C').hom ≫ A' ◁ m4 ≫ A' ◁ eR.inv ≫ m5 := by
  simp only [MonoidalCategory.associator_naturality_right_assoc,
    MonoidalCategory.associator_naturality_middle_assoc,
    MonoidalCategory.associator_naturality_left_assoc]
  exact tensorObjAssoc_associator_counit_coherence_tail eA eB eC eR m1 m3 m4 m5