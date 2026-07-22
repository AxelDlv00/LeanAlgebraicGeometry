---
author: sync
content_type: theorem
created: '2026-07-20T12:01:17'
decl: AlgebraicGeometry.ThetaGeneratorSeed.forall_flat_colength_quotient_of_hsub_free
docstring: '**Brick 1 at the chart level, from the carve pin `hsub_chart`**: the chart
  base-ideal

  colength `Γ(V) ⧸ N_V` is `R`-flat, where `V = relPinnedChart C R π b`,

  `N_V = range (chartReadMap K b)` is the image of the side reading of `K`, and the
  fibre

  input `hsub_chart` is the carve fibre non-collapse (`N_V ⊗ κ(p) ↪ Γ(V) ⊗ κ(p)` injective
  at

  every base prime `p`).  This is the chart-level analogue of `forall_flat_colength_quotient_of_hsub`

  (`DivSchemeRedesignJFlat`), reduced to the **free-codomain** `(c4)` keystone

  `Module.Flat.quotient_range_of_forall_rTensor_residueField_injective_free`: the
  codomain

  `Γ(V)` is `Module.Free R` (`free_sections_relPinnedChart`) but infinite-rank, so
  the finite

  `SlicingFlatKernel` keystone does not apply; the free-codomain one does, fed `hsub_chart`
  as

  the residue-fibre injectivity of the submodule inclusion `N_V ↪ Γ(V)`.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignFreeFlatChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.forall_flat_colength_quotient_of_hsub_free
type: lean
updated: '2026-07-20T12:01:17'
---
theorem forall_flat_colength_quotient_of_hsub_free
    (K : Submodule R (relThetaSections C R π a)) (b : Bool) [Module.Finite R ↥K]
    (hsub_chart : ∀ p : PrimeSpectrum R, Function.Injective
      ((LinearMap.range (chartReadMap K b)).subtype.rTensor p.asIdeal.ResidueField)) :
    Module.Flat R
      (Γ(relCurve C R, relPinnedChart C R π b) ⧸ LinearMap.range (chartReadMap K b)) := by
  haveI : Module.Free R Γ(relCurve C R, relPinnedChart C R π b) :=
    free_sections_relPinnedChart C R π b
  haveI : Module.Finite R ↥(LinearMap.range (chartReadMap K b)) := by
    rw [Module.Finite.iff_fg, LinearMap.range_eq_map]
    exact Module.Finite.fg_top.map (chartReadMap K b)
  have h := Module.Flat.quotient_range_of_forall_rTensor_residueField_injective_free
    (LinearMap.range (chartReadMap K b)).subtype hsub_chart
  rwa [Submodule.range_subtype] at h