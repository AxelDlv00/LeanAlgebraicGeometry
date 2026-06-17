# Blueprint Writer Report

## Slug
avr-genus0

## Status
COMPLETE — all 58 directive-listed uncovered Genus0BaseObjects declarations now have
1-to-1 blueprint blocks; no broken `\uses`, no isolated new nodes, begin/end balanced.

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Summary
Added one new top-level section, `\section{Genus-0 base-object helper declarations
(1-to-1 Lean coverage)}` (`\label{sec:genus0_helpers}`), appended at the end of the
chapter, with four `\subsection*`s by sub-file. It contains 58 new declaration blocks,
one per uncovered Lean declaration listed in the directive. Purely ADDITIVE: no existing
block was modified, moved, re-pinned, or had its markers touched; the `% archon:covers`
line was not edited.

Before writing, I grepped the whole `blueprint/src/chapters/` for every target `\lean{}`
name: all 58 were uncovered (none pre-pinned), so none was skipped. Post-write, each of
the 58 is pinned exactly once across all chapters (no duplicate pins / DAG corruption).

Substantive declarations got a real statement + a few-line informal proof; pure plumbing
(instances, `_apply`/`_eq` rewrites, round-trip components, projection helpers) got a
one-sentence statement + a one-line "Proved directly in Lean." proof, carrying the
dependency edge. All blocks are mathematical prose (the only Lean is the `\lean{}` hook).
All are Archon-original or directly Mathlib-backed — no external source is quoted, so no
`% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source:}` blocks were written (consistent with
the directive: "add the citation block only where you actually quote Milne").

## Changes Made (by sub-file)

### BareScheme.lean (11 blocks)
- `def:plb_grading` ← `projectiveLineBarGrading` (standard ℕ-grading on k̄[X₀,X₁])
- `lem:plb_grading_gradedRing` ← `projectiveLineBarGrading_gradedRing`
- `def:algebra_kbar_away` ← `algebraKbarAway`
- `def:plb_scheme` ← `ProjectiveLineBarScheme` (= Proj 𝒜)
- `lem:plb_scheme_canOver` ← `projectiveLineBarScheme_canOver`
- `def:mvpoly_generators` / `def:mvpoly_presentation` / `def:mvpoly_presubmersive` /
  `def:mvpoly_submersive` ← the `mvPoly*` standard-smooth presentation supplement chain
- `lem:plb_cover_fDeg` ← `projectiveLineBarAffineCover_fDeg`
- `lem:plb_cover_hm` ← `projectiveLineBarAffineCover_hm`

### ChartIso.lean (14 blocks)
- `def:otherFin` + `lem:otherFin_zero` / `lem:otherFin_one` / `lem:otherFin_ne`
- `def:chartEvalRingHom` + `lem:chartEvalRingHom_X_self` / `_X_other` / `_C`
- `def:hlaway_to_mvpoly` ← `homogeneousLocalizationAwayToMvPoly` (forward chart-ring map)
- `def:kbarToAwayRingHom` ← `kbarToAwayRingHom`
- `def:mvpoly_to_hlaway` ← `mvPolyToHomogeneousLocalizationAway` (inverse chart-ring map)
- `lem:hlaway_iso_aux_right` ← `homogeneousLocalizationAwayIso_aux_right` (right round-trip;
  complements the already-pinned `_aux_left`)
- `lem:plb_smooth_chart_X` / `lem:plb_smooth_chart_aux` ← the per-chart smoothness helpers

### Points.lean (25 blocks)
- `def:plb_evalIntoGlobal` / `lem:plb_irrelevant_map_eq_top` / `def:plb_pointOfVec` —
  the ℙ¹-point construction helpers
- `def:gaScheme` + `lem:gaScheme_canOver` / `lem:ga_isAffineHom` / `lem:ga_lofp` /
  `lem:ga_isReduced` — 𝔾_a scheme + instance family
- `def:gmRing` / `def:gmScheme` + `lem:gmScheme_canOver` / `lem:gm_isAffine` /
  `lem:gm_lofp` / `lem:gm_isReduced` / `lem:gmRing_isDomain` / `lem:gm_irreducibleSpace` /
  `lem:gm_smooth` — 𝔾_m scheme + instance family
