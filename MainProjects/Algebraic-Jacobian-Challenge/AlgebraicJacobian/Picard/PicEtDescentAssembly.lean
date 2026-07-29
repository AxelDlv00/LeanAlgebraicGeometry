/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import Mathlib
import AlgebraicJacobian.Picard.PicEtCrossBase
import AlgebraicJacobian.Picard.EtaleFieldCover

/-!
# The descent assembly — the theorem that CONSUMES the four repair inputs

`AJC.picrep.etale-rep.descent-assembly`.

## Why this file exists

The repaired route to the seam `sorry` `Scheme.fgaPicardRepresentability`
(`Picard/FGAPicRepresentability.lean`) is documented at that declaration as
having **four inputs**, and each of the four has either landed or is held by a
lane. What no declaration in this project stated is the theorem those four are
inputs *to*: the step that takes a representation over a larger field and
returns one over `k`.

Measured before this file was written, at HEAD with fresh oleans: the seam's
conclusion shape `Nonempty ((PicScheme.picEt C).RepresentableBy X)` occurs at
exactly three sites — `Picard/FGAPicRepresentability.lean` twice (the
`HasPicSchemeEt` class field, and the `sorry`-bodied seam itself) and
`Picard/PicEtSubcanonical.lean` once
(`hasPicSchemeEt_of_picSharp_representability`). All three are **same-field**:
the last takes a `picSharp` representation over the *same* `k` and transports it
along subcanonicity. None takes a `k'`-side representation and concludes over
`k`. Independently re-measured by `review-ajc` (`I-1256`) before this file
landed.

So the route's scoreboard was a list of antecedents with no goal attached, and an
input nobody held would have stayed invisible — the failure mode this file is
written to remove.

## What is proved here, and what is not

**Proved, `sorry`-free** (§2): the **uniqueness half** of the descent, at the
cover the repair uses. `picEt_injective_restrict_baseTest` says restriction along
the single morphism `T ×_k k' ⟶ T` is *injective* on `picEt`-classes, for every
`k`-test `T`. This is what makes a descended class unique once it exists.

**Proved, `sorry`-free** (§3): the transport that makes the `k'`-side hypothesis
statable in the right variables (`representableByRestrict_of_baseChange`, free from
input 2), and the sharp consequence of §2 —
`picEtRestrictEquiv_of_surjective`: restriction along the cover is a *bijection* as
soon as it is surjective, so the descent step's remaining class-level content is
**one half of a bijection, not two**.

**Not proved, and named rather than hidden** (§4): effectivity, and then the
quotient construction. Surjectivity of restriction has no producer here for any
curve, and the passage from a class-level bijection to a representing `k`-scheme is
campaign `G2` itself, gated on the instance-free
`AlgebraicJacobian.GaloisDescent.HasGaloisQuotient`. This file does not weaken
either, does not restate them more cheaply, and does not close them.

**What this file deliberately does not contain.** An earlier draft stated the
assembly as a Lean implication whose antecedent was the seam's clause (1) and whose
conclusion was the same existential — i.e. `P → P`, the shape `I-0838` forbids and
the 2026-07-29 audit found 67 times. It was removed before committing rather than
dressed up: the remaining obligation is a *construction*, so its home is the gate
in `Picard/FiniteGaloisQuotient.lean`, not a hypothesis slot here. Nor is any
conclusion in this file class-valued: because `instHasPicSchemeEt` is
unconditional, instance search discharges a `HasPicSchemeEt`-valued conclusion by
projecting the seam `sorry` for every object in the gate's domain, so such a
statement would typecheck whatever its hypotheses said (`review-ajc`, `I-1251`).

## What this does NOT do

It closes no `sorry` in `Picard/FGAPicRepresentability.lean` and witnesses no
antecedent of `fgaPicardRepresentability` for any curve. §2 is a genuine theorem
about `picEt` on an arbitrary smooth proper curve over an arbitrary field, with no
hypothesis on `C(k)` per `I-0491`; the statements of §3 are unconditional, and what
§4 records as remaining has no producer.

## A route correction recorded here because it was nearly acted on

`review-ajc` proposed (and, once shown this, withdrew — `I-1256`) that the
assembly should conclude the `picSharp`-shaped endpoint
`∃ X, Nonempty ((picSharp C).RepresentableBy X) ∧ LocallyOfFiniteType X.hom ∧
IsSeparated X.hom`, on the strength of its own r5 measurement that this single
existential discharges *both* seam conjuncts with nothing left over. That
reduction is correct and is cited below at the **input** end. As a *conclusion*
over the headline's arbitrary `k` it is inadmissible, and this project already
proves why: `PicScheme.not_exists_representing_picSharp_of_not_isIso`
(`Picard/PicEtSubcanonical.lean`) says no scheme at all represents `picSharp C`
over such a `k` once `picEtComparison C` fails to be an isomorphism. Aiming the
assembly there would have produced a green, `sorry`-free theorem refutable from a
lemma two files away. The whole content of the repair is that the object crossing
the descent step is `picEt`.

## Measurement discipline

