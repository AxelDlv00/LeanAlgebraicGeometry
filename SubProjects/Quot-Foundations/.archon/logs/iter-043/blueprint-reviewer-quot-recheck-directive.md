# Blueprint-reviewer (fast-path re-review) — iter-043, scoped to Picard_QuotScheme.tex

Scoped re-verification of ONE chapter after a writer round: **Picard_QuotScheme.tex**. Confirm the
gap2 HARD GATE now clears. (You always read the whole blueprint; report verdict for QuotScheme only.)

The iter-043 full review flagged 4 CRITICAL gap2 defects, all now writer-patched. Verify each is fixed:
1. gap2 proof sketch (`lem:qcoh_section_localization_basicOpen`) no longer says "sole genuinely new
   piece"; now routes through the existing `section_localization_hfr_aux_general` core + names the
   `fromSpec_image_top_section_coherence` crux.
2. 4 helper blocks now exist with `\label{}` + `\lean{}` + `\uses{}`: `restrictₗ`, `restrictBasicOpenₗ`,
   `fromSpec_image_top_section_coherence`, `section_localization_hfr_aux_general` (the writer may have
   labelled these `lem:modules_restrict_linear` / `lem:modules_restrict_basicOpen_linear` /
   `lem:fromSpec_image_top_section_coherence` / `lem:section_localization_hfr_aux_general` — confirm the
   `\lean{}` pins match the real decl names).
3. Piece A block `lem:qcoh_pullback_fromSpec` exists with `\lean{}` + `\uses{}` (QC-pullback along fromSpec).
4. gap2 `\uses{}` now includes Piece A + the helper labels.

Verdict needed: is Picard_QuotScheme.tex now `complete: true` AND `correct: true` with no must-fix for
the gap2 + Piece-A prover lanes? If yes, the gate clears and both provers dispatch this iter.
