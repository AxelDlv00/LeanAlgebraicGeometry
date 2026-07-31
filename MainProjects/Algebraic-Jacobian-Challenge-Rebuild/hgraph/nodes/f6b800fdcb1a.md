---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.MeromorphicPresentation.ofCocycle
docstring: 'The base-index construction: any unit cocycle `γ` on a pointed cover is
  presented

  meromorphically by `elem x := germ_η (γ x η)`, taking the generic point itself as
  the

  canonical base index (all overlaps contain `η`, so the cocycle identity for the
  triple

  `(x, y, η)` becomes the ratio property in `K(X)ˣ`).'
file: AlgebraicJacobian/Picard/MeromorphicPresentation.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.MeromorphicPresentation.ofCocycle
type: lean
updated: '2026-07-31T20:14:52'
---
noncomputable def ofCocycle (𝒰 : X.PointedCover) (γ : X.unitsCocycle 𝒰) :
    X.MeromorphicPresentation where
  cover := 𝒰
  cocycle := γ
  elem x := germGenericUnits (𝒰.genericPoint_mem_inf x (genericPoint X))
    (unitsEvInf γ x (genericPoint X))
  ratio x y := by
    have hηT : genericPoint X
        ∈ 𝒰.opens x ⊓ 𝒰.opens y ⊓ 𝒰.opens (genericPoint X) :=
      ⟨𝒰.genericPoint_mem_inf x y, 𝒰.genericPoint_mem_opens (genericPoint X)⟩
    have key := congrArg (germGenericUnits hηT)
      (unitsEvInf_trans γ x y (genericPoint X))
    rw [map_mul, germGenericUnits_unitsRestrict, germGenericUnits_unitsRestrict,
      germGenericUnits_unitsRestrict] at key
    rw [mul_inv_eq_iff_eq_mul]
    exact key.symm

@[simp]