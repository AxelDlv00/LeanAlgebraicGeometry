# Blueprint Writer Report

## Slug
g0bo-pins-iter169

## Status
COMPLETE — all four `\lean{...}` pin blocks requested by the directive are added; no markers introduced; existing chapter content untouched.

## Target chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Changes Made

Added a new `\subsection*{Chart cover and chart-ring iso (formalisation infrastructure)}` between `def:gm_grpObj` and `def:gaTranslationP1` (i.e., it sits inside the existing `\section{The genus-$0$ base objects and the $\mathbb G_m$-scaling action (the primary route)}`, right after the genus-$0$ base objects + their $\bar k$-points + the group-object structures, and before the scaling action $\sigma_\times$ itself). The subsection opens with a short orienting paragraph and contains four new blocks:

- **Added definition** `\definition`/`\label{def:projlinebar_affine_cover}`/`\lean{AlgebraicGeometry.projectiveLineBarAffineCover}` — two-chart affine open cover of $\overline{\mathbb P^1}$ via $D_+(X_0)$, $D_+(X_1)$, built by specialising `Proj.affineOpenCoverOfIrrelevantLESpan` to $\iota = \mathrm{Fin}\,2$, $f = (X_0, X_1)$, $m = (1, 1)$. Prose explains the irrelevant-ideal containment input. Uses `def:genus0_base_objects`.

- **Added definition** `\definition`/`\label{def:proj_chart_ring_iso}`/`\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso}` — the chart-ring iso $\mathrm{Away}\,\mathcal A\,X_i \cong \bar k[u]$ for $i \in \{0, 1\}$, with $u = X_{1-i}/X_i$. Prose explains both directions (forward via `Localization.awayLift`, inverse via the universal property of `MvPolynomial Unit`) and packaging via `RingEquiv.ofRingHom`. Includes the required `% NOTE (iter-169):` LaTeX comment flagging that the reverse round-trip is currently a scaffold `sorry` so the iso ships sorry-tainted until that residual closes; forward round-trip is axiom-clean. Uses `def:projlinebar_affine_cover`.

- **Added lemma** `\lemma`/`\label{lem:proj_chart_ring_iso_aux_left}`/`\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left}` — the residual reverse round-trip $\mathrm{inverse} \circ \mathrm{forward} = \mathrm{id}$ that the chart-ring iso of `def:proj_chart_ring_iso` depends on. Prose flags the analogist's recommended "cancel surjective" closure path (image of inverse = `Algebra.adjoin` of localised generator = $\top$ by `Away.adjoin_mk_prod_pow_eq_top` with $d=1$, $v=(X_0, X_1)$, $dv=(1, 1)$). Uses `def:proj_chart_ring_iso`.

- **Added lemma** `\lemma`/`\label{lem:projlinebar_isReduced}`/`\lean{AlgebraicGeometry.projectiveLineBar_isReduced}` — $\overline{\mathbb P^1}$ is reduced. Prose follows the Lean proof's actual route: chart cover → each chart ring is a domain (via the canonical `val`-injection of `HomogeneousLocalization.Away` into the ordinary polynomial localization $\bar k[X_0, X_1][X_i^{-1}]$, which is a localization of a polynomial ring at a non-zero-divisor) → reduced. Uses `def:projlinebar_affine_cover` only (the `def:proj_chart_ring_iso` is NOT in the `\uses{}` because the Lean proof goes through `val_injective`, not the iso).

### Placement choice
Within the existing `\section{The genus-$0$ base objects and the $\mathbb G_m$-scaling action (the primary route)}`, immediately after `def:gm_grpObj` and immediately before `def:gaTranslationP1`. Rationale: these are formalisation infrastructure for the chartwise construction of $\sigma_\times$, so they naturally sit between the base-object/group-structure pins and the action that consumes them.

### Subsection title
`\subsection*{Chart cover and chart-ring iso (formalisation infrastructure)}` — starred so it does not appear in the chapter ToC (these are auxiliary formalisation pins, not narrative landmarks).

## Cross-references introduced
- `def:projlinebar_affine_cover` → `\uses{def:genus0_base_objects}` — verified present in this chapter.
- `def:proj_chart_ring_iso` → `\uses{def:projlinebar_affine_cover}` — newly introduced, in this chapter.
- `lem:proj_chart_ring_iso_aux_left` → `\uses{def:proj_chart_ring_iso}` — newly introduced, in this chapter.
- `lem:projlinebar_isReduced` → `\uses{def:projlinebar_affine_cover}` — newly introduced, in this chapter.

