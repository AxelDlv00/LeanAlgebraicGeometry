---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.prodRefinement
docstring: 'The product basic refinement of a pulled-back pointed cover: given a basic
  refinement

  `P` of `𝒰` on `Y` and a basic refinement `Q` of `𝒰.pullback g` on `X`, the refinement
  of

  `𝒰.pullback g` indexed by `P.ι × Q.ι`, with sections `g.appTop (P.r i) * Q.r j`
  and points

  `Q.pt j`.  Its basic opens `X.basicOpen (g.appTop (P.r i) * Q.r j)` refine those
  of `Q`,

  hence of `𝒰.pullback g`, and still cover `X`.'
file: AlgebraicJacobian/Picard/CechPicToPicNaturality.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.prodRefinement
type: lean
updated: '2026-08-01T09:44:11'
---
private def prodRefinement (g : X ⟶ Y) {𝒰 : Y.PointedCover} (P : 𝒰.BasicRefinement)
    (Q : (𝒰.pullback g).BasicRefinement) : (𝒰.pullback g).BasicRefinement where
  ι := P.ι × Q.ι
  pt p := Q.pt p.2
  r p := g.appTop.hom (P.r p.1) * Q.r p.2
  basicOpen_le p :=
    ((X.basicOpen_mul _ _).trans_le inf_le_right).trans (Q.basicOpen_le p.2)
  iSup_eq := by
    rw [eq_top_iff]
    intro x _
    have hP : (⨆ i, X.basicOpen (g.appTop.hom (P.r i))) = ⊤ := by
      have h : ∀ i, X.basicOpen (g.appTop.hom (P.r i)) = g ⁻¹ᵁ Y.basicOpen (P.r i) :=
        fun i => (g.preimage_basicOpen_top (P.r i)).symm
      simp_rw [h]
      exact g.iSup_preimage_eq_top P.iSup_eq
    have hxP : x ∈ ⨆ i, X.basicOpen (g.appTop.hom (P.r i)) := hP.ge trivial
    have hxQ : x ∈ ⨆ j, X.basicOpen (Q.r j) := Q.iSup_eq.ge trivial
    obtain ⟨i, hi⟩ := Opens.mem_iSup.mp hxP
    obtain ⟨j, hj⟩ := Opens.mem_iSup.mp hxQ
    exact Opens.mem_iSup.mpr ⟨(i, j), (X.basicOpen_mul _ _).ge ⟨hi, hj⟩⟩

@[simp]