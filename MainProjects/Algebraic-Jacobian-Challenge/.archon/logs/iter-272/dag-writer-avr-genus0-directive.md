# Blueprint Writer Directive

## Slug
avr-genus0

## Chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex`

This chapter already declares (line 4):
`% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean AlgebraicJacobian/Genus0BaseObjects.lean AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean AlgebraicJacobian/Genus0BaseObjects/Points.lean AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean AlgebraicJacobian/RigidityLemma.lean`

It already pins ~33 Genus0 declarations (Ga, Gm, ProjectiveLineBar, gmScaling*,
homogeneousLocalizationAwayIso*, etc.). **Do NOT touch or duplicate any block
that is already present.** Your job is purely ADDITIVE: add blueprint entries
for the currently-UNCOVERED helper declarations from the four Genus0BaseObjects
sub-files so the chapter reaches 1-to-1 Lean↔blueprint coverage.

## Task

Add a `\begin{definition}/\begin{lemma}` block (with `\label{}`, `\lean{}`,
accurate `\uses{}`, and a short informal proof) for each of the uncovered Lean
declarations listed below. **Before writing each block, grep the whole blueprint
(`blueprint/src/chapters/`) for the exact `\lean{}` name; if a block already
pins it anywhere, SKIP it** (a Lean decl may be pinned in exactly one block —
duplicate pins corrupt the DAG). Group the new blocks into clearly-titled
`\section`/`\subsection`s by sub-file so the chapter stays navigable.

For genuinely substantive declarations (real mathematical content), write a
proper statement + a few-line informal proof. For pure plumbing
(structure-projection helpers, `_apply`/`_eq` rewrite lemmas, instances,
round-trip components), a one-sentence statement + a one-line proof
("Direct computation; proved directly in Lean.") is correct and sufficient —
the block's purpose is to carry the dependency edge and satisfy 1-to-1 coverage.

Keep everything **mathematical prose, no Lean syntax** in statements/proofs
(the only Lean is the `\lean{}` annotation). Wire `\uses{}` to the dependencies
each decl actually needs (read the matched `.lean` declaration — you may read,
never edit Lean — to see what it invokes; pull from the already-pinned Genus0
blocks for the load-bearing dependencies).

## Uncovered declarations to cover (skip any already pinned)

### Points.lean (`AlgebraicJacobian/Genus0BaseObjects/Points.lean`)
GaScheme, GmRing, GmScheme, ProjectiveLineBar.evalIntoGlobal,
ProjectiveLineBar.irrelevant_map_eq_top, ProjectiveLineBar.pointOfVec,
gaScheme_canOver, ga_isAffineHom, ga_isReduced, ga_locallyOfFinitePresentation,
gmHomEquiv_homEquiv_comp, gmHomEquiv_invFun, gmHomEquiv_invFun_isOver,
gmHomEquiv_left_inv, gmHomEquiv_right_inv, gmHomEquiv_toFun, gmHomFunctor,
gmHomFunctor_representableBy, gmRing_isDomain, gmScheme_canOver,
gm_irreducibleSpace, gm_isAffine, gm_isReduced, gm_locallyOfFinitePresentation,
gm_smooth   (all under `AlgebraicGeometry.`)

### BareScheme.lean (`AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`)
ProjectiveLineBarScheme, algebraKbarAway, mvPolyGenerators,
mvPolyPreSubmersivePresentation, mvPolyPresentation, mvPolySubmersivePresentation,
projectiveLineBarAffineCover_fDeg, projectiveLineBarAffineCover_hm,
projectiveLineBarGrading, projectiveLineBarGrading_gradedRing,
projectiveLineBarScheme_canOver

### ChartIso.lean (`AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`)
chartEvalRingHom, chartEvalRingHom_C, chartEvalRingHom_X_other,
chartEvalRingHom_X_self, homogeneousLocalizationAwayIso_aux_right,
homogeneousLocalizationAwayToMvPoly, kbarToAwayRingHom,
mvPolyToHomogeneousLocalizationAway, otherFin, otherFin_ne, otherFin_one,
otherFin_zero, projectiveLineBar_smooth_chart_X, projectiveLineBar_smooth_chart_aux

