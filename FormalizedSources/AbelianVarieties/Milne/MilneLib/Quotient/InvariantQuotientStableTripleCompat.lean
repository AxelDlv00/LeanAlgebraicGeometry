/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientStableTriple

/-!
# Compatibility of stable triple quotient charts

The same geometric triple intersection can be written in three cyclic orders.
This file records the resulting comparison at the fixed-section level and
gives each descended triple quotient chart a local fixed-section presentation.
The only identifications used here are equality transport on section rings and
the already constructed pairwise fixed-section presentation.
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

/-! ## Cyclic comparisons of descended triple charts -/

/-- The cyclic comparison of the fixed-section presentations descends to the
triple quotient charts. -/
noncomputable def quotientTripleRotationIso [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let m := overlap act j l
    let n := overlap act l i
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p m.U
    letI := sectionsAlgebra p n.U
    letI := sectionsAlgebra p (i.U ⊓ m.U)
    letI := sectionsAlgebra p (j.U ⊓ n.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act m.stable
    letI := sectionsMulSemiringAction act n.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i m)
    letI := sectionsMulSemiringAction act (overlap_stable act j n)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact m.stable
    letI := sectionsSMulCommClass act p hact n.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
    quotientTriple act p hact i j l ≅ quotientTriple act p hact j l i := by
  let m := overlap act j l
  let n := overlap act l i
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p m.U
  letI := sectionsAlgebra p n.U
  letI := sectionsAlgebra p (i.U ⊓ m.U)
  letI := sectionsAlgebra p (j.U ⊓ n.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act m.stable
  letI := sectionsMulSemiringAction act n.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i m)
  letI := sectionsMulSemiringAction act (overlap_stable act j n)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact m.stable
  letI := sectionsSMulCommClass act p hact n.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
  exact (fixedTripleQuotientIso act p hact i j l).symm.trans
    ((fixedTripleSourceRotationIso act p hact i j l).trans
      (fixedTripleQuotientIso act p hact j l i))

/-- The quotient rotation is compatible with the fixed-section inclusion of the
cyclically reordered triple chart. -/
@[reassoc]
theorem quotientTripleRotationIso_hom_comp_ι [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let m := overlap act j l
    let n := overlap act l i
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p m.U
    letI := sectionsAlgebra p n.U
    letI := sectionsAlgebra p (i.U ⊓ m.U)
    letI := sectionsAlgebra p (j.U ⊓ n.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act m.stable
    letI := sectionsMulSemiringAction act n.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i m)
    letI := sectionsMulSemiringAction act (overlap_stable act j n)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact m.stable
    letI := sectionsSMulCommClass act p hact n.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
    (quotientTripleRotationIso act p hact i j l).hom ≫
        quotientTripleι act p hact j l i =
      (fixedTripleQuotientIso act p hact i j l).inv ≫
        (fixedTripleSourceRotationIso act p hact i j l).hom ≫
          overlapFixedRestrictionMap act p hact j n := by
  let m := overlap act j l
  let n := overlap act l i
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p m.U
  letI := sectionsAlgebra p n.U
  letI := sectionsAlgebra p (i.U ⊓ m.U)
  letI := sectionsAlgebra p (j.U ⊓ n.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act m.stable
  letI := sectionsMulSemiringAction act n.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i m)
  letI := sectionsMulSemiringAction act (overlap_stable act j n)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact m.stable
  letI := sectionsSMulCommClass act p hact n.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
  let F := fixedTripleQuotientIso act p hact i j l
  let S := fixedTripleSourceRotationIso act p hact i j l
  let H := fixedTripleQuotientIso act p hact j l i
  change ((F.inv ≫ S.hom) ≫ H.hom) ≫
      quotientTripleι act p hact j l i =
    (F.inv ≫ S.hom) ≫ overlapFixedRestrictionMap act p hact j n
  have hι := fixedTripleQuotientIso_hom_comp_ι act p hact j l i
  exact congrArg (fun f => (F.inv ≫ S.hom) ≫ f) hι

/-! ## Cyclic coherence of quotient rotations -/

private lemma iso_cyclic_conjugation
    {C : Type u} [Category C]
    {A₁ A₂ A₃ Q₁ Q₂ Q₃ : C}
    (F₁ : A₁ ≅ Q₁) (F₂ : A₂ ≅ Q₂) (F₃ : A₃ ≅ Q₃)
    (S₁ : A₁ ≅ A₂) (S₂ : A₂ ≅ A₃) (S₃ : A₃ ≅ A₁)
    (hS : S₁ ≪≫ S₂ ≪≫ S₃ = Iso.refl A₁) :
    (F₁.symm ≪≫ S₁ ≪≫ F₂) ≪≫
        (F₂.symm ≪≫ S₂ ≪≫ F₃) ≪≫
        (F₃.symm ≪≫ S₃ ≪≫ F₁) = Iso.refl Q₁ := by
  apply Iso.ext
  simp only [Iso.trans_hom, Iso.symm_hom, Category.assoc]
  simp only [Iso.hom_inv_id_assoc]
  have hh := congrArg Iso.hom hS
  simpa using congrArg (fun f => F₁.inv ≫ f ≫ F₁.hom) hh

private lemma iso_transition_cocycle
    {C : Type u} [Category C]
    {A₁ A₂ A₃ Q₁ Q₂ Q₃ : C}
    (F₁ : A₁ ≅ Q₁) (F₂ : A₂ ≅ Q₂) (F₃ : A₃ ≅ Q₃)
    (R₁ : Q₁ ≅ Q₂) (R₂ : Q₂ ≅ Q₃) (R₃ : Q₃ ≅ Q₁)
    (hR : R₁ ≪≫ R₂ ≪≫ R₃ = Iso.refl Q₁) :
    (F₁.hom ≫ R₁.hom ≫ F₂.inv) ≫
        (F₂.hom ≫ R₂.hom ≫ F₃.inv) ≫
        (F₃.hom ≫ R₃.hom ≫ F₁.inv) = 𝟙 A₁ := by
  simp only [Category.assoc]
  have hh := congrArg Iso.hom hR
  simpa using congrArg (fun f => F₁.hom ≫ f ≫ F₁.inv) hh

/-- The three quotient-open rotations satisfy the cyclic cocycle.  This is the
coherence needed when the triple charts are used as the transition objects of
a quotient gluing datum. -/
theorem quotientTripleRotation_cocycle [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let m := overlap act j l
    let n := overlap act l i
    let o := overlap act i j
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p l.U
    letI := sectionsAlgebra p m.U
    letI := sectionsAlgebra p n.U
    letI := sectionsAlgebra p o.U
    letI := sectionsAlgebra p (i.U ⊓ m.U)
    letI := sectionsAlgebra p (j.U ⊓ n.U)
    letI := sectionsAlgebra p (l.U ⊓ o.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act l.stable
    letI := sectionsMulSemiringAction act m.stable
    letI := sectionsMulSemiringAction act n.stable
    letI := sectionsMulSemiringAction act o.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i m)
    letI := sectionsMulSemiringAction act (overlap_stable act j n)
    letI := sectionsMulSemiringAction act (overlap_stable act l o)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact l.stable
    letI := sectionsSMulCommClass act p hact m.stable
    letI := sectionsSMulCommClass act p hact n.stable
    letI := sectionsSMulCommClass act p hact o.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
    letI := sectionsSMulCommClass act p hact (overlap_stable act l o)
    quotientTripleRotationIso act p hact i j l ≪≫
      quotientTripleRotationIso act p hact j l i ≪≫
      quotientTripleRotationIso act p hact l i j = Iso.refl _ := by
  let F₁ := fixedTripleQuotientIso act p hact i j l
  let F₂ := fixedTripleQuotientIso act p hact j l i
  let F₃ := fixedTripleQuotientIso act p hact l i j
  let S₁ := fixedTripleSourceRotationIso act p hact i j l
  let S₂ := fixedTripleSourceRotationIso act p hact j l i
  let S₃ := fixedTripleSourceRotationIso act p hact l i j
  change (F₁.symm ≪≫ S₁ ≪≫ F₂) ≪≫
      (F₂.symm ≪≫ S₂ ≪≫ F₃) ≪≫
      (F₃.symm ≪≫ S₃ ≪≫ F₁) = Iso.refl _
  have hS : S₁ ≪≫ S₂ ≪≫ S₃ = Iso.refl _ := by
    simpa only [S₁, S₂, S₃] using
      (fixedTripleSourceRotation_cocycle act p hact i j l)
  exact iso_cyclic_conjugation F₁ F₂ F₃ S₁ S₂ S₃ hS

/-! ## Quotient-open transition maps -/

/-- The transition map between the two quotient-open pullbacks obtained by
rotating an ordered triple.  The pullback presentations make this a map of
the actual quotient opens, rather than only an equality between their affine
coordinate presentations. -/
noncomputable def quotientTripleTransition [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let m := overlap act j l
    let n := overlap act l i
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p m.U
    letI := sectionsAlgebra p n.U
    letI := sectionsAlgebra p (i.U ⊓ m.U)
    letI := sectionsAlgebra p (j.U ⊓ n.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act m.stable
    letI := sectionsMulSemiringAction act n.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i m)
    letI := sectionsMulSemiringAction act (overlap_stable act j n)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact m.stable
    letI := sectionsSMulCommClass act p hact n.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
    pullback (quotientOverlapι act p hact i j)
        (quotientOverlapι act p hact i l) ⟶
      pullback (quotientOverlapι act p hact j l)
        (quotientOverlapι act p hact j i) := by
  let m := overlap act j l
  let n := overlap act l i
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p m.U
  letI := sectionsAlgebra p n.U
  letI := sectionsAlgebra p (i.U ⊓ m.U)
  letI := sectionsAlgebra p (j.U ⊓ n.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act m.stable
  letI := sectionsMulSemiringAction act n.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i m)
  letI := sectionsMulSemiringAction act (overlap_stable act j n)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact m.stable
  letI := sectionsSMulCommClass act p hact n.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
  exact (pullbackOverlapIsoTriple act p hact i j l).hom ≫
    (quotientTripleRotationIso act p hact i j l).hom ≫
      (pullbackOverlapIsoTriple act p hact j l i).inv

/-- The quotient-open transitions satisfy the usual three-chart cocycle. -/
theorem quotientTripleTransition_cocycle [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let m := overlap act j l
    let n := overlap act l i
    let o := overlap act i j
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p l.U
    letI := sectionsAlgebra p m.U
    letI := sectionsAlgebra p n.U
    letI := sectionsAlgebra p o.U
    letI := sectionsAlgebra p (i.U ⊓ m.U)
    letI := sectionsAlgebra p (j.U ⊓ n.U)
    letI := sectionsAlgebra p (l.U ⊓ o.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act l.stable
    letI := sectionsMulSemiringAction act m.stable
    letI := sectionsMulSemiringAction act n.stable
    letI := sectionsMulSemiringAction act o.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i m)
    letI := sectionsMulSemiringAction act (overlap_stable act j n)
    letI := sectionsMulSemiringAction act (overlap_stable act l o)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact l.stable
    letI := sectionsSMulCommClass act p hact m.stable
    letI := sectionsSMulCommClass act p hact n.stable
    letI := sectionsSMulCommClass act p hact o.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
    letI := sectionsSMulCommClass act p hact (overlap_stable act l o)
    quotientTripleTransition act p hact i j l ≫
      quotientTripleTransition act p hact j l i ≫
      quotientTripleTransition act p hact l i j = 𝟙 _ := by
  let F₁ := pullbackOverlapIsoTriple act p hact i j l
  let F₂ := pullbackOverlapIsoTriple act p hact j l i
  let F₃ := pullbackOverlapIsoTriple act p hact l i j
  let R₁ := quotientTripleRotationIso act p hact i j l
  let R₂ := quotientTripleRotationIso act p hact j l i
  let R₃ := quotientTripleRotationIso act p hact l i j
  change (F₁.hom ≫ R₁.hom ≫ F₂.inv) ≫
      (F₂.hom ≫ R₂.hom ≫ F₃.inv) ≫
      (F₃.hom ≫ R₃.hom ≫ F₁.inv) = 𝟙 _
  have hR : R₁ ≪≫ R₂ ≪≫ R₃ = Iso.refl _ := by
    simpa only [R₁, R₂, R₃] using
      (quotientTripleRotation_cocycle act p hact i j l)
  exact iso_transition_cocycle F₁ F₂ F₃ R₁ R₂ R₃ hR

end StableAffineOpen
end StableGroupAction
end MilneLib
