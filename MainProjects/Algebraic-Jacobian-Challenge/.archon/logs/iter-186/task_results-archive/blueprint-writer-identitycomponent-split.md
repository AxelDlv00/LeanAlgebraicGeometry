# Blueprint Writer Report

## Slug
identitycomponent-split

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_IdentityComponent.tex

## Changes Made

### Block 1 split — `thm:identity_component_open_subgroup`

The original single theorem block (which encoded the 4-conjunct statement
of Kleiman §5 Lem.~`lem:agps`(3) but pinned only to
`AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme`,
whose Lean signature captures only the clopen-inclusion sub-claim) was
replaced by 4 per-conclusion theorem blocks:

- **`\label{thm:identity_component_open_subgroup}` (KEEP, EXISTING PIN)**
  - `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme}`
  - Conclusion (a): inclusion `G^0 ↪ G` is both an open immersion and
    a closed immersion (clopen subscheme).
  - Carries the verbatim `% SOURCE QUOTE:` of Kleiman lem:agps~(3)
    (covering all 4 conclusions); preserves the existing `\leanok`
    marker.
- **`\label{thm:identity_component_is_subgroup_homomorphism}` (NEW PIN)**
  - `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isSubgroupHomomorphism}`
  - Conclusion (b): inclusion is a homomorphism of `k`-group schemes;
    `G^0` inherits a `[GrpObj]` structure compatible with the
    inclusion.
- **`\label{thm:identity_component_finite_type_geom_irreducible}` (NEW PIN)**
  - `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible}`
  - Conclusion (c): `G^0` is of finite type over `k` (locally of finite
    type and quasi-compact) and geometrically irreducible. Single
    pinned Lean decl bundles the three instances.
- **`\label{thm:identity_component_base_change_commutes}` (NEW PIN)**
  - `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.baseChangeIso}`
  - Conclusion (d): for any field extension `K/k`, the natural map
    `(G^0)_K → (G_K)^0` is an isomorphism of `K`-schemes.

