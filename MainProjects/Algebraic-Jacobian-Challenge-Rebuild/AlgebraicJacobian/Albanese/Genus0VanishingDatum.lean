/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Albanese.Genus0Terminal
import AlgebraicJacobian.Picard.Pic0VanishingRoute

/-!
# S11 with the datum binder REMOVED: the degenerate Albanese leaf needs no `JacobianData`

`Albanese/Genus0Terminal.lean` closes the uniqueness half of the frozen
`exists_unique_ofCurve_comp` in the degenerate case, and every one of its statements takes a
`(d : JacobianData C)` as its first argument.  That binder is not free: `JacobianData` is the
Wave-4 north star, and at the time that file was written it had no producer that did not run
through the chart atlas, i.e. through `rep`, `IsChartUniv` and coverage.

So the S11 leaf read as *gated on DAT-D* — which is how the roadmap prices it, and which is
why the row sits behind the divisor-representability lane.

**It is not gated on DAT-D.**  `Picard/Pic0VanishingRoute.lean` produces a `JacobianData` from
the *same* vanishing hypothesis that `Genus0Terminal`'s theorems already assume.  Feeding it
to those theorems deletes the binder: every consequence there becomes a statement about the
curve alone.

That is the whole content of this file, and it is worth exactly one observation: the datum
binder and the vanishing hypothesis were never independent.  A file that assumes both is
assuming the second twice.

## What is unconditional here, and what is not

Unconditional given the vanishing: existence of the datum, terminality of its representing
object, and the uniqueness clause of the Albanese property.

**Still open, and it is the same debt `Genus0Terminal` names:** the vanishing itself.
`genus C = 0 → pic0Subgroup C T = ⊥` is real curve theory and no declaration in this tree
proves it.  Nothing below weakens that; what changes is that the vanishing is now the *only*
input, where before it was the vanishing *plus* a datum.

Also still open, and equally unchanged: the *existence* half of the Albanese `∃!`, which is
Milne I 3.9.  It appears as the explicit `hex` hypothesis, exactly as upstream.

## Main declarations

* `AlgebraicGeometry.jacobianData_of_vanishing` — the datum from `pic0Subgroup C T = ⊥`, i.e.
  in the spelling `Genus0Terminal` uses.
* `AlgebraicGeometry.isTerminal_jacobianData_of_vanishing` — its representing object is
  terminal, with no datum binder.
* `AlgebraicGeometry.existsUnique_ofCurve_comp_of_vanishing` — **S11's uniqueness clause with
  the `JacobianData` binder gone.**
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

variable (C) in
/-- **The datum, from the `= ⊥` spelling of the vanishing.**

`Genus0Terminal` states its hypothesis as `pic0Subgroup C T = ⊥`; the producer in
`Pic0VanishingRoute` takes the `Subsingleton` form.  They are interderivable
(`subsingleton_of_pic0Subgroup_eq_bot`), so this is the producer in the spelling the
consumers below want. -/
def jacobianData_of_vanishing
    (h : ∀ T : Over (Spec (.of k)), pic0Subgroup C T = ⊥) :
    JacobianData C :=
  jacobianData_of_subsingleton C fun T => subsingleton_of_pic0Subgroup_eq_bot (h T)

variable (C) in
/-- **Terminality with no datum binder.**

`JacobianData.isTerminal_of_pic0Subgroup_eq_bot` concludes `IsTerminal d.J` from a datum `d`
plus the vanishing.  Here the datum is *built* from the vanishing, so the conclusion depends
on the curve alone.

Note that the representing object is `Over.mk (𝟙 (Spec k))` by construction, so terminality
is also available as `Over.mkIdTerminal` — but the composite is the statement worth having,
because it is the upstream theorem with its binder discharged rather than a fact about this
particular carrier. -/
def isTerminal_jacobianData_of_vanishing
    (h : ∀ T : Over (Spec (.of k)), pic0Subgroup C T = ⊥) :
    IsTerminal (jacobianData_of_vanishing C h).J :=
  JacobianData.isTerminal_of_pic0Subgroup_eq_bot _ h

end

variable (C) in
/-- **S11's UNIQUENESS CLAUSE, WITH THE `JacobianData` BINDER GONE.**

`JacobianData.existsUnique_ofCurve_comp_of_pic0Subgroup_eq_bot` is the upstream assembly; it
takes a datum, the vanishing, surjectivity of the curve's structure morphism, a rational
point, and the existence half `hex`.  This is the same theorem with the datum *supplied*, so
the hypotheses are: the vanishing, a nonempty curve, a rational point, and `hex`.

Read against the `AJCR.w6-albanese.genus0` row, which records the leaf as gated behind
`divRep`: it is not, and never was — the gate was the datum binder, and the vanishing that
the row's own hypothesis carries is enough to build one.

`hex` is Milne I 3.9 and is still open, exactly as upstream. -/
theorem existsUnique_ofCurve_comp_of_vanishing
    (h : ∀ T : Over (Spec (.of k)), pic0Subgroup C T = ⊥) (hs : Surjective C.hom)
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) {A : Over (Spec (.of k))} (f : C ⟶ A)
    (hex : ∃ g : (jacobianData_of_vanishing C h).J ⟶ A,
      f = (jacobianData_of_vanishing C h).ofCurve P ≫ g) :
    ∃! g : (jacobianData_of_vanishing C h).J ⟶ A,
      f = (jacobianData_of_vanishing C h).ofCurve P ≫ g :=
  JacobianData.existsUnique_ofCurve_comp_of_pic0Subgroup_eq_bot _ h hs P f hex

end AlgebraicGeometry
