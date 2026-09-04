/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientTransitionsOver
import MilneLib.InvariantQuotientGlue
import Mathlib.AlgebraicGeometry.Gluing
import Mathlib.AlgebraicGeometry.Pullbacks

/-!
# Supplied cross-chart data for invariant quotients

This module records the data needed to glue a finite family of affine invariant
quotient charts.  The overlap schemes, open immersions, comparison
isomorphisms, and cocycle proofs are explicit fields: no affine-intersection or
quotient-existence theorem is asserted here.  The ring-level overlap cone is
the existing `EquivariantAffineOverlapOver` API; its quotient legs satisfy the
projection squares by `affineInvariantQuotientMapOver_naturality`.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits AlgebraicGeometry

namespace MilneLib
namespace InvariantLocalization

section RingOverlap

variable {k A B C G : Type u}
  [CommRing k] [CommRing A] [CommRing B] [CommRing C]
  [Algebra k A] [Algebra k B] [Algebra k C]
  [Group G] [MulSemiringAction G A] [MulSemiringAction G B]
  [MulSemiringAction G C]
  [Finite G]
  [SMulCommClass G k A] [SMulCommClass G k B] [SMulCommClass G k C]

/-- The pair of quotient legs attached to a supplied equivariant overlap cone.
The source and quotient maps are all over `Spec k`. -/
structure EquivariantAffineOverlapOver.QuotientLegPair
    (D : EquivariantAffineOverlapOver (k := k) (A := A) (B := B)
      (C := C) (G := G)) where
  left : affineInvariantQuotientOver (k := k) (A := C) (G := G) ⟶
    affineInvariantQuotientOver (k := k) (A := A) (G := G)
  right : affineInvariantQuotientOver (k := k) (A := C) (G := G) ⟶
    affineInvariantQuotientOver (k := k) (A := B) (G := G)

namespace EquivariantAffineOverlapOver

/-- Canonical quotient legs for the supplied overlap ring maps. -/
noncomputable def quotientLegs
    (D : EquivariantAffineOverlapOver (k := k) (A := A) (B := B)
      (C := C) (G := G)) : D.QuotientLegPair where
  left := D.leftQuotientMap
  right := D.rightQuotientMap

omit [Finite G] in
/-- The left quotient leg agrees with the left source leg after quotienting. -/
theorem quotientLegs_left_naturality
    (D : EquivariantAffineOverlapOver (k := k) (A := A) (B := B)
      (C := C) (G := G)) :
    affineInvariantQuotientMapOver (k := k) (A := C) (G := G) ≫
        (D.quotientLegs).left =
      D.leftSourceMap ≫
        affineInvariantQuotientMapOver (k := k) (A := A) (G := G) :=
  D.quotientMap_comp_leftQuotientMap

omit [Finite G] in
/-- The right quotient leg agrees with the right source leg after quotienting. -/
theorem quotientLegs_right_naturality
    (D : EquivariantAffineOverlapOver (k := k) (A := A) (B := B)
      (C := C) (G := G)) :
    affineInvariantQuotientMapOver (k := k) (A := C) (G := G) ≫
        (D.quotientLegs).right =
      D.rightSourceMap ≫
        affineInvariantQuotientMapOver (k := k) (A := B) (G := G) :=
  D.quotientMap_comp_rightQuotientMap

end EquivariantAffineOverlapOver

end RingOverlap

section GlueDatum

variable {J : Type u}

/-! The fields below are exactly the inputs required by `Scheme.GlueData`.
Keeping them in a named structure makes the conditional boundary explicit and
allows clients to attach additional quotient projections. -/

/-- Explicit finite-family cross-chart gluing data.  In particular, `V i j`
and `f i j` are *supplied* overlap schemes and legs; this structure does not
construct them from topological intersections. -/
structure InvariantQuotientCrossChartDatum [Finite J] where
  U : J → Scheme.{u}
  V : J → J → Scheme.{u}
  f : ∀ i j, V i j ⟶ U i
  f_id : ∀ i, IsIso (f i i)
  f_open : ∀ i j, IsOpenImmersion (f i j)
  t : ∀ i j, V i j ≅ V j i
  t_id : ∀ i, t i i = Iso.refl _
  t' : ∀ i j k,
    pullback (f i j) (f i k) ⟶ pullback (f j k) (f j i)
  t_fac : ∀ i j k,
    t' i j k ≫ pullback.snd (f j k) (f j i) =
      pullback.fst (f i j) (f i k) ≫ (t i j).hom
  cocycle : ∀ i j k,
    t' i j k ≫ t' j k i ≫ t' k i j = 𝟙 _

