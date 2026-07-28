---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.isIso_appTop_of_isoSq
docstring: 'Transport `IsIso (·.appTop)` across an isomorphism of arrows: given scheme
  morphisms

  `a : W ⟶ X`, `b : Y ⟶ Z` and isomorphisms `l : W ≅ Y`, `r : X ≅ Z` forming a commuting
  square

  `a ≫ r.hom = l.hom ≫ b`, if `b.appTop` is an isomorphism then so is `a.appTop`.  (The
  two ends of

  the square being isomorphisms makes the induced global-section maps differ by isomorphisms.)'
file: AlgebraicJacobian/Picard/StructureSheafPushforward.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.isIso_appTop_of_isoSq
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma isIso_appTop_of_isoSq {W X Y Z : Scheme.{u}} {a : W ⟶ X} {b : Y ⟶ Z}
    (l : W ≅ Y) (r : X ≅ Z) (comm : a ≫ r.hom = l.hom ≫ b) [IsIso (b.appTop)] :
    IsIso (a.appTop) := by
  have key := congrArg Scheme.Hom.appTop comm
  rw [Scheme.Hom.comp_appTop, Scheme.Hom.comp_appTop] at key
  haveI : IsIso (r.hom.appTop) := isIso_appTop_of_isIso r.hom
  haveI : IsIso (l.hom.appTop) := isIso_appTop_of_isIso l.hom
  have ha : a.appTop = inv (r.hom.appTop) ≫ b.appTop ≫ l.hom.appTop := by
    rw [← key, IsIso.inv_hom_id_assoc]
  rw [ha]; infer_instance