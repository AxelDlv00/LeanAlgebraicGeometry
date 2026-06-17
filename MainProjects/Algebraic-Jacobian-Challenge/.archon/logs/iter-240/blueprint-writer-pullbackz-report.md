# Blueprint Writer Report

## Slug
pullbackz

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Scope
Section `sec:tensorobj_pullback_monoidality` only. No other section touched.

## Changes Made
- **Revised** section intro (`sec:tensorobj_pullback_monoidality`) — replaced the
  dead "the general case uses the LEFT adjoint extendScalars which is strong
  monoidal sectionwise for any ring map" framing. New prose states: (1) `f^*` is the
  abstract left adjoint `(pushforward f).leftAdjoint` with NO sectionwise/stalkwise
  value formula, so a global sectionwise tensorator cannot be attached; (2) Mathlib
  ships only `Adjunction.rightAdjointLaxMonoidal` (opposite direction), so the oplax
  comparison maps on `f^*` are not free; (3) monoidality is therefore proven by
  **local-chart finality** (charts where pullback IS extension of scalars), then
  globalized. Added the one-sentence **FLAT-restricted fallback** note (projection
  `π_T`/base changes are flat) as a recorded reversing-signal, not the primary route.
- **Revised** proof of `lem:pullback_tensor_iso` (Phase 2 — the real gap) — rewrote
  into three parts: (a) construct the `pullbackObjTensorToTensor` comparison `δ`
  (not in Mathlib; built from the presheaf-level monoidal pullback moved across
  `SheafOfModules.sheafificationCompPullback`, RHS reconciled by the landed
  sheafification-monoidality brick); (b) prove it an iso by the SAME finality
  chart-chase as Phase 1 (`resLE`, `final_of_representablyFlat`, local comparison =
  `extendScalars` tensorator, globalize via `isIso_of_isIso_restrict`); (c) package
  via `Functor.CoreMonoidal.ofOplaxMonoidal` consuming `[IsIso η]` + `[IsIso (δ X Y)]`,
  noting the `OplaxMonoidal` structure on `pullback` is itself non-free (no
  `leftAdjointOplaxMonoidal`) and must be built by hand. `μIso`/`εIso` deliver the
  comparison isos.
  - Proof sketch added: Y (full rewrite of method, statement unchanged).
- **Revised** proof of `lem:pullback_unit_iso` (Phase 1 — cheap half) — replaced the
  circular "preserved by the strong-monoidal pullback of lem:pullback_tensor_iso"
  argument with the direct route: `SheafOfModules.pullbackObjUnitToUnit f` is iso
  under `Final` (`instIsIsoPullbackObjUnitToUnitOfFinal`, the `i7` step in
  `IsLocallyTrivial.pullback`); general `f` reduced to Final charts via `resLE` +
  `final_of_representablyFlat`, globalized by `isIso_of_isIso_restrict`. Noted the
  small remaining naturality lemma.
- **Kept intact** `lem:isinvertible_pullback` — statement, `\uses`, SOURCE/SOURCE
  QUOTE/SOURCE QUOTE PROOF blocks, and the composite proof
  (`pullbackTensorIso⁻¹ ≫ f^*e ≫ pullbackUnitIso`). Its prose carries no dead
  "extendScalars sectionwise" framing, so no edit was needed.
- **Kept verbatim** all three Stacks `% SOURCE` / `% SOURCE QUOTE` /
  `% SOURCE QUOTE PROOF` / `\textit{Source: …}` blocks (statements unchanged):
  `lemma-tensor-product-pullback`, `lemma-pullback-invertible`. Re-verified
  character-by-character against `references/stacks-modules.tex` (L2392-2400 and
  L4142-4157).

## Cross-references introduced
- `\uses{def:scheme_modules_tensorobj, lem:pullback_unit_iso}` added in proof of
  `lem:pullback_tensor_iso` — Phase 2 reuses Phase 1's finality chart-chase. Acyclic:
  `lem:pullback_unit_iso` does not use `lem:pullback_tensor_iso` (the prior circular
  reference was removed). Both labels exist in this same section.

## References consulted
- `references/stacks-modules.tex` — re-verified the verbatim `% SOURCE QUOTE` for
  `lemma-tensor-product-pullback` (L2392-2400) and the `% SOURCE QUOTE` +
  `% SOURCE QUOTE PROOF` for `lemma-pullback-invertible` (L4142-4157). All match the
  blocks already in the chapter; no changes to quotes.
- `analogies/pullback-monoidal.md` — sourced the precise Mathlib citations woven in
  as `\texttt{…}`: `instIsIsoPullbackObjUnitToUnitOfFinal`, `pullbackObjUnitToUnit`,
  `Functor.CoreMonoidal.ofOplaxMonoidal` (+ `μIso`/`εIso`), `rightAdjointLaxMonoidal`
  (and the non-existence of `leftAdjointOplaxMonoidal`), `sheafificationCompPullback`,
  `final_of_representablyFlat`, `pullbackComp`/`pullbackId`/`pullback_assoc`.

## Macros needed (if any)
None. Used only existing commands (`\mathtt`, `\texttt`, `\cref`, `\iota`,
`\mathbin{;}`, `\Scheme`, `\mathcal`).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The proof METHOD for all three lemmas is now Archon-original (local-chart finality),
  while the Stacks SOURCE blocks correctly cite only the unchanged STATEMENTS. No new
  external source was needed; no marker (`\leanok`/`\mathlibok`) was touched.
- Phase 2 explicitly records two non-free build obligations the prover must own: (i)
  the bespoke `pullbackObjTensorToTensor` comparison (no Mathlib tensorator on
  `pullback`), and (ii) the hand-built `OplaxMonoidal` structure on `pullback` (no
  `leftAdjointOplaxMonoidal`). If Phase 2 stalls, the prose names the flat-restricted
  `IsInvertible.pullback` fallback (projection/base-change maps are flat) — a plan-level
  reversing signal, not yet a separate blueprint lemma.

## Strategy-modifying findings
(none — the rewrite stays within the recorded Route-Z pivot; the flat-restricted
fallback is already a known reversing signal, not a new strategy change.)
