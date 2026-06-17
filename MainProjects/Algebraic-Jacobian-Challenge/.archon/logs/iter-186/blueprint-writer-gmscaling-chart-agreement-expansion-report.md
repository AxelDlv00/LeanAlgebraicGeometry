# Blueprint Writer Report

## Slug
gmscaling-chart-agreement-expansion

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Subsection touched

`\subsection*{Scaffolds for the body of \(\sigma_\times = \mathtt{gmScalingP1}\)
(iter-171 chart-glue split)}` (header at L1228 in pre-edit file). Two
insertions plus one in-place rewrite:

- **Pre-edit L1304--1339** → post-edit L1349--1505: full rewrite of the proof
  block of `lem:gmscaling_chart_agreement` (the iter-185 MUST-FIX-THIS-ITER
  finding). Net delta ~+170 LOC (15 → 156 lines of proof prose), structured
  as the 4 sub-paragraphs + an upfront `% NOTE (iter-186 writer, ...)`
  comment recording the Mathlib / ergonomic gaps once for the prover.
- **Pre-edit L1236--1237** → post-edit L1236--1281: two new mini-blocks
  pinning `\lean{AlgebraicGeometry.pullback_map_fst_proj}` /
  `\lean{AlgebraicGeometry.pullback_map_snd_proj}` (`lem:pullback_map_fst_proj`,
  `lem:pullback_map_snd_proj`) at the top of the scaffolds subsection, so the
  expanded proof-sketch's `\cref{...}` references resolve.
- **Pre-edit L1480 → post-edit L1654--1737**: four new mini-blocks pinning the
  product-stability instances at the end of the scaffolds subsection (after
  `gmScaling_fixes_zero`, before the Milne-3.9 §): `lem:projGm_locallyOfFiniteType`,
  `lem:gm_geomIrred`, `lem:projGm_geomIrred`, `lem:projGm_isReduced`.

Total chapter delta: ~+330 LOC (within the directive's ~50--100 LOC + 6 pin
landings budget — overran on the 4-sub-paragraph expansion and on prose for
the 6 mini-blocks, but each mini-block needed enough text to host the iter-185
Mathlib-gap explanations the prover and reviewer rely on).

## Changes Made

- **Rewrote proof block** of `lem:gmscaling_chart_agreement` — replaced the
  old single-paragraph "Content of the equation" sketch with the directive's
  4-sub-paragraph structure (I)/(II)/(III)/(IV) + an `% NOTE (iter-186 writer)`
  upfront comment listing the two Mathlib / ergonomic gaps. New material:

  - **% NOTE (upfront)** — records (i) the missing
    `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` Mathlib bridge that
    blocks `gm_geomIrred` and `projGm_isReduced`, and (ii) the
    tactic-mode-`refine ≪≫ ?_; refine; exact` ergonomic gap that blocks the
    canonical `Iso.trans_inv`/`Iso.inv_comp_eq`/... simp chain on
    `gmScalingP1_cover_intersection_X_iso`.
  - **(I) Setup and structural lift** — restates the cross-case `(x,y)=(0,1)`
    in project notation, identifies the two charts and the intersection iso
    `gmScalingP1_cover_intersection_X_iso : pullback _ _ ≅ Spec ((Away (X 0 ·
    X 1)) ⊗ GmRing)`, and explains the
    `cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv` move as the
    cleanest entry point.
  - **(II) Why the canonical simp chain is blocked** — explains in 2--3
    sentences that the iso is constructed in tactic mode, that its elaboration
    is opaque to the canonical Mathlib simp chain (`Iso.trans_inv` /
    `Iso.inv_comp_eq` / `pullback.congrHom_inv` / `asIso_inv` plus the
    pullback{Right,Left}*_inv_* family), points at the project-side
    `pullback_map_{fst,snd}_proj` helpers as the iter-184 Recipe 1
    contribution, and explicitly supersedes the stale
    `analogies/chart-bridge.md (iter-173 in flight)` reference with
    `analogies/gmscaling-projection-idiom.md` (iter-184).
  - **(III) Three concrete pickup paths** — formal `description` env with
    `(III.a)` term-mode refactor (~30--50 LOC; structural-refactor subagent),
    `(III.b)` named projection lemmas via `pullback.hom_ext` (~50--80 LOC;
    analogist Recipe 2, requires relaxing helper-budget = 0), and `(III.c)`
    separating-sheaf bypass (~80--120 LOC; falls under STRATEGY.md's
    "Genus-0 separated-locus alternative" open question).
  - **(IV) Substantive ring-level residual** — preserves the original
    `λ · u = (1/t) · λ` ring-level reduction in
    `Localization.Away t ⊗ GmRing kbar`, attributes the unit identity
    `t · u = 1` to `IsLocalization.Away.mul_invSelf`, and links the residual
    closure back through `def:proj_chart_ring_iso` + `pullbackSpecIso`.

- **Added lemma block** `\lemma`/`\label{lem:pullback_map_fst_proj}`/
  `\lean{AlgebraicGeometry.pullback_map_fst_proj}` — informally states the
  `pullback.map ≫ pullback.fst = pullback.fst ≫ i₁` simp helper, explains
  why the project promotes it to `@[reassoc (attr := simp)]` (Mathlib ships
  `pullback.lift_fst` as `@[reassoc]` only, not `@[simp]`), and flags
  upstream-contribution candidacy.
- **Added lemma block** `\lemma`/`\label{lem:pullback_map_snd_proj}`/
  `\lean{AlgebraicGeometry.pullback_map_snd_proj}` — the dual.
