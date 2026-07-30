---
author: sync
content_type: theorem
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.exists_cechPicClass_eq
docstring: '**The extraction keystone** (stage 1f; worksheet §2.3.1): every Čech Picard
  class

  on the relative curve refines to a pinned basic-open cocycle datum with the same

  class — the DAT-1 constructor input shape, on finite basic-open families of the
  two

  pinned charts.'
file: AlgebraicJacobian/Cohomology/GluedSheafExtraction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.exists_cechPicClass_eq
type: lean
updated: '2026-07-30T15:46:00'
---
theorem exists_cechPicClass_eq (c : (relCurve C B).CechPic) :
    ∃ D : BasicOpenCocycleDatum C B π, D.cechPicClass = c := by
  induction c using Scheme.CechPic.ind with | mk 𝒰 a =>
  induction a using Quot.ind with | _ γ =>
  obtain ⟨ι₀, hfin₀, f₀, an₀, a₀, hsub₀, hpart₀⟩ :=
    (relCover_isAffineOpen₀ C B (fiberTwoCover π)).exists_finite_basicOpen_refinement 𝒰
  obtain ⟨ι₁, hfin₁, f₁, an₁, a₁, hsub₁, hpart₁⟩ :=
    (relCover_isAffineOpen₁ C B (fiberTwoCover π)).exists_finite_basicOpen_refinement 𝒰
  refine ⟨ofRefinement ι₀ ι₁ f₀ a₀ f₁ a₁ 𝒰 γ an₀ an₁ hpart₀ hpart₁ hsub₀ hsub₁, ?_⟩
  exact cechPicClass_eq_of_anchor _ 𝒰 γ (Sum.elim an₀ an₁)
    (refinementCoverData_pieces_le ι₀ ι₁ f₀ a₀ f₁ a₁ 𝒰 an₀ an₁ hpart₀ hpart₁
      hsub₀ hsub₁)
    (fun i j => rfl)