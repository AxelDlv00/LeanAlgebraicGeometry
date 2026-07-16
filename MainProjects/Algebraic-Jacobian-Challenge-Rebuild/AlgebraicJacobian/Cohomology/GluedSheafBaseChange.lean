/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.GluedSheafDatum

/-!
# Base change of the pinned cocycle datum along a test-ring map (DAT-1 stage 1d-ii, the datum map)

The datum half of `informal/spec-dat-1.md` stage (1d-ii), landed here because RE-5's
descent certificate consumes it (worksheet §3.2: "a datum over `B₀` whose base change
along `B₀ → B` is the given one"): for a test-ring change `B → B'` over `k`, the
basic-open cocycle datum of `GluedSheafDatum` pushes forward through the landed
comparison machinery —

* `AlgebraicGeometry.BasicOpenCoverData.baseChange` — `h`, `a` push through
  `relSectionsMap`; the partition witnesses are `map_*` images;
* `AlgebraicGeometry.BasicOpenCocycleDatum.overlapMap`/`overlapMap₃` — the comparison
  ring homomorphisms on the pairwise/triple piece overlaps (`appLE` of `relCurveMap`;
  pieces map into the preimages of pieces by `Scheme.basicOpen_appLE`);
* `AlgebraicGeometry.BasicOpenCocycleDatum.baseChange` — the transition units push
  through `Units.map`; the cocycle identities transport along the
  `appLE`/`resHom` exchange (`Scheme.Hom.appLE_resHom`).

The remaining (1d-ii) clauses (piece/chart-term base change of the GLUED SHEAF and the
on-the-nose `H⁰` export `datumH0BaseChange`) are NOT here — they stay with the DAT-1
finisher lane; RE-5's transport corollary is stated against the abstract clause
`datumH0BaseChangeEquiv` (`GluedSheafEngine.lean`) with the seam recorded in
`DatumDescent.lean`.

Also here: `BasicOpenCocycleDatum.ext_units`, the constructor congruence used by the
descent certificate (two data with the same cover data and pointwise-equal units are
equal).
-/

set_option autoImplicit false
/- The statements mix `Γ(relCurve C B, ·)` with opens produced on the product spelling
and with the `relCover`/`pullbackProd` chart spellings (definitionally equal through
semireducible definitions), as in `GluedSheafDatum.lean`. -/
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory TopologicalSpace Opposite

namespace AlgebraicGeometry

/-! ## The `appLE`/`resHom` exchange (the transport workhorse) -/

/-- **The `appLE`/`resHom` exchange**: pulling back a restricted section is restricting
the pulled-back section. Both sides collapse to `f.appLE U O'`; all four inclusion
witnesses are proof-irrelevant, so this one lemma covers every restriction-compatibility
obligation of the datum transport. -/
lemma Scheme.Hom.appLE_resHom {X Y : Scheme.{u}} (f : X ⟶ Y) {U O : Y.Opens}
    {U' O' : X.Opens} (hleU : U' ≤ f ⁻¹ᵁ U) (hOU : O ≤ U) (hleO : O' ≤ f ⁻¹ᵁ O)
    (hO'U' : O' ≤ U') (x : Γ(Y, U)) :
    (f.appLE O O' hleO).hom (Y.resHom hOU x) =
      X.resHom hO'U' ((f.appLE U U' hleU).hom x) := by
  have h₁ := Scheme.Hom.map_appLE f hleO (homOfLE hOU).op
  have h₂ := Scheme.Hom.appLE_map f hleU (homOfLE hO'U').op
  have e₁ : (f.appLE O O' hleO).hom (Y.resHom hOU x) =
      (f.appLE U O' (hleO.trans (Scheme.Hom.preimage_mono f hOU))).hom x :=
    congr($(h₁).hom x)
  have e₂ : X.resHom hO'U' ((f.appLE U U' hleU).hom x) =
      (f.appLE U O' (hO'U'.trans hleU)).hom x :=
    congr($(h₂).hom x)
  rw [e₁, e₂]

/-- The basic open of an `appLE`-pulled-back section sits inside the preimage of the
basic open of the section (`Scheme.basicOpen_appLE`, inequality face — stated in
`.hom`-application form so it applies to the section comparison maps directly). -/
lemma Scheme.Hom.basicOpen_appLE_le_preimage {X Y : Scheme.{u}} (f : X ⟶ Y)
    {U : Y.Opens} {U' : X.Opens} (e : U' ≤ f ⁻¹ᵁ U) (s : Γ(Y, U)) :
    X.basicOpen ((f.appLE U U' e).hom s) ≤ f ⁻¹ᵁ Y.basicOpen s :=
  le_trans (le_of_eq (Scheme.basicOpen_appLE f U' U e s)) inf_le_right

section BaseChange

attribute [local instance] Scheme.overModule

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {π : C.left ⟶ P1 k} [IsAffineHom π]
variable (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B'] [IsScalarTower k B B']

/-! ## Base change of the cover data -/

/-- **Base change of the basic-open cover data** along a test-ring change `B → B'`
(spec-dat-1 stage (1d-ii), datum half): the generators and partition coefficients push
through the sections comparison map `relSectionsMap`; the partition witnesses are the
`map_*` images of the given ones. -/
noncomputable def BasicOpenCoverData.baseChange (D : BasicOpenCoverData C B π) :
    BasicOpenCoverData C B' π where
  J₀ := D.J₀
  J₁ := D.J₁
  fintype₀ := D.fintype₀
  fintype₁ := D.fintype₁
  h₀ := fun j => relSectionsMap C B B' (fiberTwoCover π).V₀ (D.h₀ j)
  h₁ := fun j => relSectionsMap C B B' (fiberTwoCover π).V₁ (D.h₁ j)
  a₀ := fun j => relSectionsMap C B B' (fiberTwoCover π).V₀ (D.a₀ j)
  a₁ := fun j => relSectionsMap C B B' (fiberTwoCover π).V₁ (D.a₁ j)
  partition₀ := by
    rw [← map_one (relSectionsMap C B B' (fiberTwoCover π).V₀), ← D.partition₀, map_sum]
    exact Finset.sum_congr rfl fun j _ => (map_mul _ _ _).symm
  partition₁ := by
    rw [← map_one (relSectionsMap C B B' (fiberTwoCover π).V₁), ← D.partition₁, map_sum]
    exact Finset.sum_congr rfl fun j _ => (map_mul _ _ _).symm

namespace BasicOpenCoverData

variable {B'} (D : BasicOpenCoverData C B π)

@[simp]
lemma baseChange_h₀ (j : D.J₀) :
    (D.baseChange B').h₀ j = relSectionsMap C B B' (fiberTwoCover π).V₀ (D.h₀ j) := rfl

@[simp]
lemma baseChange_h₁ (j : D.J₁) :
    (D.baseChange B').h₁ j = relSectionsMap C B B' (fiberTwoCover π).V₁ (D.h₁ j) := rfl

@[simp]
lemma baseChange_a₀ (j : D.J₀) :
    (D.baseChange B').a₀ j = relSectionsMap C B B' (fiberTwoCover π).V₀ (D.a₀ j) := rfl

@[simp]
lemma baseChange_a₁ (j : D.J₁) :
    (D.baseChange B').a₁ j = relSectionsMap C B B' (fiberTwoCover π).V₁ (D.a₁ j) := rfl

/-- The base-changed pieces sit inside the `relCurveMap`-preimages of the pieces
(`Scheme.basicOpen_appLE`). -/
lemma baseChange_pieces_le_preimage (i : D.index) :
    (D.baseChange B').pieces i ≤ relCurveMap C B B' ⁻¹ᵁ D.pieces i := by
  cases i with
  | inl j =>
    change (relCurve C B').basicOpen ((D.baseChange B').h₀ j) ≤ _
    rw [BasicOpenCoverData.pieces_inl]
    exact (relCurveMap C B B').basicOpen_appLE_le_preimage
      (le_of_eq (relCurveMap_preimage C B B' (fiberTwoCover π).V₀).symm) (D.h₀ j)
  | inr j =>
    change (relCurve C B').basicOpen ((D.baseChange B').h₁ j) ≤ _
    rw [BasicOpenCoverData.pieces_inr]
    exact (relCurveMap C B B').basicOpen_appLE_le_preimage
      (le_of_eq (relCurveMap_preimage C B B' (fiberTwoCover π).V₁).symm) (D.h₁ j)

/-- The pairwise overlaps of the base-changed pieces sit inside the preimages of the
pairwise overlaps. -/
lemma baseChange_pieces_inf_le_preimage (i j : D.index) :
    (D.baseChange B').pieces i ⊓ (D.baseChange B').pieces j ≤
      relCurveMap C B B' ⁻¹ᵁ (D.pieces i ⊓ D.pieces j) := by
  rw [Scheme.Hom.preimage_inf]
  exact inf_le_inf (D.baseChange_pieces_le_preimage i) (D.baseChange_pieces_le_preimage j)

/-- The triple overlaps of the base-changed pieces sit inside the preimages of the
triple overlaps. -/
lemma baseChange_pieces_inf₃_le_preimage (i j l : D.index) :
    (D.baseChange B').pieces i ⊓ (D.baseChange B').pieces j ⊓ (D.baseChange B').pieces l ≤
      relCurveMap C B B' ⁻¹ᵁ (D.pieces i ⊓ D.pieces j ⊓ D.pieces l) := by
  rw [Scheme.Hom.preimage_inf]
  exact inf_le_inf (D.baseChange_pieces_inf_le_preimage i j)
    (D.baseChange_pieces_le_preimage l)

end BasicOpenCoverData

/-! ## Base change of the cocycle datum -/

namespace BasicOpenCocycleDatum

variable {B'} (D : BasicOpenCocycleDatum C B π)

/-- **The pairwise-overlap comparison map** of the datum along `B → B'`: `appLE` of the
relative-curve comparison morphism from the piece overlap over `B` to the base-changed
piece overlap over `B'`. -/
noncomputable def overlapMap (i j : D.index) :
    Γ(relCurve C B, D.pieces i ⊓ D.pieces j) →+*
      Γ(relCurve C B', (D.toBasicOpenCoverData.baseChange B').pieces i ⊓
        (D.toBasicOpenCoverData.baseChange B').pieces j) :=
  ((relCurveMap C B B').appLE (D.pieces i ⊓ D.pieces j) _
    (D.toBasicOpenCoverData.baseChange_pieces_inf_le_preimage i j)).hom

/-- **The triple-overlap comparison map** of the datum along `B → B'`. -/
noncomputable def overlapMap₃ (i j l : D.index) :
    Γ(relCurve C B, D.pieces i ⊓ D.pieces j ⊓ D.pieces l) →+*
      Γ(relCurve C B', (D.toBasicOpenCoverData.baseChange B').pieces i ⊓
        (D.toBasicOpenCoverData.baseChange B').pieces j ⊓
        (D.toBasicOpenCoverData.baseChange B').pieces l) :=
  ((relCurveMap C B B').appLE (D.pieces i ⊓ D.pieces j ⊓ D.pieces l) _
    (D.toBasicOpenCoverData.baseChange_pieces_inf₃_le_preimage i j l)).hom

/-- **Base change of the pinned cocycle datum** along a test-ring change `B → B'`
(spec-dat-1 stage (1d-ii), datum half; the object whose descent is RE-5): the cover
data push through `relSectionsMap`, the transition units through `Units.map` of the
overlap comparison maps, and the cocycle identities transport along the
`appLE`/`resHom` exchange. -/
noncomputable def baseChange : BasicOpenCocycleDatum C B' π where
  toBasicOpenCoverData := D.toBasicOpenCoverData.baseChange B'
  unit := fun i j => Units.map (D.overlapMap (B' := B') i j).toMonoidHom (D.unit i j)
  isGluingCocycle := by
    constructor
    · intro i
      change (D.overlapMap (B' := B') i i) ((D.unit i i : Γ(relCurve C B, _))) = 1
      rw [D.isGluingCocycle.unit_self i, map_one]
    · intro i j l
      have key := congrArg (D.overlapMap₃ (B' := B') i j l)
        (D.isGluingCocycle.mul_res i j l)
      rw [map_mul] at key
      have e₁ : D.overlapMap₃ (B' := B') i j l
          ((relCurve C B).resHom inf_le_left
            (D.unit i j : Γ(relCurve C B, D.pieces i ⊓ D.pieces j))) =
          (relCurve C B').resHom inf_le_left
            (D.overlapMap (B' := B') i j
              (D.unit i j : Γ(relCurve C B, D.pieces i ⊓ D.pieces j))) :=
        (relCurveMap C B B').appLE_resHom
          (D.toBasicOpenCoverData.baseChange_pieces_inf_le_preimage (B' := B') i j)
          inf_le_left
          (D.toBasicOpenCoverData.baseChange_pieces_inf₃_le_preimage i j l)
          inf_le_left _
      have e₂ : D.overlapMap₃ (B' := B') i j l
          ((relCurve C B).resHom (gluedInclCoc D.pieces (D.pieces i) j l)
            (D.unit j l : Γ(relCurve C B, D.pieces j ⊓ D.pieces l))) =
          (relCurve C B').resHom
            (gluedInclCoc ((D.toBasicOpenCoverData.baseChange B').pieces)
              ((D.toBasicOpenCoverData.baseChange B').pieces i) j l)
            (D.overlapMap (B' := B') j l
              (D.unit j l : Γ(relCurve C B, D.pieces j ⊓ D.pieces l))) :=
        (relCurveMap C B B').appLE_resHom
          (D.toBasicOpenCoverData.baseChange_pieces_inf_le_preimage (B' := B') j l)
          (gluedInclCoc D.pieces (D.pieces i) j l)
          (D.toBasicOpenCoverData.baseChange_pieces_inf₃_le_preimage i j l)
          (gluedInclCoc ((D.toBasicOpenCoverData.baseChange B').pieces)
            ((D.toBasicOpenCoverData.baseChange B').pieces i) j l) _
      have e₃ : D.overlapMap₃ (B' := B') i j l
          ((relCurve C B).resHom (gluedInclSnd D.pieces (D.pieces i) j l)
            (D.unit i l : Γ(relCurve C B, D.pieces i ⊓ D.pieces l))) =
          (relCurve C B').resHom
            (gluedInclSnd ((D.toBasicOpenCoverData.baseChange B').pieces)
              ((D.toBasicOpenCoverData.baseChange B').pieces i) j l)
            (D.overlapMap (B' := B') i l
              (D.unit i l : Γ(relCurve C B, D.pieces i ⊓ D.pieces l))) :=
        (relCurveMap C B B').appLE_resHom
          (D.toBasicOpenCoverData.baseChange_pieces_inf_le_preimage (B' := B') i l)
          (gluedInclSnd D.pieces (D.pieces i) j l)
          (D.toBasicOpenCoverData.baseChange_pieces_inf₃_le_preimage i j l)
          (gluedInclSnd ((D.toBasicOpenCoverData.baseChange B').pieces)
            ((D.toBasicOpenCoverData.baseChange B').pieces i) j l) _
      rw [e₁, e₂, e₃] at key
      simp only [Units.coe_map]
      exact key

@[simp]
lemma baseChange_toBasicOpenCoverData :
    (D.baseChange (B' := B')).toBasicOpenCoverData =
      D.toBasicOpenCoverData.baseChange B' := rfl

@[simp]
lemma baseChange_unit (i j : D.index) :
    (D.baseChange (B' := B')).unit i j =
      Units.map (D.overlapMap (B' := B') i j).toMonoidHom (D.unit i j) := rfl

end BasicOpenCocycleDatum

/-! ## Constructor congruence -/

/-- **Constructor congruence for the cocycle datum**: two data with the same cover data
and pointwise-equal transition units are equal (the cocycle laws are proofs). This is
the shape of the RE-5 descent certificate after the cover-data components have been
substituted. -/
lemma BasicOpenCocycleDatum.ext_units {cov : BasicOpenCoverData C B π}
    {u₁ u₂ : ∀ i j : cov.index, Γ(relCurve C B, cov.pieces i ⊓ cov.pieces j)ˣ}
    {c₁ : Scheme.IsGluingCocycle cov.pieces u₁} {c₂ : Scheme.IsGluingCocycle cov.pieces u₂}
    (h : ∀ i j, u₁ i j = u₂ i j) :
    (⟨cov, u₁, c₁⟩ : BasicOpenCocycleDatum C B π) = ⟨cov, u₂, c₂⟩ := by
  obtain rfl : u₁ = u₂ := funext fun i => funext fun j => h i j
  rfl

end BaseChange

end AlgebraicGeometry