`lake build AlgebraicJacobian` EXIT=0 (8869 jobs) with **fresh** oleans before
every probe below — a stale-import environment reports every probe as succeeding
(`I-1057`), which would have made the §2 proof look free when it was not.
-/

universe u

open CategoryTheory AlgebraicGeometry Limits

namespace AlgebraicGeometry

namespace Scheme

namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

/-! ## §1. The cover of a `k`-test by its base change, as an `Over`-morphism -/

/-- The base change `T ×_k Spec k'` of a `k`-test `T`, regarded as a `k'`-test
via the second projection.

This is the object the descent step's classes live on: a class over `k'` is a
class on `T_{k'}` for the tests `T` of interest, and `§2` shows a `k`-class is
determined by its restriction here. -/
noncomputable abbrev baseTest (T : Over (Spec (CommRingCat.of k))) :
    Over (Spec (CommRingCat.of k')) :=
  Over.mk (pullback.snd T.hom (specMapAlgebra k k'))

/-- **The covering morphism `T_{k'} ⟶ T`**, in the slice over `Spec k`.

Its underlying scheme map is exactly `pullback.fst`, which is the morphism
`Picard/EtaleFieldCover.lean` builds its covering sieve from — so the sheaf
axiom landed there applies to this morphism on the nose (checked by `rfl`:
`coverMap_left`). -/
noncomputable def coverMap (T : Over (Spec (CommRingCat.of k))) :
    (restrictTest k k').obj (baseTest (k' := k') T) ⟶ T :=
  Over.homMk (pullback.fst T.hom (specMapAlgebra k k'))
    (pullback.condition (f := T.hom) (g := specMapAlgebra k k'))

/-- The cover morphism's underlying scheme map **is** `pullback.fst`, definitionally.

This is the identification that lets `§2` feed
`Scheme.picEt_ext_of_pullback_agrees`, whose sieve is generated by
`Presieve.singleton (pullback.fst T.hom (specMapAlgebra k k'))`. -/
@[simp]
theorem coverMap_left (T : Over (Spec (CommRingCat.of k))) :
    (coverMap (k' := k') T).left = pullback.fst T.hom (specMapAlgebra k k') := rfl

/-! ## §2. The uniqueness half of the descent — PROVED -/

/-- **Restriction along `T_{k'} ⟶ T` is injective on `picEt`-classes.**

For a smooth proper curve `C` over an arbitrary field `k`, an arbitrary finite
separable `k'/k`, and an arbitrary `k`-test `T`: two classes in
`Pic_{(C/k)ét}(T)` that agree after restriction to `T ×_k Spec k'` are equal.

This is the *uniqueness* half of the descent step, and it is what makes a
descended class unique once one exists — so `picEtRestrictEquiv_of_surjective`
below needs no separate uniqueness hypothesis.

**Where the content is, stated precisely.** The amalgamation property itself is
free: `Scheme.isSheafFor_picEt_of_mem` holds at *every* covering sieve of
`etaleTopologyOver k`, `⊤` included, because it is `PicSharp.etaleSheaf`'s own
`Sheaf.cond` pushed through the forgetful functor. What this lemma adds over
`Scheme.picEt_ext_of_pullback_agrees` is the reduction from that lemma's
*sieve-indexed* hypothesis — agreement after restriction along **every** arrow of
the generated sieve — to agreement along the **single** morphism `coverMap`. The
step is the factorisation: an arrow of the sieve factors through `pullback.fst`,
and lifting that factorisation to the slice over `Spec k` is where
`pullback.condition` is consumed.

**No hypothesis on `C(k)`** (`I-0491`), and none on `T`. The finite-separability
binders are inherited from the covering-sieve membership witness of
`Picard/EtaleFieldCover.lean`, which is where they are genuinely used; they are
*not* needed by the cross-base identification (`picEt_crossBaseIso` holds for an
arbitrary field extension). -/
theorem picEt_injective_restrict_baseTest
    [FiniteDimensional k k'] [Algebra.IsSeparable k k']
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    {t₁ t₂ : (picEt C).obj (Opposite.op T)}
    (h : (picEt C).map (coverMap (k' := k') T).op t₁
       = (picEt C).map (coverMap (k' := k') T).op t₂) :
    t₁ = t₂ := by
  refine AlgebraicGeometry.Scheme.picEt_ext_of_pullback_agrees k' C T ?_
  intro W g hg
  rw [Sieve.overEquiv_symm_iff] at hg
  obtain ⟨Z, a, b, hb, hfac⟩ := hg
  cases hb
  -- `g` factors through `coverMap` in the slice over `Spec k`.
  have hgfac : g = (Over.homMk a (by
      rw [← Over.w g]
      simp only [restrictTest, Over.map_obj_hom, baseTest, Over.mk_hom, ← hfac]
      rw [Category.assoc]
      exact congrArg (a ≫ ·) pullback.condition.symm) :
        W ⟶ (restrictTest k k').obj (baseTest (k' := k') T))
      ≫ coverMap (k' := k') T := by
    apply Over.OverMorphism.ext
    change Over.Hom.left g = a ≫ pullback.fst T.hom (specMapAlgebra k k')
    exact hfac.symm
  rw [hgfac]
  simp only [op_comp, Functor.map_comp, CategoryTheory.comp_apply, h]

/-! ## §3. The input-side transport, and the sharp form of what remains -/

/-- **The `k'`-side input, transported: PROVED, and free.**

A representation of `picEt` of the **base-changed curve** `C_{k'}` by a
`k'`-scheme `X'` is the same thing as a representation of `picEt C` restricted to
`k'`-tests. This is `picEt_crossBaseIso` (input 2 of the repair, closed
unconditionally by `Picard/PicEtCrossBase.lean`) fed to
`Functor.RepresentableBy.ofIso`.

It is recorded because it is the step that makes the assembly's hypothesis
*statable in the right variables*: without it the `k'`-scheme that campaign `J5`
produces would represent `picEt` of the `k`-curve restricted to `k'`-tests rather
than `picEt` of `C_{k'}`, and there would be no functor for the Galois action to
act on — a mismatch no green build reveals.

No separability or finiteness hypothesis on `k'/k`: the cross-base identification
never needed one. -/
noncomputable def representableByRestrict_of_baseChange
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X') :
    ((restrictTest k k').op ⋙ picEt C).RepresentableBy X' :=
  rep.ofIso (picEt_crossBaseIso C k')

/-- **THE SHARP FORM OF WHAT THE DESCENT STEP STILL OWES: surjectivity alone.**

Restriction along the cover `T_{k'} ⟶ T` is a **bijection** on `picEt`-classes as
soon as it is surjective — because `§2` already supplies injectivity
unconditionally. So the descent step's remaining content, at the level of classes,
is exactly one half of a bijection, not two.

This is the useful output of this file for whoever attacks campaign `G1`/`G2`: an
effectivity argument has to produce a *preimage*, and nothing more. Any effort
spent on uniqueness of the descended class is wasted — `§2` is unconditional in
`T`, in `C`, and in the extension.

**What this is not.** It is not a discharge. `hsurj` has no producer in this
project for any curve and any non-trivial `T`: producing one is the existence half
of the descent, campaign `G1`/`G2`, whose gate
`AlgebraicJacobian.GaloisDescent.HasGaloisQuotient` is instance-free off the affine
locus (`Picard/GaloisQuotientAffineGeneral.lean` discharges it for `[IsAffine X]`
only, and the object this route descends is glued). The hypothesis is stated
explicitly rather than routed through that class so that an axiom check on any
future discharge is meaningful.

**Non-vacuity of the statement, not of the hypothesis**: `C` occurs in both the
hypothesis and the conclusion, the conclusion is an `Equiv` where the hypothesis is
only a surjection, and the injectivity that upgrades one to the other is `§2`'s
theorem rather than a projection of `hsurj`. At `k' = k` the cover is an
isomorphism and the statement degenerates, which is why `§2` — the half that is
proved — is stated for an arbitrary `k'` and carries the load. -/
noncomputable def picEtRestrictEquiv_of_surjective
    [FiniteDimensional k k'] [Algebra.IsSeparable k k']
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (hsurj : Function.Surjective
      (fun t : (picEt C).obj (Opposite.op T) =>
        (picEt C).map (coverMap (k' := k') T).op t)) :
    (picEt C).obj (Opposite.op T) ≃
      (picEt C).obj (Opposite.op ((restrictTest k k').obj (baseTest (k' := k') T))) :=
  Equiv.ofBijective _
    ⟨fun _ _ h => picEt_injective_restrict_baseTest (k' := k') C T h, hsurj⟩

/-! ## §4. What still stands between this and the seam's clause (1)

The seam's clause (1) asks for a `k`-scheme representing `picEt C`. What `§2` and
`picEtRestrictEquiv_of_surjective` establish is that the *class-level* descent is
injective always and bijective as soon as it is surjective. What they do **not**
supply, and what this file therefore leaves open, is the passage from a
class-level bijection to a *representing scheme* over `k`: that is the quotient
construction itself (campaign `G2`), which produces the `k`-scheme as a quotient of
`X'` by the semilinear Galois action, and it is gated on
`AlgebraicJacobian.GaloisDescent.HasGaloisQuotient`.

Deliberately **not** stated here as a Lean implication with that passage as a
hypothesis: an implication whose antecedent is its own conclusion is `P → P`, and
an implication whose antecedent is "the `k`-scheme exists with its properties" is
that. The route's remaining obligation is a *construction*, and the place for it is
`Picard/FiniteGaloisQuotient.lean`'s gate, where it already sits.

So the scoreboard this file was written to complete reads, at HEAD: inputs 1 (the
cover), 2 (cross-base), 4 (the `k^s` section) landed; input 3 (the Galois quotient)
open and gated; the *goal* they feed now exists as `§2` for the uniqueness half,
with surjectivity-of-restriction the sharp remaining class-level statement and the
quotient construction the remaining geometric one.
-/

end PicScheme

end Scheme

end AlgebraicGeometry
