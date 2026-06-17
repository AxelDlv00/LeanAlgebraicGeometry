# Blueprint Writer Report

## Slug
Albanese_CodimOneExtension-cov273

## Status
COMPLETE — all 30 uncovered Lean declarations now have exactly one `\lean{}`-pinned
blueprint block; every new block is wired into the chapter's dependency cone (no
isolated nodes, no broken `\uses`), verified via `leandag`.

## Target chapter
blueprint/src/chapters/Albanese_CodimOneExtension.tex

## Verification (leandag build --json)
- `unknown_uses` = 0 (no broken `\uses`)
- isolated nodes in this chapter = 0 (`leandag query --isolated --chapter ...` → none)
- all 30 directive names previously listed as unmatched `lean-aux` are now matched;
  no remaining `unmatched_lean` entry belongs to `CodimOneExtension.lean`.
- LaTeX begin/end balanced (the only "extra" `\begin{lemma}` is inside a `%` comment).

## Blocks added (label + Lean pin)

### §2 (indeterminacy locus)
- `lem:isClosed_indeterminacy_locus` — `AlgebraicGeometry.Scheme.RationalMap.isClosed_indeterminacyLocus`

### Stages 1–4 (subsec:kaehler_localisation_substrate)
- `lem:stalkMap_flat_of_smooth` — `...Scheme.stalkMap_flat_of_smooth`
- `lem:exists_standardSmooth_at_of_smooth` — `...Scheme.exists_isStandardSmooth_at_of_smooth`
- `lem:exists_algebra_standardSmooth_stalk_localization` — `...Scheme.exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth`
- `lem:module_free_kaehler_standardSmooth` — `...Scheme.module_free_kaehlerDifferential_of_isStandardSmooth`

### Stage 6.B (cotangent ↔ Kähler finrank, after lem:cotangent_kahler_over_field)
- `lem:finrank_residue_kaehler_of_free_rank` — `...Scheme.finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq`
- `lem:finrank_residue_kaehler_of_standardSmooth_reldim` — `...Scheme.finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension`
- `lem:cotangent_iso_maximalIdeal_residue_kaehler` — `...Scheme.cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue`
- `lem:finrank_cotangentSpace_of_formallySmooth_residue` — `...Scheme.finrank_cotangentSpace_of_formallySmooth_residue`
- `lem:finrank_cotangentSpace_of_bijective_residue` — `...Scheme.finrank_cotangentSpace_of_bijective_algebraMap_residue`

### New subsec:codim1_substrate_lemmas (00OE / 00SW / bridges / Matsumura)
- `lem:ringKrullDim_localization_eq_height_atPrime` — `...Scheme.ringKrullDim_localization_eq_height_atPrime`
- `lem:mvPolynomial_maximalIdeal_height_ge_card` — `...Scheme.MvPolynomial.maximalIdeal_height_ge_card_of_field`
- `lem:mvPolynomial_maximalIdeal_height_le_natCard` — `...Scheme.MvPolynomial.maximalIdeal_height_le_natCard_of_field`
- `lem:mvPolynomial_maximalIdeal_height_eq_card` — `...Scheme.MvPolynomial.maximalIdeal_height_eq_card`
- `lem:mvPolynomial_maximalIdeal_height_eq_natCard` — `...Scheme.MvPolynomial.maximalIdeal_height_eq_natCard`
- `lem:ringKrullDim_localization_atMaximal_mvPolynomial` — `...Scheme.ringKrullDim_localization_atMaximal_MvPolynomial`
- `lem:ringKrullDim_quotient_add_eq_regular_sequence` — `...Scheme.ringKrullDim_quotient_add_eq_of_regular_sequence`
- `lem:ringKrullDim_quotient_localization_mvPolynomial_regular` — `...Scheme.ringKrullDim_quotient_localization_MvPolynomial_of_regular`
- `lem:submersive_relation_cotangent_linearIndependent` — `...Scheme.submersivePresentation_relation_cotangent_mk_linearIndependent`
- `lem:submersive_relation_cotangent_linearIndependent_localized` — `...Scheme.submersivePresentation_relation_cotangent_mk_linearIndependent_localized`
- `lem:exists_standardSmoothOfRelativeDimension_of_standardSmooth` — `...Scheme.exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`
- `lem:exists_submersivePresentation_of_standardSmoothReldim` — `...Scheme.exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension`
- `lem:isLocalization_atPrime_stalk_of_affineOpen` — `...Scheme.isLocalization_atPrime_stalk_of_affineOpen`
- `lem:open_eq_top_of_subsingleton` — `...Scheme.open_eq_top_of_subsingleton`
- `lem:gammaSpecField_ringEquiv` — `...Scheme.gammaSpecField_ringEquiv`
- `lem:quotSMulTop_quotientRing_linearEquiv` — `...Scheme.quotSMulTop_quotientRing_linearEquiv`
- `lem:isRegular_cons_of_quotient_ring` — `...Scheme.isRegular_cons_of_quotient_ring`
- `lem:matsumura_descent_cotangent` — `...Scheme.matsumura_descent_cotangent`
- `lem:matsumura_isRegular_of_linearIndependent_cotangent` — `...Scheme.matsumura_isRegular_of_linearIndependent_cotangent`

