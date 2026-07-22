---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: Module.tensorSqBaseChange_tmul
file: AlgebraicJacobian/Descent/UnitDescentBaseChange.lean
generated: lean
lean_status: lean_ok
title: Module.tensorSqBaseChange_tmul
type: lean
updated: '2026-07-16T21:33:28'
---
lemma tensorSqBaseChange_tmul (x y : B) :
    tensorSqBaseChange A A' B (x ⊗ₜ y)
      = ((1 : A') ⊗ₜ[A] x) ⊗ₜ[A'] ((1 : A') ⊗ₜ[A] y) := by
  simp [tensorSqBaseChange]

variable (A A' B) in