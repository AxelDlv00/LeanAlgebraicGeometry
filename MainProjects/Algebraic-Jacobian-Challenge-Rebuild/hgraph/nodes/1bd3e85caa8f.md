---
author: sync
content_type: theorem
created: '2026-07-25T15:32:34'
decl: AlgebraicGeometry.exists_fin_span_eq_top_of_forall_prime
docstring: '**Pointwise good elements span the unit ideal, finitely.** If a predicate
  `P` on `R`

  holds at some element outside each prime, then finitely many elements satisfying
  `P` span

  `⊤`.  This is quasi-compactness of `Spec R` in the elementary form the certificate
  gate

  needs: the basic opens of the good elements cover the spectrum, hence the good set
  spans

  the unit ideal, hence `1` is a finite combination of good elements.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarPointwise.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_fin_span_eq_top_of_forall_prime
type: lean
updated: '2026-07-25T15:32:34'
---
theorem exists_fin_span_eq_top_of_forall_prime (P : R → Prop)
    (h : ∀ p : PrimeSpectrum R, ∃ r, r ∉ p.asIdeal ∧ P r) :
    ∃ (m : ℕ) (g : Fin m → R), Ideal.span (Set.range g) = ⊤ ∧ ∀ i, P (g i) := by
  classical
  -- the good elements span the unit ideal, because their basic opens cover `Spec R`
  have hspan : Ideal.span {r : R | P r} = ⊤ := by
    rw [← PrimeSpectrum.iSup_basicOpen_eq_top_iff']
    refine top_le_iff.mp fun p _ => ?_
    obtain ⟨r, hrp, hrP⟩ := h p
    exact Opens.mem_iSup.mpr ⟨r, by
      simpa only [Opens.mem_iSup, PrimeSpectrum.mem_basicOpen] using ⟨hrP, hrp⟩⟩
  -- `1` is then a finite combination of good elements
  have hone : (1 : R) ∈ Submodule.span R {r : R | P r} := by
    show (1 : R) ∈ Ideal.span {r : R | P r}
    rw [hspan]; exact Submodule.mem_top
  obtain ⟨T, hTsub, hT⟩ := Submodule.mem_span_finite_of_mem_span hone
  refine ⟨T.card, fun i => (T.equivFin.symm i : R), ?_, fun i => hTsub (T.equivFin.symm i).2⟩
  have hrange : Set.range (fun i : Fin T.card => ((T.equivFin.symm i : R))) = (T : Set R) := by
    ext x
    constructor
    · rintro ⟨i, rfl⟩
      exact (T.equivFin.symm i).2
    · intro hx
      exact ⟨T.equivFin ⟨x, hx⟩, by simp⟩
  rw [hrange]
  exact Ideal.eq_top_of_isUnit_mem _ hT isUnit_one

end SpanTop

/-! ## The pointwise certificate gate -/

section Pointwise

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]