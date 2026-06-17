# Refactor Directive — iter-022

## Slug

iter-022-mv-sequence

## Summary

Single-file additive scaffold change to `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`: append one new declaration to the file, inside `namespace AlgebraicGeometry.Scheme`, immediately after `noncomputable def HModule'_δ` (currently L590–599) and before the closing `end AlgebraicGeometry.Scheme` (currently L601):

1. `noncomputable abbrev HModule'_sequence` — the Mayer-Vietoris LES `ComposableArrows`-form sequence in `ModuleCat k`-valued sheaf cohomology, packaging the iter-017 `HModule'_toBiprod` (sum), iter-017 `HModule'_fromBiprod` (difference), and iter-021 `HModule'_δ` (connecting hom) into a `ComposableArrows AddCommGrpCat 5`. Mirrors Mathlib's `Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean` L120–122 line-by-line for the `ModuleCat k` flavor with `F.cohomologyPresheaf → HModule'_cohomologyPresheaf k F` and `S.δ F → HModule'_δ k S F`. Body `:= by sorry`.

The single `sorry` body is probe-confirmed as a one-line term-mode body; the prover round will close it. Sorry count `9 → 10`.

## Mathematical justification

After the iter-014 carrier `HModule'`, the iter-015 `H⁰` bridge, the iter-016 functorial wrappers, the iter-017 LES building blocks `HModule'_toBiprod` + `HModule'_fromBiprod`, the iter-018 composition-is-zero lemma, the iter-019 short-complex carrier infrastructure, the iter-020 short-exact infrastructure, and the iter-021 connecting hom `HModule'_δ`, all three Mayer-Vietoris LES building blocks are in scope. The natural follow-on is to **package them into the standard `ComposableArrows`-form sequence** that downstream code (iter-023+ `HModule'_sequenceIso`, iter-024+ `HModule'_sequence_exact`) will consume.

In Mathlib's `AddCommGrpCat`-flavored construction (`Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean` L116–122):

```lean
open ComposableArrows

/-- The Mayer-Vietoris long exact sequence of an abelian sheaf `F : Sheaf J AddCommGrpCat`
for a Mayer-Vietoris square `S : J.MayerVietorisSquare`. -/
noncomputable abbrev sequence : ComposableArrows AddCommGrpCat.{w} 5 :=
  mk₅ (S.toBiprod F n₀) (S.fromBiprod F n₀) (S.δ F n₀ n₁ h)
    (S.toBiprod F n₁) (S.fromBiprod F n₁)
```

Mathlib's `ComposableArrows.mk₅` (file `Mathlib/CategoryTheory/ComposableArrows.lean`) takes 5 morphisms `f₀ : X₀ ⟶ X₁`, ..., `f₄ : X₄ ⟶ X₅` and assembles them into `ComposableArrows C 5`. The 5 morphisms here are the LES building blocks at the alternating degree pattern `(n₀, n₀, (n₀, n₁), n₁, n₁)`:

- arrow 0: `S.toBiprod F n₀ : F.H' n₀ S.X₄ ⟶ F.H' n₀ S.X₂ ⊞ F.H' n₀ S.X₃`
- arrow 1: `S.fromBiprod F n₀ : F.H' n₀ S.X₂ ⊞ F.H' n₀ S.X₃ ⟶ F.H' n₀ S.X₁`
- arrow 2: `S.δ F n₀ n₁ h : F.H' n₀ S.X₁ ⟶ F.H' n₁ S.X₄`
- arrow 3: `S.toBiprod F n₁ : F.H' n₁ S.X₄ ⟶ F.H' n₁ S.X₂ ⊞ F.H' n₁ S.X₃`
- arrow 4: `S.fromBiprod F n₁ : F.H' n₁ S.X₂ ⊞ F.H' n₁ S.X₃ ⟶ F.H' n₁ S.X₁`

For the `ModuleCat k` flavor: with the iter-016 per-fiber `rfl`-identification `(HModule'_cohomologyPresheaf k F n).obj (op X) = HModule' k F n X`, and substituting `S.toBiprod F n` → `HModule'_toBiprod k S F n`, `S.fromBiprod F n` → `HModule'_fromBiprod k S F n`, `S.δ F n₀ n₁ h` → `HModule'_δ k S F n₀ n₁ h`, the body transfers verbatim. The codomain `ComposableArrows AddCommGrpCat 5` is `AddCommGrpCat`-flavored because every individual building block lands in `AddCommGrpCat`-morphisms (forced by the iter-016 wrappers always landing in `Cᵒᵖ ⥤ AddCommGrpCat`, regardless of the `Linear k` enrichment of `Sheaf J (ModuleCat k)`).

