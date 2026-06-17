# Blueprint Writer Report

## Slug
hdi

## Status
COMPLETE — all four directive items written with verbatim Stacks citations.

## Target chapter
blueprint/src/chapters/Cohomology_HigherDirectImage.tex (newly created)

## Changes Made
- **Coverage marker** `% archon:covers AlgebraicJacobian/Cohomology/HigherDirectImage.lean` placed at top (after `\label`).
- **Added definition** `\definition`/`\label{def:higher_direct_image}`/`\lean{AlgebraicGeometry.higherDirectImage}` — `R^i f_*\mathcal{F}` as the i-th right derived functor of `f_*`, realized as sheafification of `V ↦ H^i(f⁻¹(V), F|_{f⁻¹(V)})`. Source-quoted from the proof of Tag 02KG (the classical Čech/sheafified-presheaf description).
- **Added lemma** `\lemma`/`\label{lem:higher_direct_image_quasi_coherent}`/`\lean{AlgebraicGeometry.higherDirectImage_isQuasiCoherent}` — `R^p f_*F` quasi-coherent for `f` qcqs, `F` qc. Source: Tag 02KE part (1).
  - Proof sketch added: Y — induction principle on quasi-compact opens; affine base via relative affine vanishing; inductive step via relative Mayer–Vietoris.
- **Added lemma** `\lemma`/`\label{lem:higher_direct_image_affine_vanishing}`/`\lean{AlgebraicGeometry.higherDirectImage_affine_eq_zero}` — `f` affine ⇒ `R^i f_*F = 0` for `i ≥ 1`. Source: Tag 02KG.
  - Proof sketch added: Y — preimage of affine is affine ⇒ higher cohomology of qc sheaf on affine vanishes ⇒ sheafification of basis-vanishing presheaf is zero.
- **Added theorem** `\theorem`/`\label{thm:flat_base_change_higher}`/`\lean{AlgebraicGeometry.flatBaseChange_higherDirectImage_isIso}` — flat base change `g^*(R^i f_*F) ≅ R^i f'_*(g'^*F)` for `g` flat, `i ≥ 1`. Source: Tag 02KH (i≥1 case).
  - Proof sketch added: Y — reduce to affine target via quasi-coherence; reduce to algebra `H^i(X,F)⊗_A B → H^i(X_B,F_B)`; separated case via Čech complexes + flatness exactness; quasi-separated case via the two Čech-to-cohomology spectral sequences.

Each statement block carries `% SOURCE:` (with `(read from references/stacks-coherent.tex, L…)` parenthetical), `% SOURCE QUOTE:` (verbatim), and a visible `\textit{Source: …}` line; the two lemmas and the theorem each carry a `% SOURCE QUOTE PROOF:` block immediately before `\begin{proof}`.

## Cross-references introduced
- `\uses{def:higher_direct_image}` in both lemmas and the theorem — defined in this chapter. OK.
- `\uses{lem:higher_direct_image_affine_vanishing}` in proof of `lem:higher_direct_image_quasi_coherent` — defined in this chapter. OK.
- `\uses{lem:higher_direct_image_quasi_coherent}` in `thm:flat_base_change_higher` — same chapter. OK.
- `\uses{def:pushforward_base_change_map}` in `thm:flat_base_change_higher` — defined in `Cohomology_FlatBaseChange.tex` (verified present, line 36). OK.
- Chapter prose references `\ref{chap:Cohomology_FlatBaseChange}` — label verified present (FlatBaseChange line 2).

Note: the directive's `\uses` skeleton listed the theorem and `lem:higher_direct_image_quasi_coherent` but did not list a `\uses` on the quasi-coherence proof; I added `lem:higher_direct_image_affine_vanishing` there because the Stacks proof genuinely invokes relative affine vanishing in the affine-base step. This is a proof-internal dependency, consistent with the source.

## References consulted
- `references/stacks-coherent.md` — pointer/tag map: confirmed Tag 02KH = `lemma-flat-base-change-cohomology` (Lemma 30.5.2), two-part lemma with i≥0.
- `references/stacks-coherent.tex` — verbatim source for all four blocks:
  - L180–199 (Tag 02KG `lemma-relative-affine-vanishing`, statement + proof) — used for the definition's source quote (proof's sheafified-presheaf description) and for `lem:higher_direct_image_affine_vanishing`.
  - L741–803 (Tag 02KE `lemma-quasi-coherence-higher-direct-images`, statement parts (1)–(3) + proof of (1)) — used for `lem:higher_direct_image_quasi_coherent`.
  - L947–1018 (Tag 02KH `lemma-flat-base-change-cohomology`, statement + proof) — used for `thm:flat_base_change_higher`.
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — read for sibling style and to confirm `def:pushforward_base_change_map` / `chap:Cohomology_FlatBaseChange` labels.

## Tag→label verification (not in pointer file, verified in-source)
The pointer `references/stacks-coherent.md` only documented Tag 02KH. I confirmed the other two tags by matching the directive's stated statements against the labelled lemmas in the `.tex`:
- **02KG** ↔ `lemma-relative-affine-vanishing` (L181): "If `f` is affine then `R^i f_*F = 0` for all `i > 0`." — exact match to directive item 3.
- **02KE** ↔ `lemma-quasi-coherence-higher-direct-images` (L742): part (1) "higher direct images `R^p f_*F` are quasi-coherent on `S`." — exact match to directive item 2.
Both are standard Stacks tags for these statements; the verbatim quotes are copied character-by-character from the lines above.

## Macros needed (if any)
None. Verbatim quotes preserve the source's `\Spec`; rendered prose uses `\operatorname{Spec}` (as the sibling FlatBaseChange chapter does). No new macros introduced.

## Reference-retriever dispatches (if any)
None — all required source text was already on disk in `references/stacks-coherent.tex`.

## Notes for Plan Agent
- The pointer file `references/stacks-coherent.md` documents only Tag 02KH. Consider updating it to also list Tags 02KE (`lemma-quasi-coherence-higher-direct-images`, L741–757) and 02KG (`lemma-relative-affine-vanishing`, L180–185), now that this chapter cites them — would keep the tag→label map complete for future writers.
- The theorem's `\lean` target `flatBaseChange_higherDirectImage_isIso` and the higher base-change map are stated as "the higher-degree analogue of `def:pushforward_base_change_map`"; the Lean side will likely need a higher-degree base-change-map definition (the i≥1 analogue of `pushforwardBaseChangeMap`). The directive did not ask for a separate `def` block for that map, and I did not add one — flagging in case the scaffolder wants one before the prover lane attacks the theorem.
- `content.tex` wiring of `\input{chapters/Cohomology_HigherDirectImage}` is the planner's job (per directive out-of-scope); not done here.

## Strategy-modifying findings
None. The four results are provable as stated from the cited Stacks tags, and their use as engine foundations (CM-regularity / semicontinuity / m-regularity) is consistent with the strategy context given.
