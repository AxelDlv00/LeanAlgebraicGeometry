/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Genus of a smooth proper curve

The genus of a smooth, proper, geometrically irreducible curve over a field.

## Status (iteration 001 — discovery)

Mathlib b80f227 has the abstract Grothendieck-topology sheaf-cohomology API
(`CategoryTheory.Sheaf.H`) but no specialisation that yields the
$k$-vector-space dimension of $H^1(C, \mathcal O_C)$ for $C$ a smooth proper
curve over $k$. See `task_results/Genus.md` for the precise gap. The `sorry`
below is left in place per the discovery directive in `.archon/PROGRESS.md`.

### Building blocks already in Mathlib

* `CategoryTheory.Sheaf.H : Sheaf J AddCommGrpCat → ℕ → Type w'` — abstract
  cohomology with `AddCommGroup` instance (`Sheaf.instAddCommGroupH`),
  living in `Mathlib/CategoryTheory/Sites/SheafCohomology/Basic.lean`.
* `AlgebraicGeometry.Scheme.sheaf : TopCat.Sheaf CommRingCat X` — the
  structure sheaf in commutative-ring form.
* `TopCat.Sheaf C X` is *definitionally* `Sheaf (Opens.grothendieckTopology X) C`.
* `RingCat.hasForgetToAddCommGrp : HasForget₂ RingCat AddCommGrpCat`.
* `AlgebraicGeometry.Scheme.Modules X` and `SheafOfModules.toSheaf` for the
  $\mathcal O_X$-module category and its forget to `Sheaf J AddCommGrpCat`.
* `IsGrothendieckAbelian.hasExt` : provides `HasExt` on Grothendieck-abelian
  sheaf categories.

### Missing pieces (Phase A of `STRATEGY.md`)

1. A `Sheaf (Opens.gT C.toPresheafedSpace.carrier) AddCommGrpCat` built from
   `C.left.sheaf` via `forget₂ CommRingCat RingCat ⋙ forget₂ RingCat AddCommGrpCat`,
   with `HasSheafCompose` instance (sheaf condition preserved by the forgetful).
2. The instance `HasSheafify (Opens.gT X) AddCommGrpCat`.
3. The instance `HasExt (Sheaf (Opens.gT X) AddCommGrpCat)`.
4. A `Module k`-structure on the resulting `H 1` group, derived from the
   $k$-algebra structure on $\Gamma(C, \mathcal O_C)$ induced by `C.hom`.
5. (For meaningful `finrank`) finite-dimensionality, i.e. Serre's theorem on
   coherent cohomology of a proper $k$-scheme. `Module.finrank` returns `0`
   without it, so step 4 alone makes the definition type-check; step 5 is
   needed for downstream theorems.

The sketch below documents what an honest definition would look like once
those pieces exist; it is intentionally commented out so the file compiles.
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
def genus {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : ℕ :=
  -- Honest definition is `Module.finrank k (H¹(C, O_C))`, where the latter is
  -- a `k`-vector space via `C.hom : C.left ⟶ Spec (.of k)`. The current Mathlib
  -- API (b80f227) does not assemble these pieces; see the docstring above and
  -- `.archon/task_results/Genus.md` for the precise gap and helper-lemma
  -- proposals. Discovery iteration 001 leaves the sorry intentionally per
  -- `.archon/PROGRESS.md` (no constant placeholder, no axiom).
  sorry

end AlgebraicGeometry
