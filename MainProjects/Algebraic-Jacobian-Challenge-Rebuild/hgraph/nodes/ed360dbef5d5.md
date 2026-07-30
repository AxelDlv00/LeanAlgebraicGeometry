---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.pairAwayEquiv
docstring: 'The two-base localization identification of `S i ⊗[A] S j` with the section
  ring on

  the double basic open of the tensor square.'
file: AlgebraicJacobian/Picard/WitnessAway.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.pairAwayEquiv
type: lean
updated: '2026-07-30T15:46:07'
---
noncomputable def pairAwayEquiv (i j : P.ι) :
    letI := IsLocalization.Away.tensorAwayAlgebra A B B Γ(XB, (XB).basicOpen (P.r i))
      Γ(XB, (XB).basicOpen (P.r j))
    (Γ(XB, (XB).basicOpen (P.r i)) ⊗[A] Γ(XB, (XB).basicOpen (P.r j)))
      ≃ₐ[B ⊗[A] B] Γ(Sq, (Sq).basicOpen (pairSection P i j)) :=
  haveI := isLocalization_awayElt P i
  haveI := isLocalization_awayElt P j
  haveI : IsLocalization.Away
      ((awayElt P i ⊗ₜ[A] (1 : B)) * ((1 : B) ⊗ₜ[A] awayElt P j))
      Γ(Sq, (Sq).basicOpen (pairSection P i j)) := by
    have h := isLocalization_away_sections (B ⊗[A] B) (pairSection P i j)
    rwa [ΓSpecIso_hom_pairSection P i j] at h
  tensorAwayEquiv A B B (awayElt P i) (awayElt P j)
    Γ(XB, (XB).basicOpen (P.r i)) Γ(XB, (XB).basicOpen (P.r j))
    Γ(Sq, (Sq).basicOpen (pairSection P i j))

open IsLocalization.Away in