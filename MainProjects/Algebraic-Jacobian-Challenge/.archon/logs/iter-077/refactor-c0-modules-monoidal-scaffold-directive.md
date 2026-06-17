# Refactor Directive

## Slug

c0-modules-monoidal-scaffold

## Problem

The project's Phase C step C0 (per `STRATEGY.md`) requires the symmetric monoidal structure on the category of $\mathcal O_X$-modules for a scheme $X$ — written `X.Modules` in the project's vocabulary, packaged as `SheafOfModules X.ringCatSheaf` in Mathlib's vocabulary. Mathlib provides the structure on the **presheaf** side (`PresheafOfModules.monoidalCategory`) but not on the sheaf side: there is no `MonoidalCategory (SheafOfModules R)` instance for a sheaf-of-rings `R`. This gap blocks Phase C step C1 (refining `LineBundle` from the global-sections proxy `CommRing.Pic Γ(X, ⊤)` to the geometric definition as an invertible object of the monoidal category).

The blueprint chapter `blueprint/src/chapters/Modules_Monoidal.tex` (written iter-076) describes the construction informally: sheafify the presheaf-tensor product. Mathlib has the input pieces — `PresheafOfModules.monoidalCategory`, `PresheafOfModules.sheafification`, `SheafOfModules.toSheafCompSheafToPresheafIso` — but not the assembly.

This iteration's task is to **create the Lean scaffold** for the construction: a new file `AlgebraicJacobian/Modules/Monoidal.lean` carrying the three signature stubs (`tensorObj`, `instMonoidalCategoryStruct`, `instMonoidalCategory`) with `sorry` bodies. The actual proofs are deferred to prover rounds iter-078+.

## Mathematical Justification

