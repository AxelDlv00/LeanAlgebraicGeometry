# Blueprint Clean Report — iter018

## Status: COMPLETE

Both target chapters cleaned of Lean leakage in all newly added/edited blocks.

---

## FlatBaseChange.tex — 5 new Seam-2 blocks + 1 edited proof

### `lem:gammaMap_pushforwardComp_hom_eq_id`
- Removed `\operatorname{moduleSpec}\Gamma` Lean-name annotation from statement.
- Removed "definitional transparency" from proof; replaced with "evaluates to the identity on every open".

### `lem:gammaMap_pushforwardComp_inv_eq_id`
- Removed "definitional transparency" from proof; replaced with "evaluates to the identity on every open".

### `lem:gammaMap_pushforwardCongr_hom`
- Removed `\operatorname{moduleSpec}\Gamma` from statement.
- Replaced `\operatorname{eqToHom}(\dots)` conclusion with `\operatorname{id}`.
- Removed `\operatorname{eqToHom}(\mathrm{rfl})` from proof; replaced with "reduces to the identity morphism on sections".

### `lem:base_change_mate_codomain_read_legs`
- Removed "well-typed motive / dependent-type obstruction" from statement.
- Removed "well-typed motive" from proof; replaced with a mathematical explanation of why free-variable substitution is legitimate.

### `lem:base_change_mate_fstar_reindex_legs`
- Removed "This is the block carrying the live Seam 2 proof content" from statement.
- Removed "well-typed motive" phrasing from proof step (i).
- Replaced `\operatorname{eqToHom}` with "the identity" in proof step (ii) (referencing `lem:gammaMap_pushforwardCongr_hom`).

### `lem:base_change_mate_fstar_reindex` (edited this iter to reference `_legs`)
- Removed "The dependent-type obstruction" heading; replaced with "Why a direct substitution fails".
- Removed "dependent positions of the goal", "ill-typed motive", "formalizable sub-steps", "honest substitutable variables".
- Removed "substitution now acts on a well-typed motive"; replaced with a clean explanation that the free variables transform uniformly.
- Removed "the motive-blocked rewrite"; replaced with "the blocked rewrite".

### Citation discipline
- All 5 new Seam-2 blocks are project-bespoke (NO `% SOURCE` / `% SOURCE QUOTE` lines present — verified).
- No fabricated citations added.

---

## QuotScheme.tex — new homogeneity calculus + finiteness recipe + edited proofs

### `def:graded_subquotientHilb`
- Removed `(\mathrm{DirectSum.Decomposition}\ \mathcal{M})` parenthetical; kept pure mathematical statement.
- Replaced `(\mathrm{Module.Finite})` annotation with "a finiteness condition".

### `lem:graded_subquotient_finite_transfer`
- Replaced "datum as a single bundle" / "scalar-tower compatibility" / "handed back as bundles" paragraph with timeless mathematical prose.
- Removed "Module.Finite carrier" sentence from proof.
- Removed "no derived-carrier grading is used" implementation note from proof.
- Removed remaining `\mathrm{Module.Finite}` from statement ("with a valid Module.Finite witness") → "satisfying the finiteness condition".

### `lem:graded_homogeneousSubmodule_iSup_eq` (G1 supremum, in ambient calculus section)
- Removed `(\mathrm{DirectSum.Decomposition})\ on the subtype\ \hat{p}` parenthetical; replaced with "without requiring a direct-sum decomposition of the subtype".

### `lem:gradedHilbertSerre_rational` (proof edited this iter to invoke new subquotient induction)
- Removed `\mathrm{Module.Finite}` from "this is the Module.Finite witness required below"; replaced with "this is the finiteness condition required below".

### Homogeneity calculus blocks (`lem:graded_raisesDegree*`, `lem:graded_*_isHomogeneous`, `lem:graded_*_degree_eq`)
- Verified clean on read — no Lean leakage found in these new blocks.

### `Algebra.adjoinCommRingOfComm` Mathlib anchor
- Verified `\mathlibok` present, no `% SOURCE QUOTE` (correct — Mathlib is the source, no verbatim quote needed).

### Citation discipline
- All new project-bespoke homogeneity-calculus blocks carry NO `% SOURCE` lines — verified.
- Existing Stacks 00K1 `% SOURCE QUOTE PROOF` blocks untouched.
- No new fabricated source quotes added.

---

## Items left untouched (out of scope)

- `FlatBaseChange.tex` line 803: `\operatorname{moduleSpec}\Gamma` in `lem:pullback_spec_tilde_iso` — existing block, not edited this iteration.
- `FlatBaseChange.tex` line 2362: `scalar-tower compatibility` in a Mathlib lemma description — existing block.
- All occurrences inside `%` comment lines (`% LEAN SIGNATURE`, `% RECIPE`, `% NOTE:`) — invisible in compiled PDF, leave as-is.

---

## LaTeX / dependency edges
- All `\lean{}` pins preserved intact.
- All `\uses{}` edges preserved intact.
- No `\leanok` markers added or removed.
- `\mathlibok` on `adjoinCommRingOfComm` block unchanged.
