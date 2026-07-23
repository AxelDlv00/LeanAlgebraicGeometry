---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GradedModule.inf_isHomogeneous
docstring: 'The intersection of two homogeneous submodules is homogeneous. Project-local:
  Mathlib

  provides no lattice-closure lemmas for `Submodule.IsHomogeneous`.'
file: AlgebraicJacobian/Picard/GradedHilbertSerre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GradedModule.inf_isHomogeneous
type: lean
updated: '2026-07-24T03:02:10'
---
lemma inf_isHomogeneous {p q : Submodule κ M} (hp : p.IsHomogeneous ℳ)
    (hq : q.IsHomogeneous ℳ) : (p ⊓ q).IsHomogeneous ℳ := by
  intro i z hz
  exact Submodule.mem_inf.mpr
    ⟨(Submodule.IsHomogeneous.mem_iff ℳ hp).mp (Submodule.mem_inf.mp hz).1 i,
      (Submodule.IsHomogeneous.mem_iff ℳ hq).mp (Submodule.mem_inf.mp hz).2 i⟩