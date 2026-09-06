/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.SymmetricPower.SymmetricPower
import MilneLib.Quotient.InvariantQuotientFactorization
import MilneLib.Quotient.InvariantQuotientFiniteAtlasOver
import MilneLib.Quotient.InvariantQuotientFree

/-!
# Symmetric powers from invariant-ring quotients

The finite permutation quotient of a relative power gives symmetric-power
data over an affine base. The construction assumes that the relative power is
separated and quasi-compact and that every permutation orbit lies in an affine
open. For affine schemes these conditions hold automatically.

The universal property applies to arbitrary target schemes over the base.
This construction does not assert separability or discharge the orbit-in-affine
hypothesis for general varieties in Milne III.3, Proposition 3.1.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry

namespace MilneLib

open StableGroupAction StableGroupAction.StableAffineOpen

variable {k : Type u} [CommRing k]

/-- Permutations of the relative power preserve its structure morphism. -/
theorem permutationAutHomOverLeft_comp_base
    (V : Over (Spec (CommRingCat.of k))) (n : ℕ) (σ : Equiv.Perm (Fin n)) :
    ((permutationAutHomOverLeft V n) σ).hom ≫ (relativePower V n).hom =
      (relativePower V n).hom := by
  change (permute V n σ⁻¹).left ≫ (relativePower V n).hom = _
  exact Over.w (permute V n σ⁻¹)

noncomputable def quotientPermutationAction
    (V : Over (Spec (CommRingCat.of k))) (n : ℕ) :
    ULift.{u} (Equiv.Perm (Fin n)) →* Aut (relativePower V n).left :=
  (permutationAutHomOverLeft V n).comp MulEquiv.ulift.toMonoidHom

theorem quotientPermutationAction_comp_base
    (V : Over (Spec (CommRingCat.of k))) (n : ℕ)
    (σ : ULift.{u} (Equiv.Perm (Fin n))) :
    ((quotientPermutationAction V n) σ).hom ≫ (relativePower V n).hom =
      (relativePower V n).hom :=
  permutationAutHomOverLeft_comp_base V n σ.down

theorem quotientPermutationAction_orbits
    (V : Over (Spec (CommRingCat.of k))) (n : ℕ)
    (h : OrbitsInAffineOpen (permutationAutHomOverLeft V n)) :
    OrbitsInAffineOpen (quotientPermutationAction V n) := by
  intro x
  obtain ⟨U, hU⟩ := h x
  exact ⟨U, fun σ => hU σ.down⟩

section Orbits

variable (V : Over (Spec (CommRingCat.of k))) (n : ℕ)
  [(relativePower V n).left.IsSeparated] [CompactSpace (relativePower V n).left]
  (h : OrbitsInAffineOpen (permutationAutHomOverLeft V n))

/-- The quotient over the affine base obtained by gluing the invariant rings
of a finite stable affine cover of the relative power. -/
noncomputable def symmetricPowerQuotient : Over (Spec (CommRingCat.of k)) :=
  Over.mk ((finiteStableQuotientBaseMapData (quotientPermutationAction V n)
    (relativePower V n).hom (quotientPermutationAction_comp_base V n)
      (quotientPermutationAction_orbits V n h)).map
      (finiteStableQuotientCrossChartDatum (quotientPermutationAction V n)
        (relativePower V n).hom (quotientPermutationAction_comp_base V n)
          (quotientPermutationAction_orbits V n h)))

/-- The geometric quotient projection, as a morphism over the affine base. -/
noncomputable def symmetricPowerQuotientProjection :
    relativePower V n ⟶ symmetricPowerQuotient V n h :=
  Over.homMk (finiteStableCanonicalQuotientProjection (quotientPermutationAction V n)
    (relativePower V n).hom (quotientPermutationAction_comp_base V n)
      (quotientPermutationAction_orbits V n h))
    (finiteStableCanonicalQuotientProjectionOver_comp_base (quotientPermutationAction V n)
      (relativePower V n).hom (quotientPermutationAction_comp_base V n)
        (quotientPermutationAction_orbits V n h))

/-- The geometric quotient projection is symmetric. -/
theorem symmetricPowerQuotientProjection_isSymmetric :
    IsSymmetric V n (symmetricPowerQuotientProjection V n h) := by
  intro σ
  apply Over.OverMorphism.ext
  have hs := act_hom_comp_finiteStableCanonicalQuotientProjection
    (quotientPermutationAction V n) (relativePower V n).hom
    (quotientPermutationAction_comp_base V n) (quotientPermutationAction_orbits V n h)
      (ULift.up σ⁻¹)
  change (permute V n σ⁻¹⁻¹).left ≫
    (symmetricPowerQuotientProjection V n h).left =
      (symmetricPowerQuotientProjection V n h).left at hs
  simpa only [inv_inv, Over.comp_left] using hs

