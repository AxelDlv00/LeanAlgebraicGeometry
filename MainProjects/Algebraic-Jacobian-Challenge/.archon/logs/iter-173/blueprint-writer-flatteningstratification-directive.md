# Blueprint-writer directive — slug `flatteningstratification`

## Target chapter

`blueprint/src/chapters/Picard_FGA_FlatteningStratification.tex` (NEW chapter).

## Strategy phase

Route A.2.a — Flattening stratification of a coherent sheaf. STRATEGY.md row tagged **parallel-startable** (no project-side gate). Mathlib has Stacks 052H absent; this in-tree sub-build unblocks A.2.b (Quot representability) = the dominant Route A cost (~15–25 iters).

## Scope (4 declarations + proof-sketches)

Per the iter-173 `blueprint-reviewer route173` proposal — read its task result for the full outline. Core declarations:

1. `\definition` `\label{def:flat_locus}` — the flat locus of a coherent sheaf `F` on `f : X → S` is the open subset of `S` over which `F` is `f`-flat. `\lean{AlgebraicGeometry.Scheme.flatLocus}` [expected]. Source: Stacks tag 0532.
2. `\definition` `\label{def:flatteningStratification}` — the flattening stratification of `F` is a locally-finite stratification of `S` by locally closed subschemes such that the pullback of `F` to each stratum is flat. `\lean{AlgebraicGeometry.Scheme.flatteningStratification}` [expected]. Source: Stacks tag 052H.
3. `\theorem` `\label{thm:flatteningStratification_exists}` — for `f : X → S` proper finitely presented and `F` coherent on `X`, the flattening stratification of `S` exists. `\lean{AlgebraicGeometry.Scheme.exists_flatteningStratification}` [expected]. Source: Stacks 052H.
4. `\theorem` `\label{thm:flatteningStratification_universal}` — the flattening stratification represents the functor "$T → \{$morphisms $T → S$ along which `F` pulls back flat$\}$". `\lean{AlgebraicGeometry.Scheme.flatteningStratification_isUniversal}` [expected]. Source: Stacks 052H + Nitsure §4.

## Constraints

- `% archon:covers AlgebraicJacobian/Picard/FGAFlatteningStratification.lean` at the top.
- Each declaration block: `% SOURCE: <pointer> (read from references/<file>)` + `% SOURCE QUOTE: <verbatim>`. **You must open the local file and quote verbatim.** Authorized references in `--write-domain`: `references/**` (Stacks tags 0532 / 052H / 0533 live in `references/stacks-coherent.tex`; Nitsure §4 lives in `references/nitsure-hilbert-quot.pdf` / `.tex`).
- Stay within the chapter scope: Route A.2.a only. Do NOT pull A.2.b (Quot construction) content forward.
- **NEVER** add `\leanok` or `\mathlibok` markers.

## Sub-phase choices (planner directives)

The iter-173 reviewer's proposal exposes two sub-phase choices:

1. **Coherent vs finitely presented**: chapter should state existence for "coherent on `X`" (Mathlib `CoherentlyOf`) with `X → S` proper-of-finite-presentation, matching Nitsure §4. Add a `\subsection*{Variants}` note for the f.p. case.

2. **Locally-finite stratification API**: define a project-bespoke `Scheme.LocallyClosedStratification` type. Document this in `% NOTE:` as a Mathlib upstream PR candidate.

## Authorization

- `--write-domain 'blueprint/src/chapters/Picard_FGA_FlatteningStratification.tex'`
- `--write-domain 'references/**'` (authorize the reference-retriever if Nitsure §4 needs fetching — but `references/nitsure-hilbert-quot.pdf` already exists; check first).

## Verification step

- 4 `\lean{...}` pins.
- 4 `% SOURCE:` + `% SOURCE QUOTE:` blocks (verbatim from Stacks-Project + Nitsure).
- `\uses{...}` graph: no root in any other unwritten chapter (this is parallel-startable).
- The Mathlib gap "Stacks 052H not in Mathlib" surfaces in the chapter prose explicitly as a project sub-build.
