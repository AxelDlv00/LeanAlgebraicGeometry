# Iter-209 objectives

## Dispatch shape
**No prover dispatch** (structural-pivot diagnosis iter; progress-critic ts209 Option B).
Plan-phase subagents only: 2 read-only consults + 1 strategy-critic + 1 blueprint-writer.

## Lane TS — `Picard/TensorObjSubstrate.lean` (NOT dispatched)
- **Status**: STUCK (progress-critic ts209, 4 triggers); construction PIVOTED to ⊗-invertibility.
- **Pivot (analogist tsconstruct209, ALIGN_WITH_MATHLIB)**: a line object is `∃ N, M⊗N≅𝒪`
  (`Module.Invertible` / `CommRing.Pic = Units(Skeleton)`; Stacks 01HK/01CR). Removes
  `tensorObj_restrict_iso` + `exists_tensorObj_inverse` from the critical path.
- **Engine correction (strategy-critic clean209 + planner LSP check)**: the iso-class
  associator needs `J.W.IsMonoidal` (strong-monoidal sheafification). `Sheaf.monoidalCategory`
  exists in Mathlib gated on it; no direct `SheafOfModules` monoidal instance. Mechanical only
  on the flat/line-bundle subcategory (`whiskerLeft`-for-flat via `Module.Flat.lTensor_*`).
- **Owed iter-210 (in order)**: (1) blueprint engine-correction writer + clean + scoped review;
  (2) verify `whiskerLeft`-for-flat mechanical; (3) if gate clears, mathlib-build prover on the
  first ingredient (`whiskerLeft`-for-flat / `J.W.IsMonoidal` on line bundles).

## Reference anchors used
- `analogies/tsconstruct209.md` (pivot rationale), `analogies/ts-design206.md` (flat-subcategory route).
- Stacks 01HK (⊗-invertibility), 01CR (Pic abelian group); `Mathlib.RingTheory.PicardGroup`
  (`Module.Invertible`, `CommRing.Pic`); `Mathlib.CategoryTheory.Sites.Monoidal`
  (`Sheaf.monoidalCategory`, `J.W.IsMonoidal`).

## All other lanes
Held / paused / gated by USER standing directives (ROUTE C PAUSE; no A.3/A.4 before A.2.c).
