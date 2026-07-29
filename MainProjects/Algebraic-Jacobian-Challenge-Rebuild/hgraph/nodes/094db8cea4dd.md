---
author: sync
content_type: theorem
created: '2026-07-17T16:57:11'
decl: AlgebraicGeometry.subsingleton_hModule_gluedSheaf_subord
docstring: '**Cohomology vanishing transports across the subordination** in every
  degree.'
file: AlgebraicJacobian/Cohomology/GluedSheafSubord.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.subsingleton_hModule_gluedSheaf_subord
type: lean
updated: '2026-07-29T15:26:08'
---
theorem subsingleton_hModule_gluedSheaf_subord (hσ : ∀ i : I, V i ≤ U (σ i))
    (hg' : ∀ i i' : I, (g' i i' : Γ(X, V i ⊓ V i')) =
      X.resHom (le_inf (inf_le_left.trans (hσ i)) (inf_le_right.trans (hσ i')))
        (g (σ i) (σ i') : Γ(X, U (σ i) ⊓ U (σ i'))))
    (hc : Scheme.IsGluingCocycle U g) (hcov : ∀ z : X, ∃ i : I, z ∈ V i) (n : ℕ) :
    Subsingleton (Sheaf.HModule (gluedSheaf k U g) n) ↔
      Subsingleton (Sheaf.HModule (gluedSheaf k V g') n) :=
  (Sheaf.HModule.mapEquiv (gluedSheafSubord k hσ hg' hc hcov)
    n).toEquiv.subsingleton_congr