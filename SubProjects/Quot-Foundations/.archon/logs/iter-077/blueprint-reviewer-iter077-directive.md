# Blueprint-reviewer directive — iter-077 (full whole-blueprint audit)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`). This is the overdue FULL gate: the
last full run was iter-066; chapters were edited iter-067 (gr-coverage2 coverage blocks + a SNAP
two-block edit). Iters 068–076 ran no real provers (auth failure), so no blueprint changed since.

Produce your standard per-chapter completeness+correctness checklist. Pay particular attention to
the two chapters feeding THIS iter's live prove lanes — confirm their open-target blocks carry
complete, formalizable informal proofs (not just statements):
- `Picard_GlueDescent.tex` — effective-descent keystone (`isIso_glueRestrictionHom`,
  `glueOverlapBaseChangeIso` β_ij, `lem:gr_modules_glue_unique`, `def:gr_modules_glueHom`).
- `Picard_GrassmannianQuot.tex` — Nitsure §5 inverse chain (`tautologicalQuotient_epi`,
  `chartLocus_isOpenCover`, `isIso_pullback_isoLocus_map`, `grPointOfRankQuotient`, `represents`).

Also flag any STRATEGY phase with no blueprint coverage (unstarted-phase proposals) per your descriptor.
Report to your task_results file.
