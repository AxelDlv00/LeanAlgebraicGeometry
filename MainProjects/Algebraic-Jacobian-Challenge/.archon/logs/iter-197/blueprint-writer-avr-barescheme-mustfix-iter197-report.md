# Blueprint Writer Report

## Slug
avr-barescheme-mustfix-iter197

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex` (consolidated chapter covering
`AbelianVarietyRigidity.lean` + `Genus0BaseObjects/BareScheme.lean` + ChartIso /
Points / GmScaling / RigidityLemma).

## Summary

Addressed both must-fix items + all four major items from the iter-196
lean-vs-blueprint-checker reports for `avr` and `barescheme`. The chapter now (i)
pins the iter-196 prover's identified missing intermediate
`Proj.basicOpenIsoSpec_inv_app_top` as a named lemma block, (ii) rewrites Step 1
of `lem:awayi_app_basicOpen`'s proof sketch to reference the landed
`Proj.awayι_eq_specMap_fromSpec` and chains Steps 2-4 through `fromSpec.app ⊤` +
`Spec.map.app` (avoiding the dependent-motive obstruction), (iii) expands
`lem:projectiveLineBar_geomIrred` with the 5-sub-helper recipe (A: Proj
base-change iso = Stacks 0BLW load-bearing piece, B-E: chain), and (iv) adds
`\lean{...}` blocks for the four substantive declarations missing blueprint
visibility (`Proj.awayι_preimage_basicOpen_self`, `Proj.awayι_eq_specMap_fromSpec`,
`projectiveLineBar_isProper`, `mvPolynomialFin_isStandardSmoothOfRelativeDimension`).
The `Smooth_iff_atOpens` loose hint was corrected to
`IsZariskiLocalAtSource.of_openCover`, and the per-chart smoothness gap (private
`projectiveLineBar_smooth_chart_aux` sorry) is documented with the recommended
relocation refactor.

## Items addressed

### Must-fix
- **M-1**: Added new lemma block `lem:basicOpenIsoSpec_inv_app_top` with `\lean{...}`
  pin (`AlgebraicGeometry.Proj.basicOpenIsoSpec_inv_app_top`) and explicit proof
  sketch (`Scheme.invApp` + `Proj.basicOpenIsoSpec_hom` +
  `Proj.basicOpenToSpec_app_top` chain, ~5-15 LOC). Inserted immediately before
  `lem:awayi_app_basicOpen`; the latter's `\uses{...}` now references the new
  helper.
- **M-2**: Rewrote Step 1 of `lem:awayi_app_basicOpen`'s proof sketch to use the
  iter-196 landed declaration `\cref{lem:awayi_eq_specMap_fromSpec}` (Lean
  `Proj.awayι_eq_specMap_fromSpec`) instead of the non-existent
  `Proj.awayι_eq_isoSpec_ι_comp`. Revised Steps 2-4 to chain through
  `IsAffineOpen.fromSpec.app ⊤` (via Mathlib's `IsAffineOpen.fromSpec_app_self`)
  followed by `Spec.map(basicOpenIsoAway.inv).app _` (via `Spec.map_appTop`).
  Added explicit prose noting that this route **avoids the dependent-motive
  obstruction** because both sides of the factorization keep the same
  `app`-codomain type (justified via `\cref{lem:awayi_preimage_basicOpen_self}`).
- **M-3**: Expanded `lem:projectiveLineBar_geomIrred`'s proof sketch (previously
  a brief informal mathematical argument) into a `\begin{proof}` block with the
  5-sub-helper recipe from the directive:
  - Sub-helper A: `Proj.baseChangeIso` (Stacks 0BLW, the load-bearing
    Mathlib gap; future Lean target ~100-200 LOC).
  - Sub-helper B: `homogeneousLocalizationAwayIso.baseChange` (chart-iso
    reparameterisation over an arbitrary field).
  - Sub-helpers C-D-E: base-changed graded ring is integral domain; Proj of
    integral graded domain is integral; assemble via Helper A.
  Sub-helpers A and B are `\lean{}`-pinned as future targets; C, D, E are
  un-pinned prose (per the directive). Total estimated closure cost documented as
  200-350 LOC; Helper A dominates.

### Major
- **J-1**: Added two new `\begin{lemma}` blocks with `\lean{...}` pins for the
  iter-196 landed primitives:
  - `lem:awayi_preimage_basicOpen_self` →
    `AlgebraicGeometry.Proj.awayι_preimage_basicOpen_self` (~5 LOC, axiom-clean
    preimage identity).
  - `lem:awayi_eq_specMap_fromSpec` →
    `AlgebraicGeometry.Proj.awayι_eq_specMap_fromSpec` (~10 LOC, axiom-clean
    bridge identity).
  Both inserted just before the Lane E recipe subsection and are now visible to
  sync_leanok and the next blueprint review.
- **J-2**: Added `lem:projectiveLineBar_isProper` block with `\lean{...}` pin
  (`AlgebraicGeometry.projectiveLineBar_isProper`) and brief proof sketch
  noting the `IsScalarTower`/`Algebra.FiniteType` chain + `Spec.map` iso
  composition.
- **J-3**: Added `lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension` block
  with `\lean{...}` pin and a numbered list documenting the 5-declaration
  `Algebra.SubmersivePresentation` chain (`mvPolyGenerators` →
  `mvPolyPresentation` → `mvPolyPreSubmersivePresentation` →
  `mvPolySubmersivePresentation` → final instance), with explicit notation that
  Mathlib `b80f227` does NOT ship the direct instance.
  `lem:projectiveLineBar_smoothOfRelDim`'s `\uses{...}` now points at the new
  substrate block.
- **J-4**: Added a "Per-chart substrate dependency" prose block + "Status
  (iter-196)" footnote to `lem:projectiveLineBar_smoothOfRelDim`. The footnote
  documents the per-chart aux private sorry, names the dependency on
  `homogeneousLocalizationAwayIso` (downstream `ChartIso.lean`), and explicitly
  cites the **recommended refactor**: relocate the smoothness instance to
  `ChartIso.lean` or a new `Genus0BaseObjects/Smooth.lean` (separate dispatch
  this iter, slug `barescheme-smoothness-relocation`).
- **J-5**: Corrected the Lean API name in `lem:projectiveLineBar_smoothOfRelDim`'s
  prose from `Smooth_iff_atOpens` to `IsZariskiLocalAtSource.of_openCover`,
  specialised to `SmoothOfRelativeDimension 1` via the
  `HasRingHomProperty ⇒ IsZariskiLocalAtSource` chain (matching the Lean code at
  `BareScheme.lean:338`). Also names the per-chart reduction chain
  (`HasRingHomProperty.iff_of_isAffine` +
  `RingHom.locally_of isStandardSmoothOfRelativeDimension_respectsIso`).

## Cross-references introduced
- `\uses{lem:basicOpenIsoSpec_inv_app_top}` added to `lem:awayi_app_basicOpen` —
  the new helper is now a documented dependency of the section-level port.
- `\uses{def:genus0_base_objects, lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension}`
  set on `lem:projectiveLineBar_smoothOfRelDim` — substrate dependency on the new
  Mathlib supplement block.
- `\cref{lem:awayi_eq_specMap_fromSpec}` and
  `\cref{lem:awayi_preimage_basicOpen_self}` introduced inside the proof of
  `lem:awayi_app_basicOpen` (Steps 1, 4).
- `\cref{lem:basicOpenIsoSpec_inv_app_top}` introduced inside the proof of
  `lem:awayi_app_basicOpen` (Step 2, as the parallel intermediate in the
  alternative `basicOpenIsoSpec.inv ≫ ι` route).

## References consulted
No new external references were opened this session — all edits ground in the
project's own iter-196 task reports and reviewer reports. Specifically:
- `.archon/task_results/lean-vs-blueprint-checker-avr.md` — full
  iter-196 review listing of must-fix (M-1) + 4 majors (J-1 through J-5) for
  the AVR chapter.
- `.archon/task_results/lean-vs-blueprint-checker-barescheme.md` — full
  iter-196 review listing of must-fix (M-3) + majors (J-2, J-3, J-4, J-5) for
  the BareScheme half of the consolidated chapter.
- `.archon/task_results/AlgebraicJacobian/AbelianVarietyRigidity.md` —
  iter-196 prover task report identifying `Proj.basicOpenIsoSpec_inv_app_top`
  as the missing intermediate (lines 65-72) and documenting the
  dependent-motive blocker (lines 50-64).
- `.archon/task_results/AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean.md` —
  iter-196 prover task report on the 5-declaration MvPolynomial substrate chain
  and the smoothness/geomIrred gap.

No `% SOURCE QUOTE` or `% SOURCE QUOTE PROOF` block was added (all new lemma
blocks are project-bespoke Mathlib supplements or named structural
intermediates; the directive flagged Stacks tag 0BLW for Helper A of M-3 but
no local reference file covers it, so a `% SOURCE` line is **not** added — the
prose names the Stacks tag in text only, with no verbatim quote).

## Macros needed (if any)
None. The `\fatsemi` macro used in the new blocks is already locally `\providecommand`-ed at the top of the chapter.

## Reference-retriever dispatches (if any)
None dispatched. The Stacks 0BLW reference is named in prose only as a future
substrate target for Helper A of `lem:projectiveLineBar_geomIrred`; per the
directive ("Out of scope: the geomIrred Helper A `Proj.baseChangeIso` Lean
implementation — blueprint-side recipe only this iter"), no verbatim source
quote was required and no retriever was dispatched.

## Verification
- All `\begin{...}` / `\end{...}` environments balance per environment type
  (lemma 36/36, definition 13/13, theorem 1/1, proof 20/20, etc.).
- All five new labels resolve as parsed: `lem:basicOpenIsoSpec_inv_app_top`,
  `lem:awayi_preimage_basicOpen_self`, `lem:awayi_eq_specMap_fromSpec`,
  `lem:projectiveLineBar_isProper`, `lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension`.
- All `\cref{...}` / `\uses{...}` entries I introduced this session target the
  five new labels above, which all resolve.
- All `\lean{...}` pins I introduced this session map to:
  - LANDED axiom-clean (iter-196): `Proj.awayι_preimage_basicOpen_self`,
    `Proj.awayι_eq_specMap_fromSpec`, `projectiveLineBar_isProper`,
    `mvPolynomialFin_isStandardSmoothOfRelativeDimension`.
  - FUTURE target (iter-197+ prover): `Proj.basicOpenIsoSpec_inv_app_top`
    (the must-fix M-1 missing intermediate),
    `Proj.baseChangeIso` (Helper A of M-3, Stacks 0BLW project supplement),
    `homogeneousLocalizationAwayIso.baseChange` (Helper B of M-3).
- No `\leanok` or `\mathlibok` markers were added on any block — those are
  managed by sync_leanok / the review agent.
- No edits outside the assigned chapter
  `blueprint/src/chapters/AbelianVarietyRigidity.tex`.

## Notes for Plan Agent
- The new helper `lem:basicOpenIsoSpec_inv_app_top` is positioned as a parallel
  intermediate (carrying the same content the iter-196 prover identified)
  rather than a strict prerequisite of the new fromSpec-route Step 1-4 proof
  sketch. The `\uses{lem:basicOpenIsoSpec_inv_app_top}` on
  `lem:awayi_app_basicOpen` is the discipline check the directive's Verification
  section explicitly asks for; the prove agent may choose either route
  (basicOpenIsoSpec.inv route via the helper, or the fromSpec-route via
  `lem:awayi_eq_specMap_fromSpec`) when closing the section-level port.
- The per-chart smoothness gap (Lean private
  `projectiveLineBar_smooth_chart_aux`) is now blueprint-side documented as
  resolvable by the separate refactor dispatch
  `barescheme-smoothness-relocation` (mentioned in J-4). The blueprint side is
  ready; the refactor + ~10 LOC prover close should yield an axiom-clean
  `projectiveLineBar_smoothOfRelDim` instance next iter.
- The `\uses{def:genus0_base_objects, lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension}`
  edit on `lem:projectiveLineBar_smoothOfRelDim` makes the dependency on the
  MvPolynomial substrate chain visible in the dependency graph — useful for
  blueprint-doctor and future reviewers.
- I noticed (informational, not a strategy issue) that
  `lem:projectiveLineBar_isProper` corresponds to a Lean instance that has been
  axiom-clean since iter-165 — its absence from the blueprint was a pure
  documentation gap, not a substrate gap. The block is now in place.

## Strategy-modifying findings
None. All edits stay within the consolidated AVR + BareScheme chapter and
implement the directive's specifications. No strategy-level inconsistency
surfaced during this writing session — the chapter's strategy (genus-0 base
case via the `\mathbb G_m`-scaling shortcut, with the Lane E `Proj.appIso`
evaluation chain as the bottleneck) is unchanged.
