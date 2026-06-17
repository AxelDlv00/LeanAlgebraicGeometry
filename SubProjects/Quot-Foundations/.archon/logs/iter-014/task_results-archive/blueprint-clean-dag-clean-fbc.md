# Blueprint Clean Report — dag-clean-fbc
**Subagent:** blueprint-clean  
**Target:** `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`  
**Iteration:** 013  

---

## Summary

Full audit and clean pass on `Cohomology_FlatBaseChange.tex` (2292 lines). All Lean leakage in rendered text was removed; project history references were stripped; verbosity trimmed; LaTeX cross-references verified.

---

## Changes Made

### 1. Project history removal
- Removed `iter-003`, `iter-002` prefixes from `% NOTE` comments → `% NOTE`
- Removed `iter-012 effort-break` / `iter-011 prover identified` narrative from section separator comment block
- Replaced verbose `iter-012`-style section separator with clean mathematical summary

### 2. "Seam N:" scaffolding stripped
- Removed `[Seam 1: ...]`, `[Seam 2: ...]`, `[Seam 3: ...]` prefixes from three lemma titles (`lem:base_change_mate_unit_value`, `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose`)
- Updated cross-references in proof body from "Seam~N" narrative to `Lemma~\ref{...}` citations

### 3. Lean identifiers removed from rendered prose
The following Lean names appeared in rendered text outside `\mathlibok` blocks and were replaced with mathematical descriptions or `Lemma~\ref{}` citations:
- `\texttt{ModuleCat.extendRestrictScalarsAdj}` (from `lem:base_change_mate_unit_value` statement)
- `\texttt{Adjunction.homEquiv_counit}` (from two proof blocks)
- `\texttt{pushforwardBaseChangeMap}` (multiple occurrences in statements and proofs) → `Definition~\ref{def:pushforward_base_change_map}` or "the base-change map"
- `\texttt{gammaPushforwardTildeIso}` / `\texttt{gammaPushforwardIso}` → `Lemma~\ref{lem:gammaPushforwardTildeIso}`, `Lemma~\ref{lem:gammaPushforwardIso}`
- `\texttt{TensorProduct.AlgebraTensorModule.cancelBaseChange}` → `Lemma~\ref{lem:cancelBaseChange_mathlib}`
- `\texttt{cancelBaseChange_symm_tmul}` → "the inverse formula of Lemma~\ref{lem:cancelBaseChange_mathlib}"
- `\texttt{pullbackSpecIso}` in prose and display formulas → `Lemma~\ref{lem:pullbackSpecIso_mathlib}` / "the canonical isomorphism of Lemma~\ref{...}"
- `\texttt{pullbackSpecIso_hom_fst}`, `\texttt{pullbackSpecIso_hom_snd}`, `\texttt{_inv_fst}` → clean mathematical description
- `\texttt{pullbackSpecIso_hom_fst}` / `\texttt{pullbackSpecIso_hom_snd}` in proof of `lem:pullback_fst_snd_specMap_tensor` → replaced with narrative citing `Lemma~\ref{lem:pullbackSpecIso_mathlib}`
- `\texttt{algebraMap}`, `\texttt{CommRingCat.ofHom}` in proof body → removed (replaced by "definitional identification")
- `\texttt{ext}` tactic in proof of `lem:base_change_mate_section_identity` → removed
- `\operatorname{pullback.fst}` / `\operatorname{pullback.snd}` as Lean-specific identifiers in statements → replaced by "the first projection", "the second projection", or "the canonical projections (Lemma~\ref{...})"
- `\operatorname{pushforwardComp}` / `\operatorname{pushforwardCongr}` → "the pushforward pseudofunctor coherences"
- `(\texttt{through pullbackSpecIso})` parenthetical in proof → removed
- `\operatorname{restrictScalars}\psi` Lean notation → "the restriction of scalars along \(\psi\)"
- `\operatorname{extendScalars}\psi` / `\operatorname{LinearMap.lTensor} R'` → "extension of scalars along \(\psi\)"
- `\operatorname{Algebra.IsPushout.cancelBaseChange}` in proof body → replaced by `Lemma~\ref{lem:isPushout_cancelBaseChange_mathlib}`
- `\operatorname{Algebra.TensorProduct.leftAlgebra}` in proof body → replaced by mathematical description
- `\operatorname{LinearEquiv.toModuleIso}` in proof body → "promoting to an isomorphism of module objects"
- `\texttt{LinearMap.tensorEqLocusEquiv}` parenthetical in proof of main theorem → removed (lemma reference sufficient)

### 4. "Intended formalized signature" blocks removed
Two appendages to lemma statements that contained Lean type syntax were excised:
- `lem:base_change_map_affine_local`: ~25-line Lean-syntax block with `\mathrm{IsPullback}`, `h.w`, `[\mathrm{IsAffineHom}]`
- `lem:pushforward_base_change_mate_cancelBaseChange`: ~22-line block with `\texttt{pushforwardBaseChangeMap} f\ g\ f'\ g'\ h.w\ \widetilde{M}` Lean application syntax

### 5. `def:base_change_mate_inner_value` trimmed
The newly-added definition block (introduced in iter-012) was trimmed from ~31 lines to ~12 lines per the 1–3-line statement guideline. The verbose "codomain read"/"seam" cross-references were condensed to a single concise statement referencing `lem:base_change_mate_unit_value`.

### 6. Terminology cleanups
- "domain read" / "codomain read" jargon in statements and proofs → explicit isomorphism references `\(\Theta_{\mathrm{src}}\)` / `\(\Theta_{\mathrm{tgt}}\)` with `Lemma~\ref{}` citations
- Subsection title "Locality of isomorphisms for `\texttt{Scheme.Modules}` morphisms" → "Locality of isomorphisms for quasi-coherent sheaf morphisms"

### 7. Reformatted display formula for `lem:pullback_fst_snd_specMap_tensor`
Statement: replaced Lean display formula using `\operatorname{pullback.fst}`, `(\texttt{pullbackSpecIso}).\mathrm{hom}^{-1}`, `\texttt{\_hom\_fst}/\texttt{\_hom\_snd}/\texttt{\_inv\_fst}` with a clean `\begin{align*}` block mapping \(g'\) and \(f'\) to `\(\operatorname{Spec}\)` of explicit ring maps.

### 8. LaTeX / cross-reference hygiene
- Replaced one `\cref{}` with `Lemma~\ref{}` (in proof of `lem:pullback_isEquivalence_of_iso`)
- No literal `REF` tokens found
- No orphan `\uses{}` entries introduced
- No undefined macros introduced

---

## `\mathlibok` blocks left intact
The following blocks retain `\texttt{}` and Lean qualified names as documentation of the Mathlib API surface — this is appropriate:
- `lem:pullbackSpecIso_mathlib` (lines ~986–1009)
- `lem:cancelBaseChange_mathlib` (lines ~1011–1030)
- `lem:isPushout_cancelBaseChange_mathlib` (lines ~1032–1055)
- `lem:flat_preserves_equalizer_mathlib` (lines ~1944–1968)

---

## Mathematical statements not altered
The mathematical content of all main theorems and definitions was preserved verbatim. Only Lean leakage, project history, and stylistic/verbosity issues were addressed.

---

## Status
**CLEAN** — chapter passes blueprint-clean criteria.
