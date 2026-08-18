---
author: sync
content_type: theorem
created: '2026-08-03T20:05:08'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.exists_basicOpen_h1_vanishing
docstring: 'A witness at one prime is contained in a basic open on which the datum-pair
  H1

  fibre vanishes at every prime.'
file: AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSurjectiveSpread.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.exists_basicOpen_h1_vanishing
type: lean
updated: '2026-08-18T20:51:04'
---
theorem exists_basicOpen_h1_vanishing
    (D : BasicOpenCocycleDatum C B pi)
    (hpi : pi ≫ P1.structureMap k = C.hom) (p : PrimeSpectrum B)
    (hp : D.HasWitnessH1Vanishing p.asIdeal.ResidueField) :
    ∃ h : B, h ∉ p.asIdeal ∧ ∀ q : PrimeSpectrum B, h ∉ q.asIdeal →
      Subsingleton ((datumPair D).H1 ⊗[B] q.asIdeal.ResidueField) := by
  have hp' : Subsingleton ((datumPair D).H1 ⊗[B] p.asIdeal.ResidueField) :=
    (D.hasWitnessH1Vanishing_iff_subsingleton p.asIdeal.ResidueField).mp hp
  obtain ⟨U, ⟨h, rfl⟩, hpU, hU⟩ :=
    PrimeSpectrum.isTopologicalBasis_basic_opens.exists_subset_of_mem_open hp'
      (datumRigidEngine_isOpen_vanishing D hpi)
  refine ⟨h, (PrimeSpectrum.mem_basicOpen h p).mp hpU, fun q hq => ?_⟩
  exact hU ((PrimeSpectrum.mem_basicOpen h q).mpr hq)