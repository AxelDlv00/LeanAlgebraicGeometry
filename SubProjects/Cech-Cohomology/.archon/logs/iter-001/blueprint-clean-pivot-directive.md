# Blueprint Clean Directive

## Slug
pivot

## Chapters to clean (all touched/created this iteration)

1. `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — heavily edited this iter:
   the push–pull functor-assembly lemma was split into `lem:push_pull_id` + `lem:push_pull_comp`;
   the comparison theorem proof was rewritten to the acyclic-resolution route; and
   `lem:cech_acyclic_affine` was split into Čech-complex vanishing + `lem:affine_serre_vanishing`
   + `lem:cech_to_cohomology_on_basis`.
2. `blueprint/src/chapters/Cohomology_AcyclicResolution.tex` — brand-new chapter (abstract
   acyclic-resolution comparison theorem).

## What to do

- **Strip Lean-tactic leakage** from prose, especially in the `lem:push_pull_comp` proof's
  "Implementation note for the prover": remove pure tactic/kernel syntax mentions
  (`erw`, `congr`, `whnf`, `TwoSquare.equivNatTrans`, `mateEquiv`, `subst`, "rewrites stay
  syntactic", references to "documented dead-end" / iteration history). **PRESERVE** the
  load-bearing MATHEMATICAL content and named Mathlib lemmas — `conjugateEquiv_comp`
  ("mate-of-composite = composite-of-mates"), `pseudofunctor_associativity`,
  `conjugateEquiv_pullbackComp_inv`, `conjugateEquiv_pullbackId_hom`,
  `pseudofunctor_right_unitality`, the mate lemmas `pushPull_unit_mate`/`pushPull_unit_comp` —
  these are legitimate references to Mathlib infrastructure and the proof recipe, not leakage.
  Naming a Mathlib lemma is fine; naming a Lean tactic or a kernel-evaluation artifact is not.
  The pointer "see `analogies/pushpull-functoriality.md`" may be removed or kept as a brief
  prose note; do not keep iteration-history framing.
- **Strip any remaining project-history / iteration framing** anywhere in either chapter
  (e.g. "iter-264/271/283", "our failed route", "this iter").
- **Validate citation discipline** on every block: `% SOURCE:` with `(read from references/<file>)`,
  verbatim `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:`. The relevant local sources are
  `references/stacks-coherent.tex` (Čech chapter) and `references/homological-acyclic-derived.tex`
  (Stacks `derived.tex`, Tags 0157/015C/015D/015E/05TA for the acyclic-resolution chapter). If a
  block needs a verbatim quote that is missing but the source file exists, open the source and
  insert the quote. Note: `lem:cech_to_cohomology_on_basis` corresponds to the Stacks
  *Cohomology* chapter lemma `cohomology-lemma-cech-vanish-basis`, whose standalone statement may
  NOT be in `references/` (only its application is in `stacks-coherent.tex`); if so, leave the
  writer's honest "statement not yet retrieved" note OR spawn a reference-retriever for the
  Stacks Cohomology chapter (`cohomology.tex`) — your `--write-domain` authorizes `references/**`.
- **Fix LaTeX / `\uses{}` / `\label{}` formatting** issues.
- Do NOT add or remove `\leanok` (managed by `sync_leanok`). Do NOT edit `content.tex`.

## Out of scope
- `Cohomology_HigherDirectImage.tex` (untouched, already clean).
- Do not change any `\lean{}` pin or `\label`; only clean prose/citations/LaTeX.

Return your outcome and the path to your report.