- `def:gmHomFunctor` / `def:gmHomEquiv_toFun` / `lem:gmHomEquiv_invFun_isOver` /
  `def:gmHomEquiv_invFun` / `lem:gmHomEquiv_left_inv` / `lem:gmHomEquiv_right_inv` /
  `lem:gmHomEquiv_homEquiv_comp` / `def:gmHomFunctor_representableBy` — the 𝔾_m
  representability witness (the units functor T ↦ Γ(T,⊤)ˣ and its bijection components)

### GmScaling.lean (8 blocks)
- `lem:awayι_comp_PLB_hom` ← `awayι_comp_PLB_hom` (chart bridge)
- `def:gmscaling_chart0_ringMap` / `def:gmscaling_chart1_ringMap` (per-chart scaling ring maps)
- `def:gmscaling_cover_X_iso` ← `gmScalingP1_cover_X_iso`
- `def:gmscaling_cover_intersection_X_iso` ← `gmScalingP1_cover_intersection_X_iso`
- `lem:isDomain_mvPolyUnit_tensor` ← `isDomain_mvPolyUnit_tensor`
- `lem:affineLine_geomIrred` ← `affineLine_geomIrred`
- `lem:gmscaling_chart_agreement_cross01` ← `gmScalingP1_chart_agreement_cross01`
  **(carries a sorry in Lean)** — stated with the ring-level cocycle identity and an
  informal proof sketch; not marked done (no `\leanok` added — that is sync-owned anyway).

## Cross-references introduced
All `\uses{}` wired to existing pinned Genus0 blocks where load-bearing:
- `def:genus0_base_objects` (ProjectiveLineBar), `def:ga`, `def:gm`, `def:gm_grpObj`,
  `def:projlinebar_affine_cover`, `def:proj_chart_ring_iso`, `lem:proj_chart_ring_iso_aux_left`,
  `lem:chart_ring_iso_preserves_algebraMap`, `def:gmscaling_cover`, `def:gmscaling_chart`,
  `lem:gmscaling_chart_PLB_eq`, `lem:projlinebar_isReduced`,
  `lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension`, `lem:gm_geomIrred` — all
  verified present (label-count = 1 each).
- New blocks also chain to one another (grading → graded-ring/scheme/algebra;
  generators → presentation → presubmersive → submersive; otherFin → chartEval → forward
  map; toFun/invFun → round-trips → representableBy; isDomain → affineLine; etc.).

## Verification
- `comm` of target list vs. all-chapter `\lean{}` set: all 58 covered (empty diff).
- Duplicate-pin check: each of the 58 appears exactly once across `blueprint/src/chapters/`.
- `leandag build --json`: `unknown_uses = []` (no broken `\uses`); `conflicts = []`.
- `leandag show isolated`: none of the 58 new labels appears (checked full IDs and
  truncated stems) — every new node has at least one edge.
- begin/end environment balance in the chapter: 176/176.

## References consulted
None — all 58 blocks are Archon-original / Mathlib-backed plumbing and helper
constructions; no external source text was quoted, so no citation blocks were authored and
no `references/` file was opened for quoting. (I did read the four Lean sub-files —
`AlgebraicJacobian/Genus0BaseObjects/{Points,BareScheme,ChartIso,GmScaling}.lean` — to
read off each declaration's actual dependencies for `\uses{}`.)

## Macros needed (if any)
None new. The existing chapter-local `\fatsemi` (`\providecommand`) is reused in a few
proof sketches; no new macro is required.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The existing blocks `def:genus0_base_objects` (ProjectiveLineBar), `def:ga`, `def:gm`,
  `def:p1bar_zero/one/infty`, `def:gm_grpObj`, `def:projlinebar_affine_cover`, and
  `lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension` reference several of the
  newly-pinned helpers *in prose only* (no `\uses{}` to them, since the helpers were
  previously unpinned). The corresponding forward edges (e.g. ProjectiveLineBar `\uses`
  plb_grading/plb_scheme; the standard-smooth lemma `\uses` the mvPoly* chain; pointOfVec
  consumers `\uses` it) would tighten the DAG. I did not add them because that requires
  editing existing blocks (out of this additive directive's scope). A future
  reviewer/writer pass could add those backward `\uses{}` edges to those existing blocks.
- `lem:gmscaling_chart_agreement_cross01` is the one genuine residual sorry among the new
  set (all others are sorry-free in Lean); its block documents the missing Mathlib
  range-containment substrate for the diagonal factorization.

## Strategy-modifying findings
None — writing these helper blocks surfaced no strategy-level issue; they are faithful
1-to-1 records of existing Lean declarations supporting the already-committed genus-0 route.
