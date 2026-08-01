/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaOverlapBaseChange

/-!
# Product base change for intrinsic theta modules

The pairwise theta restrictions are base changes along the two maps from a piece colength
algebra to an overlap colength algebra.  Together with the tensor-square identification of
the finite affine divisor cover, this assembles into the comparison

`chartProd ⊗[gluedSubalgebra] ThetaPieceProd ≃ ThetaOverlapProd`.

The comparison is the Cech module interface consumed by faithful-flat descent.  It is stated
for an arbitrary certified affine adaptation and introduces no containment, chart-typing, or
additional hypothesis.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Opposite TopologicalSpace
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π] [IsProper C.hom]
variable {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}

namespace AffAdaptation

attribute [local instance] thetaPieceQuotientModule thetaOverlapQuotientModule
  thetaPieceQuotientGluedModule thetaOverlapQuotientGluedModule

noncomputable section

variable (A : AffAdaptation D d) (a : ℕ)

local notation "B" => A.chartProd
local notation "M" => A.ThetaPieceProd (π := π) a
local notation "Q" => A.ThetaOverlapProd (π := π) a

/- The chart algebra acts on a piece through its coordinate projection. -/
local instance pieceChartModule (j : D.index) : Module B
    (A.ThetaPieceQuotient (π := π) a j) :=
  letI : Module (A.colength j)
      (A.ThetaPieceQuotient (π := π) a j) :=
    A.thetaPieceQuotientModule (π := π) a j
  Module.compHom _ (Pi.evalRingHom (fun j : D.index => A.colength j) j)

local instance overlapChartModule (i j : D.index) : Module B
    (A.ThetaOverlapQuotient (π := π) a i j) :=
  letI : Module (A.ovlColength i j)
      (A.ThetaOverlapQuotient (π := π) a i j) :=
    A.thetaOverlapQuotientModule (π := π) a i j
  Module.compHom _ ((A.toOvlLeft i j).comp
    (Pi.evalAlgHom R (fun j : D.index => A.colength j) i)).toRingHom

local instance pieceProdChartModule : Module B M :=
  Pi.module D.index (fun j => A.ThetaPieceQuotient (π := π) a j) B

local instance overlapProdChartModule : Module B Q :=
  Pi.module (D.index × D.index)
    (fun p => A.ThetaOverlapQuotient (π := π) a p.1 p.2) B

local instance pieceADModule (j : D.index) : Module (↥(gluedSubalgebra A))
    (A.ThetaPieceQuotient (π := π) a j) :=
  A.thetaPieceQuotientGluedModule (π := π) a j

local instance pieceProdADModule : Module (↥(gluedSubalgebra A)) M :=
  Pi.module D.index (fun j => A.ThetaPieceQuotient (π := π) a j)
    (↥(gluedSubalgebra A))

local instance chartOverGlued : Algebra (↥(gluedSubalgebra A)) B :=
  Subalgebra.toAlgebra (gluedSubalgebra A)

local instance pieceAlgebra (i : D.index) : Algebra (↥(gluedSubalgebra A))
    (A.colength i) := A.gluedSubalgebraPieceMap i |>.toRingHom.toAlgebra

local instance overlapLeftAlgebra (i j : D.index) : Algebra (↥(gluedSubalgebra A))
    (A.ovlColength i j) :=
  ((A.toOvlLeft i j).comp (A.gluedSubalgebraPieceMap i)).toRingHom.toAlgebra

local instance overlapRightAlgebra (i j : D.index) : Algebra (A.colength j)
    (A.ovlColength i j) :=
  (A.toOvlRight i j).toRingHom.toAlgebra

local instance overlapRightTower (i j : D.index) : IsScalarTower
    (↥(gluedSubalgebra A)) (A.colength j) (A.ovlColength i j) := by
  constructor
  intro c x
  change A.toOvlRight i j (c.1 j * x) =
    A.toOvlRight i j (c.1 j) * A.toOvlRight i j x
  rw [map_mul]

local instance pieceTower (j : D.index) : IsScalarTower
    (↥(gluedSubalgebra A)) (A.colength j)
      (A.ThetaPieceQuotient (π := π) a j) := by
  constructor
  intro c x
  rfl

