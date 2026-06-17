# blueprint-writer · identitycomponent-split (iter-186)

## Chapter to edit
`blueprint/src/chapters/Picard_IdentityComponent.tex` (~564 LOC, already on disk).

## Problem (from lean-vs-blueprint-checker iter185-identitycomponent — 2 MUST-FIX-THIS-ITER findings)

The chapter currently has 2 over-loaded theorem blocks whose Lean
pins target Lean declarations that capture only ONE of multiple
conclusions stated in the prose. The Lean file
`AlgebraicJacobian/Picard/IdentityComponent.lean` (5 typed-sorry
declarations, iter-185 file-skeleton) is downstream of this chapter,
and the iter-186 plan agent has chosen **Path B**: split each
over-loaded theorem block into per-conclusion blocks, each with its
own `\lean{...}` pin to a Lean declaration. The existing Lean
declarations remain pinned to the SUB-CLAIM they actually prove;
the additional conclusions are pinned to NEW Lean decl names that
will be scaffolded in a follow-up iter as typed sorries.

## The two over-loaded theorem blocks

### Block 1 — `thm:identity_component_open_subgroup` (currently L95-117)

Currently pins `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme}`.
The Lean signature only captures
`Nonempty {f : IdentityComponent G ⟶ G // IsOpenImmersion f.left ∧ IsClosedImmersion f.left}`,
i.e. Kleiman conclusion (a) — the clopen-subscheme inclusion.

Kleiman §5 Lem.~`lem:agps`(3) actually proves FOUR conclusions:
(a) clopen open-immersion `G^0 ↪ G`;
(b) the inclusion is a homomorphism of `k`-group schemes
    (`G^0` inherits a `[GrpObj]` structure);
(c) `G^0` is of finite type over `k` and geometrically irreducible
    (`[LocallyOfFiniteType ((IdentityComponent G).hom)]` +
    `[QuasiCompact ((IdentityComponent G).hom)]` +
    `[GeometricallyIrreducible ((IdentityComponent G).hom)]`);
(d) formation commutes with base change: for any field extension
    `K/k`, the natural map `(IdentityComponent G)_K → IdentityComponent (G_K)`
    is an isomorphism.

### Block 2 — `thm:pic_zero_is_abelian_variety` (currently L316-355)

Currently pins `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety}`.
The Lean signature only captures conjunct (1) of three:
`IsProper (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧
   GeometricallyIrreducible (Pic0Scheme C).hom ∧
   Nonempty (GrpObj (Pic0Scheme C))`,
i.e. the 4-conjunct abelian-variety structure.

The prose claims three components:
(1) abelian-variety structure (the 4-conjunct as captured);
(2) `dim_k (Pic0Scheme C).left = AlgebraicGeometry.genus C` (dimension equals genus);
(3) `∀ x : (Spec (.of k) ⟶ (Pic0Scheme C).left), True ↔
        PicScheme.degree C ((PicScheme.fromPic0 C).left ≫ x) = 0`
    — i.e. the k-points of `Pic⁰_{C/k}` are exactly the kernel of the
    degree map. (Phrasing TBD; the chapter prose says
    `Pic⁰_{C/k}(k) = ker(deg)`.)

## Changes requested (Path B split)

For EACH of the two blocks above, split into per-conclusion
`\begin{theorem}…\end{theorem}` blocks (keep the long
`% SOURCE QUOTE PROOF:` and `\begin{proof}` once, shared at the end
under a `\paragraph{Combined proof}` or similar wrapper — at your
discretion as long as the proof material is not duplicated).

### Block 1 split — target structure

Produce 4 separate `\begin{theorem}…\end{theorem}` blocks with these
labels, pins, and short prose (each block restates ONE conclusion of
Kleiman lem:agps(3) with its own `\textit{Source: …}` line; keep the
existing `% SOURCE:` and `% SOURCE QUOTE:` comments at the FIRST
block, share the SOURCE QUOTE PROOF before the proof environment that
follows the last block):

1. `\label{thm:identity_component_open_subgroup}` (KEEP — same label;
   pins the existing Lean clopen-inclusion conclusion):
   `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme}`
   — clopen subscheme inclusion.

2. `\label{thm:identity_component_is_subgroup_homomorphism}` (NEW;
   pins a Lean decl to be scaffolded in a follow-up iter):
   `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isSubgroupHomomorphism}`
   — the clopen inclusion `G^0 ↪ G` is a homomorphism of `k`-group
   schemes; equivalently, `[GrpObj (IdentityComponent G)]` exists and
   is compatible with the inclusion to `G`.

