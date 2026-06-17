# Blueprint Writer Report

## Slug
fbc-locality

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made
- **Added subsection** "Locality of isomorphisms for `Scheme.Modules` morphisms"
  (under `\section{The affine case}`), with an intro paragraph explaining these are
  project-local Mathlib supplements that carry no external citation. Renamed the
  remainder of the affine section into a `\subsection{The affine computation}`.
- **Added lemma** `\label{lem:modules_isIso_iff_stalk}` /
  `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` — a morphism of
  `Scheme.Modules` is an iso iff it induces an iso on every stalk.
  - Proof sketch added: Y. Forward by functoriality (forgetful + stalk functor);
    backward by packaging underlying abelian-group presheaves as `TopCat.Sheaf`,
    applying the sheaf-level stalk-local criterion, then reflecting along the
    forgetful functor.
- **Added lemma** `\label{lem:modules_isIso_of_isBasis}` /
  `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` — iso on every
  basic open of a basis ⇒ iso.
  - Proof sketch added: Y. Reduce to the stalk criterion; stalk bijectivity from
    basis-local injectivity + germ-lifting surjectivity.
- **Added lemma** `\label{lem:modules_isIso_iff_affineOpens}` /
  `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` — iso iff iso on
  sections over every affine open.
  - Proof sketch added: Y. Forward is immediate; converse is the basis lemma applied
    to the basis of affine opens.
- **Revised** proof of `lem:affine_base_change_pushforward` — prepended an explicit
  "First reduction (locality)" paragraph stating that by
  `lem:modules_isIso_iff_affineOpens` it suffices to prove the map is an iso on
  sections over each affine open of `S'`, where the tilde dictionary applies; the
  existing per-affine-open argument (tilde dictionary + associativity / cancellation
  isomorphism `(R'⊗_R A)⊗_A M ≅ R'⊗_R M`) is unchanged and follows.

## Cross-references introduced
- `\uses{lem:modules_isIso_iff_stalk}` in `lem:modules_isIso_of_isBasis` (statement
  + proof) — target defined in this same chapter.
- `\uses{lem:modules_isIso_of_isBasis}` in `lem:modules_isIso_iff_affineOpens`
  (statement + proof) — target defined in this same chapter.
- `\uses{..., lem:modules_isIso_iff_affineOpens}` added to the proof of
  `lem:affine_base_change_pushforward` — target defined in this same chapter.

## References consulted
- None. The three added lemmas are project-bespoke Mathlib supplements (directive
  states no external `% SOURCE` quote is required); no citation blocks were written
  for them. Existing `% SOURCE` blocks in the chapter were left untouched.

## Macros needed (if any)
- None. Used only standard LaTeX (`\texttt`, `\texorpdfstring`-free; `\mathrm`,
  `\iff`, `\operatorname`).

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- The three new lemma statements match the Lean declarations in
  `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (lines 99, 125, 161); the
  `\lean{}` namespaces (`AlgebraicGeometry.Modules.*`) were read off the live file.
- The deep `flatBaseChange_pushforward_isIso` theorem block and its proof sketch
  were left untouched, per scope.
- `\leanok`/`\mathlibok` markers were not touched (owned by sync_leanok / review).

## Strategy-modifying findings
None.
