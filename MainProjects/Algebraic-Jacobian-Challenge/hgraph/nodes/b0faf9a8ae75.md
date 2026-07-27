---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top
docstring: 'The `k`-linear equivalence between the global-sections module `(Sheaf.Γ
  J _).obj F` and the

  sections `F.obj.obj (op ⊤)` over the top open, for a sheaf `F` on a topological
  space `X`.


  The underlying isomorphism is `Sheaf.ΓNatIsoSheafSections`: on a site with a terminal
  object `T`,

  the global-sections functor is naturally isomorphic to evaluation at `T`. For the
  topology of opens

  `Opens.grothendieckTopology X` the terminal object of `TopologicalSpace.Opens X`
  is the top open

  `⊤`, by `Preorder.isTerminalTop`. The resulting isomorphism in `ModuleCat k` is
  upgraded to a

  `LinearEquiv` by `Iso.toLinearEquiv`.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top
type: lean
updated: '2026-07-27T01:33:11'
---
noncomputable def SheafGammaObj_linearEquiv_top
    (k : Type u) [Field k] {X : TopCat.{u}}
    (F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} k)) :
    (Sheaf.Γ (Opens.grothendieckTopology X) (ModuleCat.{u} k)).obj F
      ≃ₗ[k] F.obj.obj (Opposite.op (⊤ : TopologicalSpace.Opens X)) :=
  ((Sheaf.ΓNatIsoSheafSections (Opens.grothendieckTopology X)
      (ModuleCat.{u} k) (T := ⊤) (Preorder.isTerminalTop _)).app F).toLinearEquiv