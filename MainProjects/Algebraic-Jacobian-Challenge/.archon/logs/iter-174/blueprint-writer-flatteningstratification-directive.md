# Blueprint Writer Directive

## Slug
flatteningstratification

## Target chapter
`blueprint/src/chapters/Picard_FlatteningStratification.tex` (NEW)

## Lean file this chapter is the blueprint for
`AlgebraicJacobian/Picard/FlatteningStratification.lean` (NEW — does not yet exist; you write the chapter ONLY; the file-skeleton lane fires iter-175+).

Add the standard `% archon:covers AlgebraicJacobian/Picard/FlatteningStratification.lean` line at the top of the file.

## Strategy context

This chapter covers Route A.2.a in the project's positive-genus arm. The flattening stratification of a coherent sheaf is the geometric construction that underpins the Quot/Hilbert scheme representability proof (Nitsure §4 → §5). It is **independently parallel-startable** (does NOT gate on A.1.a) — that's why it's first in the writer queue. Estimated downstream Lean burden: ~600–900 LOC, ~5–8 iters.

This is a NEW chapter (no prior version on disk). Write it from scratch.

## Required content

### Definition: coherent sheaf flatness over a base
Given a Noetherian scheme `S` and a coherent `O_X`-module `F` on a finite-type `S`-scheme `f : X → S`, define what it means for `F` to be `S`-flat. Cite Stacks 00HB. The Lean target predicate is `Module.Flat` (for the affine case) lifted to coherent sheaves.

### Definition: flattening stratification of a coherent sheaf
Statement (Nitsure §4, Theorem 4 / Stacks 052H): given a projective morphism `f : X → S` with `S` Noetherian and a coherent `O_X`-module `F`, there exists a finite stratification of `S` by locally-closed subschemes such that, on each stratum, the restriction of `F` becomes `S`-flat after base change to the stratum. Moreover, this stratification is universal: any base change `g : T → S` that makes `g* F` flat factors through one of the strata.

### Theorem: existence of the flattening stratification
The Nitsure §4 main theorem. State carefully:
- Input: `S` Noetherian, `f : X → S` projective, `F` coherent on `X`.
- Output: a finite collection of locally-closed immersions `i_α : S_α ↪ S`, disjoint, covering `S` set-theoretically, such that `(f × id)*_α F` is flat over `S_α`.
- Universality: any `g : T → S` such that `g* F` (along `f_T : X_T → T`) is `T`-flat factors uniquely through some `i_α`.

### Lemma: hypotheses can be relaxed (proper) for our setting
Note that we will apply this to `C ×_k T → T` for `C` a smooth proper curve over `k`. The Nitsure proof requires projectivity; for our case the curve `C` is automatically projective (smooth proper curve over a field). So instantiating Nitsure §4 for the curve case is direct.

### Mathlib status pointer
Confirm in prose that Mathlib (as of Mathlib master `b80f227`) does NOT have `Flatten` or `FlatteningStratification` for coherent sheaves. The closest are `Module.Flat` and `Mathlib.AlgebraicGeometry.Morphisms.Flat`. The new in-tree material includes:
- A `Scheme.QcohFlat` (or `CoherentSheaf.Flat`) predicate.
- The constructive existence proof of the stratification (Nitsure §4 verbatim Lean port).
- A `Scheme.QcohFlat.universalProperty` lemma giving the factorisation through strata.

### `\lean{...}` pins to add

The Lean file-skeleton lane (iter-175+) will need pinned declarations:
- `def:coherent_sheaf_flat` → `AlgebraicGeometry.Scheme.CoherentSheafFlat`
- `thm:flattening_stratification_exists` → `AlgebraicGeometry.flatteningStratification`
- `thm:flattening_stratification_universal` → `AlgebraicGeometry.flatteningStratification_universal`

Use `\lean{AlgebraicGeometry.<name>}` markers in each `\begin{definition}` / `\begin{theorem}` block.

### Sub-statements (optional but recommended)
If the proof of Theorem-existence is too long for a single block, split into sub-lemmas:
- `lem:flat_locus_open` — the flat locus is open (when `S` is Noetherian and `F` is finitely-presented).
- `lem:nonflat_locus_proper` — the non-flat locus is a proper closed subset, allowing Noetherian induction.
- `lem:noetherian_induction_strata` — closing the induction.

## Required citations

Each main block must include `% SOURCE:` + `% SOURCE QUOTE:` + `\textit{Source: …}` per the blueprint citation rules.

**Read source verbatim from**:
- `references/nitsure-hilbert-quot.pdf` §4 (the flattening stratification proper proof; "Theorem 4" or equivalent — locate via the TOC in `references/nitsure-hilbert-quot.md`).
- `references/stacks-coherent.md` tag 052H for the Stacks formulation.

The `% SOURCE QUOTE:` must be **verbatim**, in the source's original language (English for Nitsure and Stacks). Do NOT paraphrase. If the proof exceeds ~30 lines verbatim, sub-split as recommended above and quote each fragment.

## Out of scope

- Do NOT write the Lean file (`AlgebraicJacobian/Picard/FlatteningStratification.lean` does not exist; future iter prover scaffolds it).
- Do NOT pin Mathlib re-exports (`\mathlibok` is the review agent's domain).
- Do NOT add `\leanok` markers (deterministic sync owns those).
- Do NOT speculate beyond Nitsure §4 / Stacks 052H content.

## Verification

After writing, run `lake build` is NOT required — chapter files don't affect Lean compilation. The chapter is verified at next iter by `blueprint-doctor` (`\input` is added to `content.tex` by the plan agent, not you).

Also: add `\input{chapters/Picard_FlatteningStratification}` to `blueprint/src/content.tex` — **WAIT, this is the plan agent's job, NOT yours.** Don't touch `content.tex`. Just write the chapter file.

## Report format

Per blueprint-writer prompt template. Include "Notes for Plan Agent" section if you discover a strategy-modifying issue (e.g. Nitsure's projective hypothesis is stronger than what the project needs and a Mathlib gap is exposed by the proof structure).
