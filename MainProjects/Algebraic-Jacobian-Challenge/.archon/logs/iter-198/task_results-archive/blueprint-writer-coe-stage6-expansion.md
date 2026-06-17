# Blueprint Writer Report

## Slug
coe-stage6-expansion

## Status
COMPLETE — Stage 6 sub-decomposition added with three pinned sub-lemmas (6.A
Stacks 00OE smooth-algebra Krull-dim, 6.B Stacks 02JK cotangent/Kahler over
a field, 6.C assembly), a Mathlib API state audit, and a cascade-to-consumers
paragraph mapping each new sub-lemma to the L526/L723 sorries it unblocks.

## Target chapter
blueprint/src/chapters/Albanese_CodimOneExtension.tex

## Changes Made
- **Added subsection** `\subsection{Stage 6 sub-decomposition: 00OE + 02JK
  chain (iter-198)}` / `\label{subsec:stage6_subgap_decomposition}` —
  inserted between the existing Stage 5a/5b subsection
  (`subsec:kaehler_localisation_substrate`) and the
  `lem:smooth_to_regular_local_ring` lemma block. Houses the three new
  sub-lemmas plus the Mathlib audit + cascade paragraphs.

- **Added lemma** `\lemma`/`\label{lem:smooth_algebra_krull_dim_formula}` /
  intended pin
  `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}`
  — Stage 6.A, Stacks 00OE smooth-algebra Krull-dimension formula
  `dim_x X = dim S_q + trdeg_k κ(q)`. Pin name reflects the intended Mathlib
  signature (not yet present at b80f227). Statement-only, no proof block;
  geometric specialisation to the iter-193 stage-3 setup (closed point ⇒
  `trdeg = 0`, codim-1 generic point ⇒ `trdeg = n-1`) included as a
  paragraph after the bare statement.

- **Added lemma** `\lemma`/`\label{lem:cotangent_kahler_over_field}` /
  intended pin
  `\lean{Algebra.KaehlerDifferential.cotangent_iso_residue_tensor_kaehler}`
  — Stage 6.B, Stacks 02JK cotangent ↔ Kähler bridge over a field, with the
  split-short-exact refinement at a closed point of a `\bar k`-variety.
  Statement-only.

- **Added lemma** `\lemma`/`\label{lem:stage6_regular_stalk_assembly}` /
  intended pin
  `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth_aux}`
  — Stage 6.C, the regularity-conclusion assembly that consumes 5b + 6.A
  + 6.B and discharges the regular-local-ring claim at the standard-smooth
  stalk. Proof sketch included (4 numbered sub-steps); no separate
  `% SOURCE QUOTE PROOF:` block because the assembly is Archon-original
  (composition of three external pieces).

- **Added paragraph** "Mathlib API state (commit `b80f227`)" — itemised
  audit of the Mathlib pieces needed for 6.A/6.B/6.C, each marked
  EXISTS / MISSING / NEEDS-BRIDGE. Covers
  `Algebra.IsStandardSmoothOfRelativeDimension`, `Algebra.FormallySmooth`,
  `Algebra.Smooth`, `ringKrullDim`, `IsLocalization.AtPrime.ringKrullDim_eq_height`,
  the Stage 6.A name, the conormal-sequence right-exactness, the Stage 6.B
  name, `IsRegularLocalRing.iff_finrank_cotangentSpace`,
  `Algebra.IsSmooth.krullDim_stalk` (the missing direct shortcut), and
  `IsRegularLocalRing.localization_isRegularLocalRing`.

- **Added paragraph** "Cascade to consumers" — explicit list of the four
  sorries in `AlgebraicJacobian/Albanese/CodimOneExtension.lean` that
  Stage 6 closure propagates through:
  L526 (`isRegularLocalRing_stalk_of_smooth`),
  L547--L599 (`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`),
  L615--L644 (`localRing_dvr_of_codim_one`),
  L703--L723 (Step 1 of `extend_of_codimOneFree_of_smooth`).
  Also explicitly notes that L752--L798 (`indeterminacy_pure_codim_one_into_grpScheme`)
  is **not** gated on Stage 6 (its blocker is the Sub-step-4 pole/diagonal
  intersection lemma, recorded for chapter completeness only).

- **Revised** introductory pointer paragraph in the existing Stage 5a/5b
  subsection (the "Stage 6 ... is the open Mathlib gap" sentence) to now
  redirect the reader to the new
  `\cref{subsec:stage6_subgap_decomposition}` and the three named
  sub-lemmas, instead of the prior `% NOTE (iter-194)` block.

- **Revised** the `% NOTE (iter-194 reviewer)` block on
  `lem:smooth_to_regular_local_ring` — added an iter-198 follow-up NOTE
  listing the three new sub-lemma labels and cross-referencing
  `\cref{subsec:stage6_subgap_decomposition}` for the cascade. The
  iter-194 text itself is preserved (history record).

## Cross-references introduced
- `\uses{lem:rank_kaehler_localization_eq_relative_dim}` in
  `lem:smooth_algebra_krull_dim_formula` — verified, the cite target
  exists at L242 of the chapter.
- `\uses{lem:smooth_algebra_krull_dim_formula}` in
  `lem:cotangent_kahler_over_field` — internal to the new subsection.
- `\uses{lem:rank_kaehler_localization_eq_relative_dim,
        lem:smooth_algebra_krull_dim_formula,
        lem:cotangent_kahler_over_field}` in
  `lem:stage6_regular_stalk_assembly` — internal, plus the
  Stage 5b reference verified above.
