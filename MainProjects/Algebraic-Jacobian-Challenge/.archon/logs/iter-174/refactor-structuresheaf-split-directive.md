# Refactor Directive

## Slug
structuresheaf-split

## Problem

`AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` is 877 LOC, far above the project's preferred 400-600 LOC per file. The file ships a multi-stage construction:
1. Helpers (1)-(5) for the structure-morphism-derived ring map `k → Γ(C, U)`.
2. The presheaf `toModuleKPresheaf` (6).
3. The sheaf property proof `toModuleKPresheaf_isSheaf` (7).
4. The bundled sheaf `toModuleKSheaf` (8).
5. Downstream finite-length carriers `IsAffineHModuleVanishing`, `IsHModuleHomFinite`, and producer-instance plumbing.

These naturally split into three units along the lines of mathematical concern. The split is **off the critical path** of any active prover lane (no current Lane targets this file); it's a hygiene refactor of a fallback-arm Lean module.

## Mathematical Justification

The five blocks above represent three distinct concerns:
- (1)-(2) — preparing the per-open `k → Γ(C, U)` ring map and its presheaf wrapper.
- (3)-(4) — establishing the sheaf condition and bundling.
- (5) — downstream finite-length carriers and their producer instances.

Splitting these into three files mirrors the precedent of `Mathlib.AlgebraicGeometry.SheafOfModules.{Basic,Sheaf,Limits}` (or similar Mathlib subdivisions). Each sub-file then carries < 400 LOC.

## Changes Requested

### Create file structure

Replace the single file `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` with **three** sub-files plus a thin re-export:

- `AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean` — helpers (1)-(5), the per-open ring maps, and the `toModuleKPresheaf` definition.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean` — the sheaf condition proof and the `toModuleKSheaf` bundling.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean` — `IsAffineHModuleVanishing`, `IsHModuleHomFinite`, and the curve-side producer instances.

Plus the re-export module:
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` — re-exports all three via `import`.

### Re-export module shape

```lean
/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.Presheaf
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.SheafProperty
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.Carriers

/-! # Sheaves of `k`-modules: re-export -/
```

### Per-sub-file scope (preserve signatures)

For each sub-file:
- Preserve every declaration's full signature character-for-character.
- Preserve every declaration's body (this is a pure file-move, NOT a content edit).
- Re-order imports so each sub-file pulls in only the upstream sub-files it needs (Presheaf has no internal sibling deps; SheafProperty imports Presheaf; Carriers imports SheafProperty).
- Preserve namespace declarations; if a namespace `AlgebraicGeometry.Cohomology.StructureSheafModuleK` opens in the source file, open it in each sub-file that needs it.
- Preserve all docstrings and comments (move them with their declarations).

### Affected Files

- Splits: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` → 3 sub-files + re-export.
- Re-export is named the same as the original so the **umbrella file `AlgebraicJacobian.lean` does NOT need editing** (its `import AlgebraicJacobian.Cohomology.StructureSheafModuleK` still resolves).
- Verify no other Lean file outside `AlgebraicJacobian/Cohomology/StructureSheafModuleK*` is affected (the goal is the umbrella import stays the same).

### Blueprint `% archon:covers`

The blueprint chapter `Cohomology_StructureSheafModuleK.tex` covers `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`. After the refactor, this remains the **same path** (the re-export module retains the original name). No `% archon:covers` edit is needed.

If you want to be even cleaner: add `% archon:covers AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean` to the chapter (so each sub-file is explicitly covered). Decide based on what minimizes risk; the original cover line is sufficient since the re-export module name is unchanged.

### Verification

After the refactor:
1. `lake build AlgebraicJacobian.Cohomology.StructureSheafModuleK` → exit 0.
2. `lake build AlgebraicJacobian` → exit 0.
3. Sorry count UNCHANGED on this module group.
4. No declarations renamed or re-signed.

## Expected Outcome

- 1 file (877 LOC) becomes 3 sub-files + 1 re-export.
- Each sub-file < 400 LOC.
- Umbrella `AlgebraicJacobian.lean` unchanged.
- Sorry count unchanged.
- `lake build` clean.
