# Blueprint Writer Report

## Slug
Picard_FGAPicRepresentability-cov273

## Status
COMPLETE — all 16 uncovered Lean declarations now have exactly one `\lean{}`-pinned
blueprint block, each wired into the chapter's dependency cone (no isolated nodes,
no broken `\uses`, verified by `leandag`).

## Target chapter
blueprint/src/chapters/Picard_FGAPicRepresentability.tex

## Changes Made

Added a new section `\section{Typeclass scaffolding for the representability
assembly}` (`\label{sec:fga_pic_typeclass_scaffolding}`), inserted just before the
`Sorry-by-sorry closure order` section, containing one `\begin{definition}` block
per uncovered declaration. Each carries a one-to-three sentence mathematical
statement and a `\begin{proof} Proved directly in Lean. \end{proof}` (the
existence-witness instances add the clause naming the closure-order subsection
that carries their substantive obligation).

Blocks added (label + `\lean{}` name):

- `def:has_pic_sharp` — `AlgebraicGeometry.Scheme.PicScheme.HasPicSharp`
- `def:pic_sharp_carrier` — `AlgebraicGeometry.Scheme.PicScheme.picSharp`
- `def:inst_has_pic_sharp` — `AlgebraicGeometry.Scheme.PicScheme.instHasPicSharp`
- `def:has_div_functor` — `AlgebraicGeometry.Scheme.PicScheme.HasDivFunctor`
- `def:div_functor_carrier` — `AlgebraicGeometry.Scheme.PicScheme.divFunctor`
- `def:inst_has_div_functor` — `AlgebraicGeometry.Scheme.PicScheme.instHasDivFunctor`
- `def:has_abel_map` — `AlgebraicGeometry.Scheme.PicScheme.HasAbelMap`
- `def:inst_has_abel_map` — `AlgebraicGeometry.Scheme.PicScheme.instHasAbelMap`
- `def:has_smooth_proper_quotient` — `AlgebraicGeometry.Scheme.PicScheme.HasSmoothProperQuotient`
- `def:inst_has_smooth_proper_quotient` — `AlgebraicGeometry.Scheme.PicScheme.instHasSmoothProperQuotient`
- `def:has_pic_scheme` — `AlgebraicGeometry.Scheme.HasPicScheme`
- `def:inst_has_pic_scheme` — `AlgebraicGeometry.Scheme.instHasPicScheme`
- `def:pic_sharp_representable` — `AlgebraicGeometry.Scheme.PicScheme.PicSharpRepresentable`
- `def:inst_pic_sharp_representable` — `AlgebraicGeometry.Scheme.PicScheme.instPicSharpRepresentable`
- `def:pic_scheme_group_object` — `AlgebraicGeometry.Scheme.PicScheme.PicSchemeGroupObject`
- `def:inst_pic_scheme_group_object` — `AlgebraicGeometry.Scheme.PicScheme.instPicSchemeGroupObject`

No external `% SOURCE` citations were added: these are project-internal carrier
helpers (Prop-valued existence predicates, their `Classical.choice`/`Classical.choose`
extractions, and their existence instances), not restatements of Mathlib results,
so no `\mathlibok` anchor applies either.

## Cross-references introduced (wiring)

**New blocks' internal `\uses{}` (out-edges):**
- `def:pic_sharp_carrier` → `\uses{def:has_pic_sharp}`
- `def:inst_has_pic_sharp` → `\uses{def:has_pic_sharp}`
- `def:div_functor_carrier` → `\uses{def:has_div_functor}`
- `def:inst_has_div_functor` → `\uses{def:has_div_functor}`
- `def:has_abel_map` → `\uses{def:div_functor_carrier, def:pic_sharp_carrier}`
- `def:inst_has_abel_map` → `\uses{def:has_abel_map}`
- `def:inst_has_smooth_proper_quotient` → `\uses{def:has_smooth_proper_quotient}`
- `def:has_pic_scheme` → `\uses{def:pic_sharp_carrier}`
- `def:inst_has_pic_scheme` → `\uses{def:has_pic_scheme}`
- `def:pic_sharp_representable` → `\uses{def:pic_sharp_carrier, def:pic_scheme}`
- `def:inst_pic_sharp_representable` → `\uses{def:pic_sharp_representable}`
- `def:pic_scheme_group_object` → `\uses{def:pic_scheme}`
- `def:inst_pic_scheme_group_object` → `\uses{def:pic_scheme_group_object}`

(`def:has_pic_sharp`, `def:has_div_functor`, `def:has_smooth_proper_quotient` have
no out-edge but receive in-edges from their extraction/instance/public consumers,
so none is isolated.)

**Existing public results wired to the carriers (in-edges, the preferred direction):**
- `lem:line_bundle_quot_correspondence` (abelMap) `\uses{}` += `def:has_abel_map, def:div_functor_carrier, def:pic_sharp_carrier`
- `thm:fga_pic_representability` (representable) `\uses{}` += `def:pic_sharp_representable`
- `lem:smooth_proper_quotient` (smoothProperQuotient) — added `\uses{def:has_smooth_proper_quotient}` (it had none)
- `thm:pic_is_group_scheme` (groupSchemeStructure) `\uses{}` += `def:pic_scheme_group_object`
- `def:pic_scheme` (PicScheme) `\uses{}` += `def:has_pic_scheme`

End state: each public result transitively `\uses{}` its carrier, and each carrier
chain (`Has* → carrier-def/inst*`) is connected to the public cone. `leandag`
confirms: 0 isolated nodes in the chapter, 0 unknown_uses, 0 unmatched_lean for the
16 names; all 16 report `covered = True`.

## Literal-REF placeholders fixed
**0 in prose.** The chapter contains three literal `REF` tokens (file lines ~356,
~429, ~502), but all three lie inside `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:`
LaTeX *comments* reproducing Kleiman's source text verbatim ("Exercise~REF",
"Definition~REF"). These are not rendered prose and the verbatim-citation rule
forbids altering them, so they were left untouched. No `REF` appears in any
rendered prose in this chapter.

## References consulted
None — all 16 added blocks are project-internal carrier scaffolding with no
external-source citation; no `references/` file was opened.

## Declarations whose intent could not be determined
None. Every signature and docstring was read directly from
`AlgebraicJacobian/Picard/FGAPicRepresentability.lean`; the informal statements
are faithful to the Lean types (Prop-valued existence predicates, their
`Classical`-extracted carriers, and the existence instances).

## Macros needed (if any)
None added by me. I used only macros already defined in
`blueprint/src/macros/` (`\Pic`, `\Sch`, `\Spec`, `\Set`, `\Quot`, `\Hilb`,
`\et`, `\Div`). The typeclass names that have no macro are written in plain
`\mathrm{...}` form (e.g. `\(\mathrm{HasPicSharp}(C)\)`), and "Prop" is rendered
via `\texttt{Prop}` matching the chapter's existing convention — so no new macro
is required.

## Notes for Plan Agent
- The new carrier blocks deliberately point their semantic-discharge prose at the
  existing `Sorry 1–7` subsections (`subsec:sorry_*`) via `\cref`, keeping the
  scaffolding section consistent with the closure-order analysis already in the
  chapter. No content was deleted or restated.
- `def:has_smooth_proper_quotient` / `lem:smooth_proper_quotient` are stated for a
  generic morphism `α : Z ⟶ P`; the carrier has no natural mathematical out-edge,
  so it is anchored purely by in-edges (from its instance and from the public
  lemma). This is correct, not a missing edge.

## Strategy-modifying findings
None.
