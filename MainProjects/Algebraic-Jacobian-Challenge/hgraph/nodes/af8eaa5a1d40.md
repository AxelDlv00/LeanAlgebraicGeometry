---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.hModuleOne_linearEquiv_cechCohomology_curve
docstring: '**Node N6 (bridge), curve specialisation.** Direct application of

  `hModuleOne_linearEquiv_cechCohomology` to the structure sheaf

  `F := Scheme.toModuleKSheaf C`.  Mirrors the iter-039/…/iter-050 `_curve` pattern

  (dot-notation resolution against the structure sheaf), giving

  `HModule k (toModuleKSheaf C) n ≃ₗ[k] cechCohomology C (toModuleKSheaf C) 𝒰 n`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.hModuleOne_linearEquiv_cechCohomology_curve
type: lean
updated: '2026-07-24T03:02:13'
---
noncomputable def hModuleOne_linearEquiv_cechCohomology_curve
    {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
    {ι : Type u} (𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat)
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [HasCechToHModuleIso (Scheme.toModuleKSheaf C) 𝒰]
    (h : ⨆ i, 𝒰 i = ⊤) (n : ℕ) :
    HModule k (Scheme.toModuleKSheaf C) n
      ≃ₗ[k] cechCohomology C (Scheme.toModuleKSheaf C) 𝒰 n :=
  hModuleOne_linearEquiv_cechCohomology (Scheme.toModuleKSheaf C) 𝒰 h n

/-! ## Node N5 — the concrete 2-element cover family of an `AffineCoverMVSquare` -/