# Blueprint-writer directive — slug `linebundlepullback`

## Target chapter

`blueprint/src/chapters/Picard_LineBundlePullback.tex` (NEW chapter).

## Strategy phase

Route A.1.b — `LineBundle.Pullback` on `C ×_k T`. STRATEGY.md row labelled "gated on A.1.a". A.1.a's chapter `Picard_RelativeSpec.tex` is on disk (iter-172). This chapter unblocks A.1.c (RelPicFunctor), then all of A.2.* / A.3 / A.4.

## Scope (5 declarations + proof-sketches)

Per the iter-173 `blueprint-reviewer route173` proposal — landed at `.archon/task_results/blueprint-reviewer-route173.md` (read it for the full outline). The core declarations:

1. `\definition` `\label{def:line_bundle_on_product}` — a line bundle on a product `C ×_k T` is an invertible `O_{C×T}`-module. `\lean{AlgebraicGeometry.Scheme.LineBundle.OnProduct}` [expected]. Source: Hartshorne II §6 OR re-export of Mathlib `LineBundle` / `Modules.Invertible`.
2. `\definition` `\label{def:pullback_along_projection}` — the pullback functor `π_T^* : Pic(T) → Pic(C ×_k T)`. `\lean{AlgebraicGeometry.Scheme.LineBundle.pullbackAlongProjection}` [expected]. Source: Stacks tag 01HH + Hartshorne II §7.
3. `\lemma` `\label{lem:pullback_compose}` — `π_T^* ∘ π_{T'}^* = (π_T ∘ π_{T'})^*`. `\lean{AlgebraicGeometry.Scheme.LineBundle.pullback_pullback_eq}` [expected]. Source: Stacks tag 01HG.
4. `\theorem` `\label{thm:relative_pic_quotient_well_defined}` — the relative Picard presheaf `Pic^♯_{C/k}(T) := Pic(C ×_k T) / π_T^* Pic(T)` is a well-defined functor. `\lean{AlgebraicGeometry.Scheme.RelPicPresheaf.preimage_subgroup}` [expected]. Source: Kleiman §2.
5. `\theorem` `\label{thm:pullback_natural}` — for `g : T' → T` over `k`, the pullback `g^*` descends through the quotient. `\lean{AlgebraicGeometry.Scheme.RelPicPresheaf.functorial}` [expected]. Source: Kleiman §2 + Stacks 01HG.

## Constraints

- `% archon:covers AlgebraicJacobian/Picard/LineBundlePullback.lean` at the top.
- Each declaration block: `% SOURCE: <pointer> (read from references/<file>)` + `% SOURCE QUOTE: <verbatim>`. **You must open the local file and quote verbatim.** Authorized references (in `--write-domain`): `references/**`.
- For Mathlib re-exports (`thm:relative_spec_exists`-style aliasing): use `\mathlibok` candidate framing (do NOT add the marker — review-agent territory).
- Stay within the chapter scope: Route A.1.b only. Do NOT pull A.1.c (RelPicFunctor) or A.2.* content forward.
- **NEVER** add `\leanok` or `\mathlibok` markers (managed elsewhere).

## Sub-phase choice (planner directive)

The iter-173 reviewer's proposal recommends **Set-valued** `Pic^♯_{C/k}` for this chapter (lighter; the group refinement goes to A.1.c). Follow that recommendation. Document in `% NOTE:` why.

## Authorization

- `--write-domain 'blueprint/src/chapters/Picard_LineBundlePullback.tex'`
- `--write-domain 'references/**'` (you may dispatch a reference-retriever if Kleiman §2 needs to be fetched, or Stacks tags 01HG/01HH/01HK from `references/stacks-constructions.tex` need lookup).

## Verification step

After writing, re-read and verify:
- 5 `\lean{...}` pins present.
- 5 `% SOURCE:` / `% SOURCE QUOTE:` blocks present.
- `\uses{...}` graph is well-formed and root-able in `Picard_RelativeSpec.tex` declarations.
- Chapter ends with internal-consistency check: no forward refs to chapters that don't exist yet.