For a scheme $X$, the category $X.\mathrm{Modules}$ is the abelian category of sheaves of $\mathcal O_X$-modules (in Mathlib: `SheafOfModules X.ringCatSheaf`, where `X.ringCatSheaf : Sheaf X.opens.opensTop CommRingCat`). The presheaf variant `PresheafOfModules X.ringCatSheaf.val` already has a symmetric monoidal structure (Mathlib's `PresheafOfModules.monoidalCategory`), with tensor product computed pointwise:
$$
(M \otimes_{\mathcal O_X, \mathrm{psh}} N)(U) \;=\; M(U) \otimes_{\mathcal O_X(U)} N(U).
$$
The associator, unitors, and braiding are inherited pointwise from `ModuleCat (X.presheaf.obj U)`.

The presheaf tensor product is **not in general a sheaf** (Hartshorne II.5.12, or any algebraic-geometry textbook). The sheaf tensor product is defined as the sheafification of the presheaf tensor product:
$$
M \otimes_{\mathcal O_X} N \;:=\; \mathrm{sheafify}\bigl(M_{\mathrm{psh}} \otimes_{\mathcal O_X, \mathrm{psh}} N_{\mathrm{psh}}\bigr),
$$
where $(-)_{\mathrm{psh}}$ is the forgetful functor `SheafOfModules → PresheafOfModules` (Mathlib: `SheafOfModules.toPresheaf` or `sheafToPresheaf`).

The pentagon, triangle, and hexagon coherence axioms for the sheaf tensor product follow from the corresponding presheaf-side axioms and the universal property of sheafification (Mathlib: `PresheafOfModules.sheafification`). Concretely, sheafification is symmetric monoidal as a left adjoint to the inclusion `SheafOfModules → PresheafOfModules`, and tensor commutes with colimits, so the monoidal structure transfers across the adjunction.

The tensor unit on the sheaf side is the structure sheaf $\mathcal O_X$ regarded as a $\mathcal O_X$-module via its multiplication (i.e. the unit in `PresheafOfModules.monoidalCategory` sheafified — but since $\mathcal O_X$ is already a sheaf, the sheafification step is an isomorphism, so the unit is just $\mathcal O_X$ itself).

**Mathlib precedent.** `CategoryTheory.Sheaf.monoidalCategory` (in `Mathlib/CategoryTheory/Sites/Monoidal.lean` or similar) lifts a symmetric monoidal structure from a value category $A$ to $\mathrm{Sheaf}\,J\,A$ provided $J.W$ is monoidal and $A$ has weak sheafification. The wrinkle here is that the value category varies with the open set (sheaf of rings, not fixed ring), so the generic instance does not apply directly — we build a parallel construction adapted to the presheaf-of-modules formalism. The proof is bookkeeping rather than mathematics.

## Changes Requested

### Create file `AlgebraicJacobian/Modules/Monoidal.lean`

Contents:

```lean
/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# The symmetric monoidal structure on `X.Modules`

Phase C step C0 (per `STRATEGY.md`): the category of $\mathcal O_X$-modules
on a scheme $X$ carries a canonical symmetric monoidal structure, with
tensor product given by sheafification of the presheaf tensor product and
tensor unit given by the structure sheaf $\mathcal O_X$ itself.

See `blueprint/src/chapters/Modules_Monoidal.tex`.

## Status (iteration 077 — refactor-subagent scaffold)

This file scaffolds the three signatures (`tensorObj`,
`instMonoidalCategoryStruct`, `instMonoidalCategory`) needed by Phase C
step C1 (refining `LineBundle` from `CommRing.Pic Γ(X, ⊤)` to the
invertible-object definition). The bodies are `sorry` for the prover
rounds iter-078+ to fill, using:

- `PresheafOfModules.monoidalCategory` (presheaf-side structure)
- `PresheafOfModules.Monoidal.tensorObj` (pointwise tensor)
- `PresheafOfModules.sheafification` (left adjoint to inclusion)
- `SheafOfModules.toSheafCompSheafToPresheafIso` (the comparison data)

## Mathematical content

For two $\mathcal O_X$-modules $M$ and $N$,
$$
  M \otimes_{\mathcal O_X} N := \mathrm{sheafify}(M_{\mathrm{psh}} \otimes_{\mathcal O_X, \mathrm{psh}} N_{\mathrm{psh}}).
$$
The associator/unitors/braiding on the sheaf side are sheafifications of their
presheaf counterparts; the coherence axioms transfer via the universal
property of sheafification.
-/

set_option autoImplicit false

universe u

open CategoryTheory MonoidalCategory

namespace AlgebraicGeometry.Scheme.Modules

variable (X : Scheme.{u})

/-- The tensor product of two $\mathcal O_X$-modules: sheafify the presheaf
tensor product of the underlying presheaves-of-modules. -/
noncomputable def tensorObj (M N : X.Modules) : X.Modules := sorry

/-- The symmetric monoidal category structure on `X.Modules`: the tensor
product is `tensorObj`, the tensor unit is the structure sheaf $\mathcal O_X$,
and the associator, unitors, and braiding are inherited from the presheaf
side through sheafification. -/
noncomputable instance instMonoidalCategoryStruct :
    MonoidalCategoryStruct (X.Modules) := sorry

/-- The pentagon, triangle, and hexagon axioms transfer from the presheaf side
through the universal property of sheafification. -/
noncomputable instance instMonoidalCategory :
    MonoidalCategory (X.Modules) := sorry

end AlgebraicGeometry.Scheme.Modules
```

### Update file `AlgebraicJacobian.lean`

Add the new import. The current contents:

```lean
import AlgebraicJacobian.Cohomology.SheafCompose
import AlgebraicJacobian.Cohomology.StructureSheafAb
import AlgebraicJacobian.Cohomology.StructureSheafModuleK
import AlgebraicJacobian.Cohomology.MayerVietorisCore
import AlgebraicJacobian.Cohomology.MayerVietorisCover
import AlgebraicJacobian.Cohomology.BasicOpenCech
import AlgebraicJacobian.Differentials
import AlgebraicJacobian.Picard.LineBundle
import AlgebraicJacobian.Picard.Functor
import AlgebraicJacobian.Picard.FunctorAb
import AlgebraicJacobian.Rigidity
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Jacobian
import AlgebraicJacobian.AbelJacobi
```

Add `import AlgebraicJacobian.Modules.Monoidal` in a sensible position (e.g., between `Differentials` and `Picard.LineBundle`, or grouped with the other Picard/Modules files).

## Affected files

- `AlgebraicJacobian/Modules/Monoidal.lean` — NEW
- `AlgebraicJacobian.lean` — add one import

No existing files should break. The new file's `sorry` bodies don't conflict with anything; the new import doesn't cause cycles (the new file only imports `Mathlib`, and only `AlgebraicJacobian.lean` consumes it).

The exact namespace/identifier choices in the signature stubs are constrained:
- The namespace is `AlgebraicGeometry.Scheme.Modules` (under the existing `AlgebraicGeometry.Scheme.LineBundle`'s namespace tree).
- The identifier for the type is `X.Modules` — this is the existing Mathlib-side name `AlgebraicGeometry.Scheme.Modules`, *not* a new alias; check this is in Mathlib via `lean_leansearch` "Scheme Modules" before scaffolding (it should be — it's `def Modules (X : Scheme) : Type _ := SheafOfModules X.ringCatSheaf` or similar). If the exact Mathlib name is slightly different (e.g., the underlying type is exposed as `SheafOfModules` directly), adjust the stubs to match what's actually available — but **do not rename** the three new stub identifiers `tensorObj`, `instMonoidalCategoryStruct`, `instMonoidalCategory`.

## Expected Outcome

After the refactor:
1. `AlgebraicJacobian/Modules/Monoidal.lean` exists with the three `sorry`-bodied declarations.
2. `AlgebraicJacobian.lean` imports the new file.
3. `lake env lean AlgebraicJacobian/Modules/Monoidal.lean` succeeds — three `declaration uses sorry` warnings, zero errors.
4. `lake env lean AlgebraicJacobian.lean` succeeds — no new errors.
5. No `archon-protected.yaml` change (this file introduces no protected declarations).
6. No new axioms.
7. Sorry count: project total goes from 16 → 19 (the three new sorries in the scaffold).

The refactor agent should NOT attempt to fill any of the three sorries. Their proofs are deferred to iter-078+ prover rounds and require careful elaboration through the sheafification adjunction.
