# Blueprint Writer Report

## Slug
picard-linebundle

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_LineBundle.tex

## Changes Made

- **Rewrote** the `Status note (Phase C1)` paragraph (formerly L17-27) into three new `\paragraph{...}` headings reflecting the post-iter-109 refactor state:
  - `Status note (Phase C1, post-refactor).` — documents the new Lean body `LineBundle X := (Skeleton X.Modules)ˣ`, cites `Mathlib.RingTheory.PicardGroup:407` and `Mathlib.CategoryTheory.Monoidal.Skeleton:80`, and records the universe note (`X.Modules : Type (u+1)`, no `Shrink` wrapper, downstream codomains bumped).
  - `Load-bearing transitive dependency on the monoidality of sheafification.` — discloses that every C1+ theorem transitively consumes `instIsMonoidal_W`, with cross-reference to the corresponding paragraph in Chapter~\ref{chap:Modules_Monoidal}.
  - `Pull-back gap.` — surfaces the new named-deferred Mathlib gap (Theorem~\ref{thm:SheafOfModules_pullback_tensorObj}) and cites `analogies/c1-route.md` (option (c)) and `STRATEGY.md` Phase~C1.

- **Revised** `\thm:Scheme_Pic_commGroup` proof sketch — replaced "tensor product of two invertible quasi-coherent sheaves..." prose with the typeclass-chain derivation (`BraidedCategory(X.Modules) ⇒ CommMonoid(Skeleton X.Modules) ⇒ CommGroup(Skeleton X.Modules)ˣ` via `Skeleton.instCommMonoid` + `instCommGroupUnits`). Updated `\uses` to include `thm:Modules_MonoidalCategory`. Replaced the pre-existing `% NOTE:` with a post-C1 version flagging the transitive `instIsMonoidal_W` dependency. `\leanok` markers left in place (the Lean body `inferInstanceAs ...` carries no direct sorry).

- **Revised** `\thm:Scheme_Pic_pullback` statement + proof sketch — statement rewritten to describe `f^* : Pic(Y) → Pic(X)` as "passing to invertible objects of the skeleton" via `Units.map ∘ Skeleton.monoidHom (Scheme.Modules.pullback f)`. Proof body rewritten to describe the named-deferral via `pullback_tensorObj`; added `\uses{thm:SheafOfModules_pullback_tensorObj}`. Replaced the pre-existing `% NOTE:` with a post-C1 version explaining that `Pic.pullback`, `Pic.pullback_id`, and `Pic.pullback_comp` are sorry-bodied.

