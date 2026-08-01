---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.isLocalization_away_piFactor
docstring: 'Each factor of a finite product is the localization of the product away
  from the

  corresponding coordinate idempotent.'
file: AlgebraicJacobian/Picard/RelPicPi.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isLocalization_away_piFactor
type: lean
updated: '2026-08-01T09:44:17'
---
lemma isLocalization_away_piFactor (i : ι) :
    letI := piFactorAlgebra B i
    IsLocalization.Away (Pi.single i 1 : Π j, B j) (B i) := by
  letI := piFactorAlgebra B i
  refine IsLocalization.away_of_isIdempotentElem_of_mul ?_ ?_ ?_
  · have h : (Pi.single i 1 : Π j, B j) * Pi.single i 1 = Pi.single i 1 := by
      rw [← Pi.single_mul, one_mul]
    exact h
  · intro x y
    constructor
    · intro h
      have h' : x i = y i := h
      ext j
      rcases eq_or_ne j i with hj | hj
      · subst hj
        simp [h']
      · simp [hj]
    · intro h
      exact show x i = y i by
        simpa [Pi.single_apply] using congrArg (fun z => z i) h
  · intro b
    exact ⟨Pi.single i b, Pi.single_eq_same i b⟩

end PiPartition

section PiPartitionInstance

variable {ι : Type u} (B : ι → Type u) [∀ i, CommRing (B i)]
variable {k : Type u} [Field k] [∀ i, Algebra k (B i)]