3. `\label{thm:identity_component_finite_type_geom_irreducible}` (NEW;
   pins two Lean decls — produce ONE pinned block whose Lean target
   is the conjunction OR produce TWO sub-blocks at your discretion):
   `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible}`
   — `G^0` is of finite type over `k` and geometrically irreducible.
   Restate the finite-type assertion as
   `[LocallyOfFiniteType (IdentityComponent G).hom] ∧ [QuasiCompact (IdentityComponent G).hom]`
   (in Lean this is two instances; in the chapter the assertion is one
   sentence).

4. `\label{thm:identity_component_base_change_commutes}` (NEW; pins a
   Lean decl to be scaffolded):
   `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.baseChangeIso}`
   — for any field extension `K/k`, the natural map
   `(IdentityComponent G)_K → IdentityComponent (G_K)` is an
   isomorphism.

### Block 2 split — target structure

Produce 3 separate `\begin{theorem}…\end{theorem}` blocks with these
labels, pins, and short prose:

1. `\label{thm:pic_zero_is_abelian_variety}` (KEEP — same label;
   pins the existing Lean 4-conjunct AV-structure):
   `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety}`
   — `Pic⁰_{C/k}` is an abelian variety over `k`: the conjunction of
   `[IsProper]`, `[Smooth]`, `[GeometricallyIrreducible]`,
   `Nonempty (GrpObj _)`.

2. `\label{thm:pic_zero_dimension_equals_genus}` (NEW; pins a Lean
   decl to be scaffolded):
   `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.finrank_eq_genus}`
   — `Module.finrank k (Pic0Scheme C).left = AlgebraicGeometry.genus C`
   (the dimension of the Jacobian variety equals the genus of the
   curve).

3. `\label{thm:pic_zero_k_points_iff_degree_zero}` (NEW; pins a Lean
   decl to be scaffolded):
   `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.kPoints_iff_kerDegree}`
   — `∀ λ : Spec (.of k) ⟶ (PicScheme C).left,
        (∃ μ : Spec (.of k) ⟶ (Pic0Scheme C).left, μ ≫ pic0Inclusion = λ)
          ↔ PicScheme.degree C λ = 0`
   (precise Lean phrasing TBD by you — express the inclusion of
   `Pic⁰` into `Pic` as an open-immersion morphism and characterise
   image in terms of `degree = 0`; consult Milne III.1 p.~88 quote
   already in the chapter).

## Sources to use

All sources are ALREADY embedded in the existing chapter at
L66-92 (Kleiman lem:agps), L99-117 (Kleiman lem:agps(3)),
L199-218 (Kleiman prp:pic0), L254-269 (Milne III.1 p.~88 degree
definition), L321-381 (Kleiman ex:jac / rmk:Jac / th:qpp&p /
cor:sm + Milne III.1.4(e)). The split preserves these — do NOT
re-fetch sources; keep the `% SOURCE QUOTE:` comments verbatim,
distributing them sensibly across the per-conclusion blocks (each
block's `\textit{Source: …}` line should match its specific
conclusion's source quote).

If you find one of the source quotes is duplicated across multiple
per-conclusion blocks (e.g. Kleiman lem:agps states all 4
conclusions in one paragraph), KEEP the verbatim quote ONCE at the
first block where it appears, and reference it via the prose-level
`\textit{Source: …}` line on subsequent blocks (no second verbatim
copy needed — comments are not rendered, but discipline keeps the
file readable).

## Out of scope

- DO NOT add `\leanok` or `\mathlibok` markers (the descriptor
  forbids it; deterministic sync handles markers).
- DO NOT touch any other `\begin{definition}` or `\begin{theorem}`
  block in the chapter — only the 2 named blocks split.
- DO NOT modify the Lean file `IdentityComponent.lean` — only the
  chapter. The new `\lean{...}` pins reference names that don't yet
  exist in Lean; that is intentional. The iter-186 plan agent will
  decide whether the iter-186 prover lane scaffolds those new
  declarations (file-skeleton extension), or whether they wait for a
  later iter.
- DO NOT consult new references; everything you need is already in
  the chapter's existing `% SOURCE QUOTE:` blocks.

## Expected outcome

`Picard_IdentityComponent.tex` grows by ~50-100 LOC (new theorem
blocks; minimal new prose since each split block is a 2-3-sentence
restatement of one prose conclusion). The 2 over-loaded blocks are
replaced by 4 + 3 = 7 separate blocks, each with its own pinned
Lean name. The HARD GATE for iter-187+ IdentityComponent body work
opens because each Lean declaration now matches its blueprint pin.

## Report

Write to `.archon/task_results/blueprint-writer-identitycomponent-split.md`:
- Per-block summary (which new label, which Lean pin, what prose).
- Source-quote distribution decisions.
- Any blueprint-level concerns (e.g. if you discover the prose
  conclusions are inconsistent or missing a needed step).
- Pointers to the new `\lean{...}` names you introduced (for the
  iter-186/187 plan agent's follow-up Lean-side scaffold).