- **Added theorem** `\thm:SheafOfModules_pullback_tensorObj` (`\lean{AlgebraicGeometry.Scheme.SheafOfModules.pullback_tensorObj}`) as a new top-level section "Monoidality of the categorical pull-back functor (Mathlib gap)" — names the missing iso `f^*(M ⊗ N) ≅ f^* M ⊗ f^* N`, references Stacks~01AC + Hartshorne~II §5 + the future-Mathlib collapse to `(SheafOfModules.pullback _).Monoidal`. `\uses{def:Modules_tensorObj, thm:Modules_MonoidalCategory}` on the proof block. `\leanok` added on the statement block only (per the directive's "newly-formalised sorry-bodied `def`" carve-out); no `\leanok` on the proof block.
  - Proof sketch added: Y (one paragraph, Mathlib-precedent-style).

- **Revised** "Use in the project" section — appended a paragraph noting that downstream consumers transitively depend on `instIsMonoidal_W` (load-bearing) and that the `Pic.pullback` arc additionally depends on `pullback_tensorObj`. Both surface in `lean_verify`'s axiom chain.

- **Revised** "Mathlib gap" section — expanded the "Mathlib has" bullet list (presheaf-side monoidal structure + sheafification, `Skeleton` machinery, `CommRing.Pic` precedent at line 407, `Scheme.Modules.pullback`). Expanded the "What is missing" bullet list to surface the `pullback_tensorObj` named gap and the load-bearing `instIsMonoidal_W` dependency, with the cross-reference to Modules_Monoidal.

## Cross-references introduced

- `\uses{thm:Modules_MonoidalCategory}` added on proof of `\thm:Scheme_Pic_commGroup` — verify `thm:Modules_MonoidalCategory` exists in `blueprint/src/chapters/Modules_Monoidal.tex:35` (confirmed).
- `\uses{thm:SheafOfModules_pullback_tensorObj}` added on proof of `\thm:Scheme_Pic_pullback` — the target label is introduced in the same chapter by this writer.
- `\uses{def:Modules_tensorObj}` and `\uses{thm:Modules_MonoidalCategory}` on the new `\thm:SheafOfModules_pullback_tensorObj` — both labels live in `Modules_Monoidal.tex` (L20 and L35 respectively).
- Several `\ref{chap:Modules_Monoidal}` cross-references in prose (no `\uses` semantics, just navigation aids).

## Macros needed (if any)

None. The chapter uses only `\Pic` (already defined in `macros/common.tex:25`), `\mathrm{...}`, `\otimes`, `\mathcal O_X`, `\bigl/\bigr`, and standard math/text constructs. I initially used `\texorpdfstring{...}{...}` in a paragraph heading but removed it on review to avoid introducing a hyperref dependency that no other chapter relies on.

## Reference-retriever dispatches (if any)

None. The directive said not to dispatch (the source material is fully covered by `analogies/c1-route.md` and the cited Mathlib files); I confirmed this was sufficient.

## Convention choice for sorry-bodied `\leanok` markers

The directive offered two options for `\thm:Scheme_Pic_pullback`'s `\leanok` markers given the sorry body:
(a) remove the marker from the proof block entirely; or
(b) keep `\leanok` on the statement block but remove from the proof block.

I cross-checked the project's existing pattern for sorry-bodied named-deferred theorems:
- `\thm:nonempty_jacobianWitness` in `Jacobian.tex:100-117` keeps `\leanok` on **both** the statement and proof block, even though its Lean body (`AlgebraicJacobian/Jacobian.lean:179`) is a literal `sorry`. The project's `\leanok` semantics, as actually applied by `sync_leanok`, certify well-formedness rather than full closure for named-deferred sorries.

I therefore **left the existing `\leanok` markers on `\thm:Scheme_Pic_pullback` in place** (statement + proof block) to match the established convention, and added `\leanok` only on the **statement block** of the newly-introduced `\thm:SheafOfModules_pullback_tensorObj` (per the directive's carve-out for "stating a new declaration is formalised — as a sorry-bodied def"). `sync_leanok`'s next run is the authoritative arbiter; the `% NOTE:` annotations make the post-C1 sorry status legible to human readers regardless of what `sync_leanok` decides.

## Notes for Plan Agent

- The new `\thm:SheafOfModules_pullback_tensorObj` block expects Lean declaration `AlgebraicGeometry.Scheme.SheafOfModules.pullback_tensorObj`. The current `AlgebraicJacobian/Picard/LineBundle.lean:82-86` declares it under namespace `AlgebraicGeometry.Scheme` with name `SheafOfModules.pullback_tensorObj`, i.e. fully qualified `AlgebraicGeometry.Scheme.SheafOfModules.pullback_tensorObj`. The `\lean{...}` hint matches.
- Cross-chapter consistency check (NOT touched per scope): `Picard_Functor.tex` and `Picard_FunctorAb.tex` likely still contain forward-compatibility notes referencing the pre-C1 approximation. Those chapters are slated for concurrent updates by their own writers this iter (per directive), so I did not touch them, but the plan agent should confirm those writers fire.
- Cross-chapter consistency check (NOT touched per scope): `Modules_Monoidal.tex` is being updated concurrently by `blueprint-writer modules-monoidal` to add the load-bearing-disclosure paragraph. My chapter cross-references that paragraph; if the modules-monoidal writer's edits land with different anchor text, my cross-reference still resolves through `\ref{chap:Modules_Monoidal}` (chapter-level) and remains valid even if specific subsections shift.
- The chapter now contains 5 declaration blocks (1 definition, 3 theorems with proofs, 1 remark) plus 3 itemize lists. LaTeX env begin/end balance verified by grep (3/3 theorems, 3/3 proofs, 1/1 definition, 1/1 remark, 3/3 itemize). Total chapter length: ~133 lines (was 99); growth is concentrated in the status-note + new theorem block + expanded Mathlib-gap section.

## Strategy-modifying findings

None. The directive accurately described the post-refactor Lean state, and the rewrite was a faithful prose alignment with that state plus the new named-deferred gap. No strategy-level surprises surfaced during writing — the four cost-lines flagged in `analogies/c1-route.md` (skeleton-units idiom, load-bearing `instIsMonoidal_W`, missing `Functor.Monoidal` on the pullback, hand-rolled inhabitants) are all already reflected in `STRATEGY.md` per the directive's framing.
