---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.CombinatorialCech.depDiff_eq_of_cocycle
docstring: 'Dependent cocycle⟹coboundary (the geometric half consumed by L2): if

  `depDiff t = 0` then `t = depDiff (depHomotopy t)`.'
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.CombinatorialCech.depDiff_eq_of_cocycle
type: lean
updated: '2026-07-24T03:02:09'
---
lemma depDiff_eq_of_cocycle
    (hu : ∀ {m : ℕ} (σ : Fin (m + 1) → ι)
        (y : A (m + 1)
          ((Fin.cons r σ : Fin (m + 2) → ι) ∘ (0 : Fin (m + 2)).succAbove)),
        c (m + 1) σ (δ (m + 1) (Fin.cons r σ) 0 y)
          = (cons_comp_zero_succAbove r σ) ▸ y)
    (hsh : ∀ {m : ℕ} (σ : Fin (m + 1) → ι) (k : Fin (m + 1))
        (y : A (m + 1)
          ((Fin.cons r σ : Fin (m + 2) → ι) ∘ (k.succ).succAbove)),
        c (m + 1) σ (δ (m + 1) (Fin.cons r σ) (k.succ) y)
          = δ m σ k (c m (σ ∘ k.succAbove) ((cons_comp_succAbove_succ r σ k) ▸ y)))
    {m : ℕ} (t : ∀ σ : Fin (m + 1) → ι, A (m + 1) σ)
    (ht : depDiff δ t = 0) (σ : Fin (m + 1) → ι) :
    depDiff δ (depHomotopy r c t) σ = t σ := by
  have h := depHomotopy_spec r δ c hu hsh t σ
  rw [show depHomotopy r c (depDiff δ t) σ = 0 by rw [ht]; simp [depHomotopy], add_zero] at h
  exact h

omit [∀ m σ, AddCommGroup (A m σ)] in