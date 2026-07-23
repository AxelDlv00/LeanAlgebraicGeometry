---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GradedModule.polyEndHom_lastVar_sub_mem
docstring: '**Mod-`P''` semilinearity heart.** For `m ∈ P`, evaluating a polynomial
  `s` via the full

  endomorphism family `t` agrees, modulo `P''`, with first projecting away the last
  variable

  (`lastVarAlgHom`) and evaluating via `t ∘ Fin.castSucc` — provided the last endomorphism

  `x = t (Fin.last r)` carries `P` into `P''` and `P, P''` are stable under every
  `t i`. This is the

  algebraic content of the finiteness transfer (`lem:graded_subquotient_finite_transfer`).'
file: AlgebraicJacobian/Picard/GradedHilbertSerre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GradedModule.polyEndHom_lastVar_sub_mem
type: lean
updated: '2026-07-16T21:14:27'
---
lemma polyEndHom_lastVar_sub_mem {r : ℕ} (t : Fin (r + 1) → Module.End κ M)
    (hcomm : ∀ i j, Commute (t i) (t j)) {P P' : Submodule κ M}
    (hP : ∀ i, P.map (t i) ≤ P) (hP' : ∀ i, P'.map (t i) ≤ P')
    (hannih : P.map (t (Fin.last r)) ≤ P')
    (s : MvPolynomial (Fin (r + 1)) κ) :
    ∀ m ∈ P, (polyEndHom t hcomm s) m
      - (polyEndHom (fun i => t (Fin.castSucc i)) (fun i j => hcomm _ _)
          (lastVarAlgHom r κ s)) m ∈ P' := by
  induction s using MvPolynomial.induction_on with
  | C a =>
      intro m _
      rw [lastVarAlgHom_C, polyEndHom_C, polyEndHom_C, sub_self]
      exact P'.zero_mem
  | add p q hp hq =>
      intro m hm
      rw [map_add, map_add, map_add, LinearMap.add_apply, LinearMap.add_apply]
      have := P'.add_mem (hp m hm) (hq m hm)
      convert this using 1
      abel
  | mul_X p j hp =>
      intro m hm
      rw [map_mul, polyEndHom_X, Module.End.mul_apply]
      rcases Fin.eq_castSucc_or_eq_last j with ⟨i, rfl⟩ | rfl
      · -- `j = castSucc i`: reduce to the IH at `t (castSucc i) m ∈ P`
        rw [map_mul, lastVarAlgHom_X_castSucc, map_mul, polyEndHom_X, Module.End.mul_apply]
        exact hp _ (hP _ (Submodule.mem_map_of_mem hm))
      · -- `j = last`: the right term vanishes; the left lands in `P'` by annihilation
        rw [map_mul, lastVarAlgHom_X_last, mul_zero, map_zero, LinearMap.zero_apply, sub_zero]
        exact polyEndHom_mem_of_stable t hcomm hP' p _
          (hannih (Submodule.mem_map_of_mem hm))