### Top consumer (before lem:smooth_codim_one_dvr)
- `lem:smooth_codim_one_maximalIdeal_principal` — `...Scheme.smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`

Each new block carries a one-line `\begin{proof}` (`Proved directly in Lean…`),
naming the parent result it is a sub-step of, per directive item 2. No `% SOURCE`
citations were added (all are internal substrate helpers under the already-cited
public API), and no `\mathlibok` was used (these are the project's own helpers, not
verbatim Mathlib re-exports).

## Cross-references introduced (wiring edges)

Edges follow the real Lean call graph.

In-edges added to existing public/hub blocks:
- `lem:smooth_to_regular_local_ring` `\uses{…}` += `lem:stalkMap_flat_of_smooth`,
  `lem:exists_algebra_standardSmooth_stalk_localization`,
  `lem:finrank_cotangentSpace_of_bijective_residue`, `lem:gammaSpecField_ringEquiv`,
  `lem:exists_standardSmoothOfRelativeDimension_of_standardSmooth`.
- `lem:smooth_algebra_krull_dim_formula` (proof `\uses`) +=
  `lem:ringKrullDim_localization_atMaximal_mvPolynomial`,
  `lem:ringKrullDim_quotient_localization_mvPolynomial_regular`,
  `lem:matsumura_isRegular_of_linearIndependent_cotangent`,
  `lem:exists_submersivePresentation_of_standardSmoothReldim`,
  `lem:submersive_relation_cotangent_linearIndependent_localized`.
- `lem:module_free_kaehler_localization` `\uses` += `lem:module_free_kaehler_standardSmooth`
  (Stage 5a freeness hypothesis supplied by Stage 4).
- `lem:smooth_codim_one_dvr` `\uses` += `lem:smooth_codim_one_maximalIdeal_principal`
  (its Lean proof consumes this helper).

Internal chains (out-edges on the new blocks):
- B: `lem:exists_algebra_standardSmooth_stalk_localization \uses
  {lem:exists_standardSmooth_at_of_smooth, lem:isLocalization_atPrime_stalk_of_affineOpen}`.
- C: `…_bijective_residue → …_formallySmooth_residue →
  {lem:cotangent_iso_maximalIdeal_residue_kaehler (→ lem:cotangent_kahler_over_field),
   lem:finrank_residue_kaehler_of_free_rank}`;
  `lem:finrank_residue_kaehler_of_standardSmooth_reldim \uses lem:finrank_residue_kaehler_of_free_rank`.
- D: `…_quotient_localization_mvPolynomial_regular →
  {…_localization_atMaximal_mvPolynomial (→ …_eq_height_atPrime, …_height_eq_natCard
   → …_height_eq_card → {…_ge_card, …_le_natCard}), …_quotient_add_eq_regular_sequence}`.
- E: `…_localized \uses …_linearIndependent`.
- F: `…_submersivePresentation_of_standardSmoothReldim \uses
  …_standardSmoothOfRelativeDimension_of_standardSmooth`;
  `lem:gammaSpecField_ringEquiv \uses lem:open_eq_top_of_subsingleton`.
- G: `matsumura_isRegular \uses {matsumura_descent_cotangent, isRegular_cons_of_quotient_ring}`;
  `isRegular_cons_of_quotient_ring \uses quotSMulTop_quotientRing_linearEquiv`.
- A/H: `lem:isClosed_indeterminacy_locus \uses def:indeterminacy_locus`;
  `lem:smooth_codim_one_maximalIdeal_principal \uses
   {lem:smooth_to_regular_local_ring, thm:ringKrullDim_stalk_eq_coheight}`.

Net result: `thm:codim_one_extension → lem:smooth_codim_one_dvr →
{lem:smooth_codim_one_maximalIdeal_principal, lem:smooth_to_regular_local_ring}` and
`lem:smooth_to_regular_local_ring`/`lem:smooth_algebra_krull_dim_formula`
transitively `\uses{}` all 30 new helpers.

## Literal REF placeholders fixed
0 — `grep` found no literal `REF` tokens in this chapter (directive item 4: none to fix).

## References consulted
None — no new external citation blocks were authored. Every new block is an internal
substrate helper under the chapter's already-cited public API (Milne 3.1/3.3, Stacks
00TT/00OE/02JK/00SW/00NQ), so per the descriptor the source lines are omitted and the
blocks stand on their one-line Lean-proved proof sketches. Faithfulness of each
informal statement was checked directly against the Lean signatures in
`AlgebraicJacobian/Albanese/CodimOneExtension.lean`.

## Notes for Plan Agent
- All 30 declarations' intents were determined directly from the Lean signatures +
  docstrings; none required guessing.
- Project-wide `leandag` still reports 47 `unmatched_lean` nodes, but **none** are in
  `CodimOneExtension.lean` — they belong to other chapters/files (out of this
  directive's scope).
- `lem:finrank_residue_kaehler_of_standardSmooth_reldim` (C2) is an alternative
  standard-smooth packaging not on the main `finrank_cotangentSpace` path; it is wired
  via an out-edge to `lem:finrank_residue_kaehler_of_free_rank` (non-isolated) but no
  existing result consumes it in Lean. Harmless, but a future reviewer may wish to note
  it is a parallel convenience form.

## Strategy-modifying findings
None.
