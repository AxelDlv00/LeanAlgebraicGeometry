---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: Module.IsDescentCocycle.mem_descended
file: AlgebraicJacobian/Descent/UnitDescent.lean
generated: lean
lean_status: lean_ok
title: Module.IsDescentCocycle.mem_descended
type: lean
updated: '2026-08-01T09:44:10'
---
lemma IsDescentCocycle.mem_descended {u : (B ⊗[A] B)ˣ} (hu : IsDescentCocycle u) {m : B} :
    m ∈ hu.descended ↔ u.val * m ⊗ₜ 1 = 1 ⊗ₜ m :=
  DescentDatum.mem_descended _

/-! ## The Picard class of a cocycle -/

section picClass

variable [Module.FaithfullyFlat A B]