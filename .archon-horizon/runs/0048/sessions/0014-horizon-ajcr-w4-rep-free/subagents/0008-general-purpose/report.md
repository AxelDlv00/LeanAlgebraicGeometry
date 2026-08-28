Analysis complete. Scripts: `/tmp/ajcr_closure.py` (import closure) and `/tmp/ajcr_sorry.py` (comment-stripped token scan). No `lake build` was run.

## 1-4. Root-closure membership — all four are IN

| Module | In closure | Chain |
|---|---|---|
| `Picard/DivRepGlobalLift.lean` | YES | `AlgebraicJacobian.lean` → `Picard.DivRepGlobalLift` (**direct import**, root line 458) |
| `Picard/DivRepKit.lean` | YES | `AlgebraicJacobian.lean` → `Picard.DivRepGlobalLift` → `Picard.DivRepKit` (`.../AlgebraicJacobian/Picard/DivRepGlobalLift.lean:6`). Sole importer in the whole tree. |
| `Picard/JacobianDataCharts.lean` | YES | `AlgebraicJacobian.lean` → `Picard.JacobianDataCharts` (**direct import**) |
| `Picard/Pic0SigmaSheaf.lean` | YES | `AlgebraicJacobian.lean` → `Picard.Pic0SigmaSheaf` (**direct import**) |

## 5. `Curve/GeometricallyReduced` in closure of `Picard/Pic0SigmaSheaf` — YES

```
Picard.Pic0SigmaSheaf -> Picard.PicEtCoverBridge -> Picard.Pic0ZariskiSheaf
  -> Picard.Pic0Functor -> Picard.PicEtMap -> Picard.PicEtMapToolkit
  -> Picard.PicEtAffZariskiGlue -> Picard.PicEtAffZariskiSep -> Picard.RelPicPi
  -> Picard.ProjectionUnits -> Picard.Separatedness -> Picard.UniversalSections
  -> Curve.GeometricallyReduced
```
(shortest BFS chain; Pic0SigmaSheaf's own closure is 135 modules)

## 6. Orphans — 94 of 623

623 `.lean` files under `AlgebraicJacobian/`; 529 in the root closure; **94 orphaned**. Note `lakefile.toml` declares `[[lean_lib]] name = "AlgebraicJacobian"` with no `globs`, so the default glob is `.one` — orphans are **not compiled by `lake build`** at all.

Breakdown: `Algebra/` 2 — `DirectLimitQuotient`, `FlatDirectLimit`. `Picard/` 92, dominated by two dead sub-trees: 38 `DivSchemeHighWindow*`, 25 `DivSchemeRedesign*`, plus 12 `DivSchemeSeedUniv*`, 3 `DivSchemeThetaCoordinate*`/`ThetaKernelKill`, 2 `DivSchemeMulIdeal*`, and singles `DivRepGlobalClassify`, `DivSchemeFibrePoint`, `DivSchemeFibrePointRead`, `DivSchemeFlatteningBridge`, `DivSchemeProjectiveFibreModel`, `DivSchemeWindowMulGeneral`, `DivisorFamilyWindowUnitGeneration`, `EntryIdeal`, `Pic0AtlasFromDivRep`, `Pic0ThetaCocycle`, `ScratchChartLocal`.

The orphan forest has 16 true roots (imported by nothing anywhere): `Picard/{DivRepGlobalClassify, DivSchemeFlatteningBridge, DivSchemeHighWindowSecondContainment, DivSchemeRedesignFlatIdealFibre, DivSchemeRedesignKappaZEquiv, DivSchemeRedesignKappaZPurity, DivSchemeRedesignKappaZSeed, DivSchemeRedesignPointPrime, DivSchemeRedesignRDN, DivSchemeRedesignRankOneChart, DivSchemeSeedUnivPulledDegree, DivSchemeSeedUnivSecondWindowMap, EntryIdeal, Pic0AtlasFromDivRep, Pic0ThetaCocycle, ScratchChartLocal}`. Full 94-item list is reproducible via `/tmp/ajcr_closure.py`.

Also checked: **0 imports reference a nonexistent file.**

## 7. `sorry` / axiom scan (comments stripped; raw grep is misleading — most `sorry` hits are prose in docstrings)

**Non-Challenge `sorry` in actual code: exactly 1**
- `/home/axel/.../AlgebraicJacobian/Picard/Pic0ThetaCocycle.lean:268` — bare `sorry` closing `theorem pic0Theta_comp`. This file is an **orphan** (imported by nothing) and its own header at lines 45-48 says "Do NOT import this file from the root until both `sorry`s are closed". So it is invisible to `lake build`.

**Challenge.lean `sorry` count: 15 in code** (raw `grep -c` reports 18 lines; lines 16, 18, 165 are docstring prose). Code hits: `AlgebraicJacobian/Challenge.lean:` 99, 108, 113, 117, 121, 126, 134, 147, 156 (`map _ := sorry`), 157 (`map_id := sorry`), 158 (`map_comp := sorry`), 248, 259, 272, 283.

**axiom declarations: 0.** Every `axiom` string in the tree is prose in comments (e.g. "the `𝒪ˣ`-sheaf axiom", "axiom-clean", "axiom (C1)").

**`native_decide`: 0. `@[implemented_by]`: 0. `sorryAx`/`admit`/`#exit`/`extern`: 0.**
