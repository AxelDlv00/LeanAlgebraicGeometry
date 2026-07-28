---
author: sync
content_type: theorem
created: '2026-07-29T06:51:20'
decl: AlgebraicGeometry.divFamEps_eq_of_le_of_quotientData
docstring: '**THE CARRIER-FREE ε-PAIR IDENTITY.**  For an *arbitrary* class `F : DivFam
  C R π g` —

  no certificate threaded, no adaptation named — `ε` of `F` is the Grassmannian pair
  `(x₁, x₂)`

  as soon as each `xᵢ` is contained in the corresponding window of `F` and each window
  quotient

  is projective of constant rank `g`.


  This is the form a producer on **either** carrier can feed: the chart-typed one
  through

  `windowQuotEquiv` off its own certificate (see

  `divisorWindow_eq_of_le_of_isCertified_of_quotientData`), and the widened R2 one
  through

  whatever makes its glued module invertible — the statement does not care, because

  `DivFam.window` is `divisorWindow` of a representative''s `eqns` and `divisorWindow`
  reads

  nothing else.


  Read together with the module docstring: this is the half of U2 that

  `forall_not_isCertified_of_straddling` does **not** refute.'
file: AlgebraicJacobian/Picard/DivRepChartClassUnivQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFamEps_eq_of_le_of_quotientData
type: lean
updated: '2026-07-29T06:51:20'
---
theorem divFamEps_eq_of_le_of_quotientData (F : DivFam C R π g)
    (x₁ : Grassmannian.grFunctorAff k
      (↥(Scheme.divisorSections k (windowM_choice π hπ g • fiberWeilDivisor π) ⊤)) g R)
    (x₂ : Grassmannian.grFunctorAff k
      (↥(Scheme.divisorSections k
        ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π) ⊤)) g R)
    (hproj₁ : Module.Projective R
      ((R ⊗[k] ↥(Scheme.divisorSections k
          (windowM_choice π hπ g • fiberWeilDivisor π) ⊤)) ⧸
        F.window (relThetaPairH1_windowM C π hπ g)))
    (hrank₁ : ∀ p : PrimeSpectrum R,
      Module.rankAtStalk
        ((R ⊗[k] ↥(Scheme.divisorSections k
            (windowM_choice π hπ g • fiberWeilDivisor π) ⊤)) ⧸
          F.window (relThetaPairH1_windowM C π hπ g)) p = g)
    (hproj₂ : Module.Projective R
      ((R ⊗[k] ↥(Scheme.divisorSections k
          ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π) ⊤)) ⧸
        F.window (relThetaPairH1_windowMS C π hπ g)))
    (hrank₂ : ∀ p : PrimeSpectrum R,
      Module.rankAtStalk
        ((R ⊗[k] ↥(Scheme.divisorSections k
            ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π) ⊤)) ⧸
          F.window (relThetaPairH1_windowMS C π hπ g)) p = g)
    (hle₁ : x₁.toSubmodule ≤ F.window (relThetaPairH1_windowM C π hπ g))
    (hle₂ : x₂.toSubmodule ≤ F.window (relThetaPairH1_windowMS C π hπ g)) :
    divFamEps hπ g F = (x₁.toSubmodule, x₂.toSubmodule) :=
  -- `divFamEps` is the pair of the two `DivFam.window`s BY DEFINITION (`divFamEps`,
  -- `Picard/DivisorFamilyWindow.lean`), so no `Quotient.ind` is needed: the two components
  -- are the two hypotheses' subjects on the nose.  Descending to a representative instead
  -- makes the window unfold through the section-ring algebra tower and blows the recursion
  -- limit -- measured, at exactly the two `Prod.ext` legs.
  Prod.ext
    (divisorWindowQuot_eq_of_le_of_quotientData F _ x₁ hproj₁ hrank₁ hle₁)
    (divisorWindowQuot_eq_of_le_of_quotientData F _ x₂ hproj₂ hrank₂ hle₂)