# Blueprint Writer Directive

## Slug
picard-linebundle

## Iter
109 (Archon canonical)

## Target chapter
`blueprint/src/chapters/Picard_LineBundle.tex`

## Strategy context (the slice that matters for this chapter)

Iter-109 (Archon canonical) fired the **Phase C1 promotion** of `Picard/LineBundle.lean`. The refactor landed: the body of `LineBundle X` is now `(Skeleton X.Modules)ˣ` (Option A — bare form; no `Shrink` wrapper needed). The `instCommGroupLineBundle` derives via Lean's typeclass resolution from `BraidedCategory (X.Modules)` (the project registered a fresh `instBraidedCategory` in `Modules/Monoidal.lean` exposing the transitively-existing `Localization.Monoidal.Braided` instance), through `Skeleton.instCommMonoid` and `instCommGroupUnits`. The transitive dependency on the deferred `instIsMonoidal_W` is now **load-bearing** for every C1+ theorem.

For `Pic.pullback`: the refactor adopted analogist default option (c) — a top-level named-deferred sorry `SheafOfModules.pullback_tensorObj` for the iso `(Scheme.Modules.pullback f).obj (M ⊗ N) ≅ (Scheme.Modules.pullback f).obj M ⊗ (Scheme.Modules.pullback f).obj N`. `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` all carry `sorry`-bodies, pending closure of (or hand-construction equivalent to) the named gap.