namespace InvariantQuotientCrossChartDatum

variable [Finite J]
variable (D : InvariantQuotientCrossChartDatum (J := J))

/-- The supplied cross-chart datum as Mathlib's canonical gluing datum. -/
noncomputable def toGlueData : Scheme.GlueData where
  J := J
  U := D.U
  V := fun p => D.V p.1 p.2
  f := fun i j => D.f i j
  f_mono := fun i j => by
    letI : IsOpenImmersion (D.f i j) := D.f_open i j
    infer_instance
  f_id := D.f_id
  t := fun i j => (D.t i j).hom
  t_id := fun i => by
    simpa using congrArg Iso.hom (D.t_id i)
  t' := D.t'
  t_fac := D.t_fac
  cocycle := D.cocycle
  f_open := D.f_open

@[simp]
theorem toGlueData_U (i : J) : (D.toGlueData).U i = D.U i := rfl

@[simp]
theorem toGlueData_V (i j : J) : (D.toGlueData).V (i, j) = D.V i j := rfl

@[simp]
theorem toGlueData_f (i j : J) : (D.toGlueData).f i j = D.f i j := rfl

@[simp]
theorem toGlueData_t (i j : J) : (D.toGlueData).t i j = (D.t i j).hom := rfl

@[simp]
theorem toGlueData_t' (i j k : J) : (D.toGlueData).t' i j k = D.t' i j k := rfl

end InvariantQuotientCrossChartDatum

end GlueDatum

section InvariantRingGlue

open scoped TensorProduct

variable {R J : Type u} [CommRing R]
variable (A : J → Type u) (B : J → J → Type u)
variable [∀ i, CommRing (A i)] [∀ i j, CommRing (B i j)]
variable [∀ i, Algebra R (A i)] [∀ i j, Algebra R (B i j)]
variable [∀ i j, Algebra (A i) (B i j)]
variable [∀ i j, IsScalarTower R (A i) (B i j)]

/-- The tensor ring controlling a triple overlap of supplied invariant rings. -/
abbrev InvariantAffineTripleTensor (i j k : J) : Type u :=
  B i j ⊗[A i] B i k

/- Compatibility alias with the affine-ring gluing vocabulary. -/
abbrev AffineTripleTensor (i j k : J) : Type u :=
  InvariantAffineTripleTensor A B i j k

/-- Left and right overlap inclusions into the triple tensor. -/
def invariantAffineTensorIncludeLeft (i j k : J) :
    B i j →ₐ[R] InvariantAffineTripleTensor A B i j k :=
  (Algebra.TensorProduct.includeLeft :
    B i j →ₐ[A i] B i j ⊗[A i] B i k).restrictScalars R

def invariantAffineTensorIncludeRight (i j k : J) :
    B i k →ₐ[R] InvariantAffineTripleTensor A B i j k :=
  (Algebra.TensorProduct.includeRight :
    B i k →ₐ[A i] B i j ⊗[A i] B i k).restrictScalars R

/-- The affine chart and overlap maps, viewed contravariantly on spectra. -/
noncomputable abbrev invariantAffineRestriction (i j : J) :
    Spec (CommRingCat.of (B i j)) ⟶ Spec (CommRingCat.of (A i)) :=
  Spec.map (CommRingCat.ofHom (algebraMap (A i) (B i j)))

noncomputable abbrev invariantAffineTransition
    (tau : ∀ i j, B j i →ₐ[R] B i j) (i j : J) :
    Spec (CommRingCat.of (B i j)) ⟶ Spec (CommRingCat.of (B j i)) :=
  Spec.map (CommRingCat.ofHom (tau i j).toRingHom)

noncomputable abbrev invariantAffineTriplePullbackIso (i j k : J) :
    pullback (invariantAffineRestriction A B i j)
      (invariantAffineRestriction A B i k) ≅
      Spec (CommRingCat.of (InvariantAffineTripleTensor A B i j k)) :=
  pullbackSpecIso (A i) (B i j) (B i k)

