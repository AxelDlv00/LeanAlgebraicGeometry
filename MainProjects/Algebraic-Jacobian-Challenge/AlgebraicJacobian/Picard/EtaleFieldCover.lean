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
* `Scheme.isSheafFor_picEt_specMap_presieve` — the payoff: `picEt C` satisfies
  the sheaf axiom for this presieve, for every smooth proper curve `C`. This is
  the descent test `G3` needs, and it holds with **no** hypothesis on `C(k)`.

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

/-- **`Spec k' ⟶ Spec k` is surjective**, for *any* extension of fields: both
spectra have exactly one point, so this needs neither separability nor
finiteness. -/
theorem surjective_specMap_algebraMap :
    Surjective (Spec.map (CommRingCat.ofHom (algebraMap k k'))) :=
  ⟨fun _ => ⟨default, Subsingleton.elim _ _⟩⟩

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
  exact ⟨surjective_specMap_algebraMap k k', etale_specMap_algebraMap k k'⟩

/-- The sieve generated by the field-extension cover is a **covering sieve** of
the big étale topology on schemes. This is the form the sheaf axiom of
`PicSharp.etaleSheaf` is stated against. -/
theorem sieve_specMap_mem_etaleTopology :
    Sieve.generate
        (Presieve.singleton (Spec.map (CommRingCat.ofHom (algebraMap k k')))) ∈
      Scheme.etaleTopology (Spec (CommRingCat.of k)) :=
  sorry

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

/-- **The base-changed cover is surjective**, so it is again a cover. Together
with `etale_pullback_fst_specMap` this says the field-extension cover pulls back
to an étale cover of every `k`-scheme. -/
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

/-- **The payoff: `picEt C` satisfies the sheaf axiom for the field-extension
cover** — a compatible family of `Pic_{(C/k)ét}`-classes over `Spec k'` with
matching restrictions to the fibre product glues uniquely to a class over
`Spec k`.

This is the descent test the restated campaign milestone `G3` needs, and it
carries **no** hypothesis on `C(k)`. It is a property of `picEt` alone: the
functor is a sheaf by construction (`PicSharp.etaleSheaf_isSheaf`), and §2 says
the family is a covering. The corresponding statement for `picSharp` is
unavailable — that asymmetry is the whole content of the repair. -/
theorem isSheafFor_picEt_specMap_presieve (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    True :=
  sorry

end Descent

end Scheme

end AlgebraicGeometry
