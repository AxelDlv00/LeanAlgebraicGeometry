# Refactor Report

## Slug
structuresheaf-split

## Status
COMPLETE

## Directive

### Problem
`AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` was 877 LOC, far above the project's preferred 400-600 LOC per file. Split the single file into three sub-files plus a thin re-export:

- `StructureSheafModuleK/Presheaf.lean` — helpers (1)-(5), per-open ring maps, `toModuleKPresheaf`.
- `StructureSheafModuleK/SheafProperty.lean` — the sheaf condition proof and `toModuleKSheaf` bundling.
- `StructureSheafModuleK/Carriers.lean` — `IsAffineHModuleVanishing`, `IsHModuleHomFinite`, producer instances and surrounding plumbing.
- `StructureSheafModuleK.lean` — re-exports all three via `import`.

Constraints: preserve every declaration's signature character-for-character; pure file-move, no content edits; sorry count unchanged.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
- **What:** Replaced the 877-LOC monolith with a 30-LOC thin re-export module that imports the three new sub-files and carries a single module docstring describing the split.
- **Why:** Per directive — preserve the umbrella path so `AlgebraicJacobian.lean`, `AlgebraicJacobian/Genus.lean`, and `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` (the only three downstream consumers I located) keep their existing `import AlgebraicJacobian.Cohomology.StructureSheafModuleK` lines unchanged.
- **Cascading:** None — the re-export module exposes every declaration that was in the original file (via transitive imports), and no consumer file needed any edit.

### File: `AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean` (new, 196 LOC)
- **What:** Holds, in order:
  - `namespace CategoryTheory` block: `Functor.const_additive`, `Functor.const_linear`, `Adjunction.left_adjoint_linear`, `Adjunction.right_adjoint_linear`, `Adjunction.homLinearEquiv` (the iter-046 Mathlib gap-fills).
  - `namespace AlgebraicGeometry.Cohomology`: `instHasSheafify_Opens_ModuleCatK`, `instHasExt_Sheaf_Opens_ModuleCatK`.
  - `namespace AlgebraicGeometry.Scheme.toModuleKSheaf`: helpers (1)–(5) — `kToSection`, `algebraSection`, `algebraMap_eq_kToSection`, `kToSection_naturality`, `algebraMap_naturality`.
  - `namespace AlgebraicGeometry.Scheme`: `toModuleKPresheaf` (helper 6) and `@[simp] toModuleKPresheaf_obj`.
- **Why:** This is the most upstream sub-file (no sibling deps); puts the categorical gap-fills + Cohomology prerequisite instances + per-open ring-map machinery + the presheaf definition together. The CategoryTheory gap-fills are general utility (only directly used by the Carriers `constantSheafGammaHom_linearEquiv`) but living in the most upstream sub-file ensures they propagate by transitive import to both siblings — semantically equivalent to the original.
- **Cascading:** None.

### File: `AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean` (new, 59 LOC)
- **What:** Holds `toModuleKPresheaf_isSheaf` (helper 7), `toModuleKSheaf` (helper 8), and `toModuleKSheaf_forgetCompare`, all in `namespace AlgebraicGeometry.Scheme`. Imports `…StructureSheafModuleK.Presheaf`.
- **Why:** Cleanly isolates the sheaf-property step and the bundled sheaf — the only thing downstream Carriers and downstream consumers really need from this layer is `toModuleKSheaf`.
- **Cascading:** None.

### File: `AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean` (new, 667 LOC)
- **What:** Holds the rest — all material from `HModule` (line 262 of the old file) through the end of `Scheme.subsingleton_HModule'_supr_of_isCechAcyclicCover_curve`:
  - In `namespace AlgebraicGeometry.Scheme`: `HModule`, `HModule_zero_linearEquiv`, `HModule'`, `HModule'_zero_linearEquiv`, `module_finite_HModule_zero`, `module_finite_HModule'_zero`, `module_finite_HModule_zero_curve`, `module_finite_HModule'_zero_curve`, `IsAffineHModuleVanishing`, `module_finite_HModule'_of_isAffineHModuleVanishing`, `IsHModuleHomFinite`, `module_finite_HModule_zero_of_isHModuleHomFinite`, `module_finite_HModule_zero_of_isHModuleHomFinite_curve`, `module_finite_globalSections_of_isProper`, `SheafGammaObj_linearEquiv_top`, `module_finite_gammaObj_of_isProper`, `constantSheafGammaHom_linearEquiv`, `homFromOne_linearEquiv`, `instIsHModuleHomFinite_toModuleKSheaf`.
  - In `namespace AlgebraicGeometry`: `Scheme.cechCochain_OC`, `Scheme.cechCohomology_OC`, `Scheme.cechCochain`, `Scheme.cechCohomology`, `Scheme.cechCochain_OC_eq`, `Scheme.cechCohomology_OC_eq`, `Scheme.IsCechAcyclicCover`, `Scheme.subsingleton_HModule'_supr_of_isCechAcyclicCover`, `Scheme.subsingleton_HModule'_supr_of_isCechAcyclicCover_curve`.
  Imports `…StructureSheafModuleK.SheafProperty`.
