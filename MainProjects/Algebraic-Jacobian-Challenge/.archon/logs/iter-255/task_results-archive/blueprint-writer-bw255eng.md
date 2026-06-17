# Blueprint Writer Report

## Slug
bw255eng

## Status
COMPLETE — the new chapter `Picard_LineBundleCoherence.tex` is written with all
four sub-steps C1–C4 as labelled blocks, each carrying a `\lean{...}` pin,
`\uses{...}` cross-references, and verbatim Stacks citations. The site-instance
chief unknown is recorded as an explicit `remark` block and a `% NOTE:`.

## Target chapter
blueprint/src/chapters/Picard_LineBundleCoherence.tex  (NEW file)

## Changes Made
- **New chapter** `\chapter{Coherence of locally trivial line bundles}`
  / `\label{chap:Picard_LineBundleCoherence}` with strategy note + `archon:covers`
  pointing at the (not-yet-existing) `AlgebraicGeometry/Picard/LineBundleCoherence.lean`.
- **Setup section** (`sec:lbc_setup`) — motivation: the Quot embedding needs the
  line bundle to be coherent (finitely presented); its input is a `Pic⁰` point
  whose carrier is already `IsLocallyTrivial`, so the Mathlib-scale
  invertible⟹loc-triv spreading-out is never crossed.
- **Site-instances section** (`sec:lbc_site_instances`) + **`\begin{remark}`
  `\label{rem:lbc_site_instances}`** — the C1 chief unknown: the three slice-site
  instances `HasSheafCompose` / `HasWeakSheafify` / `WEqualsLocallyBijective` on
  `J.over x` that `QuasicoherentData` demands, stated as a standing assumption to
  verify at scaffold entry. (Used `remark`, the defined theorem-like environment;
  `assumption` is not declared in `macros/common.tex`.)
- **C1 — `\lemma` `\label{lem:lbc_trivializing_cover}`**
  `\lean{…Scheme.LineBundle.IsLocallyTrivial.exists_trivializing_cover}` — turns
  pointwise `IsLocallyTrivial M` into an indexed affine open cover `{U_i}` with
  per-index trivialisation `e_i : M|_{U_i} ≅ 𝒪_{U_i}`.
  - Proof sketch added: Y (repackage the pointwise existential as an indexed family
    over `I := X`).
- **C2 — `\lemma` `\label{lem:lbc_chart_presentation}`**
  `\lean{…IsLocallyTrivial.chartPresentation}` — the trivial finite free
  presentation (`m=0, n=1`) of `𝒪_{U_i}`, transported along `e_i` to a finite
  presentation of `M|_{U_i}`; ties to `SheafOfModules.free`.
  - Proof sketch added: Y (rank-1 free is its own presentation; transport along iso).
- **C3 — `\theorem` `\label{thm:lbc_isFinitePresentation}`**
  `\lean{…IsLocallyTrivial.isFinitePresentation}` — the target:
  `IsLocallyTrivial M ⟹ M.IsFinitePresentation`, by assembling C1+C2 into a
  `QuasicoherentData` and applying `IsFinitePresentation.mk`.
  - Proof sketch added: Y.
- **C3 corollary — `\corollary` `\label{cor:lbc_isFiniteType}`**
  `\lean{…IsLocallyTrivial.isFiniteType}` — finite type + quasi-coherent are then
  free (`instIsFiniteTypeOfIsFinitePresentation`,
  `instIsQuasicoherentOfIsFinitePresentation`).
- **C4 — `\lemma` `\label{lem:lbc_rank_flat}`**
  `\lean{…IsLocallyTrivial.chart_free_rank_one}` — chart-local rank-1 + flatness
  record (each chart `≅ 𝒪_{U_i}`, free rank 1, flat over itself); with a `% NOTE:`
  that Mathlib has no `SheafOfModules`-level locally-free/flat predicate to
  instantiate globally, so the facts are recorded chart-locally as the Quot
  embedding consumes them.

## Cross-references introduced
- `\uses{def:line_bundle_on_product}` in C1 (statement + proof) — `def:line_bundle_on_product`
  exists in `Picard_LineBundlePullback.tex` (verified: `\label{def:line_bundle_on_product}`
  at L60 there). NB the chapter `Picard_LineBundlePullback.tex` also defines
  `\label{def:IsLocallyTrivial}` (L142) — C1/C4 conceptually rest on it; I linked the
  broader `def:line_bundle_on_product` per directive, but the plan agent may prefer
  `\uses{def:IsLocallyTrivial}` instead/in addition.
- `\uses{lem:lbc_trivializing_cover}` in C2, C3, C4 (intra-chapter).
- `\uses{lem:lbc_chart_presentation}` in C3 (intra-chapter).
- `\uses{rem:lbc_site_instances}` in C3 (intra-chapter).
- `\uses{thm:lbc_isFinitePresentation}` in the corollary (intra-chapter).

