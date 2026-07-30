/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.GaloisDescent.PicEtGaloisBridge

/-!
# `hcov` is a purely set-theoretic condition: joint surjectivity

`Picard/GaloisDescent/PicEtGaloisBridge.lean` §4 leaves one antecedent,
`hcov`, undischarged, and four landed `sorry`-free theorems carry it:
`projections_agree_of_invariant`, `exists_unique_descend_picEt_of_invariant`,
and the two assembly theorems of `Picard/PicEtDescentRepresentability.lean`.
`hcov` says the `Gal(k'/k)`-indexed family of sections
`coverSelfSection T γ = ⟨𝟙, twist γ⟩ : T_{k'} ⟶ T_{k'} ×_T T_{k'}`
generates a covering sieve of the étale topology on the slice over `Spec k`.

**This file reduces `hcov` to joint surjectivity of that family on points, with
nothing else owed** (`hcov_of_jointlySurjective`). The morphism-property half —
which the board and `PicEtGaloisBridge.lean`'s own `hcov_iff_scheme_level`
docstring both priced as *genuinely owed* — is **free**, and the reason is not
the one those sites were looking for.

## The repricing, and it is the finding

`I-1458` (and the corrected `hcov_iff_scheme_level` docstring after it) split
`hcov` into a *topology* half, declared free, and an *open-immersion* half,
declared owed: "the open-immersion half is genuinely owed — but a failed
`infer_instance` is not absence: `IsOpenImmersion (Sigma.ι …)` is a *theorem*
… where that theorem applies". The prescription was therefore to base-change
`selfTensorSpecCoproduct` along `T_{k'} ⟶ Spec k'` and match the coproduct's
`γ`-component to `coverSelfSection T γ`.

**None of that is needed.** The étale topology's covering criterion
(`Scheme.ofArrows_mem_precoverage_iff`) asks for `Etale` of each member, *not*
`IsOpenImmersion`; and `Etale` of a section is free by post-composition
cancellation, because `Etale` carries
`MorphismProperty.HasOfPostcompProperty @Etale`:

* `coverSelfSection T γ ≫ pullback.fst = 𝟙` (`coverSelfSection_fst`), so on
  underlying schemes the composite is `𝟙`, which is `Etale`;
* `(pullback.fst _ _).left` is `Etale`, being a base change of
  `(coverMap T).left = pullback.fst T.hom (specMapAlgebra k k')`
  (`etale_pullback_fst_specMap`) — and `Over.forget` sends the slice pullback
  to a scheme pullback, since pullback is a connected shape;
* cancelling the second factor gives `Etale (coverSelfSection T γ).left`.

So the coproduct splitting, `selfTensorSpecCoproduct`, `IsGalois` and
`sigmaSpec` are **all** absent from this file: nothing here needs the Galois
level, and `etale_coverSelfSection_left` holds for an arbitrary finite
separable `k'/k` and an arbitrary test `T`. Do not budget a coproduct
base-change argument for `hcov`.

**Why `IsOpenImmersion` was the wrong target.** It is a *stronger* property
than the site asks for. A section of an étale morphism *is* an open immersion
(the diagonal of an unramified morphism is one), so the prescribed route is not
false — it is simply not the cheapest, and it is the one that fails
`infer_instance` while the cheap one does not.

## What remains, stated exactly

`hcov_of_jointlySurjective`'s hypothesis: every point of
`(T_{k'} ×_T T_{k'}).left` is in the image of some `(coverSelfSection T γ).left`.
That is one statement about points, with no morphism property, no sieve, no
`picEt` and no slice in it. At a nontrivial Galois level it is the honest
content of `hcov` and it is **not** discharged here.

`I-1454` remains in force about the degenerate witness: at
`Mono (specMapAlgebra k k')` joint surjectivity holds for the trivial reason
that `coverSelfSection T 1` is an isomorphism, and there the *consequent* of §4
is free too. So this file does not exhibit a non-degenerate model; it removes
one of the two things a lane building one would have had to pay for.

## Main declarations

