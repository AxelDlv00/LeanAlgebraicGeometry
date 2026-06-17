/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.StructureSheafAb

/-!
# Sheaves of `k`-modules: sheafification and Ext

Phase A step 5 prerequisites (per `STRATEGY.md`): the `HasSheafify` and
`HasExt` instances on the topology of opens of an arbitrary topological space,
valued in `ModuleCat k`. The `Linear k` enrichment on the resulting sheaf
category is auto-inferable from Mathlib and therefore needs no scaffold here;
together with `CategoryTheory.Abelian.Ext.instModule` it gives the path to a
`Module k` structure on `Ext` groups, unblocking the `k`-vector-space level of
sheaf cohomology of curves over `Spec k`.

See `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`.

## Status (iteration 005 — refactor scaffold)

This file is a scaffold. The two declarations below are `sorry`. The next
prover round is responsible for filling them.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace

namespace AlgebraicGeometry.Cohomology

/-- Phase A step 5 prerequisite (a): sheafification on the topology of opens of
any topological space, valued in `ModuleCat k`. Inferable from Mathlib's
small-site / concrete-category sheafification API; the prover's task is the
universe pinning, mirroring the iter-004 `instHasSheafify_Opens_AddCommGrp`. -/
instance instHasSheafify_Opens_ModuleCatK
    (k : Type u) [CommRing k] (X : TopCat.{u}) :
    CategoryTheory.HasSheafify (Opens.grothendieckTopology X)
      (ModuleCat.{u} k) :=
  inferInstance

/-- Phase A step 5 prerequisite (b): `Ext` on the sheaf category. The universe
annotation `HasExt.{u+1}` is forced by the morphism universe of
`Sheaf (Opens.gT X) (ModuleCat.{u} k)`; mirrors the iter-004
`instHasExt_Sheaf_Opens_AddCommGrp`. -/
noncomputable instance instHasExt_Sheaf_Opens_ModuleCatK
    (k : Type u) [CommRing k] (X : TopCat.{u}) :
    CategoryTheory.HasExt.{u+1}
      (CategoryTheory.Sheaf (Opens.grothendieckTopology X)
        (ModuleCat.{u} k)) :=
  CategoryTheory.HasExt.standard _

end AlgebraicGeometry.Cohomology
