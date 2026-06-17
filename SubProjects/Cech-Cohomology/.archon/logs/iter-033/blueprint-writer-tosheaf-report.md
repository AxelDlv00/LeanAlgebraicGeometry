# Blueprint Writer Report

## Slug
tosheaf

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Primary fix — correct route for `lem:to_sheaf_preserves_epi`
- **Added lemma** `\lemma`/`\label{lem:toSheaf_preservesFiniteColimits}`/`\lean{AlgebraicGeometry.toSheaf_preservesFiniteColimits}` — the missing right-exact dual: `toSheaf R` preserves finite colimits.
  - Proof sketch added: Y. Two steps following the verified route — (Step 1) the composite `L ⋙ toSheaf R` preserves finite colimits via the sheafification square iso (`toPresheaf` preserves finite colimits objectwise + `presheafToSheaf` is a left adjoint), and (Step 2) per-diagram descent `F ≅ (F ⋙ forget R) ⋙ L` (counit iso) carries `toSheaf`'s colimit cocone to a colimit cocone. Routed through the left-adjoint reflector `L`, never through `forget`.
- **Added Mathlib anchor** `\label{lem:sheafificationCompToSheaf_mathlib}`/`\lean{PresheafOfModules.sheafificationCompToSheaf}` `\mathlibok` — the square iso `L ⋙ toSheaf R ≅ toPresheaf R₀ ⋙ presheafToSheaf J Ab`. Name verified via loogle (exists, module `Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification`).
- **Added Mathlib anchor** `\label{lem:preservesEpi_of_preservesColimitsOfShape_mathlib}`/`\lean{CategoryTheory.preservesEpimorphisms_of_preservesColimitsOfShape}` `\mathlibok` — preserving WalkingSpan colimits ⇒ preserves epis. Name + namespace verified against `Mathlib/CategoryTheory/Limits/Constructions/EpiMono.lean:62` (decl sits in `namespace CategoryTheory` with `open Limits`, so the fully-qualified name is `CategoryTheory.preservesEpimorphisms_of_preservesColimitsOfShape`).
- **Revised** `lem:to_sheaf_preserves_epi` — deleted the wrong "left adjoint composed with the exact sheafification–forgetful comparison" claim; proof is now "by `lem:toSheaf_preservesFiniteColimits` + `lem:preservesEpi_of_preservesColimitsOfShape_mathlib` (WalkingSpan finite)". Added `\uses{lem:toSheaf_preservesFiniteColimits, lem:preservesEpi_of_preservesColimitsOfShape_mathlib}` to both statement and proof. Shortened the `% NOTE (iter-032)` to point at the new sub-lemma + `analogies/tosheaf-epi.md` while keeping the historical record (the wrong route + the missing Mathlib dual).

### Secondary fix — `lem:standard_cover_cofinal`
- **Revised** statement prose to the realized **indexed-cover/refinement** shape: given an arbitrary open cover `{W_α}_{α∈A}` of `D(f)`, there exist `n`, `g : {1..n}→R`, and a reindexing `φ : {1..n}→A` with `D(f) = ⋃ᵢ D(gᵢ)` and `D(gᵢ) ⊆ W_{φ(i)}`.
- **Revised** proof to use quasi-compactness of `D(f)` + the basic-open topological basis + finite subcover (no longer the affine-opens-basis lemma).
- **Fixed dependencies** `lem:standard_cover_cofinal` — dropped the spurious `lem:scheme_isBasis_affineOpens` from statement `\uses{}`; statement now uses `def:standard_affine_cover, lem:primeSpectrum_isBasis_basicOpen`, proof now uses `def:standard_affine_cover, lem:affine_faces_mem, lem:primeSpectrum_isBasis_basicOpen`. `\lean{}` pin untouched.
- **Added Mathlib anchor** `\label{lem:primeSpectrum_isBasis_basicOpen}`/`\lean{PrimeSpectrum.isTopologicalBasis_basic_opens}` `\mathlibok` — basic opens form a topological basis of `Spec R`. Name verified via loogle (exists, module `Mathlib.RingTheory.Spectrum.Prime.Topology`).

## Cross-references introduced
- `\uses{lem:sheafificationCompToSheaf_mathlib}` in `lem:toSheaf_preservesFiniteColimits` (stmt + proof) — anchor created in this chapter.
- `\uses{lem:toSheaf_preservesFiniteColimits, lem:preservesEpi_of_preservesColimitsOfShape_mathlib}` in `lem:to_sheaf_preserves_epi` (stmt + proof) — both created in this chapter.
- `\uses{lem:primeSpectrum_isBasis_basicOpen}` in `lem:standard_cover_cofinal` (stmt + proof) — anchor created in this chapter.
- `leandag build --json`: `unknown_uses: []`, no isolated node in this chapter (`leandag query --isolated --chapter Cohomology_CechHigherDirectImage` → 0 results). All four new nodes appear in the DAG with edges.

## References consulted
- None for verbatim quotes. The two project-bespoke blocks (`lem:toSheaf_preservesFiniteColimits`, `lem:to_sheaf_preserves_epi`) carry no external source by design (missing Mathlib dual). Mathlib anchor names verified directly against the local Mathlib checkout / loogle (see below), not from training memory:
  - `analogies/tosheaf-epi.md` — the verified route (Route A) the sub-lemma encodes.
  - loogle: `PresheafOfModules.sheafificationCompToSheaf`, `PrimeSpectrum.isTopologicalBasis_basic_opens` (both found).
  - `.lake/.../Mathlib/CategoryTheory/Limits/Constructions/EpiMono.lean:62` — confirmed `preservesEpimorphisms_of_preservesColimitsOfShape` name + `CategoryTheory` namespace.

## Macros needed (if any)
- None. All commands used (`\mathrm`, `\operatorname`, `\circ`, `\cong`, `\mathbf{Ab}`, `\bigcup`) are standard / already in use in the chapter.

## Notes for Plan Agent
- `lem:affine_surj_of_vanishing` still `\uses{lem:scheme_isBasis_affineOpens}` in Step 2 (its own refinement-to-affine-basis reasoning). That block remains live and non-isolated; I left it untouched as out of scope. If the realized Lean `affine_surj_of_vanishing` actually leans on the basic-open basis rather than the affine-opens basis, that `\uses` may want the same `lem:primeSpectrum_isBasis_basicOpen` swap — flagging for a future reconcile, not changed here.
- The `lem:toSheaf_preservesFiniteColimits` proof names `toPresheaf R₀` finite-colimit preservation and `presheafToSheaf` left-adjoint colimit preservation inline rather than as separate `\mathlibok` anchors, to avoid over-proliferation (both are standard Mathlib facts; only the non-obvious square iso got its own anchor). If the reviewer prefers explicit anchors for those two, they are `PresheafOfModules.toPresheaf` colimit-preservation (`…/ModuleCat/Presheaf/Colimits.lean`) and `CategoryTheory.sheafificationAdjunction` / `Adjunction.leftAdjoint_preservesColimits`.

## Strategy-modifying findings
None. The correction is internal to the chapter's proof routing and matches the existing strategy (this gap-fill is a prerequisite for `lem:affine_surj_of_vanishing` → `affine_serre_vanishing`).
