# Blueprint-writer directive — add the `quasiIso_τ₂` middle-term transfer + close P4 coverage debt

## Chapter to edit (ONLY this file)

`blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

## Strategy context (the slice that matters)

This chapter blueprints `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`, the abstract
homological-algebra lemma "a `G`-acyclic resolution computes `G.rightDerived`" (Stacks Tag 015E).
Over iters 004–005 the prover built, axiom-clean, the entire horseshoe construction EXCEPT the final
"the middle complex `I_B` resolves `B`" step (`lem:horseshoe_resolvesMiddle`,
`\lean{...ofShortExact_resolvesMiddle}`). That step is blocked on ONE missing Mathlib lemma, which we
are about to direct a prover to build. Your job is to give that build a proper blueprint home and to
close standing 1-to-1 coverage debt. Do NOT touch any Lean file. Do NOT add `\leanok` anywhere
(it is managed by a deterministic phase).

## Task 1 (PRIMARY) — add a new sub-lemma block: middle-term homology quasi-iso transfer

Insert a new `\begin{lemma}...\end{lemma}` + `\begin{proof}...\end{proof}` block in the section
"Lifting a short exact sequence to injective resolutions" (the `\subsection{The horseshoe
construction, step by step}`), placed immediately BEFORE `lem:horseshoe_resolvesMiddle` (it is a
prerequisite of it).

- **Label**: `lem:homology_quasiIso_tau2`
- **Human name**: "Middle-term quasi-isomorphism in a short exact sequence of complexes"
- **`\lean{}`**: `HomologicalComplex.HomologySequence.quasiIso_τ₂`
  (NOTE for the planner, not for you to act on: the prover may realize this as a small cluster —
  `mono_homologyMap_τ₂` / `epi_homologyMap_τ₂` / `isIso_homologyMap_τ₂` + the `quasiIso_τ₂` wrapper,
  mirroring Mathlib's `τ₃` family; if the names diverge the review agent repoints `\lean{}`.)
- **`\uses{}`**: `lem:homology_long_exact_sequence` (and nothing else — it depends only on the
  complex-level homology long exact sequence + the abelian four/five-lemma).
- **Provenance**: This is a **project-bespoke formalization helper filling an explicit Mathlib TODO**
  — no external mathematical SOURCE QUOTE is required; it stands on its proof sketch. State this
  plainly in the prose (e.g. "This lemma fills a stated Mathlib TODO; see the remark below."). Do
  NOT fabricate a citation. You MAY add a `% NOTE:` recording the Mathlib TODO verbatim (quoted
  below) since it documents why the lemma must be built project-side.

- **Statement to write** (project notation): Let `φ : S₁ ⟶ S₂` be a morphism between two short exact
  sequences of cochain complexes `0 → S.X₁ → S.X₂ → S.X₃ → 0` in an abelian category. If the two
  outer component maps `φ.τ₁ : S₁.X₁ → S₂.X₁` and `φ.τ₃ : S₁.X₃ → S₂.X₃` are quasi-isomorphisms,
  then the middle component `φ.τ₂ : S₁.X₂ → S₂.X₂` is a quasi-isomorphism. (This is the "2-out-of-3"
  property for quasi-isos in a short exact sequence of complexes, in the middle-term case.)

- **Proof sketch to write** (mathematical, no Lean tactics; detail enough to formalize): Apply the
  complex-level homology long exact sequence (Lemma `lem:homology_long_exact_sequence`) naturally to
  the morphism `φ`. This yields, for each degree `i`, a commuting ladder between the two long exact
  homology sequences whose vertical maps are `H^•(φ.τ_k)`. Fix a degree `i`. The five consecutive
  terms of the ladder centred at `H^i(S.X₂)` are
  \[ H^{i-1}(X₃) \xrightarrow{\delta} H^{i}(X₁) \to H^{i}(X₂) \to H^{i}(X₃) \xrightarrow{\delta} H^{i+1}(X₁), \]
  with vertical maps (left to right) `H^{i-1}(φ.τ₃)`, `H^{i}(φ.τ₁)`, `H^{i}(φ.τ₂)`, `H^{i}(φ.τ₃)`,
  `H^{i+1}(φ.τ₁)`. Since `φ.τ₁` and `φ.τ₃` are quasi-isomorphisms, the four outer verticals are
  isomorphisms; by the five lemma the middle vertical `H^{i}(φ.τ₂)` is an isomorphism. As this holds
  in every degree `i`, `φ.τ₂` is a quasi-isomorphism. (Formalization note for the prover, written as
  prose in the proof: the window spans two of Mathlib's `composableArrows₅` exactness windows — the
  one for the degree pair `(i-1, i)` and the one for `(i, i+1)` — and the `ℕ`-indexed degree-0
  boundary `i = 0` (no predecessor degree) is handled exactly as Mathlib's `τ₃` proofs handle their
  boundary, via a `by_cases` on the existence of a related degree.)

- **`% NOTE:` to attach** (verbatim Mathlib TODO, justifying the project-side build):
  `% NOTE: Mathlib's HomologySequenceLemmas.lean states only the four τ₃ lemmas; its docstring`
  `% reads: "So far, we state only four lemmas for φ.τ₃. Eight more similar lemmas for φ.τ₁ and`
  `% φ.τ₂ shall also be obtained (TODO)." The τ₂ transfer is therefore built project-side here,`
  `% modelled on Mathlib's mono_homologyMap_τ₃/epi_homologyMap_τ₃/isIso_homologyMap_τ₃/quasiIso_τ₃`
  `% (Mathlib/Algebra/Homology/HomologySequenceLemmas.lean), which use the abelian four-lemma`
  `% helpers from Mathlib.CategoryTheory.Abelian.DiagramLemmas.Four.`

