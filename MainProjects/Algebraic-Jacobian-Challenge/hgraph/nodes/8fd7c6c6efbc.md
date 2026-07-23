---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.pullbackSpecLIso_inv_snd
file: AlgebraicJacobian/Picard/FiniteGaloisQuotientAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.pullbackSpecLIso_inv_snd
type: lean
updated: '2026-07-16T21:14:26'
---
lemma pullbackSpecLIso_inv_snd :
    (pullbackSpecLIso K L C).inv ≫ pullback.snd _ _
      = Spec.map (CommRingCat.ofHom (algebraMap L (L ⊗[K] C))) := by
  simp only [pullbackSpecLIso, Iso.trans_inv, specRingEquivIso_inv]
  rw [Category.assoc, pullbackSpecIso_inv_snd, ← Spec.map_comp, ← CommRingCat.ofHom_comp]
  congr 2