<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-07T05:02:17Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive — iteration 009 (Track 1 / `HModule` infrastructure scaffold)

**Status: queued for the iter-009 refactor agent run.**

## §1 Mathematical motivation (read this first)

This iteration's directive lands a single new declaration: a parallel `Sheaf.H` for `ModuleCat k`-valued sheaves. The motivation is laid out in `STRATEGY.md` (iter-008/009 entries) and `task_pending.md` ("Track B step 5/6 bridge — `HModule`"). Briefly:

- Mathlib's `CategoryTheory.Sheaf.H : {C : Type _} → [Category C] → {J : GrothendieckTopology C} → Sheaf J AddCommGrpCat → [HasSheafify J AddCommGrpCat] → [HasExt _] → ℕ → Type _` is parameterised over the value category `AddCommGrpCat` only — it is not parameterised over the value abelian category. This is verified by the iter-008 plan-agent `lean_run_code` probe (`#check @Sheaf.H`).
- Closing the protected `genus` honestly as `Module.finrank k (H¹(C, O_C))` requires a `Module k` structure on `H¹`. The iter-006 strategic note that this would come "for free via the typeclass chain `HasSheafify → HasExt → Linear k → Ext.instModule`" was slightly mistaken — that chain works on `Ext` directly in the `Linear k`-enriched abelian category `Sheaf (Opens.gT X) (ModuleCat k)`, but `Sheaf.H` does not deliver an `Ext` in that category, only in `Sheaf J AddCommGrpCat`.
- The fix is to mirror Mathlib's `Sheaf.H` construction directly with the value category `AddCommGrpCat` replaced by `ModuleCat k` and the unit object replaced by `ModuleCat.of k k` (the obvious choice for the constant sheaf of `k` regarded as a $k$-module). The iter-005 prerequisites (`HasSheafify (Opens.gT X) (ModuleCat k)` at L46 and `HasExt (Sheaf (Opens.gT X) (ModuleCat k))` at L56 of `Cohomology/StructureSheafModuleK.lean`) provide the typeclass dependencies; the body is `CategoryTheory.Abelian.Ext ((constantSheaf J (ModuleCat k)).obj (ModuleCat.of k k)) F n`.

The iter-009 plan-agent has run two probes:

1. **Body typechecks:** `noncomputable abbrev HModule (k : Type u) [Field k] {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C} [HasSheafify J (ModuleCat.{u} k)] [HasExt (Sheaf J (ModuleCat.{u} k))] (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) : Type (u+1) := CategoryTheory.Abelian.Ext ((CategoryTheory.constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k)) F n` typechecks against current Mathlib (no errors, only longLine warnings).
2. **Specialisation works end-to-end:** `noncomputable example : ℕ := Module.finrank k (HModule k (toModuleKSheaf X) 1)` typechecks against current Mathlib (no errors, no warnings) — this is the natural `genus` closure.

