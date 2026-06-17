# Blueprint Writer Report

## Slug
gr-cells-glue

## Status
COMPLETE

All six directive declarations were written as named blocks with rigorous,
formalize-grade informal proofs, all grounded in the local Nitsure §1 source.
No retrieval was needed (everything is in the local nitsure tex, §1, gluing
over ℤ). No `\leanok`/`\mathlibok` markers added.

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex  (NEW FILE)

**Plan agent: `\input{chapters/Picard_GrassmannianCells}` this into `content.tex`**
so its 6 nodes enter the DAG. Coverage line at top:
`% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean`.

## Changes Made
- **Added definition** `\definition`/`\label{def:gr_affine_chart}`/`\lean{AlgebraicGeometry.Grassmannian.affineChart}` — for each size-`d` subset `I ⊆ {1,…,r}` the chart `U^I = Spec ℤ[X^I]` with identity `I`-block and `d(r-d)` free entries; `U^I ≅ 𝔸^{d(r-d)}_ℤ`.
- **Added definition** `\definition`/`\label{def:gr_transition}`/`\lean{AlgebraicGeometry.Grassmannian.transitionMap}` — `P^I_J = det(X^I_J)`, the principal open `U^I_J`, and the transition `θ_{I,J}: X^J ↦ (X^I_J)⁻¹X^I` with `θ_{I,J}(P^J_I)=1/P^I_J`. `\uses{def:gr_affine_chart}`.
- **Added lemma** `\lemma`/`\label{lem:gr_cocycle}`/`\lean{AlgebraicGeometry.Grassmannian.cocycleCondition}` — cocycle `θ_{I,K}=θ_{J,K}∘θ_{I,J}` (scheme form) / `θ_{I,K}=θ_{I,J}θ_{J,K}` (ring form), plus `θ_{I,I}=id`.
  - Proof added: full matrix-algebra computation `(X^I_K)⁻¹X^I_J · (X^I_J)⁻¹X^I = (X^I_K)⁻¹X^I` via associativity; also derives `θ_{J,I}∘θ_{I,J}=id`. `\uses{def:gr_transition, def:gr_affine_chart}`.