local instance overlapLeftTower (i j : D.index) : IsScalarTower
    (↥(gluedSubalgebra A)) (A.colength i) (A.ovlColength i j) := by
  constructor
  intro c x
  change A.toOvlLeft i j (c.1 i * x) =
    A.toOvlLeft i j (c.1 i) * A.toOvlLeft i j x
  rw [map_mul]

local instance pushout {n : ℕ} (hc : A.IsCertified n) (i j : D.index) :
    Algebra.IsPushout (↥(gluedSubalgebra A)) (A.colength i) (A.colength j)
      (A.ovlColength i j) := hc.isPushout_gluedSubalgebraPieceMaps A i j

/- The coordinate comparison uses the right restriction after cancelling the pushout base. -/
noncomputable def thetaPieceBaseChangeToOverlapCoord {n : ℕ}
    (hc : A.IsCertified n) (i j : D.index) :
    A.colength i ⊗[↥(gluedSubalgebra A)]
        A.ThetaPieceQuotient (π := π) a j ≃ₗ[A.colength i]
      A.ThetaOverlapQuotient (π := π) a i j := by
  let e := (Algebra.IsPushout.cancelBaseChange
    (↥(gluedSubalgebra A)) (A.colength i) (A.colength j)
      (A.ovlColength i j)
      (A.ThetaPieceQuotient (π := π) a j)).symm
  exact e.trans (A.thetaPieceBaseChangeToOverlapRightEquiv (π := π) a i j)

local instance overlapADModule (i j : D.index) : Module (↥(gluedSubalgebra A))
    (A.ThetaOverlapQuotient (π := π) a i j) :=
  A.thetaOverlapQuotientGluedModule (π := π) a i j

local instance overlapNestedADModule : Module (↥(gluedSubalgebra A))
    (∀ j : D.index, ∀ i : D.index,
      A.ThetaOverlapQuotient (π := π) a i j) :=
  Pi.module D.index (fun j => ∀ i : D.index,
    A.ThetaOverlapQuotient (π := π) a i j) (↥(gluedSubalgebra A))

local instance overlapPairADModule : Module (↥(gluedSubalgebra A)) Q :=
  Pi.module (D.index × D.index)
    (fun p => A.ThetaOverlapQuotient (π := π) a p.1 p.2)
    (↥(gluedSubalgebra A))

