---
author: sync
content_type: theorem
created: '2026-07-20T02:01:14'
decl: AlgebraicGeometry.ThetaGeneratorSeed.hfield_of_forall_pinnedPieceSectionsMap_mem
docstring: '**`hfield` reduced to fibre divisibility**: if every `K`-side component
  of the seed

  `D`, restricted to the base-changed piece `D(h z'')` at each base prime `p`, is
  divisible by

  the base-changed equation `eqn z''`, then the `hfield` clause of

  `isGenerator_of_fibrewise_ker_span_of_field_vanishing` holds — every element of
  the

  `K`-side-component submodule `N z` dies in the residue-field fibre.  The transport
  is

  `mk_tmul_one_eq_zero_iff_pinnedPieceSectionsMap_mem`; the residual honest content
  is the

  `hdiv` fibre-divisibility (the `d_p` achiever, for the universal seed).'
file: AlgebraicJacobian/Picard/DivSchemeUnivFibreKerSpan.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ThetaGeneratorSeed.hfield_of_forall_pinnedPieceSectionsMap_mem
type: lean
updated: '2026-07-31T20:14:49'
---
theorem hfield_of_forall_pinnedPieceSectionsMap_mem
    (hdiv : ∀ (z : relCurve C R) (p : PrimeSpectrum R) ⦃ψ : relThetaSections C R π a⦄,
      ψ ∈ K →
      pinnedPieceSectionsMap p.asIdeal.ResidueField (D.side z) (D.h z)
          (relThetaResSide a (D.side z) (D.piece_le z) ψ)
        ∈ Ideal.span {pinnedPieceSectionsMap p.asIdeal.ResidueField (D.side z) (D.h z)
          (D.eqn z)}) :
    ∀ (z : relCurve C R) (y : relCurve C R) (hy : y ∈ D.piece z)
        (x : ↥(D.sideColengthSubmodule z)),
        ((x : Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z}) ⊗ₜ[R]
            (1 : (basePrime (R := R)
              ((relCurve C R).presheaf.germ (D.piece z) y hy).hom).asIdeal.ResidueField))
          = 0 := by
  intro z y hy x
  obtain ⟨ψ, hψK, hψx⟩ := x.2
  have hmk : (x : Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z})
      = Ideal.Quotient.mk (Ideal.span {D.eqn z})
          (relThetaResSide a (D.side z) (D.piece_le z) ψ) := hψx.symm
  rw [hmk]
  refine (mk_tmul_one_eq_zero_iff_pinnedPieceSectionsMap_mem _ (D.side z) (D.h z)
    {D.eqn z} (relThetaResSide a (D.side z) (D.piece_le z) ψ)).mpr ?_
  rw [Set.image_singleton]
  exact hdiv z _ hψK

/-! ## The `hspan` reduction: to fibre injectivity of the induced map -/

set_option maxHeartbeats 1600000 in
-- the heavy relCurve section-ring colength drives the `rTensor` factorisation defeq past
-- the default budget
set_option synthInstance.maxHeartbeats 400000 in