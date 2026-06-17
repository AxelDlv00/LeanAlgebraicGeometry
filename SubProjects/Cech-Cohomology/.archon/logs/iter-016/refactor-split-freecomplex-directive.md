# Refactor directive — create `FreePresheafComplex.lean` (P3b file split for parallelism)

## Goal
Split the P3b presheaf-Čech work across two files so two provers can build in parallel
(standing directive: parallelism via file splitting). `PresheafCech.lean` keeps the
**section** side (`sectionCechComplex`, the hom-identification, `injective_cech_acyclic`); the new
file owns the **free-complex** side (`cechFreePresheafComplex`, `cechFreeComplex_quasiIso`).

This iteration you ONLY create the new skeleton file and wire its import. You do NOT move any
existing declaration and you do NOT write any mathematical construction.

## Exact changes
1. **Create** `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` with:
   - The standard project file header (copyright block mirroring `PresheafCech.lean`).
   - Imports mirroring `PresheafCech.lean`:
     ```
     import Mathlib
     import AlgebraicJacobian.Cohomology.CechHigherDirectImage
     import AlgebraicJacobian.Cohomology.PresheafCech
     ```
   - A module docstring `/-! ... -/` stating this is the free-presheaf-complex side of the P3b
     bridge, and listing the two declarations to be built (with their blueprint `\lean{}` names):
     `AlgebraicGeometry.cechFreePresheafComplex` (`def:cech_free_presheaf_complex`) and
     `AlgebraicGeometry.cechFreeComplex_quasiIso` (`lem:cech_free_complex_quasi_iso`).
   - `universe u`, `open CategoryTheory Limits`, and `namespace AlgebraicGeometry ... end AlgebraicGeometry`.
   - Inside the namespace, a `/- Planner strategy: ... -/` comment block (NO declarations) capturing
     the build recipe for the next prover:
       * `cechFreePresheafComplex` — a `ChainComplex X.PresheafOfModules ℕ`, degree `p` term
         `⨁_{σ : Fin(p+1) → ι} (PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj (⨅ k, U (σ k)))`,
         with the alternating-face differential. Build it as a **simplicial** object
         (`SimplicialObject`) and apply `AlgebraicTopology.alternatingFaceMapComplex` to get `d²=0`
         FOR FREE — do NOT hand-roll the alternating-sum identity. Use `PresheafOfModules.free` +
         `yoneda` (NOT a bespoke `j_!`).
       * `cechFreeComplex_quasiIso` — the free complex resolves `O_𝒰`; build an objectwise contracting
         homotopy as a `HomologicalComplex.Homotopy`, then `HomotopyEquiv.toQuasiIso`.
         DEAD END (do not retry): do NOT route through `SimplicialObject.Augmented.ExtraDegeneracy`.
   - **NO `def`/`lemma`/`theorem` declarations and NO `sorry`** — leave the file as a compiling
     skeleton (imports + namespace + comments only), exactly the shape `PresheafCech.lean` had before
     its first prover pass. The file must compile green.
2. **Wire the import**: add the line
   `import AlgebraicJacobian.Cohomology.FreePresheafComplex`
   to the root aggregator `AlgebraicJacobian.lean` (after the `PresheafCech` import line).

## Verify
After the edits, `lake build` must be GREEN (the new file is an empty skeleton; the root now imports it).

## Out of scope
- Do NOT move, rename, or modify any existing declaration in any file.
- Do NOT touch `PresheafCech.lean`'s declarations (`injective_toPresheafOfModules`, `freeYonedaHomEquiv`).
- Do NOT edit blueprint chapters (the planner updates `% archon:covers` and `\lean{}` separately).
- Do NOT touch any protected signature.
