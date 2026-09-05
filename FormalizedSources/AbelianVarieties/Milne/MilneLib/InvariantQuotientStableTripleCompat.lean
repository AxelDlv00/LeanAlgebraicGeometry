/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientStableTriple

/-!
# Compatibility of stable triple quotient charts

The same geometric triple intersection can be written in three cyclic orders.
This file records the resulting comparison at the fixed-section level and
transports it to the descended open quotient charts.  The only identifications
used here are equality transport on section rings and the already constructed
pairwise fixed-section presentation.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry Topology

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-! ## Equality transport on fixed sections -/

omit [X.IsSeparated] in
/-- Equality transport on section algebras composes along a chain of equal
opens.  The proof is by equality elimination, so the result is independent of
the chosen equality witnesses. -/
theorem sectionsAlgEquivOfEq_trans
    (p : X ⟶ Spec (CommRingCat.of k))
    {U V W : X.Opens} (eUV : U = V) (eVW : V = W) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    letI := sectionsAlgebra p W
    (sectionsAlgEquivOfEq p eUV).trans (sectionsAlgEquivOfEq p eVW) =
      sectionsAlgEquivOfEq p (eUV.trans eVW) := by
  subst V
  subst W
  rfl

/-- The fixed-subalgebra equivalence induced by equality transport. -/
noncomputable def fixedSectionsAlgEquivOfEq
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    {U V : X.Opens} (hU : IsStableOpen act U) (hV : IsStableOpen act V)
    (e : U = V) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    letI := sectionsMulSemiringAction act hU
    letI := sectionsMulSemiringAction act hV
    letI := sectionsSMulCommClass act p hact hU
    letI := sectionsSMulCommClass act p hact hV
    FixedPoints.subalgebra k Γ(X, U) G ≃ₐ[k]
      FixedPoints.subalgebra k Γ(X, V) G := by
  letI := sectionsAlgebra p U
  letI := sectionsAlgebra p V
  letI := sectionsMulSemiringAction act hU
  letI := sectionsMulSemiringAction act hV
  letI := sectionsSMulCommClass act p hact hU
  letI := sectionsSMulCommClass act p hact hV
  exact InvariantLocalization.equivariantFixedAlgEquiv
    (sectionsAlgEquivOfEq p e)
    (sectionsAlgEquivOfEq_equivariant act p hU hV e)

omit [X.IsSeparated] in
/-- Fixed-section equality transports compose. -/
theorem fixedSectionsAlgEquivOfEq_trans
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    {U V W : X.Opens}
    (hU : IsStableOpen act U) (hV : IsStableOpen act V)
    (hW : IsStableOpen act W)
    (eUV : U = V) (eVW : V = W) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    letI := sectionsAlgebra p W
    letI := sectionsMulSemiringAction act hU
    letI := sectionsMulSemiringAction act hV
    letI := sectionsMulSemiringAction act hW
    letI := sectionsSMulCommClass act p hact hU
    letI := sectionsSMulCommClass act p hact hV
    letI := sectionsSMulCommClass act p hact hW
    (fixedSectionsAlgEquivOfEq act p hact hU hV eUV).trans
      (fixedSectionsAlgEquivOfEq act p hact hV hW eVW) =
      fixedSectionsAlgEquivOfEq act p hact hU hW (eUV.trans eVW) := by
  subst V
  subst W
  rfl

/-! ## Fixed spectra -/

/-- The contravariant spectrum isomorphism associated to an equality of stable
opens. -/
noncomputable def fixedSectionsSpecIsoOfEq
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    {U V : X.Opens} (hU : IsStableOpen act U) (hV : IsStableOpen act V)
    (e : U = V) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    letI := sectionsMulSemiringAction act hU
    letI := sectionsMulSemiringAction act hV
    letI := sectionsSMulCommClass act p hact hU
    letI := sectionsSMulCommClass act p hact hV
    Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, V) G)) ≅
      Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, U) G)) := by
  letI := sectionsAlgebra p U
  letI := sectionsAlgebra p V
  letI := sectionsMulSemiringAction act hU
  letI := sectionsMulSemiringAction act hV
  letI := sectionsSMulCommClass act p hact hU
  letI := sectionsSMulCommClass act p hact hV
  exact Scheme.Spec.mapIso
    (fixedSectionsAlgEquivOfEq act p hact hU hV e).toRingEquiv.toCommRingCatIso.op

