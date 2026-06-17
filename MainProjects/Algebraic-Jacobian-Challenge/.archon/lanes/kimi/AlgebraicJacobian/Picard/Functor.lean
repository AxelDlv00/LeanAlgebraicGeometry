/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.LineBundle

/-!
# The relative Picard functor

Phase C step 2 (per `STRATEGY.md`): the relative Picard functor of a curve
`C` over `Spec k`, packaged as a contravariant functor on schemes-over-`k`,
plus the (deferred) representability theorem whose closure jointly unblocks
the four `Jacobian.lean` sorries.

See `blueprint/src/chapters/Picard_Functor.tex`.

## Status (iteration 005 — first prover round)

`PicardFunctor` is **filled**: for `C : Over (Spec k)` the functor sends each
`S : Over (Spec k)` to the cokernel-as-quotient
`Pic(C ×_k S) / p_S^* Pic(S)` of the pull-back homomorphism along the
projection `p_S : C ×_k S → S`. Functoriality in `S` is via the universal map
of fiber products and `Pic.pullback`.

`PicardFunctor.representable` is intentionally left as `sorry` — see the
forward-compatibility note below.

## Forward-compatibility note (`LineBundle` approximation)

`LineBundle` (per `Picard/LineBundle.lean`) is currently realised as the
global-sections approximation `CommRing.Pic Γ(X, ⊤)`. The relative Picard
functor built on top of this approximation gives smaller subgroups than the
true relative Picard functor on non-affine `S`. Closing `representable` on
top of this approximation would silently assert representability of the wrong
functor and is therefore a forbidden shortcut: keep it as `sorry`.

## Source category

The directive's sketch had source `Schemeᵒᵖ`, but a generic `S : Scheme` does
not come equipped with a structure morphism to `Spec k` — without it the fiber
product `C ×_k S` is not canonically defined. Following the blueprint's
mathematical setup (`Sch_k = Sch / Spec k`) and the convention already used in
`Jacobian.lean`, we therefore take the source as `(Over (Spec (CommRingCat.of
k)))ᵒᵖ`, i.e.\ contravariant on `k`-schemes. This preserves the intended
functor while making the fiber product canonically defined; the
`IsRepresentable` predicate then asks for a representing object inside
`Over (Spec k)`, matching the geometric meaning of the Picard scheme as a
`k`-scheme. See `task_results/Picard_Functor.lean.md` for the rationale.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry.Scheme

variable {k : Type u} [Field k]

namespace PicardFunctor

/-- The map on fiber products `C ×_k S₁ → C ×_k S₂` induced by
`f : S₁ ⟶ S₂` in `Over (Spec k)`, given by the universal property of pullback
applied to `(𝟙 C, f.left)`. -/
noncomputable def fiberMap (C : Over (Spec (CommRingCat.of k)))
    {S₁ S₂ : Over (Spec (CommRingCat.of k))} (f : S₁ ⟶ S₂) :
    Limits.pullback C.hom S₁.hom ⟶ Limits.pullback C.hom S₂.hom :=
  Limits.pullback.map _ _ _ _ (𝟙 _) f.left (𝟙 _) (by simp)
    (by rw [Category.comp_id]; exact (Over.w f).symm)

@[simp, reassoc]
lemma fiberMap_comp_snd (C : Over (Spec (CommRingCat.of k)))
    {S₁ S₂ : Over (Spec (CommRingCat.of k))} (f : S₁ ⟶ S₂) :
    fiberMap C f ≫ Limits.pullback.snd C.hom S₂.hom =
      Limits.pullback.snd C.hom S₁.hom ≫ f.left := by
  unfold fiberMap; exact Limits.pullback.lift_snd _ _ _

@[simp, reassoc]
lemma fiberMap_comp_fst (C : Over (Spec (CommRingCat.of k)))
    {S₁ S₂ : Over (Spec (CommRingCat.of k))} (f : S₁ ⟶ S₂) :
    fiberMap C f ≫ Limits.pullback.fst C.hom S₂.hom =
      Limits.pullback.fst C.hom S₁.hom := by
  unfold fiberMap; rw [Limits.pullback.lift_fst]; simp

@[simp]
lemma fiberMap_id (C : Over (Spec (CommRingCat.of k)))
    (S : Over (Spec (CommRingCat.of k))) :
    fiberMap C (𝟙 S) = 𝟙 _ := by
  unfold fiberMap; exact Limits.pullback.map_id

lemma fiberMap_comp (C : Over (Spec (CommRingCat.of k)))
    {S₁ S₂ S₃ : Over (Spec (CommRingCat.of k))} (f : S₁ ⟶ S₂) (g : S₂ ⟶ S₃) :
    fiberMap C (f ≫ g) = fiberMap C f ≫ fiberMap C g := by
  refine Limits.pullback.hom_ext ?_ ?_
  · simp
  · simp only [fiberMap_comp_snd, Category.assoc, Over.comp_left, fiberMap_comp_snd_assoc]

/-- The pull-back homomorphism on the relative Picard quotient
`Pic(C ×_k S₁) / p_{S₁}^* Pic(S₁) → Pic(C ×_k S₂) / p_{S₂}^* Pic(S₂)` induced
by `f : S₂ ⟶ S₁` in `Over (Spec k)`.

