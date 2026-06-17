# Blueprint Writer Report

## Slug
gf-tower-descent

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:gf_away_tower_descent}`/`\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}`
  — the L5 Step-4 helper: for `A` a domain and an abstract `A`-module `T`, given `g ≠ 0` in
  `A` and `h ≠ 0` in `A_g = Away(g)`, freeness of the iterated localisation `(T_g)_h` over
  `(A_g)_h = Away(h)` yields `f ≠ 0` in `A` with `T_f` free over `A_f`. Statement and proof
  written to match the landed Lean signature exactly (read from
  `AlgebraicJacobian/Picard/FlatteningStratification.lean:1266`), including the explicit
  witness `f := g·a` (single product — the WITNESS CAVEAT). Four-step proof sketch added
  (clear denominator of `h` → identify base rings → identify modules via the composite
  localisation map → transport freeness). A `% LEAN DEPS:` comment records the exact Mathlib
  primitives the Lean proof consumes (`IsLocalization.surj`, `IsLocalization.map_units`,
  `IsLocalization.Away.mul_of_associated`, `IsLocalization.algEquiv`, `Module.Free.of_ringEquiv`,
  `IsLocalizedModule.linearEquiv`, `LinearEquiv.extendScalarsOfIsLocalization`) plus a note that
  the composite-localisation `IsLocalizedModule (powers (g·a)) ψ` fact is proved from the three
  module axioms (no packaged Mathlib lemma). This clears the `lean_aux` coverage debt: the Lean
  decl now matches the new blueprint node instead of floating as an unmatched auxiliary.
- **Added Mathlib anchor** `\label{lem:isLocalization_away_mul_of_associated}`/`\lean{IsLocalization.Away.mul_of_associated}`/`\mathlibok`
  — the key ring identification `Away(x z) T` from `Associated (algebraMap z) y` along a
  localisation tower. Verified to exist in Mathlib (`Mathlib.RingTheory.Localization.Away.Basic`)
  via loogle before marking `\mathlibok`.
- **Added Mathlib anchor** `\label{lem:module_free_of_ringEquiv}`/`\lean{Module.Free.of_ringEquiv}`/`\mathlibok`
  — freeness transports across a semilinear ring isomorphism. Verified to exist in Mathlib
  (`Mathlib.LinearAlgebra.FreeModule.Basic`) via loogle before marking `\mathlibok`.
- **Revised** `lem:gf_polynomial_core` Step 4 — repointed the "descend the witness from `A_g`
  to `A`" citation from `\cref{lem:gf_splice_shortExact_free_transport}` (L3b, the wrong lemma)
  to `\cref{lem:gf_away_tower_descent}`; adjusted the prose to describe clearing the denominator
  of `h` to a numerator `a` associated to `h`, the identification `(A_g)_h = A_{g a}` /
  `(T_g)_h = T_{g a}`, and the single-product witness `f := g a` (with an explicit "not a
  square" note matching the WITNESS CAVEAT).
- **Fixed dependencies** `lem:gf_polynomial_core` — added `lem:gf_away_tower_descent` to both
  the statement-block and proof-block `\uses{}` (the two blocks carry identical `\uses` lists in
  this chapter), keeping all existing entries per directive.

## Cross-references introduced
- `\uses{lem:isLocalization_away_mul_of_associated, lem:module_free_of_ringEquiv}` in
  `lem:gf_away_tower_descent` (statement + proof) — both targets created in this same chapter.
- `\uses{... lem:gf_away_tower_descent}` added in `lem:gf_polynomial_core` (statement + proof)
  — target created in this same chapter.
- `\cref{lem:gf_away_tower_descent}` in `lem:gf_polynomial_core` proof Step 4.

leandag verification: `unknown_uses: []`, `conflicts: []`, no isolated nodes in
Picard_FlatteningStratification. Edges confirmed:
`isLocalization_away_mul_of_associated → gf_away_tower_descent`,
`module_free_of_ringEquiv → gf_away_tower_descent`,
`gf_away_tower_descent → gf_polynomial_core`. The new helper node matches the Lean decl
(`proved=False`, sorry present — correct, no `\leanok`). The two new `\mathlibok` anchors appear
in `unmatched_lean`, which is the normal pattern for Mathlib anchors (all pre-existing
`\mathlibok` anchors in the chapter — e.g. `lem:fp_free_descent`, `lem:annihilator_meets_nonZeroDivisors`,
`lem:mathlib_away_lift` — appear there too).

## References consulted
None. The new helper `lem:gf_away_tower_descent` is an Archon-original Lean-helper block (no
external source — the source lines are correctly omitted per citation discipline). The two added
blocks marked `\mathlibok` are Mathlib dependency anchors whose citation IS the `\lean{}` target;
their existence and exact statements were verified directly against Mathlib via loogle
(`IsLocalization.Away.mul_of_associated`, `Module.Free.of_ringEquiv`,
`LinearEquiv.extendScalarsOfIsLocalization` all confirmed). No `references/*.md` files were opened
for citation blocks this session.

## Macros needed (if any)
None. All math uses existing macros / standard commands (`\mathrm`, `\xrightarrow`, `\langle`,
`\simeq`).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The 2 remaining isolated `lean_aux` nodes are unrelated GradedModule helpers
  (`AlgebraicGeometry.GradedModule.homogeneousSubmodule_iSup_inf_eq`,
  `...homogeneousSubmodule_inf_iSupIndep`) — these are the graded-quotient `isDefEq` pathology
  area, outside this chapter and this directive.
- `lem:gf_polynomial_core` retains `lem:gf_splice_shortExact_free_transport` in its `\uses`
  per directive ("keep the existing `\uses` entries"), even though Step 4 no longer cites it
  directly. It remains a genuine dependency of `lem:gf_splice_shortExact` (used in Step 5), so
  the edge is not misleading at the chain level; if a future cleanup wants `\uses` to reflect
  only direct citations, this entry could be dropped from the L5 core block.

## Strategy-modifying findings
None. The chapter change is a localised wiring/citation fix plus one new helper block; it does
not alter the project strategy.
