# Blueprint Writer Report

## Slug
Picard_QuotScheme-cov273b2

## Status
COMPLETE — all 8 uncovered Lean helper declarations now have exactly one
`\lean{}`-pinned blueprint block, each wired into the chapter cone with
statement-level `\uses{}`; `leandag` reports zero isolated nodes and zero
unknown `\uses{}` in `Picard_QuotScheme`.

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

### New blocks (label + `\lean{}`), all in the "Project-side base-change substrate" subsection

- **Added theorem** `\label{thm:quot_canonical_basechange_app_app_isIso_of_isAffineBase}` —
  `\lean{AlgebraicGeometry.canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase}`
  — affine-base case of the stalkwise base-change iso (S affine; reduces to algebraic flat base change).
  - Statement-level `\uses{def:quot_pullback_app_isoTensor, lem:pushforward_isQuasicoherent, lem:pullback_tildeIso}` (mirrors the Lean body, which calls `pullback_app_isoTensor`, `pushforward_isQuasicoherent`, and gaps to `pullback_tildeIso`).
- **Added theorem** `\label{thm:quot_canonical_basechange_app_app_isIso_of_isAffineOpen}` —
  `\lean{AlgebraicGeometry.canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen}`
  — affine-open case over a general base S (base-side Mayer-Vietoris onto the affine-base case).
  - `\uses{thm:quot_canonical_basechange_app_app_isIso_of_isAffineBase, lem:quot_pushforward_pullback_section_eq}`.
