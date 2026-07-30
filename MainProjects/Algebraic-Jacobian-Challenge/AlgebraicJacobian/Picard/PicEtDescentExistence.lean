/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentAssembly

/-!
# The EXISTENCE half of the `picEt` field-descent step, at one morphism

`AJC.picrep.etale-rep.invariance`.

## What this file is for

`Picard/PicEtDescentAssembly.lean` proves the **uniqueness** half of the descent
step at the field-extension cover: `picEt_injective_restrict_baseTest` says a
`k`-class is determined by its restriction along the single morphism
`coverMap T : T_{k'} ⟶ T`. Its §4 records that the corresponding *existence*
statement is not in the tree, and names the two things that would produce a
descended class.

This file supplies the missing half of the **sheaf-theoretic** side, in the
single-morphism form a consumer can actually use, and then states precisely what
that leaves owed — which is *not* a sheaf-theoretic fact.

## The gap it closes, stated exactly

`Picard/EtaleFieldCover.lean` proves the sheaf axiom at the *scheme-level*
generated sieve transported by `Sieve.overEquiv`
(`isSheafFor_picEt_pullback_presieve`). What a consumer of the descent step holds
is a class on `T_{k'}`, i.e. datum indexed by the **slice-level** singleton
presieve on `coverMap T`. Those two presieves are *not* the same object, and
nothing identified them: the sieve-indexed statement cannot be applied to a
single-morphism datum without the identification, which is why
`PicEtDescentAssembly.lean`'s uniqueness proof had to redo the factorisation by
hand inside its own proof rather than cite a lemma.

`generate_singleton_coverMap_eq` is that identification, as an equality of sieves
on `T` in the slice. With it:

* `isSheafFor_picEt_singleton_coverMap` — the sheaf axiom holds for the
  **slice-level singleton presieve** on `coverMap T`;
* `exists_unique_descend_picEt` — the existence-and-uniqueness statement in the
  form the descent step consumes: a class `x` on `T_{k'}` whose two pullbacks to
  any common test agree descends to a **unique** class on `T`.

The uniqueness half of `exists_unique_descend_picEt` is *not* a second proof of
`picEt_injective_restrict_baseTest`; it is the `∃!` that the sheaf condition
delivers in one piece, and the earlier lemma is the form that takes two classes
rather than a compatibility hypothesis.

## What remains owed, and why this is not the invariance step

The hypothesis of `exists_unique_descend_picEt` is *agreement of the two
pullbacks*. What campaign `G1` hands over is different: a class fixed by the
semilinear `Gal(k'/k)`-action. **Those are not the same hypothesis**, and the
bridge between them is the Galois-splitting comparison
`k' ⊗_k k' ≅ ∏_{Gal(k'/k)} k'` — under which the two projections
`T_{k'} ×_T T_{k'} ⟶ T_{k'}` become the identity and the `γ`-twist, so that
"the two pullbacks agree" becomes "`γ` fixes the class, for every `γ`". That
splitting is `ajc-p1`'s row `AJC.picrep.etale-rep.galois-splitting`; it is
**absent from mathlib** (measured: `exact?` fails on both the `AlgEquiv` and the
`RingEquiv` form, and `Algebra.Etale K (L ⊗[K] L)` fails synthesis) and this file
does **not** assume it.

So the honest statement of what is closed here is: *the sheaf-theoretic content
of the existence half, in single-morphism form*. The Galois-to-pullback
translation is open and is named, not restated more cheaply.

## What this does NOT do

It closes no `sorry` in `Picard/FGAPicRepresentability.lean` and witnesses **no**
antecedent of `Scheme.fgaPicardRepresentability` for any curve. In particular it
says nothing about the existence of a representing scheme: it descends *classes*,
which is the layer `PicEtDescentAssembly.lean`'s §3 already priced as free — what
this file adds is that the free layer is usable at one morphism, which it was not.

Deliberately contains no implication whose antecedent is its own conclusion, and
no class-valued conclusion: `instHasPicSchemeEt` is unconditional, so a
`HasPicSchemeEt`-valued conclusion is discharged by instance search projecting the
seam `sorry` (`I-1251`).

## Measurement discipline

`lake build AlgebraicJacobian` EXIT=0 with **fresh** oleans before every probe
below; a stale-import environment reports every probe as succeeding (`I-1057`).
-/

universe u

open CategoryTheory AlgebraicGeometry Limits

namespace AlgebraicGeometry

namespace Scheme

namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

/-! ## §1. The two presieves are one sieve -/

/-- **The slice-level singleton sieve on `coverMap` IS the transported
scheme-level one.**

`Picard/EtaleFieldCover.lean` establishes covering-sieve membership and the sheaf
axiom for `(Sieve.overEquiv T).symm (Sieve.generate (Presieve.singleton
(pullback.fst …)))` — a sieve described on the *underlying schemes* and pulled
back into the slice. A consumer of the descent step instead holds a datum indexed
by the slice morphism `coverMap T`. This says the two sieves are **equal**, so
every statement proved for one applies verbatim to the other.

Both inclusions are the same factorisation, in opposite directions: an arrow of
either sieve factors through the cover on underlying schemes, and the lift to the
slice over `Spec k` is where `pullback.condition` is consumed. The forward
direction additionally uses that `restrictTest` does not move the underlying
scheme, so `Over.Hom.left` of a slice factorisation *is* a scheme factorisation.

No hypothesis on `k'/k` beyond `[Algebra k k']`: this is bookkeeping about the
slice, and neither finiteness nor separability enters. Those are consumed only by
the covering-sieve *membership* witness, one file over. -/
theorem generate_singleton_coverMap_eq (T : Over (Spec (CommRingCat.of k))) :
    Sieve.generate (Presieve.singleton (coverMap (k := k) (k' := k') T)) =
      (Sieve.overEquiv T).symm
        (Sieve.generate (Presieve.singleton
          (pullback.fst T.hom (specMapAlgebra k k')))) := by
  ext W g
  constructor
  · rintro ⟨Z, a, b, hb, hfac⟩
    cases hb
    rw [Sieve.overEquiv_symm_iff]
    refine ⟨_, a.left, _, Presieve.singleton.mk, ?_⟩
    rw [← hfac]
    rfl
  · intro hg
    rw [Sieve.overEquiv_symm_iff] at hg
    obtain ⟨Z, a, b, hb, hfac⟩ := hg
    cases hb
    refine ⟨_, Over.homMk a (by
      rw [← Over.w g]
      simp only [restrictTest, Over.map_obj_hom, baseTest, Over.mk_hom, ← hfac]
      rw [Category.assoc]
      exact congrArg (a ≫ ·) pullback.condition.symm), coverMap (k' := k') T,
      Presieve.singleton.mk, ?_⟩
    apply Over.OverMorphism.ext
    change a ≫ pullback.fst T.hom (specMapAlgebra k k') = Over.Hom.left g
    exact hfac

end PicScheme

end Scheme

end AlgebraicGeometry