## Task 2 (PRIMARY) — rewire `lem:horseshoe_resolvesMiddle` to consume the new lemma

The existing block `lem:horseshoe_resolvesMiddle` (currently `\uses{lem:horseshoe_chainMap,
lem:homology_long_exact_sequence}`) carries a review `% NOTE` saying its formalization needs a
middle-term quasi-iso transfer. Now that Task 1 supplies that transfer:

- Add `lem:homology_quasiIso_tau2` to its `\uses{}` (statement and proof).
- Update its proof sketch to make the formalization route explicit while keeping the existing
  mathematical content: the augmentation `\beta` assembles into a morphism of short exact sequences
  of complexes from `(\text{single}_0 A \to \text{single}_0 B \to \text{single}_0 C)` to
  `(I_A \to I_B \to I_C)` whose outer verticals are the resolution augmentations `I_A.\iota`,
  `I_C.\iota` — these are quasi-isomorphisms because `I_A`, `I_C` are injective resolutions. By the
  middle-term transfer (`lem:homology_quasiIso_tau2`) the middle vertical
  `\text{single}_0 B \to I_B` is then a quasi-isomorphism, i.e. `I_B` (with `\beta`) is a resolution
  of `B`; together with injectivity of its terms (`lem:horseshoe_biprod_injective`) it is an
  injective resolution of `B`. You may keep the prior "kill the flanking vanishing terms in the LES"
  paragraph as the conceptual justification, but the operative formalization step is the quasi-iso
  transfer. Trim/replace the stale review `% NOTE` that said the planner must still scaffold the
  transfer (it is now scaffolded as `lem:homology_quasiIso_tau2`).

## Task 3 (SECONDARY — 1-to-1 coverage hygiene; concise entries)

Several already-proven, axiom-clean declarations (built iters 004–005) have NO blueprint block, so
they are invisible to the dependency graph. Add a brief block for each (statement + `\label` +
`\lean{}` + accurate `\uses{}` + a one-to-three-line informal proof — trivial entries for structural
helpers are fine and expected). Group them sensibly; these are internal homological-algebra helpers,
project-bespoke (no external SOURCE QUOTE needed). Place them where they fit the narrative.

