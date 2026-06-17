# Blueprint-reviewer directive — iter-027 (whole-blueprint audit, HARD GATE)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) as usual — the cross-chapter view is the
point. Produce your standard per-chapter completeness + correctness checklist and the
unstarted-phase proposals section.

## This iter's focus (where the planner most needs your gate verdict)
The consolidated chapter `Cohomology_CechHigherDirectImage.tex` received substantial edits this
iter, and the planner intends to SCAFFOLD the following into Lean NEXT iter — so they need a
`complete: true · correct: true` gate verdict on these specific blocks:

1. **The 01EO decomposition** — `lem:cech_to_cohomology_on_basis` (Stacks 01EO) was split into a
   four-link `\uses` chain: `lem:cech_ses_of_basis` (SES of Čech complexes from basis),
   `lem:quotient_vanishing_cech` (quotient inherits vanishing-higher-Čech),
   `lem:absolute_cohomology_one_vanishing` (base case `H¹=0`),
   `lem:absolute_cohomology_pos_vanishing` (dimension-shift induction). Check: does each sub-lemma's
   statement + informal proof genuinely cover one mathematical step of the verbatim Stacks 01EO
   proof, are the `\uses` edges accurate and acyclic, and is the top lemma now a faithful assembly?
   Is the proposed Lean signature for each (in the effort-breaker's plan — cover-local L1–L3, a
   `BasisCovSystem`/`HasVanishingHigherCech` abstraction for L4 + top) well-formed and faithful (in
   particular: the inductive predicate must stay abstract, since the quotient `Q` is NOT
   quasi-coherent)?

2. **The new project-wrapper blocks** under `\subsection{Project wrappers around the Ext
   realization}`: `lem:absolute_cohomology_zero` (H⁰≅Γ), `lem:absolute_cohomology_zero_natural`
   (naturality of H⁰≅Γ in the coefficient sheaf — a NEW to-build obligation, no Lean decl yet),
   `lem:absolute_cohomology_injective_vanishing`, `lem:absolute_cohomology_covariant_les`. The first,
   third, and fourth already have axiom-clean Lean decls; the naturality one is the one new
   declaration the next scaffold must build. Check these blocks are correct specializations of the
   Mathlib Ext anchors and that the naturality statement (the commuting square transferring
   section-level surjectivity `I(U)↠Q(U)` across H⁰≅Γ) is precisely what
   `lem:absolute_cohomology_one_vanishing`'s surjectivity step consumes.

## Output expectations
- Your per-chapter checklist with explicit `complete:`/`correct:` for
  `Cohomology_CechHigherDirectImage.tex` (the consolidated chapter — its verdict gates all 7 Lean
  files it `% archon:covers`, including the next 01EO scaffold).
- Any must-fix-this-iter findings, sharply scoped.
- Unstarted-phase blueprint proposals (if any phase still lacks coverage).
- Whether the 01EO sub-lemma chain + the naturality obligation are formalize-ready (so the planner
  can dispatch a scaffold next iter), or what remains to fix first.