* `etale_coverSelfSection_left` — each `γ`-section is `Etale` on underlying
  schemes, unconditionally in `γ`; the étale half of `hcov`, free.
* `hcov_of_jointlySurjective` — `hcov` from joint surjectivity alone.
* `projections_agree_of_jointlySurjective`,
  `exists_unique_descend_picEt_of_jointlySurjective` — the two
  `PicEtGaloisBridge.lean` consumers restated on the set-theoretic hypothesis.
-/

open CategoryTheory Limits AlgebraicGeometry

universe u

namespace AlgebraicGeometry
namespace Scheme
namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']

/-! ## §1. The étale half of `hcov`, free -/

/-- **The `γ`-section is `Etale`, and it needs no open-immersion input.**

`coverSelfSection T γ` is a *section* of `pullback.fst (coverMap T) (coverMap T)`
by `coverSelfSection_fst`, and that projection is `Etale` on underlying schemes
as a base change of `(coverMap T).left`. `Etale` has
`MorphismProperty.HasOfPostcompProperty @Etale`, so cancelling the projection
off the identity gives the section's own étaleness.

Arbitrary `γ`, arbitrary test `T`, no `[IsGalois k k']`: this is where the
previously-quoted "genuinely owed" half of `hcov` goes. -/
theorem etale_coverSelfSection_left (T : Over (Spec (CommRingCat.of k)))
    (γ : k' ≃ₐ[k] k') :
    Etale (coverSelfSection (k := k) (k' := k') T γ).left := by
  have hcm : Etale (coverMap (k := k) (k' := k') T).left := by
    rw [coverMap_left]; exact etale_pullback_fst_specMap k k' T.left T.hom
  have hpb := (IsPullback.of_hasPullback (coverMap (k := k) (k' := k') T)
    (coverMap (k := k) (k' := k') T)).map (Over.forget (Spec (CommRingCat.of k)))
  have hfst : Etale (Limits.pullback.fst (coverMap (k := k) (k' := k') T)
      (coverMap (k := k) (k' := k') T)).left :=
    MorphismProperty.IsStableUnderBaseChange.of_isPullback (P := @Etale) hpb.flip hcm
  have hcomp : (coverSelfSection (k := k) (k' := k') T γ).left ≫
      (Limits.pullback.fst (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)).left = 𝟙 _ := by
    rw [← Over.comp_left, coverSelfSection_fst]; rfl
  refine MorphismProperty.of_postcomp (W := @Etale) (W' := @Etale) _ _ hfst ?_
  rw [hcomp]; infer_instance

/-! ## §2. `hcov` from joint surjectivity -/

/-- **`hcov` reduces to joint surjectivity on points, with nothing else owed.**

Given only that every point of the self-pullback is hit by some
`(coverSelfSection T γ).left`, the `Gal`-indexed family generates a covering
sieve of `etaleTopologyOver k`.

The route: `Scheme.Cover.mkOfCovers` assembles the family into an étale
`Cover` of the underlying scheme — joint surjectivity is its first field and
`etale_coverSelfSection_left` its second — and then
`hcov_iff_scheme_level` (already in `PicEtGaloisBridge.lean`) transports
membership from the slice to the underlying scheme, where
`Cover.mem_grothendieckTopology` finishes. The final step checks the
transported sieve contains the cover's, which is `Sieve.overEquiv_iff` applied
to `coverSelfSection T γ` itself.

**Non-vacuity, and the caveat it does not remove.** The hypothesis is
satisfiable — at `Mono (specMapAlgebra k k')` the `γ = 1` section is an
isomorphism (`etaleTopology_generate_coverSelfSection_of_mono`) — but by
`I-1454` that site *also* makes §4's consequent free, so this is
satisfiability and not a non-degenerate model. What this theorem changes is
the price of building one: only the point-level statement is left. -/
theorem hcov_of_jointlySurjective (T : Over (Spec (CommRingCat.of k)))
    (hsurj : ∀ x : (Limits.pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)).left,
      ∃ (γ : k' ≃ₐ[k] k') (y : ((restrictTest k k').obj (baseTest (k' := k') T)).left),
        (coverSelfSection (k := k) (k' := k') T γ).left y = x) :
    Sieve.generate (Presieve.ofArrows
        (fun _ : k' ≃ₐ[k] k' => (restrictTest k k').obj (baseTest (k' := k') T))
        (fun γ => coverSelfSection T γ)) ∈
      etaleTopologyOver k (Limits.pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)) := by
  let 𝒰 : Scheme.Cover.{u} (Scheme.precoverage @Etale)
      (Limits.pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)).left :=
    Scheme.Cover.mkOfCovers (P := @Etale) (k' ≃ₐ[k] k')
      (fun _ => ((restrictTest k k').obj (baseTest (k' := k') T)).left)
      (fun γ => (coverSelfSection (k := k) (k' := k') T γ).left)
      hsurj
      (fun γ => etale_coverSelfSection_left T γ)
  rw [hcov_iff_scheme_level]
  refine GrothendieckTopology.superset_covering _ ?_ 𝒰.mem_grothendieckTopology
  rintro W f ⟨Z, a, b, hb, rfl⟩
  cases hb with | mk γ =>
  refine Sieve.downward_closed _ ?_ a
  rw [Sieve.overEquiv_iff]
  refine ⟨(restrictTest k k').obj (baseTest (k' := k') T),
    Over.homMk (𝟙 _) ?_, coverSelfSection (k := k) (k' := k') T γ,
    Presieve.ofArrows.mk γ, ?_⟩
  case refine_1 =>
    exact (Category.id_comp _).trans ((coverSelfSection (k := k) (k' := k') T γ).w).symm
  case refine_2 =>
    apply Over.OverMorphism.ext
    exact Category.id_comp _

/-! ## §3. The two `PicEtGaloisBridge` consumers, on the new hypothesis -/

/-- **`projections_agree_of_invariant` with `hcov` replaced by joint
surjectivity.** This is the form a `G1` consumer can actually aim at: the
hypothesis is a statement about points of one scheme. -/
theorem projections_agree_of_jointlySurjective (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (hsurj : ∀ x : (Limits.pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)).left,
      ∃ (γ : k' ≃ₐ[k] k') (y : ((restrictTest k k').obj (baseTest (k' := k') T)).left),
        (coverSelfSection (k := k) (k' := k') T γ).left y = x)
    (x : (picEt C).obj (Opposite.op ((restrictTest k k').obj (baseTest (k' := k') T))))
    (hinv : ∀ γ : k' ≃ₐ[k] k', (picEt C).map (twistTest T γ).op x = x) :
    (picEt C).map (Limits.pullback.fst (coverMap (k := k) (k' := k') T)
          (coverMap (k := k) (k' := k') T)).op x
      = (picEt C).map (Limits.pullback.snd (coverMap (k := k) (k' := k') T)
          (coverMap (k := k) (k' := k') T)).op x :=
  projections_agree_of_invariant C T (hcov_of_jointlySurjective T hsurj) x hinv

/-- **The descent step with a point-level hypothesis.**

`exists_unique_descend_picEt_of_invariant` composed with §2: a `γ`-invariant
class on `T_{k'}` descends to a unique class on `T`, given only that the
`γ`-sections are jointly surjective on points. -/
theorem exists_unique_descend_picEt_of_jointlySurjective
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (hsurj : ∀ x : (Limits.pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)).left,
      ∃ (γ : k' ≃ₐ[k] k') (y : ((restrictTest k k').obj (baseTest (k' := k') T)).left),
        (coverSelfSection (k := k) (k' := k') T γ).left y = x)
    (x : (picEt C).obj (Opposite.op ((restrictTest k k').obj (baseTest (k' := k') T))))
    (hinv : ∀ γ : k' ≃ₐ[k] k', (picEt C).map (twistTest T γ).op x = x) :
    ∃! y : (picEt C).obj (Opposite.op T),
      (picEt C).map (coverMap (k' := k') T).op y = x :=
  exists_unique_descend_picEt_of_invariant C T (hcov_of_jointlySurjective T hsurj) x hinv

end PicScheme
end Scheme
end AlgebraicGeometry
