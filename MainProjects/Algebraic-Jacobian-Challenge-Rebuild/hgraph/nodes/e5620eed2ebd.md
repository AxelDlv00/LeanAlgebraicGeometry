---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.germ_res_eqn_left
docstring: 'The restriction of the first equation to a piece overlap vanishes along
  `d`

  germwise.'
file: AlgebraicJacobian/Picard/DivisorThetaDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.germ_res_eqn_left
type: lean
updated: '2026-07-17T16:57:13'
---
private lemma germ_res_eqn_left (i j : A.index) :
    ∀ (z : relCurve C R) (hz : z ∈ A.pieces i ⊓ A.pieces j),
      ((relCurve C R).presheaf.germ (A.pieces i ⊓ A.pieces j) z hz).hom
        ((relCurve C R).resHom (inf_le_left : A.pieces i ⊓ A.pieces j ≤ A.pieces i)
          (A.eqn i)) ∈ d.stalkIdeal z :=
  fun z hz => A.germ_res_eqn_mem_stalkIdeal i inf_le_left z hz