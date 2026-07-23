---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.cechCohomology_OC
docstring: 'Phase A step 6 *Path 2* (iter-012 scaffold): the `n`-th Čech cohomology

  of the structure sheaf for an arbitrary indexed open cover. Defined as the

  `n`-th homology of the Čech cochain complex `Scheme.cechCochain_OC`. The

  result lives in `ModuleCat.{u} k` and therefore carries a `Module k`

  structure for free; the iter-013+ comparison theorem will identify it

  with `Scheme.HModule k (Scheme.toModuleKSheaf C) n` when the cover is

  acyclic.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.cechCohomology_OC
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def Scheme.cechCohomology_OC
    {k : Type u} [Field k] (C : Over (Spec (.of k)))
    {ι : Type u} (𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat) (n : ℕ) :
    ModuleCat.{u} k :=
  (Scheme.cechCochain_OC C 𝒰).homology n