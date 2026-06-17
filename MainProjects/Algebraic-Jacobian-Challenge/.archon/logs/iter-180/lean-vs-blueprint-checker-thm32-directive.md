# lean-vs-blueprint-checker — Thm32RationalMapExtension.lean ↔ Albanese_Thm32RationalMapExtension.tex

## File pair

- **Lean**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean`
- **Blueprint**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`

## What changed this iter (Lane G — iter-180)

- `av_isIntegral_and_codimOneFree` was split into 2 named helpers:
  - `av_isIntegral_of_smooth_geomIrred` (L145): closes 3 of 4 steps axiom-clean; lone sorry on `IsReduced A.left` (Mathlib gap: `Smooth ⟹ IsReduced`).
  - `av_codimOneFree_of_indeterminacy` (L189): sorry body; documents the precise gap (combination of `indeterminacy_pure_codim_one_into_grpScheme` + codim-≥2 conclusion of Milne 3.1, the latter NOT exposed standalone).
- File 1 → 2 sorries (per directive's Option (a) split).
- Prover DEVIATED from the directive's "second helper closes axiom-clean via Lemma 3.3 as black box" by leaving sorry + documenting that Lemma 3.3 alone is insufficient.

## Report bidirectionally

1. **Lean → blueprint**: does the chapter's `\lean{...}` pin (`extend_to_av`) still match? Are the new helpers blueprint-owed?
2. **Blueprint → Lean**: is the chapter's prose detailed enough that a reader can see why Lemma 3.3 alone cannot close `CodimOneFree` (the prover's deviation rationale)? If not, the chapter needs strengthening on the Milne 3.1 codim-≥2 piece + how it combines with Lemma 3.3.

Output to `task_results/lean-vs-blueprint-checker-thm32.md`.
