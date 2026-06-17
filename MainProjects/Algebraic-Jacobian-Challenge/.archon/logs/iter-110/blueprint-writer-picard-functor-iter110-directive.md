# Blueprint Writer Directive

## Slug
picard-functor-iter110

## Target chapter
blueprint/src/chapters/Picard_Functor.tex

## Strategy context
Iter-109 (Archon canonical) closed `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` in `AlgebraicJacobian/Picard/LineBundle.lean` via a hand-construction that consumes a **pair** of named-deferred Mathlib gaps (not a single oracle as initially planned): `SheafOfModules.pullback_tensorObj` (the `μ`-iso of an absent `(SheafOfModules.pullback _).Monoidal` instance) AND `SheafOfModules.pullback_oneIso` (the `ε`-iso, NEW iter-109). Both collapse together when a future Mathlib refresh lands the monoidal instance.

Picard_Functor.tex L84 ("Post-C1 dependency note") and L74 ("Inherited (post-C1) from Chapter Picard_LineBundle" bullet) reference only the single original oracle `pullback_tensorObj` AND describe `Pic.pullback`/`_id`/`_comp` bodies as still sorry-bodied. Both are stale post-iter-109. The current Picard_LineBundle.tex (just updated this plan-phase) records the pair `pullback_tensorObj` + `pullback_oneIso` in a refreshed `\thm:Scheme_Pic_pullback` proof block + a new `\thm:SheafOfModules_pullback_oneIso` block at the same level as `\thm:SheafOfModules_pullback_tensorObj`. This chapter must catch up.

## Required content

Update the following pieces of the chapter to align with the iter-109 Lean state (the rest of the chapter is in good shape and should NOT be touched):

1. **L84 "Post-C1 dependency note"**: replace the prose that asserts the three `Pic.pullback*` bodies are sorry-bodied with the iter-109 truth: the bodies are CLOSED via hand-construction through `(Scheme.Modules.pullback f).mapSkeleton`; the closure transitively consumes the pair (`SheafOfModules.pullback_tensorObj`, `SheafOfModules.pullback_oneIso`); `Pic.pullback_id` and `Pic.pullback_comp` themselves use Mathlib's `Scheme.Modules.pullbackId` / `pullbackComp` and add no further oracle dependency beyond what `Pic.pullback` already pulls in. Drop the line numbers (`Picard/LineBundle.lean:93,99,105`) — those have shifted and the prose should not depend on line numbers.

2. **L74 "Inherited (post-C1) from Chapter Picard_LineBundle" bullet**: update to record BOTH inherited gaps (`pullback_tensorObj` AND `pullback_oneIso`) explicitly. Frame them as a pair, mention that they collapse simultaneously when Mathlib lands `(SheafOfModules.pullback _).Monoidal`.

3. **`\uses{}` of `thm:SheefOfModules_pullback_tensorObj` in the `\thm:Pic_representable` proof block (L38)**: update to include both oracles. Reading the proof block's `\uses{...}` list and adding `thm:SheafOfModules_pullback_oneIso` is the only change required.

## Out of scope

- The `\thm:Pic_representable` proof block itself: the substantive content (representability via étale sheafification + the C3 deferral via `JacobianWitness` exit policy) is final. Only the `\uses{...}` list at the top of the proof body changes.
- The chapter's main definitions (`def:Pic_functor`, etc.) are intact and require no changes.
- The L43 step-C2 description noting "PicardFunctor lands in `Type (u+1)`, PicardFunctorAb in `AddCommGrpCat.{u+1}`" is CORRECT per iter-109's universe bumps; do not change it.
- Do NOT touch the cross-chapter `\thm:` blocks in `Picard_LineBundle.tex` — those are handled.

## References
- `analogies/c1-route.md` — persistent iter-108 mathlib-analogist rationale for the named-deferral pattern.
- `blueprint/src/chapters/Picard_LineBundle.tex` (just updated this iter) — the source of truth for what the inherited oracle surface looks like post-iter-109.

## Expected outcome

A focused 3-edit chapter refresh. No new theorem blocks, no new definitions, no proof-sketch restructuring. The chapter goes from `correct: partial` to `correct: true` per blueprint-reviewer-iter110 must-fix.
