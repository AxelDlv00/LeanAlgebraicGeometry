# blueprint-writer — pic0-identity-component-chapter

## Iter

184

## Why this dispatch

iter-183 blueprint-reviewer flagged this as a **must-fix-this-iter
unstarted-phase proposal**: A.3 `Pic⁰` identity + degree has zero
blueprint coverage, blocking the A.2.c → A.3 → A.4.d pipeline. Writing
the chapter unblocks the substrate construction
(`GroupScheme.IdentityComponent` is "NEW PROJECT MATERIAL" per
`STRATEGY.md`) for downstream Lean work, and lets the Albanese-UP
wiring in A.4.d.ii consume `Pic⁰` once it lands.

## Chapter to create

**File**: `blueprint/src/chapters/Picard_IdentityComponent.tex`

**Strategy phase**: A.3 (`Pic⁰` identity + degree). Iters left ~16–28
per `STRATEGY.md`. Substrate `GroupScheme.IdentityComponent` is
UNOWNED (NEW PROJECT MATERIAL).

**Single .lean covered**: `AlgebraicJacobian/Picard/IdentityComponent.lean`
(file does NOT yet exist; skeleton owed iter-185+; this chapter is the
authoritative spec).

## Content scope (the writer's task)

Write the chapter at textbook-rigour level using the references named
below. The chapter must contain at least these declarations (in
dependency order), each with the citation discipline below:

1. **`\definition{IdentityComponentGroupScheme}`** —
   `\label{def:identity_component_group_scheme}`,
   `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent}`. For a
   group scheme `G` over a base `S` with identity section `e : S → G`
   factoring through `G`, the **identity component** `G⁰` is the
   open-and-closed subgroup scheme of `G` whose underlying topological
   space is the connected component of the image of `e`.
2. **`\theorem{IdentityComponentOpenSubgroup}`** —
   `\label{thm:identity_component_open_subgroup}`,
   `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme}`.
   For a group scheme `G` locally of finite type over a field `k`, the
   identity component `G⁰` is an open subgroup scheme.
3. **`\definition{Pic0Subscheme}`** —
   `\label{def:pic_zero_subscheme}`,
   `\lean{AlgebraicGeometry.Scheme.Pic0Scheme}`.
   `Pic⁰_{C/k} := (Pic_{C/k})⁰`, the identity component of the Picard
   scheme.
4. **`\definition{DivisorDegreePic}`** —
   `\label{def:divisor_degree_pic}`,
   `\lean{AlgebraicGeometry.Scheme.PicScheme.degree}`. The degree map
   `deg : Pic_{C/k}(k) → ℤ` extracted from the Hilbert-polynomial
   decomposition of `Pic_{C/k}`.
5. **`\theorem{Pic0IsAbelianVariety}`** —
   `\label{thm:pic_zero_is_abelian_variety}`,
   `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety}`.
   `Pic⁰_{C/k}` is a smooth proper geometrically irreducible group
   scheme of dimension `g(C)` — an abelian variety of dimension `g`.

`\uses` skeleton (cross-chapter):
- `thm:identity_component_open_subgroup` uses
  `def:identity_component_group_scheme`.
- `def:pic_zero_subscheme` uses `def:identity_component_group_scheme`,
  `def:pic_scheme` (from `Picard_FGAPicRepresentability.tex`).
- `def:divisor_degree_pic` uses `def:pic_scheme` (from
  `Picard_FGAPicRepresentability.tex`) and any `def:hilbert_polynomial`
  pin (from `Picard_QuotScheme.tex`).
- `thm:pic_zero_is_abelian_variety` uses `def:pic_zero_subscheme`,
  `thm:identity_component_open_subgroup`, `def:divisor_degree_pic`,
  `def:genus` (from `Genus.tex`), `thm:fga_pic_representability`
  (from `Picard_FGAPicRepresentability.tex`).

## Design choice (Choice A vs Choice B, per iter-183 review)

**Use Choice A**: build `Pic⁰` as the open-and-closed identity-component
subgroup scheme of the abstract group scheme `Pic_{C/k}`, via the
abstract `GroupScheme.IdentityComponent` API. This keeps the substrate
gap localised to the identity-component construction (Stacks tag
0B7R / 0B7T) and avoids coupling `Pic⁰`'s definition to the degree
map.

