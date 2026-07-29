/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffAbel
import AlgebraicJacobian.Picard.DivisorFamilyFieldDegree

/-!
# The degree ledger on the WIDENED adaptation: the algebraic half of the port

`Picard/DivisorFamilyAffAbel.lean` leaves exactly one obligation, `hdegAff` — the widened Abel
value of a degree-`n` widened class has degree `n` at every field point — and names its price:
port four lemmas of `Picard/DivisorFamilyFieldDegree.lean` from `DivisorAdaptation` to
`AffAdaptation`.  That price was itself a correction: an earlier version of the row called the
port *obstructed* by the pinned-pair covering, which is false (the step in question outputs only
"every point lies in some piece", a structure **field** of `AffCoverData`).

This file executes the part of the port that is pure module algebra over the field, and it is
deliberately a verbatim transcription: same statements, same proofs, `AffAdaptation` in place of
`DivisorAdaptation`.  Nothing here is new mathematics — the point is that nothing *had* to be,
which is what the reprice predicted and what a transcription either confirms or refutes.

## Why these two and not all four

`finrank_glued_eq_sum_of_separated` and its input `gluedSubmodule_eq_top_of_separated` are the
two steps that mention **no** geometry at all: they quantify over `A.index`, `A.colength`,
`A.ovlColength`, `A.chartProd`, `A.Glued` and the two overlap-restriction maps, every one of
which `AffAdaptation` carries under the same name.  The remaining two
(`finrank_colength_eq_sum`, `coeffAt_eq_zero_of_isUnit_germ`) are about the *presentation
divisor* and need the geometric side of the transcription; they are not attempted here, and
`hdegAff` therefore remains open.  Read this as one third of a named residue discharged, not as
the ledger.

## Main declarations

* `AlgebraicGeometry.AffAdaptation.toOvlLeft_self_eq_toOvlRight_self` — the diagonal collapse.
* `AlgebraicGeometry.AffAdaptation.gluedSubmodule_eq_top_of_separated` — separation makes the
  equalizer the whole product.
* `AlgebraicGeometry.AffAdaptation.gluedTopEquiv` — that identification as a `LinearEquiv`.
* `AlgebraicGeometry.AffAdaptation.finrank_glued_eq_sum_of_separated` — Mayer–Vietoris finrank
  additivity with no overlap correction, on the widened adaptation over a field.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161); pin in-file. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Module

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {K : Type u} [Field K] [Algebra k K]

namespace AffAdaptation

variable {D : AffCoverData C K} {d : (relCurve C K).LocalEquations} (A : AffAdaptation D d)

/-- On the diagonal the two overlap-restriction maps coincide: the two `≤`-witnesses
`pieces i ⊓ pieces i ≤ pieces i` are definitionally equal by proof irrelevance. -/
lemma toOvlLeft_self_eq_toOvlRight_self (i : D.index) :
    A.toOvlLeft i i = A.toOvlRight i i :=
  rfl

/-- **Support separation collapses the equalizer to the whole product**, widened.  If the
overlap colength modules vanish off the diagonal then every element of `∏ⱼ colength j` satisfies
the equalizer condition. -/
lemma gluedSubmodule_eq_top_of_separated
    (hsep : ∀ i j : D.index, i ≠ j → Subsingleton (A.ovlColength i j)) :
    A.gluedSubmodule = ⊤ := by
  refine eq_top_iff.mpr fun s _ => ?_
  rw [mem_gluedSubmodule_iff]
  rintro ⟨i, j⟩
  by_cases hij : i = j
  · subst hij
    exact congrFun (congrArg (fun f : A.colength i →ₐ[K] A.ovlColength i i => (f : _ → _))
      (A.toOvlLeft_self_eq_toOvlRight_self i)) (s i)
  · haveI := hsep i j hij
    exact Subsingleton.elim _ _

/-- The equalizer as the whole product, when the glued submodule is `⊤`. -/
noncomputable def gluedTopEquiv (h : A.gluedSubmodule = ⊤) : A.Glued ≃ₗ[K] A.chartProd :=
  (LinearEquiv.ofEq _ _ h).trans Submodule.topEquiv

/-- **The support-separated colength↔degree bridge, algebraic half — on the WIDENED
adaptation.**  When the overlaps vanish, the `K`-dimension of the glued equalizer is the sum of
the piece-local colength dimensions.

Pure module algebra over the field: every colength is free, and the equalizer is the whole
product.  Not one step of the chart-typed proof
(`DivisorAdaptation.finrank_glued_eq_sum_of_separated`) had to change, which is the substantive
content — it confirms, rather than assumes, that this half of the degree ledger owes the
widening nothing. -/
theorem finrank_glued_eq_sum_of_separated
    (hfin : ∀ j : D.index, Module.Finite K (A.colength j))
    (hsep : ∀ i j : D.index, i ≠ j → Subsingleton (A.ovlColength i j)) :
    finrank K A.Glued = ∑ j : D.index, finrank K (A.colength j) := by
  haveI : ∀ j : D.index, Module.Free K (A.colength j) := fun j => Module.Free.of_divisionRing _ _
  haveI := hfin
  rw [LinearEquiv.finrank_eq (A.gluedTopEquiv (A.gluedSubmodule_eq_top_of_separated hsep))]
  exact Module.finrank_pi_fintype K

end AffAdaptation

end AlgebraicGeometry
