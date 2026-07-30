---
author: sync
content_type: theorem
created: '2026-07-31T03:02:20'
decl: AlgebraicGeometry.isOpenImmersion_presheaf_abelSigmaChart_of_mono_of_cov
docstring: '**THE REPRICING AT ARBITRARY PARAMETER**, which is what a coverage lane
  at `n > 0` needs.


  `isOpenImmersion_presheaf_of_injective` is stated for an arbitrary presheaf morphism,
  so it

  composes with the *landed* `injective_abelSigmaChart_of_mono` (`Pic0ChartSubsingletonCollapse`)

  to give: for the general Abel chart at **any** parameter `n`, with `Mono D.hom`
  on the

  representing object, **coverage implies antecedent 1**.


  This is strictly more useful than the parameter-`0` statements above, and it is
  not about the

  terminal chart at all.  A lane holding antecedent 2 at `n > 0` owes `Mono D.hom`
  and nothing

  else on the antecedent-1 side — no `ChartFibrePresented` datum, no relative GAP-2,
  no

  certificate.  `Mono D.hom` is itself a real obligation, and `Pic0ChartForkNegativeBranch`

  refutes chart injectivity (hence `Mono`, hence antecedent 1) wherever an effective
  divisor of

  degree `n` has two sections; so this is a reduction of antecedent 1 to a divisor-scheme

  property, not a discharge of it.'
file: AlgebraicJacobian/Picard/Pic0ChartSeamPairDecided.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isOpenImmersion_presheaf_abelSigmaChart_of_mono_of_cov
type: lean
updated: '2026-07-31T03:02:20'
---
theorem isOpenImmersion_presheaf_abelSigmaChart_of_mono_of_cov {n : ℕ}
    {D : Over (Spec (.of k))} (rep : (divFunctor C pi n).RepresentableBy D) [Mono D.hom]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (abelSigmaChart C pi n rep m Z hdeg)) :
    IsOpenImmersion.presheaf (abelSigmaChart C pi n rep m Z hdeg) :=
  isOpenImmersion_presheaf_of_injective C _
    (injective_abelSigmaChart_of_mono rep m Z hdeg) hcov