After the four statement blocks, a single combined `\begin{proof}` env
follows the fourth theorem, carrying the original verbatim
`% SOURCE QUOTE PROOF:` comment (Kleiman's proof of lem:agps, part (3))
unchanged. The proof's prose is restructured into four `\emph{...}`
paragraphs, each explicitly labelled with the theorem it establishes
via `\cref{...}` references. Material is not duplicated.

### Block 2 split — `thm:pic_zero_is_abelian_variety`

The original single theorem block was replaced by 3 per-conclusion
blocks:

- **`\label{thm:pic_zero_is_abelian_variety}` (KEEP, EXISTING PIN)**
  - `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety}`
  - Conclusion (1): the 4-conjunct abelian-variety structure
    (`[IsProper]`, `[Smooth]`, `[GeometricallyIrreducible]` on
    `(Pic0Scheme C).hom` + `Nonempty (GrpObj (Pic0Scheme C))`).
  - Carries the verbatim Kleiman ex:jac + rmk:Jac source quotes;
    preserves the existing `\leanok` marker.
- **`\label{thm:pic_zero_dimension_equals_genus}` (NEW PIN)**
  - `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.finrank_eq_genus}`
  - Conclusion (2): `dim_k (Pic0Scheme C) = g(C)`.
  - Carries the verbatim Milne §III.1, Rmk.~1.4(e) source quote (the
    relevant block to establish "dimension of `J` is the genus of
    `C`").
- **`\label{thm:pic_zero_k_points_iff_degree_zero}` (NEW PIN)**
  - `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.kPoints_iff_kerDegree}`
  - Conclusion (3): a `k`-point `λ : Spec k ⟶ (PicScheme C).left`
    lifts through the inclusion `Pic^0 ↪ Pic` iff
    `PicScheme.degree C λ = 0`; equivalently
    `Pic⁰_{C/k}(k) = ker(deg)`.
  - References the Milne §III.1, p.~88 verbatim quote already
    reproduced at `\cref{def:divisor_degree_pic}` (not duplicated).

After the three statement blocks, a single combined `\begin{proof}` env
follows the third theorem, carrying the original
`% SOURCE QUOTE PROOF:` comments (Kleiman th:qpp&p + Kleiman cor:sm).
The Milne III.1.4(e) verbatim block is moved out of the proof-source
comment block into the statement-level `% SOURCE QUOTE:` of
`thm:pic_zero_dimension_equals_genus` (its natural home, since it
states the dimension equality directly). Proof prose is restructured
into three labelled emphasised paragraphs (one per split theorem),
preserving all 4 substantive steps (clopen subgroup, quasi-projective,
projective, smooth) of the original assembly. The "Identification with
the kernel of the degree map" paragraph from the original proof is
retained as the proof of
`thm:pic_zero_k_points_iff_degree_zero`.

### Other touch-ups (in scope, required for consistency)

- **§5 "Lean encoding" bullet list** updated to enumerate the new 10
  pinned Lean declarations (was 5). Each new bullet describes the
  intended Lean signature and which conclusion of Kleiman lem:agps~(3)
  / Milne III.1 it captures.
- **§6 "Internal-consistency check" `\uses` chain** updated to include
  the new theorem labels and their `\uses{...}` pointers. The
  proof-of `thm:pic_zero_is_abelian_variety` step (i) is updated to
  invoke all four new identity-component theorems
  (`\cref{thm:identity_component_open_subgroup,
    thm:identity_component_is_subgroup_homomorphism,
    thm:identity_component_finite_type_geom_irreducible,
    thm:identity_component_base_change_commutes}`).

## Cross-references introduced

All new `\cref{...}` cross-references stay inside this chapter — no
new sibling-chapter dependencies were introduced. New labels referenced
from within the chapter:

- `\cref{thm:identity_component_is_subgroup_homomorphism}` — used by
  `\cref{thm:pic_zero_is_abelian_variety}` proof and §6 consistency
  check.
- `\cref{thm:identity_component_finite_type_geom_irreducible}` — used
  by `\cref{thm:pic_zero_is_abelian_variety}` proof and §6 consistency
  check.
- `\cref{thm:identity_component_base_change_commutes}` — used by
  `\cref{thm:pic_zero_is_abelian_variety}` proof and §6 consistency
  check.
- `\cref{thm:pic_zero_dimension_equals_genus}` — listed in §6
  consistency check.
- `\cref{thm:pic_zero_k_points_iff_degree_zero}` — listed in §6
  consistency check.

All existing cross-references preserved.

## Source-quote distribution decisions

- **Kleiman lem:agps~(3) statement quote (4-line verbatim):** kept
  ONCE at `thm:identity_component_open_subgroup` (the first block in
  the split group). The three subsequent split blocks reference the
  quote via `\cref{thm:identity_component_open_subgroup}` in both
  their `% SOURCE:` comments and their `\textit{Source: ...}` lines.
- **Kleiman lem:agps~(3) proof quote (49-line verbatim from Kleiman's
  proof):** kept ONCE immediately before the single combined
  `\begin{proof}` env that follows the four split theorems.
- **Kleiman ex:jac + rmk:Jac statement quotes:** kept at
  `thm:pic_zero_is_abelian_variety` (the AV-structure block). These
  are the source statements that establish projectivity + smoothness
  of `Pic⁰_{C/k}` for a smooth proper curve and therefore belong with
  the AV-structure conclusion.
- **Milne III.1.4(e) verbatim quote:** moved from the proof-source
  comment block of the original `thm:pic_zero_is_abelian_variety` into
  the statement-level `% SOURCE QUOTE:` of
  `thm:pic_zero_dimension_equals_genus`. This is its natural home —
  Milne III.1.4(e) is precisely the dimension-equals-genus statement
  the new theorem encodes.
- **Milne III.1 p.~88 quote (`Pic^0(C)` = degree-zero classes):** not
  re-reproduced at `thm:pic_zero_k_points_iff_degree_zero`; instead,
  the new theorem's `% SOURCE:` and `\textit{Source: ...}` lines
  point to the existing verbatim copy at `def:divisor_degree_pic`
  (which was already in the chapter at the degree-map definition's
  source-quote block). Avoids duplication.
- **Kleiman th:qpp&p + cor:sm proof-source quotes:** kept at the
  combined `\begin{proof}` env after `thm:pic_zero_k_points_iff_degree_zero`,
  unchanged from the original chapter (these source quotes back step (ii)
  Quasi-projectivity, (iii) Projectivity, and the dimension-bound
  paragraph of the proof).

## Macros needed (if any)

None. I caught and replaced three would-be undefined macros that the
initial draft was tempted to use (`\IsProper`, `\Smooth`,
`\GeometricallyIrreducible`, `\GrpObj`, `\IdentityComponent`) with the
existing `\texttt{...}` Lean-syntax-in-typewriter pattern that the rest
of the chapter (and the project's `macros/common.tex`) uses for Lean
identifiers in prose. No new macros are required for the typeset
output.

## References consulted

- **`blueprint/src/chapters/Picard_IdentityComponent.tex`** itself — read
  the existing chapter end-to-end to identify the two over-loaded
  blocks, their existing `% SOURCE QUOTE:` and `% SOURCE QUOTE PROOF:`
  comments (which the directive instructed me to redistribute, not
  re-fetch).
- **`blueprint/src/macros/common.tex`** — read to confirm which Lean
  identifiers (`\Pic`, `\Spec`, `\finrank`, etc.) are defined as
  macros and which (`\IsProper`, `\Smooth`, `\GrpObj`, etc.) are NOT.
  Used to avoid introducing undefined macros and to keep all
  Lean-syntax-in-prose inside `\texttt{...}`.
- **`AlgebraicJacobian/Picard/IdentityComponent.lean`** — read to
  confirm the existing 5 typed-sorry signatures and namespacing, so
  the new `\lean{...}` pins introduced in the split match the project's
  namespace conventions (e.g.
  `AlgebraicGeometry.GroupScheme.IdentityComponent.*` and
  `AlgebraicGeometry.Scheme.Pic0Scheme.*`).
- **`.archon/subagents/blueprint-writer.md`** — read for the descriptor
  rules (citation discipline, no `\leanok` additions, write-domain
  scope).
- **`.archon/CLAUDE.md`** — read for project-wide context on subagent
  permissions and blueprint marker conventions.

No new source-material files were opened — per the directive,
"DO NOT consult new references; everything you need is already in the
chapter's existing `% SOURCE QUOTE:` blocks". The split is a pure
redistribution + per-conclusion pin-assignment exercise.

## Reference-retriever dispatches (if any)

None. The directive forbade new reference retrieval, and none was
needed: all source quotes already lived in the chapter's existing
verbatim comment blocks.

## New `\lean{...}` pin names introduced

For the iter-186/187 plan agent's follow-up Lean-side scaffold, the
five NEW pinned Lean declaration names (currently NOT in
`AlgebraicJacobian/Picard/IdentityComponent.lean`) are:

1. `AlgebraicGeometry.GroupScheme.IdentityComponent.isSubgroupHomomorphism`
   — type signature should assert that the clopen inclusion
   `(IdentityComponent G).hom`-compatible morphism
   `IdentityComponent G ⟶ G` (from the existing
   `isOpenSubgroupScheme` witness) is a group-object homomorphism in
   `Over (Spec (.of k))`. Suggested encoding: existence of a
   `[GrpObj (IdentityComponent G)]` instance together with a
   `Mon_.Hom (IdentityComponent G) G` whose underlying morphism is
   the clopen-inclusion of `isOpenSubgroupScheme`. (The exact Lean
   shape is a minor design choice; the iter-186 plan agent should
   pick the encoding consistent with how `GrpObj` morphisms are
   threaded elsewhere in the project, e.g.
   `AlgebraicJacobian/AbelianVarietyRigidity.lean`.)

2. `AlgebraicGeometry.GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible`
   — bundled instance/theorem packaging the three Lean instances
   `[LocallyOfFiniteType (IdentityComponent G).hom]`,
   `[QuasiCompact (IdentityComponent G).hom]`, and
   `[GeometricallyIrreducible (IdentityComponent G).hom]`.

3. `AlgebraicGeometry.GroupScheme.IdentityComponent.baseChangeIso`
   — for a field extension `K/k`, the natural comparison map
   `(IdentityComponent G) ×_(Spec k) (Spec K) ≅ IdentityComponent (G ×_(Spec k) (Spec K))`,
   expressed as an isomorphism in `Over (Spec (.of K))`.

4. `AlgebraicGeometry.Scheme.Pic0Scheme.finrank_eq_genus`
   — `Module.finrank k (Pic0Scheme C).left = AlgebraicGeometry.genus C`,
   or whatever the project's Krull-dimension-of-scheme API names. The
   `genus C` side is the existing `AlgebraicGeometry.genus` from
   `AlgebraicJacobian/Genus.lean`; the `(Pic0Scheme C).left` side
   needs the dimension of the underlying scheme.

5. `AlgebraicGeometry.Scheme.Pic0Scheme.kPoints_iff_kerDegree`
   — the `k`-point characterisation. Phrasing suggested by the
   directive:
   `∀ λ : Spec (.of k) ⟶ (PicScheme C).left,
      (∃ μ : Spec (.of k) ⟶ (Pic0Scheme C).left,
        μ ≫ pic0Inclusion = λ) ↔ PicScheme.degree C λ = 0`
   where `pic0Inclusion` is the open-immersion morphism
   `(Pic0Scheme C).left ⟶ (PicScheme C).left` extracted from
   applying `isOpenSubgroupScheme` to `G = PicScheme C`. (The
   `pic0Inclusion` name does not yet exist either; the iter-186 plan
   agent should decide whether to introduce a separate
   `Pic0Scheme.inclusion` abbreviation or inline the extraction from
   `isOpenSubgroupScheme`.)

## Notes for Plan Agent

- **`thm:pic_zero_dimension_equals_genus` depends on
  `thm:pic_zero_is_abelian_variety`.** The `\uses{...}` chain
  recorded in §6 captures this: the dimension-equality theorem cites
  the AV-structure theorem because smoothness of `Pic⁰_{C/k}` is what
  unlocks Kleiman cor:sm's `dim_k = dim_k H¹(O_C) = g` equality. If
  the Lean prover scaffolds the new pins, the
  `finrank_eq_genus` proof should be downstream of
  `isAbelianVariety` rather than parallel to it.
- **`thm:pic_zero_k_points_iff_degree_zero` references a Lean concept
  (`pic0Inclusion`) that does not yet exist.** When scaffolding the
  Lean decl `Pic0Scheme.kPoints_iff_kerDegree`, the prover will
  need either to introduce a separate `pic0Inclusion` abbreviation
  (suggested) or to inline the extraction from
  `isOpenSubgroupScheme` inside the statement. I noted this above
  under "New `\lean{...}` pin names introduced (5)" but flag it
  again here because it's the only point where the new pin's exact
  Lean shape is genuinely under-specified by the directive.
- **The existing `\leanok` on `thm:identity_component_open_subgroup`
  and `thm:pic_zero_is_abelian_variety` was preserved.** Both blocks
  pin to Lean declarations whose bodies are typed-sorry as of
  iter-185 file-skeleton, so `sync_leanok` will likely remove these
  `\leanok` markers on the next sync pass (correctly). I did not
  manually remove them per the descriptor's "DO NOT add or remove
  `\leanok`" rule.
- **The Milne III.1.4(e) verbatim quote was the only material I
  moved between blocks** (out of the proof-source comments of the
  original `thm:pic_zero_is_abelian_variety` into the statement-level
  source of `thm:pic_zero_dimension_equals_genus`). The Kleiman
  th:qpp&p and cor:sm proof-source quotes stay in the combined proof
  for Block 2, because they back specific proof steps (projectivity,
  smoothness/dimension-bound) rather than statements of split
  theorems.
- **Chapter length:** the chapter grew from ~564 LOC to ~720 LOC
  (estimate); on the upper end of the directive's expected
  ~50-100 LOC growth. The extra growth is the Lean-encoding bullet
  list (5 → 10 bullets, with more verbose Lean-signature explanations)
  and the §6 consistency-check `\uses` chain (5 → 10 declaration
  blocks).

## Strategy-modifying findings

None. The split is a pure pin-granularity refactor and does not
surface any inconsistency between the prose conclusions and the
strategic role of A.3 in Route~A.
