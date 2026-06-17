# Blueprint-writer directive — slug `g0bo-pin-scaffolds`

## Target chapter

`blueprint/src/chapters/AbelianVarietyRigidity.tex` (consolidated chapter; covers `AbelianVarietyRigidity.lean`, `Genus0BaseObjects.lean`, `RigidityLemma.lean` via `% archon:covers`).

## Why

iter-172 lean-vs-blueprint-checker `g0bo172` flagged as a **MAJOR** finding: the iter-171 body-skeleton of `gmScalingP1` factored out three named top-level scaffold sorries in `Genus0BaseObjects.lean`:

- `gmScalingP1_chart kbar i : (gmScalingP1_cover kbar).X i ⟶ ProjectiveLineBar kbar` (L847)
- `gmScalingP1_chart_agreement` (L861) — the cocycle on overlap charts
- `gmScalingP1_over_coherence` (L877) — the `Over`-side coherence equation

These are named in the chapter's NOTE comments around `def:gaTranslationP1` (~L1210–L1221), but they **lack individual `\lean{...}` pins**. As a result, `sync_leanok` cannot track them, and the iter-173 prover lane targeting them has no chapter anchor.

## Output requirements

- Edited `AbelianVarietyRigidity.tex` (write_domain).
- Add THREE new blocks immediately after `def:gaTranslationP1`:
  - `\begin{definition}[gmScalingP1 chart morphism] \label{def:gmscaling_chart} \lean{AlgebraicGeometry.gmScalingP1_chart} ...` with informal statement matching the Lean signature exactly: `gmScalingP1_chart kbar i : (gmScalingP1_cover kbar).X i ⟶ ProjectiveLineBar kbar` for each chart `i : Fin 2`. Include a proof-sketch block referencing the analogist's `analogies/chart-bridge.md` (iter-173 in flight) for the recipe.
  - `\begin{lemma}[gmScalingP1 chart agreement] \label{lem:gmscaling_chart_agreement} \lean{AlgebraicGeometry.gmScalingP1_chart_agreement} ...` with the cocycle equation in informal notation (on overlap `D₊(X_0 · X_1)`).
  - `\begin{lemma}[gmScalingP1 over coherence] \label{lem:gmscaling_over_coherence} \lean{AlgebraicGeometry.gmScalingP1_over_coherence} ...` with the `Over`-side coherence equation.
- Each block carries a `\uses{...}` graph reflecting the dependency (`def:proj_chart_ring_iso`, `def:projlinebar_affine_cover`, `def:gm`, etc.).
- **Optional** additional `\lean{...}` pins per the iter-172 lean-vs-blueprint-checker `g0bo172` minor findings:
  - `\lean{AlgebraicGeometry.gmScalingP1_chart0_ringMap}` and `\lean{AlgebraicGeometry.gmScalingP1_chart1_ringMap}` (the two chart-side ring maps; axiom-clean iter-171).
  - `\lean{AlgebraicGeometry.gmScalingP1_cover}` (the cover; axiom-clean iter-171).
  - `\lean{AlgebraicGeometry.projectiveLineBar_isProper}` (substantive axiom-clean proof; promoted from helper to pin).
  These are nice-to-have, not required this iter; add them if it does not balloon the chapter.

## Constraints

- Stay within the existing chapter; do not split the chapter or change its `% archon:covers` line.
- **NEVER** add `\leanok` or `\mathlibok` markers.
- Each block: include the `\lean{...}` pin pointing at the exact Lean declaration name.
- Source citations: NONE required for these blocks (they are project-bespoke scaffolds, not external claims).

## Verification step

After writing, re-read the chapter and verify the three new pins resolve to existing Lean declarations:

- `AlgebraicGeometry.gmScalingP1_chart` at `AlgebraicJacobian/Genus0BaseObjects.lean:847`.
- `AlgebraicGeometry.gmScalingP1_chart_agreement` at `AlgebraicJacobian/Genus0BaseObjects.lean:861`.
- `AlgebraicGeometry.gmScalingP1_over_coherence` at `AlgebraicJacobian/Genus0BaseObjects.lean:877`.