The `noncomputable abbrev` declaration form (matches Mathlib L120) is **load-bearing**: an `abbrev` is needed so that downstream code in iter-023+ `HModule'_sequenceIso` and iter-024+ `HModule'_sequence_exact` can unfold the body via `dsimp` to access `mk₅`'s field-projection simp lemmas (`ComposableArrows.mk₅_obj_zero`, `ComposableArrows.mk₅_obj_one`, ..., `ComposableArrows.mk₅_map_succ_zero`, ...), which require unfoldability of the carrier. Switching to `def` would block these `dsimp` rewrites and force ad-hoc unfolding everywhere downstream.

The `[HasExt (Sheaf J (ModuleCat.{u} k))]` typeclass is required (the body consumes `HModule'_δ` which depends on it) and matches the corresponding requirement on iter-016/017/018/021.

Plan-agent `lean_run_code` probe (this iter-022 pass, against the post-iter-021 file at L590) confirms the body typechecks `{success: true, diagnostics: []}` with the explicit `ComposableArrows.mk₅` qualification (since the file's `open CategoryTheory Limits TopologicalSpace AlgebraicGeometry` directive does not include `ComposableArrows`). No new Mathlib gap.

## Changes Requested

### File: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`

Append the following block inside `namespace AlgebraicGeometry.Scheme`, immediately after the iter-021 `HModule'_δ` declaration (currently L590–599) and before `end AlgebraicGeometry.Scheme` (currently L601):

```lean
/-- Phase A step 6 *Path 2* (iter-022): the Mayer-Vietoris long exact sequence
of `F : Sheaf J (ModuleCat k)` at a Mayer-Vietoris square `S` and adjacent
cohomological degrees `n₀ + 1 = n₁`, packaged as a `ComposableArrows`-form
sequence in `AddCommGrpCat`. The five morphisms are the iter-017
`HModule'_toBiprod k S F n₀` (sum at degree `n₀`), iter-017
`HModule'_fromBiprod k S F n₀` (difference at degree `n₀`), iter-021
`HModule'_δ k S F n₀ n₁ h` (connecting hom from `n₀` to `n₁`), iter-017
`HModule'_toBiprod k S F n₁` (sum at degree `n₁`), and iter-017
`HModule'_fromBiprod k S F n₁` (difference at degree `n₁`).

Direct mirror of Mathlib's `MayerVietorisSquare.sequence` (file
`Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean` L120–122)
for the `ModuleCat k` flavor with `F.cohomologyPresheaf → HModule'_cohomologyPresheaf k F`
and `S.δ F → HModule'_δ k S F`.

Declared as `noncomputable abbrev` (matches Mathlib L120). The `abbrev` form
is load-bearing: downstream code in iter-023+ `HModule'_sequenceIso` and
iter-024+ `HModule'_sequence_exact` will need to unfold the body via `dsimp`
to access `ComposableArrows.mk₅`'s field-projection simp lemmas; switching to
`def` would block these rewrites. The `noncomputable` modifier is required
because `HModule'_δ` is noncomputable (its body uses `Ext.precomp`).

The codomain `ComposableArrows AddCommGrpCat 5` is `AddCommGrpCat`-flavored
because every individual building block lands in `AddCommGrpCat`-morphisms
(forced by the iter-016 `HModule'_cohomologyPresheaf k F n` always landing
in `Cᵒᵖ ⥤ AddCommGrpCat`, regardless of the `Linear k` enrichment of
`Sheaf J (ModuleCat k)`). The `[HasExt (Sheaf J (ModuleCat.{u} k))]`
typeclass is required (consumed by `HModule'_δ`) and matches iter-016/017/018/021. -/
noncomputable abbrev HModule'_sequence
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    ComposableArrows AddCommGrpCat 5 := by sorry
```

The signature is verbatim from the iter-022 plan-agent probe. The body is `:= by sorry` initially; the prover round closes it with the term-mode

```lean
ComposableArrows.mk₅ (HModule'_toBiprod k S F n₀) (HModule'_fromBiprod k S F n₀)
  (HModule'_δ k S F n₀ n₁ h)
  (HModule'_toBiprod k S F n₁) (HModule'_fromBiprod k S F n₁)
```

(the explicit `ComposableArrows.mk₅` qualification is required since the file's `open CategoryTheory Limits TopologicalSpace AlgebraicGeometry` directive does not include `ComposableArrows`).

## Affected files

Only `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`. No other file is touched. No imports change. No declaration is renamed, deleted, moved, or re-typed. No protected declaration is affected. No archon-protected.yaml change.

## Expected outcome

After the refactor (sub-phase 1):
- `lean_diagnostic_messages AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` returns one `info` for the new `sorry` at the body site (line ~640), no errors.
- Total project sorry count: 9 → 10 (the new `sorry` site in `HModule'_sequence`'s body).
- File goes from 636 LOC to ~660 LOC (the new declaration carries ~24 LOC including its docstring).

