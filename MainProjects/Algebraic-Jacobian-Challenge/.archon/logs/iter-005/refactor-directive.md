<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-06T09:56:47Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive — iteration 005

## Mathematical context

The iter-004 multilane prover round (lanes anthropic + deepseek; merged commit
`2686f4e`) honestly closed the four scaffold sorries laid by the iter-004
refactor: `instHasSheafify_Opens_AddCommGrp`, `instHasExt_Sheaf_Opens_AddCommGrp`,
`Scheme.toAbSheaf`, and `PicardFunctorAb`. Plan-agent verification (iter-005)
confirms `lean_diagnostic_messages` is clean on every file, no new axioms, and
all four declarations carry only standard kernel axioms. Sorry count is back to
the pre-refactor baseline of 10 (9 protected + 1 deferred `representable`).

The project is now positioned to take the **next narrow bite of Phase A** (per
`STRATEGY.md`):

- **Phase A step 5 main** (the `Module k` structure on $H^1(C, \mathcal O_C)$
  for a curve `C` over `Spec k`) is unblocked at the *typeclass-API* level by
  `CategoryTheory.Abelian.Ext.instModule`: in any `Linear R`-enriched abelian
  category, `Ext X Y n` is automatically a `Module R`. For `R = k` and the
  category `Sheaf (Opens.gT X) (ModuleCat k)`, the `Linear k` instance is
  *auto-inferable* in Mathlib (verified by `lean_run_code`). Once the
  `HasSheafify` and `HasExt` instances on this category are in place, the only
  remaining piece of mathematical content for step 5 main is constructing
  `Scheme.toModuleKSheaf C : Sheaf (Opens.gT C.toTopCat) (ModuleCat k)` for a
  scheme `C : Over (Spec k)`. That latter step is the substantive iter-006+
  technical work; this directive is **not** that step.
- **Track C step 4** (`PicardFunctorAb.forgetCompare`: the natural iso recovering
  `PicardFunctor C` from `PicardFunctorAb C ⋙ forget AddCommGrpCat`) is the
  small lemma promised by the iter-004 `Picard_FunctorAb.tex` remark. It is
  one line of code (probe-confirmed); without it, downstream consumers cannot
  transport between the multiplicative `PicardFunctor` API (used by
  `quotMap`/`fiberMap`) and the additive `PicardFunctorAb` API.

This directive scaffolds **three new sorries total** across two files (one
brand-new and one extended): two for Phase A step 5 prerequisites and one for
Track C step 4. The plan-agent live probe confirms each closure is one line of
existing-Mathlib API; no new axioms or vacuous-instance shortcuts will be
needed by the prover.

## Plan-agent live Mathlib probe (iter 005)

All three closures pre-verified by `lean_run_code` against Mathlib `b80f227`:

```
import Mathlib
open CategoryTheory Limits TopologicalSpace
universe u

example (k : Type u) [CommRing k] (X : TopCat.{u}) :
    HasSheafify (Opens.grothendieckTopology X) (ModuleCat.{u} k) :=
  inferInstance                              -- ✓ succeeds

example (k : Type u) [CommRing k] (X : TopCat.{u}) :
    Linear k (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} k)) :=
  inferInstance                              -- ✓ succeeds (auto-inferable)

noncomputable example (k : Type u) [CommRing k] (X : TopCat.{u}) :
    HasExt.{u+1} (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} k)) :=
  HasExt.standard _                          -- ✓ succeeds
```

```
import AlgebraicJacobian.Picard.FunctorAb
open CategoryTheory Limits Opposite AlgebraicGeometry
universe u
variable {k : Type u} [Field k]

noncomputable example (C : Over (Spec (CommRingCat.of k))) :
    AlgebraicGeometry.Scheme.PicardFunctorAb C ⋙ forget AddCommGrpCat.{u} ≅
      AlgebraicGeometry.Scheme.PicardFunctor C :=
  NatIso.ofComponents (fun _ => Iso.refl _) (by intros; rfl)   -- ✓ succeeds
```

The probes confirm that the prover-side closures fit on one line each. The
`Linear k` instance is auto-resolved and therefore does **not** need its own
sorry-scaffold — the prover only sees the two Phase-A scaffold instances
(`HasSheafify`, `HasExt`) plus the `forgetCompare` natural iso.

## Changes requested

### 1. New file `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`

Create exactly the following file (signatures verbatim):

```lean
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
  sorry

/-- Phase A step 5 prerequisite (b): `Ext` on the sheaf category. The universe
annotation `HasExt.{u+1}` is forced by the morphism universe of
`Sheaf (Opens.gT X) (ModuleCat.{u} k)`; mirrors the iter-004
`instHasExt_Sheaf_Opens_AddCommGrp`. -/
noncomputable instance instHasExt_Sheaf_Opens_ModuleCatK
    (k : Type u) [CommRing k] (X : TopCat.{u}) :
    CategoryTheory.HasExt.{u+1}
      (CategoryTheory.Sheaf (Opens.grothendieckTopology X)
        (ModuleCat.{u} k)) :=
  sorry

end AlgebraicGeometry.Cohomology
```

Notes for the refactor agent:
- Imports: `import AlgebraicJacobian.Cohomology.StructureSheafAb` (which
  transitively imports Mathlib via `Cohomology.SheafCompose`).
- Namespace: both declarations under `AlgebraicGeometry.Cohomology` (matches
  the iter-004 convention).
