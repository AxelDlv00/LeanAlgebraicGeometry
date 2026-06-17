<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-07T10:55:16Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive — iter-013

**Iteration:** 013
**Strategic context:** Phase A step 6 *proper* sub-step — Mayer-Vietoris prerequisite. With iter-012's Čech-side carriers (`Scheme.cechCochain_OC`, `Scheme.cechCohomology_OC`) in scope and verified clean (kernel-only axioms; sorry count back to baseline 9), the next Path-2 sub-step is the `ModuleCat k`-flavored cohomology of an open. This is the API entry point that downstream Mayer-Vietoris LES (queued iter-014+) and Čech-vs-derived-functor comparison theorems (queued iter-015+) both consume.

## Problem statement

Mathlib's sheaf cohomology API has two flavors:

- `Sheaf.H F n : Type w'` — cohomology in degree `n` of an abelian sheaf `F` (the "global" cohomology). The iter-009 declaration `AlgebraicGeometry.Scheme.HModule k F n` is the `ModuleCat k`-flavored mirror.
- `Sheaf.H' F n X : AddCommGrpCat.{w'}` — cohomology of an *open* `X : C` with values in `F` (file `Mathlib/CategoryTheory/Sites/SheafCohomology/Basic.lean` line 105). Defined as `(F.cohomologyPresheaf n).obj (op X) = Ext ((presheafToSheaf _ _).obj ((yoneda ⋙ AddCommGrpCat.free).obj X)) F n`.

There is **no `ModuleCat k`-flavored mirror of `Sheaf.H'`** in current Mathlib or in the project. Mathlib's Mayer-Vietoris LES (`Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean`) is stated entirely in terms of `Sheaf.H'`; a `ModuleCat k`-flavored LES (the iter-014+ Path-2 sub-step) requires the corresponding `HModule'`. The iter-013 task is to land this prerequisite.

## Mathematical justification

For a Grothendieck site `(C, J)`, a sheaf `F : Sheaf J (ModuleCat.{u} k)`, an integer `n : ℕ`, and an object `X : C`:

```
H^n_{ModuleCat k}(F, X) := Ext^n ((presheafToSheaf J (ModuleCat k)).obj
                                   ((yoneda ⋙ ModuleCat.free k).obj X), F)
```

