---
author: sync
content_type: lemma
created: '2026-08-12T15:42:08'
decl: AlgebraicJacobian.GaloisDescent.pullbackBaseChange_comp
file: AlgebraicJacobian/Descent/FiniteGaloisQuotientAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.pullbackBaseChange_comp
type: lean
updated: '2026-08-18T20:50:53'
---
lemma pullbackBaseChange_comp {T' T Y : Scheme.{u}}
    (g : Y ⟶ Spec (CommRingCat.of K)) (t : T ⟶ Spec (CommRingCat.of K))
    (t' : T' ⟶ Spec (CommRingCat.of K)) (u : T ⟶ Y) (hu : u ≫ g = t)
    (v : T' ⟶ T) (hv : v ≫ t = t') :
    pullbackBaseChange K L g t' (v ≫ u) (by rw [Category.assoc, hu, hv])
      = pullbackBaseChange K L t t' v hv ≫ pullbackBaseChange K L g t u hu := by
  apply pullback.hom_ext <;> simp