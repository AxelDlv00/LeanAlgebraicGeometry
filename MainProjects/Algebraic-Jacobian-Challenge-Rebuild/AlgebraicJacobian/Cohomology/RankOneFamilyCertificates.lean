/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Cohomology.DatumDescent
import AlgebraicJacobian.Cohomology.GluedSheafDatumFibre
import AlgebraicJacobian.Cohomology.GluedSheafH0BaseChange
import AlgebraicJacobian.Picard.DivisorDatumRankOne
import AlgebraicJacobian.Picard.Pic0ChartLocusFibreField

/-!
# Descent-backed rank-one certificates for a tied cocycle datum

This file is the cohomological half of the native family contract.  A certificate is attached to
the displayed `BasicOpenCocycleDatum` and its displayed affine representative; it is never a
certificate for a separately chosen module.  The only geometric input is the fibre witness
condition (the mapped Čech class has a divisor with vanishing `H¹`), from which the datum
dictionary and the rigid engine derive the three cohomological conclusions.

The descent stage is essential: arbitrary coefficient rings need not be Noetherian.  We descend
the finite cocycle datum to a finitely generated subalgebra, fire the engine there, and transport
`H¹`, finite projectivity, and stalk rank through the on-the-nose datum H⁰ base-change
equivalence.  Thus the public conclusions are genuinely arbitrary-affine, while the only
Noetherian instance is local to the constructed stage.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite MonoidalCategory
  CartesianMonoidalCategory
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {pi : C.left ⟶ P1 k} [IsFinite pi]

variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

/-! ## The actual fibre antecedent -/

/-- A field-parametrised vanishing witness for the *displayed* cocycle datum.

This is deliberately an abbreviation for the landed `HasWitnessH1Vanishing` predicate.  In
particular its divisor has the class of this datum's cocycle; it cannot be replaced by a witness
for an unrelated module or class.  The stage constructor below asks for this predicate on its
finitely generated descent datum, where every stage residue field is an admissible coefficient
extension. -/
abbrev BasicOpenCocycleDatum.FibreH1Witness
    (D : BasicOpenCocycleDatum C B pi) : Prop :=
  ∀ (L : Type u) [Field L] [Algebra k L] [Algebra B L]
    [IsScalarTower k B L], D.HasWitnessH1Vanishing L

namespace BasicOpenCocycleDatum

/-- The fibre witness is converted through the landed two-way datum dictionary. -/
theorem subsingleton_pairH1_tensor_of_fibreWitness
    (D : BasicOpenCocycleDatum C B pi) (hW : D.FibreH1Witness)
    (L : Type u) [Field L] [Algebra k L] [Algebra B L]
    [IsScalarTower k B L] :
    Subsingleton ((datumPair D).H1 ⊗[B] L) :=
  (D.hasWitnessH1Vanishing_iff_subsingleton L).mp (hW L)

end BasicOpenCocycleDatum

/-! ## The certificate object -/

/-- The four cohomological certificates consumed by the native presentation.

Every module in this structure is the H-module of the same `D.sheaf`; no native or unrelated
module can be substituted. -/
structure RankOneFamilyCertificates
    (D : BasicOpenCocycleDatum C B pi) : Prop where
  h1_vanishing : Subsingleton (Sheaf.HModule D.sheaf 1)
  h0_finite : Module.Finite B (Sheaf.HModule D.sheaf 0)
  h0_projective : Module.Projective B (Sheaf.HModule D.sheaf 0)
  h0_rank_one : ∀ p : PrimeSpectrum B,
    Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p = 1

namespace RankOneFamilyCertificates

variable {D : BasicOpenCocycleDatum C B pi}

/- The standard base-change geometry is keyed by the structure morphism supplied by
`relCurve.instOver`; re-key it locally so the rank theorem sees the same `Over` object. -/
noncomputable local instance (priority := 20000) rankOneCertificateOver
    (L : Type u) [Field L] [Algebra k L] :
    (relCurve C L).Over (Spec (.of L)) :=
  instOverBaseChange C L

