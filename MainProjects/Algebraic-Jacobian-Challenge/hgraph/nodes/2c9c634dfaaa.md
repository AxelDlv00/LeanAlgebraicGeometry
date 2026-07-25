---
author: sync
content_type: theorem
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Scheme.Modules.mem_range_rankStratumι_iff
docstring: '**The support of the rank-`e` stratum is the rank-`e` locus**

  [Nitsure §4, part (i)].'
file: AlgebraicJacobian/Picard/FlatteningStratificationUniversal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.mem_range_rankStratumι_iff
type: lean
updated: '2026-07-26T06:25:05'
---
theorem mem_range_rankStratumι_iff [IsLocallyNoetherian S]
    [F.IsFinitePresentation] (s : S) :
    s ∈ Set.range (rankStratumι F e).base ↔ pointRank S F s = e := by
  haveI := pullback_isQuasicoherent_hom (chartLocus F e).ι F ‹_›
  constructor
  · rintro ⟨z, rfl⟩
    have hz : (rankStratumι F e).base z = ((chartLocus F e).ι.base)
        ((stratumι ((Scheme.Modules.pullback (chartLocus F e).ι).obj F) e
          (chartsCover_chartLocus F e)).base z) := rfl
    rw [hz, ← pointRank_pullback (chartLocus F e).ι F]
    exact (mem_range_stratumι_iff _ (chartsCover_chartLocus F e) _).mp
      ⟨z, rfl⟩
  · intro h
    have hs : s ∈ chartLocus F e := mem_chartLocus_of_pointRank_eq F e h
    have hs' : s ∈ Set.range (chartLocus F e).ι := by
      rwa [Scheme.Opens.range_ι]
    obtain ⟨x, hx⟩ := hs'
    have hrx : pointRank ((chartLocus F e) : Scheme.{u})
        ((Scheme.Modules.pullback (chartLocus F e).ι).obj F) x = e := by
      rw [pointRank_pullback (chartLocus F e).ι F x, hx]
      exact h
    obtain ⟨z, hz⟩ := (mem_range_stratumι_iff _
      (chartsCover_chartLocus F e) x).mpr hrx
    refine ⟨z, ?_⟩
    change ((chartLocus F e).ι.base)
      ((stratumι ((Scheme.Modules.pullback (chartLocus F e).ι).obj F) e
        (chartsCover_chartLocus F e)).base z) = s
    rw [show ((stratumι ((Scheme.Modules.pullback (chartLocus F e).ι).obj F) e
      (chartsCover_chartLocus F e)).base z) = x from hz, hx]