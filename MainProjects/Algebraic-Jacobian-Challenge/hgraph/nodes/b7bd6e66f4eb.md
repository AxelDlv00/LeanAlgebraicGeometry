---
author: sync
content_type: lemma
created: '2026-07-31T18:08:01'
decl: AlgebraicGeometry.Scheme.DivFamily.twistQuotientMap_rel
docstring: 'Equivalent divisor families have isomorphic twists, compatibly with the

  twisted quotient maps.  This is the representative-level descent input for

  the D2'' Grassmannian comparison.'
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.twistQuotientMap_rel
type: lean
updated: '2026-07-31T18:08:01'
---
lemma twistQuotientMap_rel (L : X.Modules) {x y : DivFamily π T} (h : x.Rel y) :
    ∃ f : x.twist L ≅ y.twist L,
      x.twistQuotientMap L ≫ f.hom = y.twistQuotientMap L := by
  obtain ⟨f, hf⟩ := h
  refine ⟨Modules.tensorObjIsoOfIso (Iso.refl _) f, ?_⟩
  change ((Modules.tensorObj_right_unitor _).inv ≫
      Modules.tensorObj_functoriality (𝟙 _)
        ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q)) ≫
      Modules.tensorObj_functoriality (𝟙 _) f.hom =
    (Modules.tensorObj_right_unitor _).inv ≫
      Modules.tensorObj_functoriality (𝟙 _)
        ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ y.q)
  rw [Category.assoc]
  rw [show Modules.tensorObj_functoriality (𝟙 _) _ ≫
        Modules.tensorObj_functoriality (𝟙 _) f.hom =
      Modules.tensorObj_functoriality ((𝟙 _) ≫ (𝟙 _))
        (((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q) ≫ f.hom) by
    simp only [Modules.tensorObj_functoriality]
    exact map_tensorHom_comp2
      (C := _root_.PresheafOfModules
        ((pullback π T.hom).presheaf ⋙ forget₂ CommRingCat RingCat))
      _ _ _ _ _]
  simp only [Category.id_comp]
  rw [Category.assoc, hf]