noncomputable def thetaOverlapProdSwapEquiv :
    (∀ j : D.index, ∀ i : D.index,
      A.ThetaOverlapQuotient (π := π) a i j) ≃ₗ[↥(gluedSubalgebra A)] Q := by
  let f : (∀ j : D.index, ∀ i : D.index,
      A.ThetaOverlapQuotient (π := π) a i j) →ₗ[↥(gluedSubalgebra A)] Q :=
    { toFun := fun x p => x p.2 p.1
      map_add' := by intros x y; funext p; simp
      map_smul' := by intros c x; funext p; simp }
  let g : Q →ₗ[↥(gluedSubalgebra A)]
      (∀ j : D.index, ∀ i : D.index,
        A.ThetaOverlapQuotient (π := π) a i j) :=
    { toFun := fun x j i => x (i, j)
      map_add' := by intros x y; funext j i; simp
      map_smul' := by intros c x; funext j i; simp }
  exact LinearEquiv.ofLinear f g (by ext x j i <;> rfl) (by ext x p <;> rfl)

noncomputable def thetaPieceProdBaseChangeNestedEquiv {n : ℕ}
    (hc : A.IsCertified n) :
    (∀ j : D.index, A.chartProd ⊗[↥(gluedSubalgebra A)]
      A.ThetaPieceQuotient (π := π) a j) ≃ₗ[↥(gluedSubalgebra A)]
      (∀ j : D.index, ∀ i : D.index,
        A.ThetaOverlapQuotient (π := π) a i j) := by
  let e := LinearEquiv.piCongrRight (fun j =>
    (Module.piBaseChangeDistrib
      (A := (↥(gluedSubalgebra A)))
      (S := fun i : D.index => A.colength i)
      (N := A.ThetaPieceQuotient (π := π) a j)).trans
      (LinearEquiv.piCongrRight (fun i =>
        thetaPieceBaseChangeToOverlapCoord A a hc i j)))
  exact e

/-- The Cech module comparison from the tensor square of the chart algebra. -/
noncomputable def thetaPieceProdBaseChangeToOverlapEquiv {n : ℕ}
    (hc : A.IsCertified n) :
    A.chartProd ⊗[↥(gluedSubalgebra A)]
      A.ThetaPieceProd (π := π) a ≃ₗ[A.chartProd]
      A.ThetaOverlapProd (π := π) a := by
  let e0 := TensorProduct.piRight
    (↥(gluedSubalgebra A)) A.chartProd A.chartProd
    (fun j : D.index => A.ThetaPieceQuotient (π := π) a j)
  let e1 : A.chartProd ⊗[↥(gluedSubalgebra A)]
      A.ThetaPieceProd (π := π) a ≃ₗ[↥(gluedSubalgebra A)]
      (∀ j : D.index, A.chartProd ⊗[↥(gluedSubalgebra A)]
        A.ThetaPieceQuotient (π := π) a j) :=
    e0.restrictScalars (↥(gluedSubalgebra A))
  let e2 := thetaPieceProdBaseChangeNestedEquiv A a hc
  let e3 := thetaOverlapProdSwapEquiv A a
  exact (e1.trans e2).trans e3 |>.restrictScalars A.chartProd

@[simp]
theorem thetaPieceProdBaseChangeToOverlapEquiv_tmul {n : ℕ}
    (hc : A.IsCertified n) (x : A.chartProd)
    (s : A.ThetaPieceProd (π := π) a) (p : D.index × D.index) :
    A.thetaPieceProdBaseChangeToOverlapEquiv (π := π) a hc (x ⊗ₜ s) p =
      A.toOvlLeft p.1 p.2 (x p.1) *
        A.thetaToOverlapRight (π := π) a p.1 p.2 (s p.2) := by
  simp only [thetaPieceProdBaseChangeToOverlapEquiv,
    LinearEquiv.restrictScalars_apply, LinearEquiv.trans_apply,
    thetaOverlapProdSwapEquiv, LinearEquiv.ofLinear_apply,
    thetaPieceProdBaseChangeNestedEquiv,
    LinearEquiv.piCongrRight_apply, TensorProduct.piRight_symm_apply,
    Module.piBaseChangeDistrib_tmul, thetaPieceBaseChangeToOverlapCoord,
    LinearEquiv.trans_apply,
    Algebra.IsPushout.cancelBaseChange_symm_tmul,
    thetaPieceBaseChangeToOverlapRightEquiv_tmul, Algebra.smul_def]
  rfl

/- The right Cech arrow after tensoring is the comparison above. -/
noncomputable def thetaIntrinsicDeltaRightBaseChange {n : ℕ}
    (hc : A.IsCertified n) :
    A.chartProd ⊗[↥(gluedSubalgebra A)]
      A.ThetaPieceProd (π := π) a →ₗ[A.chartProd]
      A.ThetaOverlapProd (π := π) a :=
  LinearMap.liftBaseChange A.chartProd
    (A.thetaIntrinsicDeltaRightGlued (π := π) a)

theorem thetaIntrinsicDeltaRightBaseChange_eq_comparison {n : ℕ}
    (hc : A.IsCertified n) :
    A.thetaIntrinsicDeltaRightBaseChange (π := π) a hc =
      (A.thetaPieceProdBaseChangeToOverlapEquiv (π := π) a hc).toLinearMap := by
  apply TensorProduct.ext'
  intro x s
  funext p
  rw [thetaIntrinsicDeltaRightBaseChange, LinearMap.liftBaseChange_tmul,
    thetaIntrinsicDeltaRightGlued, LinearMap.pi_apply, LinearMap.coe_comp,
    Function.comp_apply, LinearMap.proj_apply,
    Algebra.smul_def, thetaPieceProdBaseChangeToOverlapEquiv_tmul]
  rfl

theorem thetaIntrinsicDeltaRightBaseChange_bijective {n : ℕ}
    (hc : A.IsCertified n) :
    Function.Bijective (A.thetaIntrinsicDeltaRightBaseChange (π := π) a hc) := by
  rw [A.thetaIntrinsicDeltaRightBaseChange_eq_comparison (π := π) a hc]
  exact (A.thetaPieceProdBaseChangeToOverlapEquiv (π := π) a hc).bijective

end

end AffAdaptation

end AlgebraicGeometry
