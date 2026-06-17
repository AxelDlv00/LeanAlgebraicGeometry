# Blueprint Writer Directive

## Slug
modules-monoidal

## Iter
109 (Archon canonical)

## Target chapter
`blueprint/src/chapters/Modules_Monoidal.tex`

## Strategy context

Iter-109 (Archon canonical) fired the **Phase C1 promotion** of `Picard/LineBundle.lean`. The refactor lifted `LineBundle X` from `CommRing.Pic Γ(X, ⊤)` (global-sections approximation) to `(Skeleton X.Modules)ˣ` (the canonical sheaf-theoretic idiom mirroring `CommRing.Pic R`). This refactor changed the role of the project's deferred sorry `instIsMonoidal_W` (`Modules/Monoidal.lean:166`) from **dormant** (no active proof DAG consumed it pre-C1) to **load-bearing** (every C1+ theorem about `Pic` / `Pic.pullback` / `PicardFunctor` / `PicardFunctorAb` / downstream Jacobian arc transitively depends on it).

The iter-109 refactor also registered two new fresh instances in `Modules/Monoidal.lean`:

- `instBraidedCategoryPresheaf : BraidedCategory (PresheafOfModules X.ringCatSheaf.obj)` (after `instMonoidalCategory`).
- `instBraidedCategory : BraidedCategory (X.Modules)` (transported via `inferInstanceAs` from `Localization.Monoidal.Braided`'s instance on `LocalizedMonoidal`).

Both are no-content registrations exposing transitively-existing structure. The body of `instIsMonoidal_W` at `Modules/Monoidal.lean:166` is **unchanged**.

## Required updates to the chapter

The current `Modules_Monoidal.tex` describes monoidal structure on `X.Modules` accurately for the pre-C1 reality. Post-C1 the chapter has three categories of stale content:

### 1. Update the "Status of W.IsMonoidal" remark (currently around L59-61)

The chapter currently states "it does *not* block downstream consumers, which use `MonoidalCategory X.Modules` directly rather than `W.IsMonoidal` as a hypothesis." **This is post-C1 false.**

Replace the remark with a **load-bearing-disclosure paragraph** mirroring the pattern of `Jacobian.tex` for `\thm:nonempty_jacobianWitness`. The paragraph must say:

- Pre-C1: `instIsMonoidal_W` was dormant (no active proof DAG consumed it; downstream `LineBundle` ran on the `CommRing.Pic Γ(X, ⊤)` global-sections approximation).
- Post-C1 (iter-109): `instIsMonoidal_W` is **load-bearing** for the entire Pic-and-down arc:
  - `Picard/LineBundle.lean`'s `LineBundle X` carries `CommGroup` via `BraidedCategory (X.Modules)`, which goes through `Localization.Monoidal.Braided` requiring `(W X).IsMonoidal`.
  - All consumers — `Pic`, `Pic.pullback`, `Picard/Functor.lean`'s `PicardFunctor`, `Picard/FunctorAb.lean`'s `PicardFunctorAb`, the Jacobian instances, `AbelJacobi.lean`'s `ofCurve` — transitively depend on `instIsMonoidal_W` post-C1.
- `lean_verify` runs on these post-C1 declarations surface `sorryAx` in their axiom chains rooted at `Modules/Monoidal.lean:166`. This is **honest disclosure** of the named Mathlib gap, not a regression.
- Compare with the `\thm:nonempty_jacobianWitness` pattern: framework-conditional on a named deferred sorry, end-state semantics are well-formed APIs against the witness.

### 2. Add a paragraph describing the new `instBraidedCategory` instance

The chapter should now include a paragraph or remark introducing:

- `instBraidedCategoryPresheaf` — the presheaf-side `BraidedCategory` (transported from Mathlib's `Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal:145`'s `SymmetricCategory` via `inferInstanceAs`).
- `instBraidedCategory` — `BraidedCategory (X.Modules)` (transported via `inferInstanceAs` from `Localization.Monoidal.Braided`'s instance on the localization).

Both are project-side registrations exposing transitively-existing instances. The mathematical content is: the presheaf-of-modules category is symmetric monoidal, and the localized-monoidal machinery transports braided structure through sheafification.

Add `\lean{AlgebraicGeometry.Scheme.Modules.instBraidedCategory}` and `\lean{AlgebraicGeometry.Scheme.Modules.instBraidedCategoryPresheaf}` hints if naming a target.

### 3. Update L72 closing sentence on the "refinement is the content of Phase C step C1"

The chapter currently says "the refinement is the content of Phase C step C1 (see STRATEGY.md)". After iter-109 C1 lands, this prose is stale — the refinement has *happened*. Switch tense to past/perfect: "the refinement (carried out in iter-109, Archon canonical) is now in place; `LineBundle X := (Skeleton X.Modules)ˣ`. The load-bearing transition of `instIsMonoidal_W` is disclosed in Section X (or wherever you put the disclosure paragraph)."

### 4. Update L93-96 "Use in the project" (steps C1/C2/C3 description)

The current C1 description ("redefining `LineBundle X` as the type of invertible `O_X`-modules") uses the wrong (pre-C1) target name. Replace with `(Shrink (Skeleton X.Modules))ˣ` framing-correct version, then describe the iter-109 realization. The new chapter prose should say:

- **Step C1 (DONE, iter-109)**: `LineBundle X = (Skeleton X.Modules)ˣ` (without `Shrink`, since universe-pinning to `Type _` succeeded). New `instCommGroupLineBundle` via the typeclass chain `BraidedCategory (X.Modules)` → `Skeleton.instCommMonoid` → `instCommGroupUnits`. `Pic.pullback` re-derivation is gated on the new named-deferred sorry `SheafOfModules.pullback_tensorObj`.
- **Step C2**: re-derive `PicardFunctor` / `PicardFunctorAb` over the new `LineBundle`. Already partially absorbed in iter-109 (the universe bumps of `PicardFunctor` codomain `Type u → Type (u+1)` + `PicardFunctorAb` codomain `AddCommGrpCat.{u} → AddCommGrpCat.{u+1}`).
- **Step C3**: representability of the Picard scheme — deferred via `JacobianWitness` exit policy (see `Jacobian.tex`).

### 5. Update L100 "Formalization status"

The chapter currently describes `Monoidal.lean` as "the active target of Phase~C step~C0". Post-iter-109 the file's `instMonoidalCategory` is in place + the new `instBraidedCategory` is in place; the active deferred sorry is `instIsMonoidal_W` and is now load-bearing post-C1. Update the formalization status block to reflect dormancy → load-bearing transition.

## What is OUT of scope for this writer

- Do NOT touch `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Cohomology_MayerVietoris.tex`.
- Do NOT touch any `.lean` file. The refactor and the C1 firing are the source of truth; you describe them.
- Do NOT add `\leanok` to `instIsMonoidal_W` (its body is still `sorry`).
- Do NOT speculate about how `instIsMonoidal_W` will eventually be filled. The chapter discusses its post-C1 *role* (load-bearing) and the gap's mathematical content (stalks-of-presheaf-tensor for varying-ring `R₀`), not a future-work plan.
- Do NOT modify `blueprint/src/content.tex` or `blueprint/src/macros/common.tex`.

## References

- `analogies/c1-route.md` — the iter-108 mathlib-analogist's recipe for the load-bearing-transition disclosure.
- `STRATEGY.md` — Phase C1 row + Phase C0 row + End-state disclosure paragraphs.
- The current `AlgebraicJacobian/Modules/Monoidal.lean` (213 LOC) — primary source for the new project-side instances.
- `Jacobian.tex` — the model honest-disclosure paragraph (mirror its shape).

## Output

Per `.archon/subagents/blueprint-writer.md` body. Single chapter edit, report at `task_results/blueprint-writer-modules-monoidal.md`. Do NOT dispatch a child reference-retriever this iter.
