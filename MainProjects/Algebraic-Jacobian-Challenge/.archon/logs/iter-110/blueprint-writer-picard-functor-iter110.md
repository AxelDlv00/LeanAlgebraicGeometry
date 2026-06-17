# Blueprint Writer Report

## Slug
picard-functor-iter110

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_Functor.tex

## Changes Made

- **Revised** `\uses{...}` list of the proof block of `\thm:Pic_representable` (line 38) — added `thm:SheafOfModules_pullback_tensorObj` and `thm:SheafOfModules_pullback_oneIso` so the proof block now explicitly records both halves of the named-deferred pair the closure transitively consumes. The pre-edit list contained neither oracle directly (only the umbrella `thm:Scheme_Pic_pullback`); the directive asked for both to appear, and adding both makes the dependency graph faithful to the iter-109 Lean state.
- **Revised** the "Inherited (post-C1) from Chapter~\ref{chap:Picard_LineBundle}" bullet in the "Mathlib gap" section (line 74) — replaced the stale single-oracle framing (which named only `SheafOfModules_pullback_tensorObj`) with a paired framing that records both `_tensorObj` (μ-iso, $f^*(M\otimes N)\cong f^*M\otimes f^*N$) and `_oneIso` (ε-iso, $f^*\mathcal O_Y\cong\mathcal O_X$) as siblings of the single missing `Functor.Monoidal (Scheme.Modules.pullback _)` instance. Added the simultaneous-collapse clause: when Mathlib lands `(SheafOfModules.pullback _).Monoidal`, the pair is replaced by canonical `MonoidalCategoryStruct.tensorObj`-comparison and `Monoidal.εIso` structure fields.
- **Revised** the "Pull-back gap" bullet in the "Post-C1 dependency note" subsection (line 84) — replaced the pre-iter-109 prose asserting that `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` bodies are sorry-bodied with the iter-109 truth:
  - the bodies are CLOSED by hand-construction with underlying function `Functor.mapSkeleton (Scheme.Modules.pullback f)`, bundled into a `MonoidHom` whose `map_mul'` is discharged by `thm:SheafOfModules_pullback_tensorObj` and whose `map_one'` is discharged by `thm:SheafOfModules_pullback_oneIso`; the final `f*` is `Units.map` of that MonoidHom;
  - the closure transitively consumes the pair `{_tensorObj, _oneIso}` and no other Mathlib gap on the pull-back side;
  - `Pic.pullback_id` and `Pic.pullback_comp` themselves use Mathlib's existing `Scheme.Modules.pullbackId` / `pullbackComp` plus the skeleton-of-iso projection used in `Pic.pullback`; they add no further oracle dependency;
  - `PicardFunctor.quotMap` now compiles cleanly against the now-closed equalities rather than against opaque sorries;
  - all `\texttt{Picard/LineBundle.lean:93,99,105}` line-number references in the bullet body have been dropped (the prose now identifies declarations by name, not by line).

## Cross-references introduced

- `\uses{thm:SheafOfModules_pullback_tensorObj}` and `\uses{thm:SheafOfModules_pullback_oneIso}` added to the proof block of `\thm:Pic_representable`. Both labels exist in `blueprint/src/chapters/Picard_LineBundle.tex` (lines 125 and 143 respectively, established in the iter-110 Picard_LineBundle.tex update).
- All cross-references in the revised bullets (`thm:SheafOfModules_pullback_tensorObj`, `thm:SheafOfModules_pullback_oneIso`, `thm:Scheme_Pic_pullback`, `def:Pic_functor`, `chap:Picard_LineBundle`) point to existing labels.

## Macros needed (if any)

None new. All math symbols used (`\Pic`, `\PicardFunctor`, `\Spec`, etc.) were already present in the chapter and use macros defined in `blueprint/src/macros/common.tex`.

## Reference-retriever dispatches (if any)

None. The directive's references (`analogies/c1-route.md`, the iter-110-updated `blueprint/src/chapters/Picard_LineBundle.tex`) provided sufficient grounding; no external sources needed.

## Notes for Plan Agent

The three explicit pieces in the directive are now aligned with the iter-109 Lean state. However, two other stale references to the pre-iter-109 framing remain in the chapter and were intentionally not edited (per the directive's "the rest of the chapter is in good shape and should NOT be touched" instruction). The plan agent may want a follow-up directive to clean these up if the blueprint-reviewer flags them:

1. **NOTE comment at line 10** (above `\definition{def:Pic_functor}`) — still says "transitively consumes the sorry-bodied $\mathrm{Pic.pullback}$ (\texttt{AlgebraicJacobian/Picard/LineBundle.lean:93}) ... hence transitively the named-deferred Theorem~\ref{thm:SheafOfModules_pullback_tensorObj} (\texttt{Picard/LineBundle.lean:82})". Three issues with this NOTE now:
   - "sorry-bodied $\mathrm{Pic.pullback}$" is stale — the body is now closed.
   - Only `_tensorObj` is mentioned; `_oneIso` is now also part of the transitive chain.
   - Line numbers (`LineBundle.lean:93`, `LineBundle.lean:82`, `Monoidal.lean:166`) have all shifted (or will shift) and the prose-line-number coupling is fragile.
2. **Closing paragraph at line 88** ("Consequently, \texttt{lean\_verify} on $\PicardFunctor$ ... exposes \texttt{sorryAx} chains rooted at \texttt{Picard/LineBundle.lean:93,\,82}...") — same line-number issues. Post-iter-109, the sorryAx chain on the pull-back side is rooted at `_tensorObj` and `_oneIso`, not at `Pic.pullback` itself (which is now closed). Should probably be reworded as "rooted at Theorem~\ref{thm:SheafOfModules_pullback_tensorObj} and Theorem~\ref{thm:SheafOfModules_pullback_oneIso}" (and similarly for the Monoidal.lean:166 mention).

These are local stale-state artifacts; they don't affect the dependency graph correctness (the `\uses{...}` cross-references and the body of the three edited bullets are now correct), but they will read as inconsistencies to a reviewer comparing the chapter against the Picard_LineBundle.tex revisions and the iter-109 Lean state.

## Strategy-modifying findings

None.
