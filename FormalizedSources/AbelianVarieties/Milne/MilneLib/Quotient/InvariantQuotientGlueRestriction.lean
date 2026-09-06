/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientStableTripleCompat
import MilneLib.Quotient.QuotientGlueData

/-!
# Fixed-section restriction squares for triple-overlap gluing

This module supplies the restriction/naturality bridge needed by the cyclic
triple transition.  The maps are spectra of the restrictions on fixed section
algebras; no quotient-existence assertion is made here.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry Topology

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-! ## Generic fixed-section restriction maps -/

/-- The spectrum map induced by restricting sections from a stable open `U` to
the smaller stable open `V`.  The explicit local instances keep the action and
the fixed subalgebras tied to the displayed stability witnesses. -/
noncomputable def fixedSectionsRestrictionMap
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : forall g : G, (act g).hom ≫ p = p)
    {U V : X.Opens} (hU : IsStableOpen act U) (hV : IsStableOpen act V)
    (hVU : V <= U) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    letI := sectionsMulSemiringAction act hU
    letI := sectionsMulSemiringAction act hV
    letI := sectionsSMulCommClass act p hact hU
    letI := sectionsSMulCommClass act p hact hV
    Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, V) G)) ⟶
      Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, U) G)) := by
  letI := sectionsAlgebra p U
  letI := sectionsAlgebra p V
  letI := sectionsMulSemiringAction act hU
  letI := sectionsMulSemiringAction act hV
  letI := sectionsSMulCommClass act p hact hU
  letI := sectionsSMulCommClass act p hact hV
  exact Spec.map (CommRingCat.ofHom
    (InvariantLocalization.equivariantFixedRingHom
      (k := k) (G := G) (sectionsRestrictionAlgHom p hVU).toRingHom
      (sectionsRestrictionAlgHom_equivariant act p hact hU hV hVU)))

@[reassoc]
theorem fixedSectionsRestrictionMap_comp
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : forall g : G, (act g).hom ≫ p = p)
    {U V W : X.Opens}
    (hU : IsStableOpen act U) (hV : IsStableOpen act V)
    (hW : IsStableOpen act W) (hVU : V <= U) (hWV : W <= V) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    letI := sectionsAlgebra p W
    letI := sectionsMulSemiringAction act hU
    letI := sectionsMulSemiringAction act hV
    letI := sectionsMulSemiringAction act hW
    letI := sectionsSMulCommClass act p hact hU
    letI := sectionsSMulCommClass act p hact hV
    letI := sectionsSMulCommClass act p hact hW
    fixedSectionsRestrictionMap act p hact hV hW hWV ≫
        fixedSectionsRestrictionMap act p hact hU hV hVU =
      fixedSectionsRestrictionMap act p hact hU hW (hWV.trans hVU) := by
  letI := sectionsAlgebra p U
  letI := sectionsAlgebra p V
  letI := sectionsAlgebra p W
  letI := sectionsMulSemiringAction act hU
  letI := sectionsMulSemiringAction act hV
  letI := sectionsMulSemiringAction act hW
  letI := sectionsSMulCommClass act p hact hU
  letI := sectionsSMulCommClass act p hact hV
  letI := sectionsSMulCommClass act p hact hW
  rw [fixedSectionsRestrictionMap, fixedSectionsRestrictionMap,
    fixedSectionsRestrictionMap, ← Spec.map_comp, ← CommRingCat.ofHom_comp]
  apply congrArg Spec.map
  apply CommRingCat.hom_ext
  rw [InvariantLocalization.equivariantFixedRingHom_comp]
  dsimp [InvariantLocalization.equivariantFixedRingHom, RingHom.codRestrict,
    CategoryTheory.ConcreteCategory.ofHom, CategoryTheory.ConcreteCategory.hom]
  apply RingHom.ext
  intro x
  apply Subtype.ext
  change (X.presheaf.map (homOfLE hWV).op).hom
      ((X.presheaf.map (homOfLE hVU).op).hom (x : Γ(X, U))) =
    (X.presheaf.map (homOfLE (hWV.trans hVU)).op).hom (x : Γ(X, U))
  rw [← CommRingCat.comp_apply, ← X.presheaf.map_comp]
  congr 1

