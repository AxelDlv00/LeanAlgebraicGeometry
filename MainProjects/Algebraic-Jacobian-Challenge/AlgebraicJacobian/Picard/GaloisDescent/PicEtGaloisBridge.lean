/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence

/-!
# The Galois bridge: `γ`-invariance versus agreement of the cover's two projections

`AJC.picrep.etale-rep.invariance`.

## The gap this closes

`Picard/PicEtDescentExistence.lean` (`ajc-p2`) ends the sheaf-theoretic side of the
`picEt` field-descent step at `exists_unique_descend_picEt_of_projections`, whose
hypothesis is **agreement of the cover's two canonical projections**
`T_{k'} ×_T T_{k'} ⟶ T_{k'}`. Campaign `G1` produces something else: a class fixed
by the `Gal(k'/k)`-action. Its §4 names the remaining link as the *morphism-level
coherence* — that the `Gal`-indexed splitting's `γ`-component, composed with the two
projections, gives the identity and the `γ`-twist — and calls it "a computation about
specific morphisms, not a missing lemma".

This file is that computation, and it comes out asymmetric. **The direction the
route needs and the direction that is free are different directions**, so the two
are stated separately rather than as an `iff` with one hypothesis carried through
both halves.

## What is proved

* `twistTest` — the `γ`-twist of the base-changed test `T_{k'}`, as an endomorphism
  **in the slice over `Spec k`** (§1). This is the morphism a `γ`-invariance
  hypothesis is *about*, and it did not exist in the project: `Picard/GaloisDescent/`
  had the semilinear action on modules and on `Spec` of a ring, but nothing twisting
  a base-changed test.
* `coverSelfSection` — the `γ`-component section
  `T_{k'} ⟶ T_{k'} ×_T T_{k'}`, `⟨id, twist γ⟩` (§2). This is the coherence, and
  §2's two `simp` lemmas are its content: the section's composites with the two
  projections *are* `𝟙` and the `γ`-twist, by `pullback.lift_fst`/`lift_snd`.
* `invariant_of_projections_agree` (§3) — **projection agreement ⟹ `γ`-invariance,
  for every `γ`, unconditionally**. Arbitrary field `k`, arbitrary extension `k'/k`,
  arbitrary test `T`: no finiteness, no separability, no normality, no `IsGalois`.
* `projections_agree_of_invariant` (§4) — the converse, **as an implication with one
  explicitly named antecedent**: the `γ`-family must generate a *covering* sieve on
  the self-pullback. That antecedent is `hcov`, it is not discharged here, and §4
  says exactly what discharging it needs.
* `exists_unique_descend_picEt_of_invariant` (§5) — the composite a `G1` consumer
  calls: `γ`-invariance for every `γ`, plus `hcov`, gives the **unique** descended
  class. This is `ajc-p2`'s `∃!` with its hypothesis replaced by the one `G1`
  actually holds.

## Why the two directions are not symmetric, since this reprices the residue

The coherence identities are *equations between morphisms* and hold for any field
extension. What they buy in each direction is different:

* **Agreement ⟹ invariance** is pure functoriality: restrict the agreement along the
  section `⟨id, twist γ⟩`. One class, one section, no covering property. **Free.**
* **Invariance ⟹ agreement** cannot be functoriality, because the two projections are
  not in the image of any single section. It needs the `γ`-sections to *jointly* see
  all of `T_{k'} ×_T T_{k'}`, i.e. to generate a covering sieve — and *that* is where
  `IsGalois` enters, via `galoisSelfTensorEquiv` (`Picard/GaloisDescent/GaloisSelfTensor.lean`).

So the residue named in `PicEtDescentExistence.lean` §4 was **half free and half
mispriced**: the coherence itself is `pullback.lift_fst`, three lines, and it was
never the obstruction. The obstruction is a *covering* statement about the
`Gal`-indexed family, which is a different kind of fact — and `IsGalois` is needed
for it exactly as `ajc-p1`'s `galoisSelfTensorHom_bijective_iff_isGalois` predicts:
below the Galois level the family does not cover, because the splitting is false.

## What this does NOT do

It closes no `sorry` in `Picard/FGAPicRepresentability.lean` and witnesses **no**
antecedent of `Scheme.fgaPicardRepresentability` for any curve: `k'`-side
representability is untouched, and `G2`'s scheme-level quotient is untouched. What it
changes is which hypothesis a `G1` consumer must supply — `γ`-invariance, which the
Galois action gives, rather than projection agreement, which it does not.