- Universe annotations: `TopCat.{u}` on the topological space, `ModuleCat.{u} k`
  on the codomain category, `HasExt.{u+1}` on the sheaf-category Ext instance.
  These are forced by typeclass resolution (verified by the probe).
- The blueprint `\lean{...}` macros in
  `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` resolve to
  exactly:
  - `AlgebraicGeometry.Cohomology.instHasSheafify_Opens_ModuleCatK`
  - `AlgebraicGeometry.Cohomology.instHasExt_Sheaf_Opens_ModuleCatK`
- Compilation outcome: file should produce exactly two sorry warnings (no
  errors).

### 2. Extend `AlgebraicJacobian/Picard/FunctorAb.lean` with `forgetCompare`

Append the following declaration at the end of the existing
`namespace AlgebraicGeometry.Scheme` block (after the `PicardFunctorAb`
definition; **do not** modify or rename the existing declaration):

```lean
/-- Phase C step 3 forget-and-recover: the natural iso recovering
`PicardFunctor C` from `PicardFunctorAb C ⋙ forget AddCommGrpCat`. The
underlying-set functor of `PicardFunctorAb` agrees on the nose with
`PicardFunctor` (via the type-equal `Additive` wrapper of the iter-004
closure), so the iso is the identity natural transformation. See blueprint
chapter `Picard_FunctorAb.tex` (`def:PicardFunctorAb_forgetCompare`). -/
noncomputable def PicardFunctorAb.forgetCompare
    (C : Over (Spec (CommRingCat.of k))) :
    PicardFunctorAb C ⋙ forget AddCommGrpCat.{u} ≅ PicardFunctor C :=
  sorry
```

Notes for the refactor agent:
- The new declaration sits inside the existing `namespace AlgebraicGeometry.Scheme`
  block of `Picard/FunctorAb.lean`. The existing `variable {k : Type u} [Field k]`
  binder is in scope and applies to `forgetCompare`.
- Do **not** alter the existing `PicardFunctorAb` body, signature, or comments.
- Do **not** alter the existing imports.
- The blueprint `\lean{...}` macro for the new declaration resolves to
  `AlgebraicGeometry.Scheme.PicardFunctorAb.forgetCompare`.
- Compilation outcome: this file should produce exactly one new sorry warning
  (in addition to the existing zero — so one total) and no errors.

### 3. Cosmetic docstring refresh in `Cohomology/SheafCompose.lean` and `Cohomology/StructureSheafAb.lean`

Both files carry a stale "scaffold" docstring claiming the body is `sorry` and
that a future prover round will fill it. Both bodies were already filled
(iter-003 and iter-004 respectively). Refresh the `## Status` paragraph in
each file's header docstring as follows.

In `AlgebraicJacobian/Cohomology/SheafCompose.lean`, replace

```
## Status (iteration 004 — refactor scaffold)

This file is a scaffold. The single instance below is `sorry`. The iter-005
prover is responsible for filling it (Phase A step 1 of `STRATEGY.md`).
```

with

```
## Status (closed iteration 003)

The single instance below is honestly closed (5-line body via
`Limits.comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`).
Phase A step 1 of `STRATEGY.md`.
```

In `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`, replace

```
## Status (iteration 004 — refactor scaffold)

This file is a scaffold. The three declarations below are `sorry`. The next
prover round is responsible for filling them.
```

with

```
## Status (closed iteration 004)

All three declarations are honestly closed by the iter-004 multilane prover
round (lanes anthropic + deepseek; merged commit `2686f4e`).
```

Notes:
- Pure prose changes; do **not** alter any code, signatures, or namespaces.
- These updates are documented in `task_pending.md` as a queued cosmetic fix.

### 4. Umbrella import update in `AlgebraicJacobian.lean`

Add a single import line for the new file. Insert

```
import AlgebraicJacobian.Cohomology.StructureSheafModuleK
```

immediately after the existing `import AlgebraicJacobian.Cohomology.StructureSheafAb`
line. Do not reorder other imports.

## Anticipated post-refactor state

- Sorry count: 10 → 13 (3 new scaffold sites: 2 in `StructureSheafModuleK.lean`,
  1 in `Picard/FunctorAb.lean`).
- All other files compile cleanly (only the expected sorry warnings).
- No protected declaration touched; `archon-protected.yaml` unchanged.
- No new axioms; no `axiom` declarations introduced.
- Blueprint `\lean{...}` macros resolve correctly:
  - `AlgebraicGeometry.Cohomology.instHasSheafify_Opens_ModuleCatK` ✓
  - `AlgebraicGeometry.Cohomology.instHasExt_Sheaf_Opens_ModuleCatK` ✓
  - `AlgebraicGeometry.Scheme.PicardFunctorAb.forgetCompare` ✓
- `leanblueprint checkdecls` exits 0.

## Forbidden moves

- Do **not** edit any `.lean` file other than the four named above.
- Do **not** rename, re-type, or reorder arguments of any existing declaration
  (every existing signature is honored verbatim).
- Do **not** introduce new `axiom` declarations.
- Do **not** modify `archon-protected.yaml`.
- Do **not** scaffold the substantial Phase A step 5 main work
  (`Scheme.toModuleKSheaf` definition, the `Module k` instance on
  `(Scheme.toAbSheaf C).H 1`, etc.) — that is the iter-006+ scope; iter-005
  scope is strictly prerequisite typeclass plumbing plus one natural iso.
- Do **not** add the auto-inferable `Linear k` instance as a sorry-scaffold —
  it is already in Mathlib (probe confirmed); scaffolding it would create a
  spurious sorry.
