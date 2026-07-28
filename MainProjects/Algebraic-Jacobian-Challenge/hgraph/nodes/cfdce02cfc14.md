---
author: sync
content_type: theorem
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.quantified
file: AlgebraicJacobian/RiemannRoch/Ledger/DegreeVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.quantified
type: lean
updated: '2026-07-29T06:43:23'
---
theorem quantified (`generated_of_deg_ge` below). -/

section GlobalGeneration

omit [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)] in