/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.SectionsToDivisorsClass
import AlgebraicJacobian.Picard.DivisorFamily

/-!
# Cover independence for section-cut evaluation divisors

The evaluation divisor used by the arbitrary-scheme `PicRankOneOpen.FibrePresented`
producer is cut from an actual glued section.  Pulling such a divisor through an affine
coefficient change retains the pulled-back pointed cover, whereas the direct construction
uses the canonical pointed cover of the base-changed cocycle datum.  This file supplies the
pure refinement step between those covers: local equations cut by the same section on any
two subordinated pointed covers are `DivEq`.

The comparison unit is the datum's transition unit restricted to the common refinement.
Thus this result records construction-level divisor equality, not merely equality of Picard
classes, and assumes neither `PicRankOneOpen.FibrePresented` nor a pullback square.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory TopologicalSpace Opposite

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]

namespace BasicOpenCocycleDatum

/-- Local equations cut by one glued section are independent, up to `DivEq`, of the
subordinated pointed cover used to write them.  The witness is the intersection cover and
the restricted transition unit between the two selected datum pieces. -/
theorem sectionLocalEquations_divEq_of_same_section
    (D : BasicOpenCocycleDatum C B pi)
    (s : ↑(gluedSubmodule B D.pieces D.unit ⊤))
    (W W' : (relCurve C B).PointedCover)
    (σ σ' : relCurve C B → D.index)
    (hσ : ∀ x : relCurve C B, W.opens x ≤ D.pieces (σ x))
    (hσ' : ∀ x : relCurve C B, W'.opens x ≤ D.pieces (σ' x))
    (hreg : ∀ (j : D.index) (x : relCurve C B) (hx : x ∈ D.pieces j),
      ((relCurve C B).presheaf.germ (D.pieces j) x hx).hom (D.component s j)
        ∈ nonZeroDivisors ((relCurve C B).presheaf.stalk x)) :
    Scheme.LocalEquations.DivEq
      (D.sectionLocalEquations s W σ hσ hreg)
      (D.sectionLocalEquations s W' σ' hσ' hreg) := by
  refine ⟨W ⊓ W', (fun _ => inf_le_left), (fun _ => inf_le_right), fun x => ?_⟩
  have hleft : (W ⊓ W').opens x ≤ D.pieces (σ x) :=
    inf_le_left.trans (hσ x)
  have hright : (W ⊓ W').opens x ≤ D.pieces (σ' x) :=
    inf_le_right.trans (hσ' x)
  have hoverlap : (W ⊓ W').opens x ≤ D.pieces (σ x) ⊓ D.pieces (σ' x) :=
    le_inf hleft hright
  have htriple : (W ⊓ W').opens x ≤ ⊤ ⊓ D.pieces (σ x) ⊓ D.pieces (σ' x) :=
    le_inf (le_inf le_top hleft) hright
  refine ⟨(relCurve C B).unitsRestrict hoverlap (D.unit (σ x) (σ' x)), ?_⟩
  have key := congrArg ((relCurve C B).resHom htriple)
    (s.property (σ x) (σ' x))
  rw [map_mul] at key
  simp only [sectionLocalEquations_eqn]
  change (relCurve C B).resHom inf_le_left
      ((relCurve C B).resHom (hσ x) (D.component s (σ x))) =
    ((relCurve C B).unitsRestrict hoverlap (D.unit (σ x) (σ' x)) :
      Γ(relCurve C B, (W ⊓ W').opens x)) *
      (relCurve C B).resHom inf_le_right
        ((relCurve C B).resHom (hσ' x) (D.component s (σ' x)))
  rw [show (((relCurve C B).unitsRestrict hoverlap (D.unit (σ x) (σ' x)) :
      Γ(relCurve C B, (W ⊓ W').opens x)ˣ) : Γ(relCurve C B, (W ⊓ W').opens x)) =
        (relCurve C B).resHom hoverlap
          (D.unit (σ x) (σ' x) : Γ(relCurve C B, D.pieces (σ x) ⊓ D.pieces (σ' x)))
      from rfl, BasicOpenCocycleDatum.component, BasicOpenCocycleDatum.component]
  simp only [Scheme.resHom_resHom] at key ⊢
  exact key

end BasicOpenCocycleDatum

end AlgebraicGeometry
