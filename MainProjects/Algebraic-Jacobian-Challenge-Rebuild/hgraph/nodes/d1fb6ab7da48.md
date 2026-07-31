---
author: sync
content_type: lemma
created: '2026-07-17T16:57:14'
decl: AlgebraicGeometry.crossBaseAffineIso_inv_snd
file: AlgebraicJacobian/Picard/Pic0Theta.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.crossBaseAffineIso_inv_snd
type: lean
updated: '2026-07-31T20:14:50'
---
lemma crossBaseAffineIso_inv_snd :
    (crossBaseAffineIso k L C A).inv
        ≫ (snd ((baseChange k L).obj C) (overSpec L A)).left
      = (snd C (overSpec k A)).left :=
  (Iso.inv_comp_eq _).mpr (crossBaseAffineIso_hom_snd k L C A).symm