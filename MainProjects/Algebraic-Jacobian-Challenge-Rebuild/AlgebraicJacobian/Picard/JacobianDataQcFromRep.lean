/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.JacobianDataAbelSurj
import AlgebraicJacobian.Picard.Pic0ChartTestPoint

/-!
# DAT-J's `quasiCompact` field: the Abel map is not an input, it is `rep.homEquiv.symm`

`JacobianData` (`Picard/JacobianData.lean:87`) has four fields.  `rep` is the representability
antecedent; `locallyOfFiniteType` has a producer (`Picard/Pic0AtlasFiniteType.lean`).  The
remaining field, `quasiCompact`, had **no producer of any shape**: every route in the tree ends
in a hypothesis nothing supplies.

* `quasiCompact_gluedHom` (`Picard/JacobianDataCharts.lean:164`) wants `[Finite ι]`, and the
  atlas is class-indexed.
* `JacobianData.ofChartsOfAbelImage` / `ofChartsOfAbelLifts`
  (`Picard/JacobianDataAbelImage.lean:159`, `Picard/JacobianDataAbelSurj.lean:193`) want a
  morphism `abel : DivScheme g ⟶ J.left`.
* `exists_residueField_lift_of_abelCompatible` (`Picard/JacobianDataAbelSquare.lean:172`) wants
  an `IsAbelClassifyCompatible` square *and* a `pt` function, neither with a producer.

This file removes the middle two.  The observation is that **the Abel morphism is not a
construction the tree owes**: `divSchemeOver` is a test object of `Over (Spec k)`, so a
degree-zero class `lam : pic⁰(divSchemeOver …)` names a morphism `divSchemeOver … ⟶ J`
outright, as `rep.homEquiv.symm lam`, for *any* representing object `J`.  Its `.left` is the
`abel` every `JacobianData` producer above asks for.

Two consequences, and the second is the one that reprices a lane's plan.

**(1) The compatibility square is free at this `abel`.**  `IsAbelClassifyCompatible`
(`Picard/JacobianDataAbelSquare.lean:147`) is the recorded "groups agree ≠ maps agree" gap
(`I-0525`): a bijection between divisor classes and `DivScheme`-points is unusable until the
square relating the two *named* morphisms lands.  That gap is real for an `abel` given
abstractly.  It does not arise for `rep.homEquiv.symm lam`, because `homEquiv` is an
**equivalence**: two morphisms into `J` are equal as soon as their classes are, and
`RepresentableBy.homEquiv_comp` computes the class of a composite as `pic0Map`.  So the square
is discharged by `Equiv.injective`, not assumed.

**(2) What is left is one statement, and it mentions no divisor scheme morphism.**
`quasiCompact_of_pic0_class_surjective` below takes exactly:

> for every point `y` of `J.left`, some `q : overSpec k κ(y) ⟶ divSchemeOver …` with
> `pic0Map C q lam = rep.homEquiv (Over.testPoint y)`

— *the class of `y` is pulled back from `lam` along some field point of the divisor scheme*.
That is a statement about classes only.  It is what the effectivity chain
(`exists_effective_deg_eq_of_pic0_at_point`, `Picard/JacobianDataAbelEffectivePoint.lean`) and
the fibrewise classifier (`effectiveDivisorClassifyZar`,
`Picard/DivisorFamilyFieldSurj.lean:217`) between them are shaped to produce.

## Scope, stated because this file closes no gate

`lam` is a **hypothesis**, and so is `hcl`.  Nothing here produces either, and nothing here
produces `rep`.  What changes is the obligation list: DAT-J's qc field went from *three* inputs
with no producer (`abel`, the square, the lifts) to *two* hypotheses of Pic-side shape (`lam`
and `hcl`), with the morphism and the square discharged rather than relocated.  In particular
`hcl` is **not** `Function.Surjective abel.base` restated — it quantifies over classes and field
points, and the passage to the topological surjection is the proof, not the statement.

The honest residues, unchanged by this file and both recorded elsewhere:

* the effectivity chain produces its divisor over a finite separable *splitting field* of `κ(y)`,
  while `hcl` wants `overSpec k κ(y)` itself — finite separable descent, the `dat-g` lane's
  business (`Picard/JacobianDataAbelEffectivePoint.lean`, "the honest limit");
* `effectiveDivisorClassifyZar` pins `deg D = g` on the nose, which the window form of the
  effectivity leg does not deliver (`Picard/JacobianDataAbelDegreeWindow.lean`, the limit
  paragraph on `exists_effective_of_classDeg_eq_zero_of_toP1`).

## Main declarations

* `AlgebraicGeometry.abelOfPic0Class` — the Abel morphism of a degree-zero class on the divisor
  scheme, `rep.homEquiv.symm lam`.  No construction; the universal property names it.
