# Blueprint Writer Directive

## Slug
picard-functor

## Iter
109 (Archon canonical)

## Target chapter
`blueprint/src/chapters/Picard_Functor.tex`

## Strategy context

Iter-109 (Archon canonical) fired the **Phase C1 promotion**, refactoring `Picard/LineBundle.lean`. The refactor required cascading universe bumps in `Picard/Functor.lean` (codomain `Type u → Type (u+1)`) and `Picard/FunctorAb.lean` (codomain `AddCommGrpCat.{u} → AddCommGrpCat.{u+1}`); both compile, no new sorries in either consumer file.

The current chapter `Picard_Functor.tex` has a "Forward-compatibility note (`LineBundle` approximation)" at L75-77 disclosing the global-sections-approximation issue. Post-C1 this note is stale: the approximation has been refined, but a *new* named-deferred sorry `SheafOfModules.pullback_tensorObj` has been introduced (`Picard/LineBundle.lean:82` post-C1) that the relative-Picard functor transitively consumes via `\thm:Scheme_Pic_pullback`.

## Required updates to the chapter

### 1. Replace the L75-77 Forward-compatibility note with a Post-C1 dependency note

Replace the existing prose that talks about the global-sections approximation with a paragraph naming the *new* named-deferred sorry:

- `Pic.pullback`'s Lean body is currently `sorry` (`Picard/LineBundle.lean:93`) pending closure of (or hand-construction equivalent to) `SheafOfModules.pullback_tensorObj` (`Picard/LineBundle.lean:82`).
- The relative Picard functor `PicardFunctor` (`def:Pic_functor`) inherits the dependency through `\thm:Scheme_Pic_pullback`. Post-C1, `quotMap`'s well-definedness (`fiberMap_well_defined`) still compiles because it reasons against the *statement* of `Pic.pullback_id` and `Pic.pullback_comp` (whose bodies are `sorry`), not their *computational* unfolding.
- `lean_verify` on `PicardFunctor` / `quotMap` surfaces `sorryAx` chains rooted at `Picard/LineBundle.lean:93, 82` (and indirectly at `Modules/Monoidal.lean:166` `instIsMonoidal_W`).

### 2. Update Step C2 description (around L43)

The current prose says "re-derive `Pic.pullback`, `PicardFunctor`, and the étale sheafification against the refined `LineBundle`". After iter-109, the *signatures* have been re-aligned (universe bumps) but the bodies that depend on `Pic.pullback`'s reduction are still pending (some carry `sorry` already at `Picard/LineBundle.lean:99, 105`). Re-phrase to say:

- Step C2's work is now narrower than pre-iter-109: the universe bumps have been absorbed (no work needed), but the `Pic.pullback`-dependent bodies (in `Picard/LineBundle.lean` only — not in this chapter's consumer files) need closure once `SheafOfModules.pullback_tensorObj` is resolved.
- The "étale sheafification" subpart of C2 has been simplified by the universe bumps: pre-C1, `etaleSheafified` post-composed `AddCommGrpCat.uliftFunctor.{u+1, u}` to reach `AddCommGrpCat.{u+1}` (to satisfy `HasSheafify`); post-C1, `PicardFunctorAb` already lands in `AddCommGrpCat.{u+1}` and the lift is unnecessary. The `etaleSheafified` body in `Picard/FunctorAb.lean` is simplified by one functor composition.

### 3. Add a brief mention of `SheafOfModules.pullback_tensorObj` in the "Mathlib gap" or similar section

If `Picard_Functor.tex` has a "Mathlib gap" section listing what the project supplies vs what Mathlib has, add a bullet:

- "Monoidality of the categorical pull-back functor on sheaves of `O_X`-modules": Mathlib b80f227 does not provide `Functor.Monoidal (Scheme.Modules.pullback f)`. The project surfaces this as `SheafOfModules.pullback_tensorObj` in `Picard/LineBundle.lean`, a named-deferred sorry inherited by `Pic.pullback` (= `f^*` on the Picard group), which `def:Pic_functor` consumes.

If no such section exists, place the bullet under the existing forward-compat note (now post-C1 dependency note from update 1).

### 4. Update `% NOTE:` comments and `\leanok` placement

Any `% NOTE:` comments that disclaim `\leanok` for the global-sections approximation are stale post-C1; replace with comments disclaiming `\leanok` for the post-C1 chain-of-sorries (`SheafOfModules.pullback_tensorObj` + `instIsMonoidal_W`).

`theorem :representable` (`thm:Pic_representable`) at the bottom of the chapter is **still deferred under the Phase C3 exit policy** (it's distinct from the iter-109 C1 firing). Do not touch its existing deferral prose; only update the "downstream of `LineBundle` approximation" sub-prose to reflect the post-C1 reality.

## What is OUT of scope for this writer

- Do NOT touch `Picard_LineBundle.tex`, `Picard_FunctorAb.tex`, `Modules_Monoidal.tex`, `Cohomology_MayerVietoris.tex`.
- Do NOT touch any `.lean` file.
- Do NOT modify `\thm:Pic_representable` (representability remains C3-deferred — separate from the iter-109 C1 firing).
- Do NOT modify `blueprint/src/content.tex` or `blueprint/src/macros/common.tex`.
- Do NOT add new theorem/definition blocks — only update existing prose.

## References

- `analogies/c1-route.md` — analogist rationale.
- `STRATEGY.md` — Phase C1 row + Phase C2 row + End-state disclosure paragraphs.
- The current `AlgebraicJacobian/Picard/LineBundle.lean` (109 LOC), `AlgebraicJacobian/Picard/Functor.lean` (183 LOC), `AlgebraicJacobian/Picard/FunctorAb.lean` (113 LOC) — primary sources for the post-C1 Lean state.

## Output

Per `.archon/subagents/blueprint-writer.md` body. Single chapter edit, report at `task_results/blueprint-writer-picard-functor.md`. Do NOT dispatch a child reference-retriever this iter.
