---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.abelCechClass
docstring: '**The Abel Čech class** on the test `T = C`: the class `𝒪(Δ) · 𝒪(P × C)⁻¹`
  of the

  diagonal minus the constant graph, both spelled through the graph API — the graph
  of

  `𝟙 C` is the diagonal, the graph of `toUnit C ≫ P` is `P × C`.'
file: AlgebraicJacobian/Picard/AbelElement.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.abelCechClass
type: lean
updated: '2026-07-16T21:33:28'
---
def abelCechClass (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) : (C ⊗ C).left.CechPic :=
  Over.graphPicClass C (𝟙 C) * (Over.graphPicClass C (toUnit C ≫ P))⁻¹

variable (C) in