---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.transitionSectionsBaseChange
docstring: '**Base change of sections along the base-field transition** (SB-2, brick),
  as a ring

  equivalence: `Γ(C_{K₁}, V) ⊗[K₁] K₂ ≃+* Γ(C_{K₂}, π ⁻¹ᵁ V)` for an affine open `V`.
  On a pure

  tensor `s ⊗ a` it is the product of the pullback of `s` along `π` and the pullback
  of `a`

  along the second projection (`transitionSectionsBaseChange_tmul`). The `K₁`-algebra
  structure

  on `Γ(C_{K₁}, V)` is the second-projection `baseChangeSectionsAlgebra`.'
file: AlgebraicJacobian/Cohomology/TransitionSectionsBaseChange.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.transitionSectionsBaseChange
type: lean
updated: '2026-07-29T15:26:14'
---
noncomputable def Over.transitionSectionsBaseChange {V : (C ⊗ overSpec k K₁).left.Opens}
    (hV : IsAffineOpen V) :
    Γ((C ⊗ overSpec k K₁).left, V) ⊗[K₁] K₂ ≃+*
      Γ((C ⊗ overSpec k K₂).left,
        (C ◁ Over.overSpecMap (IsScalarTower.toAlgHom k K₁ K₂)).left ⁻¹ᵁ V) :=
  (Over.transitionSectionsBaseChangeIso C hV).commRingCatIsoToRingEquiv