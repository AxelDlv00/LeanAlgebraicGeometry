/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib.AlgebraicGeometry.Group.Smooth

/-!
# Smoothness of a group scheme from reducedness over ONE algebraic closure

Mathlib's `AlgebraicGeometry.smooth_of_grpObj` proves that a group scheme locally of finite
type over a field is smooth as soon as it is **geometrically** reduced, i.e. as soon as
`X ×_k Spec K` is reduced for *every* field `K` and every `Spec K ⟶ Spec k`. Internally it
goes through a `private` lemma which needs only reducedness of the **single** base change to
the algebraic closure — the geometric content is the translation argument at an algebraically
closed base, and the general field case is obtained by flat descent along `Spec k̄ → Spec k`.

That `private` modifier is the whole reason for this file. Both this project and the sibling
`Algebraic-Jacobian-Challenge-Rebuild` reached the same conclusion independently (inbox
I-0495, 2026-07-28): the smoothness leg of "`Pic⁰_{C/k}` is an abelian variety" wants to
supply reducedness over `k̄` and nothing more, because

* `Algebra.IsGeometricallyReduced` is *defined* by base change to an algebraic closure
  (`Mathlib/RingTheory/Nilpotent/GeometricallyReduced.lean`), so at the algebra level the
  k̄-statement is the definition rather than a special case;
* the scheme-level class `GeometricallyReduced` quantifies over all field base changes, and
  the passage from the `k̄` case to that quantifier is **absent from mathlib v4.31** — it is
  the transcendental half of `IsReduced after base change to k̄ ⟹ GeometricallyReduced`,
  which has no producer in mathlib and no `MorphismProperty.DescendsAlong` instance either
  (verified by machine on both sides, recorded on inbox I-0495).

So the honest input to smoothness is the `k̄` one, and the cross-project thread priced getting
it as *an upstream PR making `smooth_of_grpObj_of_isAlgClosed` public*. It is cheaper than
that: the `private` proof uses only public API, so it can simply be re-derived here. This
file does that and then packages the descent step, giving a smoothness criterion whose
hypothesis is a single `IsReduced`.

## Main results

* `AlgebraicGeometry.smooth_of_grpObj_of_isAlgClosed'` — the re-derivation of mathlib's
  `private` lemma: a reduced group scheme locally of finite type over an algebraically closed
  field is smooth. Proof transcribed from `Mathlib/AlgebraicGeometry/Group/Smooth.lean`
  (Andrew Yang), which is why the `set_option`s and the `open`s are the same.
* `AlgebraicGeometry.smooth_of_grpObj_of_isReduced_algebraicClosureBaseChange` — the
  criterion this project actually consumes: `G ⟶ Spec k` is smooth as soon as the base change
  `G ×_{Spec k} Spec k̄` is reduced. No `GeometricallyReduced`, no quantifier over fields.

## Why this is a strict reduction and not a restatement

`GeometricallyReduced f → IsReduced (pullback f (Spec.map (algebraMap K (AlgebraicClosure K))))`
holds (it is one instance of the definition), and the converse is exactly what mathlib lacks.
So the criterion below has a **strictly weaker** hypothesis than `smooth_of_grpObj`, at the
same conclusion. That is the point: a consumer owing smoothness now owes reducedness of one
scheme over one algebraically closed field, which is where Kleiman §5's argument (and
Cartier's theorem in characteristic zero) actually speaks.

