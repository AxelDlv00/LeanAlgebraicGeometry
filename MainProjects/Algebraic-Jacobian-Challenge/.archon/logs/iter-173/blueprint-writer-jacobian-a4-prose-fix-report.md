# Blueprint Writer Report

## Slug
jacobian-a4-prose-fix

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made

The three flagged A.4 paragraphs are now reconciled with the iter-172 audit verdict (outcome (b) — bypass FAILS). All three carry the same A.4 estimate ($\sim 2500{+}$ LOC, $\sim 22$--$35$ iters), the same dependency cascade (Thm 3.2 + Lemma 3.3 codim-$1$ extension + Weil-divisor API + Auslander--Buchsbaum), the same bypass-FAILS verdict, and the same audit citation (\cref{sec:Jacobian_routeA4_albaneseUP}, NOTE block + thm:albanese_universal_property proof).

- **Revised** `Mathlib status for Route A` A.4 bullet (was: L344; now L344, ~one paragraph expanded) — replaces the "Sub-step A.4 ... is not in Mathlib in this form. (~900--1200 LOC, ~7--11 iters)" prose with the bypass-FAILS verdict, the Thm 3.2 + Lemma 3.3 + Auslander–Buchsbaum sub-build, the updated $\sim 2500{+}$ LOC / $\sim 22$--$35$ iters estimate, and the iter-172 audit cross-reference.
- **Revised** per-sub-phase A.4 item (was: L384–L390; now L384–L409) — replaces the "Net new project material: ~900--1200 LOC. Iters: ~7--11. ... Reuses ... Char-free." block with the audit-aligned estimate ($\sim 2500{+}$ LOC, $\sim 22$--$35$ iters), the bypass-FAILS verdict, explicit naming of the Thm 3.2 reserved Lean target (\cref{lem:rational_map_to_av_extends}) inherited from \cref{chap:AbelianVarietyRigidity}, the Lemma 3.3 codim-$1$ Mathlib gap (\cref{rmk:thm32_codim1_mathlib_gap}), the symmetric-powers-of-schemes prerequisite shared with Route~B, and the audit cross-reference. Kept the existing Rigidity Lemma + Cor 1.2 + Cor 1.5 reuse paragraph (those are still in tree, axiom-clean) and the "Char-free" tag.
- **Revised** Mathlib-prerequisite cascade A.4 bullet (was: L425–L427; now L451–L462) — replaces the "no new Mathlib namespace; reuses AlgebraicJacobian.AbelianVarietyRigidity ... + Mathlib's Albanese-style universal property machinery" claim with the explicit prerequisite list (Thm 3.2, Lemma 3.3 codim-$1$, Weil-divisor API some shared with RR.1, Auslander–Buchsbaum absent from Mathlib), keeps the in-tree Rigidity Lemma reuse note, adds the symmetric-powers-of-schemes prerequisite shared with Route~B, states the bypass-FAILS verdict (autoduality detour → cube, cube excised iter-163), and adds the audit cross-reference.

Self-consistency repairs (necessary because changing the A.4 estimate makes the chapter-wide totals inconsistent):

- **Revised** Total Route A budget paragraph (L412–L423, was: $\sim 4400$--$6200$ LOC / $\sim 33$--$54$ iters) — recomputed from the per-sub-phase numbers ((A.1) + (A.2) + (A.3) + (A.4)) to $\sim 6000$--$7500{+}$ LOC / $\sim 48$--$78$ iters, naming the prior estimate as having under-counted A.4 and pointing at \cref{sec:Jacobian_routeA4_albaneseUP} for the explicit cause.
- **Revised** positiveGenusWitness proof (L717) — refreshed the in-line Route A budget recap to the new $\sim 6000$--$7500{+}$ LOC / $\sim 48$--$78$ iters total, with the A.4 sub-block break-out at $\sim 2500{+}$ LOC / $\sim 22$--$35$ iters; preserved the iter-123 audit midpoint cross-reference and the iter-170 refresh history for traceability.