No hypothesis on `C(k)` anywhere (`I-0491`).

## Measurement discipline

`lake env lean` with **fresh** oleans for every probe; a stale-import environment
reports every probe as succeeding (`I-1057`).
-/

universe u

open CategoryTheory AlgebraicGeometry Limits
open scoped TensorProduct

namespace AlgebraicGeometry

namespace Scheme

namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

/-! ## §1. The `γ`-twist of a base-changed test -/

/-- `Spec γ : Spec k' ⟶ Spec k'`, the scheme map of a `k`-automorphism of `k'`. -/
noncomputable abbrev specGal (γ : k' ≃ₐ[k] k') :
    Spec (CommRingCat.of k') ⟶ Spec (CommRingCat.of k') :=
  Spec.map (CommRingCat.ofHom (γ : k' →+* k'))

/-- **`Spec γ` is a morphism over `Spec k`.**

This is `γ.commutes` — that `γ` fixes `k` — transported through `Spec`. It is the
only place the `k`-algebra structure of `γ` (as opposed to its being a ring
automorphism) is consumed, and everything else in this file is formal. -/
theorem specGal_comp (γ : k' ≃ₐ[k] k') :
    specGal γ ≫ specMapAlgebra k k' = specMapAlgebra k k' := by
  rw [specMapAlgebra, ← Spec.map_comp]
  congr 1
  ext x
  exact γ.commutes x

/-- The `γ`-twist of `T ×_k Spec k'` on underlying schemes: the identity on the `T`
factor and `Spec γ` on the `Spec k'` factor.