This mirrors Mathlib's `Sheaf.H' F n X` line-by-line, with `AddCommGrpCat.free → ModuleCat.free k` (`ModuleCat.free k : Type u ⥤ ModuleCat.{u} k`, file `Mathlib/Algebra/Category/ModuleCat/Adjunctions.lean`). The codomain is `Type u` (not `ModuleCat.{u} k`), since `Abelian.Ext` returns a bare `Type u` carrying `Module k` via `Abelian.Ext.instModule` through the `Linear k` enrichment of the sheaf category.

**Why a `noncomputable abbrev` rather than `def`.** Same design rationale as iter-009's `HModule`: instance synthesis must see through the wrapper to find `Abelian.Ext.instModule` and `Abelian.Ext.instAddCommGroup`; under `def`, `Module.finrank k (HModule' k F n X)` would fail to typecheck (probe-verified iter-009 for `HModule`).

**Probe-confirmation (plan-agent, this iter-013 pass).** Two `lean_run_code` probes against the post-iter-012 project state:

```lean
import AlgebraicJacobian.Cohomology.StructureSheafModuleK
open CategoryTheory Limits TopologicalSpace AlgebraicGeometry CategoryTheory.Abelian

universe u v

namespace AlgebraicGeometry.Scheme

noncomputable abbrev HModule' (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [CategoryTheory.HasExt.{u} (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) (X : C) : Type u :=
  Ext ((presheafToSheaf _ _).obj
    ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X)) F n

end AlgebraicGeometry.Scheme

-- Smoke test 1: instance synthesis through abbrev unfolding
noncomputable example {k : Type u} [Field k] (C : Over (Spec (.of k)))
    (X : Opens C.left.toTopCat) : ℕ :=
  Module.finrank k (Scheme.HModule' k (Scheme.toModuleKSheaf C) 1 X)
-- {success: true, diagnostics: []}

-- Smoke test 2: HasWeakSheafify J (Type u) auto-resolves for the Opens topology
example {k : Type u} [Field k] (C : Over (Spec (.of k))) : True := by
  have : HasWeakSheafify (Opens.grothendieckTopology C.left.toTopCat) (Type u) := inferInstance
  trivial
-- {success: true, diagnostics: []}
```

Both probes return `{success: true, diagnostics: []}`. The body is drop-in for the iter-013 prover round.

## Refactor scope

**Single-file change to `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`.**

Insert one new declaration `AlgebraicGeometry.Scheme.HModule'` between the existing `HModule_zero_linearEquiv` (currently L203–L210) and the closing `end AlgebraicGeometry.Scheme` (currently L212), with body `:= sorry`. Placement keeps the iter-009/010 `HModule` family in `namespace AlgebraicGeometry.Scheme`, so the new declaration's full name is `AlgebraicGeometry.Scheme.HModule'`.

### Exact insertion shape (refactor agent: scaffold this signature verbatim, body `:= sorry`)

```lean
/-- Phase A step 6 *Path 2* (iter-013 scaffold): the `ModuleCat k`-flavored
cohomology of an open `X : C` with values in a sheaf `F : Sheaf J (ModuleCat.{u} k)`.
Mirrors Mathlib's `Sheaf.H' F n X = (F.cohomologyPresheaf n).obj (op X)`
(`Mathlib/CategoryTheory/Sites/SheafCohomology/Basic.lean` L105) for
`AddCommGrpCat`-valued sheaves, with `AddCommGrpCat.free → ModuleCat.free k`.

The codomain is `Type u` (not `ModuleCat.{u} k`): `Abelian.Ext` returns a bare
`Type u` carrying `Module k` via `Abelian.Ext.instModule` through the `Linear k`
enrichment. The `noncomputable abbrev` form (rather than `def`) is required so
instance synthesis sees through the wrapper to find `Module k (HModule' k F n X)`
and `AddCommGroup (HModule' k F n X)` — under `def`, `Module.finrank` would fail
to typecheck (cf. iter-009 design rationale on `HModule`).

This is the prerequisite for the iter-014+ `ModuleCat k`-flavored Mayer-Vietoris
LES (mirror of `Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean`).
The iter-014+ work will state and prove the LES on a `MayerVietorisSquare`,
specialising to a 2-affine cover of a proper `k`-curve in iter-015+. The
comparison theorem `cechCohomology_OC C 𝒰 n ≅ HModule k (toModuleKSheaf C) n`
for an acyclic cover (the technical heart of Path-2) is also queued for
iter-015+. -/
noncomputable abbrev HModule' (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) (X : C) : Type u := sorry
```

**Notes for the refactor agent on identifier resolution:**

- The file already has `open CategoryTheory Limits TopologicalSpace AlgebraicGeometry` at L38 (verbatim from iter-009 onward) and `universe u v` at L36 (added iter-009).
- The new declaration goes inside `namespace AlgebraicGeometry.Scheme`. Under `open CategoryTheory`, the bare names `HasWeakSheafify`, `HasSheafify`, `HasExt`, `Sheaf`, `GrothendieckTopology`, `Category` all resolve correctly. `ModuleCat.{u} k` and `Field k` are global. The full name will be `AlgebraicGeometry.Scheme.HModule'`.
- The signature mirrors the iter-009 `HModule` exactly except: (a) adds the `[HasWeakSheafify J (Type u)]` hypothesis (needed for `presheafToSheaf` of the `yoneda ⋙ free_k` composite into `Sheaf J (ModuleCat.{u} k)` — the Mathlib pattern requires both flavors of sheafification); (b) adds the parameter `(X : C)`; (c) the body uses `(presheafToSheaf _ _).obj ...` with a yoneda-free composite source object instead of the `(constantSheaf J _).obj _` source object that `HModule` uses.
- `HasExt (Sheaf J (ModuleCat.{u} k))` (without an explicit universe annotation) is the pattern from iter-009's `HModule` — Lean infers the universe argument; the iter-013 probe used `CategoryTheory.HasExt.{u}` and that also worked, but the unqualified form (matching iter-009) is preferred for consistency.

### Forbidden adjustments (refactor agent: do NOT do any of these)

- Do **not** add a body different from `:= sorry`. The prover round closes the body.
- Do **not** rename the declaration to `HModule_atOpen`, `HOpenModule`, `H'Module`, or any other variant. The chosen name `HModule'` matches Mathlib's `Sheaf.H'` convention (prime indicates "evaluated at an open" variant).
- Do **not** change the codomain to `ModuleCat.{u} k`. The probe with `: ModuleCat.{u} k` returns a type-mismatch error (`Abelian.Ext` returns `Type u`, not `ModuleCat.{u} k`); only `: Type u` typechecks.
- Do **not** scaffold inside `namespace AlgebraicGeometry` (rather than `AlgebraicGeometry.Scheme`). The iter-009/010 `HModule` family lives in `AlgebraicGeometry.Scheme`; consistency requires the new declaration to live there too.
- Do **not** scaffold a new file (e.g. `AlgebraicJacobian/Cohomology/HModule.lean` or `Cohomology/OpenCohomology.lean`). The current file is ~250 LOC and not yet at the threshold for splitting; the file-split refactor is deferred until the file outgrows ~400 LOC. iter-013 keeps the surface area minimal.
- Do **not** scaffold a companion `HModule'_zero_linearEquiv` declaration in iter-013. It is queued for iter-014+ (probe-confirmed at one-line `Abelian.Ext.linearEquiv₀`, cf. iter-010 `HModule_zero_linearEquiv`).
- Do **not** alter any prior declaration in the file (iter-005 prerequisites at L46/L56, iter-006 main step 5 at L72/L80/L86/L93/L101/L115/L142/L152, iter-007 polish at L143/L170, iter-009 `HModule` at L185, iter-010 `HModule_zero_linearEquiv` at L203, iter-012 Čech scaffold at L228/L241).
- Do **not** alter `archon-protected.yaml`, `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`, `Picard/*.lean`, `Cohomology/StructureSheafAb.lean`, `Cohomology/SheafCompose.lean`, `Rigidity.lean`. The iter-013 work is single-file inside `Cohomology/StructureSheafModuleK.lean`.

### Two-line shape adjustments allowed (mathematically inert)

If the literal `HasExt (Sheaf J (ModuleCat.{u} k))` form fails to elaborate (e.g. universe mismatch the probe didn't surface), the refactor agent may write `HasExt.{u} (Sheaf J (ModuleCat.{u} k))` with the explicit universe annotation. Both forms are mathematically identical; the iter-009 `HModule` uses the unqualified form successfully, so the unqualified form should also work for `HModule'`. Document any forced adjustment in `task_results/refactor.md`.

If `(yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X` does not elaborate due to whitespace ambiguity in the doc-comment shape, an equivalent and probe-confirmed alternative is `(((Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj (yoneda.obj X))`. Both spellings are mathematically equivalent — the prover round can use whichever the refactor agent settled on.

## Sanity check the refactor agent should run before reporting

1. **Sorry count post-refactor:** `${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" AlgebraicJacobian/ --format=summary` should return `10 total across 4 file(s)` (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean` + **1 `Cohomology/StructureSheafModuleK.lean`**, the new `HModule'` opener).
2. **Compilation `Cohomology/StructureSheafModuleK.lean`:** `lean_diagnostic_messages` should return exactly one `declaration uses 'sorry'` warning at the new declaration's line, zero errors, zero failed dependencies.
3. **Compilation `Genus.lean`:** `lean_diagnostic_messages` should return `{success: true, items: [], failed_dependencies: []}` (the iter-011 closure intact).
4. **`archon-protected.yaml`:** unchanged (verify with `git diff archon-protected.yaml` returning empty).
5. **§3.3 sanity-check probe:** before reporting, run a `lean_run_code` against the post-refactor file with the prover's intended one-liner closure body in place of the `sorry`:
   ```lean
   Ext ((presheafToSheaf _ _).obj
     ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X)) F n
   ```
   This must return `{success: true, diagnostics: []}`. If it fails, document the actual failure and either propose a corrected body or flag the directive as needing plan-agent revision.

## Expected outcome post-refactor

- One new `:= sorry` declaration appended at the end of `namespace AlgebraicGeometry.Scheme` block (between L210 and L212 in the current file).
- Sorry count: 9 → 10.
- File compiles with one `declaration uses 'sorry'` warning, no errors.
- `task_results/refactor.md` written with the §3.3 sanity-check result, any adjustments documented, and the iter-013 prover-round closure body re-confirmed drop-in.

## Iter-013 prover-round closure body (for the prover to use, after the refactor)

```lean
Ext ((presheafToSheaf _ _).obj
  ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X)) F n
```

Probe-confirmed verbatim. The prover should adopt this verbatim modulo the optional cosmetic `CategoryTheory.` prefix drop on `Ext` (the file's `open CategoryTheory` directive at L38 resolves it; the iter-009 `HModule` and iter-010 `HModule_zero_linearEquiv` both adopt the prefix-dropped form).