This iteration **does not** install the `genus` closure (that is gated on the user-facing decision about `noncomputable def` on protected declarations, see `task_pending.md`'s "User-facing decision needed"). It only lands the `HModule` infrastructure in unprotected territory.

## §2 Sanity-check probe to run before scaffolding

Before applying the scaffold, the refactor agent should re-run the iter-009 plan-agent's sanity-check probe to confirm the body still typechecks against the current Mathlib snapshot:

```lean
import Mathlib
import AlgebraicJacobian.Cohomology.StructureSheafModuleK

open AlgebraicGeometry CategoryTheory Limits Opposite

universe v u

namespace AlgebraicGeometry.Scheme

noncomputable abbrev HModuleProbe
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasSheafify J (ModuleCat.{u} k)] [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) : Type (u+1) :=
  CategoryTheory.Abelian.Ext
    ((CategoryTheory.constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k)) F n

variable {k : Type u} [Field k] (X : Over (Spec (CommRingCat.of k)))

noncomputable example : ℕ := Module.finrank k (HModuleProbe k (toModuleKSheaf X) 1)

end AlgebraicGeometry.Scheme
```

If this returns `{success: true, diagnostics: []}` (modulo longLine warnings — the actual scaffold is line-wrapped to avoid them), the body is drop-in. If a name has drifted in current Mathlib (e.g. `constantSheaf` qualification, `ModuleCat.of` argument shape, `Abelian.Ext` namespace), document it in `task_results/refactor.md` along with the adjusted form. Do not attempt to replace the body with a non-trivial alternative; if the probe fails, stop and report rather than landing a body the plan agent did not approve.

## §3 The scaffold to land

### 3.1 File: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`

**Single change**: Add `universe v` to the existing universe declaration line, and append one new declaration just before the existing `end AlgebraicGeometry.Scheme` (currently L177).

#### 3.1.1 Universe declaration

The current file has:

```lean
universe u
```

at line 36 (top-of-file, after the `set_option autoImplicit false`). Change it to:

```lean
universe u v
```

**Important universe order:** `u v` (with `u` first) matches the existing declarations using `universe u`. Adding `v` to the end preserves any existing implicit binding of `u`.

#### 3.1.2 New declaration

Append the following declaration immediately before the existing `end AlgebraicGeometry.Scheme` line (currently L177). The `namespace AlgebraicGeometry.Scheme` was opened at L111; the new declaration sits inside it, alongside `toModuleKPresheaf` (L117), `toModuleKPresheaf_obj` (L143), `toModuleKPresheaf_isSheaf` (L150), `toModuleKSheaf` (L160), and `toModuleKSheaf_forgetCompare` (L170):

```lean
/-- Phase A step 5/6 bridge (iter-009 scaffold): the parallel `Sheaf.H` for
`ModuleCat k`-valued sheaves. Mathlib's `CategoryTheory.Sheaf.H` is
parameterised over `Sheaf J AddCommGrpCat` only, so closing `genus` honestly
requires this `ModuleCat k`-flavoured version. The result carries `Module k`
automatically via `CategoryTheory.Abelian.Ext.instModule`, and
`Module.finrank k` is therefore well-defined on it. The declaration is a
`noncomputable abbrev` (rather than `def`) so that instance synthesis sees
through the wrapper to find `Module k` and `AddCommGroup` instances. -/
noncomputable abbrev HModule
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasSheafify J (ModuleCat.{u} k)] [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) : Type (u+1) := sorry
```

**Three reasons the signature looks the way it does:**

1. `noncomputable abbrev` (not `def`): instance synthesis must see through the wrapper to `Abelian.Ext.instModule`. Probe-verified that `def` form yields `failed to synthesize instance of type class AddCommMonoid (HModule k F n)`.
2. `[Field k]` (not `[CommRing k]`): `genus` operates over a field. The iter-005 prerequisites' `[CommRing k]` weakening is fine for those (they only need the ring structure), but `Module.finrank` and the `Module k`-structure on `Ext` use the field structure. Keep `[Field k]` here.
3. `Type (u+1)` codomain: this matches the universe of `Abelian.Ext` in this setting. Probe-verified.

#### 3.1.3 Existing declarations (do not touch)

- L46 `instHasSheafify_Opens_ModuleCatK` — closed iter-005, do not touch.
- L56 `instHasExt_Sheaf_Opens_ModuleCatK` — closed iter-005, do not touch.
- L72 `kToSection`, L80 `algebraSection`, L86 `algebraMap_eq_kToSection`, L93 `kToSection_naturality`, L101 `algebraMap_naturality` — all closed iter-006, do not touch.
- L117 `toModuleKPresheaf`, L143 `toModuleKPresheaf_obj`, L150 `toModuleKPresheaf_isSheaf`, L160 `toModuleKSheaf` — all closed iter-006/007, do not touch.
- L170 `toModuleKSheaf_forgetCompare` — closed iter-007, do not touch.

The new `HModule` is the **only** new declaration.

### 3.2 No other files

This directive scaffolds **one declaration in one file**. No other `.lean` file is touched. `archon-protected.yaml` is not touched.

## §4 Optional: docstring update

Optionally extend the file's leading docstring (currently L8–L32) with a third bullet under "Status (iteration 006 — refactor scaffold)" (or add a new "Status (iteration 009 — refactor scaffold)" paragraph) explaining the iter-009 addition. This is purely cosmetic; if it complicates the diff, skip it.

A suggested form:

```text
## Status (iteration 009 — refactor scaffold)

`HModule` is **scaffolded**: the parallel `Sheaf.H` for `ModuleCat k`-valued
sheaves, mirroring Mathlib's `Sheaf.H` construction with `AddCommGrpCat`
replaced by `ModuleCat k`. By construction the result carries `Module k`
automatically via `Abelian.Ext.instModule`, so `Module.finrank k (HModule k F n)`
is well-defined. The closure body is a one-liner; the iter-009 prover round
fills it.
```

## §5 Sorry accounting (after refactor)

Expected sorry count post-refactor: **10 → 11**.

The new sorry is at the body of `HModule` in `Cohomology/StructureSheafModuleK.lean`. The prover round that follows this refactor closes it (sorry count returns to 10).

## §6 Compilation invariant

Post-refactor, `lean_diagnostic_messages` on `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` must return:

- **zero** errors
- **zero** unrelated warnings (the only warning should be the expected `declaration uses 'sorry'` on the new `HModule` declaration)
- **zero** failed dependencies

`lean_diagnostic_messages` on every other file in `AlgebraicJacobian/` must return `{success: true, items: [...]}` with the same items as before this iteration (i.e., the existing protected/`representable` `declaration uses 'sorry'` warnings only).

## §7 Output to `.archon/task_results/refactor.md`

Write a short report covering:

1. **Sanity-check probe outcome** (§2): pass / drift / hard fail.
2. **Diff summary** (§3): the universe-line change and the new `HModule` declaration; line numbers.
3. **Compilation status** (§6): verbatim `lean_diagnostic_messages` output for `Cohomology/StructureSheafModuleK.lean`.
4. **Sorry count** (§5): pre-refactor and post-refactor counts, verified via `${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" AlgebraicJacobian/`.
5. **Adjustments** (if any): if the probe drifted (e.g. `constantSheaf` namespace), document the actual landed body and signature.
6. **Status: COMPLETE** or **PARTIAL** (with reason).

## §8 Follow-up: prover round (next pass; not part of this directive)

After this refactor lands, the iter-009 prover round will be assigned the single new `HModule` sorry, with the probe-confirmed body recorded above. The plan agent will independently verify (sorry count + `lean_diagnostic_messages` + `lean_verify` on `HModule` axioms + `leanblueprint checkdecls`) before declaring the iter-009 round accepted.
