---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.gradedModule_hilbertSeries_rational
docstring: '**Graded Hilbert–Serre: rationality of the Hilbert series** (`lem:gradedHilbertSerre_rational`).

  For a graded `κ`-module `M = ⨁ ℳ n` with finite-dimensional components, equipped
  with `r`

  pairwise-commuting degree-one endomorphisms (the degree-one generators of the action)
  for which `M`

  is finite over the free polynomial ring `MvPolynomial (Fin r) κ`, the Hilbert function

  `n ↦ dim_κ ℳ n` is a rational Hilbert function of order `r`: there are `p ∈ ℚ[X]`
  and `N` with

  `dim_κ ℳ n = [Xⁿ](p · (1 - X)⁻ʳ)` for all `n > N`. This is the substantive (non-Mathlib)
  half of

  graded Hilbert–Serre; it is obtained from the ambient subquotient induction

  (`GradedModule.subquotient_hilbertSeries_rational`) applied to the top datum `(⊤,
  ⊥)`.'
file: AlgebraicJacobian/Picard/GradedHilbertSerre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gradedModule_hilbertSeries_rational
type: lean
updated: '2026-07-24T03:02:10'
---
lemma gradedModule_hilbertSeries_rational {κ M : Type*} [Field κ] [AddCommGroup M] [Module κ M]
    (ℳ : ℕ → Submodule κ M) [DirectSum.Decomposition ℳ] [∀ n, FiniteDimensional κ ↥(ℳ n)]
    {r : ℕ} (t : Fin r → Module.End κ M) (hcomm : ∀ i j, Commute (t i) (t j))
    (hraise : ∀ i, GradedModule.RaisesDegree ℳ (t i))
    (hfin : letI := GradedModule.polyModule t hcomm
      Module.Finite (MvPolynomial (Fin r) κ) M) :
    IsRatHilb (fun n => (Module.finrank κ ↥(ℳ n) : ℚ)) r := by
  letI := GradedModule.polyModule t hcomm
  haveI := hfin
  -- the top datum `(⊤, ⊥)`: its finiteness is exactly `M` finite over the polynomial ring
  have hfintop : Module.Finite (MvPolynomial (Fin r) κ)
      (↥(GradedModule.polySubmodule t hcomm ⊤ (fun _ => le_top)) ⧸
        (GradedModule.polySubmodule t hcomm ⊥ (fun _ => by rw [Submodule.map_bot])).comap
          (GradedModule.polySubmodule t hcomm ⊤ (fun _ => le_top)).subtype) := by
    refine Module.Finite.of_surjective
      ({ toFun := fun m => Submodule.Quotient.mk ⟨m, Submodule.mem_top⟩
         map_add' := fun a b => by rw [← Submodule.Quotient.mk_add]; rfl
         map_smul' := fun c a => by rw [← Submodule.Quotient.mk_smul]; rfl } :
        M →ₗ[MvPolynomial (Fin r) κ] _) ?_
    intro z
    refine Submodule.Quotient.induction_on _ z (fun y => ⟨(y : M), rfl⟩)
  set D : GradedModule.SubquotientDatum ℳ r :=
    { N := ⊤
      N' := ⊥
      hle := bot_le
      hN := by intro i x _; exact Submodule.mem_top
      hN' := by intro i x hx; rw [Submodule.mem_bot] at hx; subst hx; simp
      t := t
      hcomm := hcomm
      hraise := hraise
      hpresN := fun _ => le_top
      hpresN' := fun _ => by rw [Submodule.map_bot]
      hfin := hfintop } with hD
  have hrat := GradedModule.subquotient_hilbertSeries_rational ℳ D
  have heq : GradedModule.SubquotientDatum.hilb ℳ D
      = fun n => (Module.finrank κ ↥(ℳ n) : ℚ) := by
    funext n
    change (((Module.finrank κ ↥((⊤ : Submodule κ M) ⊓ ℳ n) : ℤ)
        - (Module.finrank κ ↥((⊥ : Submodule κ M) ⊓ ℳ n) : ℤ) : ℤ) : ℚ)
      = (Module.finrank κ ↥(ℳ n) : ℚ)
    rw [top_inf_eq, bot_inf_eq, finrank_bot]
    simp
  rwa [heq] at hrat