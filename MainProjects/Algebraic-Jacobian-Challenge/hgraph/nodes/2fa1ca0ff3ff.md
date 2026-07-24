---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.counit_assoc_tail_id
docstring: '**Counit round-trip tail is the identity** (tail step of the associator
  coherence below).

  After the canonical associator is pushed to the front by naturality, the residual
  block of counit

  `hom`/`inv` pairs (outer `eA`, then middle/right `eB`/`eC`) is an endomorphism of
  `A'' ⊗ B'' ⊗ C''`

  equal to the identity (interchange law + iso cancellation).  Split out as its own
  declaration so its

  `whisker_exchange`/`whiskerLeft_comp` simp normalisation gets a fresh heartbeat
  budget,

  and is applied to

  the main goal by `congrArg` (no kabstract).'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.counit_assoc_tail_id
type: lean
updated: '2026-07-25T06:32:31'
---
private lemma counit_assoc_tail_id {M : Type*} [Category M] [MonoidalCategory M]
    {A A' B B' C C' Z : M} (eA : A' ≅ A) (eB : B' ≅ B) (eC : C' ≅ C)
    (g : A' ⊗ B' ⊗ C' ⟶ Z) :
    eA.hom ▷ (B' ⊗ C') ≫ A ◁ eB.hom ▷ C' ≫ A ◁ B ◁ eC.hom ≫ eA.inv ▷ (B ⊗ C) ≫
        A' ◁ eB.inv ▷ C ≫ A' ◁ B' ◁ eC.inv ≫ g = g := by
  simp only [MonoidalCategory.whisker_exchange_assoc,
    MonoidalCategory.hom_inv_whiskerRight_assoc,
    ← MonoidalCategory.whiskerLeft_comp_assoc, ← MonoidalCategory.whiskerLeft_comp,
    Iso.hom_inv_id, MonoidalCategory.whiskerLeft_id, Category.id_comp]