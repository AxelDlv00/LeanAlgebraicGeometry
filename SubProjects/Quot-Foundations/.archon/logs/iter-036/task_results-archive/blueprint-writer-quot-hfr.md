# Blueprint Writer Report

## Slug
quot-hfr

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:section_localization_descent_of_cover}`/`\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_cover}`
  — the LANDED, axiom-clean cover-hypothesis keystone (D, cover form). States: for `M : (Spec R).Modules`,
  `f : R`, a finite basic-open cover `{D(r)}_{r∈t}` with `span t = ⊤`, and per-piece data `Hfr`
  (localization on every `U ≤ D(r)`), the global restriction `Γ(M,⊤) → Γ(M,D(f))` is
  `IsLocalizedModule (powers f)`. Verbatim Stacks `lemma-invert-f-sections` source quote (statement),
  `\textit{Source: ...}`, `% SOURCE QUOTE`. Full proof sketch added: the three `IsLocalizedModule`
  fields — `map_units` (arbitrary `M`, via `map_units_restrict_basicOpen`); `surj` (per-`D(r)`
  surjectivity with common power `N`, overlap agreement up to a further power `P`, gluing the
  `f^P`-scaled family by the sheaf condition, conclude on `D(f)` by separatedness); `exists_of_eq`
  (per cover element a power of `f` kills, common exponent + separatedness). Explicitly does NOT route
  through the global `QCoh≃Mod` equivalence.
- **Added lemma** `\lemma`/`\label{lem:pullback_gamma_top_iso}`/`\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackTopIso}`
  — the iter-036 prover target: the `Hfr` SECTION-TRANSPORT ingredient. States `Γ((pullback j).obj M, ⊤)
  ≅ Γ(M, range j)` for an open immersion `j`, natural in the open argument (intertwining restriction
  maps). Proof sketch: `j^res M` has `Γ(j^res M, V) = Γ(M, j(V))` definitionally; `restrictFunctorIsoPullback`
  identifies `j^res ≅ j^* = pullback j`; apply `Γ(-,V)` to the component. Project-bespoke (no external
  source; stands on its sketch). A following `% NOTE` block spells out how chaining it through P1's
  three pullbacks (`isoSpec.inv`, basic-open ι's) + `over_restrict_pullback_iso` + P1's `IsIso fromTildeΓ`
  + `isLocalizedModule_restrict_of_isIso_fromTildeΓ` yields `Hfr`, and that the named form + gap1 are
  then one-liners.
- **Added Mathlib anchor** `\lemma`/`\label{lem:eq_of_locally_eq_mathlib}`/`\lean{TopCat.Sheaf.eq_of_locally_eq'}`/`\mathlibok`
  — separatedness over a cover (uniqueness half of the sheaf condition), the form `eq_of_locally_eq'`
  the cover-form proof actually consumes (verified used in the Lean source at QuotScheme.lean L1394, L1570).
  The existing `lem:existsUnique_gluing_mathlib` already anchored gluing, so per the directive I only
  `\uses{}` it and extended its prose to note the primed `existsUnique_gluing'` companion (used at
  QuotScheme.lean L1561) is the form the cover-form descent consumes — no duplicate gluing anchor added.
- **Revised** `lem:section_localization_descent` (named form, future target) — kept as a future target with
  its `% NOTE`; rewired `\uses{}` (lemma + proof) to `{lem:section_localization_descent_of_cover,
  lem:pullback_gamma_top_iso, lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent,
  lem:exists_finite_basicOpen_cover_le_quasicoherentData,
  lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ, lem:isLocalizedModule_tilde_restrict}`, and rewrote
  the proof to the modular route (produce `Hfr` from the section transport + P1, then apply the
  cover-form keystone) rather than the old inline finite-equalizer argument. NOTE updated to reflect the
  landed cover form and the gating section transport.

## Cross-references introduced
- `\uses{lem:section_localization_descent_of_cover}` in `lem:section_localization_descent` and its
  proof — target added in this chapter (this round).
- `\uses{lem:pullback_gamma_top_iso}` in `lem:section_localization_descent` and its proof — target added
  this chapter.
- `\uses{lem:eq_of_locally_eq_mathlib}` in `lem:section_localization_descent_of_cover` and its proof —
  target added this chapter.
- `\uses{lem:map_units_restrict_basicOpen, lem:existsUnique_gluing_mathlib, lem:isLimitPullbackCone_mathlib,
  lem:isLocalization_flat_mathlib}` in `lem:section_localization_descent_of_cover` — all pre-existing in
  this chapter.
- `\uses{lem:modules_pullback_mathlib, lem:modules_restrictFunctor_mathlib,
  lem:modules_restrictFunctorIsoPullback_mathlib, lem:over_restrict_pullback_iso}` in
  `lem:pullback_gamma_top_iso` — all pre-existing in this chapter.
- `leandag build --json`: 0 unknown_uses; none of the three new blocks isolated (verified
  `leandag query --isolated --chapter Picard_QuotScheme`). `\begin`/`\end` balanced (209/209).

## References consulted
- `references/stacks-properties.tex` (L2152–2171) — verbatim statement of Stacks `lemma-invert-f-sections`
  (tag for §"Sections over principal opens"), copied into `% SOURCE QUOTE` for
  `lem:section_localization_descent_of_cover`.
- `references/stacks-properties.md` — index/contents map confirming the `lemma-invert-f-sections`
  location and that the `.tex` (not the `.md`) holds the verbatim source.
- `AlgebraicJacobian/Picard/QuotScheme.lean` (L1255–1325, L1600–1647) — confirmed the landed Lean keystone
  `isLocalizedModule_basicOpen_descent_of_cover` signature (`Hfr` hypothesis shape, the three fields), the
  P1 object-transport `isIso_fromTildeΓ_restrict_basicOpen`, and the real Mathlib names
  `TopCat.Sheaf.existsUnique_gluing'` / `TopCat.Sheaf.eq_of_locally_eq'` the proof uses (for the anchor
  `\lean{}` faithfulness check — read-only, not edited).

## Macros needed (if any)
- None. All commands used (`\Spec`, `\widetilde`, `\mathrm`, `\sqcap`, `\cref`, `\lean`, `\uses`,
  `\mathlibok`) already exist / are standard.

## Reference-retriever dispatches (if any)
- None. The directive's named source (`references/stacks-properties.tex`, `lemma-invert-f-sections`) was
  already on disk and contained the verbatim statement.

## Notes for Plan Agent
- The cover-form `% SOURCE QUOTE` cites the STATEMENT only (Stacks `lemma-invert-f-sections` /
  Hartshorne II.5.3); the proof is the project-internal finite-cover descent and deliberately does NOT
  route through the global affine equivalence (= gap1), so there is intentionally no
  `% SOURCE QUOTE PROOF` — same convention as the pre-existing named-form block.
- The `\lean{}` hint `AlgebraicGeometry.Scheme.Modules.gammaPullbackTopIso` for the section-transport
  lemma is a NAME SUGGESTION — no such Lean decl exists yet (it is the iter-036 prover target). The
  prover may rename; if so the `\lean{}` pin should be updated to match. The intended cleanest Lean
  shape is the general-open form `Γ((pullback j).obj M, V) ≅ Γ(M, j(V))` natural in `V`, of which the
  `⊤` form in the statement is the `V = ⊤` instance; the prover may prefer to state the natural-in-`V`
  version directly.
- The pre-existing `lem:existsUnique_gluing_mathlib` pins the UNPRIMED `TopCat.Sheaf.existsUnique_gluing`,
  whereas the landed cover-form Lean proof uses the PRIMED `existsUnique_gluing'` (and `eq_of_locally_eq'`,
  now anchored separately). The unprimed pin was left untouched (not my block to repoint); review may
  wish to either repoint it to the primed name or add a sibling primed anchor for full fidelity. Flagged,
  not changed.

## Strategy-modifying findings
None. The chapter's gap1 decomposition (C → P1 → D → assembly) is consistent with the landed Lean state;
the only change is making the D-layer modular (cover-form keystone + gated section-transport ingredient),
which matches the directive and the actual Lean source.