- `\lean{CategoryTheory.Functor.rightDerivedShiftIsoOfSplitResolutionSES}` — the resolution-level
  dimension-shift engine that `lem:acyclic_dimension_shift` specializes; give it label
  `lem:right_derived_shift_split_resolution` and fold it under the "dimension-shift" narrative as the
  precursor to `lem:acyclic_dimension_shift` (which should then `\uses` it). It takes a degreewise-split
  short exact sequence of injective resolutions with right-acyclic middle and produces the
  derived-functor shift isos at the resolution level (via Mathlib's `ShortComplex.ShortExact.δIso`).
- `\lean{CategoryTheory.shortExact_of_degreewise_splitting}` — a degreewise-split family of short
  complexes of complexes assembles to a short exact sequence of complexes. Label
  `lem:short_exact_of_degreewise_splitting`.
- `\lean{CategoryTheory.shortExact_map_mapHomologicalComplex_of_degreewise_splitting}` — an additive
  functor applied degreewise to a degreewise-split SES of complexes yields a SES of complexes
  (splitness is preserved by any additive functor). Label `lem:short_exact_map_of_degreewise_splitting`.
- `\lean{CategoryTheory.Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic}` — the
  homology of `G` applied to an injective resolution of a right-`G`-acyclic object vanishes in
  positive degrees. Label `lem:isZero_homology_map_of_acyclic`.
- The `TwistedBiprod` abstraction layer, if any of these lack a home after the existing
  `lem:horseshoe_dComp`/`lem:horseshoe_chainMap` blocks (which already name `twistedBiprodD_comp`,
  `twistedBiprodInl/Snd/Splitting`): only add blocks for genuinely unmatched names
  (`twistedBiprod`, `twistedBiprodD` as the carrier definitions). A single short
  `\begin{definition}` covering the twisted-biproduct complex carrier suffices; label
  `def:twisted_biprod`. Do not duplicate content already in the `_dComp`/`_chainMap` blocks.

If you are unsure whether a name is already covered by an existing block's `\lean{}` list, prefer NOT
adding a duplicate — note it in your report instead.

## Verified Mathlib facts you may rely on (do NOT re-verify; the planner confirmed these this iter)

- `HomologicalComplex.HomologySequence.quasiIso_τ₃`, `isIso_homologyMap_τ₃`, `mono_homologyMap_τ₃`,
  `epi_homologyMap_τ₃` exist in `Mathlib/Algebra/Homology/HomologySequenceLemmas.lean`; the τ₁/τ₂
  versions are an explicit stated TODO (quote above).
- The abelian four-lemma helpers (`mono_of_epi_of_mono_of_mono`, `mono_of_epi_of_epi_of_mono`,
  `epi_of_epi_of_epi_of_mono`) live in `Mathlib.CategoryTheory.Abelian.DiagramLemmas.Four`.
- The complex-level homology LES + connecting map (`ShortComplex.ShortExact.homology_exact₁/₂/₃`,
  `.δ`) are present (already the `\mathlibok` anchor `lem:homology_long_exact_sequence`).

## Out of scope (do NOT touch)

- The companion chapter `Cohomology_CechHigherDirectImage.tex` (P3/P5).
- Any `.lean` file. Any `\leanok` marker. The protected declaration list.
- The P4 dimension-shift theorem proofs `lem:acyclic_dimension_shift` /
  `lem:acyclic_resolution_computes_derived` mathematical content — leave their proofs intact; you may
  only ADD `\uses{lem:right_derived_shift_split_resolution}` to `lem:acyclic_dimension_shift` per
  Task 3.

## Report

List every block added/edited with its label, and flag any coverage-debt name you chose NOT to add a
block for (because it was already covered) so the planner can confirm.
