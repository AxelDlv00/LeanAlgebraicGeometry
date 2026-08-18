---
author: sync
content_type: theorem
created: '2026-08-14T10:32:16'
decl: AlgebraicGeometry.PicRankOneNoetherianStage.admissibility
docstring: Every finite rank-one stage is admissible for the glued-divisor keystone.
file: AlgebraicJacobian/Picard/Pic0RankOneCanonicalDivisorStageAdmissibility.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneNoetherianStage.admissibility
type: lean
updated: '2026-08-18T20:51:05'
---
theorem admissibility (S : PicRankOneNoetherianStage P)
    (hpi : pi ≫ P1.structureMap k = C.hom) : S.Admissibility := by
  letI : IsNoetherianRing S.A0 := S.hAnoeth
  letI : Subsingleton (datumPair (S.D0.baseChange S.A0)).H1 := S.hpair
  have hwit : ∀ p : PrimeSpectrum S.A0,
      (S.D0.baseChange S.A0).HasWitnessH1Vanishing p.asIdeal.ResidueField :=
    fun p => ((S.D0.baseChange S.A0).hasWitnessH1Vanishing_iff_subsingleton
      p.asIdeal.ResidueField).mpr inferInstance
  have cert : RankOneFamilyCertificates (S.D0.baseChange S.A0) := S.certificates hpi
  exact ⟨hwit, stage_classDeg_all_fields pi (S.D0.baseChange S.A0) S.hpair cert⟩