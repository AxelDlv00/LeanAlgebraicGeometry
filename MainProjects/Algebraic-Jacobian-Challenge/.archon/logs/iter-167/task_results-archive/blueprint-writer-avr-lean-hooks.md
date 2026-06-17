# Blueprint Writer Report

## Slug
avr-lean-hooks

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made

### Edit 1 — per-decl `\lean{...}` pins for the genus-0 base objects

Implemented **option A** of the directive: kept the bundled `def:genus0_base_objects` block
intact for narrative framing, and added 8 sibling `\begin{definition}...\end{definition}` blocks
immediately below it (between `def:genus0_base_objects` and `def:gaTranslationP1`), one per
Lean declaration that needed its own pin. The bundle continues to pin
`AlgebraicGeometry.ProjectiveLineBar`; the new sibling blocks pin the remaining 8 decls.

Also promoted three "[expected]" annotations to real status (the matching Lean names are now
landed in `AlgebraicJacobian/Genus0BaseObjects.lean`):

- L913 `\texttt{ProjectiveLineBar} [expected]` → `\texttt{ProjectiveLineBar}` (already pinned in bundle).
- L929 `\texttt{Ga} [expected]` → `\texttt{Ga}`.
- L934 `\texttt{Gm} [expected]` → `\texttt{Gm}`.
- L957 `(\lean name \texttt{gmScalingP1} [expected])` → `(\lean name \texttt{gmScalingP1})`.
- L950-953 NOTE block updated to reflect iter-165/166 landing of `gmScalingP1` and clarify that
  the `gaTranslationP1` "[expected]" is intentional (off-path, not yet a Lean target).

New sibling definition blocks added:

- **Added definition** `\label{def:ga}` / `\lean{AlgebraicGeometry.Ga}` — pins the additive
  group $\mathbb G_a$ over $\Spec \bar k$.
- **Added definition** `\label{def:gm}` / `\lean{AlgebraicGeometry.Gm}` — pins the
  multiplicative group $\mathbb G_m$ over $\Spec \bar k$.
- **Added definition** `\label{def:p1bar_zero}` / `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt}`
  — pins the $\bar k$-point $0 \in \mathbb P^1$.
- **Added definition** `\label{def:p1bar_one}` / `\lean{AlgebraicGeometry.ProjectiveLineBar.onePt}`
  — pins the $\bar k$-point $1 \in \mathbb P^1$.
- **Added definition** `\label{def:p1bar_infty}` / `\lean{AlgebraicGeometry.ProjectiveLineBar.inftyPt}`
  — pins the $\bar k$-point $\infty \in \mathbb P^1$.
- **Added definition** `\label{def:gm_one}` / `\lean{AlgebraicGeometry.Gm.onePt}` — pins the
  multiplicative identity $1 \in \mathbb G_m$.
- **Added definition** `\label{def:ga_grpObj}` / `\lean{AlgebraicGeometry.ga_grpObj}` — pins the
  additive `GrpObj` instance on $\mathbb G_a$.
- **Added definition** `\label{def:gm_grpObj}` / `\lean{AlgebraicGeometry.gm_grpObj}` — pins the
  multiplicative `GrpObj` instance on $\mathbb G_m$.

Each new block carries `\uses{def:genus0_base_objects}` (or `\uses{def:ga}` / `\uses{def:gm}`
for the group-object structures, to chain through the scheme-level definitions) so the
dependency graph routes correctly. The prose for each new block is a single sentence of
cross-reference; no new mathematics is introduced.

### Edit 2 — companion lemma for the σ_× fixed-point fact

Added the new lemma block immediately after `def:gaTranslationP1` (chapter L1098) and before
`lem:hom_Ga_to_av_trivial`:

- **Added lemma** `\label{lem:gmScaling_fixes_zero}` / `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}`
  — formal statement that the $\mathbb G_m$-scaling action fixes $0 \in \mathbb P^1$, i.e.
  $\sigma_\times(0, \lambda) = 0$ for every $\lambda$. Proof sketch is chart-level (Archon-
  original; no external citation block) and walks through the affine chart's polynomial map.

### Edit 3 — cross-reference in the consumer proposition