Minor (per directive's free pickup):

- **Fixed** stale Lean line-number reference (L591, was: `AlgebraicJacobian/Jacobian.lean:120--126`) → `:134--140`. Verified directly against the Lean source: `geometricallyIrreducible_id_Spec` now sits at lines 134–140 of `AlgebraicJacobian/Jacobian.lean`.

## Cross-references introduced

No new `\uses{...}` cross-references added (the directive said do not change `\lean{...}` pins, theorem statements, or proof structure). The new prose cross-references already-existing labels:

- `\cref{sec:Jacobian_routeA4_albaneseUP}` — repeated in each A.4 paragraph, points at the existing audit section.
- `\cref{thm:albanese_universal_property}` — repeated in each A.4 paragraph, points at the existing theorem block whose proof body holds the audit findings.
- `\cref{lem:rational_map_to_av_extends}` — used in the per-sub-phase A.4 entry to name the Thm 3.2 reserved Lean target.
- `\cref{chap:AbelianVarietyRigidity}` — used in the per-sub-phase A.4 entry.
- `\cref{rmk:thm32_codim1_mathlib_gap}` — used in the per-sub-phase A.4 entry to point at the existing codim-$1$ Mathlib gap remark.

All five labels exist in the project's blueprint already (the audit at L574–L602 already cites them).

## References consulted

No new citation blocks were added — the edits revise pre-existing prose paragraphs (status / budget / cascade), none of which carries an external source citation. The audit's `% NOTE` block (L574–L602) and the `thm:albanese_universal_property` proof (L641–L656) were read in the chapter itself to align the three paragraphs with them; no `references/` files were opened this session.

## Macros needed (if any)

None.

## Reference-retriever dispatches (if any)

None.

## Notes for Plan Agent

- The chapter's "Total Route A budget" line (L412) now exceeds STRATEGY.md's `Iters left: ~40-70` envelope on the upper end ($\sim 48$--$78$). The chapter explicitly flags this and recommends the planner treat Route A as a multi-phase build with (A.2) Quot/Hilbert and (A.4) Thm 3.2 codim-$1$ as the dominant blocks. If STRATEGY.md still carries the `~40-70` envelope without acknowledging the A.4 re-estimate, that row should be refreshed for top-to-bottom consistency between the chapter and STRATEGY.md (the chapter A.4 line was changed to match STRATEGY's `~2500+ LOC` per the directive, but the chapter's Total Route A line and STRATEGY's Route A total may still drift).
- Line 691 of the chapter still contains the phrase `no new Mathlib namespace` — this is the audit explicitly quoting and refuting the stale STRATEGY claim ("The STRATEGY.md A.4 row claim ``no new Mathlib namespace'' is incorrect"), so it stays in quotation context. The directive's verification grep flagged this match; reading the surrounding sentence confirms it is the audit's rebuttal of the bad claim, not a re-assertion of it. No action needed.
- The `Iter-135 body restructure` paragraph at the end of `thm:nonempty_jacobianWitness`'s proof still says "M3 is committed to Route A per the iter-144 disposition in STRATEGY.md \S~M3" with no mention of the iter-172 audit re-estimate. Strictly speaking it's not an A.4 cost claim (it's a route-commitment recap), so I did not edit it; if the plan agent wants the audit reference to permeate the whole chapter, that paragraph would be a candidate.

## Strategy-modifying findings

No strategy change surfaced by this prose reconciliation. The audit-driven A.4 re-estimate ($\sim 22$--$35$ iters, $\sim 2500{+}$ LOC) was already absorbed into STRATEGY.md row 79 by a prior iteration; this round only aligned the chapter's three earlier paragraphs with that update and the in-chapter audit verdict. The new chapter-wide Route A total ($\sim 6000$--$7500{+}$ LOC / $\sim 48$--$78$ iters) is a deterministic consequence of summing the per-sub-phase rows; if the planner accepts the chapter as authoritative on totals, STRATEGY.md may need a corresponding refresh of its Route A overall envelope (flagged under "Notes for Plan Agent" above, not raised here as strategy-modifying because the per-sub-phase rows themselves are unchanged).