- **Why:** Per directive — the downstream finite-length carriers (`IsAffineHModuleVanishing`, `IsHModuleHomFinite`), the H⁰ algebraic bridges (`HModule[_zero_linearEquiv]`, `HModule'[_zero_linearEquiv]`, `Module.Finite` transports, the Stein-finiteness input, the constant-sheaf-Γ adjunction LinearEquiv upgrade, the homFromOne identification), the curve-side producer instance, AND the Čech-side scaffolding (cochain/cohomology carriers + `IsCechAcyclicCover`) all naturally cluster under "downstream finite-length carriers + producer-instance plumbing".
- **Cascading:** None — preserved every signature character-for-character and every body unchanged.

## Compilation Status

- `lake build AlgebraicJacobian.Cohomology.StructureSheafModuleK` → `Build completed successfully (8322 jobs).` All four files (the three sub-files and the re-export) build cleanly.
- `lake build AlgebraicJacobian` → `Build completed successfully (8339 jobs).` Three downstream consumers (`AlgebraicJacobian.lean`, `AlgebraicJacobian.Genus`, `AlgebraicJacobian.Cohomology.MayerVietorisCore`) build clean against the re-exported module. All `declaration uses 'sorry'` warnings during the build are pre-existing sorries in other files (`Genus0BaseObjects.lean`, `Picard/RelativeSpec.lean`, `RiemannRoch/WeilDivisor.lean`, `Jacobian.lean`, `AbelianVarietyRigidity.lean`, `RigidityKbar.lean`); none originate in the four files I touched.

## New Sorries Introduced

None. `grep -nE "sorry|axiom " StructureSheafModuleK.lean StructureSheafModuleK/{Presheaf,SheafProperty,Carriers}.lean` returns no matches.

## Line Counts

| File | LOC |
|------|-----|
| `StructureSheafModuleK.lean` (re-export) | 30 |
| `StructureSheafModuleK/Presheaf.lean` | 196 |
| `StructureSheafModuleK/SheafProperty.lean` | 59 |
| `StructureSheafModuleK/Carriers.lean` | 667 |
| **Total** | 952 (vs. 877 original — ~75 LOC of new headers/docstrings) |

## Notes for Plan Agent

1. **Carriers.lean exceeds the < 400 LOC target.** Per the directive's "Expected Outcome" each sub-file should be < 400 LOC, but Carriers landed at 667 LOC because the natural grouping under "downstream finite-length carriers + producer-instance plumbing" naturally absorbs:
   - The `HModule` / `HModule'` abbrevs and their H⁰ `LinearEquiv` bridges (~70 LOC of doc-heavy theorems with multi-paragraph rationale comments)
   - The four `module_finite_HModule[']{,_zero}{,_curve}` transport companions (~50 LOC each, again doc-heavy)
   - The `IsAffineHModuleVanishing` + `IsHModuleHomFinite` carrier classes + consumers + curve specialisations (~120 LOC)
   - The Stein-input chain (`module_finite_globalSections_of_isProper`, `SheafGammaObj_linearEquiv_top`, `module_finite_gammaObj_of_isProper`, `constantSheafGammaHom_linearEquiv`, `homFromOne_linearEquiv`, `instIsHModuleHomFinite_toModuleKSheaf` — ~200 LOC)
   - The Čech-side complex/cohomology carriers + `IsCechAcyclicCover` + subsingleton transports (~150 LOC)
   The bulk is docstrings — actual proof bodies are short. If a follow-up split is desired the natural fault line is to factor out the Čech-side block (`Scheme.cechCochain[_OC]`, `Scheme.cechCohomology[_OC]`, `Scheme.IsCechAcyclicCover`, and the two `subsingleton_HModule'_supr_of_isCechAcyclicCover{,_curve}`) into a 4th sub-file `Carriers/Cech.lean` or `Cech.lean`; that would drop Carriers to ~510 LOC and the Čech file to ~150 LOC. I did NOT make this additional split because the directive specified exactly three sub-files and named the file contents.

2. **CategoryTheory gap-fills placement.** I placed the `Functor.const_*` / `Adjunction.{left_adjoint_linear, right_adjoint_linear, homLinearEquiv}` instances in Presheaf.lean (the most upstream sub-file). They are *directly* used only in `constantSheafGammaHom_linearEquiv` (in Carriers), but they are typeclass-level utility code and putting them in the upstream file matches the original file's layout (they were at the very top) and ensures they propagate by transitive import.

3. **`% archon:covers` line.** The blueprint chapter `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` does not currently carry an explicit `% archon:covers` directive. Per the refactor directive, the cover relationship is implicit via filename and is unaffected by the split (the re-export module retains the original path). The plan agent may want to add `% archon:covers AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean` to that chapter for explicitness, but it is not required for build hygiene.

4. **No protected-declaration moves.** Cross-checked `archon-protected.yaml` — none of the declarations in `StructureSheafModuleK.lean` are protected, so no path updates were required.

5. **Downstream consumers untouched.** The three files importing `AlgebraicJacobian.Cohomology.StructureSheafModuleK` (`AlgebraicJacobian.lean`, `AlgebraicJacobian/Genus.lean`, `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`) build clean with no edits; verified via `lake build AlgebraicJacobian` exit 0.

6. **Mathematical justification adequacy.** The directive's mathematical justification was fully sufficient — the split fell along clean concern-boundaries (per-open ring map / sheaf condition / downstream carriers) with no implicit dependencies that violated the topological order. The only judgment call was where to land the CategoryTheory gap-fill block (handled per note 2 above).
