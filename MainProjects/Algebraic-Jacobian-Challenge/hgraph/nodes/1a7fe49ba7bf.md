---
author: sync
content_type: theorem
created: '2026-07-30T01:58:51'
decl: AlgebraicGeometry.Scheme.PicScheme.relPresheaf_crossBaseIso
docstring: '**The cross-base identification at the level of the UNSHEAFIFIED relative

  Picard presheaf.** This is the one statement this file leaves open, and it is

  stated here rather than assumed anywhere downstream.


  What it says: the relative Picard presheaf of the base-changed curve `C_{k''}`,

  as a functor on `k''`-tests, agrees with the relative Picard presheaf of `C`

  evaluated on restricted tests.


  **Why it is plausible and what remains.** On a fixed test `T` the two carriers

  are `Pic(C_{k''} ×_{k''} T)/π_T^* Pic(T)` and `Pic(C ×_k T)/π_T^* Pic(T)`, and

  the two total spaces are canonically isomorphic — that is `crossBaseTotalIso`

  above, proved. What is left is to transport the `H_T`-coset quotient along that

  iso (the subgroup being quotiented by is the pullback of `Pic(T)` on both

  sides, and `crossBaseTotalIso_hom_snd` says the two projections to `T` agree,

  which is what makes the subgroups correspond) and to check naturality in `T`.

  That is bookkeeping over an established scheme-level iso, not a further

  geometric input.


  **Deliberately left as an explicit `sorry`.** Per the round''s discipline this

  is a named open obligation, not a hidden one: no declaration in this file

  consumes it, and `picEt_crossBaseIso_of_relPresheaf` below takes the

  corresponding iso as an explicit *hypothesis* rather than invoking this.'
file: AlgebraicJacobian/Picard/PicEtCrossBase.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Scheme.PicScheme.relPresheaf_crossBaseIso
type: lean
updated: '2026-07-30T01:58:51'
---
theorem relPresheaf_crossBaseIso (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] (k' : Type u) [Field k']
    [Algebra k k'] :
    Nonempty (PicSharp.relPresheaf (baseChangeField C k')
      ≅ (restrictTest k k').op ⋙ PicSharp.relPresheaf C) :=
  sorry

/-! ## §4. The reduction: sheafification adds nothing -/