omit [X.IsSeparated] in
/-- Equality transport on a fixed spectrum is the identity when both opens are
the same. -/
theorem fixedSectionsSpecIsoOfEq_rfl
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    {U : X.Opens} (hU hV : IsStableOpen act U) :
    letI := sectionsAlgebra p U
    letI := sectionsMulSemiringAction act hU
    letI := sectionsSMulCommClass act p hact hU
    fixedSectionsSpecIsoOfEq act p hact hU hV (rfl : U = U) =
      Iso.refl _ := by
  have h : hV = hU := Subsingleton.elim _ _
  cases h
  apply Iso.ext
  rw [fixedSectionsSpecIsoOfEq]
  change Spec.map (CommRingCat.ofHom
      (fixedSectionsAlgEquivOfEq act p hact hU hU
        (rfl : U = U)).toRingEquiv.toRingHom) = 𝟙 _
  rw [← Spec.map_id]
  congr 1

omit [X.IsSeparated] in
/-- Three equality transports of fixed spectra compose to the identity. -/
theorem fixedSectionsSpecIsoOfEq_cycle
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    {U V W : X.Opens}
    (hU : IsStableOpen act U) (hV : IsStableOpen act V)
    (hW : IsStableOpen act W)
    (eUV : U = V) (eVW : V = W) (eWU : W = U) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    letI := sectionsAlgebra p W
    letI := sectionsMulSemiringAction act hU
    letI := sectionsMulSemiringAction act hV
    letI := sectionsMulSemiringAction act hW
    letI := sectionsSMulCommClass act p hact hU
    letI := sectionsSMulCommClass act p hact hV
    letI := sectionsSMulCommClass act p hact hW
    fixedSectionsSpecIsoOfEq act p hact hV hU eUV.symm ≪≫
      fixedSectionsSpecIsoOfEq act p hact hW hV eVW.symm ≪≫
      fixedSectionsSpecIsoOfEq act p hact hU hW eWU.symm = Iso.refl _ := by
  cases eUV
  cases eVW
  cases eWU
  have hV' : hV = hU := Subsingleton.elim _ _
  have hW' : hW = hU := Subsingleton.elim _ _
  cases hV'
  cases hW'
  rw [fixedSectionsSpecIsoOfEq_rfl]
  simp

omit [X.IsSeparated] in
/-- The fixed-spectrum transports compose in the contravariant order. -/
theorem fixedSectionsSpecIsoOfEq_trans
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    {U V W : X.Opens}
    (hU : IsStableOpen act U) (hV : IsStableOpen act V)
    (hW : IsStableOpen act W)
    (eUV : U = V) (eVW : V = W) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    letI := sectionsAlgebra p W
    letI := sectionsMulSemiringAction act hU
    letI := sectionsMulSemiringAction act hV
    letI := sectionsMulSemiringAction act hW
    letI := sectionsSMulCommClass act p hact hU
    letI := sectionsSMulCommClass act p hact hV
    letI := sectionsSMulCommClass act p hact hW
    fixedSectionsSpecIsoOfEq act p hact hV hW eVW ≪≫
      fixedSectionsSpecIsoOfEq act p hact hU hV eUV =
      fixedSectionsSpecIsoOfEq act p hact hU hW (eUV.trans eVW) := by
  let e1 := fixedSectionsAlgEquivOfEq act p hact hU hV eUV
  let e2 := fixedSectionsAlgEquivOfEq act p hact hV hW eVW
  have he : e1.trans e2 =
      fixedSectionsAlgEquivOfEq act p hact hU hW (eUV.trans eVW) :=
    fixedSectionsAlgEquivOfEq_trans act p hact hU hV hW eUV eVW
  change Scheme.Spec.mapIso e2.toRingEquiv.toCommRingCatIso.op ≪≫
      Scheme.Spec.mapIso e1.toRingEquiv.toCommRingCatIso.op =
      Scheme.Spec.mapIso
        (fixedSectionsAlgEquivOfEq act p hact hU hW
          (eUV.trans eVW)).toRingEquiv.toCommRingCatIso.op
  have hop :
      e2.toRingEquiv.toCommRingCatIso.op ≪≫
          e1.toRingEquiv.toCommRingCatIso.op =
        (e1.trans e2).toRingEquiv.toCommRingCatIso.op := by
    rfl
  rw [← Scheme.Spec.mapIso_trans, hop, he]