/-- Naturality of fixed-section restriction under equality transport.  If the
two source opens and the two target opens are identified, the two resulting
spectrum paths agree.  Equality elimination makes this independent of all
chosen witnesses and inclusion proofs. -/
theorem fixedSectionsRestrictionMap_naturality
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : forall g : G, (act g).hom ≫ p = p)
    {P Q A B : X.Opens}
    (hP : IsStableOpen act P) (hQ : IsStableOpen act Q)
    (hA : IsStableOpen act A) (hB : IsStableOpen act B)
    (eP : P = Q) (eA : A = B)
    (hPA : P <= A) (hQB : Q <= B) :
    letI := sectionsAlgebra p P
    letI := sectionsAlgebra p Q
    letI := sectionsAlgebra p A
    letI := sectionsAlgebra p B
    letI := sectionsMulSemiringAction act hP
    letI := sectionsMulSemiringAction act hQ
    letI := sectionsMulSemiringAction act hA
    letI := sectionsMulSemiringAction act hB
    letI := sectionsSMulCommClass act p hact hP
    letI := sectionsSMulCommClass act p hact hQ
    letI := sectionsSMulCommClass act p hact hA
    letI := sectionsSMulCommClass act p hact hB
    fixedSectionsRestrictionMap act p hact hA hP hPA ≫
        (fixedSectionsSpecIsoOfEq act p hact hB hA eA.symm).hom =
      (fixedSectionsSpecIsoOfEq act p hact hQ hP eP.symm).hom ≫
        fixedSectionsRestrictionMap act p hact hB hQ hQB := by
  letI := sectionsAlgebra p P
  letI := sectionsAlgebra p Q
  letI := sectionsAlgebra p A
  letI := sectionsAlgebra p B
  letI := sectionsMulSemiringAction act hP
  letI := sectionsMulSemiringAction act hQ
  letI := sectionsMulSemiringAction act hA
  letI := sectionsMulSemiringAction act hB
  letI := sectionsSMulCommClass act p hact hP
  letI := sectionsSMulCommClass act p hact hQ
  letI := sectionsSMulCommClass act p hact hA
  letI := sectionsSMulCommClass act p hact hB
  cases eP
  cases eA
  have hQ' : hQ = hP := Subsingleton.elim _ _
  have hB' : hB = hA := Subsingleton.elim _ _
  cases hQ'
  cases hB'
  have hPA' : hPA = hQB := Subsingleton.elim _ _
  cases hPA'
  simp only [fixedSectionsRestrictionMap, fixedSectionsSpecIsoOfEq,
    fixedSectionsAlgEquivOfEq, Functor.mapIso_hom, Iso.op_hom,
    Scheme.Spec_map, Quiver.Hom.unop_op]
  rw [← Spec.map_comp, ← Spec.map_comp]
  apply congrArg Spec.map
  apply CommRingCat.hom_ext
  apply RingHom.ext
  intro x
  simp [InvariantLocalization.equivariantFixedAlgEquiv,
    InvariantLocalization.equivariantFixedRingEquiv,
    InvariantLocalization.equivariantFixedRingHom,
    sectionsAlgEquivOfEq, sectionsRestrictionAlgHom]
  rfl

/-! ## Triple-to-overlap restriction bridges -/

