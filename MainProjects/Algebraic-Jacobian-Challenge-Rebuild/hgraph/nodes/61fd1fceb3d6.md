---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.windowM_choice
docstring: '**The embedding exponent `M`** — least `M` with `M·δ ≥ b + 2g + (g + 2)·(s
  + 1)·δ`

  (worksheet §2.1). Chosen so every embedding/normalization/lane window down to depth

  `g + 1` in `P`-steps stays `≥ b`.'
file: AlgebraicJacobian/RiemannRoch/WindowLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.windowM_choice
type: lean
updated: '2026-07-30T15:46:08'
---
noncomputable def windowM_choice (g : ℕ) : ℕ := Nat.find (windowM_exists π hπ g)