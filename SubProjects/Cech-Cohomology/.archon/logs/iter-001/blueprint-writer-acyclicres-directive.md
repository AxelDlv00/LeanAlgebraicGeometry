# Blueprint Writer Directive

## Slug
acyclicres

## Target chapter
blueprint/src/chapters/Cohomology_AcyclicResolution.tex  (NEW chapter — create it)

This chapter covers a NEW Lean file `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
(does not exist yet — you only write the `.tex`; the Lean stubs are created by a later
scaffolder). Put a `% archon:covers AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
line near the top.

## Strategy context

The project proves that the relative Čech complex computes the higher direct images
`R^i f_* F`. We have PIVOTED away from the spectral-sequence proof to the **acyclic-resolution
route** (Cartan–Leray acyclic-cover theorem). The mathematical heart of that route is one
abstract, scheme-independent homological-algebra theorem, which this chapter must state and
sketch:

> If `0 → A → J⁰ → J¹ → ⋯` is a resolution of `A` in an abelian category `𝒜` (with enough
> injectives) and each `Jⁿ` is right-`G`-acyclic for an additive functor `G : 𝒜 ⥤ ℬ`
> (i.e. `(G.rightDerived k).obj Jⁿ = 0` for all `k ≥ 1`), then the `n`-th right-derived
> functor of `G` at `A` is computed by the resolution:
> `(G.rightDerived n).obj A ≅ Hⁿ(G(J•))`.

It is applied later with `G = pushforward f : X.Modules ⥤ S.Modules`, `A = F`, and `J•` the
(augmentation-dropped) Čech complex; this is what replaces BOTH the Čech-to-cohomology and
the Leray spectral sequences. Building it here as a standalone, reusable lemma also enables
parallel prover work (the standing directive favours file splitting).

## Required content

Write a complete chapter with these blocks (use `\lemma`/`\theorem`/`\definition` as fits):

1. **Mathlib dependency anchor** (mark `\mathlibok`): the injective-resolution computation of
   the right-derived functor that Mathlib already provides, stated in the chapter's notation.
   `\lean{CategoryTheory.InjectiveResolution.isoRightDerivedObj}` (verify the exact name and
   signature with the `archon-lean-lsp` tools — `lean_local_search`/`lean_hover_info`; if the
   precise Mathlib name differs, use the real one and note it). This is the seed the
   acyclic-resolution generalization is proved from. Anchor only — do NOT mark the project's
   own to-be-proved lemmas `\mathlibok`.

2. **Definition** `\label{def:right_acyclic}` `\lean{...}` [expected name, e.g.
   `CategoryTheory.Functor.IsRightAcyclic`] — an object `J` is right-`G`-acyclic when
   `(G.rightDerived k).obj J = 0` for all `k ≥ 1`. (Pick the Mathlib-idiomatic shape; you may
   note alternatives for the planner.)

3. **The abstract comparison theorem** `\label{lem:acyclic_resolution_computes_derived}`
   `\lean{...}` [expected name, e.g.
   `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution`] — the statement above. Give a
   rigorous textbook proof sketch: the standard dimension-shifting / induction argument
   (truncate the resolution, use the long exact sequence of right-derived functors, the
   acyclicity of `Jⁿ` to kill the connecting terms, and induct on `n`), reducing the base case
   to the Mathlib injective-resolution anchor. Detail enough for a prover; name the Mathlib
   infrastructure each step needs (`Functor.rightDerived`, the long exact sequence /
   `δ`-functor of right-derived functors, `Abelian` machinery).

4. (Optional, if the proof naturally factors) sub-lemmas for the dimension-shift step, each
   with its own `\label`/`\lean{}`/`\uses` and a one-line sketch.

## `\uses` skeleton
- `lem:acyclic_resolution_computes_derived` uses `def:right_acyclic` and the `\mathlibok` anchor.

## Citation discipline

This is a CLASSICAL homological-algebra theorem (the acyclic-resolution / "Grothendieck's
theorem" comparison), NOT Archon-original. You MUST cite a real source with a verbatim
`% SOURCE QUOTE:`. If `references/` lacks a homological-algebra text, dispatch a
reference-retriever (your `--write-domain` authorizes `references/**`) for Weibel,
*An Introduction to Homological Algebra* (the acyclic-resolution corollary, ~§2.4, the
result that `F`-acyclic resolutions compute the derived functors), or Cartan–Eilenberg. Open
the retrieved file and quote it verbatim (original language, every symbol). Do NOT write a
`% SOURCE QUOTE:` from memory. The `\mathlibok` anchor block (item 1) needs no external
source — it is a Mathlib re-export.

## Out of scope
- Anything scheme-specific (the Čech complex, pushforward, the comparison theorem itself):
  those live in `Cohomology_CechHigherDirectImage.tex` and are handled by a sibling writer.
- Do NOT add `\leanok` markers (managed by the deterministic `sync_leanok` phase).
- Do NOT edit `content.tex` or any other chapter.

## References
- `references/stacks-coherent.md` → `.tex`: NOT the right source for this abstract lemma
  (it is scheme cohomology). You will likely need to retrieve a homological-algebra text.

## Expected outcome
A new self-contained chapter `Cohomology_AcyclicResolution.tex` stating the abstract
acyclic-resolution comparison theorem (with a Mathlib anchor for the injective-resolution
seed and a dimension-shifting proof sketch), ready for a scaffolder to turn into
`AcyclicResolution.lean` stubs. Flag in "Notes for Plan Agent" any uncertainty about the
exact Mathlib name/signature of `InjectiveResolution.isoRightDerivedObj` or the right-derived
long-exact-sequence API, so the planner can verify before scaffolding.
