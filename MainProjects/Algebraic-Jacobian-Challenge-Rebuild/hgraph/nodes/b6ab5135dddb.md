---
author: sync
content_type: theorem
created: '2026-07-19T15:01:16'
decl: AlgebraicGeometry.DivisorAdaptation.divEq_sectionLocalEquations_canonSection
docstring: '**(N2) — the canonical section cuts back `d` by pure refinement**: the

  `LocalEquations` datum cut by the canonical section on any pointed cover subordinated

  to the pieces is `DivEq` to `d`. The common refinement is `𝒲 ⊓ d.cover`, and the

  comparison units are the adaptation''s own `eqn_rel` units (`relUnit`) — no fibre

  argument anywhere.'
file: AlgebraicJacobian/Picard/DivisorDatumInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.divEq_sectionLocalEquations_canonSection
type: lean
updated: '2026-07-29T15:31:43'
---
theorem divEq_sectionLocalEquations_canonSection
    (𝒲 : (relCurve C R).PointedCover) (σ : relCurve C R → (A.thetaIdealDatum 0).index)
    (hσ : ∀ y : relCurve C R, 𝒲.opens y ≤ A.divisorDatum.pieces (σ y)) :
    Scheme.LocalEquations.DivEq
      (A.divisorDatum.sectionLocalEquations A.canonSection 𝒲 σ hσ
        (fun j y hy => A.germ_component_canonSection_mem_nonZeroDivisors j y hy))
      d := by
  refine ⟨𝒲 ⊓ d.cover, fun x => inf_le_left, fun x => inf_le_right, fun x => ?_⟩
  -- the piece through `x` sits inside the adaptation piece of its lowered index
  have hpc : 𝒲.opens x ≤ A.pieces (A.lowerIndex 0 (σ x)) :=
    (hσ x).trans (le_of_eq (A.thetaIdealDatum_pieces 0 (σ x)))
  have hle : 𝒲.opens x ⊓ d.cover.opens x
      ≤ A.pieces (A.lowerIndex 0 (σ x)) ⊓ d.cover.opens x :=
    inf_le_inf_right _ hpc
  refine ⟨(relCurve C R).unitsRestrict hle (A.relUnit (A.lowerIndex 0 (σ x)) x), ?_⟩
  -- the defining equation of the comparison unit, restricted to the refinement
  have key := congrArg ((relCurve C R).resHom hle)
    (A.res_eqn_eq_relUnit_mul (A.lowerIndex 0 (σ x)) x)
  rw [map_mul] at key
  simp only [Scheme.resHom_resHom] at key
  -- collapse the constructed datum's restricted equation onto the adaptation
  -- equation, term-mode (`rw` walks into the relCurve spelling seam — I-0237(a))
  have hlhs := (Scheme.resHom_resHom (hσ x)
      (inf_le_left : 𝒲.opens x ⊓ d.cover.opens x ≤ 𝒲.opens x)
      (A.divisorDatum.component A.canonSection (σ x))).trans
    ((congrArg ((relCurve C R).resHom
        ((inf_le_left : 𝒲.opens x ⊓ d.cover.opens x ≤ 𝒲.opens x).trans (hσ x)))
      (A.component_canonSection (σ x))).trans
      (Scheme.resHom_resHom (le_of_eq (A.thetaIdealDatum_pieces 0 (σ x)))
        ((inf_le_left : 𝒲.opens x ⊓ d.cover.opens x ≤ 𝒲.opens x).trans (hσ x))
        (A.eqn (A.lowerIndex 0 (σ x)))))
  exact hlhs.trans key