- **Added theorem** `\label{thm:quot_canonical_basechange_app_app_isIso_of_affineCover}` —
  `\lean{AlgebraicGeometry.canonicalBaseChangeMap_app_app_isIso_of_affineCover}`
  — open-cover descent: iso on every affine open ⟹ iso on every open.
  - `\uses{def:quot_canonical_basechange_map}` (its body is the descent of that map's sections; the edge to the affine-open case lives on the parent `thm:quot_canonical_basechange_app_app_isIso`, matching the Lean call site where `_of_isAffineOpen` is passed as the affine hypothesis).
- **Added lemma** `\label{lem:quot_pushforward_pullback_section_eq}` —
  `\lean{AlgebraicGeometry.pushforward_pullback_section_eq_pullback_section}`
  — definitional (rfl) identity: sections of `f'_*(g'^*F)` over U = sections of `g'^*F` over `f'^{-1}(U)`.
  - `\uses{def:quot_canonical_basechange_map}` (the identity through which the base-change map's target is read).
- **Added definition** `\label{def:quot_pullback_app_isoTensor_unitAtV}` —
  `\lean{AlgebraicGeometry.pullback_app_isoTensor_unitAtV}`
  — adjunction-unit base linear map at a section (Step 1 of the Tilde-isoTop route). No outgoing project `\uses{}` (built from the Mathlib pullback–pushforward adjunction); non-isolated via the incoming edge from the base-map block.
- **Added definition** `\label{def:quot_pullback_app_isoTensor_baseMap}` —
  `\lean{AlgebraicGeometry.pullback_app_isoTensor_baseMap}`
  — section-level Γ(X,V)-linear base map (unit-at-section ∘ presheaf restriction).
  - `\uses{def:quot_pullback_app_isoTensor_unitAtV}`.
- **Added theorem** `\label{thm:quot_pullback_app_isoTensor_baseMap_isBaseChange}` —
  `\lean{AlgebraicGeometry.pullback_app_isoTensor_baseMap_isBaseChange}`
  — the base map is a base change.
  - `\uses{def:quot_pullback_app_isoTensor_baseMap, def:pullback_app_isoTensor_sigma}` (Lean body destructures `pullback_app_isoTensor_baseMap_sectionLinearEquiv` = the Σ-pair).
- **Added theorem** `\label{thm:quot_pullback_app_isoTensor_isBaseChange}` —
  `\lean{AlgebraicGeometry.pullback_app_isoTensor_isBaseChange}`
  — existence of the tensor-presentation `LinearEquiv` (consumed by `def:quot_pullback_app_isoTensor`).
  - `\uses{thm:quot_pullback_app_isoTensor_baseMap_isBaseChange}`.

All eight new blocks carry a `\begin{proof} Proved directly in Lean. \end{proof}` body and no external `% SOURCE` (they are project-bespoke decomposition helpers, not restatements of a single Mathlib decl). No `\leanok`/`\mathlibok` added.

### Wiring edits to existing blocks (statement-level `\uses{}`)

- **`thm:quot_canonical_basechange_app_app_isIso`** (`canonicalBaseChangeMap_app_app_isIso`) — appended `thm:quot_canonical_basechange_app_app_isIso_of_affineCover` and `thm:quot_canonical_basechange_app_app_isIso_of_isAffineOpen` to its `\uses{}` (its Lean proof composes exactly these two helpers). Single line.
- **`def:quot_pullback_app_isoTensor`** (`Scheme.Modules.pullback_app_isoTensor`) — appended `thm:quot_pullback_app_isoTensor_isBaseChange` to its `\uses{}` (Lean body discharges via `(pullback_app_isoTensor_isBaseChange …).some`). Single line.

These two edits make the existing cluster transitively `\uses{}` all eight new helpers:
`thm:quot_canonical_basechange_isIso → thm:quot_canonical_basechange_app_app_isIso → {_of_affineCover, _of_isAffineOpen} → _of_isAffineBase → {def:quot_pullback_app_isoTensor, lem:pushforward_isQuasicoherent, lem:pullback_tildeIso}`, and `def:quot_pullback_app_isoTensor → thm:quot_pullback_app_isoTensor_isBaseChange → …_baseMap_isBaseChange → {def:quot_pullback_app_isoTensor_baseMap, def:pullback_app_isoTensor_sigma} → def:quot_pullback_app_isoTensor_unitAtV`; `_of_isAffineOpen → lem:quot_pushforward_pullback_section_eq`.

## Cross-references introduced
- All new `\uses{}` and `\cref{}` targets are labels that exist in this same chapter (verified by `leandag build --json`: `unknown_uses = 0`).

## Verification
- `leandag query --isolated --chapter Picard_QuotScheme` → none.
- `leandag build --json` → 0 unknown `\uses{}`; none of the 8 target `\lean{}` names remain unmatched.
- Each of the 8 `\lean{}` names is pinned exactly once project-wide (grep).
- LaTeX environments balanced (the lone `\begin{proof}` regex "mismatch" is a pre-existing one inside a `%` comment at line 397, present at HEAD; not introduced here).
- No literal `REF` in rendered prose: the 4 `REF` occurrences are all inside verbatim `% SOURCE QUOTE`/`% SOURCE QUOTE PROOF` comments and were left untouched per directive.

## References consulted
None opened this session — all eight blocks are internal project helpers (no external `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source:}` written), so no `references/` files were needed.

## Notes for Plan Agent
- **Cone orientation (pre-existing modeling inversion, not fixable additively).** The whole base-change substrate cluster (`canonicalBaseChangeMap*`, `pullback_app_isoTensor*`) is wired internally and is transitively reachable from `thm:quot_canonical_basechange_isIso`. It is **not** transitively reachable from the headline `thm:quot_representable`, because the existing blueprint edges run *from* the substrate *to* `thm:flat_base_change_cohomology` (treated as a Stacks-02KH anchor), which is the same sink `thm:quot_representable` depends on. In Lean the dependency is the reverse: `flatBaseChangeCohomology`'s proof *calls* `canonicalBaseChangeMap_isIso`. Adding the faithful edge `thm:flat_base_change_cohomology → thm:quot_canonical_basechange_isIso` would close a cycle (`flat_base_change_cohomology → … → def:quot_canonical_basechange_map → flat_base_change_cohomology`), so I did not add it. Resolving this would require re-orienting the pre-existing `\uses{thm:flat_base_change_cohomology}` edges in the substrate (e.g. demoting `thm:flat_base_change_cohomology` to a consumer that `\uses{}` the substrate), which is beyond this additive-coverage directive. The hard isolation gate is satisfied regardless.

## Strategy-modifying findings
None.