* `AlgebraicGeometry.abelOfPic0Class_comp_class` — its defining property: the class of a
  composite `q ≫ abel` is `pic0Map C q lam`.  This is the compatibility square, proved.
* `AlgebraicGeometry.residueField_lift_of_pic0_class` — the per-point lift obligation of
  `JacobianData.ofAbelLifts`, from the class statement.
* `AlgebraicGeometry.quasiCompact_of_pic0_class_surjective` — **the qc field**, from `rep`, a
  class `lam` on the divisor scheme, and `hcl`.
* `AlgebraicGeometry.JacobianData.ofPic0ClassSurjective` — the three-input `JacobianData`
  producer: `rep`, the lft certificate, and `hcl`.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

section Abel

variable {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of k))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of k))] [IsIntegral X]
variable {A B : X.CurveDivisor} {g r₁ r₂ : ℕ}
variable {b₁ : Module.Basis (Fin r₁) k ↥(Scheme.divisorSections k B ⊤)}
variable {b₂ : Module.Basis (Fin r₂) k ↥(Scheme.divisorSections k (A + B) ⊤)}

/-- **The Abel morphism of a degree-zero class on the divisor scheme.**

`divSchemeOver … : Over (Spec k)` is a test object of the degree-zero Picard functor, so a class
`lam : pic⁰(divSchemeOver …)` *is* a morphism to any representing object, by the universal
property.  No geometry is used: this is `rep.homEquiv.symm`.

Every `JacobianData` producer of `Picard/JacobianDataAbelImage.lean` and
`Picard/JacobianDataAbelSurj.lean` takes such a morphism as an unproduced hypothesis `abel`.
Its `.left` (`abelOfPic0Class_left` below is `rfl`) is that hypothesis, so those producers are
reachable from a class. -/
def abelOfPic0Class {J : Over (Spec (.of k))}
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂)) :
    divSchemeOver k A B g r₁ r₂ b₁ b₂ ⟶ J :=
  rep.homEquiv.symm lam

/-- The underlying morphism of schemes out of `DivScheme g` — the `abel` of
`JacobianData.ofAbelImage`. -/
@[simp]
lemma abelOfPic0Class_left {J : Over (Spec (.of k))}
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂)) :
    (abelOfPic0Class rep lam).left
      = ((rep.homEquiv.symm lam : divSchemeOver k A B g r₁ r₂ b₁ b₂ ⟶ J)).left :=
  rfl

/-- **The compatibility square, proved rather than assumed.**

The class of a composite `q ≫ abel` is the restriction `pic0Map C q lam` of `lam` along `q`.
This is `RepresentableBy.homEquiv_comp` after `Equiv.apply_symm_apply`, and it is what
`IsAbelClassifyCompatible` (`Picard/JacobianDataAbelSquare.lean:147`) posits for an abstractly
given `abel`.

Recorded as the reason the "groups agree ≠ maps agree" gap (`I-0525`) does not arise here: the
gap is about relating two *independently named* morphisms, and this `abel` is named by the same
equivalence that names the classes. -/
lemma abelOfPic0Class_comp_class {J : Over (Spec (.of k))}
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂))
    {T : Over (Spec (.of k))} (q : T ⟶ divSchemeOver k A B g r₁ r₂ b₁ b₂) :
    rep.homEquiv (q ≫ abelOfPic0Class rep lam) = pic0Map C q lam := by
  rw [abelOfPic0Class, rep.homEquiv_comp (f := q), Equiv.apply_symm_apply]
  rfl

/-- **A field point whose class is pulled back from `lam` lifts through the Abel morphism.**

If `q : overSpec k κ(y) ⟶ divSchemeOver …` carries `lam` to the class of the field point of `y`,
then `q ≫ abelOfPic0Class rep lam` **is** that field point — not merely a morphism with the same
class.  The upgrade is `Equiv.injective`: `homEquiv` is an equivalence, so two morphisms into `J`
with equal classes are equal.

This is the step that would otherwise be the compatibility square. -/
lemma comp_abelOfPic0Class_eq_testPoint {J : Over (Spec (.of k))}
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂)) (y : J.left)
    (q : overSpec k (Over.testPointField y) ⟶ divSchemeOver k A B g r₁ r₂ b₁ b₂)
    (hq : pic0Map C q lam = rep.homEquiv (Over.testPoint y)) :
    q ≫ abelOfPic0Class rep lam = Over.testPoint y := by
  apply rep.homEquiv.injective
  rw [abelOfPic0Class_comp_class]
  exact hq

/-- **The per-point residue-field lift, from the class statement.**

