# Lean Scaffolder Report — snap-coeq (iter-063)

**Status:** SUCCESS — `lake build` green, no new errors.

## Declaration added

**File:** `AlgebraicJacobian/Picard/SectionGradedRing.lean`
**Inserted after:** the closing `using hz` line of `relTensorProj`, before the first `/-` handoff comment block.

```lean
noncomputable def relativeTensorCoequalizerIso (P Q : X.PresheafOfModules) :
    Limits.IsColimit (Limits.Cofork.ofπ (relTensorProj P Q)
      (show relTensorActL P Q ≫ relTensorProj P Q = relTensorActR P Q ≫ relTensorProj P Q
        from sorry)) :=
  sorry
```

**Blueprint label:** `lem:relativeTensor_as_coequalizer`
**Lean name:** `AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso`

## Type structure

- Category: `(TopologicalSpace.Opens X)ᵒᵖ ⥤ Ab` (the `Ab`-valued presheaf category on opens of `X`)
- Parallel pair: `relTensorActL P Q`, `relTensorActR P Q` — both `relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q`
- Cofork leg: `relTensorProj P Q : relTensorDomainPresheaf P Q ⟶ (PresheafOfModules.toPresheaf X.ringCatSheaf.obj).obj (MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q)`
- Return: `Limits.IsColimit (Limits.Cofork.ofπ (relTensorProj P Q) ...)` — standard Mathlib `IsColimit`

## Mathlib name verification

| Name | Status |
|------|--------|
| `PresheafOfModules.Monoidal.tensorObj_obj` | ✅ Confirmed via loogle |
| `CategoryTheory.Limits.evaluationJointlyReflectsColimits` | ⚠️ NOT FOUND — only `evaluationJointlyReflectsLimits` found; colimit analogue may be `PresheafOfModules.evaluationJointlyReflectsColimits` or `CategoryTheory.Limits.combinedIsColimit` |
| `Limits.Cofork.ofπ` | ✅ Already used at line 375 of this file |
| `Limits.IsColimit` | ✅ Already used at line 418 of this file |

The discrepancy for `evaluationJointlyReflectsColimits` is noted verbatim in the planner strategy comment injected above the declaration.

## Planner strategy comment

Injected verbatim as a `/- Planner strategy: ... -/` block directly above the `noncomputable def`. The comment covers:
1. **OBJECTWISE** — instantiate `RelativeTensorCoequalizer.isColimitCofork` at each `U`
2. **PROMOTE** — use `evaluationJointlyReflectsColimits` (with caveat on which Mathlib name to use)
3. **APEX** — identify via `PresheafOfModules.Monoidal.tensorObj_obj` and transport the colimit

## Sorries introduced

| Sorry | Location | Role |
|-------|----------|------|
| `from sorry` (condition) | Inside `Cofork.ofπ` type argument | `relTensorActL P Q ≫ relTensorProj P Q = relTensorActR P Q ≫ relTensorProj P Q`; provable objectwise from `RelativeTensorCoequalizer.coeq_condition` via `evaluationJointlyReflectsColimits` / NatTrans `ext` |
| `sorry` (body) | Body of `relativeTensorCoequalizerIso` | The full `IsColimit` witness |

## Build verification

```
Build completed successfully (2436 jobs)
```
Only pre-existing long-line linter warnings; zero new errors or axiom warnings.

## Uncovered declarations

None — this declaration has a corresponding `\lean{AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso}` entry already in the blueprint at `lem:relativeTensor_as_coequalizer`.