Well defined because `Spec γ` is a morphism over `Spec k` (`specGal_comp`), so the
twisted pair still satisfies the pullback condition. -/
noncomputable def twistLeft (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    pullback T.hom (specMapAlgebra k k') ⟶ pullback T.hom (specMapAlgebra k k') :=
  pullback.lift (pullback.fst _ _) (pullback.snd _ _ ≫ specGal γ) (by
    rw [Category.assoc, specGal_comp]
    exact pullback.condition)

/-- **The `γ`-twist as an endomorphism of the base-changed test, in the slice over
`Spec k`.**

This is the morphism a `γ`-invariance hypothesis is a statement about, and the
project did not have it: `Picard/GaloisDescent/` twists modules
(`SemilinearModules.lean`), algebras (`SemilinearAlgebras.lean`) and `Spec` of a
ring, but nothing twisted a *base-changed test* `T_{k'}` — which is the object
`picEt`-classes on the `k'` side live on.

It is a slice morphism over `Spec k`, not over `Spec k'`: the twist moves the
`k'`-structure and is *not* `k'`-linear, which is exactly the semilinearity of the
Galois action, and is why the descent runs in the `k`-slice. -/
noncomputable def twistTest (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    (restrictTest k k').obj (baseTest (k' := k') T) ⟶
      (restrictTest k k').obj (baseTest (k' := k') T) :=
  Over.homMk (twistLeft T γ) (by
    change twistLeft T γ ≫ pullback.snd _ _ ≫ specMapAlgebra k k' = _
    rw [twistLeft, pullback.lift_snd_assoc, Category.assoc, specGal_comp]
    rfl)

/-- **The twist lives over `T`**: it commutes with the covering morphism.

This is what makes the twist a morphism of *descent data* rather than merely of
schemes, and it is `pullback.lift_fst` — the twist is the identity on the `T`
factor. -/
theorem twistTest_comp_coverMap (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    twistTest T γ ≫ coverMap (k' := k') T = coverMap (k' := k') T := by
  apply Over.OverMorphism.ext
  change twistLeft T γ ≫ pullback.fst _ _ = pullback.fst _ _
  exact pullback.lift_fst _ _ _

/-! ## §2. The `γ`-component section of the cover's self-pullback -/

/-- **THE COHERENCE, as a morphism**: the `γ`-component
`T_{k'} ⟶ T_{k'} ×_T T_{k'}`, namely `⟨𝟙, twist γ⟩`.

`PicEtDescentExistence.lean` §4 named the open link as "the `Gal`-coproduct's
`γ`-component inclusion composed with the two projections gives `id` and `γ`", with
the ingredients listed as `pullbackSpecIso`, `IsIso (sigmaSpec …)` and
`galoisSelfTensorEquiv`. **None of those three is needed for the coherence itself.**
The section exists by the universal property of the pullback, from
`twistTest_comp_coverMap` alone, and the two identities below are
`pullback.lift_fst` and `pullback.lift_snd`. The splitting is needed for something
else — see §4.

No hypothesis on `k'/k` beyond `[Algebra k k']`. -/
noncomputable def coverSelfSection (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    (restrictTest k k').obj (baseTest (k' := k') T) ⟶
      pullback (coverMap (k := k) (k' := k') T) (coverMap (k := k) (k' := k') T) :=
  pullback.lift (𝟙 _) (twistTest T γ) (by
    rw [Category.id_comp, twistTest_comp_coverMap])

/-- The `γ`-component composed with the **first** projection is the identity. -/
@[simp] theorem coverSelfSection_fst (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    coverSelfSection T γ ≫ pullback.fst (coverMap (k := k) (k' := k') T)
      (coverMap (k := k) (k' := k') T) = 𝟙 _ :=
  pullback.lift_fst _ _ _

/-- The `γ`-component composed with the **second** projection is the `γ`-twist. -/
@[simp] theorem coverSelfSection_snd (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    coverSelfSection T γ ≫ pullback.snd (coverMap (k := k) (k' := k') T)
      (coverMap (k := k) (k' := k') T) = twistTest T γ :=
  pullback.lift_snd _ _ _

/-! ## §3. Agreement ⟹ invariance — free, and at full generality -/

/-- **The direction that is free: projection agreement gives `γ`-invariance, for
every `γ`.**

If a class `x` on `T_{k'}` has equal pullbacks along the two projections of
`T_{k'} ×_T T_{k'}`, then `x` is fixed by the `γ`-twist for every
`γ ∈ Gal(k'/k)` — hence `ajc-p2`'s hypothesis is *at least as strong as*
`γ`-invariance.

**Binder list is the measurement.** Arbitrary field `k`, arbitrary extension `k'/k`
with only `[Algebra k k']`, arbitrary test `T`, arbitrary smooth proper curve `C`:
**no** `[Module.Finite]`, **no** `[Algebra.IsSeparable]`, **no** `[IsGalois]`. So
this half of the bridge is not a Galois fact at all — which is why §4's converse,
which *does* need `IsGalois`, cannot be obtained by symmetry.

The proof is one restriction: apply `(picEt C).map (coverSelfSection T γ).op` to the
agreement and rewrite the two composites with §2. -/
theorem invariant_of_projections_agree (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (x : (picEt C).obj (Opposite.op ((restrictTest k k').obj (baseTest (k' := k') T))))
    (h : (picEt C).map (pullback.fst (coverMap (k := k) (k' := k') T)
              (coverMap (k := k) (k' := k') T)).op x
        = (picEt C).map (pullback.snd (coverMap (k := k) (k' := k') T)
              (coverMap (k := k) (k' := k') T)).op x)
    (γ : k' ≃ₐ[k] k') :
    (picEt C).map (twistTest T γ).op x = x := by
  have := congrArg ((picEt C).map (coverSelfSection T γ).op) h
  simp only [← CategoryTheory.comp_apply, ← Functor.map_comp, ← op_comp,
    coverSelfSection_fst, coverSelfSection_snd] at this
  simpa using this.symm

/-! ## §4. Invariance ⟹ agreement — an implication, with its antecedent named -/

/-- **The direction the route needs, stated with its one antecedent explicit and
undischarged.**

If the `γ`-sections `⟨𝟙, twist γ⟩` generate a **covering** sieve on the
self-pullback `T_{k'} ×_T T_{k'}` (hypothesis `hcov`), then `γ`-invariance for every
`γ` implies agreement of the two projections — which is exactly what
`Picard/PicEtDescentExistence.lean`'s `∃!` consumes.

**`hcov` IS NOT DISCHARGED HERE and this theorem does not claim it is.** Naming it
as a hypothesis rather than proving it is the honest state: what it says is that the
`Gal`-indexed family of sections is jointly surjective and étale, i.e. that
`T_{k'} ×_T T_{k'}` is the `Gal`-indexed disjoint union of copies of `T_{k'}` with
the `γ`-component being `coverSelfSection T γ`. That is a *covering* statement, not
a coherence identity, and it is where `[IsGalois k k']` enters the route —
`ajc-p1`'s `galoisSelfTensorHom_bijective_iff_isGalois` shows the splitting
`k' ⊗_k k' ≅ ∏_{Gal} k'` is **false** at a merely finite separable level, so at such
a level `hcov` fails rather than being merely unproved.

**Why this is not a weaker restatement of the obligation.** The content is that
`hcov` is the *only* thing owed: `γ`-invariance plus a covering property gives
agreement, with no further input about `picEt`, the curve, or the classes. The
`picEt` side of the argument is one line — separatedness of the sheaf at `hcov`'s
sieve, from `isSheafFor_picEt_of_mem`, which holds at *every* covering sieve — and
the rest is §2's two identities.

**Non-vacuity of `hcov`, checked by degenerate substitution rather than asserted**
(the discipline of `I-1413`): at `k' = k` the group `Gal(k/k)` is trivial and
`coverMap` is an isomorphism, so the single section `coverSelfSection T 1` is an
isomorphism and generates `⊤`, which is covering. So `hcov` is an inhabitable
hypothesis and this implication is not conditioned on a false statement. It is
`hcov` *at a nontrivial Galois level* that this file does not supply. -/
theorem projections_agree_of_invariant (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (hcov : Sieve.generate (Presieve.ofArrows
        (fun _ : k' ≃ₐ[k] k' => (restrictTest k k').obj (baseTest (k' := k') T))
        (fun γ => coverSelfSection T γ)) ∈
      etaleTopologyOver k (pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)))
    (x : (picEt C).obj (Opposite.op ((restrictTest k k').obj (baseTest (k' := k') T))))
    (hinv : ∀ γ : k' ≃ₐ[k] k', (picEt C).map (twistTest T γ).op x = x) :
    (picEt C).map (pullback.fst (coverMap (k := k) (k' := k') T)
          (coverMap (k := k) (k' := k') T)).op x
      = (picEt C).map (pullback.snd (coverMap (k := k) (k' := k') T)
          (coverMap (k := k) (k' := k') T)).op x := by
  refine (isSheafFor_picEt_of_mem C _ hcov).isSeparatedFor.ext ?_
  rintro W f ⟨Z, a, b, hb, rfl⟩
  cases hb with | mk γ =>
  simp only [op_comp, Functor.map_comp, CategoryTheory.comp_apply]
  congr 1
  simp only [← CategoryTheory.comp_apply, ← Functor.map_comp, ← op_comp,
    coverSelfSection_fst, coverSelfSection_snd]
  simp [hinv γ]

/-! ## §5. The form a `G1` consumer calls -/

section Cover

variable [Algebra.IsSeparable k k'] [Module.Finite k k']

/-- **The descent step with `γ`-invariance as its hypothesis.**

`ajc-p2`'s `exists_unique_descend_picEt_of_projections` composed with §4: a
`γ`-invariant class on `T_{k'}` descends to a **unique** class on `T`, given `hcov`.

This is the statement campaign `G1` should aim at, and the reason it could not be
stated before is that nothing turned invariance into projection agreement. What
remains owed is `hcov` and **only** `hcov` — named in §4, not restated more cheaply
here.

`[Algebra.IsSeparable]` and `[Module.Finite]` re-enter only because
`exists_unique_descend_picEt_of_projections` needs them: they are what makes
`Spec k' ⟶ Spec k` a *covering* in the étale topology. Neither §3 nor §4 uses
them. -/
theorem exists_unique_descend_picEt_of_invariant (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (hcov : Sieve.generate (Presieve.ofArrows
        (fun _ : k' ≃ₐ[k] k' => (restrictTest k k').obj (baseTest (k' := k') T))
        (fun γ => coverSelfSection T γ)) ∈
      etaleTopologyOver k (pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)))
    (x : (picEt C).obj (Opposite.op ((restrictTest k k').obj (baseTest (k' := k') T))))
    (hinv : ∀ γ : k' ≃ₐ[k] k', (picEt C).map (twistTest T γ).op x = x) :
    ∃! y : (picEt C).obj (Opposite.op T),
      (picEt C).map (coverMap (k' := k') T).op y = x :=
  exists_unique_descend_picEt_of_projections (k' := k') C T x
    (projections_agree_of_invariant C T hcov x hinv)

end Cover

end PicScheme

end Scheme

end AlgebraicGeometry
