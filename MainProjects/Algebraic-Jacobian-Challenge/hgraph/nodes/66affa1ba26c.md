---
author: sync
content_type: theorem
created: '2026-07-26T04:23:59'
decl: AlgebraicGeometry.Scheme.isConstantField_functionField
docstring: '**The structure field satisfies the adelic `IsConstantField` interface.**

  For an integral

  `k`-scheme `C` satisfying the `(*)`-hypotheses, with the structure-morphism

  algebra structure on `K(C)`, every nonzero constant `c ∈ k` has order `0` at

  every prime divisor: `c` is a unit in the field `k`, hence its image in each

  DVR stalk is a unit, and units have order `0`

  (`order_algebraMap_eq_zero_of_isUnit`).


  Audit verdict (see module docstring): TRUE at this generality — no properness,

  no `B0`/`HasTrivialConstants` input; this is the easy direction of the

  field-of-constants dialectic.'
file: AlgebraicJacobian/RiemannRoch/Adelic/GateInstances.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.isConstantField_functionField
type: lean
updated: '2026-07-26T04:23:59'
---
theorem isConstantField_functionField (C : Over (Spec (CommRingCat.of k)))
    [IsIntegral C.left] [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left] :
    Adelic.IsConstantField k C.left where
  order_algebraMap_eq_zero P c hc := by
    letI : Algebra ↥Γ(C.left, ⊤) (C.left.presheaf.stalk P.point) :=
      C.left.presheaf.algebra_section_stalk
        (⟨P.point, trivial⟩ : (⊤ : C.left.Opens))
    haveI : IsScalarTower ↥Γ(C.left, ⊤) (C.left.presheaf.stalk P.point)
        C.left.functionField :=
      functionField_isScalarTower C.left ⊤ ⟨P.point, trivial⟩
    have h1 : algebraMap k C.left.functionField c
        = algebraMap ↥Γ(C.left, ⊤) C.left.functionField ((constMap C).hom c) := rfl
    have hu : IsUnit (algebraMap ↥Γ(C.left, ⊤) (C.left.presheaf.stalk P.point)
        ((constMap C).hom c)) :=
      ((isUnit_iff_ne_zero.mpr hc).map (constMap C).hom).map _
    rw [h1, IsScalarTower.algebraMap_apply ↥Γ(C.left, ⊤)
      (C.left.presheaf.stalk P.point) C.left.functionField]
    exact Scheme.RationalMap.order_algebraMap_eq_zero_of_isUnit P hu

/-- Scoped instance form of `isConstantField_functionField`. -/
scoped instance instIsConstantField (C : Over (Spec (CommRingCat.of k)))
    [IsIntegral C.left] [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left] :
    Adelic.IsConstantField k C.left :=
  isConstantField_functionField C