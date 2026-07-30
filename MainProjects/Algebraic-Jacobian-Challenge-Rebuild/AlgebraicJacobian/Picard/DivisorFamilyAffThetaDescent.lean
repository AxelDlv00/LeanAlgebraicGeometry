/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffMapAlg
import AlgebraicJacobian.Picard.DivisorFamilyAffTheta
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaRestriction
import Mathlib.LinearAlgebra.TensorProduct.Quotient

/-!
# Intrinsic theta descent on a widened divisor cover

For an arbitrary affine piece `U_j`, the restriction of `O(a Theta)` to the divisor is
the genuine module

`Gamma(U_j, O(a Theta)) / (f_j) Gamma(U_j, O(a Theta))`.

Unlike the older chart-typed theta module, this quotient does not choose a trivialization
of the line bundle on `U_j`.  Restriction to `U_i inter U_j` sends the equation-generated
submodule into the symmetric overlap ideal, so the piece quotients have two canonical
overlap maps.  Their equalizer is the intrinsic theta restriction on the widened divisor.

The construction below supplies the module that the widened equalizer algebra acts on.
It is the chart-free input for proving invertibility and identifying the result with the
cover-independent high-window quotient.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite TopologicalSpace

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

section GluedQsmul

variable (B : Type u) [CommRing B] {X : Scheme.{u}} [X.Over (Spec (.of B))]
variable {J : Type u} (U : J -> X.Opens) (g : forall i j : J, Γ(X, U i ⊓ U j)ˣ)

/-- Componentwise multiplication is independent of whether a scalar is first restricted
to an intermediate open. -/
theorem gluedQsmul_res {V W Z : X.Opens} (hWV : W ≤ V) (hVZ : V ≤ Z)
    (r : Γ(X, Z)) (s : ↑(gluedSubmodule B U g W)) :
    gluedQsmul B U g hWV (X.resHom hVZ r) s =
      gluedQsmul B U g (hWV.trans hVZ) r s := by
  apply Subtype.ext
  funext j
  rw [gluedQsmul_coe, gluedQsmul_coe]
  simp only [Scheme.resHom_resHom]

end GluedQsmul

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π] [IsProper C.hom]
variable {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}

namespace AffAdaptation

/-- Intrinsic theta sections on the affine overlap of two widened pieces. -/
noncomputable abbrev ThetaOverlapSections (_A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) : Type u :=
  (thetaChartDatum C R π a).sheaf.obj.obj (op (D.pieces i ⊓ D.pieces j))

