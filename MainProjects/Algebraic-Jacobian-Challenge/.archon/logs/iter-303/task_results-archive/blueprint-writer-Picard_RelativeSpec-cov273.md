# Blueprint Writer Report

## Slug
Picard_RelativeSpec-cov273

## Status
COMPLETE — all 9 uncovered Lean declarations now have exactly one `\lean{}`-pinned
blueprint block, each wired into the chapter's relative-Spec / base-change cone; all
prose `REF` placeholders replaced with `\cref{}`.

## Target chapter
blueprint/src/chapters/Picard_RelativeSpec.tex

## Changes Made

### New coverage blocks (one per uncovered decl)
- **Added definition** `\label{def:relspec_structure_morphism}` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.structureMorphism}` — the canonical projection `π : Spec_X(𝒜) → X` (colimit descent of the affine-local maps `Spec(𝒜(U)) → U`). Placed in §2 after `thm:relative_spec_exists`.
- **Added lemma** `\label{lem:relspec_pullback_fst_isaffinehom}` / `\lean{AlgebraicGeometry.Scheme.QcohAlgebra.pullback_fst_isAffineHom}` — the pullback projection `q` of `π` along `g` is affine.
- **Added lemma** `\label{lem:relspec_pullback_coequifibered}` / `\lean{AlgebraicGeometry.Scheme.QcohAlgebra.pullback_coequifibered}` — the pushforward `q_* O` carries the Stacks-01LL localization-away (Coequifibered) overlay.
- **Added definition** `\label{def:relspec_pullback_iso_affine_piece}` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.pullback_iso_affine_piece}` — per-affine-open iso `q⁻¹(U) ≅ Spec((g^*𝒜)(U))`.
- **Added definition** `\label{def:relspec_pullback_cocone}` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.pullback_cocone}` — cocone on the relative-gluing functor of `g^*𝒜` with apex the pullback.
- **Added lemma** `\label{lem:relspec_pullback_cocone_desc_comp_fst}` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.pullback_cocone_desc_comp_fst}` — cocone descent composed with `q` equals the structure morphism of `Spec_T(g^*𝒜)`.
- **Added lemma** `\label{lem:relspec_pullback_iso_desc_isiso}` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.pullback_iso_desc_isIso}` — that descent map is an isomorphism (checked Zariski-locally on `{q⁻¹U}`).
- **Added definition** `\label{def:relspec_pullback_iso_construction}` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.pullback_iso_construction}` — the base-change iso `T ×_X Spec_X(𝒜) ≅ Spec_T(g^*𝒜)`, inverse of the descent.
- **Added lemma** `\label{lem:relspec_pullback_iso}` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.pullback_iso}` — existence (Nonempty) of that iso; the statement consumed by `base_change`.

All eight pullback-helper blocks live in a new `\section{Pullback compatibility helpers}`
(`\label{sec:relspec_pullback_helpers}`) inserted between Base change and Functoriality.
Each carries a `\begin{proof} ... directly in Lean. \end{proof}` block.

### Dependency wiring (no isolated nodes)
- `thm:relative_spec_univ`: added `def:relspec_structure_morphism` to its `\uses{}` (its Lean proof builds on `structureMorphism`).
- `thm:relative_spec_base_change`: added `lem:relspec_pullback_iso, lem:relspec_pullback_coequifibered` to its `\uses{}` (its Lean proof consumes `pullback_iso` and the pulled-back algebra whose `coequifibered` field is `pullback_coequifibered`).
- Internal helper edges (matching the Lean call graph):
  - `def:relspec_structure_morphism` → `thm:relative_spec_exists, def:qc_sheaf_of_algebras`
  - `lem:relspec_pullback_fst_isaffinehom` → `thm:relative_spec_univ, def:relspec_structure_morphism`
  - `lem:relspec_pullback_coequifibered` → `lem:relspec_pullback_fst_isaffinehom`
  - `def:relspec_pullback_iso_affine_piece` → `lem:relspec_pullback_fst_isaffinehom`
  - `def:relspec_pullback_cocone` → `lem:relspec_pullback_fst_isaffinehom`
  - `lem:relspec_pullback_cocone_desc_comp_fst` → `def:relspec_pullback_cocone, lem:relspec_pullback_fst_isaffinehom`
  - `lem:relspec_pullback_iso_desc_isiso` → `def:relspec_pullback_cocone, lem:relspec_pullback_cocone_desc_comp_fst, def:relspec_pullback_iso_affine_piece, lem:relspec_pullback_fst_isaffinehom`
  - `def:relspec_pullback_iso_construction` → `def:relspec_pullback_cocone, lem:relspec_pullback_iso_desc_isiso, lem:relspec_pullback_fst_isaffinehom`
  - `lem:relspec_pullback_iso` → `def:relspec_pullback_iso_construction`

End state: `thm:relative_spec_base_change` transitively `\uses{}` all eight pullback
helpers; `thm:relative_spec_univ` reaches `structureMorphism`. `leandag` reports the
chapter has **0 isolated nodes**.

### REF placeholder fixes (prose only)
Replaced 11 literal `Theorem~REF` / `Definition~REF` placeholders in rendered prose with
real `\cref{}`:
- `def:qc_sheaf_of_algebras` (relative-spec-exists statement)
- `thm:relative_spec_affine_base`, `thm:relative_spec_base_change`, `thm:relative_spec_exists` (univ-property proof)
- `thm:relative_spec_univ` (base-change proof, functoriality statement, functoriality proof, Lean-encoding section)
- `thm:relative_spec_affine_base` (functoriality proof)
- `thm:relative_spec_base_change`, `thm:relative_spec_functorial` (Lean-encoding section)

The remaining `REF` strings in the file are all inside verbatim `% SOURCE QUOTE:` /
`% SOURCE QUOTE PROOF:` LaTeX comments (the Stacks source's own internal cross-refs);
per citation discipline these are left untouched.

## Cross-references introduced
All new `\uses{}` targets are labels in this same chapter (verified by `leandag build`:
`unknown_uses: []`). No cross-chapter `\uses{}` were introduced.

## References consulted
None — all 9 blocks are internal helper/substrate lemmas under an already-cited public
API (Stacks 01LL/01LO/01LQ/01LR/01LS). No new external source material was needed; no
`% SOURCE:` citation blocks were written, so no `references/` files were opened. Each new
block uses the directive-sanctioned `... directly in Lean.` proof body.

## Verification (leandag)
- `leandag build --json`: `unknown_uses: []` (no broken `\uses{}`).
- All 9 target `\lean{}` names match Lean declarations (none in `unmatched_lean`).
- `leandag query --isolated --chapter Picard_RelativeSpec`: 0 results.
- Each of the 9 Lean names is pinned exactly once in the chapter.

## Macros needed (if any)
None.

## Notes for Plan Agent
- `AlgebraicGeometry.Scheme.QcohAlgebra.pullback` (a `noncomputable def` in
  `RelativeSpec.lean`, used by `base_change`, `pullback_iso_affine_piece`,
  `pullback_cocone`, etc.) has **no** blueprint pin and was **not** in this directive's
  list of 9. It is sorry-free in Lean and its `coequifibered` field is supplied by
  `pullback_coequifibered`. If a 1-to-1 audit flags it as uncovered `lean-aux`, it needs
  its own block (a `\begin{definition}` pinning `QcohAlgebra.pullback`, `\uses` →
  `lem:relspec_pullback_coequifibered, def:relspec_structure_morphism`, used-by
  `thm:relative_spec_base_change`). I did not add it to avoid exceeding the directive's
  declared scope; flagging for a follow-up coverage dispatch.

## Strategy-modifying findings
None.
