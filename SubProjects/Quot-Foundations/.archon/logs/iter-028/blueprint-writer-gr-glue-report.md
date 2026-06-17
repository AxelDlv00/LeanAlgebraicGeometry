# Blueprint Writer Report

## Slug
gr-glue

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex

## Changes Made

### Task 1 — coverage-debt blocks (new `\section{Scheme-level glue-data layer}`)
Inserted a new section after `lem:gr_cocycle` and before `\section{The glued
Grassmannian scheme}`, with three sub-blocks: Mathlib inputs, charts/overlaps,
and the away-pullback iso. All 11 Lean decls now have a blueprint block.

**Mathlib dependency anchors authored (`\mathlibok`, verified to exist via `lean_verify`):**
- **Added lemma** `lem:mathlib_specMap_localizationAway_isOpenImmersion` / `\lean{AlgebraicGeometry.Scheme.isOpenImmersion_SpecMap_localizationAway}` — Spec of an away-localisation is an open immersion. (The project instance `chartIncl_isOpenImmersion` resolves this by inference; I cited the stable *named* Mathlib instance rather than the auto-generated `instIsOpenImmersionMapOfHomAwayAlgebraMap`, both prove the identical statement.)
- **Added lemma** `lem:mathlib_pullbackSpecIso` / `\lean{AlgebraicGeometry.pullbackSpecIso}` — pullback of two affine spectra is Spec of the tensor product.
- **Added lemma** `lem:mathlib_isLocalization_away_mul` / `\lean{IsLocalization.Away.mul'}` — `R[1/x] ⊗_R R[1/y]` is a localisation away from `xy`.
- **Added lemma** `lem:mathlib_isLocalization_algEquiv` / `\lean{IsLocalization.algEquiv}` — two localisations at the same submonoid are canonically isomorphic.

**Project bridge blocks (the 11 lean_aux decls):**
- **Added theorem** `lem:gr_minorDet_self` / `\lean{...minorDet_self}` — `P^I_I = 1`. `\uses{def:gr_minor_det, lem:gr_universalMatrix_submatrix_self}`. Proof sketch: Y.
- **Added definition** `def:gr_chart_overlap` / `\lean{...chartOverlap}` — `U^I_J = Spec R^I[1/P^I_J]`. `\uses{def:gr_minor_det, def:gr_affine_chart}`.
- **Added definition** `def:gr_chart_incl` / `\lean{...chartIncl}` — inclusion `U^I_J → U^I = Spec` of the structure map. `\uses{def:gr_chart_overlap, def:gr_affine_chart}`.
- **Added lemma** `lem:gr_chartIncl_isOpenImmersion` / `\lean{...chartIncl_isOpenImmersion}` — it is an open immersion. `\uses{def:gr_chart_incl, lem:mathlib_specMap_localizationAway_isOpenImmersion}`. Proof sketch: Y.
- **Added lemma** `lem:gr_chartIncl_self_isIso` / `\lean{...chartIncl_self_isIso}` — `IsIso (chartIncl I I)` (f_id field). `\uses{def:gr_chart_incl, lem:gr_minorDet_self}`. Proof sketch: Y (localisation at the unit `P^I_I=1`).
- **Added definition** `def:gr_chart_transition` / `\lean{...chartTransition}` — t-field `U^I_J → U^J_I = Spec θ_{I,J}`. `\uses{def:gr_transition, def:gr_chart_overlap}`.
- **Added lemma** `lem:gr_chartTransition_self` / `\lean{...chartTransition_self}` — t_id field, `= 𝟙`. `\uses{def:gr_chart_transition, lem:gr_transition_self}`. Proof sketch: Y.
- **Added definition** `def:gr_away_pullback_iso` / `\lean{...awayPullbackIso}` — linchpin: `pullback(Spec A[1/x] → Spec A ← Spec A[1/y]) ≅ Spec A[1/(xy)]`. `\uses{lem:mathlib_pullbackSpecIso, lem:mathlib_isLocalization_away_mul, lem:mathlib_isLocalization_algEquiv}`.
- **Added lemma** `lem:gr_awayPullbackIso_inv_fst` / `\lean{...awayPullbackIso_inv_fst}` — left leg = `Spec awayInclLeft`. `\uses{def:gr_away_pullback_iso, def:gr_away_incl_left}`. Proof sketch: Y.
- **Added lemma** `lem:gr_awayPullbackIso_inv_snd` / `\lean{...awayPullbackIso_inv_snd}` — right leg = `Spec awayInclRight`. `\uses{def:gr_away_pullback_iso, def:gr_away_incl_right}`. Proof sketch: Y.
- **Added definition** `def:gr_away_mul_comm_equiv` / `\lean{...awayMulCommEquiv}` — order-swap iso `A[1/(xy)] ≅ A[1/(yx)]`. `\uses{lem:mathlib_isLocalization_algEquiv}`.

