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

/-! ## §2. The sheaf axiom at the cover morphism, and the `∃!` descent -/

section Cover

variable [Algebra.IsSeparable k k'] [Module.Finite k k']

/-- **The sheaf axiom of `picEt` at the slice-level singleton presieve on
`coverMap`.**

This is `Scheme.isSheafFor_picEt_pullback_presieve` (`Picard/EtaleFieldCover.lean`)
carried across `generate_singleton_coverMap_eq`. It is the form a *consumer*
needs, and the reason it needed a lemma at all is §1: the landed statement is
about a sieve described on underlying schemes, while a descent datum is indexed by
one slice morphism.

Finiteness and separability of `k'/k` re-enter here — not for the identification,
but because they are what makes the family *covering* in the étale topology. -/
theorem isSheafFor_picEt_singleton_coverMap (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k))) :
    Presieve.IsSheafFor (picEt C)
      (Presieve.singleton (coverMap (k := k) (k' := k') T)) := by
  rw [Presieve.isSheafFor_iff_generate, generate_singleton_coverMap_eq]
  exact AlgebraicGeometry.Scheme.isSheafFor_picEt_pullback_presieve k' C T

/-- **The existence-and-uniqueness form of the descent step at one morphism.**

For a smooth proper curve `C` over an arbitrary field `k`, a finite separable
`k'/k` and an arbitrary `k`-test `T`: a class `x ∈ Pic_{(C/k)ét}(T_{k'})` whose two
pullbacks along any pair of morphisms agreeing over `T` coincide descends to a
**unique** class on `T`.

This is the statement `PicEtDescentAssembly.lean`'s §4 recorded as missing on the
existence side, in the shape a consumer holds its datum in. Its uniqueness half
overlaps `picEt_injective_restrict_baseTest`, deliberately: that lemma takes *two
classes* and this one takes *one class with a compatibility hypothesis*, and a
consumer of the descent step has the latter.

**Non-vacuity measured, not asserted**, with both obvious refutations probed
(`lake env lean`, fresh oleans, both `exact?` reporting failure):

* dropping the compatibility hypothesis `hx` leaves the `∃!` conclusion **open**,
  so the hypothesis is not decoration;
* the same conclusion at an *arbitrary* morphism `f : W ⟶ T` in place of `coverMap`
  is **open**, so the covering-sieve witness of `Picard/EtaleFieldCover.lean` is
  load-bearing rather than incidental.

**No hypothesis on `C(k)`** (`I-0491`), and none on `T`. -/
theorem exists_unique_descend_picEt (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (x : (picEt C).obj (Opposite.op ((restrictTest k k').obj (baseTest (k' := k') T))))
    (hx : ∀ {W : Over (Spec (CommRingCat.of k))}
      (p₁ p₂ : W ⟶ (restrictTest k k').obj (baseTest (k' := k') T)),
      p₁ ≫ coverMap (k' := k') T = p₂ ≫ coverMap (k' := k') T →
      (picEt C).map p₁.op x = (picEt C).map p₂.op x) :
    ∃! y : (picEt C).obj (Opposite.op T),
      (picEt C).map (coverMap (k' := k') T).op y = x := by
  have h := isSheafFor_picEt_singleton_coverMap (k' := k') C T
  rw [Presieve.isSheafFor_singleton] at h
  exact h x hx

end Cover

/-! ## §3. The level this runs at is the level a curve reaches — the join

`§2` is generic in `k'`: `generate_singleton_coverMap_eq` binds only
`[Algebra k k']`, and `§2` adds exactly the two binders that make the family
covering. That matters because `ajc-p3`'s producer
(`Curve/GaloisLevelRationalPoint.lean`,
`Scheme.exists_finiteGalois_level_hasRationalPoint_of_geometricallyIntegral`)
does **not** hand over a section at a level of the consumer's choosing: its
conclusion is an *existential* over `k''`, and that `k''` is manufactured from the
point as a normal closure. So "the section is available" and "the section is
available **at my cover's level**" are different statements, and the second is
what a descent step needs (`ajc-p3`, caveat on `I-1371`).

**Elaborated rather than argued** (`lake env lean` EXIT=0, fresh oleans; scratch
file, not kept): at the `k''` that producer manufactures, `coverMap` exists and
`isSheafFor_picEt_singleton_coverMap` applies, both instances arriving by
`letI` from the `obtain`. So the answer to that caveat is the cheap one — no
join or enlargement step is owed, because this file's statements are generic in
the level. Recorded here because the composition is the kind of thing that is
invisible from either side: the producer's file has no `picEt` in it and this one
has no rational point.

## §4. What is still owed, named rather than restated more cheaply

The hypothesis of `exists_unique_descend_picEt` is **agreement of two pullbacks**.
Campaign `G1` produces something else: a class fixed by the semilinear
`Gal(k'/k)`-action. The bridge is the Galois splitting
`k' ⊗_k k' ≅ ∏_{Gal(k'/k)} k'` — under it the two projections of the cover become
the identity and the `γ`-twist, so pullback-agreement becomes `γ`-invariance for
every `γ`. That splitting is **absent from Mathlib** (measured: `exact?` fails on
both the `AlgEquiv` and the `RingEquiv` form; `Algebra.Etale K (L ⊗[K] L)` fails
synthesis — though note `ajc-p3` observes that this project's own
`etale_of_finite_isSeparable` supplies the étale half, so the residue is the
`Gal`-**indexing** rather than étaleness) and is `ajc-p1`'s row
`AJC.picrep.etale-rep.galois-splitting`. This file does not assume it and does not
weaken the invariance step to something the splitting would make free.

Beyond that bridge, the scheme-level `G2` quotient is unchanged and untouched: it
is what turns descended *classes* into a representing *scheme*, and it is gated on
`AlgebraicJacobian.GaloisDescent.HasGaloisQuotient`, which has an instance only on
the affine locus while the object this route descends is glued.

So: sheaf-theoretic side of the existence half **closed** at one morphism;
Galois-to-pullback translation **open**; `k'`-side representability and the `G2`
quotient **open** and not made cheaper by anything here.
-/

end PicScheme

end Scheme

end AlgebraicGeometry
