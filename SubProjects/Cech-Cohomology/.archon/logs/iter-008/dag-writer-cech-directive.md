# Blueprint Writer Directive

## Slug
cech-coverage

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Strategy context
This chapter (`% archon:covers AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`)
develops the {\v C}ech computation of higher direct images: the push--pull functor
`G : (Over X)ᵒᵖ → X.Modules`, the {\v C}ech nerve/complex, affine acyclicity, and the
comparison theorem (the protected, frozen goal `cech_computes_higherDirectImage`). Its
mathematical roadmap is COMPLETE and correct. **This is NOT a math-content round.**

The single remaining task is **1-to-1 Lean ↔ blueprint coverage hygiene**. The P1/P2
push--pull formalization created 10 internal helper declarations in
`CechHigherDirectImage.lean` that have NO blueprint entry; `leandag` reports them as
`lean_aux` nodes, blocking the DAG's 1-to-1 completeness criterion. Each is already proved
sorry-free in Lean (effort 0). They need blueprint homes so the graph is complete.

## Required content

Read `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` for the exact signatures and
docstrings of every declaration named below (line numbers given as a guide). Then cover the
10 uncovered declarations, preferring to FOLD definitional/component helpers into the
`\lean{}` list of the existing block they implement (`leandag` matches every comma-separated
name in a `\lean{...}`). Add a NEW block only where a helper is substantive enough to deserve
its own statement.

**The `rawPushPullMap` layer** — `rawPushPullMap` (L389) is the un-coerced, over-triangle-free
form of the push--pull comparison map underlying `def:push_pull_map`
(`AlgebraicGeometry.pushPullMap`). The existing `def:push_pull_map` block already describes the
five-step composite. Cover the raw layer as follows:
- FOLD `rawPushPullMap` and `pushPullMap_eq_raw` (L406, the identity relating the coerced map
  to the raw form) into the `\lean{}` of `def:push_pull_map`, OR add ONE short
  `\begin{lemma}` `\label{lem:raw_push_pull_map}` `\lean{AlgebraicGeometry.rawPushPullMap}`
  describing the transport-free form and stating `pushPullMap_eq_raw` (the coerced map equals
  the raw map composed with the over-triangle `eqToHom` coercions). Append `pushPullMap_eq_raw`
  to its `\lean{}`. `\uses{def:push_pull_map}`. One-line proof ("By definition, unfolding the
  over-triangle coercions.").
- FOLD the raw-map functoriality identities into the matching existing law blocks:
  - `rawPushPullMap_self` (L455) and `rawPushPullMap_self_gen` (L472) — the raw-map identity
    law — append to `lem:push_pull_id` (`pushPullMap_id`) OR to
    `lem:push_pull_transport_cancel` (read the Lean: `rawPushPullMap_self` is the raw form of
    the over-triangle cancellation; place it where its math lives).
  - `rawPushPullMap_comp` (L536) — the raw-map composition law — append to
    `lem:push_pull_comp` (`pushPullMap_comp`).
  - `pushPull_pentagon` (L491) — the pseudofunctor pentagon/associativity coherence used in
    the composition law — append to `lem:push_pull_comp`, or fold into `lem:push_pull_unit_mate`
    if the Lean shows it is the mate-calculus core. Read the Lean to decide.
  - `pushPull_unit_comp` (L358) — the adjunction-unit composition identity — append to
    `lem:push_pull_unit_mate` (`pushPull_unit_mate`), whose statement is exactly the
    unit/mate identity.
  - `pushforwardComp_hom_app_id` (L377) — the pushforward-comparison-at-identity normalisation —
    append to whichever law block consumes it (likely `lem:push_pull_id`; read the Lean).

**The cover {\v C}ech nerve over `X`** — `coverCechNerveOver` (L651) and
`coverCechNerveOverAug` (L660) are the (non-augmented and augmented) {\v C}ech nerve of the
cover arrow realized as a simplicial object in `Over X` (the geometric backbone (1) lifted to
the over-category, before applying `G`). The existing `def:cover_cech_nerve`
(`AlgebraicGeometry.coverCechNerve`) describes the augmented simplicial scheme backbone.
- Append `coverCechNerveOver` and `coverCechNerveOverAug` to the `\lean{}` of
  `def:cover_cech_nerve` if they are the same backbone repackaged in `Over X`; OR add ONE short
  `\begin{definition}` `\label{def:cover_cech_nerve_over}`
  `\lean{AlgebraicGeometry.coverCechNerveOver}` for the {\v C}ech nerve as a simplicial object
  in the over-category `Over X` (degree `p` = the `(p+1)`-fold fibre power packaged as an
  `X`-scheme), appending `coverCechNerveOverAug` (its augmented form) to the `\lean{}`.
  `\uses{def:cover_arrow}` (and `def:cover_cech_nerve`). Read the Lean to confirm the precise
  relationship and phrase a one-line statement. This is the backbone consumed by
  `def:cech_nerve_cosimplicial` via the push--pull functor.

For every NEW block: concise mathematical statement, `\label{}`, exact `\lean{}`, accurate
`\uses{}`, and a one-to-two-line informal proof/description. Folded component names need no
new prose.

## Out of scope
- Do NOT alter existing statements, proof sketches, or source citations beyond appending names
  to `\lean{}` lists and adding the `\uses{}` edges named above.
- Do NOT touch the protected block: `cech_computes_higherDirectImage`
  (`lem:cech_computes_cohomology`) is a frozen-signature protected declaration — you may not
  edit its statement block. You are not asked to; leave it untouched.
- Do NOT touch `\leanok` markers.
- Do NOT edit other chapters or `content.tex`.
- Do NOT add new mathematical content beyond covering the 10 listed helpers.

## References
These helpers are internal plumbing of the push--pull functor and {\v C}ech nerve, both
already cited in this chapter (`references/stacks-coherent.tex`,
`references/stacks-cohomology.tex`). No NEW external source is required — they are
category-theoretic coherence/transport identities (the push--pull functoriality discussion in
the chapter's §"three-part construction" already explains the mate/pentagon coherence the raw
layer realizes). Only add a `% SOURCE:` block if you introduce externally-sourced content
(you should not need to). Your write-domain includes `references/**` should you need a
retriever.

## Expected outcome
After this round, `leandag build` followed by `archon dag-query unmatched` reports ZERO
`lean_aux` nodes from `CechHigherDirectImage.lean` — all 10 helpers folded into existing law
blocks' `\lean{}` lists or covered by at most ~3 new dedicated blocks (raw push--pull map,
cover {\v C}ech nerve over `X`). No new broken `\uses{}`, no new isolated blocks. The
protected goal block is untouched; the chapter's mathematical content is otherwise unchanged.