### Task 2 — `def:gr_glued_scheme` made prover-ready
- **Revised** `def:gr_glued_scheme` — extended `\uses{}` to add all 11 new helper labels plus `def:gr_cocycle_theta_ij` (kept existing `def:gr_affine_chart, def:gr_transition, lem:gr_cocycle`). KEPT the Nitsure `% SOURCE`/`% SOURCE QUOTE` block and the smoothness paragraph unchanged.
- Added a *Construction of the glue datum* paragraph between the gluing paragraph and the smoothness paragraph: names the Mathlib vehicle (`Scheme.GlueData`), the index set `J = {I : #I = d}`, the object/overlap/`f`/`f_id`/`t`/`t_id` field assignments, the `t'` cocycle field as the `awayPullbackIso`→`Spec cocycleΘIJ`→`Spec awayMulCommEquiv`→inverse-`awayPullbackIso` composite (with the order-swap rationale), the `t_fac` reduction via the leg lemmas + Spec-faithfulness + away universal property, the `cocycle` reduction to `lem:gr_cocycle` modulo order-swaps, and `Gr(r,d) := (glue datum).glued`.

## Cross-references introduced
- New intra-chapter `\uses{}` edges among the 11 new blocks and the four new Mathlib anchors — all resolve (leandag `unknown_uses: []`).
- `def:gr_glued_scheme \uses{... def:gr_cocycle_theta_ij}` — `def:gr_cocycle_theta_ij` exists in this same chapter (verified).
- All `\cref{}`s in the new prose point at real labels in this chapter.

## leandag verification
- `leandag build --json`: `unknown_uses: []`; all 11 target decls removed from `unmatched_lean` (`lean_aux_nodes` 11→4 project-wide; the 4 remaining isolated/aux nodes are in other chapters).
- `leandag query --isolated --chapter Picard_GrassmannianCells`: **0 results** (no isolated nodes introduced).
- LaTeX balance: 85 `\begin` = 85 `\end` for def/lem/thm/proof envs. 8 `\mathlibok` total (4 pre-existing + 4 new). No `\leanok` added.

## References consulted
None for the new blocks — Task 1 blocks are Archon-original project-bespoke bridge lemmas (no external `% SOURCE`), and the Mathlib anchors are cited by their `\lean{}` target (verified existent), not by a `references/` file. The pre-existing Nitsure `% SOURCE QUOTE` in `def:gr_glued_scheme` was left untouched (not re-derived).

## Macros needed (if any)
None. All commands used (`\Spec`, `\binom`, `\cref`, `\mathrm`, `\emph`, `\otimes`) are already in use in this chapter. `\mathtt` is standard LaTeX. No new shared macro required.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The four new Mathlib anchors were each confirmed to exist via `lean_verify` (axioms only: propext/Classical.choice/Quot.sound). For the open-immersion anchor I cited the stable named instance `AlgebraicGeometry.Scheme.isOpenImmersion_SpecMap_localizationAway` rather than the auto-generated `instIsOpenImmersionMapOfHomAwayAlgebraMap` named in the directive — same statement, but the named form is not fragile to Mathlib regeneration. If a future prover wants leandag to match the *exact* instance the Lean `inferInstanceAs` resolves, the `\lean{}` could be repointed, but the current anchor is faithful and stable.
- `def:gr_glued_scheme` itself is still unproved in Lean (`AlgebraicGeometry.Grassmannian.scheme` — the `Scheme.GlueData` assembly is the next prover target); the construction paragraph is written to be that prover's spec. The four coherence fields (`t_fac`, `cocycle`) reference `IsLocalization.ringHom_ext` in prose only (no `\uses` anchor authored, as it was not in the directive's anchor list).

## Strategy-modifying findings
None.
