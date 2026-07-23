---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.pullbackBaseChange_comp
file: AlgebraicJacobian/Picard/FiniteGaloisQuotientAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.pullbackBaseChange_comp
type: lean
updated: '2026-07-24T03:02:10'
---
lemma pullbackBaseChange_comp {T' T Y : Scheme.{u}}
    (g : Y ⟶ Spec (CommRingCat.of K)) (t : T ⟶ Spec (CommRingCat.of K))
    (t' : T' ⟶ Spec (CommRingCat.of K)) (u : T ⟶ Y) (hu : u ≫ g = t)
    (v : T' ⟶ T) (hv : v ≫ t = t') :
    pullbackBaseChange K L g t' (v ≫ u) (by rw [Category.assoc, hu, hv])
      = pullbackBaseChange K L t t' v hv ≫ pullbackBaseChange K L g t u hu := by
  apply pullback.hom_ext <;> simp