---
author: sync
content_type: theorem
created: '2026-07-29T22:29:09'
decl: AlgebraicJacobian.TwoTerm.isClosed_le_finrank_ker_baseChange
docstring: '**Closed form**: the superlevel locus of the fibrewise kernel dimension
  is

  closed.  The complement of `isOpen_finrank_ker_baseChange_le`; this is the

  direction milestone B6 consumes.'
file: AlgebraicJacobian/Picard/TwoTermKernelSemicontinuity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.TwoTerm.isClosed_le_finrank_ker_baseChange
type: lean
updated: '2026-07-29T23:31:12'
---
theorem isClosed_le_finrank_ker_baseChange (n : ℕ) (k : K →ₗ[A] (Fin n → A))
    [Module.FinitePresentation A K] (e : ℕ) :
    IsClosed {t : PrimeSpectrum A | e + 1 ≤ Module.finrank t.asIdeal.ResidueField
      (LinearMap.ker (k.baseChange t.asIdeal.ResidueField))} := by
  have hcompl : {t : PrimeSpectrum A | e + 1 ≤ Module.finrank t.asIdeal.ResidueField
        (LinearMap.ker (k.baseChange t.asIdeal.ResidueField))}
      = {t : PrimeSpectrum A | Module.finrank t.asIdeal.ResidueField
        (LinearMap.ker (k.baseChange t.asIdeal.ResidueField)) ≤ e}ᶜ := by
    ext t
    simp only [Set.mem_setOf_eq, Set.mem_compl_iff, not_le]
    omega
  rw [hcompl]
  exact (isOpen_finrank_ker_baseChange_le n k e).isClosed_compl