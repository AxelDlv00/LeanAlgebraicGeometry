---
author: sync
content_type: definition
created: '2026-07-22T11:03:23'
decl: AlgebraicGeometry.divUniversalHighWindowSuccessorExponentFibreEquiv
docstring: Reindex a transported successor section space to the sum exponent.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowFibreNormalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowSuccessorExponentFibreEquiv
type: lean
updated: '2026-08-01T09:44:11'
---
noncomputable def divUniversalHighWindowSuccessorExponentFibreEquiv (n : Nat) :
    ↥(Scheme.divisorSections K
        (windowTransportDivisor C K pi exp[n + 1]) ⊤) ≃ₗ[K]
      ↥(Scheme.divisorSections K
        (windowTransportDivisor C K pi
          (windowS_choice pi hpi g + exp[n])) ⊤) :=
  LinearEquiv.ofEq _ _ (congrArg
    (fun m : Nat => Scheme.divisorSections K
      (windowTransportDivisor C K pi m) ⊤)
    (divUniversalHighWindowExponent_succ
      (C := C) (pi := pi) hpi g n).symm)