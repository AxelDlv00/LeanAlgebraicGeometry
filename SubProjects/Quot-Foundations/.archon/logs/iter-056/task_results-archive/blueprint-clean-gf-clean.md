# blueprint-clean report — gf-clean (iter-056)

**Target:** `blueprint/src/chapters/Picard_FlatteningStratification.tex`
**Scope:** open-immersion flat-descent route blocks (~L2173–2443)

## Summary

Five edits applied; all targeted at Lean leakage or redundant project-architecture commentary.
No `\leanok` markers, `\lean{}` pins, or `\label{}`s were touched.
No SOURCE/SOURCE QUOTE citations were added or removed for any `\mathlibok` block.

## Edits

### 1. `lem:gf_flat_of_isBaseChange_id` proof — removed project-architecture parenthetical
Stripped the `\emph{(This primitive is subsumed by \cref{lem:gf_flat_descend_isEpi}: ...)}` sentence.
It explained how the lemma fits into the generic-flatness assembly — project-strategy commentary,
not mathematics. The proof now reads as a single direct sentence.

### 2. `lem:gf_section_span_flat_descent` proof — removed `\mathrm{powers}` Lean notation
Replaced `as the away-localization \((\mathrm{powers}\,g)^{-1}\,\Gamma(\F, W)\)` with
`as the away-localization of \(\Gamma(\F, W)\) at \(g\)`.
The concept is already named "away-localization at g" in the lemma statement; the explicit
`Submonoid.powers`-formula was Lean leakage.

### 3. `thm:generic_flatness` proof, Step 1 — removed `[\mathrm{QuasiCompact}\,p]` typeclass bracket
Replaced `(by the \([\mathrm{QuasiCompact}\,p]\) hypothesis)` with plain prose:
"Since p is quasi-compact and U₀ is affine, hence quasi-compact, …"
The bracket is Lean instance-search notation, not mathematical language.

### 4. `thm:generic_flatness` proof, Step 4 — removed `(\mathrm{powers}\,\bar g)` Lean notation
Replaced `so source-localizing \((M_{j})_f\) at \((\mathrm{powers}\,\bar g)\)` with
`so localizing \((M_{j})_f\) at the powers of \(\bar g\)`.

### 5. `lem:gf_openImmersion_isEpi` proof — replaced "typeclass statement"
Replaced `as the typeclass statement \(\mathrm{Algebra.IsEpi}\,…\)` with
`as the ring-epimorphism property \(\mathrm{Algebra.IsEpi}\,…\)`.
"Typeclass" is Lean implementation language; "ring-epimorphism property" is the mathematical term.

## Blocks reviewed and found clean

- `lem:mathlib_flat_isBaseChange`: states the Mathlib result in project notation only; no proof
  obligation prose; no SOURCE QUOTE (correct for a `\mathlibok` block). ✓
- `lem:gf_flat_descend_isEpi` statement and proof: pure math prose. ✓
- `lem:gf_section_span_flat_descent` statement: pure math prose. ✓
- `thm:generic_flatness` statement and SOURCE QUOTE: appropriate — this is a Nitsure-sourced
  theorem, not a `\mathlibok` block; the citation is correct and required. ✓

## Status

PASS — region is clean; no further action required.
