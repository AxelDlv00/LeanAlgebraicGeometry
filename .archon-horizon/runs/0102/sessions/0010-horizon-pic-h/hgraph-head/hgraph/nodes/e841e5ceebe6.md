---
author: sync
content_type: theorem
created: '2026-07-20T04:31:14'
decl: AlgebraicGeometry.ThetaGeneratorSeed.forall_flat_colength_quotient_of_hsub
docstring: '**Brick 1, `∀ z` package from the cleanest carve statement `hsub`**: the
  same

  `hflat` conclusion, reduced all the way to the fibre non-collapse of the side-component

  inclusion — at every base prime `p`, `N z ⊗ κ(p) ↪ colength z ⊗ κ(p)` is injective.  This

  is the rank-`g` pinning delivered by `divUniversal_carve_residueField`: no fibre
  of the

  `K`-side-component submodule `N z` collapses.  Composes the landed reductions

  `hsub ⟹ hinj` (`hinj_of_forall_sideColengthSubmodule_subtype_rTensor_injective`)
  and

  `hinj ⟹ hspan` (`hspan_of_forall_liftQ_rTensor_injective`) with the (c4) keystone;
  it is the

  brick-1 flat producer downstream `RD-N` / the certificate consume, parameterized
  by the one

  honest carve obligation.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignJFlat.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.forall_flat_colength_quotient_of_hsub
type: lean
updated: '2026-08-01T09:44:12'
---
theorem forall_flat_colength_quotient_of_hsub [Module.Finite R ↥K]
    (hcolFin : ∀ z : relCurve C R,
      Module.Finite R (Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z}))
    (hcolFlat : ∀ z : relCurve C R,
      Module.Flat R (Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z}))
    (hsub : ∀ (z : relCurve C R) (p : PrimeSpectrum R),
      Function.Injective
        ((D.sideColengthSubmodule z).subtype.rTensor p.asIdeal.ResidueField)) :
    ∀ z : relCurve C R,
      Module.Flat R ((Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z})
        ⧸ D.sideColengthSubmodule z) :=
  D.forall_flat_colength_quotient_of_hspan hcolFin hcolFlat
    (D.hspan_of_forall_liftQ_rTensor_injective
      (D.hinj_of_forall_sideColengthSubmodule_subtype_rTensor_injective hsub))