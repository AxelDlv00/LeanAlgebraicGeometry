---
author: sync
content_type: theorem
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.Over.cechPicMap_pieceι_eq_one
docstring: '**The piece restriction of the descending class is trivial** (D2 item
  3a, residual

  half — the recovery identity at construction time): the class `L = CechPic.mk 𝒩
  γ.class`

  of the (C2) setting pulls back to `1` on the open subscheme `cg⁻¹ V`, cobounded
  by the

  piece trivialization.  Together with `mapAlgebra_pieceDescentClass_eq_one` this
  is the

  recovery `cg^* M_V = [L|_{cg⁻¹V}]`: both sides are trivial, by construction.'
file: AlgebraicJacobian/Picard/EffectivityPieceDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.cechPicMap_pieceι_eq_one
type: lean
updated: '2026-07-31T20:15:25'
---
theorem cechPicMap_pieceι_eq_one {𝒩 : (XB).PointedCover} {γ : (XB).unitsCocycle 𝒩}
    {V : (XA).Opens} (T : PieceTrivialization C 𝒩 γ V) :
    Scheme.CechPic.map (Scheme.Opens.ι ((cg) ⁻¹ᵁ V))
        (Scheme.CechPic.mk 𝒩 γ.class)
      = 1 := by
  rw [Scheme.CechPic.map_mk, Scheme.Hom.pullbackUnitsH1_class,
    Scheme.CechPic.mk_eq_one_iff]
  exact (OneCocycle.class_eq_iff _ 1).mpr
    (Scheme.Hom.pullbackUnitsCocycle_isCohomologous_one
      (Scheme.Opens.ι ((cg) ⁻¹ᵁ V)) 𝒩 γ ((cg) ⁻¹ᵁ V)
      (Scheme.Opens.ι_preimage_self ((cg) ⁻¹ᵁ V)) T.triv T.triv_rel)