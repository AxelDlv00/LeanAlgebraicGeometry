# blueprint-writer directive — cohflatbc (NEW chapter: Cohomology_FlatBaseChange)

## Goal
Create a NEW blueprint chapter `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` covering the
**smallest fully-ungated foundational piece of the A.2.c representability engine**: the `i=0` flat
base change for the pushforward of a quasi-coherent sheaf along a (separated, quasi-compact)
morphism. This seeds a future parallel prover lane (USER parallelism directive); it is INDEPENDENT
of the ⊗-substrate and RelPic work.

## Strategy context (the slice that matters)
The engine ultimately needs `R^i f_*` (i ≥ 1) and cohomology-and-base-change. This chapter is the
`i = 0` slice ONLY — `f_* F` commutes with flat base change — which is the easiest, fully-ungated
warm-up and a genuine building block. Do NOT write the higher `R^i f_*` material here (that is a
separate deferred chapter `Cohomology_HigherDirectImage`).

## Required content (one or two blocks)
1. **Definition/setup block** — the base-change square: `f : X → S`, a flat morphism `g : S' → S`,
   the fibre product `X' = X ×_S S'` with projections `g' : X' → X`, `f' : X' → S'`; a
   quasi-coherent `F` on `X`. The canonical base-change map `g^* (f_* F) → f'_* (g'^* F)`.
2. **Theorem block** — under (`f` quasi-compact + quasi-separated, `g` flat) the canonical map
   `g^* (f_* F) → f'_* (g'^* F)` is an isomorphism. Give a rigorous textbook proof sketch:
   reduce to the affine case (both `S = Spec A`, `S' = Spec A'`, `X` covered by affines), where it
   becomes `A' ⊗_A M ≅ (A' ⊗_A B)-module base change of M` / flatness of `A → A'`; then glue over a
   cover (Čech/separated-qcqs descent). Detail enough to formalize.

Leave `\lean{...}` hints as plausible target names (e.g.
`AlgebraicGeometry.flatBaseChange_pushforward_iso` / `…_isIso`) — the Lean file does not exist yet;
this is coverage-ahead-of-code, so do NOT claim the declarations exist.

## Citation discipline (MANDATORY — read the local source files and quote verbatim)
- `references/stacks-coherent.tex` — **tag 02KH** (flat base change of `R^i f_*`; part (2) is the
  `H^0`/`f_*` case). Open the .tex, find tag 02KH, copy the verbatim statement into a `% SOURCE
  QUOTE:` and the verbatim proof (or the relevant part) into `% SOURCE QUOTE PROOF:`. Use
  `% SOURCE: Stacks 02KH (read from references/stacks-coherent.tex)`.
- Optionally cross-cite Hartshorne III.9 (flat base change) if `references/hartshorne-algebraic-geometry.pdf`
  has the relevant statement — but the Stacks 02KH verbatim quote is the required anchor.
- If you need a source not present locally, you MAY spawn a reference-retriever (your write-domain
  includes `references/**`) — but stacks-coherent.tex should already be present.

## Out of scope
- Do NOT touch any other chapter. Do NOT write the `R^i f_*` (i≥1) material, cohomology-and-base-change
  (Grauert), relative Proj, or Quot construction — those are separate deferred chapters.
- Do NOT add `\leanok` / `\mathlibok` markers (deterministic sync / review own those).

## Note
This chapter will be `\input` into `content.tex` by the plan agent after you return.