In `prop:morphism_P1_to_AV_constant` (chapter L1333-) the W-axis-collapse step at L1389-1391
now cites the new lemma:

- **Revised** proof body of `\label{prop:morphism_P1_to_AV_constant}` — inserted
  `(\cref{lem:gmScaling_fixes_zero})` at the W-axis collapse sentence.
- **Revised** `\uses{...}` of both the proposition statement block (L1339) and its proof block
  (L1361) to add `lem:gmScaling_fixes_zero`.

## Cross-references introduced

- 8 sibling definition blocks each carry `\uses{def:genus0_base_objects}` (or `\uses{def:ga}`
  / `\uses{def:gm}`) — all target labels exist in the same chapter.
- `\uses{def:genus0_base_objects, def:gaTranslationP1, def:p1bar_zero, def:gm_one}` on
  `lem:gmScaling_fixes_zero` statement (proof block uses the same minus the bundle).
- `\cref{lem:gmScaling_fixes_zero}` added in `prop:morphism_P1_to_AV_constant`'s proof body and
  added to the `\uses{...}` of both that proposition's statement and proof blocks.

All new labels (`def:ga`, `def:gm`, `def:p1bar_zero`, `def:p1bar_one`, `def:p1bar_infty`,
`def:gm_one`, `def:ga_grpObj`, `def:gm_grpObj`, `lem:gmScaling_fixes_zero`) follow the
project's naming convention and do not collide with any existing label (verified by grep).

## References consulted

None opened this session — the directive explicitly stated no new reference retrieval is
required ("they are Lean-side coverage hooks, not new mathematics"). All new blocks are
Archon-original (per-decl pins / Archon-original lemma statement); no external `% SOURCE
QUOTE` lines were written.

For the Lean-side verification I read:

- `AlgebraicJacobian/Genus0BaseObjects.lean` (declaration list around L78-L456) — to confirm
  each pinned name resolves to an actual Lean declaration: `ProjectiveLineBar`, `Ga`, `Gm`,
  `ProjectiveLineBar.{zeroPt,onePt,inftyPt}`, `Gm.onePt`, `ga_grpObj`, `gm_grpObj`,
  `gmScalingP1`, `gmScalingP1_collapse_at_zero` are all present (the last three with `sorry`
  bodies, which the directive explicitly permits — the pin tracks the declaration's
  existence, not the proof state).
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — confirmed `gaTranslationP1` is NOT a Lean
  declaration (no `def gaTranslationP1` anywhere), so its "[expected]" tag is intentionally
  retained.

## Macros needed (if any)

None. All new blocks use macros already in use in this chapter.

## Reference-retriever dispatches (if any)

None.

## Notes for Plan Agent

- The directive listed `lem:gmScaling_fixes_zero` as the new lemma label and the existing Lean
  declaration `AlgebraicGeometry.gmScalingP1_collapse_at_zero` as its hook. The Lean
  declaration is currently `sorry`-bodied (per `Genus0BaseObjects.lean` L452-456); the
  blueprint-doctor will not mark this `\leanok` until the body lands. The lemma statement is
  the load-bearing one for `prop:morphism_P1_to_AV_constant`'s W-axis collapse and is already
  wired into that proof.
- I did not split `def:gaTranslationP1` into `def:gmScalingP1` + `def:gaTranslationP1` (the
  directive's "out of scope"). If a future iter wants the scaling action pinned as its own
  block (rather than sharing the bundle with the demoted translation action), the cleanest
  refactor would be to split that bundle and update the `\cref{def:gaTranslationP1}` consumers
  throughout this chapter (~10 occurrences) plus the cross-chapter ones in `Jacobian.tex` and
  `RigidityKbar.tex`. Flagged for visibility only.
- The "[expected]" tag for `gaTranslationP1` is the only one left after this iter (intentional
  per the directive — off-path demoted decl, not yet a Lean target). If the demoted
  $\mathbb G_a$-additive route gets reactivated for some reason, this would be the trigger to
  land that Lean target and promote the tag.

## Strategy-modifying findings

None. The edits are purely Lean-coverage hookups; no strategy-level issue surfaced while
writing.
