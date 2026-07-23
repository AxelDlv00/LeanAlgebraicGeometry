---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.hModuleOne_linearEquiv_cechCohomology
docstring: '**Node N6 (bridge), abstract sheaf form.** For a sheaf `F` of `k`-modules
  on a

  `Spec k`-scheme `C` and a cover `𝒰` with `⨆ 𝒰 = ⊤` satisfying the Čech-to-derived

  comparison gate `HasCechToHModuleIso F 𝒰`, the genus-degree cohomology

  `HModule k F n` is `k`-linearly identified with the Čech cohomology

  `cechCohomology C F 𝒰 n` of the cover.


  The equivalence chains the iter-050 comparison

  `cechToHModuleIso n : cechCohomology C F 𝒰 n ≃ₗ[k] HModule'' k F n (⨆ 𝒰)` with the

  iter-034 universe bridge `HModule''_eq_HModule_linearEquiv` at the terminal open

  `⊤ = ⨆ 𝒰` (using `Preorder.isTerminalTop` transported along `h`, exactly the

  iter-035 `HModule''_X₄_linearEquiv` pattern), then symmetrises.


  This is stated *conditional* on the `HasCechToHModuleIso` gate — no new `sorry`
  or

  gate is introduced.  Downstream (`N5`, the finiteness keystone `N11`/`N12`) the

  useful degree is `n = 1`: it reduces `H¹(C, 𝒪_C)` to the concrete Čech `H¹`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.hModuleOne_linearEquiv_cechCohomology
type: lean
updated: '2026-07-24T03:02:13'
---
noncomputable def hModuleOne_linearEquiv_cechCohomology
    {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
    (F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))
    {ι : Type u} (𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat)
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    [HasCechToHModuleIso F 𝒰]
    (h : ⨆ i, 𝒰 i = ⊤) (n : ℕ) :
    HModule k F n ≃ₗ[k] cechCohomology C F 𝒰 n :=
  ((cechToHModuleIso n).trans
    (HModule'_eq_HModule_linearEquiv k F n
      (h.symm ▸ Preorder.isTerminalTop (TopologicalSpace.Opens C.left.toTopCat)))).symm