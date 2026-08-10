/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.Pic0RankOneLocusNative
import AlgebraicJacobian.Cohomology.GluedSheafH0BaseChange

/-!
# Degree-zero sections of the native rank-one module under coefficient change

The glued datum already carries an unconditional ring-map equivalence on `H⁰`.
This file transports that equivalence through `BasicOpenCocycleDatum.nativeModuleKSheafIso`,
so the native `Scheme.Modules` object exposes the same comparison on its actual sections.
The resulting map is an algebraic input to the canonical base-change mate; it does not assume
that the mate itself is an isomorphism.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open scoped TensorProduct

namespace AlgebraicGeometry

variable {k : Type u} [Field k]
variable {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]

namespace BasicOpenCocycleDatum

noncomputable section

variable (D : BasicOpenCocycleDatum C B pi)

local instance nativeSectionsModule (U : (relCurve C B).Opens) :
    Module B Γ(D.nativeModule, U) :=
  Scheme.moduleKSections
    (Over.mk (relCurve C B ↘ Spec (.of B))) D.nativeModule U

/-- Degree-zero datum cohomology, viewed as native-module sections. -/
noncomputable def nativeH0SectionsEquiv :
    Sheaf.HModule D.sheaf 0 ≃ₗ[B] Γ(D.nativeModule, ⊤) :=
  (Sheaf.HModule.linearEquiv₀
      (Opens.grothendieckTopology ((relCurve C B : Scheme.{u}) : TopCat))
      isTerminalTop D.sheaf).trans
    (D.nativeModuleKSectionsEquiv (⊤ : (relCurve C B).Opens)).symm

variable (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B']
  [IsScalarTower k B B']

local instance nativeSectionsModuleBaseChange (U : (relCurve C B').Opens) :
    Module B' Γ((D.baseChange B').nativeModule, U) :=
  Scheme.moduleKSections
    (Over.mk (relCurve C B' ↘ Spec (.of B'))) (D.baseChange B').nativeModule U

/-- The native degree-zero base-change equivalence, obtained by transport from
`datumH0BaseChange`; no `IsIso` statement is used as an input. -/
noncomputable def nativeH0BaseChange
    (hH1 : Subsingleton (datumPair D).H1) :
    B' ⊗[B] Γ(D.nativeModule, ⊤) ≃ₗ[B']
      Γ((D.baseChange B').nativeModule, ⊤) :=
  ((D.nativeH0SectionsEquiv).symm.lTensor B').trans
    ((D.datumH0BaseChange B' hH1).trans
      ((D.baseChange B').nativeH0SectionsEquiv B').symm)

@[simp]
lemma nativeH0BaseChange_one_tmul
    (hH1 : Subsingleton (datumPair D).H1) (x : Γ(D.nativeModule, ⊤)) :
    D.nativeH0BaseChange B' hH1 (1 ⊗ₜ[B] x) =
      ((D.baseChange B').nativeH0SectionsEquiv B')
        (D.datumH0BaseChange B' hH1
          (1 ⊗ₜ[B] (D.nativeH0SectionsEquiv).symm x)) := by
  rfl

end

end BasicOpenCocycleDatum

end AlgebraicGeometry
