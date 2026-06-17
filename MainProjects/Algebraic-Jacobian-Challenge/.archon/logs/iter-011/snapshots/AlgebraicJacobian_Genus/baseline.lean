/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.StructureSheafModuleK

/-!
# Genus of a smooth proper curve

The genus of a smooth, proper, geometrically irreducible curve over a field.

## Status (iteration 011 — `genus` closure scheduled)

The iter-011 refactor adds the `noncomputable` modifier (user-authorised
`2026-05-07`) and an import of `AlgebraicJacobian.Cohomology.StructureSheafModuleK`
so the body can use the project's `ModuleCat k`-flavoured cohomology
`Scheme.HModule` (iter-009) of the structure sheaf
`Scheme.toModuleKSheaf` (iter-006). The body itself is filled by the
iter-011 prover round with the probe-confirmed one-liner

    Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)

which is the honest mathematical definition `dim_k H^1(C, O_C)`.

See `blueprint/src/chapters/Genus.tex` for the informal proof sketch and
`.archon/STRATEGY.md` for the multi-phase build-out plan.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-
-- Sketch of the route once Phase A is available:
--
-- noncomputable def OXAsAddCommGrpSheaf
--     {k : Type u} [Field k] (C : Over (Spec (.of k))) :
--     CategoryTheory.Sheaf
--       (TopologicalSpace.Opens.grothendieckTopology
--         C.left.toPresheafedSpace.carrier) AddCommGrpCat :=
--   ⟨C.left.sheaf.1.comp
--     (forget₂ CommRingCat RingCat ⋙ forget₂ RingCat AddCommGrpCat), by
--     -- Use `Presheaf.isSheaf_iff_isSheaf_comp` plus the fact that
--     -- forgetful functors `CommRingCat ⥤ RingCat ⥤ AddCommGrpCat`
--     -- create limits of multispan diagrams.
--     sorry⟩
--
-- noncomputable def H1OC
--     {k : Type u} [Field k] (C : Over (Spec (.of k))) : Type _ :=
--   (OXAsAddCommGrpSheaf C).H 1
--
-- The `Module k`-instance on `H1OC` would come from the `k`-algebra
-- structure on `Γ(C, O_C)` (via `C.hom : C.left ⟶ Spec (.of k)`),
-- propagated through the abelian-group cohomology by functoriality.
-/

-- data
/-- The genus of a smooth proper curve. -/
noncomputable def genus {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : ℕ :=
  -- Iter-011 closure scaffold: the body is filled by the prover round with
  -- `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. The
  -- `noncomputable` modifier is authorised by the user (recorded
  -- `2026-05-07` in `.archon/USER_HINTS.md`) because the honest body uses
  -- `Module.finrank`, `Abelian.Ext.instModule`, and `toModuleKSheaf` — all
  -- noncomputable Mathlib API. Argument types, names, and order remain
  -- verbatim per `archon-protected.yaml`.
  sorry

end AlgebraicGeometry