/-! The concrete projection also exposes the symmetry equation directly.  This
form is convenient for quotient-map calculations that do not need to unfold
the `IsSymmetric` predicate. -/

@[reassoc]
theorem symmetricPowerQuotientProjection_comp_permute
    (σ : Equiv.Perm (Fin n)) :
    permute V n σ ≫ symmetricPowerQuotientProjection V n h =
      symmetricPowerQuotientProjection V n h :=
  symmetricPowerQuotientProjection_isSymmetric V n h σ

/-- A symmetric map to any scheme over the base descends uniquely through the
invariant-ring quotient. The base square descends by cancellation of the
epimorphic quotient projection. -/
theorem symmetricPowerQuotientProjection_existsUnique_factor
    {T : Over (Spec (CommRingCat.of k))} (f : relativePower V n ⟶ T)
    (hf : IsSymmetric V n f) :
    ∃! g : symmetricPowerQuotient V n h ⟶ T,
      symmetricPowerQuotientProjection V n h ≫ g = f := by
  let act := quotientPermutationAction V n
  let hact := quotientPermutationAction_comp_base V n
  let horb := quotientPermutationAction_orbits V n h
  let q := finiteStableCanonicalQuotientProjection act (relativePower V n).hom hact horb
  have hfinv : ∀ σ : ULift.{u} (Equiv.Perm (Fin n)),
      (act σ).hom ≫ f.left = f.left := by
    intro σ
    exact congrArg (fun g => g.left) (hf σ.down⁻¹)
  obtain ⟨g, hg, huniq⟩ := finiteStableCanonicalQuotientProjection_existsUnique_factor
    act (relativePower V n).hom hact horb f.left hfinv
  have hbase : g ≫ T.hom = (symmetricPowerQuotient V n h).hom := by
    apply (cancel_epi q).mp
    rw [← Category.assoc, hg]
    exact (Over.w f).trans
      (finiteStableCanonicalQuotientProjectionOver_comp_base act
        (relativePower V n).hom hact horb).symm
  refine ⟨Over.homMk g hbase, ?_, ?_⟩
  · apply Over.OverMorphism.ext
    exact hg
  · intro g' hg'
    apply Over.OverMorphism.ext
    exact huniq g'.left (congrArg (fun t => t.left) hg')

/-- The geometric symmetrisation projection is surjective on points. -/
theorem symmetricPowerQuotientProjection_surjective :
    Function.Surjective (symmetricPowerQuotientProjection V n h).left :=
  finiteStableCanonicalQuotientProjection_surjective (quotientPermutationAction V n)
    (relativePower V n).hom (quotientPermutationAction_comp_base V n)
      (quotientPermutationAction_orbits V n h)

/-- The symmetric-power carrier has the quotient topology. -/
theorem symmetricPowerQuotientProjection_isQuotientMap :
    Topology.IsQuotientMap (symmetricPowerQuotientProjection V n h).left.base :=
  finiteStableCanonicalQuotientProjection_isQuotientMap (quotientPermutationAction V n)
    (relativePower V n).hom (quotientPermutationAction_comp_base V n)
      (quotientPermutationAction_orbits V n h)

/-- The symmetrisation projection is finite when the relative power is locally
of finite type over the base. -/
theorem symmetricPowerQuotientProjection_isFinite
    [LocallyOfFiniteType (relativePower V n).hom] :
    IsFinite (symmetricPowerQuotientProjection V n h).left :=
  finiteStableCanonicalQuotientProjection_isFinite (quotientPermutationAction V n)
    (relativePower V n).hom (quotientPermutationAction_comp_base V n)
      (quotientPermutationAction_orbits V n h)

/-! Étaleness of the finite quotient is local on the affine stable charts.  The
chart-level hypothesis is kept explicit because freeness of the action does not
yet have an affine invariant-ring implementation in Mathlib. -/

theorem symmetricPowerQuotientProjection_isEtale_of_chart_maps
    (hEtale : ∀ i : (finiteStableAffineCover (quotientPermutationAction V n)
        (quotientPermutationAction_orbits V n h)).I₀,
      Etale (finiteStableQuotientChartMap (quotientPermutationAction V n)
        (relativePower V n).hom (quotientPermutationAction_comp_base V n)
        (quotientPermutationAction_orbits V n h) i ≫
        (finiteStableQuotientCrossChartDatum (quotientPermutationAction V n)
          (relativePower V n).hom (quotientPermutationAction_comp_base V n)
          (quotientPermutationAction_orbits V n h)).toGlueData.ι i)) :
    Etale (symmetricPowerQuotientProjection V n h).left := by
  exact finiteStableCanonicalQuotientProjection_etale_of_chart_maps
    (quotientPermutationAction V n) (relativePower V n).hom
    (quotientPermutationAction_comp_base V n)
    (quotientPermutationAction_orbits V n h) hEtale

