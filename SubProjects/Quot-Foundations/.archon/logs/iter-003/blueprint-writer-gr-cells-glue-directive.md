# Blueprint-writer directive — new chapter: Grassmannian cells + gluing (GR-cells / GR-glue)

## Chapter to create
`blueprint/src/chapters/Picard_GrassmannianCells.tex` (NEW file; you may spawn a
reference-retriever into `references/**` only if you reach material the local Nitsure
source does not cover — see "Retrieval" below).

## Coverage declaration
Put at the top of the new chapter:
`% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean`
(the GR-cells/GR-glue sub-phases formalize into QuotScheme.lean alongside the rest of
QUOT-repr). NOTE: `Picard_QuotScheme.tex` is ALSO edited this iter by a sibling writer;
do not edit it — only create your new chapter. A covered file may legitimately be
blueprinted across a consolidated chapter + a focused sub-chapter; keep your declarations
disjoint from QuotScheme's (you add the Grassmannian-construction lemmas only).

## Strategy context
`thm:grassmannian_representable` (phase QUOT-repr, estimated 6–12 iters) is currently one
monolithic proof block. STRATEGY decomposes it into GR-cells → GR-glue → GR-quot → GR-repr.
Your job: blueprint the first two sub-phases (GR-cells, GR-glue) as named lemma/definition
blocks so they become parallelisable, reviewable prover targets when QUOT unblocks. Work
the Nitsure §1 route: construct Gr(r,d) over ℤ by gluing affine charts, then base-change
to a general base S with vector bundle V later (GR-quot/repr, out of scope here).

## Key declarations (dependency order) — use the reviewer's outline
1. `\definition \label{def:gr_affine_chart}` — for each size-d subset I ⊆ {1,…,r}, the
   affine chart `U^I := Spec(ℤ[X^I])`, where `X^I` is the d×r matrix with identity d×d
   I-block and d(r−d) free entries; `U^I ≅ 𝔸^{d(r-d)}_ℤ`.
   `\lean{AlgebraicGeometry.Grassmannian.affineChart}` [expected].
2. `\definition \label{def:gr_transition}` — for I≠J, the transition map
   `θ_{I,J} : U^I_J → U^J_I`, `X^J ↦ (X^I_J)⁻¹·X^I` on the locus `det(X^I_J) ≠ 0`.
   `\lean{AlgebraicGeometry.Grassmannian.transitionMap}` [expected].
   `\uses{def:gr_affine_chart}`.
3. `\lemma \label{lem:gr_cocycle}` — the transition maps satisfy the cocycle condition
   `θ_{I,K} = θ_{J,K} ∘ θ_{I,J}` on `U^I ∩ U^J ∩ U^K` (associativity of matrix mult).
   `\lean{AlgebraicGeometry.Grassmannian.cocycleCondition}` [expected].
   `\uses{def:gr_transition, def:gr_affine_chart}`. Note the Lean backbone is
   `AlgebraicGeometry.Scheme.GlueData.cocycle_cond`.
4. `\definition \label{def:gr_glued_scheme}` — the Grassmannian scheme Gr(r,d) over ℤ from
   gluing `{U^I}` along `{θ_{I,J}}` via `Scheme.GlueData`; smooth over ℤ of relative
   dimension d(r−d). `\lean{AlgebraicGeometry.Grassmannian.scheme}` [expected].
   `\uses{def:gr_affine_chart, def:gr_transition, lem:gr_cocycle}`.
5. `\lemma \label{lem:gr_separated}` — Gr(r,d) is separated over ℤ: the diagonal is a
   closed immersion, checked on charts by `X^J_I · X^I = X^J`.
   `\lean{AlgebraicGeometry.Grassmannian.isSeparated}` [expected].
   `\uses{def:gr_glued_scheme, def:gr_transition}`.
6. `\lemma \label{lem:gr_proper}` — Gr(r,d) is proper over ℤ via the valuative criterion
   for DVRs (extend over the DVR by the chart with minimal-valuation minor).
   `\lean{AlgebraicGeometry.Grassmannian.isProper}` [expected].
   `\uses{def:gr_glued_scheme, lem:gr_separated}`.

Each block gets a rigorous, formalize-grade informal proof (matrix algebra over ℤ / over a
DVR) — not a sketch.

## Citation discipline (MANDATORY)
Source: Nitsure §1 "Construction of Grassmannian / gluing affine patches",
`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (≈L773–L870). Open and read
it; every block carries `% SOURCE:` (with `(read from references/...)`), a verbatim
original-language `% SOURCE QUOTE:`, a `% SOURCE QUOTE PROOF:` immediately before each
proof env, and a visible `\textit{Source: [Nitsure], §1.}` first line. Do NOT cite from
memory.

## Retrieval
GR-cells/GR-glue is Nitsure §1 (gluing over ℤ) — covered by the LOCAL nitsure tex. You
should NOT need new sources. Only if a block genuinely requires §5 relative-base-change
material (it should not for cells/glue), spawn a reference-retriever for Nitsure §5; note
it in your report. Otherwise stay within §1.

## LaTeX / macros
If you need a new macro (e.g. for `𝔸^n_S`), define it in
`blueprint/src/macros/common.tex` before use — but prefer existing macros. Ensure
`\begin`/`\end` balance and that every `\label` is referenced/defined exactly once.

## Out of scope
- GR-quot (tautological quotient) and GR-repr (functor-of-points) — later sub-phases.
- The relative-over-S version with vector bundle V — work over ℤ first.
- Do NOT add `\leanok` or `\mathlibok` to any block (these are all to-be-proved project
  declarations; the deterministic sync owns `\leanok`).
- Do NOT edit `Picard_QuotScheme.tex` or any other chapter.

## After you create the chapter
Report the exact filename so the plan agent can `\input` it into `content.tex`. Put any
strategy-level surprises under "Strategy-modifying findings".
