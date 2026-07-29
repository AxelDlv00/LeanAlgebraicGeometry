/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import AlgebraicJacobian.Picard.PicEtSubcanonical

/-!
# Finite separable field extensions are étale covers, and the descent test they give

This file supplies the **cover** that the repaired campaign tail `G1`/`G3` needs:
`Spec k' ⟶ Spec k` for a finite separable extension `k'/k` is a *singleton étale
covering* of `Spec k`, its base change along any `k`-scheme `T` is again one, and
the resulting sieve lies in `etaleTopologyOver k` — the site on which
`PicScheme.picEt` is a sheaf.

## Why this file exists

The seam's single open obligation `Scheme.fgaPicardRepresentability`
(`Picard/FGAPicRepresentability.lean`) is routed through the Milne–Kollár
campaign (`informal/pic-representability-campaign.md`). That campaign builds a
representing scheme over a separably closed field (`J1`–`J5`), spreads it to a
finite Galois level (`G1`) and descends to `k` (`G3`). Its tail is stated for
`picSharp` and, as such, is **false**: by
`PicScheme.not_exists_representing_picSharp_of_not_isIso`
(`Picard/PicEtSubcanonical.lean`) no scheme represents `picSharp C` once
`picEtComparison C` fails to be an isomorphism, which Kleiman's real conic
supplies. The repair recorded on the board row `AJC.picrep.etale-rep` is to
descend `picEt` instead, *because `picEt` is a sheaf for the étale topology and
`picSharp` is not*.

That repair has a prerequisite nothing in the tree provided: the descent step
needs `Spec k' ⟶ Spec k` to actually be an **étale covering** in Mathlib's sense,
so that the sheaf axiom of `PicSharp.etaleSheaf` can be fired at it. This file
proves exactly that, and nothing more. It is infrastructure, not a discharge:

**No `sorry` is closed here, and no antecedent of the seam is witnessed.** What
changes is that the cover the restated `G3` quantifies over is now a theorem
rather than a hypothesis.

## The measurement that motivated the shape of the proofs

`Algebra.Etale k k'` does **not** synthesize from
`[Algebra.IsSeparable k k'] [Module.Finite k k']`, and neither does
`Etale (Spec.map …)`; a lane reading a failing `infer_instance` as an absence
would conclude this cover is unavailable. Both are assembled below from theorem
forms (`Algebra.FormallyEtale.of_isSeparable`,
`Algebra.FinitePresentation.of_finiteType`, `RingHom.etale_algebraMap`,
`HasRingHomProperty.Spec_iff`). The *base change* of the cover, by contrast, is
free by synthesis — `Etale` and `Surjective` are both stable under base change in
Mathlib.

The sibling project `Algebraic-Jacobian-Challenge-Rebuild` has the same
`Algebra.Etale` instance in `AlgebraicJacobian/Algebra/EtaleCover.lean`
(`Algebra.EtaleCover.ofField`); the scheme-level covering statements below are
not there.

## Main results

* `Scheme.etale_specMap_algebraMap` — `Spec k' ⟶ Spec k` is étale.
* `Scheme.surjective_specMap_algebraMap` — and surjective (both spectra are
  one-point), so no separability or finiteness is used.
* `Scheme.singleton_mem_etalePrecoverage_specMap` — the singleton family is an
  étale cover of `Spec k`.
* `Scheme.etale_pullback_fst_specMap` / `Scheme.surjective_pullback_fst_specMap`
  — its base change along an arbitrary `k`-scheme is again étale and surjective.
* `Scheme.sieve_specMap_mem_etaleTopology` — the generated sieve is a covering
  sieve of `Scheme.etaleTopology`.
* `Scheme.picEt_isSheaf_etaleTopologyOver` — `picEt C` is an étale sheaf on
  `(Sch/k)` in the type-valued form, for every smooth proper curve `C`, with
  **no** hypothesis on `C(k)`.
* `Scheme.isSheafFor_picEt_pullback_presieve` — the payoff: `picEt C` satisfies
  the sheaf axiom for the field-extension cover at every test object. This is the
  descent test `G3` needs.
* `Scheme.picEt_ext_of_pullback_agrees` — its uniqueness half on its own:
  restriction along the cover is injective on `picEt`-classes.

