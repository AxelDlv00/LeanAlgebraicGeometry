# Blueprint Writer Report

## Slug
picard-functor

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_Functor.tex

## Changes Made

- **Revised** `\subsection{Forward-compatibility note (LineBundle approximation)}` (was at L75-77) → renamed to `\subsection{Post-C1 dependency note}` and entirely rewritten. The new subsection (a) declares the global-sections-approximation caveat resolved by the Phase~C1 refactor, (b) names the two transitively consumed sorries — the pull-back gap (rooted at `Picard/LineBundle.lean:93` blocking on `Picard/LineBundle.lean:82` = `thm:SheafOfModules_pullback_tensorObj`) and the monoidality-of-sheafification gap (`instIsMonoidal_W` at `Modules/Monoidal.lean:166`) — with file:line citations, (c) explains why `PicardFunctor.quotMap` compiles despite the sorry-bodied `Pic.pullback_id`/`Pic.pullback_comp` (statement-vs-unfolding distinction), (d) records the `lean_verify` axiom-chain expectation, and (e) restates that `thm:Pic_representable` is still deferred under the C3 exit policy (with the deferral prose itself untouched).

- **Revised** the Step~C2 enumerate item (L43) inside the `thm:Pic_representable` proof block. The pre-iter-109 phrasing "re-derive Pic.pullback, PicardFunctor, and the étale sheafification against the refined LineBundle" was replaced with the post-C1 narrower scope: (a) universe bumps already absorbed by `Picard/Functor.lean` and `Picard/FunctorAb.lean`, (b) remaining sorry-bodied declarations live in `Picard/LineBundle.lean` only, (c) closure waits on `thm:SheafOfModules_pullback_tensorObj`, and (d) `PicardFunctorAb.etaleSheafified` simplifies by one functor composition because `PicardFunctorAb` now lands in `AddCommGrpCat.{u+1}` directly, removing the pre-C1 `AddCommGrpCat.uliftFunctor` post-composition.

- **Added** `% NOTE: post-C1 (iter-109) ...` comment before the `def:Pic_functor` block (L10), disclosing the transitive sorry chain (`Pic.pullback` → `SheafOfModules.pullback_tensorObj`, plus `instIsMonoidal_W` for the underlying `CommGroup`). Clarifies that `\leanok` on the statement block certifies well-formedness, with the full dependency chain laid out in the "Post-C1 dependency note" subsection.

- **Added** a bullet to the "What is missing" itemize in `\section{Mathlib gap}` (L74) recording the named-deferred `thm:SheafOfModules_pullback_tensorObj` as the inherited (from `Picard_LineBundle`) Mathlib gap on `Functor.Monoidal (Scheme.Modules.pullback f)`, with the explicit downstream consumption path through `Pic.pullback` and `def:Pic_functor`.

## Cross-references introduced

- `\ref{thm:SheafOfModules_pullback_tensorObj}` — added in 4 places (the new `% NOTE:` comment, the revised Step~C2 enumerate item, the new "Mathlib gap" bullet, and the Pull-back-gap bullet of the new subsection). Target lives in `blueprint/src/chapters/Picard_LineBundle.tex` L86-95 (introduced post-C1, iter-109); verified present.
- `\ref{chap:Modules_Monoidal}` — added in the new subsection's monoidality-of-sheafification bullet. Sibling chapter, exists.
- `\ref{chap:Picard_FunctorAb}` — added in the closing paragraph of the new subsection. Sibling chapter, exists.
- `\ref{thm:Scheme_Pic_pullback}` — already referenced in the chapter; the new prose re-uses it. Target lives in `Picard_LineBundle.tex`.
- All other cross-references (`def:Pic_functor`, `chap:Picard_LineBundle`, `thm:Pic_representable`) reuse pre-existing labels.

No `\uses{...}` lists were modified (the directive did not request changes there; the existing `\uses` on `thm:Pic_representable`'s proof block already names `thm:Scheme_Pic_pullback` and `thm:Modules_MonoidalCategory`, which transitively pull in the new bullet content).

## Macros needed (if any)

None new. The chapter uses pre-existing macros (`\Pic`, `\PicardFunctor`, `\PicardFunctorAb`, `\Jac`, `\Spec`) and otherwise plain LaTeX math (`\mathrm{...}`, `\texttt{...}`, `\cong`, `\otimes_{\mathcal O_Y}`).

## Reference-retriever dispatches (if any)

None. The directive's source material (`analogies/c1-route.md`, the current `Picard/LineBundle.lean` / `Picard/Functor.lean` / `Picard/FunctorAb.lean`) was sufficient to write the chapter; no external mathematics was needed.

## Notes for Plan Agent

- **Out-of-chapter consistency observation (no fix attempted, per scope rule).** The closing paragraph of `Picard_LineBundle.tex` ("Use in the project") already cross-references `def:Pic_functor` and notes that all downstream consumers depend on `instIsMonoidal_W` and `thm:SheafOfModules_pullback_tensorObj`. The post-C1 disclosure in `Picard_Functor.tex` is now mutually consistent with that paragraph; no edit needed there.

- **`Picard_FunctorAb.tex` consistency observation.** The Lean file `Picard/FunctorAb.lean` already documents (in its file-docstring, lines 32-41) that the post-C1 universe bumps render the pre-C1 `AddCommGrpCat.uliftFunctor` post-composition unnecessary. If the iter-109 plan agent wants `Picard_FunctorAb.tex` to mirror this simplification at the blueprint level, that would be a separate writer dispatch — out of scope for this iter per the directive.

- **`thm:Pic_representable` deferral framing.** The directive instructed me not to touch the existing C3 deferral prose for `thm:Pic_representable`. I respected this — the proof block's overall framing ("Until steps~C0--C3 are complete, the Lean-side sorry remains; downstream consumers... `nonempty_jacobianWitness`") is unchanged. Only Step~C2's item was rewritten.

- **`% NOTE:` comment style.** I followed the pattern established by `Picard_LineBundle.tex` (sibling chapter, post-C1) which uses `% NOTE: post-C1 ...` immediately above the declaration block. Reviewers may want to standardize this idiom across other Phase~C-affected chapters (`Picard_FunctorAb.tex`, `Modules_Monoidal.tex`) for visual consistency, but that is out-of-scope for this writer.

- **Chapter length.** The chapter grew from 77 LOC to 88 LOC after the edits — still small. No structural concern.

## Strategy-modifying findings

None. The directive's framing (C1 promoted in iter-109; the prior global-sections-approximation caveat is resolved; the new named-deferred `SheafOfModules.pullback_tensorObj` propagates through `Pic.pullback` to consumers) was directly applicable, and writing the prose did not uncover any inconsistency between the strategy and the actual Lean state. `STRATEGY.md` does not need to change as a result of this edit.