- New `\cref{subsec:stage6_subgap_decomposition}` references in the
  Stage 5a/5b intro and in the iter-198 follow-up NOTE on
  `lem:smooth_to_regular_local_ring` — sub-section label was just added,
  so target exists.

## References consulted
- `references/stacks-algebra.tex` (L28206--28217)
  — verbatim quote for `\lem:smooth_algebra_krull_dim_formula`
  (statement of `lemma-dimension-at-a-point-finite-type-field`,
  the local equivalent of canonical Stacks tag 00OE).
- `references/stacks-algebra.tex` (L34087--34104) — verbatim quote
  (right-exact half) for `\lem:cotangent_kahler_over_field`
  (statement of `lemma-differential-seq`, the local equivalent of
  the right-exact portion of canonical Stacks tag 02JK).
- `references/stacks-algebra.tex` (L38724--38766) — verbatim quote
  (separable-residue refinement) for `\lem:cotangent_kahler_over_field`
  (the equality `dim_κ Ω_{R/k} ⊗_R κ = dim_κ m/m² + trdeg_k κ ≥ dim R
  + trdeg_k κ = dim_q S` inside the proof of `lemma-separable-smooth`,
  which is the strengthening of `lemma-differential-seq` at a
  separable residue point — content under canonical Stacks tag 02JK).
- `references/stacks-algebra.md` — cross-checked Stacks chapter
  metadata, large-file line-jump convention, and the
  `tags/tags`-mapping caveat for tag↔label cross-checks.
- `references/summary.md` — confirmed the Stacks-algebra chapter's
  position in the project's reference index and that the
  `tags/tags` map is not maintained locally (only the `\label{...}`
  layer is available in `.tex`, by which I cross-checked tag numbers
  in the writer's report rather than from the local source).

## Macros needed (if any)
None. All new content uses existing macros: `\Spec`, `\mathfrak`,
`\kappa`, `\Omega_{S/R}`, `\mathrm{trdeg}_k`, `\mathrm{rank}_R`,
`\mathcal O_{X, z}`, and the project's `\cref{...}` /
`\textit{Source: ...}` / `% SOURCE QUOTE:` discipline.

## Reference-retriever dispatches (if any)
None dispatched this round. The Stacks-algebra source already contained
the verbatim content for both Stacks 00OE (=
`lemma-dimension-at-a-point-finite-type-field` at L28206) and Stacks 02JK
(= `lemma-differential-seq` at L34087, plus the separable-residue
refinement inside `lemma-separable-smooth` at L38724). No retrieval
needed; tag↔label cross-checking was done by content-match against the
local file.

## Notes for Plan Agent
- **Tag↔label verification caveat.** The local `references/stacks-algebra.tex`
  carries `\label{...}` macros but not Stacks tag numbers (the
  `tags/tags` mapping file is not maintained locally). For Stages 6.A
  (Stacks 00OE) and 6.B (Stacks 02JK) I matched the canonical tag-name
  to the local label by content (`lemma-dimension-at-a-point-finite-type-field`
  ↔ 00OE; `lemma-differential-seq` + `lemma-separable-smooth` ↔ 02JK).
  The `% SOURCE:` parentheticals cite both the label and the canonical
  tag with the discipline note "tag-to-label cross-check not in the local
  `tags/tags` file". A follow-up retriever dispatch could fetch the
  upstream `tags/tags` to verify, but the verbatim content used in the
  `% SOURCE QUOTE:` blocks is taken character-by-character from the
  local file at the line ranges given, so the anti-fabrication
  discipline holds. Optional iter-199 cleanup: fetch
  `https://raw.githubusercontent.com/stacks/stacks-project/master/tags/tags`
  to the references folder and confirm the tag↔label mapping
  programmatically.
- **`Algebra.KaehlerDifferential.cotangent_iso_residue_tensor_kaehler`
  intended name.** The Mathlib `IsLocalRing.CotangentSpace` ↔
  `KaehlerDifferential` bridge does not exist at `b80f227` (per the
  iter-194/195/196 Lane M↓ comments in `CodimOneExtension.lean`). The
  intended pin name follows the project convention but is **not** yet
  resolvable; the next prover round should plan to add it.
- **`Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`
  intended name.** Long but follows the project's existing pattern
  (compare the established
  `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`).
  The prover may wish to shorten on landing; the blueprint pin can be
  retargeted later if a shorter Mathlib name lands first.
- **No `\leanok` / `\mathlibok` markers added** (per writer descriptor;
  the deterministic `sync_leanok` phase and the review agent own those
  semantically).
- **Out-of-scope items the directive flagged** (Stacks 0AVF
  depth-≥2 H¹ vanishing for Step 2 of `thm:codim_one_extension`;
  function-field-pullback machinery for `thm:weil_divisor_obstruction`;
  Milne Sub-step 4 pole/diagonal codim-1 lemma): not touched. The new
  "Cascade to consumers" paragraph explicitly excludes them from the
  Stage 6 collapse so the plan agent has a clear demarcation of what
  Stage 6 closure does and does not unblock.

## Strategy-modifying findings
None. The Stage 6 decomposition follows the strategy already pinned in
the chapter's iter-193/194/196/197 history; the iter-198 expansion is
purely a sub-gap enumeration so the iter-199+ prover can attack 6.A,
6.B, and 6.C as independent named targets rather than the monolithic
"Stacks 00TT" gap. No fact surfaced during the write-up contradicts
or qualifies any statement in `STRATEGY.md`.