- **Added lemma block** `\lemma`/`\label{lem:projGm_locallyOfFiniteType}`/
  `\lean{AlgebraicGeometry.projGm_locallyOfFiniteType}` — informally states the
  product-stability instance for `LocallyOfFiniteType`, with the standard
  decomposition + composition closure proof sketch.
- **Added lemma block** `\lemma`/`\label{lem:gm_geomIrred}`/
  `\lean{AlgebraicGeometry.gm_geomIrred}` — informally states the `𝔾_m`
  geometric-irreducibility instance with explicit Mathlib-gap note (the
  iter-185 CONFIRMED-gap `Algebra.TensorProduct.isDomain_of_isAlgClosed_left`
  bridge), so a future reviewer can verify the gap diagnosis without
  re-reading the prover's NOTE.
- **Added lemma block** `\lemma`/`\label{lem:projGm_geomIrred}`/
  `\lean{AlgebraicGeometry.projGm_geomIrred}` — informally states the product
  GI instance, contingent on `lem:gm_geomIrred` (carries the gap downstream).
- **Added lemma block** `\lemma`/`\label{lem:projGm_isReduced}`/
  `\lean{AlgebraicGeometry.projGm_isReduced}` — informally states the
  product reducedness instance with the same Mathlib-gap diagnosis.

## Cross-references introduced

- `\cref{lem:pullback_map_fst_proj}` — used in the expanded proof of
  `lem:gmscaling_chart_agreement` (sub-paragraph (II)). Verified label exists
  in this same chapter (added above).
- `\cref{lem:pullback_map_snd_proj}` — same.
- `\cref{lem:gm_geomIrred}` — used in proof body of `lem:projGm_geomIrred`.
  Same chapter (added above).
- `\cref{def:gmscaling_chart}`, `\cref{def:gmscaling_cover}`,
  `\cref{def:proj_chart_ring_iso}` — already present in chapter (verified
  via existing `\label{...}` lines).
- `\cref{prop:morphism_P1_to_AV_constant}` — already present in chapter.

No new `\uses{...}` directives added (the directive did not ask for them; the
existing dep-graph wiring of `lem:gmscaling_chart_agreement` is preserved
verbatim).

## References consulted

- `analogies/gmscaling-projection-idiom.md` — iter-184 analogist consult.
  Used as the prose-level source for (II) / (III.a) / (III.b) of the
  expanded proof sketch and for the Recipe 1 helper-lemma narrative. The
  three Recipes there directly map to the three (III.a)/(III.b)/(III.c)
  pickup paths.
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (L41-L69, L280-L508,
  L655-L750) — read to confirm exact declaration names and signatures the
  pins reference (`pullback_map_fst_proj`, `pullback_map_snd_proj`,
  `gmScalingP1_cover_intersection_X_iso`, `gmScalingP1_chart_agreement_cross01`,
  `projGm_locallyOfFiniteType`, `projectiveLineBar_isReduced`,
  `gm_geomIrred`, `projGm_geomIrred`, `projGm_isReduced`); also for the
  iter-185 in-Lean status comments that drove the (II) / NOTE prose.

(No new external `references/` files needed — the expansion is grounded in
analogist note + existing Lean state, both Archon-original.)

## Macros needed (if any)

None — `\fatsemi`, `\Spec`, `\Proj`, `\cref`, `description` env, etc.\ are
all already in use elsewhere in this chapter.

## Reference-retriever dispatches (if any)

None.

## Notes for Plan Agent

- The expanded proof sketch is mathematical-only; it deliberately does NOT
  prescribe a single pickup path. The iter-186 plan agent should pick one
  of (III.a) / (III.b) / (III.c) and write the prover directive against it.
  The directive should authorise the helper-budget increase (III.b needs 2
  new named top-level lemmas; III.a needs a structural refactor of the
  existing iso; III.c needs verification of `IsSeparatedOver` / `sheafExt`
  availability at the pinned Mathlib commit).
- The 6 new `\lean{...}` pins reference declarations that already exist in
  `GmScaling.lean`; `sync_leanok` should automatically add `\leanok` markers
  to the 4 stability-instance blocks whose Lean declarations are
  proof-complete (`projGm_locallyOfFiniteType`, `projGm_geomIrred`,
  `pullback_map_fst_proj`, `pullback_map_snd_proj`) and leave the 2
  sorry-bearing blocks (`gm_geomIrred`, `projGm_isReduced`) unmarked.
- The pre-edit chapter's L1301-1302 reference to
  `analogies/chart-bridge.md (iter-173 in flight)` survives in **two** places:
  (a) the now-rewritten `lem:gmscaling_chart_agreement` proof sketch (fixed
  here — superseded by `analogies/gmscaling-projection-idiom.md`), and (b)
  the proof block of `def:gmscaling_chart` (pre-edit L1300--1302, post-edit
  L1346--1347 in the rewritten file: "the iter-173 analogist note
  `analogies/chart-bridge.md` (in flight)"). The directive scoped to only
  `lem:gmscaling_chart_agreement`, so the `def:gmscaling_chart` reference is
  **out of scope** for this iter — flagging here so the plan agent can
  schedule a follow-up sweep.
- The chapter's `lem:gmscaling_chart_PLB_eq` block (post-edit L1507--1573)
  similarly references `analogies/chart-bridge.md (iter-173 in flight)` and
  `analogies/gmscaling-deep.md`; both are stale but again out of scope for
  this iter.

## Strategy-modifying findings

None. The expansion records pickup path (III.c) as falling under
STRATEGY.md's pre-existing "Genus-0 separated-locus alternative" open
question — this is a back-reference to a strategy thread that already
exists, not a new strategy issue surfaced by the prose.