/-- A triple transition induced by a supplied ring map, conjugated by the
canonical affine pullback identifications. -/
noncomputable def invariantAffineTripleTransition
    (theta : ∀ i j k,
      InvariantAffineTripleTensor A B j k i →ₐ[R]
        InvariantAffineTripleTensor A B i j k) (i j k : J) :
    pullback (invariantAffineRestriction A B i j)
        (invariantAffineRestriction A B i k) ⟶
      pullback (invariantAffineRestriction A B j k)
        (invariantAffineRestriction A B j i) :=
  (invariantAffineTriplePullbackIso A B i j k).hom ≫
    Spec.map (CommRingCat.ofHom (theta i j k).toRingHom) ≫
      (invariantAffineTriplePullbackIso A B j k i).inv

theorem invariantAffineTripleTransition_fac
    (tau : ∀ i j, B j i →ₐ[R] B i j)
    (theta : ∀ i j k,
      InvariantAffineTripleTensor A B j k i →ₐ[R]
        InvariantAffineTripleTensor A B i j k)
    (hfac : ∀ i j k,
      (theta i j k).comp (invariantAffineTensorIncludeRight A B j k i) =
        (invariantAffineTensorIncludeLeft A B i j k).comp (tau i j))
    (i j k : J) :
    invariantAffineTripleTransition A B theta i j k ≫
        pullback.snd (invariantAffineRestriction A B j k)
          (invariantAffineRestriction A B j i) =
      pullback.fst (invariantAffineRestriction A B i j)
          (invariantAffineRestriction A B i k) ≫
        invariantAffineTransition B tau i j := by
  have hfac' :
      CommRingCat.ofHom
          (((theta i j k).comp
            (invariantAffineTensorIncludeRight A B j k i)).toRingHom) =
        CommRingCat.ofHom
          (((invariantAffineTensorIncludeLeft A B i j k).comp
            (tau i j)).toRingHom) :=
    congrArg (fun f => CommRingCat.ofHom f.toRingHom) (hfac i j k)
  simp only [invariantAffineTripleTransition, Category.assoc]
  rw [pullbackSpecIso_inv_snd, ← Spec.map_comp, ← CommRingCat.ofHom_comp]
  change (invariantAffineTriplePullbackIso A B i j k).hom ≫
      Spec.map (CommRingCat.ofHom
        (((theta i j k).comp
          (invariantAffineTensorIncludeRight A B j k i)).toRingHom)) = _
  rw [hfac']
  rw [show ((invariantAffineTensorIncludeLeft A B i j k).comp
      (tau i j)).toRingHom =
      (invariantAffineTensorIncludeLeft A B i j k).toRingHom.comp
        (tau i j).toRingHom by rfl]
  rw [CommRingCat.ofHom_comp, Spec.map_comp]
  change (invariantAffineTriplePullbackIso A B i j k).hom ≫
      Spec.map (CommRingCat.ofHom
        (Algebra.TensorProduct.includeLeftRingHom :
          B i j →+* InvariantAffineTripleTensor A B i j k)) ≫
      Spec.map (CommRingCat.ofHom (tau i j).toRingHom) = _
  rw [← Category.assoc, pullbackSpecIso_hom_fst]

theorem invariantAffineTripleTransition_cocycle
    (theta : ∀ i j k,
      InvariantAffineTripleTensor A B j k i →ₐ[R]
        InvariantAffineTripleTensor A B i j k)
    (hcycle : ∀ i j k,
      (theta i j k).comp ((theta j k i).comp (theta k i j)) =
        AlgHom.id R (InvariantAffineTripleTensor A B i j k))
    (i j k : J) :
    invariantAffineTripleTransition A B theta i j k ≫
      invariantAffineTripleTransition A B theta j k i ≫
      invariantAffineTripleTransition A B theta k i j =
      𝟙 _ := by
  have hmap :
      Spec.map (CommRingCat.ofHom (theta i j k).toRingHom) ≫
      Spec.map (CommRingCat.ofHom (theta j k i).toRingHom) ≫
      Spec.map (CommRingCat.ofHom (theta k i j).toRingHom) =
      𝟙 (Spec (CommRingCat.of (InvariantAffineTripleTensor A B i j k))) := by
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp,
      ← Spec.map_comp, ← CommRingCat.ofHom_comp]
    have hc := congrArg (fun f => CommRingCat.ofHom f.toRingHom)
      (hcycle i j k)
    change Spec.map (CommRingCat.ofHom
      (((theta i j k).comp ((theta j k i).comp (theta k i j))).toRingHom)) = _
    rw [hc]
    rw [show (AlgHom.id R (InvariantAffineTripleTensor A B i j k)).toRingHom =
      RingHom.id _ by rfl, CommRingCat.ofHom_id, Spec.map_id]
  simp only [invariantAffineTripleTransition, Category.assoc,
    Iso.inv_hom_id_assoc]
  rw [reassoc_of% hmap]
  exact Iso.hom_inv_id _

