# Blueprint Reviewer Directive

## Slug
dag-iter013

## Strategy snapshot
Goal: close the Čech-independent leg of the parent's `thm:fga_pic_representability` cone — flat base
change (i=0), generic flatness, and the Quot foundations. Seven seed declarations: FBC
(`lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward`), GF
(`thm:generic_flatness`, `thm:generic_flatness_algebraic`), QUOT (`def:hilbert_polynomial`,
`def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable`). Encoding decisions:
Hilbert polynomial via the graded Hilbert function + a project-side graded Hilbert–Serre rationality
lemma `lem:gradedHilbertSerre_rational` (Mathlib provides only the extraction half); Grassmannian via
big-cell Plücker-cocycle gluing. Full arc in STRATEGY.md.

## Routes
- **FBC** — affine lemma direct-on-sections via tilde dictionaries + `cancelBaseChange`; globalization
  via the H⁰-equalizer (flat preserves the finite equalizer). Three adjoint-mate seam lemmas
  (`base_change_mate_unit_value` / `fstar_reindex` / `gstar_transpose`). Chapter:
  `Cohomology_FlatBaseChange.tex` (+ `Cohomology_RegroupHelper.tex`).
- **GF** — algebraic core `genericFlatnessAlgebraic` via Nitsure §4 induction on variable count, Nagata
  change of variables. Chapter: `Picard_FlatteningStratification.tex`.
- **QUOT** — Hilbert polynomial (graded encoding + SNAP rationality), predicates (schematic/proper
  support, rank-r local-freeness), Quot functor, Grassmannian + representability. Chapters:
  `Picard_QuotScheme.tex`, `Picard_GrassmannianCells.tex`, `Picard_RelativeSpec.tex`.

## References
- `references/nitsure-hilbert-quot.md` — Nitsure §1, §2, §4 (generic flatness), §5 (Grassmannian/Quot).
- `references/stacks-coherent.md` — flat base change of pushforward (tag 02KH).
- `references/stacks-schemes.md` — affine pullback/pushforward of tilde modules (tag 01I9).
- `references/stacks-constructions.md` — relative spectrum.
- `references/hilbert-serre.md` — graded Hilbert–Serre rationality (Stacks 00K1).
- `references/hartshorne-algebraic-geometry.md` — background companion.

## Focus areas (optional)
This DAG iteration closed the Lean↔blueprint 1-to-1 coverage debt: **44 prover-generated internal
helper declarations** (previously `lean_aux`, no blueprint entry) were given concise blueprint blocks
across four chapters — `Picard_FlatteningStratification.tex` (11 `GenericFreeness.*` Nagata helpers),
`Picard_GrassmannianCells.tex` (21 `Grassmannian.*` cocycle/matrix/localization helpers),
`Picard_QuotScheme.tex` (11: the `IsRatHilb` rationality cluster + 2 schematic-support helpers),
`Cohomology_FlatBaseChange.tex` (1: `base_change_mate_inner_value`). A blueprint-clean pass then
stripped Lean leakage from these. **Please pay particular attention to these new helper blocks**:
(a) are their informal statements mathematically faithful (not Lean-syntactic)? (b) are their `\uses{}`
edges accurate (each wired into the parent lemma whose Lean proof invokes it, none isolated)? (c) any
residual Lean leakage the clean pass missed? Confirm the new blocks did not perturb the meaningful
theorem statements (the clean pass was directed not to alter mathematical statements).

## Known issues
- `leandag` currently reports: 0 ∞-effort nodes, 0 broken `\uses{}`, 0 isolated blueprint nodes, 0
  blueprint decls missing `\lean{}`, 0 `lean_aux` (1-to-1 coverage complete). 28 blueprint→Lean
  unmatched `\lean{}` remain, expected and legitimate: 19 are Mathlib dependency anchors (`\mathlibok`,
  unparseable by leandag) and 9 are project forward-declarations the prover loop will create
  (`sectionGradedRing`, `sectionGradedModule`, `sectionGradedModule_fg`, `gradedModule_hilbertSeries_rational`,
  `hilbertPolynomialOfSectionModule`, `isLocalizedModule_basicOpen`, `Grassmannian.{scheme,isSeparated,isProper}`).
  Flag only if you find one of these is actually mis-stated or mislabeled.
- 14 Lean `sorry`s and 9 unproved-but-blueprinted blocks remain — these are the prover loop's domain,
  NOT blueprint defects; do not flag them as incompleteness.
