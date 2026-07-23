---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top
docstring: 'Iter-045: LinearEquiv between the global-sections module

  `(Sheaf.Γ J _).obj F` (an object of `ModuleCat k`) and the underlying carrier

  of `F.obj.obj (op ⊤)` for any sheaf `F` on a topological space `X`.


  The underlying iso comes from `Sheaf.ΓNatIsoSheafSections` (Mathlib

  `Mathlib/CategoryTheory/Sites/GlobalSections.lean`): on a site with terminal

  `T`, the global-sections functor is naturally iso to evaluation at `T`. For

  the topology of opens `Opens.grothendieckTopology X`, the terminal in

  `TopologicalSpace.Opens X` is the top open `⊤` (this is `Preorder.isTerminalTop`

  for any preorder with a top element). The categorical iso in `ModuleCat k` is

  converted to a `LinearEquiv` via `Iso.toLinearEquiv` (Mathlib''s standard

  upgrading of `ModuleCat`-isos to LinearEquivs).


  Iter-046+ uses this `LinearEquiv` together with the linearised constant-sheaf

  / global-sections adjunction (multi-iteration; project-local lift of

  Mathlib''s `Adjunction.homAddEquiv` to `≃ₗ[k]`) to construct the producer

  instance `IsHModuleHomFinite k C (toModuleKSheaf C)`.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def SheafGammaObj_linearEquiv_top
    (k : Type u) [Field k] {X : TopCat.{u}}
    (F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} k)) :
    (Sheaf.Γ (Opens.grothendieckTopology X) (ModuleCat.{u} k)).obj F
      ≃ₗ[k] F.obj.obj (Opposite.op (⊤ : TopologicalSpace.Opens X)) :=
  ((Sheaf.ΓNatIsoSheafSections (Opens.grothendieckTopology X)
      (ModuleCat.{u} k) (T := ⊤) (Preorder.isTerminalTop _)).app F).toLinearEquiv