## References consulted
None — all four new blocks are Archon-original Lean encodings of textbook-standard facts (two affine charts of $\mathbb P^1$, identification of the chart ring with $\bar k[u]$, reducedness of $\mathbb P^1$). The directive explicitly stated no external source was named; per the citation-discipline rule, the `% SOURCE QUOTE` / `\textit{Source: \ldots}` lines are omitted and each block stands on its proof sketch alone. The placeholder `% Archon-original \ldots` comments are present in the standard form used by the existing sibling blocks (`def:ga`, `def:gm`, `def:p1bar_zero`, etc.).

## Macros needed (if any)
None. The new blocks use only existing macros and standard environments. The local `\providecommand{\fatsemi}` is not used by any new block (the new content uses `\mathrm{val}`, `\mathrm{Algebra.adjoin}`, etc., not diagrammatic composition).

## Reference-retriever dispatches (if any)
None — no external sources needed.

## Verification

Re-read the new content and confirmed:
- Each new `\lean{...}` pin targets exactly one Lean declaration with the fully qualified `AlgebraicGeometry.` namespace (matching the file's `namespace AlgebraicGeometry` at L67 of `Genus0BaseObjects.lean`).
- Each block has a `\label{...}` (`def:projlinebar_affine_cover`, `def:proj_chart_ring_iso`, `lem:proj_chart_ring_iso_aux_left`, `lem:projlinebar_isReduced`), consistent with chapter conventions (lowercase, kebab-style, type-prefixed).
- No `\leanok` or `\mathlibok` added to the new blocks — confirmed by spot-checking `grep -n '\\leanok\|\\mathlibok'` against the four label ranges (lines ~1060–1148): none of those line numbers appear in the marker grep output.
- Environment balance preserved across the file (post-edit counts via grep): `definition` 12/12, `lemma` 15/15, `theorem` 1/1, `proof` 16/16, `proposition` 2/2, `remark` 6/6. The new content added 1 definition + 2 lemmas; the pre-edit chapter had 11 definitions + 13 lemmas (verified by inspection of which lines hold the new blocks).
- No existing block was deleted or moved; the four directive-listed already-correct pins (`def:genus0_base_objects`, `def:gaTranslationP1`, `lem:gmScaling_fixes_zero`, the ℙ¹-point pins) are untouched.
- The `% NOTE (iter-169):` comment on `def:proj_chart_ring_iso` flagging the iso's sorry-tainted status is in place (the directive's specific request).

## Notes for Plan Agent

1. **Out-of-scope Lean docstring staleness flagged by lean-vs-blueprint-checker `g0bo-iter168`**: two stale `.lean` docstrings in `AlgebraicJacobian/Genus0BaseObjects.lean` — (i) `projectiveLineBar_isReduced` at L708–718 still says "Project-side scaffold sorry (Mathlib does not ship `IsReduced (Proj 𝒜)`…)" even though the body is now genuinely proven axiom-clean, and (ii) the section-(E) header docstring at L680–696 still lists `ℙ¹ is reduced — scaffold` among the "Mathlib gap" justifications. These are Lean-side edits and out of my write-domain; the iter-169 prover lane's hygiene pass should refresh them.

2. **Minor narrative-flow consideration**: the new subsection sits inside the existing `\section{The genus-$0$ base objects and the $\mathbb G_m$-scaling action (the primary route)}`, which is now ~230 lines. If the plan agent wants tighter sectioning later (a separate `\section{Chart-level formalisation infrastructure for $\mathbb P^1$}`), the four new blocks are already grouped under a starred subsection and can be lifted into their own `\section{...}` without further refactoring. I left the `\subsection*` starred (omitted from ToC) since these are auxiliary pins, not narrative landmarks; the plan agent may unstar if it disagrees.

3. **`lem:projlinebar_isReduced` `\uses{}` choice**: I include only `def:projlinebar_affine_cover` (not `def:proj_chart_ring_iso`) because the Lean proof at L719 of `Genus0BaseObjects.lean` uses `Function.Injective.isDomain` on `HomogeneousLocalization.val_injective` directly, NOT the chart-ring iso. If a future Lean refactor routes the reducedness proof through the iso (e.g. once `aux_left` closes), the `\uses{}` should be extended; flagging here so the dependency graph stays accurate.

4. **No `% SOURCE:` blocks added**: per the directive ("…the directive does not name an external source for this block: the source lines are omitted — the block stands on the proof sketch alone"), all four new blocks use only the `% Archon-original Lean encoding…` comment pattern that the existing sibling blocks (`def:ga`, `def:gm`, `def:p1bar_zero`, `def:gm_grpObj`, etc.) already use. No citations were fabricated.

## Strategy-modifying findings

None. The new pins document iter-168 infrastructure that the existing strategy already anticipates (the iter-167 NOTE on `prop:morphism_P1_to_AV_constant`'s proof at L1444–1458 explicitly listed `projectiveLineBarAffineCover` and `homogeneousLocalizationAwayIso` as iter-168 deliverables awaiting blueprint pinning); this writer round closes that documentation gap without surfacing any conflict between the prose and the Lean.