/-- A finite projective invertible sections model on a piece overlap.  Properness of the
curve makes the intersection of the two affine pieces affine. -/
noncomputable def thetaOverlapSectionsModel (_A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    (thetaChartDatum C R π a).AffineSectionsModel (D.pieces i ⊓ D.pieces j) :=
  Classical.choice ((thetaChartDatum C R π a).nonempty_affineSectionsModel
    (D.pieces i ⊓ D.pieces j) (D.hasAffineOverlaps_of_isProper i j))

/-- The overlap-ring action on intrinsic theta sections. -/
@[reducible]
noncomputable def thetaOverlapSectionsModule (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    Module Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
      (A.ThetaOverlapSections (π := π) a i j) :=
  letI : Scheme.QcohOn (thetaChartDatum C R π a).sheaf (D.pieces i ⊓ D.pieces j) :=
    (A.thetaOverlapSectionsModel (π := π) a i j).qcoh
  Scheme.QcohOn.moduleOfLE (F := (thetaChartDatum C R π a).sheaf)
    (le_refl (D.pieces i ⊓ D.pieces j))

attribute [local instance] thetaPieceSectionsModule thetaOverlapSectionsModule

/-- The equation-generated submodule of theta sections on one piece. -/
noncomputable def thetaPieceVanishing (A : AffAdaptation D d) (a : ℕ)
    (j : D.index) :
    letI : Module Γ(relCurve C R, D.pieces j)
      (A.ThetaPieceSections (π := π) a j) :=
    A.thetaPieceSectionsModule (π := π) a j
    Submodule Γ(relCurve C R, D.pieces j)
      (A.ThetaPieceSections (π := π) a j) :=
  Ideal.span {A.eqn j} • ⊤

/-- The symmetric overlap ideal acting on intrinsic theta sections. -/
noncomputable def thetaOverlapVanishing (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    letI : Module Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
      (A.ThetaOverlapSections (π := π) a i j) :=
    A.thetaOverlapSectionsModule (π := π) a i j
    Submodule Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
      (A.ThetaOverlapSections (π := π) a i j) :=
  A.ovlIdeal i j • ⊤

/-- Intrinsic theta sections restricted to the divisor on one widened piece. -/
noncomputable abbrev ThetaPieceQuotient (A : AffAdaptation D d) (a : ℕ)
    (j : D.index) : Type u :=
  letI : Module Γ(relCurve C R, D.pieces j)
      (A.ThetaPieceSections (π := π) a j) :=
    A.thetaPieceSectionsModule (π := π) a j
  A.ThetaPieceSections (π := π) a j ⧸ A.thetaPieceVanishing (π := π) a j

/-- Intrinsic theta sections modulo both equations on a piece overlap. -/
noncomputable abbrev ThetaOverlapQuotient (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) : Type u :=
  letI : Module Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
      (A.ThetaOverlapSections (π := π) a i j) :=
    A.thetaOverlapSectionsModule (π := π) a i j
  A.ThetaOverlapSections (π := π) a i j ⧸
    A.thetaOverlapVanishing (π := π) a i j

/-- The tensor restriction from the previous module is canonically the intrinsic quotient
by the local equation. -/
noncomputable def thetaPieceRestrictionEquiv (A : AffAdaptation D d) (a : ℕ)
    (j : D.index) :
    letI : Module Γ(relCurve C R, D.pieces j)
        (A.ThetaPieceSections (π := π) a j) :=
      A.thetaPieceSectionsModule (π := π) a j
    A.ThetaPieceRestriction (π := π) a j ≃ₗ[Γ(relCurve C R, D.pieces j)]
      A.ThetaPieceQuotient (π := π) a j :=
  TensorProduct.quotTensorEquivQuotSMul
    (A.ThetaPieceSections (π := π) a j) (Ideal.span {A.eqn j})

/-- Restriction of intrinsic theta sections from the left piece to an overlap. -/
noncomputable def thetaSectionsToOverlapLeft (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    letI : Module Γ(relCurve C R, D.pieces i)
        (A.ThetaPieceSections (π := π) a i) :=
      A.thetaPieceSectionsModule (π := π) a i
    letI : Module Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
        (A.ThetaOverlapSections (π := π) a i j) :=
      A.thetaOverlapSectionsModule (π := π) a i j
    A.ThetaPieceSections (π := π) a i →ₛₗ[
      (relResAlgHom C R (inf_le_left : D.pieces i ⊓ D.pieces j ≤ D.pieces i)).toRingHom]
      A.ThetaOverlapSections (π := π) a i j := by
  let Mi := A.thetaPieceSectionsModel (π := π) a i
  let Mij := A.thetaOverlapSectionsModel (π := π) a i j
  letI : Scheme.QcohOn (thetaChartDatum C R π a).sheaf (D.pieces i) := Mi.qcoh
  letI : Scheme.QcohOn (thetaChartDatum C R π a).sheaf
      (D.pieces i ⊓ D.pieces j) := Mij.qcoh
  refine
    { toFun := secRes (thetaChartDatum C R π a).sheaf inf_le_left
      map_add' := (secRes (thetaChartDatum C R π a).sheaf inf_le_left).map_add
      map_smul' := fun r s => ?_ }
  change
    secRes (thetaChartDatum C R π a).sheaf inf_le_left
        (Scheme.QcohOn.qsmul (F := (thetaChartDatum C R π a).sheaf)
          (le_refl (D.pieces i)) r s) =
      Scheme.QcohOn.qsmul (F := (thetaChartDatum C R π a).sheaf)
        (le_refl (D.pieces i ⊓ D.pieces j))
        ((relResAlgHom C R inf_le_left).toRingHom r)
        (secRes (thetaChartDatum C R π a).sheaf inf_le_left s)
  rw [Mi.qsmul_eq, Mij.qsmul_eq]
  exact (gluedRes_gluedQsmul R (thetaChartDatum C R π a).pieces
      (thetaChartDatum C R π a).unit inf_le_left (le_refl (D.pieces i)) r s).trans
    (gluedQsmul_res R (thetaChartDatum C R π a).pieces
      (thetaChartDatum C R π a).unit (le_refl (D.pieces i ⊓ D.pieces j))
      inf_le_left r (gluedRes R (thetaChartDatum C R π a).pieces
        (thetaChartDatum C R π a).unit inf_le_left s)).symm

/-- Restriction of intrinsic theta sections from the right piece to an overlap. -/
noncomputable def thetaSectionsToOverlapRight (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    letI : Module Γ(relCurve C R, D.pieces j)
        (A.ThetaPieceSections (π := π) a j) :=
      A.thetaPieceSectionsModule (π := π) a j
    letI : Module Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
        (A.ThetaOverlapSections (π := π) a i j) :=
      A.thetaOverlapSectionsModule (π := π) a i j
    A.ThetaPieceSections (π := π) a j →ₛₗ[
      (relResAlgHom C R (inf_le_right : D.pieces i ⊓ D.pieces j ≤ D.pieces j)).toRingHom]
      A.ThetaOverlapSections (π := π) a i j := by
  let Mj := A.thetaPieceSectionsModel (π := π) a j
  let Mij := A.thetaOverlapSectionsModel (π := π) a i j
  letI : Scheme.QcohOn (thetaChartDatum C R π a).sheaf (D.pieces j) := Mj.qcoh
  letI : Scheme.QcohOn (thetaChartDatum C R π a).sheaf
      (D.pieces i ⊓ D.pieces j) := Mij.qcoh
  refine
    { toFun := secRes (thetaChartDatum C R π a).sheaf inf_le_right
      map_add' := (secRes (thetaChartDatum C R π a).sheaf inf_le_right).map_add
      map_smul' := fun r s => ?_ }
  change
    secRes (thetaChartDatum C R π a).sheaf inf_le_right
        (Scheme.QcohOn.qsmul (F := (thetaChartDatum C R π a).sheaf)
          (le_refl (D.pieces j)) r s) =
      Scheme.QcohOn.qsmul (F := (thetaChartDatum C R π a).sheaf)
        (le_refl (D.pieces i ⊓ D.pieces j))
        ((relResAlgHom C R inf_le_right).toRingHom r)
        (secRes (thetaChartDatum C R π a).sheaf inf_le_right s)
  rw [Mj.qsmul_eq, Mij.qsmul_eq]
  exact (gluedRes_gluedQsmul R (thetaChartDatum C R π a).pieces
      (thetaChartDatum C R π a).unit inf_le_right (le_refl (D.pieces j)) r s).trans
    (gluedQsmul_res R (thetaChartDatum C R π a).pieces
      (thetaChartDatum C R π a).unit (le_refl (D.pieces i ⊓ D.pieces j))
      inf_le_right r (gluedRes R (thetaChartDatum C R π a).pieces
        (thetaChartDatum C R π a).unit inf_le_right s)).symm

/-- The left restriction sends equation multiples into the symmetric overlap ideal. -/
theorem thetaSectionsToOverlapLeft_vanishing_le (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    A.thetaPieceVanishing (π := π) a i ≤
      Submodule.comap (A.thetaSectionsToOverlapLeft (π := π) a i j)
        (A.thetaOverlapVanishing (π := π) a i j) := by
  change Ideal.span {A.eqn i} •
      (⊤ : Submodule Γ(relCurve C R, D.pieces i) (A.ThetaPieceSections (π := π) a i)) ≤
    Submodule.comap (A.thetaSectionsToOverlapLeft (π := π) a i j)
      (A.ovlIdeal i j •
        (⊤ : Submodule Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
          (A.ThetaOverlapSections (π := π) a i j)))
  rw [Submodule.smul_le]
  intro r hr s _
  change A.thetaSectionsToOverlapLeft (π := π) a i j (r • s) ∈
    A.ovlIdeal i j •
      (⊤ : Submodule Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
        (A.ThetaOverlapSections (π := π) a i j))
  rw [(A.thetaSectionsToOverlapLeft (π := π) a i j).map_smulₛₗ]
  apply Submodule.smul_mem_smul ?_ Submodule.mem_top
  rw [Ideal.mem_span_singleton] at hr
  obtain ⟨c, rfl⟩ := hr
  rw [map_mul]
  exact Ideal.mul_mem_right _ _ (Ideal.subset_span (Set.mem_insert _ _))

/-- The right restriction sends equation multiples into the symmetric overlap ideal. -/
theorem thetaSectionsToOverlapRight_vanishing_le (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    A.thetaPieceVanishing (π := π) a j ≤
      Submodule.comap (A.thetaSectionsToOverlapRight (π := π) a i j)
        (A.thetaOverlapVanishing (π := π) a i j) := by
  change Ideal.span {A.eqn j} •
      (⊤ : Submodule Γ(relCurve C R, D.pieces j) (A.ThetaPieceSections (π := π) a j)) ≤
    Submodule.comap (A.thetaSectionsToOverlapRight (π := π) a i j)
      (A.ovlIdeal i j •
        (⊤ : Submodule Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
          (A.ThetaOverlapSections (π := π) a i j)))
  rw [Submodule.smul_le]
  intro r hr s _
  change A.thetaSectionsToOverlapRight (π := π) a i j (r • s) ∈
    A.ovlIdeal i j •
      (⊤ : Submodule Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
        (A.ThetaOverlapSections (π := π) a i j))
  rw [(A.thetaSectionsToOverlapRight (π := π) a i j).map_smulₛₗ]
  apply Submodule.smul_mem_smul ?_ Submodule.mem_top
  rw [Ideal.mem_span_singleton] at hr
  obtain ⟨c, rfl⟩ := hr
  rw [map_mul]
  exact Ideal.mul_mem_right _ _ (Ideal.subset_span (Set.mem_insert_of_mem _ rfl))

/-- The induced left overlap map on divisor-restricted theta sections. -/
noncomputable def thetaToOverlapLeft (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    A.ThetaPieceQuotient (π := π) a i →ₛₗ[
      (relResAlgHom C R (inf_le_left : D.pieces i ⊓ D.pieces j ≤ D.pieces i)).toRingHom]
      A.ThetaOverlapQuotient (π := π) a i j :=
  Submodule.mapQ (A.thetaPieceVanishing (π := π) a i)
    (A.thetaOverlapVanishing (π := π) a i j)
    (A.thetaSectionsToOverlapLeft (π := π) a i j)
    (A.thetaSectionsToOverlapLeft_vanishing_le (π := π) a i j)

/-- The induced right overlap map on divisor-restricted theta sections. -/
noncomputable def thetaToOverlapRight (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) :
    A.ThetaPieceQuotient (π := π) a j →ₛₗ[
      (relResAlgHom C R (inf_le_right : D.pieces i ⊓ D.pieces j ≤ D.pieces j)).toRingHom]
      A.ThetaOverlapQuotient (π := π) a i j :=
  Submodule.mapQ (A.thetaPieceVanishing (π := π) a j)
    (A.thetaOverlapVanishing (π := π) a i j)
    (A.thetaSectionsToOverlapRight (π := π) a i j)
    (A.thetaSectionsToOverlapRight_vanishing_le (π := π) a i j)

end AffAdaptation

end AlgebraicGeometry