theorem invariantAffineTransition_self
    (tau : ∀ i j, B j i →ₐ[R] B i j)
    (htau : ∀ i, tau i i = AlgHom.id R (B i i)) (i : J) :
    invariantAffineTransition B tau i i =
      𝟙 (Spec (CommRingCat.of (B i i))) := by
  change Spec.map (CommRingCat.ofHom (tau i i).toRingHom) = _
  rw [htau, show (AlgHom.id R (B i i)).toRingHom = RingHom.id _ by rfl,
    CommRingCat.ofHom_id, Spec.map_id]

/-- Build a `Scheme.GlueData` from supplied invariant chart rings.  The
diagonal isomorphism and openness remain explicit geometric hypotheses. -/
noncomputable def invariantAffineRingGlueData
    (tau : ∀ i j, B j i →ₐ[R] B i j)
    (theta : ∀ i j k,
      InvariantAffineTripleTensor A B j k i →ₐ[R]
        InvariantAffineTripleTensor A B i j k)
    (fId : ∀ i, IsIso (invariantAffineRestriction A B i i))
    (fOpen : ∀ i j, IsOpenImmersion (invariantAffineRestriction A B i j))
    (tauId : ∀ i, tau i i = AlgHom.id R (B i i))
    (thetaFac : ∀ i j k,
      (theta i j k).comp (invariantAffineTensorIncludeRight A B j k i) =
        (invariantAffineTensorIncludeLeft A B i j k).comp (tau i j))
    (thetaCocycle : ∀ i j k,
      (theta i j k).comp ((theta j k i).comp (theta k i j)) =
        AlgHom.id R (InvariantAffineTripleTensor A B i j k)) :
    Scheme.GlueData.{u} :=
  { J := J
    U := fun i => Spec (CommRingCat.of (A i))
    V := fun p => Spec (CommRingCat.of (B p.1 p.2))
    f := invariantAffineRestriction A B
    f_id := fId
    f_open := fOpen
    t := invariantAffineTransition B tau
    t_id := invariantAffineTransition_self B tau tauId
    t' := invariantAffineTripleTransition A B theta
    t_fac := invariantAffineTripleTransition_fac A B tau theta thetaFac
    cocycle := invariantAffineTripleTransition_cocycle A B theta thetaCocycle }

end InvariantRingGlue

section CrossChartRange

variable {k A G : Type u}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A] [Finite G]

/-- The affine invariant quotient pulls back the descended overlap of two stable
opens to their source intersection.  This is the cross-chart range identity
used to identify a geometric overlap before any gluing datum is assembled. -/
@[simp]
theorem affineInvariantQuotientMap_preimage_stable_inf
    (U V : (Spec (CommRingCat.of A)).Opens)
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U)
    (hV : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ V = V) :
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
        (quotientOpenOfStable (k := k) (A := A) (G := G) U hU ⊓
          quotientOpenOfStable (k := k) (A := A) (G := G) V hV) =
      U ⊓ V := by
  let hUV : ∀ g : G,
      (specAction G A g).hom ⁻¹ᵁ (U ⊓ V) = U ⊓ V := by
    intro g
    rw [Scheme.Hom.preimage_inf, hU g, hV g]
  rw [← quotientOpenOfStable_inf (k := k) (A := A) (G := G) U V hU hV]
  exact quotientOpenOfStable_preimage (k := k) (A := A) (G := G)
    (U ⊓ V) hUV

end CrossChartRange

end InvariantLocalization
end MilneLib