## References consulted
- `references/stacks-modules.tex` — verbatim quotes for:
  `lem:lbc_trivializing_cover` (Definition 17.25.1 "invertible module", L4046–4059);
  `lem:lbc_chart_presentation` (Definition of "finite presentation", §17.11,
  L1377–1392); `thm:lbc_isFinitePresentation` (Lemma 17.25.4 invertible ↔ locally
  free rank 1, L4159–4165); `lem:lbc_rank_flat` (Definition "(finite) locally free
  of rank r", §17.14, L2079–2094). Also read L2175–2194
  (`lemma-direct-summand-of-locally-free-is-locally-free`, which records "finite
  presentation as a summand") and the invertible-section proofs L4066–4198 for
  context.
- `references/stacks-modules.md` — confirmed Stacks tag assignments: §17.25 = Tag
  01CR, Definition 17.25.1 = Tag 01CS, Lemma 17.25.2 = Tag 0B8K, Lemma 17.25.4 =
  Tag 0B8M. (Tags for §17.11 finite-presentation / §17.14 finite-locally-free are
  not listed in the `.md`; I cited those by Stacks section/definition number +
  source line range rather than asserting an unverified numeric tag.)
- `analogies/engine252.md` — the C1–C4 decomposition and the cost-collapsing fact
  (read in full, per directive).
- `analogies/invertible-loctriv-bridge.md` — confirms the forward bridge is
  Mathlib-scale and off-path; grounds the strategy note.

## Mathlib API verified (for the `\lean{}` hints / prose)
Confirmed present at the pin via loogle:
`SheafOfModules.IsFinitePresentation`, `…IsFinitePresentation.mk`,
`SheafOfModules.QuasicoherentData` (fields `I`, `X`, `presentation`,
`localGeneratorsData`), `QuasicoherentData.IsFinitePresentation(.mk)`,
`instIsFiniteTypeOfIsFinitePresentation`,
`instIsQuasicoherentOfIsFinitePresentation`,
`SheafOfModules.Presentation` + `.ofIsIso` + `Presentation.quasicoherentData`.
All three site instances appear verbatim as hypotheses on these declarations
(`(J.over x).HasSheafCompose (forget₂ RingCat AddCommGrpCat)`,
`HasWeakSheafify (J.over x) AddCommGrpCat`,
`(J.over x).WEqualsLocallyBijective AddCommGrpCat`) — this is the basis for the
`rem:lbc_site_instances` chief-unknown flag.

## Macros needed (if any)
- None new. Used existing `\struct`, `\Pic`, `\Sheaf`, `\RingCat`, `\AddCommGrpCat`,
  `\HasWeakSheafify`, `\forget`. Wrote `IsLocallyTrivial`, `HasSheafCompose`,
  `WEqualsLocallyBijective`, `QuasicoherentData`, etc. as `\texttt{...}`/`\mathtt{...}`
  (no `\IsLocallyTrivial` macro exists; matched the `\texttt`/`\mathtt` style used in
  the sibling chapters). If the plan agent wants a `\IsLocallyTrivial` operator macro
  for uniformity across `Picard_LineBundlePullback` / `Picard_TensorObjSubstrate` /
  this chapter, that is a `macros/common.tex` edit (out of my write-domain).

## Reference-retriever dispatches (if any)
- None. `references/stacks-modules.{tex,md}` already contained every verbatim
  statement required.

## Notes for Plan Agent
- **content.tex registration needed.** The new chapter is NOT yet `\input` in
  `blueprint/src/content.tex` (out of my write-domain). Add
  `\input{chapters/Picard_LineBundleCoherence}` after the
  `Picard_LineBundlePullback` line (currently L25) so the chapter is not an orphan.
  blueprint-doctor will otherwise flag it.
- **Lean namespace correction.** The directive's example pin used
  `AlgebraicGeometry.Scheme.Modules.IsLocallyTrivial.isFinitePresentation`, but the
  predicate actually lives at `AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial`
  (`LineBundlePullback.lean:115`, inside `namespace AlgebraicGeometry / Scheme /
  LineBundle`). I pinned all five blocks under `Scheme.LineBundle`. Confirm this is
  the intended home when scaffolding `Picard/LineBundleCoherence.lean`.
- **Lean file does not exist yet.** `AlgebraicGeometry/Picard/LineBundleCoherence.lean`
  is to be scaffolded a later iter; the `archon:covers` line points at it
  prospectively. The chapter is written to be scaffold-and-prove-ready.
- **Chief de-risking step is the site instances** (`rem:lbc_site_instances`): the
  scaffolder's first action should be to check that `X.ringCatSheaf` inhabits
  `HasSheafCompose` / `HasWeakSheafify` / `WEqualsLocallyBijective` on every
  `J.over x`. Everything downstream is definitional bookkeeping.
- The `\lean{}` names for C1/C2/C4 (`exists_trivializing_cover`,
  `chartPresentation`, `chart_free_rank_one`) are suggestions; the scaffolder may
  rename. C3 (`isFinitePresentation`) and the corollary (`isFiniteType`) are the
  load-bearing names the Quot embedding will reference.

## Strategy-modifying findings
None. Drafting confirmed the `analogies/engine252.md` decomposition: the
`IsLocallyTrivial ⟹ IsFinitePresentation` route is elementary (cover + trivial
chart presentation + `QuasicoherentData` assembly) with no hidden Mathlib-scale
gap. The only Mathlib-scale obstruction (sheaf finite-presentation spreading-out)
lives strictly on the abandoned `IsInvertible` entry point, which this chapter
does not touch. The single open item is the site-instance resolution, recorded as
`rem:lbc_site_instances` — an instance-availability check, not a strategy change.
