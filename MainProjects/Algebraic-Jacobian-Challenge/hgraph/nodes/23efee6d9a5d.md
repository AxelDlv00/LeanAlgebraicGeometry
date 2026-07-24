---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry._root_.Module.Flat.of_isPushout
docstring: '**Flatness under pushout base change** [Stacks 00HI, module form].  Let

  `B = S ⊗[R] A` be a pushout of rings (`Algebra.IsPushout R S A B`), `M` an

  `A`-module flat over `R`, and `N` a `B`-module which is a base change of `M`

  along `A → B` (`IsBaseChange B f`).  Then `N` is flat over `S` (acting through

  `S → B`).  Mathlib covers `A = R`, `B = S` (`Module.Flat.baseChange`); this

  mixed form is the per-piece engine of the flattening stratification.'
file: AlgebraicJacobian/Picard/GenericFlatnessGeometric.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry._root_.Module.Flat.of_isPushout
type: lean
updated: '2026-07-24T17:02:59'
---
theorem _root_.Module.Flat.of_isPushout [h : Algebra.IsPushout R S A B]
    {N : Type v} [AddCommGroup N] [Module A N] [Module B N] [Module S N]
    [IsScalarTower A B N] [IsScalarTower S B N]
    {f : M →ₗ[A] N} (hf : IsBaseChange B f) [Module.Flat R M] :
    Module.Flat S N := by
  haveI : Module.Flat S (B ⊗[A] M) :=
    Module.Flat.isBaseChange (R := R) (S := S) (M := M) (B ⊗[A] M)
      (isBaseChange_pushout_tensorProduct R S A B M)
  exact Module.Flat.of_linearEquiv (hf.equiv.restrictScalars S).symm

end FlatPushout

/-! ## §4. Affine pieces of a fibre-product square

For a cartesian square `H : IsPullback g iY iX f` (so `Y = X ×ₛ T` with
projections `g : Y ⟶ X`, `iY : Y ⟶ T` over `iX : X ⟶ S`, `f : T ⟶ S`) and
affine opens `US ⊆ S`, `UX ⊆ iX⁻¹US`, `UT ⊆ f⁻¹US`, the **piece**
`UY := g⁻¹UX ⊓ iY⁻¹UT ⊆ Y` is an affine open whose section ring is the
pushout `Γ(X,UX) ⊗_{Γ(S,US)} Γ(T,UT)` (Mathlib's
`isIso_pushoutSection_of_isAffineOpen`), and whose `F`-pullback sections are
the base change `Γ(Y,UY) ⊗_{Γ(X,UX)} Γ(F,UX)` (the Lane F section formula
`pullback_app_isoTensor_baseMap_sectionLinearEquiv`, Stacks 01HQ/01I8).
Combining the two with `Module.Flat.of_isPushout` (§3) transports flatness
of `Γ(F,UX)` over `Γ(S,US)` to flatness of the piece sections over
`Γ(T,UT)`; `Module.Finite.base_change` similarly transports finiteness over
the fibre ring.  These are the two per-piece inputs of the
flattening-stratification induction. -/

section PullbackPiece

open TensorProduct

variable {X Y S T : Scheme.{u}} {f : T ⟶ S} {g : Y ⟶ X} {iX : X ⟶ S} {iY : Y ⟶ T}
variable (H : IsPullback g iY iX f)
variable {US : S.Opens} {UT : T.Opens} {UX : X.Opens}
variable (hUST : UT ≤ f ⁻¹ᵁ US) (hUSX : UX ≤ iX ⁻¹ᵁ US)

include H hUST hUSX