**The trade is NOT lossless, and which direction fails is worth saying plainly** rather than
letting "strictly weaker" read as "equally good". The two hypotheses are *not* equivalent
here: `GeometricallyReduced ⟹ IsReduced`-over-`k̄` is available, `IsReduced`-over-`k̄ ⟹
GeometricallyReduced` is not (that is the missing transcendental half). So anything that
genuinely needs the *class* — as opposed to needing smoothness — cannot be recovered from this
criterion, and a consumer wanting `GeometricallyReduced` itself gains nothing from it. What
makes the trade correct anyway is that the weaker statement already suffices for the
conclusion at hand. A restatement whose converse *is* provable would be the better shape (see
`ajc-albanese`'s `Sym^g` colimit trade, inbox I-0493, for that stronger discipline); this one
is a genuine weakening that happens to be enough.

## References

Mathlib `AlgebraicGeometry/Group/Smooth.lean`; Kleiman, "The Picard scheme"
(arXiv:math/0504020), §5. Cross-project analysis: inbox I-0495 (2026-07-28).
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry

namespace AlgebraicGeometry

variable {K : Type u} [Field K] {G : Scheme.{u}} (f : G ⟶ Spec (.of K))
    [LocallyOfFiniteType f] [GrpObj (Over.mk f)]

set_option backward.defeqAttrib.useBackward true in
set_option backward.isDefEq.respectTransparency false in
open MonObj MonoidalCategory CartesianMonoidalCategory in
/-- **A reduced group scheme locally of finite type over an algebraically closed field is
smooth** — the re-derivation of mathlib's `private smooth_of_grpObj_of_isAlgClosed`.

The mathematics is not ours: the proof below is transcribed from
`Mathlib/AlgebraicGeometry/Group/Smooth.lean` (Andrew Yang), which is why the `set_option`s,
the `open`s and the tactic script agree with it line for line. It is re-derived rather than
imported because the mathlib declaration is `private`, and its statement — reducedness over
*one* algebraically closed field — is the hypothesis this project can actually supply, while
the public `smooth_of_grpObj` asks for the full `GeometricallyReduced` class.

The argument itself: the smooth locus is nonempty (generic smoothness over a perfect field)
and stable under the translation isomorphisms `GrpObj.mulRight`, which act transitively on
closed points; a Jacobson space whose points are closed-point-dense then forces the smooth
locus to be everything. -/
theorem smooth_of_grpObj_of_isAlgClosed' [IsReduced G] [IsAlgClosed K] : Smooth f := by
  have := LocallyOfFiniteType.jacobsonSpace f
  have : Nonempty G := ⟨η[Over.mk f].1 (IsLocalRing.closedPoint _)⟩
  rw [← Scheme.Hom.smoothLocus_eq_top_iff, ← TopologicalSpace.Opens.coe_eq_univ,
    ← not_ne_iff, ← Set.nonempty_compl]
  intro H
  obtain ⟨x, hx, hxc⟩ :=
    nonempty_inter_closedPoints H f.smoothLocus.2.isClosed_compl.isLocallyClosed
  obtain ⟨y, hy : y ∈ f.smoothLocus, hyc⟩ := nonempty_inter_closedPoints
    f.dense_smoothLocus_of_perfectField.nonempty f.smoothLocus.2.isLocallyClosed
  let x' : 𝟙_ _ ⟶ Over.mk f := Over.homMk _ ((pointEquivClosedPoint f).symm ⟨x, hxc⟩).2
  let y' : 𝟙_ _ ⟶ Over.mk f := Over.homMk _ ((pointEquivClosedPoint f).symm ⟨y, hyc⟩).2
  let α := (GrpObj.mulRight (A := Over.mk f) x').symm ≪≫
    (GrpObj.mulRight (A := Over.mk f) y')
  have hα : x' ≫ α.hom = y' := by
    dsimp only [Iso.trans_hom, Iso.symm_hom, α]
    rw [← Category.assoc, ← Iso.eq_comp_inv]
    simp [comp_lift_assoc]
  have hα' : α.hom.left x = y := by
    simpa [x', y', pointEquivClosedPoint] using congr(($hα).left (IsLocalRing.closedPoint K))
  rw! [← hα', ← α.hom.left.mem_preimage, Scheme.Hom.preimage_smoothLocus_eq,
    show α.hom.left ≫ f = f from α.hom.w] at hy
  exact hx hy

/-- **Smoothness of a group scheme from reducedness of the base change to `k̄` alone.**

The criterion this project consumes in place of `smooth_of_grpObj`: for `G` a `k`-group
scheme locally of finite type, `G ⟶ Spec k` is smooth as soon as the single scheme
`G ×_{Spec k} Spec k̄` is reduced. There is no `GeometricallyReduced` hypothesis and no
quantifier over field extensions.

The descent step is mathlib's, verbatim from `smooth_of_grpObj`:
`MorphismProperty.of_pullback_snd_of_descendsAlong` against
`@Surjective ⊓ @Flat ⊓ @QuasiCompact`, along which `@Smooth` descends
(`Mathlib/AlgebraicGeometry/Morphisms/LocalFlatDescent.lean`). The group structure transports
to the base change by `Over.grpObjMkPullbackSnd`. What changes is only *where the reducedness
hypothesis is taken*: `smooth_of_grpObj` derives `IsReduced` of the pullback from the
`GeometricallyReduced` instance, whereas here it is supplied directly.

Strictly weaker hypothesis, same conclusion — see the module docstring for why the converse
implication (`IsReduced` over `k̄` ⟹ `GeometricallyReduced`) is *not* available in mathlib
v4.31, which is what makes the difference load-bearing rather than cosmetic. -/
theorem smooth_of_grpObj_of_isReduced_algebraicClosureBaseChange
    (h : IsReduced (Limits.pullback f
      (Spec.map (CommRingCat.ofHom (algebraMap K (AlgebraicClosure K)))))) :
    Smooth f := by
  let Ω : Type u := AlgebraicClosure K
  let g : Spec (.of Ω) ⟶ Spec (.of K) := Spec.map (CommRingCat.ofHom <| algebraMap K Ω)
  apply MorphismProperty.of_pullback_snd_of_descendsAlong
    (Q := @Surjective ⊓ @Flat ⊓ @QuasiCompact) (g := g)
  · exact ⟨⟨inferInstance, inferInstance⟩, inferInstance⟩
  · letI : GrpObj (Over.mk (Limits.pullback.snd f g)) := Over.grpObjMkPullbackSnd
    haveI := h
    exact smooth_of_grpObj_of_isAlgClosed' _

end AlgebraicGeometry
