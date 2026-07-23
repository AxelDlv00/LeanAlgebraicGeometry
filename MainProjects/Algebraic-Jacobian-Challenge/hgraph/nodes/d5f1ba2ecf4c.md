---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.pairLift
docstring: The pair lift `Γ(𝒰₀) × Γ(𝒰₁) ⟶ Č⁰`.
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.pairLift
type: lean
updated: '2026-07-16T21:14:28'
---
noncomputable def AffineCoverMVSquare.pairLift :
    ModuleCat.of k
        (F.obj.obj (op (S.coverFamily ⟨0⟩)) × F.obj.obj (op (S.coverFamily ⟨1⟩)))
      ⟶ ∏ᶜ (cechTerm S.coverFamily F 1) :=
  Pi.lift (S.pairComponent F)

@[reassoc]