### GmScaling.lean (`AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`)
affineLine_geomIrred, awayι_comp_PLB_hom, gmScalingP1_chart0_ringMap,
gmScalingP1_chart1_ringMap, gmScalingP1_chart_agreement_cross01 (has sorry —
state it, give an informal proof sketch, do NOT mark done), gmScalingP1_cover_X_iso,
gmScalingP1_cover_intersection_X_iso, isDomain_mvPolyUnit_tensor

## Content guidance (from the blueprint-reviewer's per-file outlines, iter-272)

- **Points**: the substantive ones are `GaScheme`/`Ga` (additive group
  `𝔾_a = AffineSpace (Fin 1) (Spec k̄)`), `GmRing` (`k̄[t,t⁻¹]=Localization.Away (X ())`),
  `GmScheme`/`Gm` (`Spec` of GmRing), `gm_grpObj` (already pinned), `gm_smooth`
  (smooth over `Spec k̄`, alg-closed), and the instance families `ga_*`/`gm_*`
  (affine, reduced, locally finite presentation, irreducible via `gmRing_isDomain`).
  `gmHomFunctor`/`gmHomEquiv_*`/`gmHomFunctor_representableBy` are the
  representability witness for `𝔾_m`: the functor `T ↦ Γ(T.left,⊤)ˣ` is
  represented by `Gm` via the `IsLocalization.Away` universal property; the
  `gmHomEquiv_*` are the components/round-trips of that bijection (plumbing —
  one-line entries). `pointOfVec`/`evalIntoGlobal`/`irrelevant_map_eq_top` are
  `ℙ¹`-point-construction helpers.
- **BareScheme**: `projectiveLineBarGrading` (the ℕ-grading
  `MvPolynomial.homogeneousSubmodule (Fin 2) k̄`), its `GradedRing` instance,
  `algebraKbarAway` (`k̄`-algebra on `HomogeneousLocalization.Away`),
  `ProjectiveLineBarScheme` (`= Proj 𝒜`), the `mvPoly*` standard-smooth
  presentation supplement, and the affine-cover witnesses (`_hm`, `_fDeg`).
- **ChartIso**: `homogeneousLocalizationAwayToMvPoly` /
  `mvPolyToHomogeneousLocalizationAway` (the two directions of the chart-ring
  iso `Away 𝒜 (Xᵢ) ≅ k̄[u]`), `chartEvalRingHom*` (the chart-i evaluation),
  `otherFin*` (the `Fin 2` "other index" combinatorics), and the chart
  smoothness helpers `projectiveLineBar_smooth_chart_*`.
- **GmScaling**: `gmScalingP1_chart{0,1}_ringMap` (per-chart scaling ring maps
  `u ↦ u⊗λ`, `t ↦ t⊗λ⁻¹`), the cover/intersection isos, `affineLine_geomIrred`,
  `isDomain_mvPolyUnit_tensor`, and the cross-01 agreement (sorry).

## References
- `references/abelian-varieties.md` (Milne) §I.2 (group schemes 𝔾_a/𝔾_m),
  §I.3 (rigidity Cor 1.5 — context for `gmScalingP1_collapse_at_zero`, already
  pinned). Use ONLY for context framing; these constructions are largely
  Archon-original / Mathlib-backed, so most blocks are Archon-original (no
  `% SOURCE:` block needed) — add the citation block only where you actually
  quote Milne. Do not fabricate citations.

## Scope boundary
- ADDITIVE only — do not modify, move, or re-pin any existing block.
- Do not edit the `% archon:covers` line.
- Do not touch any `\leanok` marker (deterministic sync owns it).
- Do not create new chapter files; everything goes into AbelianVarietyRigidity.tex.
- Out of scope: the AbelianVarietyRigidity.lean rigidity proper and RigidityLemma
  decls (already covered); the `\lean{}` name-mismatch fixes flagged by the
  reviewer (those are the review agent's domain).
