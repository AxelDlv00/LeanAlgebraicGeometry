# Blueprint-reviewer directive — iter-028 (whole-blueprint audit + 01EO gate)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) per your standard per-chapter
completeness + correctness checklist.

## Context (what changed this iter — for your gate verdict, not a scope limit)
The consolidated chapter `Cohomology_CechHigherDirectImage.tex` (its `% archon:covers` block covers
`AbsoluteCohomology.lean` and `CechToCohomology.lean` among others) was substantially edited this iter
to clear the iter-027 lean-vs-blueprint must-fix items and to scaffold the next prover target:

1. L1 `lem:cech_ses_of_basis` and L2 `lem:quotient_vanishing_cech` statement prose rewritten from the
   cover-global `(B,Cov)`/sheaf form to the **landed** cover-local, presheaf-level, hypothesis-driven
   form (matching the axiom-clean Lean that shipped iter-027).
2. New blocks for the previously-uncovered helpers: `lem:short_exact_pi_map` (AB4* product-of-SES),
   `lem:cech_homology_quotient_vanishing` (abstract homology-LES core), `def:cech_cohomology_accessor`,
   `def:section_cech_short_complex`, `def:section_cech_functoriality`, and the 4 AbsoluteCohomology
   naturality helpers bundled into `lem:absolute_cohomology_zero_natural`. (`unmatched` 14→0.)
3. Scaffold blocks for the NOT-YET-FORMALIZED next targets (each `% NOTE`-flagged as such):
   `lem:face_ses_of_sheaf_ses` (per-face SES derivation), `def:basis_cov_system`,
   `def:has_vanishing_higher_cech`, and reconciled L3 `lem:absolute_cohomology_one_vanishing`,
   L4 `lem:absolute_cohomology_pos_vanishing`, top `lem:cech_to_cohomology_on_basis`.

## What I most need from you
Your standard whole-blueprint checklist, AND specifically a HARD-GATE verdict
(`complete: true|false · correct: true|false`, with any must-fix-this-iter findings) on
**`Cohomology_CechHigherDirectImage.tex`**, because I intend to dispatch a prover at
`CechToCohomology.lean` THIS iter (fast path) to formalize the per-face SES derivation + L3 + L4 + top.
Check in particular:
- Are the L3/L4/top + per-face-SES + BasisCovSystem scaffolds **formalize-ready** — statements precise,
  signatures coherent with the landed cover-local L1/L2 and with the Form-B `absoluteCohomology` Ext API,
  `\uses` acyclic and complete?
- Is the L1/L2 rewritten prose now faithful to the landed Lean (no residual cover-global mismatch)?
- Is the inductive predicate `HasVanishingHigherCech` kept correctly ABSTRACT (not specialized to
  quasi-coherent modules — `Q = I/F` need not be quasi-coherent)?
- Any broken `\uses{}` / `\ref{}`, missing source quotes, or `\leanok`/`\mathlibok` misuse.

Also flag any unstarted strategy phase with no blueprint coverage (your standard
`## Unstarted-phase blueprint proposals` section).
