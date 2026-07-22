---
author: sync
content_type: theorem
created: '2026-07-20T16:02:15'
decl: AlgebraicGeometry.DivisorAdaptation.isCertified_of_noLeak_kernel_spanning
docstring: 'The certificate constructor in the exact SupportTube form: fibrewise no-leak
  of

  each chart trace supplies its finite colength, after which

  `isCertified_of_kernel_spanning` handles every remaining field.'
file: AlgebraicJacobian/Picard/DivSchemeCertUniv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.isCertified_of_noLeak_kernel_spanning
type: lean
updated: '2026-07-20T16:02:15'
---
theorem isCertified_of_noLeak_kernel_spanning [IsNoetherianRing R] {n : Nat}
    (hnoLeak : forall (j : A.index) (s : Spec (.of R)),
      ((relCurve C R) ↘ Spec (.of R)).base ⁻¹' {s}
          ∩ closure (d.supportLocus ∩ (A.pieces j : Set (relCurve C R))) <=
        (A.pieces j : Set (relCurve C R)))
    (hregular : forall (j : A.index) (p : PrimeSpectrum R),
      (A.eqn j ⊗ₜ[R] (1 : p.asIdeal.ResidueField) :
          Γ(relCurve C R, A.pieces j) ⊗[R] p.asIdeal.ResidueField) ∈
        nonZeroDivisors
          (Γ(relCurve C R, A.pieces j) ⊗[R] p.asIdeal.ResidueField))
    (hovlFinite : Module.Finite R A.ovlProd)
    (hovlFlat : Module.Flat R A.ovlProd)
    (L : Submodule R A.chartProd)
    (hle : L <= LinearMap.ker (A.deltaLeft - A.deltaRight))
    (hspan : forall p : PrimeSpectrum R,
      LinearMap.ker ((A.deltaLeft - A.deltaRight).rTensor p.asIdeal.ResidueField) <=
        LinearMap.range (L.subtype.rTensor p.asIdeal.ResidueField))
    (hdim : forall p : PrimeSpectrum R,
      Module.finrank p.asIdeal.ResidueField
          (LinearMap.ker
            ((A.deltaLeft - A.deltaRight).baseChange p.asIdeal.ResidueField)) = n) :
    A.IsCertified n :=
  A.isCertified_of_kernel_spanning
    (fun j => A.finite_colength_of_forall_fibre_closure_subset j (hnoLeak j))
    hregular hovlFinite hovlFlat L hle hspan hdim