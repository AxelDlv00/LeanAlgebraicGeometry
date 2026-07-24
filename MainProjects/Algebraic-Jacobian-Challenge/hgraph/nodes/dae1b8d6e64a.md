---
author: sync
content_type: lemma
created: '2026-07-24T17:02:56'
decl: RingTheory.Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator
docstring: '**Matrix-collapse on Ext.** For an R-linear map `A : R^m →ₗ R^n` whose
  every

  matrix entry `A (Pi.single j 1) i` lies in `Ann_R N`, the postcomposition map

  `Ext^p(N, R^m) → Ext^p(N, R^n)` induced by `mk₀ (ofHom A)` is the zero map.


  Proof: write `A = ∑_{(i,j)} A_{i,j} • E_{i,j}` via `linearMap_finFunR_matrix_decomp`.

  Push through `ofHom`, `mk₀`, and `Ext.comp` using `ofHom_sum / mk₀_sum / comp_sum`

  plus `ofHom_smul / mk₀_smul / comp_smul`. Each summand becomes

  `A_{i,j} • (e.comp (mk₀ (ofHom (elemMap _ _ i j))))`, where the scalar `A_{i,j}`

  lies in `Ann_R N`. The existing `ext_smul_eq_zero_of_mem_annihilator` (Stacks

  00LP fragment) makes each such scalar action zero. Hence the total sum is zero.'
file: AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
generated: lean
lean_status: lean_ok
title: RingTheory.Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator
type: lean
updated: '2026-07-24T17:02:56'
---
private lemma ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator
    {R : Type u} [CommRing R]
    {N : ModuleCat.{u} R}
    {n m : ℕ}
    (A : (Fin m → R) →ₗ[R] (Fin n → R))
    (hA : ∀ (i : Fin n) (j : Fin m),
        A (Pi.single j 1) i ∈ _root_.Module.annihilator R (N : Type u))
    {p : ℕ} (e : Abelian.Ext.{u} N (ModuleCat.of R (Fin m → R)) p) :
    e.comp (CategoryTheory.Abelian.Ext.mk₀
              (ModuleCat.ofHom A :
                ModuleCat.of R (Fin m → R) ⟶ ModuleCat.of R (Fin n → R)))
          (add_zero p) = 0 := by
  classical
  rw [linearMap_finFunR_matrix_decomp A]
  rw [show (ModuleCat.ofHom (∑ ij : Fin n × Fin m,
      A (Pi.single ij.2 1) ij.1 • elemMap n m ij.1 ij.2) :
      ModuleCat.of R (Fin m → R) ⟶ ModuleCat.of R (Fin n → R))
      = ∑ ij : Fin n × Fin m, ModuleCat.ofHom
          (A (Pi.single ij.2 1) ij.1 • elemMap n m ij.1 ij.2) from by
    refine ModuleCat.hom_ext ?_
    rw [ModuleCat.hom_sum]
    rfl]
  rw [CategoryTheory.Abelian.Ext.mk₀_sum]
  rw [CategoryTheory.Abelian.Ext.comp_sum]
  apply Finset.sum_eq_zero
  intro ij _
  rw [show (ModuleCat.ofHom (A (Pi.single ij.2 1) ij.1 • elemMap n m ij.1 ij.2) :
      ModuleCat.of R (Fin m → R) ⟶ ModuleCat.of R (Fin n → R))
      = A (Pi.single ij.2 1) ij.1 • ModuleCat.ofHom (elemMap n m ij.1 ij.2) from by
    refine ModuleCat.hom_ext ?_; rfl]
  rw [show (CategoryTheory.Abelian.Ext.mk₀
      (A (Pi.single ij.2 1) ij.1 • ModuleCat.ofHom (elemMap n m ij.1 ij.2)) :
        Abelian.Ext.{u} (ModuleCat.of R (Fin m → R)) (ModuleCat.of R (Fin n → R)) 0)
      = A (Pi.single ij.2 1) ij.1 • CategoryTheory.Abelian.Ext.mk₀
          (ModuleCat.ofHom (elemMap n m ij.1 ij.2)) from
      CategoryTheory.Abelian.Ext.mk₀_smul (R := R) _ _]
  rw [CategoryTheory.Abelian.Ext.comp_smul]
  exact ext_smul_eq_zero_of_mem_annihilator _ (hA ij.1 ij.2)

end Module

/-! ## §5. The Auslander–Buchsbaum formula

For a nonzero finite module `M` of finite projective dimension over a
Noetherian local ring `(R, 𝔪)`, the **Auslander–Buchsbaum formula** reads
```
  pd_R(M) + depth(M) = depth(R)
```
(Stacks tag 090V). The proof inducts on `depth(M)`: the base case
`depth(M) = 0` uses a minimal finite free resolution of `M` and the
"what is exact" criterion (Stacks 00MF) plus iterated application of the
depth-on-a-short-exact-sequence lemma (§4) to bound `depth(R)` against the
resolution length; the inductive step picks a common non-zero-divisor
`x ∈ 𝔪` on both `R` and `M`, applies the snake lemma to obtain a minimal
finite free resolution of `M/xM` over `R/xR` of the same length, and uses
the inductive hypothesis on `M/xM` over `R/xR`.

Blueprint reference: `thm:auslander_buchsbaum` (Stacks tag 090V). -/

/-! ### Helper iter-202 Lane AB Path B (axiom-clean): ℕ∞ combine for the