/-! ## Triple quotient presentations -/

/-- The right-associated triple open equals the overlap with the second and
third charts bundled into one stable affine chart. -/
theorem quotientTripleOpen_eq_quotientOverlapOpen
    [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    quotientTripleOpen act p hact i j l =
      quotientOverlapOpen act p hact i (overlap act j l) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  unfold quotientTripleOpen quotientOverlapOpen tripleCoordinateOpen
    overlapCoordinateOpen
  congr 1
  ac_rfl

/-! ## A fixed-section presentation of a triple quotient -/

/-- The triple quotient chart is presented by the fixed sections of the
right-associated source triple. -/
noncomputable def fixedTripleQuotientIso [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let m := overlap act j l
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p (i.U ⊓ m.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i m)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
    Spec (CommRingCat.of
      (FixedPoints.subalgebra k Γ(X, i.U ⊓ m.U) G)) ≅
      quotientTriple act p hact i j l := by
  let m := overlap act j l
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p m.U
  letI := sectionsAlgebra p (i.U ⊓ m.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act m.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i m)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact m.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
  exact fixedOverlapQuotientIso act p hact i m ≪≫
    (Spec (CommRingCat.of
      (FixedPoints.subalgebra k Γ(X, i.U) G))).isoOfEq
      (quotientTripleOpen_eq_quotientOverlapOpen act p hact i j l).symm

@[reassoc (attr := simp)]
theorem fixedTripleQuotientIso_hom_comp_ι [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let m := overlap act j l
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p (i.U ⊓ m.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i m)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
    (fixedTripleQuotientIso act p hact i j l).hom ≫
        quotientTripleι act p hact i j l =
      overlapFixedRestrictionMap act p hact i m := by
  let m := overlap act j l
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p m.U
  letI := sectionsAlgebra p (i.U ⊓ m.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act m.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i m)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact m.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
  rw [fixedTripleQuotientIso, Iso.trans_hom]
  change ((fixedOverlapQuotientIso act p hact i m).hom ≫
      ((Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U) G))).isoOfEq
        (quotientTripleOpen_eq_quotientOverlapOpen act p hact i j l).symm).hom) ≫
      (quotientTripleOpen act p hact i j l).ι = _
  have hι := Scheme.isoOfEq_hom_ι
    (Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U) G)))
    (quotientTripleOpen_eq_quotientOverlapOpen act p hact i j l).symm
  calc
    _ = (fixedOverlapQuotientIso act p hact i m).hom ≫
        (((Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U) G))).isoOfEq
          (quotientTripleOpen_eq_quotientOverlapOpen act p hact i j l).symm).hom ≫
          (quotientTripleOpen act p hact i j l).ι) := Category.assoc _ _ _
    _ = (fixedOverlapQuotientIso act p hact i m).hom ≫
        (quotientOverlapOpen act p hact i m).ι := by
      congr 1
    _ = overlapFixedRestrictionMap act p hact i m :=
      fixedOverlapQuotientIso_hom_comp_ι act p hact i m

/-! ## Cyclic source comparison -/

