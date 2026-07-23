---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.ZariskiDescent.isSheaf_gluedFunctor
docstring: '**The glued functor is a sheaf for the big Zariski topology.**'
file: AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ZariskiDescent.isSheaf_gluedFunctor
type: lean
updated: '2026-07-16T21:14:28'
---
lemma isSheaf_gluedFunctor :
    Presieve.IsSheaf Scheme.zariskiTopology (gluedFunctor F Y R) := by
  rw [zariskiTopology_eq, Presieve.isSheaf_pretopology]
  rintro T Rp hRp
  obtain ⟨𝓤, rfl⟩ := exists_cover_of_mem_pretopology hRp
  -- Reduce to the cover by the image opens: both presieves generate the
  -- same sieve, since each factors through the other.
  let κ : Type := {V : T.Opens // ∃ j, (𝓤.f j).opensRange = V}
  let W : κ → T.Opens := Subtype.val
  have hW : ⨆ k, W k = ⊤ := by
    rw [eq_top_iff]
    rintro t -
    obtain ⟨j, y, hy⟩ := 𝓤.exists_eq t
    exact TopologicalSpace.Opens.mem_iSup.mpr
      ⟨⟨(𝓤.f j).opensRange, j, rfl⟩, ⟨y, hy⟩⟩
  have hgen : Sieve.generate (Presieve.ofArrows 𝓤.X 𝓤.f)
      = Sieve.generate
          (Presieve.ofArrows (fun k => (W k).toScheme) (fun k => (W k).ι)) := by
    apply le_antisymm
    · rw [Sieve.generate_le_iff]
      rintro Z g ⟨j⟩
      refine ⟨((𝓤.f j).opensRange).toScheme,
        IsOpenImmersion.lift ((𝓤.f j).opensRange).ι (𝓤.f j)
          (by rw [Scheme.Opens.range_ι]; exact subset_rfl),
        ((𝓤.f j).opensRange).ι,
        Presieve.ofArrows.mk (⟨(𝓤.f j).opensRange, j, rfl⟩ : κ),
        IsOpenImmersion.lift_fac _ _ _⟩
    · rw [Sieve.generate_le_iff]
      rintro Z g ⟨k⟩
      obtain ⟨j, hj⟩ := k.2
      refine ⟨𝓤.X j, IsOpenImmersion.lift (𝓤.f j) ((k.1).ι)
        (by rw [Scheme.Opens.range_ι, ← hj]; exact subset_rfl), 𝓤.f j,
        Presieve.ofArrows.mk j, IsOpenImmersion.lift_fac _ _ _⟩
  rw [Presieve.isSheafFor_iff_generate, hgen,
    ← Presieve.isSheafFor_iff_generate]
  exact isSheafFor_opens hF hU T W hW

/-! ## §6. The charts

Each local representing object `Y i` maps to the glued functor: a morphism
`t : T ⟶ (Y i).left` classifies an `F`-section over
`T → U i → S`, whose glued point is the chart image of `t`. -/

include hF hU in