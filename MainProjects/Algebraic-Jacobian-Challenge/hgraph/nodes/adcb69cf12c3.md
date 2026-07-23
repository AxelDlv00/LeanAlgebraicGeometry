---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.serreTwistZeroEquivInt
docstring: '**`Γ(Proj ℤ[Xᵢ], O(0)) ≅ ℤ`**: the degree-zero global sections of the
  Serre twist

  are the constants (degree-zero forms `= ℤ`, via `homogeneousSubmodule … 0 = 1` and

  `C : ℤ ↪ ℤ[X]`).'
file: AlgebraicJacobian/Picard/SerreTwistSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.serreTwistZeroEquivInt
type: lean
updated: '2026-07-16T21:14:28'
---
def serreTwistZeroEquivInt [Nonempty n₀] : Γ(serreTwist n₀ 0, ⊤) ≃+ ℤ := by
  have hinj : Function.Injective
      (Algebra.linearMap (ULift.{0} ℤ) (MvPolynomial n₀ (ULift.{0} ℤ))) := fun a b h =>
    MvPolynomial.C_injective n₀ (ULift.{0} ℤ)
      (by simpa [Algebra.linearMap_apply, MvPolynomial.algebraMap_eq] using h)
  exact (formSectionEquiv 0).symm.trans
    (((LinearEquiv.ofEq _ _
          (MvPolynomial.homogeneousSubmodule_zero (σ := n₀) (R := ULift.{0} ℤ))).trans
        ((LinearEquiv.ofEq _ _ Submodule.one_eq_range).trans
          (LinearEquiv.ofInjective _ hinj).symm)).toAddEquiv.trans
      (ULift.ringEquiv (R := ℤ)).toAddEquiv)

end Bridge

/-! ## Local triviality, finite presentation and quasi-coherence of `O(m)` (P0.4)

The glued Serre twist, the twist on the integral model `Proj ℤ[X]`, and the
relative twisting sheaf on `ℙ(n₀; S)` are all **locally trivial line bundles**:
rank-one free on the trivialising basic-open charts.  On the affine chart
`opensRange (ι_i)` the chart restriction of the glued twist is the unit module
(`glueRestrictionIso`), so `serreTwistGlued` is locally trivial; local triviality
is stable under pullback (`IsLocallyTrivial.pullback`), so it descends along the
cover isomorphism to `serreTwist`, and along `toProjInt` to `twistingSheaf`.
Locally trivial line bundles are finitely presented
(`IsLocallyTrivial.isFinitePresentation`), hence quasi-coherent. -/

section LocallyTrivial

open AlgebraicGeometry.Scheme.LineBundle