noncomputable local instance rankOneCertificateSmooth
    (L : Type u) [Field L] [Algebra k L] :
    SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (.of L)) :=
  instSmoothOfRelativeDimensionBaseChange C L

noncomputable local instance rankOneCertificateIntegral
    (L : Type u) [Field L] [Algebra k L] :
    IsIntegral (relCurve C L) :=
  instIsIntegralBaseChange C L

noncomputable local instance rankOneCertificateQuasiCompact
    (L : Type u) [Field L] [Algebra k L] :
    QuasiCompact (relCurve C L ↘ Spec (.of L)) :=
  instQuasiCompactBaseChange C L

noncomputable local instance rankOneCertificateFiniteH0
    (L : Type u) [Field L] [Algebra k L] :
    Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0) :=
  instModuleFiniteHModuleZeroBaseChange C L

noncomputable local instance rankOneCertificateFiniteH1
    (L : Type u) [Field L] [Algebra k L] :
    Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1) :=
  instModuleFiniteHModuleOneBaseChange C L

/-! ## Canonical scalar extension -/

/-- The canonical H⁰ equivalence attached to a certificate. -/
noncomputable def h0BaseChange
    (P : RankOneFamilyCertificates D)
    (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B']
    [IsScalarTower k B B'] :
    B' ⊗[B] (Sheaf.HModule D.sheaf 0) ≃ₗ[B']
      Sheaf.HModule (D.baseChange B').sheaf 0 := by
  exact D.datumH0BaseChange B' ((subsingleton_datumPair_h1_iff D).mpr P.h1_vanishing)

/-- H¹ vanishing is preserved by the same canonical coefficient extension. -/
theorem h1_baseChange
    (P : RankOneFamilyCertificates D)
    (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B']
    [IsScalarTower k B B'] :
    Subsingleton (Sheaf.HModule (D.baseChange B').sheaf 1) :=
  D.datum_subsingleton_h1_baseChange B'
    ((subsingleton_datumPair_h1_iff D).mpr P.h1_vanishing)

/- The finite/projective instances for a tensor product are installed in the next constructor,
   where they are used to transport the package's source module along `h0BaseChange`. -/

/-- Scalar extension transports all four certificates, with the target still `D.baseChange`. -/
noncomputable def scalarExtension
    (P : RankOneFamilyCertificates D)
    (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B']
    [IsScalarTower k B B'] :
    RankOneFamilyCertificates (D.baseChange B') := by
  let Q := Sheaf.HModule D.sheaf 0
  letI : Module.Finite B Q := P.h0_finite
  letI : Module.Projective B Q := P.h0_projective
  let e : B' ⊗[B] Q ≃ₗ[B']
      Sheaf.HModule (D.baseChange B').sheaf 0 := P.h0BaseChange B'
  letI : Module.Finite B' (B' ⊗[B] Q) := by infer_instance
  letI : Module.Projective B' (B' ⊗[B] Q) := by infer_instance
  refine {
    h1_vanishing := P.h1_baseChange B'
    h0_finite := Module.Finite.equiv e
    h0_projective := Module.Projective.of_equiv e
    h0_rank_one := ?_ }
  intro p
  rw [← Module.rankAtStalk_eq_of_equiv e, Module.rankAtStalk_baseChange]
  exact P.h0_rank_one (p.comap (algebraMap B B'))

/-! ## The arbitrary-ring constructor -/

/-- Construct the certificate package after a genuine finitely generated descent stage.

`hfib` is the fibre-divisor/H¹ antecedent at the stage and `hdegree` is the corresponding
class-degree calculation.  Neither field mentions the desired H¹/H⁰/rank conclusions.  The
Noetherian instance is created only for `B₀`; the result is over the original, unrestricted
ring `B` by the canonical datum base-change equivalence. -/
noncomputable def of_descent_stage
    {B₀ : Subalgebra k B} (hfg : B₀.FG)
    (D₀ : BasicOpenCocycleDatum C (↥B₀) pi)
    (hbc : D₀.baseChange (B' := B) = D)
    (hπ : pi ≫ P1.structureMap k = C.hom)
    (hW₀ : D₀.FibreH1Witness)
    (hdegree : ∀ p : PrimeSpectrum (↥B₀),
      classDeg p.asIdeal.ResidueField
        (D₀.baseChange p.asIdeal.ResidueField).cechPicClass = (genus C : ℤ)) :
    RankOneFamilyCertificates D := by
  subst D
  letI : IsNoetherianRing (↥B₀) := hfg.isNoetherianRing
  have hfib : ∀ p : PrimeSpectrum (↥B₀),
      Subsingleton ((datumPair D₀).H1 ⊗[↥B₀] p.asIdeal.ResidueField) := by
    intro p
    exact D₀.subsingleton_pairH1_tensor_of_fibreWitness hW₀
      p.asIdeal.ResidueField
  obtain ⟨-, hfin₀, hproj₀⟩ := datumRigidEngine D₀ hπ hfib
  have hpair₀ : Subsingleton (datumPair D₀).H1 :=
    datum_subsingleton_pairH1 D₀ hπ hfib
  have hrank₀ : ∀ p : PrimeSpectrum (↥B₀),
      Module.rankAtStalk (Sheaf.HModule D₀.sheaf 0) p = 1 := by
    intro p
    haveI : IsIntegral (relCurve C p.asIdeal.ResidueField) :=
      instIsIntegralBaseChange C p.asIdeal.ResidueField
    haveI : SmoothOfRelativeDimension 1
        (relCurve C p.asIdeal.ResidueField ↘
          Spec (CommRingCat.of p.asIdeal.ResidueField)) :=
      instSmoothOfRelativeDimensionBaseChange C p.asIdeal.ResidueField
    haveI : QuasiCompact
        (relCurve C p.asIdeal.ResidueField ↘
          Spec (CommRingCat.of p.asIdeal.ResidueField)) :=
      instQuasiCompactBaseChange C p.asIdeal.ResidueField
    haveI : Module.Finite p.asIdeal.ResidueField
        (Sheaf.HModule
          ((relCurve C p.asIdeal.ResidueField).moduleKSheaf p.asIdeal.ResidueField) 0) :=
      instModuleFiniteHModuleZeroBaseChange C p.asIdeal.ResidueField
    haveI : Module.Finite p.asIdeal.ResidueField
        (Sheaf.HModule
          ((relCurve C p.asIdeal.ResidueField).moduleKSheaf p.asIdeal.ResidueField) 1) :=
      instModuleFiniteHModuleOneBaseChange C p.asIdeal.ResidueField
    exact BasicOpenCocycleDatum.rankAtStalk_hModule_zero_eq_one D₀ (n := genus C) hπ
      (chi_moduleKSheaf C) hfib p (hdegree p)
  let Q := Sheaf.HModule D₀.sheaf 0
  letI : Module.Finite (↥B₀) Q := hfin₀
  letI : Module.Projective (↥B₀) Q := hproj₀
  let e : B ⊗[↥B₀] Q ≃ₗ[B]
      Sheaf.HModule (D₀.baseChange (B' := B)).sheaf 0 :=
    D₀.datumH0BaseChange B hpair₀
  letI : Module.Finite B (B ⊗[↥B₀] Q) := by infer_instance
  letI : Module.Projective B (B ⊗[↥B₀] Q) := by infer_instance
  refine {
    h1_vanishing := D₀.datum_subsingleton_h1_baseChange B hpair₀
    h0_finite := Module.Finite.equiv e
    h0_projective := Module.Projective.of_equiv e
    h0_rank_one := ?_ }
  intro p
  rw [← Module.rankAtStalk_eq_of_equiv e, Module.rankAtStalk_baseChange]
  exact hrank₀ (p.comap (algebraMap (↥B₀) B))

end RankOneFamilyCertificates

end AlgebraicGeometry