`Over.testPoint y` has carrier `fromSpecResidueField y` by definition
(`Over.testPoint_left`), so the previous lemma delivers exactly the hypothesis
`surjective_of_forall_exists_residueField_lift` (`Picard/JacobianDataAbelSurj.lean:82`) and
hence `JacobianData.ofAbelLifts` consume — with the morphism and the square supplied here
instead of assumed. -/
lemma residueField_lift_of_pic0_class {J : Over (Spec (.of k))}
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂))
    (hcl : ∀ y : J.left,
      ∃ q : overSpec k (Over.testPointField y) ⟶ divSchemeOver k A B g r₁ r₂ b₁ b₂,
        pic0Map C q lam = rep.homEquiv (Over.testPoint y))
    (y : J.left) :
    ∃ q : Spec (J.left.residueField y) ⟶ DivScheme k A B g r₁ r₂ b₁ b₂,
      q ≫ (abelOfPic0Class rep lam).left = J.left.fromSpecResidueField y := by
  obtain ⟨q, hq⟩ := hcl y
  exact ⟨q.left, congrArg Over.Hom.left
    (comp_abelOfPic0Class_eq_testPoint rep lam y q hq)⟩

/-- **DAT-J's `quasiCompact` field, from a class on the divisor scheme.**

Given a representation `rep` of the degree-zero Picard functor by `J`, a degree-zero class `lam`
on `divSchemeOver …`, and the statement that *every* point of `J.left` has its class pulled back
from `lam` along some field point of the divisor scheme, the structure morphism `J.hom` is
quasi-compact.

The chain: `hcl` gives per-point lifts through `abelOfPic0Class rep lam`
(`residueField_lift_of_pic0_class`), those give point surjectivity
(`surjective_of_forall_exists_residueField_lift`), `DivScheme g` is a compact space
(`compactSpace_divScheme`, DD-Q) and `Spec k` is affine, so DJ-0's
`quasiCompact_of_surjective` applies.

**What is and is not discharged.**  `lam` and `hcl` are hypotheses; this proves the implication.
What it removes from the previous obligation list is the Abel *morphism* and the compatibility
*square* — neither is an input any more. -/
theorem quasiCompact_of_pic0_class_surjective {J : Over (Spec (.of k))}
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂))
    (hcl : ∀ y : J.left,
      ∃ q : overSpec k (Over.testPointField y) ⟶ divSchemeOver k A B g r₁ r₂ b₁ b₂,
        pic0Map C q lam = rep.homEquiv (Over.testPoint y)) :
    QuasiCompact J.hom :=
  quasiCompact_of_forall_residueField_lift_from_divScheme A B g r₁ r₂ b₁ b₂ J
    (abelOfPic0Class rep lam).left (residueField_lift_of_pic0_class rep lam hcl)

/-- **The `JacobianData` producer with the qc field discharged from a class.**

Three inputs: the representation, the locally-of-finite-type certificate (which
`Picard/Pic0AtlasFiniteType.lean` supplies — free at the divisor-representability lane's own
carrier), and `hcl`.  Compare `JacobianData.ofAbelLifts`
(`Picard/JacobianDataAbelSurj.lean:149`), which needs the same `rep` and `hlft` plus an
unproduced `abel` and per-point lifts *of that morphism*. -/
def JacobianData.ofPic0ClassSurjective (C) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] (J : Over (Spec (.of k)))
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (hlft : LocallyOfFiniteType J.hom)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂))
    (hcl : ∀ y : J.left,
      ∃ q : overSpec k (Over.testPointField y) ⟶ divSchemeOver k A B g r₁ r₂ b₁ b₂,
        pic0Map C q lam = rep.homEquiv (Over.testPoint y)) :
    JacobianData C :=
  JacobianData.ofRepresentableBy C J rep hlft
    (quasiCompact_of_pic0_class_surjective rep lam hcl)

@[simp]
lemma JacobianData.ofPic0ClassSurjective_J (C) [SmoothOfRelativeDimension 1 C.hom]
    [IsProper C.hom] [GeometricallyIrreducible C.hom] (J : Over (Spec (.of k)))
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (hlft : LocallyOfFiniteType J.hom)
    (lam : pic0Subgroup C (divSchemeOver k A B g r₁ r₂ b₁ b₂))
    (hcl : ∀ y : J.left,
      ∃ q : overSpec k (Over.testPointField y) ⟶ divSchemeOver k A B g r₁ r₂ b₁ b₂,
        pic0Map C q lam = rep.homEquiv (Over.testPoint y)) :
    (JacobianData.ofPic0ClassSurjective C J rep hlft lam hcl).J = J :=
  rfl

end Abel

end

end AlgebraicGeometry
