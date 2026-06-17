# Blueprint Writer Report

## Slug
quot-cov

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made
Added the three missing blueprint blocks for the iter-031 gap1-bridge-C Lean declarations,
all placed in the `OverRestrictBridge` region alongside `lem:over_restrict_iso`. All three are
project-bespoke infra — no `% SOURCE` lines, no `\leanok` (per directive). Lean pins verified
against `AlgebraicJacobian/Picard/QuotScheme.lean` (defs at L930, L963, L990).

- **Added definition** `\definition`/`\label{def:over_restrict_equiv}`/`\lean{AlgebraicGeometry.Scheme.Modules.overRestrictEquiv}`
  — the step-3 module-category equivalence `SheafOfModules (O_X.over U) ≌ U.toScheme.Modules`.
  Placed just after `def:overEquivalence_sheafCongr`, before the `(C)` bridge comment.
  - Proof sketch added: Y — `pushforwardPushforwardEquivalence` applied to the site equivalence
    `Opens.overEquivalence U` (both legs continuous), ring-sheaf comparison = whiskered (co)unit +
    identity (step-2 holding by definitional equality), oriented via `.symm`.
  - `\uses{def:overEquivalence_sheafCongr, lem:opens_overEquivalence_mathlib,
    lem:pushforwardPushforwardEquivalence_mathlib, lem:overEquivalence_functor_isContinuous,
    lem:overEquivalence_inverse_isContinuous}` (statement + proof).
- **Added lemma** `\lemma`/`\label{lem:over_restrict_functor_iso}`/`\lean{AlgebraicGeometry.Scheme.Modules.overRestrictFunctorIso}`
  — functor-level identification `(pushforward 𝟙) ⋙ overRestrictEquiv.functor ≅ restrictFunctor U.ι`.
  Placed immediately after `def:over_restrict_equiv`.
  - Proof sketch added: Y — both sides are pushforward along the same opens functor
    (`eqv.inverse ⋙ Over.forget U = U.ι.opensFunctor`, definitional); identified via
    `pushforwardComp ≫ pushforwardCongr`. `pushforwardComp`/`pushforwardCongr` are NOT anchored in
    the chapter, so they are referenced in prose narrative (not via `\uses`), per directive.
  - `\uses{def:over_restrict_equiv, lem:modules_restrictFunctor_mathlib, lem:opens_overEquivalence_mathlib}`.
- **Added lemma** `\lemma`/`\label{lem:over_restrict_pullback_iso}`/`\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPullbackIso}`
  — pullback form `overRestrictEquiv.functor.obj (M.over U) ≅ (pullback U.ι).obj M`.
  Placed immediately after `lem:over_restrict_iso`'s proof, before the `(P1)` comment.
  - Proof sketch added: Y — compose `overRestrictIso U M` with `(restrictFunctorIsoPullback U.ι).app M`.
  - Prose explicitly notes this is the form consumed by the P1 transport
    `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`.
  - `\uses{lem:over_restrict_iso, lem:modules_restrictFunctorIsoPullback_mathlib, lem:modules_pullback_mathlib}`.
- **Fixed dependencies** `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (the P1 node) — added
  `lem:over_restrict_pullback_iso` to its `\uses{}` in BOTH the statement block and the proof block
  (per secondary task; the P1 transport consumes the pullback form).

## Cross-references introduced
- `\uses{def:over_restrict_equiv}` in `lem:over_restrict_functor_iso` and `lem:over_restrict_pullback_iso`
  → target exists (new, this chapter).
- `\uses{lem:over_restrict_pullback_iso}` in `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`
  → target exists (new, this chapter).
- All other `\uses{}` on the new blocks point at pre-existing blocks in this chapter
  (`def:overEquivalence_sheafCongr`, `lem:opens_overEquivalence_mathlib`,
  `lem:pushforwardPushforwardEquivalence_mathlib`, `lem:overEquivalence_{functor,inverse}_isContinuous`,
  `lem:modules_restrictFunctor_mathlib`, `lem:modules_restrictFunctorIsoPullback_mathlib`,
  `lem:modules_pullback_mathlib`, `lem:over_restrict_iso`).

## Secondary task — P1 dispatch-readiness check
- **All six required `\uses` labels on the P1 block resolve** to existing blocks in this chapter:
  `lem:presentation_map_mathlib` (L2805), `lem:quasicoherentData_bind_mathlib` (L2820),
  `lem:modules_pullback_mathlib`, `lem:isIso_fromTildeΓ_of_presentation_mathlib`,
  `lem:isLocalization_basicOpen_mathlib`, `lem:exists_finite_basicOpen_cover_le_quasicoherentData`
  (L2851). No missing labels.
- **Added** `lem:over_restrict_pullback_iso` to the P1 block's `\uses{}` (statement + proof) — done.

## Verification (leandag build --json)
- `unknown_uses`: **0** — no broken `\uses{}` introduced.
- All three new blueprint nodes are matched to their Lean pins (correct node types
  definition/lemma; `lean_name` = `overRestrictEquiv` / `overRestrictFunctorIso` /
  `overRestrictPullbackIso`). None isolated.
- Remaining `lean_aux` (coverage-debt) nodes after my edits are exactly three Grassmannian helpers
  (`AlgebraicGeometry.Grassmannian.rotMid`, `…transitionInvImageMatrix`, `…transitionInvPair`) —
  a DIFFERENT chapter's debt (GrassmannianCells), out of scope here. The overRestrict debt is cleared.
- LaTeX environment balance verified: `\begin`/`\end` counts equal (186/186); no env-name imbalance.

## References consulted
None — all three blocks are project-bespoke (no external source); statements/proofs grounded in the
Lean source `AlgebraicJacobian/Picard/QuotScheme.lean` (L909–994) only. No citation blocks written.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- I invented no labels — all three were named by the directive and match the live Lean decls exactly.
- No P1 `\uses` label failed to resolve.
- The blueprint block `lem:over_restrict_iso` describes the full 4-step bridge construction as its
  proof sketch, whereas the live Lean `overRestrictIso` is now just `(overRestrictFunctorIso U).app M`
  (the 4 steps now live in `overRestrictEquiv` + `overRestrictFunctorIso`). I did NOT edit
  `lem:over_restrict_iso` (out of scope); the new blocks `def:over_restrict_equiv` /
  `lem:over_restrict_functor_iso` now carry the step-3/step-4 decomposition. The over_restrict_iso
  prose remains mathematically correct as an overview but no longer mirrors the Lean proof structure
  1-to-1 — a future cleanup could trim its proof sketch to "object component of
  `lem:over_restrict_functor_iso`, composed in step 4". Flagging, not fixing.
- Separate (unrelated) coverage debt remains: 3 Grassmannian `lean_aux` nodes (rotMid,
  transitionInvImageMatrix, transitionInvPair) lack blueprint blocks in the GrassmannianCells chapter.

## Strategy-modifying findings
None.
