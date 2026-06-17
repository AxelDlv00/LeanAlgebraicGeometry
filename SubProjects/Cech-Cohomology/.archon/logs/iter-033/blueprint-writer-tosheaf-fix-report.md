# Blueprint Writer Report

## Slug
tosheaf-fix

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Revised** `lem:toSheaf_preservesFiniteColimits` (statement block) — added
  `lem:mod_pmod_adjunction` to `\uses{}` (now
  `\uses{lem:sheafificationCompToSheaf_mathlib, lem:mod_pmod_adjunction}`).
- **Revised** `lem:toSheaf_preservesFiniteColimits` (proof block) — added
  `lem:mod_pmod_adjunction` to the proof `\uses{}` (same union as above), and added a
  one-line notation convention to the opening paragraph fixing `\circ` as **diagrammatic**
  composition (`F ∘ G` = "apply F, then G"), the convention already used implicitly in
  Step 1 (e.g. `L ∘ toSheaf R ≅ toPresheaf R₀ ∘ sheafify_J^Ab`).
- **Rewrote Step 2** of the proof. The previous prose mixed an applicative reading
  (`F ≅ (F ∘ forget R) ∘ L`, `colim F ≅ L(colim(F ∘ forget R))`) with the diagrammatic
  `\circ` of Step 1, producing the composition-order inconsistency the reviewer flagged.
  Replaced with a three-clause descent, all in diagrammatic `\circ`:
  - **(i) counit-iso:** the counit `ε : ι ∘ L ⟶ id_{Mod(R)}` of the sheafification
    adjunction `L ⊣ ι` (Lemma `lem:mod_pmod_adjunction`) is a natural isomorphism
    (sheafification of a sheaf is itself).
  - **(ii) retract:** whiskering `ε` with `toSheaf R` gives
    `toSheaf R ≅ ι ∘ (L ∘ toSheaf R)`, exhibiting `toSheaf R` as a retract of the
    composite `L ∘ toSheaf R` (section = precomposition with `ι`; retraction = `ε`
    whiskered with `toSheaf R`); the composite preserves finite colimits by Step 1.
  - **(iii) retract-preserves-colimits:** a retract of a finite-colimit-preserving functor
    preserves finite colimits (the colimit comparison map for the retract is a retract of an
    isomorphism, hence an isomorphism), giving the conclusion for `toSheaf R`.

## Cross-references introduced
- `\uses{lem:mod_pmod_adjunction}` added in both the statement and proof blocks of
  `lem:toSheaf_preservesFiniteColimits` — target exists (`~L2549`,
  `\lean{PresheafOfModules.sheafificationAdjunction}`). Verified via `leandag`:
  `unknown_uses = []`, block is not isolated.

## References consulted
None — this is project-bespoke Mathlib-infra prose (per directive, no `% SOURCE` quote
required). No citation blocks written.

## Macros needed (if any)
None. All commands used (`\circ`, `\dashv`, `\hookrightarrow`, `\xrightarrow`, `\cong`,
`\bigl/\bigr`, `\mathrm`, `\operatorname`) are standard / already in use in this block.

## Notes for Plan Agent
- No `\leanok` touched (out of scope, and writer-forbidden).
- `lem:to_sheaf_preserves_epi`, `lem:standard_cover_cofinal`, and all other blocks left
  untouched.
- `leandag build --json` after the edit: `unknown_uses = []`, no new isolated nodes. The
  pre-existing `unmatched_lean` list (Lean names awaiting build-time matching, project-wide)
  is unchanged by this prose-only edit and includes `lem:toSheaf_preservesFiniteColimits`
  and `lem:mod_pmod_adjunction` among many others — that is the normal pre-build state, not a
  regression from this edit.

## Strategy-modifying findings
None.