After the prover round (sub-phase 2):
- The single `sorry` is replaced with the probe-confirmed term-mode body.
- Total project sorry count: 10 → 9 (back to baseline: 8 protected + 1 deferred `representable`).
- `lean_verify AlgebraicGeometry.Scheme.HModule'_sequence` returns kernel-only axioms `[propext, Classical.choice, Quot.sound]` (plus the harmless L397 `local instance` heuristic from the iter-019 docstring; ignore that one).
- `Genus.lean` still kernel-only, `archon-protected.yaml` unchanged.

## Optional collapsed-Edit acceleration (matches iter-015 through iter-021 pattern)

If the prover collapses both sub-phases into a single Edit (appending the declaration directly with the closure body in place), that is acceptable. The end-state shape is what matters; the plan-agent post-prover verification will accept either trajectory. The probe-confirmed body is:

```lean
noncomputable abbrev HModule'_sequence
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    ComposableArrows AddCommGrpCat 5 :=
  ComposableArrows.mk₅ (HModule'_toBiprod k S F n₀) (HModule'_fromBiprod k S F n₀)
    (HModule'_δ k S F n₀ n₁ h)
    (HModule'_toBiprod k S F n₁) (HModule'_fromBiprod k S F n₁)
```

## Forbidden during the refactor

- Do **not** rename `HModule'_sequence`, change its return type, change the namespace, swap `noncomputable abbrev` for `def` / `theorem` / `lemma` / `instance`, or alter any prior declaration in the file (in particular: do not modify `HModule`, `HModule_zero_linearEquiv`, `HModule'`, `HModule'_zero_linearEquiv`, `HModule'_cohomologyPresheafFunctor`, `HModule'_cohomologyPresheaf`, `HModule'_toBiprod`, `HModule'_fromBiprod`, `HModule'_toBiprod_fromBiprod`, `ModuleCat_free_isLeftAdjoint`, `HModule'_isPushoutModuleCatFreeSheaf`, `HModule'_shortComplex`, `ModuleCat_free_preservesMonomorphisms`, `HModule'_shortComplex_f_mono`, `HModule'_shortComplex_g_epi`, `HModule'_shortComplex_exact`, `HModule'_shortComplex_shortExact`, `HModule'_δ`, `cechCochain_OC`, `cechCohomology_OC`).
- Do **not** drop the `[HasExt (Sheaf J (ModuleCat.{u} k))]` typeclass requirement (it is consumed by `HModule'_δ` in the body; without it, `HModule'_δ` itself is unsynthesizable).
- Do **not** introduce a `set_option backward.isDefEq.respectTransparency false in` annotation. Mathlib L120 has no such annotation; the iter-022 body is a clean term-mode expression and does not require relaxed transparency (the iter-020 `Mono` instance is a different scenario where Lean's `dsimp` of `(HModule'_shortComplex k S).f` fails without the `set_option`).
- Do **not** swap `noncomputable abbrev` for `noncomputable def`. The `abbrev` form is load-bearing for iter-023+ `dsimp`-based unfolding; switching to `def` would silently break downstream code.
- Do **not** scaffold the iter-023+ work (`HModule'_sequenceIso`, four auxiliary lemmas, `HModule'_sequence_exact`, `δ_toBiprod`, `fromBiprod_δ`). All deferred. Iter-022 lays only `HModule'_sequence`.
- Do **not** introduce a global `open ComposableArrows` directive at file scope. The explicit `ComposableArrows.mk₅` qualification is more localized and avoids name-resolution ambiguity with other `mk₅` definitions in scope (e.g. there is no `mk₅` collision currently, but a global `open` would make future declarations in this file fragile if a parallel `mk₅` is added).