**Substrate keeps in chapter**: the underlying
`GroupScheme.IdentityComponent` construction stays in this chapter
(rather than being split off into a separate
`GroupScheme_IdentityComponent.tex`), with a `% NOTE: future split
candidate when a second consumer materialises` marker. iter-183
reviewer rationale: substrate is small (~200–300 LOC), a separate
chapter is premature.

## Citation discipline (HARD RULE)

You MUST follow the citation discipline from `.archon/prompts/plan.md`
exactly:

1. Every theorem / definition block has `% SOURCE: <pointer> (read
   from references/<file>)` BEFORE the `\begin{...}` environment.
2. Every block has `% SOURCE QUOTE: <verbatim original-language text>`
   BEFORE the environment.
3. Every block has `\textit{Source: ...}` as the first prose line
   INSIDE the environment.
4. Every proof block has `% SOURCE QUOTE PROOF: <verbatim>` BEFORE
   `\begin{proof}` (when source provides a proof — for substrate
   constructions where the source is an existence theorem rather than
   a proof transcript, use `% SOURCE QUOTE PROOF: (substrate
   construction — source proves existence; assembled here from
   <list>)`).
5. NO source from memory — you must actually open the local source
   file under `references/` and copy verbatim. If the file you need
   is not on disk, dispatch the `reference-retriever` subagent
   (your `--write-domain` allows this) to fetch it FIRST, then come
   back and quote.

## Sources you should consult

Open these local files (your `--write-domain` lets you read them all):

1. `references/abelian-varieties.pdf` (Milne *Abelian Varieties*
   2008 course notes) — §III.6 (the Albanese / Picard scheme of a
   curve), specifically Prop 6.1 / Thm 6.4. This is your primary
   source for declarations 3 and 5.
2. `references/kleiman-picard.pdf` (Kleiman *The Picard scheme*
   FGA Explained / arXiv:math/0504020) — §5 (Hilbert-polynomial
   decomposition of `Pic_{X/S}`) and §6 (the identity component
   construction). Primary source for declarations 1 and 4.
3. `references/mumford-abelian-varieties.pdf` (Mumford *Abelian
   Varieties*) — §III.6 + §III.13 if Milne is too thin on the
   smoothness-in-char-p case.
4. **You will likely also need**: Stacks tag 0B7R / 0B7T for the
   abstract group-scheme identity-component construction. Check
   whether `references/stacks-*.md` cache already covers these tags;
   if not, dispatch `reference-retriever` to fetch the Stacks tex
   (your `--write-domain` allows this).
5. Optional: any `references/hartshorne-algebraic-geometry.md` (if
   present) → IV.4 for the Jacobian as an abelian variety in the
   char-0 case.

## Proof strategy guidance

The identity-component construction extracts the open-and-closed
subscheme containing `η_J` from representability of `Pic_{C/k}` as a
disjoint union of quasi-projectives (Theorem 4.1 of
`Picard_FGAPicRepresentability.tex` already pins this disjoint-union
structure). Dimension is `g` by Riemann–Roch / Serre duality on
`Pic⁰` (Milne III.6); smoothness in characteristic `p` requires
care (Milne IV §13–14) but in char 0 is automatic. Geometric
irreducibility follows because `Pic⁰_{C/k}` is the connected
component of the identity by construction. The degree map is the
index of the Hilbert-polynomial component containing a given class
(Kleiman §5).

## Markers — DO NOT write

- **Do NOT add `\leanok` markers** anywhere. The deterministic
  `sync_leanok` phase adds them based on the actual Lean source
  status. You write the chapter; the loop manages `\leanok`.
- **Do NOT add `\mathlibok` markers** anywhere. The review agent
  manages those.

## Out-of-scope

- Do NOT touch any other chapter; this dispatch is single-chapter.
- Do NOT write Lean code or speculate about specific Mathlib
  lemma names beyond `[expected]` hints already given.
- Do NOT introduce new strategy decisions; if you spot a
  strategy-modifying finding, surface it under
  "Strategy-modifying findings" in your report (the planner will
  STOP and update STRATEGY.md before further Lean work).

## Out-of-scope: `\input` registration

You do NOT need to add `\input{chapters/Picard_IdentityComponent}` to
`content.tex` — the planner will do that manually after the chapter
lands, as a single-line update.

## Verification

After writing, your report should record:
- Citation count per source file (verifies you actually opened each
  file claimed in `% SOURCE: ... (read from ...)`).
- Whether you needed `reference-retriever` (and if so, what slugs).
- Any strategy-modifying findings.
- A summary of the 5 declarations + 5 proofs landed.
