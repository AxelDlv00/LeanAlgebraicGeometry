---
author: sync
content_type: theorem
created: '2026-07-28T18:12:19'
decl: CategoryTheory.permAut_eq_map
docstring: '**The action, expressed as a diagram map.** `permAut C σ` is the diagram''s
  map at

  `σ⁻¹`; the double inverse is the `End`-convention bookkeeping of `permEnd`. This
  is the

  bridge every proof below crosses.'
file: AlgebraicJacobian/Albanese/SymPowColimit.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.permAut_eq_map
type: lean
updated: '2026-07-28T18:12:19'
---
theorem permAut_eq_map (σ : Equiv.Perm (Fin n)) :
    MonObj.permAut C σ = (permDiagram C n).map (SingleObj.toEnd (Equiv.Perm (Fin n)) σ⁻¹) := by
  change MonObj.permAut C σ = MonObj.permAut C σ⁻¹⁻¹
  rw [inv_inv]

omit [CartesianMonoidalCategory K] in