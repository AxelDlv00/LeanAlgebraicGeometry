# Blueprint Writer Report

## Slug
quot-coverage

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

### A. 18 new blueprint blocks for the 20 Lean helper decls
(The other 2 — `SubquotientDatum`, `SubquotientDatum.hilb` — are matched via extra
`\lean{}` pins in `def:graded_subquotientHilb`, per M4, not standalone blocks.)
All are Archon-original / project-bespoke (no `% SOURCE` lines). All carry `[human name]`,
`\label`, `\lean{AlgebraicGeometry.GradedModule.<name>}`, accurate `\uses`, and a one-line
informal proof. Each `\lean` pin verified to resolve (none appear in leandag `unmatched_lean`;
`lean_aux` dropped 21→1).

**Group 1 — kernel/cokernel calculus** (8 lemmas, placed in the "Closure under kernel and
cokernel" subsubsection, before the narrative `lem:graded_subquotient_ker_coker`):
- `lem:graded_ker_isHomogeneous` → `ker_isHomogeneous` — `\uses{lem:graded_inf_isHomogeneous, lem:graded_comap_isHomogeneous}`
- `lem:graded_coker_isHomogeneous` → `coker_isHomogeneous` — `\uses{lem:graded_sup_isHomogeneous, lem:graded_map_isHomogeneous}`
- `lem:graded_ker_le` → `ker_le` — (pure lattice; no blueprint dep)
- `lem:graded_coker_le` → `coker_le` — (pure lattice)
- `lem:graded_ker_annihilate` → `ker_annihilate` — (definitional)
- `lem:graded_coker_annihilate` → `coker_annihilate` — (definitional)
- `lem:graded_comap_map_le_of_commute` → `comap_map_le_of_commute` — (commute calc)
- `lem:graded_map_map_le_of_commute` → `map_map_le_of_commute` — (commute calc)

**Group 2 — free polynomial-ring module structure** (9 decls, in a new subsubsection "The
free polynomial-ring module structure", before "Ambient finiteness transfer"):
- `def:graded_polyEndHom` → `polyEndHom` — `\uses{lem:adjoinCommRingOfComm_mathlib}`
- `lem:graded_polyEndHom_X` → `polyEndHom_X` — `\uses{def:graded_polyEndHom}`
- `lem:graded_polyEndHom_C` → `polyEndHom_C` — `\uses{def:graded_polyEndHom}`
- `def:graded_polyModule` → `polyModule` — `\uses{def:graded_polyEndHom}`
- `lem:graded_polyModule_X_smul` → `polyModule_X_smul` — `\uses{def:graded_polyModule, lem:graded_polyEndHom_X}`
- `lem:graded_polyModule_C_smul` → `polyModule_C_smul` — `\uses{def:graded_polyModule, lem:graded_polyEndHom_C}`
- `lem:graded_polyModule_isScalarTower` → `polyModule_isScalarTower` — `\uses{def:graded_polyModule, lem:graded_polyEndHom_C}`
- `def:graded_polySubmodule` → `polySubmodule` — `\uses{def:graded_polyModule, lem:graded_polyModule_X_smul, lem:graded_polyModule_C_smul}`
- `lem:graded_polySubmodule_coe` → `polySubmodule_coe` — `\uses{def:graded_polySubmodule}`

**Group 3 — base case** (1 standalone block, in a new subsubsection "The base case ($r=0$)",
before the induction):
- `lem:graded_finiteDimensional_of_mvPolynomial_isEmpty_finite` → `finiteDimensional_of_mvPolynomial_isEmpty_finite` — (no blueprint dep beyond Mathlib)

### B. M2 — fixed finiteness-condition prose of `def:graded_subquotientHilb`
Third bullet now reads "the subquotient `N/N'` is a finite module over the polynomial ring
`κ[t_0..t_{r-1}]` acting through the `t_i`" (with a `\cref` to `def:graded_polySubmodule`
for the ambient carriers). The redundant iter-018 `% NOTE` was removed.

### C. M3 — fixed the broken `\lean{}` on `lem:graded_subquotient_ker_coker`
Dropped the `\lean{AlgebraicGeometry.GradedModule.subquotient_ker_coker}` line (named a
non-existent decl) — option (a). The block is now a pure narrative grouping lemma. Its
**statement** `\uses{}` was extended with the 8 Group-1 labels (see note below), and a short
LaTeX comment records that its content is realised by those 8 components plus the (not-yet-built)
`SubquotientDatum.ker/.coker` constructors. The iter-018 `% NOTE` flagging the broken pin was
removed.

### D. M4 — added the missing pins in `def:graded_subquotientHilb`
Added `\lean{AlgebraicGeometry.GradedModule.SubquotientDatum}` and
`\lean{AlgebraicGeometry.GradedModule.SubquotientDatum.hilb}` alongside the existing
`subquotientHilb` pin. Both resolved (confirmed: `lean_aux` for these two cleared).

### E. M1 — `% NOTE` on the IsRatHilb toolkit subsection
Added a `% NOTE:` after `\label{subsec:isRatHilb}` recording that the toolkit decls
(`coeff_invOneSubPow_one_mul`, `rationalHilbert_antidiff`, `IsRatHilb`, `.ofEventuallyZero`,
`.bump`, `.sub`, `.shiftRight`, `.antidiff`, `.ofDiffEq`) are `private` in Lean and their
public-name pins may not resolve until the toolkit is split into `GradedHilbertSerre.lean`.
No math changed. (Also flagged under "Notes for Plan Agent" below.)

## Cross-references introduced / wired
- `lem:graded_subquotient_ker_coker` statement `\uses{}` += the 8 Group-1 labels.
- `lem:graded_subquotient_finite_transfer` statement `\uses{}` += `def:graded_polyEndHom`,
  `def:graded_polyModule`, `def:graded_polySubmodule`, `lem:graded_polyModule_isScalarTower`.
- `lem:graded_subquotient_isRatHilb` statement `\uses{}` += `lem:graded_finiteDimensional_of_mvPolynomial_isEmpty_finite` (base case).

**IMPORTANT mechanism note (for the reviewer):** `leandag` builds dependency edges from
**statement-level** `\uses{}` only — it does **not** read `\begin{proof}` `\uses{}`. The
directive (M3) phrased the wiring as a proof `\uses{}`; to actually de-isolate the nodes I put
the dependency labels in the **statement** `\uses{}` of each consumer (I also left them in the
proof `\uses{}` where natural). This is the only deviation from the literal directive wording
and it is required to achieve the directive's stated goal (isolated → 1).

## leandag verification (after edits)
- `lean_aux`: 21 → **1** (only `finrank_comap_subtype`, the intentionally-unblueprinted private helper)
- `isolated`: 21 → **1** (only `lean:AlgebraicGeometry.GradedModule.finrank_comap_subtype`)
- `unknown_uses`: **0** (no broken `\uses` introduced)
- All 18 new `\lean{}` pins resolve; the 2 multi-pins (`SubquotientDatum`, `.hilb`) resolve.
- LaTeX environments balanced (definition 16/16, lemma 56/56, theorem 2/2, proof 25/25,
  itemize 2/2, enumerate 3/3); no bare `$` introduced (all `$` are in pre-existing
  `% SOURCE QUOTE` comments).

Note on the `unmatched_lean` JSON field (distinct from `lean_aux`): it sits at 46 and consists
entirely of (i) Mathlib dependency anchors marked `\mathlibok` and (ii) project decls not yet
formalized in Lean (`sectionGradedRing`, `gradedModule_hilbertSeries_rational`,
`subquotient_finite_transfer`, `subquotient_hilbertSeries_rational`, the 4 protected stubs, etc.).
None are blocks I authored — every one of my 18 new pins resolved. This field is not part of the
directive's acceptance criteria.

## References consulted
None opened this session for citation purposes — all 20 helper blocks are Archon-original /
project-bespoke mechanical lemmas (the directive authorized omitting `% SOURCE` lines and noted
the Stacks 00K1 context is already cited on the surrounding induction blocks, which I did not
modify). No new verbatim quotes were written, so no `references/<file>.md` was read for sourcing.

## Macros needed
None. All new prose uses macros already present (`\kappa`, `\mathcal`, `\dim`, `\cref`, etc.)
and chapter-standard `\( \)` / `\[ \]` delimiters.

## Reference-retriever dispatches
None.

## Notes for Plan Agent
- **IsRatHilb toolkit is `private` (M1).** The 9 `IsRatHilb`-toolkit declarations are `private`
  in `QuotScheme.lean`, so their public-name `\lean{}` pins (e.g.
  `AlgebraicGeometry.IsRatHilb`, `AlgebraicGeometry.coeff_invOneSubPow_one_mul`) will not
  resolve until the toolkit is de-private'd — planned for when the file is split into
  `GradedHilbertSerre.lean`. They show as part of `unmatched_lean` today. Recommend scheduling
  that split (lean-scaffolder) so these pins resolve and the toolkit nodes match.
- **Statement-vs-proof `\uses{}` (graph mechanism).** `leandag` ignores proof-level `\uses{}`.
  Any future directive that says "wire X into the proof `\uses{}`" will not move the graph;
  dependencies must go in the **statement** `\uses{}` to register an edge. Worth encoding in the
  writer/reviewer guidance.
- **Two narrative/unformalized induction blocks remain unmatched** (expected, out-of-scope this
  round): `lem:graded_subquotient_ker_coker` (now intentionally `\lean`-less narrative lemma; its
  Lean realisation is the 8 components + future `SubquotientDatum.ker/.coker` bundlers) and the
  not-yet-formalized `lem:graded_subquotient_finite_transfer` /
  `lem:graded_subquotient_isRatHilb` / `lem:gradedHilbertSerre_rational`. These are the substantive
  remaining Lean obligations of QUOT Route-2.

## Strategy-modifying findings
None. This was graph-hygiene + adequacy; the mathematics is unchanged.