/-- Geometric freeness of the permutation action makes the symmetric
projection etale.  The field-valued-point hypothesis is stated on the
relative-power scheme so it can be transported directly to the finite stable
quotient atlas. -/
theorem symmetricPowerQuotientProjection_isEtale_of_field_points
    (hfree : ∀ (K : Type u) [Field K]
      (x : Spec (CommRingCat.of K) ⟶ (relativePower V n).left)
      (σ : ULift.{u} (Equiv.Perm (Fin n))),
      x ≫ (quotientPermutationAction V n σ).hom = x → σ = 1) :
    Etale (symmetricPowerQuotientProjection V n h).left := by
  exact finiteStableCanonicalQuotientProjection_etale_of_field_points
    (quotientPermutationAction V n)
    (relativePower V n).hom
    (quotientPermutationAction_comp_base V n)
    (quotientPermutationAction_orbits V n h)
    hfree

/-! When the permutation group is subsingleton (in particular for the zeroth
and first relative powers), the field-valued freeness condition is automatic.
This packages the degenerate cases without weakening the explicit freeness
hypothesis used for genuine symmetric powers. -/

theorem symmetricPowerQuotientProjection_isEtale_of_subsingleton_permutation
    [Subsingleton (Equiv.Perm (Fin n))] :
    Etale (symmetricPowerQuotientProjection V n h).left := by
  apply symmetricPowerQuotientProjection_isEtale_of_field_points V n h
  intro K _ x σ _
  exact Subsingleton.elim σ 1

/-- Symmetric-power data produced by the finite invariant-ring quotient,
under the explicit affine-orbit and compactness hypotheses. -/
noncomputable def symmetricPowerDataOfOrbits : SymmetricPowerData V n where
  carrier := symmetricPowerQuotient V n h
  projection := symmetricPowerQuotientProjection V n h
  projection_symmetric := symmetricPowerQuotientProjection_isSymmetric V n h
  desc := fun f hf => symmetricPowerQuotientProjection_existsUnique_factor V n h f hf

end Orbits

/-- Every finite relative power of an affine scheme over an affine base has
a symmetric quotient, constructed from invariant rings and affine gluing. -/
noncomputable def affineSymmetricPowerData
    (V : Over (Spec (CommRingCat.of k))) (n : ℕ) [IsAffine V.left] :
    SymmetricPowerData V n := by
  letI := relativePower_isAffine V n
  exact symmetricPowerDataOfOrbits V n (permutation_orbitsInAffineOpen_of_isAffine V n)

/-- Over a noetherian affine base, a quasi-compact separated scheme of finite
type has a finite symmetric quotient whenever its permutation orbits lie in
affine opens. The power-level geometric hypotheses are proved from the input
scheme, and the quotient is again quasi-compact, separated, and of finite type. -/
theorem exists_finite_symmetricPowerData [IsNoetherianRing k]
    (V : Over (Spec (CommRingCat.of k))) (n : ℕ)
    [LocallyOfFiniteType V.hom] [QuasiCompact V.hom] [IsSeparated V.hom]
    (h : OrbitsInAffineOpen (permutationAutHomOverLeft V n)) :
    ∃ D : SymmetricPowerData V n,
      IsFinite D.projection.left ∧ Function.Surjective D.projection.left ∧
        LocallyOfFiniteType D.carrier.hom ∧ QuasiCompact D.carrier.hom ∧
          IsSeparated D.carrier.hom := by
  letI := relativePower_locallyOfFiniteType V n
  letI := relativePower_quasiCompact V n
  letI := relativePower_isSeparated V n
  letI : (relativePower V n).left.IsSeparated :=
    (HasAffineProperty.iff_of_isAffine (P := @IsSeparated)
      (f := (relativePower V n).hom)).mp inferInstance
  letI : CompactSpace (relativePower V n).left :=
    QuasiCompact.compactSpace_of_compactSpace (relativePower V n).hom
  refine ⟨symmetricPowerDataOfOrbits V n h,
    symmetricPowerQuotientProjection_isFinite V n h,
    symmetricPowerQuotientProjection_surjective V n h, ?_, ?_, ?_⟩
  · exact finiteStableQuotientBaseMap_locallyOfFiniteType (quotientPermutationAction V n)
      (relativePower V n).hom (quotientPermutationAction_comp_base V n)
        (quotientPermutationAction_orbits V n h)
  · exact finiteStableQuotientBaseMap_quasiCompact (quotientPermutationAction V n)
      (relativePower V n).hom (quotientPermutationAction_comp_base V n)
        (quotientPermutationAction_orbits V n h)
  · exact finiteStableQuotientBaseMap_isSeparated (quotientPermutationAction V n)
      (relativePower V n).hom (quotientPermutationAction_comp_base V n)
        (quotientPermutationAction_orbits V n h)

end MilneLib