Universe note: `LineBundle X` now lives in `Type (u+1)` (X.Modules lives in `Type (u+1)`, hence its skeleton's units do too). Downstream `PicardFunctor` and `PicardFunctorAb` codomains were bumped accordingly. No `Shrink` was required.

## Required updates to the chapter

The current chapter prose (especially the "Status note (Phase C1)" at L17-27 + the `Pic.pullback` proof sketch at L65-69) describes the pre-C1 global-sections approximation as the current Lean body. After iter-109's refactor this is **factually wrong**. The chapter must now describe the *current* (post-refactor) state and disclose the load-bearing `instIsMonoidal_W` + the new `SheafOfModules.pullback_tensorObj` named gap.

### 1. Rewrite "Status note (Phase C1)" (currently L17-27)

Replace it with a paragraph describing the *current* post-refactor state:

- The Lean body is `(Skeleton X.Modules)ˣ`, mirroring `CommRing.Pic R = Shrink (Skeleton (SemimoduleCat R))ˣ`.
- Cite `Mathlib.RingTheory.PicardGroup:407` for the ring-side precedent and `Mathlib.CategoryTheory.Monoidal.Skeleton:80` for `Skeleton.instCommMonoid`.
- Disclose the load-bearing transitive dependency on the deferred `instIsMonoidal_W` (`Modules/Monoidal.lean:166`): every theorem about `LineBundle X` / `Pic X` / `Pic.pullback` / `PicardFunctor` / `PicardFunctorAb` / downstream Jacobian arc transitively consumes this sorry. Refer the reader to the load-bearing-disclosure paragraph in `Modules_Monoidal.tex` (which `blueprint-writer modules-monoidal` is updating concurrently this iter).
- Mention the pullback gap: `Pic.pullback`'s body is `sorry`, pending closure of `SheafOfModules.pullback_tensorObj` (the named-deferred iso of monoidality of the categorical pullback functor `Scheme.Modules.pullback f`).
- Cite `analogies/c1-route.md` and `STRATEGY.md` Phase C1 row for the design rationale.

### 2. Update `\thm:Scheme_Pic_commGroup` proof sketch (L45-49)

The current sketch ("Tensor product of two invertible quasi-coherent sheaves is invertible quasi-coherent...") is still mathematically right but should now point to the *typeclass-chain* derivation that Lean uses:

- The `CommGroup` instance comes from `instCommGroupUnits` applied to `Skeleton.instCommMonoid`-of-`BraidedCategory (X.Modules)`.
- The mathematical content of "tensor product preserves invertibility" is baked into `Skeleton.instCommMonoid` + the localized-monoidal infrastructure.
- Add a single-line `% NOTE:` flagging the post-C1 transitive dependency on `instIsMonoidal_W`.

The existing `\leanok` mark remains valid (the `instCommGroupLineBundle` body compiles, modulo the load-bearing sorry chain).

### 3. Update `\thm:Scheme_Pic_pullback` proof sketch (L65-69)

The current body says "pull-back commutes with tensor product" — which is *the content the project doesn't have*. Rewrite:

- The eventual Lean definition is `Units.map (Skeleton.monoidHom (Scheme.Modules.pullback f))`, which requires `(Scheme.Modules.pullback f).Monoidal`.
- Mathlib b80f227 does not provide `Functor.Monoidal (Scheme.Modules.pullback f)`; the project surfaces the missing iso as a top-level sorry `SheafOfModules.pullback_tensorObj : (pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N`.
- `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` are currently sorry-bodied pending closure of (or hand-construction equivalent to) `pullback_tensorObj`.
- Add a `% NOTE:` flagging that `\leanok` no longer holds for `\thm:Scheme_Pic_pullback`: replace the existing `\leanok` mark inside the proof block with no marker, OR keep the marker on the statement block (signature/type-checks) and remove from the proof block. Use **whichever convention the chapter already uses for sorry-bodied theorems** (cross-check with `Jacobian.tex`'s `\thm:nonempty_jacobianWitness` and `Modules_Monoidal.tex`'s `instIsMonoidal_W` for the project's chosen pattern). Document your choice.

The existing `% NOTE:` comment at L53 already disclaims `\leanok` for the pre-C1 approximation; replace it with a post-C1 version.

### 4. Add a new `\begin{theorem}` block for `SheafOfModules.pullback_tensorObj`

This is the new top-level named gap introduced by the iter-109 refactor:

```latex
% NOTE: post-C1 named-deferred Mathlib gap. The body is `sorry`; the chapter's
% \leanok markers reflect well-formedness, not closure.
\begin{theorem}[Monoidality of the categorical pullback functor (Mathlib gap)]
  \label{thm:SheafOfModules_pullback_tensorObj}
  \lean{AlgebraicGeometry.Scheme.SheafOfModules.pullback_tensorObj}
  Let $f \colon X \to Y$ be a morphism of schemes and $M, N \in Y.\mathrm{Modules}$. Then the categorical pull-back functor $f^* = \mathrm{Scheme.Modules.pullback}\,f$ preserves tensor products:
  \[
    f^*(M \otimes_{\mathcal O_Y} N) \;\cong\; f^* M \otimes_{\mathcal O_X} f^* N.
  \]
\end{theorem}

\begin{proof}
  This is the standard statement that the inverse-image functor on $\mathcal O$-modules is monoidal. Mathlib provides $\mathrm{Scheme.Modules.pullback}\,f$ as a functor and has the analogous statement on the presheaf side, but \texttt{b80f227} does not register $\mathrm{Functor.Monoidal\,(Scheme.Modules.pullback\,f)}$. The proof goes by tensor-hom adjunction and the fact that the pull-back of the structure-sheaf-unit map is again a unit map; see Stacks~\texttt{01AC} (\S5 of Hartshorne~II for the affine local picture).
\end{proof}
```

Choose the label namespace consistent with existing chapter conventions (`thm:`, `def:`, etc.).

### 5. Update the "Mathlib gap" section (L82-99)

Add `SheafOfModules.pullback_tensorObj` to the list of "what is missing and supplied by this chapter" + the "what Mathlib has" section. Specifically:

- Add a bullet under "what is missing" naming the categorical-pullback monoidality gap.
- Cross-reference `Modules_Monoidal.tex` for the related `instIsMonoidal_W` gap.

### 6. Update the "Use in the project" section (L71-80)

Note that, post-C1, `Pic(X)` is consumed by `def:Pic_functor` and downstream Jacobian framework via its `CommGroup` instance, which carries the load-bearing `instIsMonoidal_W` and `pullback_tensorObj` named-deferred sorries through `lean_verify`'s axiom chain.

## What is OUT of scope for this writer

- Do NOT touch `Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Modules_Monoidal.tex`, `Cohomology_MayerVietoris.tex` — they are being updated by their own writers this iter (or in follow-up iters).
- Do NOT touch any `.lean` file. The refactor is the source of truth for the Lean state; you describe it.
- Do NOT modify `blueprint/src/macros/common.tex` unless you introduce a *new* non-standard command (which you should not need to — `\Pic`, `\mathcal O_X`, `\otimes` are all standard).
- Do NOT modify `blueprint/src/content.tex`. The `\input{chapters/Picard_LineBundle.tex}` line already exists.
- Do NOT add `\leanok` or `\mathlibok` markers gratuitously. `\leanok` is managed deterministically by the `sync_leanok` phase between prover and review; the writer adds it only when stating that a *new* declaration is formalised (which `pullback_tensorObj` is — as a `sorry`-bodied `def`).

## References

- `analogies/c1-route.md` — the iter-108 mathlib-analogist's recipe, including the universe-size discussion and the option (a)/(b)/(c) decision.
- `STRATEGY.md` — Phase C1 row + the post-refactor "Aggregate" + End-state disclosure paragraphs.
- The current `AlgebraicJacobian/Picard/LineBundle.lean` (109 LOC after iter-109 refactor) — primary source for the post-C1 Lean state.

## Output

Per `.archon/subagents/blueprint-writer.md` body. Single chapter edit, report at `task_results/blueprint-writer-picard-linebundle.md`. Do NOT dispatch a child reference-retriever this iter — the source material is already in `analogies/c1-route.md` and Mathlib.
