# blueprint-writer directive — slug fbc-locality

## Chapter (the ONLY file you edit)
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

## Strategy context (the slice that matters)
`FlatBaseChange.lean` is an A.2.c engine lane (Stacks 02KH, `i = 0` flat base change). iter-233
added three axiom-clean **locality-of-isomorphisms** lemmas for `Scheme.Modules` morphisms that are
the literal first reduction step of the affine base-change proof, but they have NO `\lean{...}` block
in the chapter (a per-file Lean↔blueprint check flagged this as a major coverage gap: the affine
proof sketch uses a tool the chapter never names).

## Required edits (additive — do NOT alter existing statements or `% SOURCE` blocks)

1. **Add a short supplement subsection** "Locality of isomorphisms for `Scheme.Modules` morphisms"
   with three lemma blocks (project-local Mathlib supplements; these are bespoke infrastructure, so
   NO external `% SOURCE` quote is required — they stand on their proof sketch). Pin each with `\lean{}`:
   - `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` — a morphism of
     `Scheme.Modules` is an iso iff it induces an iso on every stalk (forward by functoriality;
     backward by packaging the underlying abelian-group presheaves as a `TopCat.Sheaf` and applying
     the stalk-local iso criterion, then reflecting along the forgetful functor).
   - `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` — if a morphism induces an
     iso on sections over every open in a basis, it is an iso (reduce to the stalk criterion;
     stalk bijectivity from basis-local injectivity + germ-lifting surjectivity).
   - `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` — a morphism is an iso iff it
     induces an iso on sections over every affine open (apply the basis lemma to the basis of affine
     opens, `Scheme.isBasis_affineOpens`).
   Give each a one-paragraph mathematical proof sketch (no Lean tactic strings).

2. **Update the proof sketch of the affine base-change lemma** (`lem:affine_base_change_pushforward`
   or whatever the chapter's affine-iso lemma is named) so it explicitly states the first reduction:
   "by `isIso_iff_isIso_app_affineOpens` it suffices to prove the map is an iso on sections over each
   affine open, where the tilde dictionary applies", then the remaining per-affine-open argument
   (tilde pushforward/pullback dictionary + `TensorProduct.AlgebraTensorModule.cancelBaseChange`).

## Out of scope
- Do NOT touch the deep `flatBaseChange_pushforward_isIso` theorem block beyond what already exists.
- Do NOT add/remove `\leanok` or `\mathlibok`.
- Do NOT edit any other chapter.
