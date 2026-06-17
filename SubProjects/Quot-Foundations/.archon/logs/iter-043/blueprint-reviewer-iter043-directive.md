# Blueprint-reviewer directive — iter-043

Whole-blueprint audit (read all chapters; the cross-chapter view is the point). Per-chapter
complete/correct checklist + must-fix-this-iter findings.

## Focus — chapters feeding prover lanes this iter (HARD GATE clearance needed)
1. **Cohomology_FlatBaseChange.tex** — the affine tilde-transport PIVOT was authored iter-042
   (`lem:pushforward_base_change_mate_sections_direct` @~3288, `lem:pushforward_base_change_mate_cancelBaseChange`
   @~3441, `lem:affineBaseChange_pushforward_iso` @~3547). This chapter has NOT been reviewed since the pivot.
   Is the tilde-transport route complete + correct + formalizable? Does the `\uses{}` chain reflect the new
   route (no residual dependence on the abandoned conjugate `gstar_transpose` path)? This gates the MANDATORY
   FBC prover this iter.
2. **Picard_QuotScheme.tex** — gap2 block `lem:qcoh_section_localization_basicOpen` (@~2477). Known defects
   from iter-042 lean-vs-blueprint-checker (to be writer-patched THIS iter): sketch omits the proven crux
   `fromSpec_image_top_section_coherence` and still frames transport as "the sole new piece" though
   `section_localization_hfr_aux_general` already exists. Also 4 new helper decls lack blueprint blocks
   (coverage debt): `restrictₗ`, `restrictBasicOpenₗ`, `fromSpec_image_top_section_coherence`,
   `section_localization_hfr_aux_general`. And Piece A (QC-pullback along `fromSpec`, Mathlib-absent) needs a
   blueprint block before its prover. Flag whether the gap2 cone is complete enough to formalize Piece A + B.
3. **Picard_FlatteningStratification.tex** — `lem:gf_qcoh_fintype_finite_sections` (G1, @~1514). Is it
   complete + correct + formalizable as a direct G1-core (`lem:qcoh_affine_section_localization`) application?
   This gates the GF-G1 prover lane.

## Also
- Coverage debt: leandag unmatched=4 (the QUOT helpers above). Per-chapter, note which need blocks.
- Unstarted-phase proposals as usual (SNAP tensor-powers, GR-quot/repr).
- Carry-forward: `Grassmannian.representable` Lean weaker than blueprint prose (pre-existing major).
