# Blueprint Writer Report

## Slug
extcohom-025

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### New definition block
- **Added definition** `\definition`/`\label{def:absolute_cohomology}` (no `\lean{}` — it
  records the realization convention, not a single Lean decl) — states
  `H^p(U, F) := Ext^p_{Mod(O_U)}(𝒪_U, F|_U)` (equivalently `Ext^p_{Mod(O_X)}(j_! 𝒪_U, F)`),
  and records the three downstream facts: (1) `H^0 ≅ Γ(U,F)` via degree-0 Ext, (2) injective
  vanishing with the injective kept as the **second** Ext argument (so no
  restriction-preserves-injectives lemma is forced), (3) the covariant Ext LES at fixed first
  argument `𝒪_U`. `\uses{}` all six Mathlib anchors below. Preceded by a short
  `\section{Absolute sheaf cohomology as Ext of the structure sheaf}` intro paragraph.

### New Mathlib dependency anchors (all `\mathlibok`, verified via `lean_run_code`/`#check`)
- `\definition`/`\label{lem:ext_bifunctor_mathlib}` — `\lean{CategoryTheory.Abelian.Ext}` — the Ext bifunctor object.
- `\lemma`/`\label{lem:hasext_standard_mathlib}` — `\lean{CategoryTheory.HasExt.standard}` — unconditional `HasExt`.
- `\lemma`/`\label{lem:ext_homequiv_zero_mathlib}` — `\lean{CategoryTheory.Abelian.Ext.homEquiv₀, CategoryTheory.Abelian.Ext.addEquiv₀}` — degree-0 Ext ≅ Hom.
- `\lemma`/`\label{lem:ext_eq_zero_of_injective_mathlib}` — `\lean{CategoryTheory.Abelian.Ext.eq_zero_of_injective}` — injective vanishing in second argument.
- `\lemma`/`\label{lem:ext_covariant_les_mathlib}` — `\lean{CategoryTheory.Abelian.Ext.covariantSequence_exact, ...covariant_sequence_exact₁, ₂, ₃}` — covariant Ext LES.
- `\definition`/`\label{lem:modules_restrict_functor_mathlib}` — `\lean{AlgebraicGeometry.Scheme.Modules.restrictFunctor}` — restriction of module sheaves along an open immersion.

### Revised consuming lemmas
- **Revised** `lem:affine_serre_vanishing` — added `def:absolute_cohomology` to BOTH the statement
  and proof `\uses{}`; added a closing sentence noting `H^p(U,-)` is the Ext realization of
  `def:absolute_cohomology`. Statement (the `H^p(U,F)=0` conclusion) unchanged; source quotes verbatim/untouched.
- **Revised** `lem:cech_to_cohomology_on_basis` — added `def:absolute_cohomology` to BOTH the
  statement and proof `\uses{}`; opened the proof prose by fixing `H^p(U,-)` as the Ext realization;
  rewrote the dimension-shift paragraph so "the sheaf-cohomology long exact sequence" now explicitly
  cites the covariant Ext LES (`lem:ext_covariant_les_mathlib`) and "`H^n(U,I)=0` for injective `I`"
  cites injective vanishing (`lem:ext_eq_zero_of_injective_mathlib`). Statement and `% SOURCE`/`% SOURCE
  QUOTE`/`% SOURCE QUOTE PROOF` blocks verbatim/untouched.

## Cross-references introduced (`\uses{}` edges added)
- `def:absolute_cohomology` → `{lem:ext_bifunctor_mathlib, lem:ext_covariant_les_mathlib,
  lem:ext_eq_zero_of_injective_mathlib, lem:ext_homequiv_zero_mathlib, lem:hasext_standard_mathlib,
  lem:modules_restrict_functor_mathlib}` (all six new, same chapter).
- `lem:affine_serre_vanishing` (statement + proof) → `def:absolute_cohomology`.
- `lem:cech_to_cohomology_on_basis` (statement + proof) → `def:absolute_cohomology`.

## Verification
- `leandag build --json`: `isolated: 0`, `unknown_uses: []`, `conflicts: []`; `mathlib_ok` rose
  9 → 15 (exactly the six new anchors). No broken `\uses{}` introduced; `def:absolute_cohomology`
  is fully wired (6 out-edges, 2 in-edges from the consuming lemmas).
- The six anchors appear in leandag's `unmatched_lean` list — this is the same expected/benign
  behavior as the pre-existing `\mathlibok` anchors (`lem:injective_of_adjoint`,
  `lem:mod_pmod_adjunction`), whose `\lean{}` targets are Mathlib decls outside the local Lean
  scan; they resolve as `mathlib_ok`, not as proof obligations.
- **No `\leanok` added anywhere.** `\mathlibok` added ONLY on the six genuine Mathlib anchors.
- All nine cited Mathlib decls `#check`ed successfully (`Abelian.Ext`, `covariant_sequence_exact₁/₂/₃`,
  `covariantSequence_exact`, `eq_zero_of_injective`, `homEquiv₀`, `addEquiv₀`, `HasExt.standard`,
  `Scheme.Modules.restrictFunctor`).

## References consulted
- `analogies/absolute-cohomology.md` — the planner's api-alignment decision (Ext realization, exact
  Mathlib decl names + file paths, refutation of Route β); primary source for the anchors.
- (No external `references/<file>.md` citation blocks authored — the new definition is a project
  realization convention, and the anchors cite Mathlib via `\lean{}`, not via `% SOURCE` quotes. The
  pre-existing `% SOURCE`/`% SOURCE QUOTE` blocks on the two consuming lemmas were left verbatim and
  untouched.)

## Macros needed
- None. Used only existing notation (`\mathcal{O}`, `X.\mathrm{Modules}`, `\operatorname{Ext}`,
  `\restriction`, `\Gamma`).

## Notes for Plan Agent
- The directive named `Ext.covariant_sequence_exact` (no subscript) as an anchor; that exact name
  does **not** exist in Mathlib. The real decls are `covariant_sequence_exact₁/₂/₃` (the three
  step-lemmas) and the bundled `covariantSequence_exact` (ComposableArrows exactness). I anchored
  `lem:ext_covariant_les_mathlib`'s `\lean{}` on all four, per the directive's allowance to bundle
  the ₁/₂/₃ pieces.
- `def:absolute_cohomology` carries no `\lean{}` (it is a realization convention with no single Lean
  declaration). If the project later introduces a named Lean abbreviation for `H^p(U,F)`, the plan
  agent can add the `\lean{}` hint then.
- Minor tension already resolved in the prose: the primary definition is `Ext^p(𝒪_U, F|_U)`, but the
  injective-vanishing fact is faithfully stated for "injective in the second argument" and applied via
  the equivalent `Ext^p_{Mod(O_X)}(j_! 𝒪_U, I)` form (so no restriction-preserves-injectives lemma is
  forced), exactly as `analogies/absolute-cohomology.md` recommends.

## Strategy-modifying findings
None.
