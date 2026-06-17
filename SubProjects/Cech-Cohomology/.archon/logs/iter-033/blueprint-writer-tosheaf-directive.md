# Blueprint-writer directive — slug `tosheaf`

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (ONLY this file).

## Context
The block `lem:to_sheaf_preserves_epi` (~L3461, Lean target
`AlgebraicGeometry.toSheaf_preservesEpimorphisms`) currently carries a proof sketch that is
**mathematically wrong / misleading**: it claims `toSheaf` "preserves finite colimits, being a left
adjoint composed with the exact sheafification–forgetful comparison." That is the wrong direction —
`toSheaf` is NOT a left adjoint, and the iter-032 prover burned an iteration confirming the route is
not a small instance. A `% NOTE (iter-032)` already documents the failure. Your job is to REPLACE
the wrong proof with the correct, bounded route, decomposing it into a small `\uses`-linked chain so
a prover can formalize it piece by piece.

## The correct route (verified by mathlib-analogist, see `analogies/tosheaf-epi.md`)
The content is genuinely `PreservesFiniteColimits (SheafOfModules.toSheaf R)` (toSheaf
RIGHT-exactness), the missing dual of Mathlib's `PreservesFiniteLimits (toSheaf R)`. It must be
routed through the **sheafification square + the left-adjoint reflector**, NEVER through `forget`
(which is a right adjoint and structurally cannot preserve epis). The chain:

1. Let `L := PresheafOfModules.sheafification (𝟙 R.obj) : PresheafOfModules R.obj ⥤ SheafOfModules R`
   — a LEFT adjoint and a localization (counit is an iso).
2. Square iso `L ⋙ toSheaf R ≅ toPresheaf R.obj ⋙ presheafToSheaf J AddCommGrpCat`
   (Mathlib `PresheafOfModules.sheafificationCompToSheaf (𝟙 R.obj)`).
3. `toPresheaf R.obj` preserves finite colimits (Mathlib `…/ModuleCat/Presheaf/Colimits.lean`);
   `presheafToSheaf J AddCommGrpCat` preserves colimits (left adjoint, `sheafificationAdjunction`).
   ⇒ `L ⋙ toSheaf` preserves finite colimits.
4. Per-diagram: for `F : K ⥤ SheafOfModules R`, `F ≅ (F ⋙ forget R) ⋙ L`, so
   `colimit F ≅ L (colimit (F ⋙ forget R))`; applying the colimit-preserving `L ⋙ toSheaf` shows
   `toSheaf` carries `F`'s colimit cocone to a colimit cocone ⇒ `PreservesFiniteColimits (toSheaf R)`.
5. Epi-preservation `toSheaf_preservesEpimorphisms` is then a one-line corollary via
   `preservesEpimorphisms_of_preservesColimitsOfShape` (WalkingSpan is finite).
6. Downstream consumer: `Epi g ⟹ Epi (toSheaf g) ⟹ IsLocallySurjective (toSheaf g)` via
   `Sheaf.isLocallySurjective_iff_epi'.mpr` (the `Balanced` arg comes from `Sheaf J AddCommGrpCat`
   being abelian).

## What to write
1. **New sub-lemma block** `lem:toSheaf_preservesFiniteColimits` with
   `\lean{AlgebraicGeometry.toSheaf_preservesFiniteColimits}` — statement: the forgetful functor
   `SheafOfModules R ⥤ Sheaf J AddCommGrpCat` preserves finite colimits. Informal proof = steps 1–4
   above, in project notation. This is project-bespoke Mathlib infrastructure (the missing dual of
   `PreservesFiniteLimits (toSheaf R)`) — NO external math source, so omit `% SOURCE`/`% SOURCE QUOTE`
   lines (stands on the construction alone). Its `\uses{}` should cite the Mathlib anchors it leans
   on (see point 3).
2. **Rewrite the proof of `lem:to_sheaf_preserves_epi`**: delete the wrong "left adjoint" claim;
   the proof is now "by `lem:toSheaf_preservesFiniteColimits` and
   `preservesEpimorphisms_of_preservesColimitsOfShape` (the span shape is finite)." Add
   `\uses{lem:toSheaf_preservesFiniteColimits}` to both the statement and proof blocks. Keep the
   existing `% NOTE (iter-032)` but you may shorten it to point at the new sub-lemma + the analogy
   file; do not delete the historical record entirely.
3. **Mathlib dependency anchors** (`\mathlibok`) — add SHORT anchor blocks (statement in project
   notation + `\lean{}` naming the real Mathlib decl + `\mathlibok`) ONLY for the genuine Mathlib
   pieces the build relies on that do not already have a block in this chapter. Candidates (check the
   chapter first; `lem:sheaf_locally_surjective_iff_epi` already exists as `\mathlibok`):
   - `PresheafOfModules.sheafificationCompToSheaf` (the square iso),
   - `preservesEpimorphisms_of_preservesColimitsOfShape` (epi from colimit preservation).
   You decide which anchors are worth a block vs. naming inline; do not over-proliferate. Wire
   `lem:toSheaf_preservesFiniteColimits`'s `\uses{}` to whichever anchors you create.

## Secondary fix (same chapter, while you are here)
The block `lem:standard_cover_cofinal` (~L3344, `\lean{AlgebraicGeometry.standard_cover_cofinal}`,
already `\leanok`) — the iter-032 prover reports the REALIZED Lean statement is the **indexed
cover/refinement** form (∃ n, g : Fin n → R, φ : Fin n → α with `D(f) = ⨆ᵢ D(gᵢ)` and
`D(gᵢ) ≤ W(φ i)`), and the actual proof uses `PrimeSpectrum.isTopologicalBasis_basic_opens`, NOT
`Scheme.isBasis_affineOpens`. Adjust the prose to describe the concrete indexed-cover/refinement
shape and correct its `\uses{}` to reflect the real dependencies (drop a spurious
`lem:scheme_isBasis_affineOpens` if present; the proof uses quasi-compactness of `D(f)` +
the basic-open topological basis + finite subcover). Do not change the `\lean{}` pin.

## Out of scope
Do NOT touch any other block (tilde, P1a, P1b, the 01EO/P5 material). Do NOT add `\leanok` anywhere
(that is the deterministic sync's job). Only `\mathlibok` on the genuine Mathlib anchors above.