- **Added definition** `\definition`/`\label{def:gr_glued_scheme}`/`\lean{AlgebraicGeometry.Grassmannian.scheme}` — `Gr(r,d) → Spec ℤ` glued from `{U^I}` along `{θ_{I,J}}`; finite type, `U^I∩U^J=U^I_J`, **and smoothness of relative dimension `d(r-d)` folded into this block** (per directive #4, which assigns smoothness to the glued-scheme node). `\uses{def:gr_affine_chart, def:gr_transition, lem:gr_cocycle}`.
- **Added lemma** `\lemma`/`\label{lem:gr_separated}`/`\lean{AlgebraicGeometry.Grassmannian.isSeparated}` — `Gr(r,d)` separated over ℤ.
  - Proof added: diagonal checked on the cover `{U^I×U^J}`; restricted diagonal ring map surjective because `1/P^I_J = δ(1⊗P^J_I)`; matches Nitsure's `X^J_I X^I − X^J = 0`. `\uses{def:gr_glued_scheme, def:gr_transition}`.
- **Added lemma** `\lemma`/`\label{lem:gr_proper}`/`\lean{AlgebraicGeometry.Grassmannian.isProper}` — `Gr(r,d)` proper over ℤ.
  - Proof added: valuative criterion for DVRs; choose `J` minimising `ν(f(P^I_J))`, `g = f∘θ_{I,J}`, `ν(g(P^J_{K'})) = ν(f(P^I_{K'}))−ν(f(P^I_J)) ≥ 0`, each entry `x^J_{p,q} = ±P^J_{K'}` by cofactor expansion against the identity `J`-block ⇒ `g` factors through `R`; uniqueness from separatedness. `\uses{def:gr_glued_scheme, lem:gr_separated, def:gr_transition}`.

The six `\lean{}` targets are all under the `[expected]` namespace
`AlgebraicGeometry.Grassmannian.*` exactly as the directive specified.

## Cross-references introduced
- All `\uses{}` edges are **internal to this chapter** and resolve to labels
  defined in it (verified by inspection — the chain is
  `def:gr_affine_chart → def:gr_transition → lem:gr_cocycle → def:gr_glued_scheme → {lem:gr_separated, lem:gr_proper}`,
  with `lem:gr_proper` also using `lem:gr_separated`). No node is isolated.
- Prose `\cref{thm:grassmannian_representable}` and `\cref{chap:Picard_QuotScheme}`
  in the "Out of scope" section — both labels exist in
  `Picard_QuotScheme.tex` (not edited). These are prose cross-refs, **not**
  `\uses{}` edges.

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` — the only
  source. Verbatim `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks copied
  character-by-character from:
  - L807–L821 (minor convention + chart `U^I`) → `def:gr_affine_chart`
  - L822–L836 (`P^I_J`, `U^I_J`, `θ_{I,J}`) → `def:gr_transition`
  - L838–L848 (`θ_{I,I}=id`, cocycle condition) → `lem:gr_cocycle` (stmt+proof)
  - L843–L850 (gluing to a finite-type scheme; smoothness) → `def:gr_glued_scheme`
  - L856–L860 (Separatedness) → `lem:gr_separated` (stmt+proof)
  - L865–L891 (Properness, full valuative-criterion argument) → `lem:gr_proper` (stmt+proof)
- `blueprint/src/chapters/Picard_QuotScheme.tex` — read (not edited) to keep my
  labels/`\lean{}` targets disjoint from `def:grassmannian_scheme` /
  `thm:grassmannian_representable` and to align notation (`\mathrm{Gr}`,
  `\mathbb{A}`, `\Spec`).

## Macros needed (if any)
None. Used only macros already in `macros/common.tex` (`\Spec`, `\Z`, `\id`,
`\Quot`, `\cref`/`\Cref`) plus standard `\mathbb`, `\mathrm`, `\det`, `\binom`,
`\operatorname{Frac}`. Deliberately avoided `\texorpdfstring` in titles (a
hyperref macro not used elsewhere and risky in the web build) and did not
introduce a `\grass` or `\AA` macro — used `\mathrm{Gr}` and `\mathbb{A}` inline
to match `Picard_QuotScheme.tex`.

## Reference-retriever dispatches (if any)
None. GR-cells/GR-glue is entirely Nitsure §1 (gluing over ℤ), covered by the
local tex. No §5 relative-base-change material was required.

## Notes for Plan Agent
1. **Wire the goal edge (cross-chapter — I cannot edit `Picard_QuotScheme.tex`).**
   `thm:grassmannian_representable` is the eventual consumer of these
   construction lemmas, but its `\uses{}` set currently does not reference them.
   Once this chapter is `\input`, `lem:gr_proper` / `lem:gr_separated` /
   `def:gr_glued_scheme` will form a connected component that is **not yet
   linked to the project goal**. To connect it, add
   `\uses{def:gr_glued_scheme, lem:gr_separated, lem:gr_proper}` (and the
   chart/transition/cocycle defs as desired) to
   `thm:grassmannian_representable` in `Picard_QuotScheme.tex` — a one-line edit
   for the sibling QuotScheme writer or the plan agent. I left this edge out
   rather than editing another chapter.
2. **leandag could not yet verify my nodes**: `leandag build --json` parses
   `web.tex`, which does not `\input` my new chapter (blueprint_nodes stayed at
   54). After the `\input` is added, re-run `leandag` to confirm the 6 new nodes
   (and that none are isolated). Internal edges are verified by inspection.
3. The chart-overlap identification `U^I ∩ U^J = U^I_J` and `θ_{J,I}∘θ_{I,J}=id`
   are stated in prose where needed; if a prover wants them as standalone Lean
   helpers, they are natural sub-lemmas of `lem:gr_cocycle` /
   `def:gr_glued_scheme` but were not split out (the directive listed exactly 6
   declarations).

## Strategy-modifying findings
None. The Nitsure §1 route decomposes cleanly into the six blocks as STRATEGY
anticipated; every step (charts, transition, cocycle, gluing+smoothness,
separatedness, properness) is provable by elementary matrix algebra over ℤ / a
DVR exactly as the directive's outline assumed. No hidden hypothesis or
strategy-level gap surfaced.