/-- The right-associated source triples in cyclic orders are canonically
isomorphic on fixed-section spectra.  The orientation is from the `i`-source
to the `j`-source. -/
noncomputable def fixedTripleSourceRotationIso [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let Pi := i.U ⊓ (j.U ⊓ l.U)
    let Pj := j.U ⊓ (l.U ⊓ i.U)
    letI := sectionsAlgebra p Pi
    letI := sectionsAlgebra p Pj
    let hPi : IsStableOpen act Pi := by
      intro g
      simp only [Pi, Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]
    let hPj : IsStableOpen act Pj := by
      intro g
      simp only [Pj, Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]
    letI := sectionsMulSemiringAction act hPi
    letI := sectionsMulSemiringAction act hPj
    letI := sectionsSMulCommClass act p hact hPi
    letI := sectionsSMulCommClass act p hact hPj
    Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, Pi) G)) ≅
      Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, Pj) G)) := by
  let Pi := i.U ⊓ (j.U ⊓ l.U)
  let Pj := j.U ⊓ (l.U ⊓ i.U)
  let hPi : IsStableOpen act Pi := by
    intro g
    simp only [Pi, Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]
  let hPj : IsStableOpen act Pj := by
    intro g
    simp only [Pj, Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]
  letI := sectionsAlgebra p Pi
  letI := sectionsAlgebra p Pj
  letI := sectionsMulSemiringAction act hPi
  letI := sectionsMulSemiringAction act hPj
  letI := sectionsSMulCommClass act p hact hPi
  letI := sectionsSMulCommClass act p hact hPj
  let e : Pi = Pj := by
    dsimp [Pi, Pj]
    ac_rfl
  exact fixedSectionsSpecIsoOfEq act p hact hPj hPi e.symm

/- The three source rotations compose to the identity. -/
theorem fixedTripleSourceRotation_cocycle [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let Pi := i.U ⊓ (j.U ⊓ l.U)
    let Pj := j.U ⊓ (l.U ⊓ i.U)
    let Pk := l.U ⊓ (i.U ⊓ j.U)
    letI := sectionsAlgebra p Pi
    letI := sectionsAlgebra p Pj
    letI := sectionsAlgebra p Pk
    let hPi : IsStableOpen act Pi := by
      intro g
      simp only [Pi, Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]
    let hPj : IsStableOpen act Pj := by
      intro g
      simp only [Pj, Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]
    let hPk : IsStableOpen act Pk := by
      intro g
      simp only [Pk, Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]
    letI := sectionsMulSemiringAction act hPi
    letI := sectionsMulSemiringAction act hPj
    letI := sectionsMulSemiringAction act hPk
    letI := sectionsSMulCommClass act p hact hPi
    letI := sectionsSMulCommClass act p hact hPj
    letI := sectionsSMulCommClass act p hact hPk
    fixedTripleSourceRotationIso act p hact i j l ≪≫
      fixedTripleSourceRotationIso act p hact j l i ≪≫
      fixedTripleSourceRotationIso act p hact l i j = Iso.refl _ := by
  dsimp
  let Pi := i.U ⊓ (j.U ⊓ l.U)
  let Pj := j.U ⊓ (l.U ⊓ i.U)
  let Pk := l.U ⊓ (i.U ⊓ j.U)
  let hPi : IsStableOpen act Pi := by
    intro g
    simp only [Pi, Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]
  let hPj : IsStableOpen act Pj := by
    intro g
    simp only [Pj, Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]
  let hPk : IsStableOpen act Pk := by
    intro g
    simp only [Pk, Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]
  letI := sectionsAlgebra p Pi
  letI := sectionsAlgebra p Pj
  letI := sectionsAlgebra p Pk
  letI := sectionsMulSemiringAction act hPi
  letI := sectionsMulSemiringAction act hPj
  letI := sectionsMulSemiringAction act hPk
  letI := sectionsSMulCommClass act p hact hPi
  letI := sectionsSMulCommClass act p hact hPj
  letI := sectionsSMulCommClass act p hact hPk
  let eij : Pi = Pj := by
    dsimp [Pi, Pj]
    ac_rfl
  let ejk : Pj = Pk := by
    dsimp [Pj, Pk]
    ac_rfl
  let eki : Pk = Pi := by
    dsimp [Pk, Pi]
    ac_rfl
  have hcycle := fixedSectionsSpecIsoOfEq_cycle act p hact
    hPi hPj hPk eij ejk eki
  simpa [fixedTripleSourceRotationIso] using hcycle

end StableAffineOpen
end StableGroupAction
end MilneLib