/-- The left leg of a descended triple chart is the fixed-section restriction
map for the corresponding source opens, followed by the fixed overlap
presentation.  This is the quotient-level restriction square used by the
triple transition. -/
@[reassoc]
theorem tripleToOverlapLeft_eq_fixedRestriction [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let m := overlap act j l
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p m.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsAlgebra p (i.U ⊓ m.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act m.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsMulSemiringAction act (overlap_stable act i m)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact m.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
    let hPA : i.U ⊓ m.U ≤ i.U ⊓ j.U := by
      dsimp [m, overlap]
      exact inf_le_inf_left _ inf_le_left
    tripleToOverlapLeft act p hact i j l =
      (fixedTripleQuotientIso act p hact i j l).inv ≫
        fixedSectionsRestrictionMap act p hact
          (overlap_stable act i j) (overlap_stable act i m) hPA ≫
        (fixedOverlapQuotientIso act p hact i j).hom := by
  let m := overlap act j l
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p m.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsAlgebra p (i.U ⊓ m.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act m.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsMulSemiringAction act (overlap_stable act i m)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact m.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
  let hPA : i.U ⊓ m.U ≤ i.U ⊓ j.U := by
    dsimp [m, overlap]
    exact inf_le_inf_left _ inf_le_left
  apply (cancel_mono (quotientOverlapι act p hact i j)).1
  rw [tripleToOverlapLeft_fac]
  simp only [Category.assoc, fixedOverlapQuotientIso_hom_comp_ι]
  apply (cancel_epi (fixedTripleQuotientIso act p hact i j l).hom).1
  simp only [Category.assoc, Iso.hom_inv_id_assoc,
    fixedTripleQuotientIso_hom_comp_ι]
  have hcomp := fixedSectionsRestrictionMap_comp act p hact
    (U := i.U) (V := i.U ⊓ j.U) (W := i.U ⊓ m.U)
    i.stable (overlap_stable act i j) (overlap_stable act i m)
    (show i.U ⊓ j.U ≤ i.U from inf_le_left) hPA
  simpa [m, overlap, fixedSectionsRestrictionMap, overlapFixedRestrictionMap] using hcomp.symm

/-- The right leg of a cyclically reordered descended triple chart is the
fixed-section restriction map for the reordered source opens. -/
@[reassoc]
theorem tripleToOverlapRight_eq_fixedRestriction [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let n := overlap act l i
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p l.U
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p n.U
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (j.U ⊓ n.U)
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act l.stable
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act n.stable
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act j n)
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact l.stable
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact n.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
    let hQB : j.U ⊓ n.U ≤ j.U ⊓ i.U := by
      dsimp [n, overlap]
      exact inf_le_inf_left _ inf_le_right
    tripleToOverlapRight act p hact j l i =
      (fixedTripleQuotientIso act p hact j l i).inv ≫
        fixedSectionsRestrictionMap act p hact
          (overlap_stable act j i) (overlap_stable act j n) hQB ≫
        (fixedOverlapQuotientIso act p hact j i).hom := by
  let n := overlap act l i
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p l.U
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p n.U
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsAlgebra p (j.U ⊓ n.U)
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act l.stable
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act n.stable
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsMulSemiringAction act (overlap_stable act j n)
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact l.stable
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact n.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
  let hQB : j.U ⊓ n.U ≤ j.U ⊓ i.U := by
    dsimp [n, overlap]
    exact inf_le_inf_left _ inf_le_right
  apply (cancel_mono (quotientOverlapι act p hact j i)).1
  rw [tripleToOverlapRight_fac]
  simp only [Category.assoc, fixedOverlapQuotientIso_hom_comp_ι]
  apply (cancel_epi (fixedTripleQuotientIso act p hact j l i).hom).1
  simp only [Category.assoc, Iso.hom_inv_id_assoc,
    fixedTripleQuotientIso_hom_comp_ι]
  have hcomp := fixedSectionsRestrictionMap_comp act p hact
    (U := j.U) (V := j.U ⊓ i.U) (W := j.U ⊓ n.U)
    j.stable (overlap_stable act j i) (overlap_stable act j n)
    (show j.U ⊓ i.U ≤ j.U from inf_le_left) hQB
  simpa [n, overlap, fixedSectionsRestrictionMap, overlapFixedRestrictionMap] using hcomp.symm

/-! ## Quotient-level cyclic overlap equation -/

/-- The two quotient-overlap legs of a cyclic triple agree after the canonical
fixed-section transition.  This is the chart-level equation underlying the
pullback `t_fac` theorem above. -/
@[reassoc]
theorem tripleToOverlapLeft_comp_quotientOverlapSwapIso [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let m := overlap act j l
    let n := overlap act l i
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p m.U
    letI := sectionsAlgebra p n.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ m.U)
    letI := sectionsAlgebra p (j.U ⊓ n.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act m.stable
    letI := sectionsMulSemiringAction act n.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i m)
    letI := sectionsMulSemiringAction act (overlap_stable act j n)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact m.stable
    letI := sectionsSMulCommClass act p hact n.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
    tripleToOverlapLeft act p hact i j l ≫
        (quotientOverlapSwapIso act p hact i j).hom =
      (quotientTripleRotationIso act p hact i j l).hom ≫
        tripleToOverlapRight act p hact j l i := by
  let m := overlap act j l
  let n := overlap act l i
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p m.U
  letI := sectionsAlgebra p n.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsAlgebra p (i.U ⊓ m.U)
  letI := sectionsAlgebra p (j.U ⊓ n.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act m.stable
  letI := sectionsMulSemiringAction act n.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsMulSemiringAction act (overlap_stable act i m)
  letI := sectionsMulSemiringAction act (overlap_stable act j n)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact m.stable
  letI := sectionsSMulCommClass act p hact n.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
  let hPA : i.U ⊓ m.U ≤ i.U ⊓ j.U := by
    dsimp [m, overlap]
    exact inf_le_inf_left _ inf_le_left
  let hQB : j.U ⊓ n.U ≤ j.U ⊓ i.U := by
    dsimp [n, overlap]
    exact inf_le_inf_left _ inf_le_right
  let eP : i.U ⊓ m.U = j.U ⊓ n.U := by
    dsimp [m, n, overlap]
    ac_rfl
  let eA : i.U ⊓ j.U = j.U ⊓ i.U := inf_comm _ _
  apply (cancel_mono (quotientOverlapι act p hact j i)).1
  rw [Category.assoc, quotientOverlapSwapIso_hom_comp_ι]
  rw [tripleToOverlapLeft_eq_fixedRestriction]
  simp only [Category.assoc, tripleToOverlapRight_fac]
  rw [quotientTripleRotationIso_hom_comp_ι]
  simp only [Category.assoc, Iso.hom_inv_id_assoc]
  rw [← fixedOverlapIso_hom_comp_leftFixedRestrictionMap]
  have hnat := fixedSectionsRestrictionMap_naturality act p hact
    (P := i.U ⊓ m.U) (Q := j.U ⊓ n.U)
    (A := i.U ⊓ j.U) (B := j.U ⊓ i.U)
    (overlap_stable act i m) (overlap_stable act j n)
    (overlap_stable act i j) (overlap_stable act j i)
    eP eA hPA hQB
  have hcomp := fixedSectionsRestrictionMap_comp act p hact
    (U := j.U) (V := j.U ⊓ i.U) (W := j.U ⊓ n.U)
    j.stable (overlap_stable act j i) (overlap_stable act j n)
    (show j.U ⊓ i.U ≤ j.U from inf_le_left) hQB
  have hcomp' :
      fixedSectionsRestrictionMap act p hact
          (overlap_stable act j i) (overlap_stable act j n) hQB ≫
        overlapFixedRestrictionMap act p hact j i =
      overlapFixedRestrictionMap act p hact j n := by
    simpa [overlapFixedRestrictionMap, fixedSectionsRestrictionMap] using hcomp
  have hIso :
      (fixedOverlapIso act p hact i j).hom =
        (fixedSectionsSpecIsoOfEq act p hact
          (overlap_stable act j i) (overlap_stable act i j) eA.symm).hom := by
    rfl
  have htransport := congrArg (fun f =>
      (fixedTripleQuotientIso act p hact i j l).inv ≫ f ≫
        overlapFixedRestrictionMap act p hact j i) hnat
  simp only [Category.assoc] at htransport
  rw [hcomp'] at htransport
  rw [hIso]
  convert htransport using 1 <;>
    simp [fixedTripleSourceRotationIso, fixedSectionsSpecIsoOfEq,
      fixedSectionsAlgEquivOfEq, overlapFixedSectionsAlgEquiv,
      overlapSectionsAlgEquiv, overlapFixedRestrictionMap,
      fixedSectionsRestrictionMap, Category.assoc, n] <;> rfl

/-- The cyclic triple transition has the factorization required by
`InvariantQuotientCrossChartDatum.t_fac`: restricting the transition to the
second pullback leg agrees with first restricting to the left overlap and then
reversing that overlap. -/
@[reassoc]
theorem quotientTripleTransition_t_fac [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    let m := overlap act j l
    let n := overlap act l i
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p m.U
    letI := sectionsAlgebra p n.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ m.U)
    letI := sectionsAlgebra p (j.U ⊓ n.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act m.stable
    letI := sectionsMulSemiringAction act n.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i m)
    letI := sectionsMulSemiringAction act (overlap_stable act j n)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact m.stable
    letI := sectionsSMulCommClass act p hact n.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
    quotientTripleTransition act p hact i j l ≫
        pullback.snd (quotientOverlapι act p hact j l)
          (quotientOverlapι act p hact j i) =
      pullback.fst (quotientOverlapι act p hact i j)
          (quotientOverlapι act p hact i l) ≫
        (quotientOverlapSwapIso act p hact i j).hom := by
  let m := overlap act j l
  let n := overlap act l i
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p m.U
  letI := sectionsAlgebra p n.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsAlgebra p (i.U ⊓ m.U)
  letI := sectionsAlgebra p (j.U ⊓ n.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act m.stable
  letI := sectionsMulSemiringAction act n.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsMulSemiringAction act (overlap_stable act i m)
  letI := sectionsMulSemiringAction act (overlap_stable act j n)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact m.stable
  letI := sectionsSMulCommClass act p hact n.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact (overlap_stable act i m)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j n)
  simp only [quotientTripleTransition, Category.assoc]
  rw [pullbackOverlapIsoTriple_inv_snd]
  rw [← tripleToOverlapLeft_comp_quotientOverlapSwapIso]
  rw [← Category.assoc, pullbackOverlapIsoTriple_hom_fst]

end StableAffineOpen
end StableGroupAction
end MilneLib
