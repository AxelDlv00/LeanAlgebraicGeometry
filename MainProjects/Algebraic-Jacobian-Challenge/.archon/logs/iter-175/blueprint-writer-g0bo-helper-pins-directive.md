# Blueprint Writer Directive

## Slug
g0bo-helper-pins

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Strategy context

`AbelianVarietyRigidity.tex` is the consolidated chapter covering
`AbelianVarietyRigidity.lean`, `Genus0BaseObjects.lean` (and post-iter-175
the 4 G0BO sub-files), and `RigidityLemma.lean`. The chart-bridge sub-section
(near the `def:gmscaling_chart` / `lem:gmscaling_chart_agreement` /
`lem:gmscaling_over_coherence` blocks) currently does NOT pin two new
load-bearing helpers landed iter-174:

1. `AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap` (private
   lemma at `Genus0BaseObjects.lean:564`, post-split moves to
   `Genus0BaseObjects/ChartIso.lean`) — proves the chart-ring iso
   preserves `algebraMap kbar`. **Axiom-clean.** Load-bearing for Step B
   of `gmScalingP1_chart_PLB_eq`.
2. `AlgebraicGeometry.gmScalingP1_chart_PLB_eq` (private lemma at
   `Genus0BaseObjects.lean:991`, post-split moves to
   `Genus0BaseObjects/GmScaling.lean`) — the per-chart certificate
   consumed by `gmScalingP1_over_coherence`. **Steps A + B axiom-clean;
   Step C has 2 residual `sorry`s on `i=0`/`i=1` cases** (Fin syntactic
   mismatch, iter-175 Lane A target).

Per the iter-174 LVB `genus0-iter174` MAJOR finding, these two pins are
missing from the chapter. This iter's writer dispatch is to **add the
two `\lean{...}` blocks** so the blueprint↔Lean graph is current.

## Required content

NARROW SCOPE: add exactly 2 `\lean{...}` blocks. Do NOT rewrite the
chapter; do NOT add unrelated blocks; do NOT touch markers.

1. **Add a `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap}`
   block under the chart-ring-iso section**. Locate the existing block
   for `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left}`
   (label `lem:proj_chart_ring_iso_aux_left`) and the block for
   `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}`
   (label `lem:mvPoly_to_homogeneousLocalization_away_surjective`). Add
   a new lemma block **between** them or **immediately after**, using a
   format like:

       \begin{lemma}[chart-ring iso preserves `algebraMap kbar`]
         \label{lem:chart_ring_iso_preserves_algebraMap}
         \lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap}
         \uses{def:proj_chart_ring_iso}
         For the chart-ring iso of \cref{def:proj_chart_ring_iso}, the
         forward direction (`HomogeneousLocalization.Away 𝒜 (X i) → k̄[u]`)
         composed with `algebraMap kbar (HomogeneousLocalization.Away …)`
         equals the canonical `algebraMap kbar (MvPolynomial Unit kbar)`,
         i.e., the chart-ring iso preserves the `kbar`-algebra structure.
       \end{lemma}
       \begin{proof}
         \uses{lem:mvPoly_to_homogeneousLocalization_away_surjective}
         Round-trip via `mvPolyToHomogeneousLocalizationAway` and apply
         the forward round-trip identity
         `lem:proj_chart_ring_iso_aux_right`; the chart-ring iso then
         agrees with the `algebraMap` because `algebraMap kbar (Away …)`
         is `Algebra.compHom` of `HomogeneousLocalization.fromZeroRingHom`
         (Mathlib `HomogeneousLocalization.algebraMap_eq`), and the
         forward direction sends each degree-0 element back to the
         corresponding `MvPolynomial.C` constant.
       \end{proof}

   Adjust the prose modestly to fit the chapter's voice. The recipe text
   above is correct per the iter-174 prover task report at L17 of
   `task_results/AlgebraicJacobian_Genus0BaseObjects.lean.md`.