The descent through the quotient uses the commutative square
`fiberMap C f ≫ pullback.snd = pullback.snd ≫ f.left`
(`fiberMap_comp_snd`), which sends `p_{S₁}^* Pic(S₁)` into `p_{S₂}^* Pic(S₂)`
via `Pic.pullback (fiberMap C f)`. -/
noncomputable def quotMap (C : Over (Spec (CommRingCat.of k)))
    {S₁ S₂ : Over (Spec (CommRingCat.of k))} (f : S₂ ⟶ S₁) :
    (Pic (Limits.pullback C.hom S₁.hom) ⧸
        (Pic.pullback (Limits.pullback.snd C.hom S₁.hom)).range) →*
      (Pic (Limits.pullback C.hom S₂.hom) ⧸
        (Pic.pullback (Limits.pullback.snd C.hom S₂.hom)).range) :=
  QuotientGroup.lift _
    ((QuotientGroup.mk' _).comp (Pic.pullback (fiberMap C f)))
    (by
      rintro x ⟨m, rfl⟩
      simp only [MonoidHom.mem_ker, MonoidHom.coe_comp, Function.comp_apply,
        QuotientGroup.mk'_apply]
      rw [QuotientGroup.eq_one_iff]
      refine ⟨Pic.pullback f.left m, ?_⟩
      rw [← MonoidHom.comp_apply (Pic.pullback (Limits.pullback.snd C.hom S₂.hom)),
          ← Pic.pullback_comp, ← fiberMap_comp_snd, Pic.pullback_comp,
          MonoidHom.comp_apply])

@[simp]
lemma quotMap_mk (C : Over (Spec (CommRingCat.of k)))
    {S₁ S₂ : Over (Spec (CommRingCat.of k))} (f : S₂ ⟶ S₁)
    (x : Pic (Limits.pullback C.hom S₁.hom)) :
    quotMap C f (x : _ ⧸ _) = ((Pic.pullback (fiberMap C f) x) : _ ⧸ _) := rfl

@[simp]
lemma quotMap_id (C : Over (Spec (CommRingCat.of k)))
    (S : Over (Spec (CommRingCat.of k))) :
    quotMap C (𝟙 S) = MonoidHom.id _ := by
  ext x; simp

lemma quotMap_comp (C : Over (Spec (CommRingCat.of k)))
    {S₁ S₂ S₃ : Over (Spec (CommRingCat.of k))} (f : S₂ ⟶ S₁) (g : S₃ ⟶ S₂) :
    quotMap C (g ≫ f) = (quotMap C g).comp (quotMap C f) := by
  ext x
  simp [fiberMap_comp, Pic.pullback_comp]

end PicardFunctor

/-- The relative Picard functor of `C` over `Spec k`:
    `S ↦ Pic(C ×_k S) / p_S^* Pic(S)`,
where `p_S : C ×_k S → S` is the projection. Functoriality in `S` is via base
change of the fiber product (`PicardFunctor.fiberMap`) and the pull-back
homomorphism on Picard groups (`Pic.pullback`).

**Iteration 005 implementation.** The fiber product is taken in
`Limits.pullback C.hom S.unop.hom`, the projection `p_S = pullback.snd`, and
the quotient by the pull-back range uses `QuotientGroup.lift` /
`QuotientGroup.mk'`. See `PicardFunctor.fiberMap` and `PicardFunctor.quotMap`
for the underlying constructions and the source-category note in the file
docstring. -/
noncomputable def PicardFunctor
    (C : Over (Spec (CommRingCat.of k))) :
    (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ Type u where
  obj S := Pic (Limits.pullback C.hom S.unop.hom) ⧸
    (Pic.pullback (Limits.pullback.snd C.hom S.unop.hom)).range
  map {_ _} f := TypeCat.ofHom fun x ↦ PicardFunctor.quotMap C f.unop x
  map_id _ := by
    apply TypeCat.Hom.ext; apply TypeCat.Fun.ext
    funext x
    change PicardFunctor.quotMap C (𝟙 _) x = x
    simp
  map_comp f g := by
    apply TypeCat.Hom.ext; apply TypeCat.Fun.ext
    funext x
    change PicardFunctor.quotMap C (f ≫ g).unop x =
      PicardFunctor.quotMap C g.unop (PicardFunctor.quotMap C f.unop x)
    rw [unop_comp, PicardFunctor.quotMap_comp]; rfl

/-- Representability of the relative Picard functor for a smooth, proper,
geometrically irreducible curve `C` over a field `k` (Grothendieck FGA, Mumford
*Abelian Varieties* §III.13). The connected component of the identity of the
representing group scheme is the Jacobian `Jac(C)`.

**Intentionally deferred.** This is FGA-level and not honestly closeable on
the global-sections-approximate `LineBundle`. The four `Jacobian.lean` sorries
all reduce to this theorem. Do not attempt to fill it in iter-005 — see the
file docstring and `Picard_Functor.tex` forward-compatibility note. -/
theorem PicardFunctor.representable
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom]
    [IsProper C.hom]
    [GeometricallyIrreducible C.hom] :
    (PicardFunctor C).IsRepresentable := sorry

end AlgebraicGeometry.Scheme