## References

Kleiman, "The Picard scheme" (arXiv:math/0504020), §4 Thm `th:main`.
Campaign milestones `G1`, `G3`. Board: `AJC.picrep.etale-rep`. Decision:
`I-0491`.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

/-! ## §1. The étale algebra structure -/

section Algebra

variable (k k' : Type u) [Field k] [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']

/-- **A finite separable field extension is an étale algebra.**

Formal étaleness is separability (`Algebra.FormallyEtale.of_isSeparable`), and
finite presentation follows from finite type over a field
(`Algebra.FinitePresentation.of_finiteType`, the Noetherian criterion).

Stated as an `instance` because both inputs are, and because
`Algebra.Etale k k'` does *not* synthesize without it: this is the declaration
whose absence makes the étale cover below look unavailable. -/
instance etale_of_finite_isSeparable : Algebra.Etale k k' where
  formallyEtale := Algebra.FormallyEtale.of_isSeparable k k'
  finitePresentation :=
    (Algebra.FinitePresentation.of_finiteType (R := k) (A := k')).mp inferInstance

end Algebra

/-! ## §2. The scheme-level cover -/

section Cover

variable (k k' : Type u) [Field k] [Field k'] [Algebra k k']

/-- **`Spec k' ⟶ Spec k` is surjective on points**, for *any* extension of
fields: both spectra have exactly one point, so this needs neither separability
nor finiteness.

Stated on the underlying map because that is the form
`Scheme.singleton_mem_precoverage_iff` consumes; the morphism-property version is
`surjective_specMap_algebraMap` below. -/
theorem surjective_base_specMap_algebraMap :
    Function.Surjective (Spec.map (CommRingCat.ofHom (algebraMap k k'))).base :=
  fun _ => ⟨default, Subsingleton.elim _ _⟩

/-- `Spec k' ⟶ Spec k` is surjective as a morphism property. -/
theorem surjective_specMap_algebraMap :
    Surjective (Spec.map (CommRingCat.ofHom (algebraMap k k'))) :=
  ⟨surjective_base_specMap_algebraMap k k'⟩

variable [Algebra.IsSeparable k k'] [Module.Finite k k']

/-- **`Spec k' ⟶ Spec k` is étale** for `k'/k` finite separable.

The bridge from the algebra statement of §1 to the morphism property is
`RingHom.etale_algebraMap` followed by `HasRingHomProperty.Spec_iff`. It is
needed because `Etale (Spec.map …)` does not synthesize: `RingHom.Etale f` is
`Algebra.Etale` at `f.toAlgebra`, which is not the ambient `Algebra k k'`
instance up to reducible defeq. -/
theorem etale_specMap_algebraMap :
    Etale (Spec.map (CommRingCat.ofHom (algebraMap k k'))) :=
  (HasRingHomProperty.Spec_iff (P := @Etale)).mpr
    (RingHom.etale_algebraMap.mpr inferInstance)

/-- **The singleton family `{Spec k' ⟶ Spec k}` is an étale cover of `Spec k`.**

`Scheme.singleton_mem_precoverage_iff` reduces membership in the étale
precoverage to exactly the two facts above: surjectivity on points, and the
morphism property. -/
theorem singleton_mem_etalePrecoverage_specMap :
    Presieve.singleton (Spec.map (CommRingCat.ofHom (algebraMap k k'))) ∈
      Scheme.precoverage @Etale (Spec (CommRingCat.of k)) := by
  rw [Scheme.singleton_mem_precoverage_iff]
  exact ⟨surjective_base_specMap_algebraMap k k', etale_specMap_algebraMap k k'⟩

/-- The sieve generated by the field-extension cover is a **covering sieve** of
the big étale topology on schemes. This is the form the sheaf axiom of
`PicSharp.etaleSheaf` is stated against. -/
theorem sieve_specMap_mem_etaleTopology :
    Sieve.generate
        (Presieve.singleton (Spec.map (CommRingCat.ofHom (algebraMap k k')))) ∈
      Scheme.etaleTopology (Spec (CommRingCat.of k)) :=
  Precoverage.generate_mem_toGrothendieck (singleton_mem_etalePrecoverage_specMap k k')

end Cover

/-! ## §3. Base change: the cover survives passage to an arbitrary `k`-scheme -/

section BaseChange

variable (k k' : Type u) [Field k] [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']

/-- **The base-changed cover is étale.** `Etale` is stable under base change in
Mathlib (`AlgebraicGeometry.Etale.etale_isStableUnderBaseChange`), so this needs
no argument beyond §2 — recorded because it is the form `G1`'s spreading step
consumes, at an arbitrary test object rather than at `Spec k`. -/
theorem etale_pullback_fst_specMap (T : Scheme.{u}) (a : T ⟶ Spec (CommRingCat.of k)) :
    Etale (pullback.fst a (Spec.map (CommRingCat.ofHom (algebraMap k k')))) :=
  haveI := etale_specMap_algebraMap k k'
  inferInstance

omit [Algebra.IsSeparable k k'] [Module.Finite k k'] in
/-- **The base-changed cover is surjective**, so it is again a cover. Together
with `etale_pullback_fst_specMap` this says the field-extension cover pulls back
to an étale cover of every `k`-scheme.

Needs neither separability nor finiteness, for the same reason
`surjective_base_specMap_algebraMap` does not. -/
theorem surjective_pullback_fst_specMap (T : Scheme.{u})
    (a : T ⟶ Spec (CommRingCat.of k)) :
    Surjective (pullback.fst a (Spec.map (CommRingCat.ofHom (algebraMap k k')))) :=
  haveI := surjective_specMap_algebraMap k k'
  inferInstance

end BaseChange

/-! ## §4. The descent test for `picEt` -/

section Descent

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']

/-- The base-changed cover, as an étale cover of the *underlying scheme* of a
slice object `T`. Restatement of §3 in presieve form. -/
theorem singleton_pullback_mem_etalePrecoverage (T : Over (Spec (CommRingCat.of k))) :
    Presieve.singleton
        (pullback.fst T.hom (Spec.map (CommRingCat.ofHom (algebraMap k k')))) ∈
      Scheme.precoverage @Etale T.left := by
  haveI := etale_specMap_algebraMap k k'
  haveI : Surjective (Spec.map (CommRingCat.ofHom (algebraMap k k'))) :=
    surjective_specMap_algebraMap k k'
  rw [Scheme.singleton_mem_precoverage_iff]
  exact ⟨Surjective.surj
    (f := pullback.fst T.hom (Spec.map (CommRingCat.ofHom (algebraMap k k')))),
    inferInstance⟩

/-- **The field-extension cover, transported into the site `(Sch/k)`** on which
the relative Picard presheaf lives.

`etaleTopologyOver k` is `Scheme.etaleTopology.over (Spec k)`, whose covering
sieves are by definition those whose image under `Sieve.overEquiv` covers the
underlying scheme; `GrothendieckTopology.overEquiv_symm_mem_over` is that
definition read backwards. -/
theorem sieve_pullback_mem_etaleTopologyOver (T : Over (Spec (CommRingCat.of k))) :
    (Sieve.overEquiv T).symm
        (Sieve.generate (Presieve.singleton
          (pullback.fst T.hom (Spec.map (CommRingCat.ofHom (algebraMap k k')))))) ∈
      etaleTopologyOver k T :=
  GrothendieckTopology.overEquiv_symm_mem_over (J := Scheme.etaleTopology) T _
    (Precoverage.generate_mem_toGrothendieck
      (singleton_pullback_mem_etalePrecoverage k' T))

/-- **`picEt C` is an étale sheaf on `(Sch/k)`**, in the type-valued form the
descent test needs.

`PicSharp.etaleSheaf C` is a sheaf by construction, and the sheaf property of an
`AddCommGrpCat`-valued presheaf is equivalent to that of its underlying
type-valued functor (`Presheaf.isSheaf_iff_isSheaf_forget`, the forgetful functor
of a concrete algebraic category preserving limits and reflecting isomorphisms).
Proved, not assumed — and with no hypothesis on `C(k)`.

This is the same reflection step as
`PicScheme.relPresheaf_isSheaf_of_representableBy`
(`Picard/PicEtSubcanonical.lean`) run in the opposite direction: there it takes a
representing scheme to make the *unsheafified* presheaf a sheaf; here the
sheafified one is a sheaf for free. -/
theorem picEt_isSheaf_etaleTopologyOver (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    Presieve.IsSheaf (etaleTopologyOver k) (PicScheme.picEt C) := by
  have h := PicSharp.etaleSheaf_isSheaf C
  rw [Presheaf.isSheaf_iff_isSheaf_forget
      (s := CategoryTheory.forget AddCommGrpCat.{u + 1}),
    isSheaf_iff_isSheaf_of_type] at h
  exact h

/-- **THE DESCENT TEST: `picEt C` satisfies the sheaf axiom for the
field-extension cover, at every test object.**

Concretely: for a `k`-scheme `T` and a finite separable `k'/k`, a family of
`Pic_{(C/k)ét}`-classes on `T ×_k k'` that is compatible on overlaps has a
*unique* amalgamation on `T` (`Presieve.IsSheafFor` unfolds to exactly that
existence-and-uniqueness statement).

This is the descent step the repaired campaign milestone `G3` runs on, and it
carries **no** hypothesis on `C(k)`: it composes §3's cover with §4's sheaf
property, both unconditional. `G3` as written descends `picSharp` instead, for
which the corresponding statement is *not* available — `picSharp` is not an étale
sheaf, which by
`PicScheme.not_exists_representing_picSharp_of_not_isIso`
(`Picard/PicEtSubcanonical.lean`) is why its representability over an arbitrary
field is false rather than merely open. That asymmetry is the entire content of
the repair, and this theorem is the side of it that works.

**What this does and does not give.** It supplies the *descent test*; it does not
supply a descended object. Turning a `k'`-representing scheme into a
`k`-representing one additionally needs the Galois action and the effectivity of
the resulting descent datum (campaign `G1`/`G2`, `Picard/FiniteGaloisQuotient.lean`).
So this closes no `sorry` and witnesses no antecedent of
`Scheme.fgaPicardRepresentability`. -/
theorem isSheafFor_picEt_pullback_presieve (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k))) :
    Presieve.IsSheafFor (PicScheme.picEt C)
      (((Sieve.overEquiv T).symm
        (Sieve.generate (Presieve.singleton
          (pullback.fst T.hom
            (Spec.map (CommRingCat.ofHom (algebraMap k k'))))))) : Presieve T) :=
  picEt_isSheaf_etaleTopologyOver C _ (sieve_pullback_mem_etaleTopologyOver k' T)

/-- **The separatedness half, in the form `G3` uses it: restriction along the
cover is injective on `picEt`-classes.**

Two classes in `Pic_{(C/k)ét}(T)` that agree after restriction along the
base-changed field-extension cover are *equal*. This is the direction the
Hilbert-90 step of campaign `G3` consumes — it is what makes an invariant class
determined by its `k'`-shadow, so that a descent datum is unique once it exists.

It is strictly weaker than `isSheafFor_picEt_pullback_presieve` (separatedness is
the uniqueness half of the sheaf axiom) and is recorded separately because it is
the half that is used on its own. The corresponding statement for `picSharp` is
*not* known to fail — `th:cmp` part 1 gives `picSharp ↪ Pic_{(C/k)zar}` on these
binders — so it is the *amalgamation* half above, not this one, that the repair
depends on. -/
theorem picEt_ext_of_pullback_agrees (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    {t₁ t₂ : (PicScheme.picEt C).obj (Opposite.op T)}
    (h : ∀ ⦃W : Over (Spec (CommRingCat.of k))⦄ ⦃g : W ⟶ T⦄,
      (((Sieve.overEquiv T).symm
        (Sieve.generate (Presieve.singleton
          (pullback.fst T.hom
            (Spec.map (CommRingCat.ofHom (algebraMap k k'))))))) : Presieve T) g →
      (PicScheme.picEt C).map g.op t₁ = (PicScheme.picEt C).map g.op t₂) :
    t₁ = t₂ :=
  (isSheafFor_picEt_pullback_presieve k' C T).isSeparatedFor.ext h

end Descent

end Scheme

end AlgebraicGeometry