2. **Add a `\lean{AlgebraicGeometry.gmScalingP1_chart_PLB_eq}` block in
   the chart-glue scaffold subsection** (near `def:gmscaling_chart`,
   `lem:gmscaling_chart_agreement`, `lem:gmscaling_over_coherence`).
   Use a lemma block of the form:

       \begin{lemma}[per-chart `awayι ≫ PLB.hom` bridge]
         \label{lem:gmscaling_chart_PLB_eq}
         \lean{AlgebraicGeometry.gmScalingP1_chart_PLB_eq}
         \uses{def:gmscaling_chart, def:gmscaling_cover, lem:chart_ring_iso_preserves_algebraMap}
         For each `i : Fin 2`, the per-chart morphism `(gmScalingP1_cover).f i ≫
         (gmScalingP1_chart i).left` equals
         `((Proj.awayι …) ≫ (ℙ¹ ⊗ 𝔾ₘ).hom.left)`. This is the
         chart-by-chart certificate of the coherence equation required by
         the glued morphism `σ_×` constructed in \cref{def:gaTranslationP1}.
       \end{lemma}
       \begin{proof}
         \uses{lem:gmscaling_awayι_comp_PLB_hom}
         Three steps: (A) collapse `Proj.awayι ≫ PLB.hom` via the
         chart-bridge `lem:gmscaling_awayι_comp_PLB_hom`; (B) merge the
         `Spec.map`s via `Spec.map_comp` + the chart-ring-iso algebraMap
         preservation \cref{lem:chart_ring_iso_preserves_algebraMap}; (C)
         chase the pullback iso isomorphism using
         `pullbackSpecIso_hom_base`, `pullbackRightPullbackFstIso_hom_fst`,
         and `pullbackSymmetry_hom_comp_fst`. \emph{Step (C) currently
         carries two residual scaffold gaps on the `i=0` / `i=1` cases
         due to a Fin literal syntactic mismatch between
         `MvPolynomial.X (0 : Fin 2)` (from `match`-branch reduction) and
         `MvPolynomial.X ⟨0, _⟩` (post-`fin_cases`-substitution); the
         iter-175 Lane A prover lane closes these via the chart-bridge
         structural pivot.}
       \end{proof}

   Be sure to introduce a `\label{lem:gmscaling_awayι_comp_PLB_hom}`
   on the existing chart-bridge `awayι_comp_PLB_hom` lemma block if the
   chapter has one (or add a thin lemma block for it if missing, since
   it's a load-bearing helper too — but check first; if the chapter
   already documents the chart-bridge inline without a labeled lemma,
   leave it alone and replace the `\uses{}` reference with a prose
   citation).

## Out of scope

- Do NOT rewrite the chart-ring iso section's prose.
- Do NOT change the existing pinned blocks
  (`def:proj_chart_ring_iso`, `lem:proj_chart_ring_iso_aux_left`,
  `lem:proj_chart_ring_iso_aux_right`, `lem:mvPoly_to_homogeneousLocalization_away_surjective`,
  `def:gmscaling_chart`, `lem:gmscaling_chart_agreement`,
  `lem:gmscaling_over_coherence`, `def:gaTranslationP1`).
- Do NOT touch `\leanok` markers (deterministic sync_leanok manages).
- Do NOT change the file's `% archon:covers` line (refactor `g0bo-split`
  is handling that this iter).
- Do NOT add other unrelated `\lean{...}` blocks.

## References

- `analogies/chart-bridge-shared-helper.md` (iter-174 analogist consult)
  for the chart-bridge recipe.
- iter-174 prover task report `task_results/AlgebraicJacobian_Genus0BaseObjects.lean.md`
  for the verified body of `homogeneousLocalizationAwayIso_algebraMap`.

## Expected outcome

After your edit:
- The chapter has 2 new `\lean{...}`-pinned blocks for the iter-174
  helpers `homogeneousLocalizationAwayIso_algebraMap` and
  `gmScalingP1_chart_PLB_eq`.
- The iter-174 LVB `genus0-iter174` MAJOR finding is closed.
- The chart-bridge reduction diary is up to iter-174.
- No other edits.
