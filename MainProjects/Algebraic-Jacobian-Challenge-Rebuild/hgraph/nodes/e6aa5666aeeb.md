---
author: sync
content_type: theorem
created: '2026-07-31T13:39:13'
decl: AlgebraicGeometry.PicEtAff.rigidity_of_away
docstring: '**THE REDUCTION, rigidity spelling**: the `hrigAff` clause at every member
  of a finite

  covering family of localizations of `A` gives it at `A`.


  Note which way the field points travel, because it is what makes this cheap: a field
  point of a

  localization `S i` restricts to a field point of `A` by composing with `A → S i`,
  so the

  antecedent **at `A`** supplies the antecedent at each `S i` — no lifting of field
  points along

  the localization is required, and no compatibility between the members is used.  The
  classes

  then agree with `1` after each localization, and separation finishes.'
file: AlgebraicJacobian/Picard/Pic0RingZariskiLocal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicEtAff.rigidity_of_away
type: lean
updated: '2026-07-31T20:15:27'
---
theorem PicEtAff.rigidity_of_away (hg : Ideal.span (Set.range g) = ⊤)
    (hloc : ∀ i, ∀ q : PicEtAff C (S i),
      (∀ (K : Type u) [Field K] [Algebra k K] (φ : S i →ₐ[k] K),
        PicEtAff.mapAlg C φ q = 1) → q = 1)
    (q : PicEtAff C A)
    (hq : ∀ (K : Type u) [Field K] [Algebra k K] (φ : A →ₐ[k] K),
      PicEtAff.mapAlg C φ q = 1) :
    q = 1 := by
  refine PicEtAff.eq_of_away_eq C g S hg (x := q) (y := 1) fun i => ?_
  rw [map_one]
  refine hloc i _ fun K _ _ φ => ?_
  rw [← PicEtAff.mapAlg_comp]
  exact hq K (φ.comp (IsScalarTower.toAlgHom k A (S i)))