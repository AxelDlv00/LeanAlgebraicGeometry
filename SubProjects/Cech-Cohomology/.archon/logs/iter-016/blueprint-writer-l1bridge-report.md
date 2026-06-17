# Blueprint Writer Report

## Slug
l1bridge

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Revised proof of** `lem:cech_acyclic_affine` — inserted the L1 categorical→module
  bridge paragraph ("Identification of the abstract {\v C}ech complex with the
  localisation complex") into the existing `\begin{proof}...\end{proof}`. The statement
  block, its `\lean{...}` and `\uses{...}` were left untouched (frozen/correct). The
  paragraph makes explicit, at textbook rigor:
  1. For `𝒰 = (affineOpenCoverOfSpanRangeEqTop s hs).openCover`, the `i`-th piece is
     `Spec(A_{s_i}) → Spec A` = `D(s_i)`, and the `(p+1)`-fold intersection indexed by
     `σ : {0,…,p} → ι` is `D(s_σ)` with `s_σ = ∏_k s_{σ(k)} = s_{σ(0)}⋯s_{σ(p)}`
     (using `D(s_{i_0}) ∩ ⋯ ∩ D(s_{i_p}) = D(s_{i_0}⋯s_{i_p})`), sections the away
     localisation `A_{s_σ}`.
  2. `F = M~` quasi-coherent ⇒ `Γ(D(s_σ), F) = M_{s_σ}` (the `Localization.Away` /
     `IsLocalizedModule` localisation of `M` at the product `s_σ`), so the degree-`p`
     term of `CechComplex 𝒰 F` is `∏_{σ:{0,…,p}→ι} M_{s_σ}`.
  3. The abstract Čech differential (alternating sum of restrictions along the face
     inclusions `D(s_σ) ↪ D(s_{σ∘d_j})`) is, under this identification, exactly the
     alternating sum of localisation maps `M_{s_{σ∘d_j}} → M_{s_σ}`; the identification
     is an isomorphism of cochain complexes, so positive-degree vanishing
     `IsZero(Ȟ^p(𝒰,F))` of the abstract complex is equivalent to positive-degree
     exactness of the concrete localised complex — the content L2 (`exact_of_isLocalized_span`)
     + L3 (`combDifferential`/`combHomotopy`) supply, and the existing homotopy prose
     then proves.
- **Fixed dependencies** `lem:cech_acyclic_affine` (proof block) — extended the proof's
  `\uses{def:cech_complex}` to `\uses{def:cech_complex, def:standard_affine_cover}`, since
  the new paragraph references `def:standard_affine_cover` directly.

## Citation block added
- New `% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source: …}` inside the proof for the
  external fact `Γ(D(f), M~) = M_f`:
  Stacks Project, **Schemes**, Lemma `lemma-spec-sheaves` (Tag **01HV**), items (4) and
  (5), read from `references/stacks-schemes.tex` L691–719. The verbatim quote is a
  character-by-character copy of items (4)–(5) from that file (item (4): sections of
  `M~` over `D(f)` = `M_f`; item (5): restriction of `M~` along `D(g) ⊂ D(f)` is the
  localisation map `M_f → M_g` — the differential-compatibility ingredient).

## Cross-references introduced
- `\uses{def:standard_affine_cover}` added to the proof of `lem:cech_acyclic_affine` —
  `def:standard_affine_cover` exists in this same chapter (verified by leandag, 0
  unknown_uses).

## Verification
- `leandag build --json`: `isolated: 0`, `conflicts: []`, `unknown_uses: []`. No broken
  edges introduced; nothing left isolated.
- No literal `REF` in the chapter; `\begin{proof}`/`\end{proof}` of the lemma balanced;
  no interleaved math delimiters (prose uses `\(…\)` and `\[…\]` only). The new prose
  uses only `\operatorname{…}` and existing macros; the `\Spec`/`\widetilde` occurrences
  are confined to the `%`-comment verbatim quote (not typeset).

## References consulted
- `references/stacks-schemes.tex` — verbatim quote (items (4)–(5) of Lemma
  `lemma-spec-sheaves`, Tag 01HV, L691–719) for the `Γ(D(f), M~) = M_f` foundational
  fact and the restriction-map compatibility. Fetched this session via a
  reference-retriever child (see below).
- `references/stacks-coherent.tex` — reread L30–119 to confirm the existing
  standard-cover Čech identification ("Clearly the {\v C}ech complex … is identified
  with the complex ∏ M_{f_{i_0}} → …") that the L1 paragraph now justifies in detail.
- `references/summary.md` — reference index.

## Reference-retriever dispatches
- slug `stacks-schemes`: requested the Stacks "Schemes" chapter (`schemes.tex`) for the
  verbatim `Γ(D(f), M~) = M_f`. Status: **COMPLETE**. Downloaded
  `references/stacks-schemes.tex` (4914 lines) + pointer `references/stacks-schemes.md`;
  the key statement is Lemma `lemma-spec-sheaves` (Tag 01HV), items (4)–(5), L691–719.
  Row appended to `references/summary.md` by the retriever.

## Macros needed
- None. (The verbatim quote's `\Spec`, `\widetilde` live inside `%`-comments only.)

## Notes for Plan Agent
- The L1 paragraph asserts the degreewise identification is an *isomorphism of cochain
  complexes* `Ȟ^•(𝒰,F) ≅ (concrete away-localisation complex)`. This is exactly the
  bridge the Lean prover must transport: `CechAcyclic.affine`'s reduction of
  `IsZero (homology p)` of the categorical `CechComplex f 𝒰 F` to
  `combDifferential_exact` (L3) on `∏_{σ} M_{s_σ}` runs through this identification. The
  prose is now explicit about (i) the term identification `Γ(D(s_σ),F)=M_{s_σ}` and
  (ii) the differential compatibility — the two facts that were previously silent.
- No strategy-modifying findings.

## Strategy-modifying findings
None.
