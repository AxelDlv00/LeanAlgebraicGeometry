# Blueprint Writer Directive

## Slug
picard-functorab-iter110

## Target chapter
blueprint/src/chapters/Picard_FunctorAb.tex

## Strategy context
Iter-109 (Archon canonical) introduced cascading universe bumps as part of the C1 promotion of `LineBundle`:
- `Picard/Functor.lean`: codomain `Type u` → `Type (u+1)` (to accept `Pic X : Type (u+1)` post-C1).
- `Picard/FunctorAb.lean`: codomain `AddCommGrpCat.{u}` → `AddCommGrpCat.{u+1}` (cascading from PicardFunctor's bump).

A side effect: `etaleSheafified` no longer needs to compose with the universe-lift functor `AddCommGrpCat.{u} → AddCommGrpCat.{u+1}` because the codomain is now in the higher universe directly. The body simplified by one functor composition.

The current Picard_FunctorAb.tex (L66 and L73) still describes the pre-iter-109 universe-lift composition as part of the `etaleSheafified` body. This contradicts Picard_Functor.tex L43 (which correctly notes "post-C1, the universe-lift is unnecessary"). The blueprint-reviewer-iter110 cross-chapter inconsistency note explicitly identifies Picard_FunctorAb.tex as the most likely stale chapter.

## Required content

Update the following pieces of the chapter to align with the iter-109 Lean state:

1. **L66 prose** ("`PicardFunctorAb` lands at `AddCommGrpCat.{u}`"): update to `AddCommGrpCat.{u+1}` and explain this is the post-iter-109 universe-bump cascade from `Picard/Functor.lean`'s codomain change.

2. **L73 prose** (describing the etale-sheafification body as composing with the natural universe lift `AddCommGrpCat.{u} → AddCommGrpCat.{u+1}`): update to reflect that this composition is no longer needed; the body simplifies by one functor composition. The current Lean state (`Picard/FunctorAb.lean`) confirms `etaleSheafified` body has been simplified accordingly.

3. **Any other place in the chapter that mentions the old universe lift composition**: hunt for and fix; should be local to L66-L73 but check surrounding paragraphs.

## Out of scope

- The definition `PicardFunctorAb` itself (forgetting from `PicardFunctor` to abelian groups) is unchanged in essence — only the codomain universe and the lift-composition language are post-iter-109 stale.
- The `\thm:Pic_representable` references in this chapter (if any) are downstream of `Picard_Functor.tex` and should remain consistent.
- Do NOT touch any `\lean{...}` hints — those are stable.
- Do NOT touch any `\leanok` markers.

## References
- `blueprint/src/chapters/Picard_Functor.tex` L43 — the *correct* version of the post-C1 universe-bump narrative (the contradiction reference).
- Iter-109's `task_results/Picard_LineBundle.lean.md` archive at `.archon/logs/iter-110/prover-iter109-LineBundle-report.md` documents the universe-bump cascade.

## Expected outcome

A focused 2-3 paragraph edit. Chapter goes from `correct: partial` to `correct: true` per blueprint-reviewer-iter110 must-fix.
