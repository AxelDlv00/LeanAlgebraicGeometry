# Blueprint Writer Report

## Slug
tensorobj-pins

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:unitToPushforwardObjUnit_comp}`/`\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}` — pushforward-side (right-adjoint) composition coherence of the unit comparison `upu(h;f) = upu f ; (pushforward f).map(upu h) ; (pushforwardComp h f).hom`.
  - Proof sketch added: Y — sectionwise comparison; both sides reduce to the functoriality identity `(h;f)^♯ = h^♯ ∘ f^♯` of the structure-sheaf ring maps, holds definitionally. Inserted before `lem:pullback_unit_iso` (it is the input the mate transport consumes).
- **Added lemma** `\lemma`/`\label{lem:pullbackObjUnitToUnit_comp}`/`\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` — pullback-side (left-adjoint) composition coherence `pbu(h;f) = (pullbackComp h f).inv ; (pullback h).map(pbu f) ; pbu h`, the genuinely-new ingredient.
  - Proof sketch added: Y — adjunction-mate transport across the pullback–pushforward adjunction; transposing both sides reduces to `lem:unitToPushforwardObjUnit_comp` via conjugation of the pseudofunctoriality isos and the composite-adjunction unit; result follows by injectivity of the transpose. No Lean tactics / no instance-synthesis plumbing in prose.
- **Revised** `lem:pullback_unit_iso` proof sketch — replaced the closing "the small remaining work is the naturality lemma…" prose. Now: (a) `\uses{}` the two new sub-lemmas; (b) states the composition coherence is PROVED (cites both new lemmas); (c) names what is reused (per-chart factorization `V.ι;f = g;U.ι` with `g = f.resLE U V`, the `Final`-chart instance `instIsIsoPullbackObjUnitToUnitOfFinal`, the globalizer `isIso_of_isIso_restrict`); (d) records the SOLE remaining step as assembling the per-chart `IsIso (pbu (V.ι;f))` (composite of three isos from the coherence equation), transported across `restrictFunctorIsoPullback`, then globalized. Textbook-level prose, no `infer_instance`/synthesis mention.

## Cross-references introduced
- `\uses{lem:unitToPushforwardObjUnit_comp}` in `lem:pullbackObjUnitToUnit_comp` (statement + proof) — both labels defined in this same chapter.
- `\uses{lem:pullbackObjUnitToUnit_comp, lem:unitToPushforwardObjUnit_comp}` added to `lem:pullback_unit_iso` proof — both in this chapter.

## References consulted
None — both new blocks are Archon-original project infrastructure (the directive named no external source; the coherence lemmas stand on their proof sketches). No `% SOURCE` lines written. Verified the two Lean declarations exist and captured their exact statements/namespace from `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (lines 882, 923; namespace `AlgebraicGeometry.Scheme.Modules`).

## Macros needed (if any)
None — only standard `\mathrm`, `\mathtt`, `\cref`, `\Scheme` (already used throughout the chapter).

## Notes for Plan Agent
- The new lemmas precede `lem:pullback_unit_iso` so the dependency order in the typeset PDF reads input→consumer.
- The existing Stacks SOURCE QUOTE comments on `lem:pullback_tensor_iso` and `lem:isinvertible_pullback` were left byte-intact; no group-law / dual-bridge material touched.

## Strategy-modifying findings
None.
