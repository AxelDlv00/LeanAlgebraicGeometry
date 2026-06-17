# Directive — blueprint-writer, COE Stage 6 sub-gap expansion (iter-198)

## Mode
Update one chapter (`blueprint/src/chapters/Albanese_CodimOneExtension.tex`) to expand Stage 6 of `isRegularLocalRing_stalk_of_smooth` (line 526 of `AlgebraicJacobian/Albanese/CodimOneExtension.lean`) with a fully-explicit sub-gap decomposition. Iter-198 progress-critic verdict: STUCK (5-iter unchanged, prior iter-196 EXCISED, USER directive re-elevates to priority-2). The Stage 6 gap is ~300–500 LOC; the prover would encounter it cold without this expansion.

## Strategy context (the slice that matters)

A.4.c.0 — codim-≥2 conclusion. Inside `Albanese/CodimOneExtension.lean` the theorem `isRegularLocalRing_stalk_of_smooth` carries Stages 1–5 axiom-clean (closed iter-193 incl. Stage 5a + 5b). Stage 6 remains a single `sorry` at L526. iter-198 prover (Lane COE, mathlib-build mode) needs a precise sub-gap list to make incremental progress within one prover round; without it the prover will spend the budget on un-scoped substrate hunting.

## Required content for the chapter

Expand the `§"Smoothness yields a DVR at every codim-1 point"` section
(starts at L176 of `Albanese_CodimOneExtension.tex`) with a new
**Stage 6 sub-decomposition** sub-section. The decomposition should
list, with concrete Mathlib API state, each sub-gap that closes
Stage 6:

1. **Smooth-algebra Krull-dim formula** (Stacks 00OE):
   `dim S_q = dim R_p + trdeg(κ(p) → κ(q))` for `f : R → S` smooth
   of finite presentation, `q ∈ Spec S` mapping to `p ∈ Spec R`.
   For each Mathlib piece needed (`Algebra.IsStandardSmoothOfRelativeDimension`,
   `Algebra.formallySmooth`, `RingHom.krullDim`, `Algebra.IsSmooth.krullDim_stalk`),
   state existence (`exists` / `missing` / `needs-bridge`).
   The lemma is **Stacks 00OE** (`stacks-algebra.tex` if present, else
   stacks.math.columbia.edu/tag/00OE); cite the verbatim
   statement with `% SOURCE QUOTE`.

2. **Cotangent ↔ Kähler over a field** (Stacks 02JK):
   over a field `k`, the cotangent complex of a smooth ring map
   `k → S` at a closed point `q` with residue field `κ(q)` is the
   Kähler differential module
   `Ω_{S/k} ⊗_S κ(q) ≃ T*_{S/k, q}` (free of rank `dim S_q`).
   List the bridge lemmas (`Algebra.cotangentComplex`,
   `KaehlerDifferential.tensorPowerBasis`) and their Mathlib state.

3. **Stalk is regular local of dimension n** (assembly):
   from (1) + (2), `𝒪_{X, x}` is a regular local ring with
   `dim 𝒪_{X, x} = trdeg(κ(s) → κ(x)) + dim 𝒪_{S, s}` for
   `f : X → S` smooth of rel dim `n` at `x` with `s = f(x)`.
   In the codim-1 application (`X` smooth proper geom-irred curve
   over `k = κ(s)`), `dim 𝒪_{X, x} = 1` for `x` a closed point.

4. **Cascade** to `L723` + `L798` consumers — show how each
   subsequent sorry in the file collapses once Stage 6 lands.

For each sub-gap, write a small `\begin{lemma}` block (no proof, just
the typed statement + intended `\lean{...}` pin name + Stacks-tag /
Milne / Hartshorne anchor). Together these become the iter-199+
prover targets.

## Citation discipline (mandatory)

For every external citation, include:
1. `% SOURCE: <pointer> (read from references/<file>)`.
2. `% SOURCE QUOTE:` — verbatim text from the source (original
   language, original notation, every word).
3. `\textit{Source: …}` as the first visible prose line.
4. For proofs (if you write any informal sketches): `% SOURCE QUOTE PROOF:`
   immediately before `\begin{proof}`.

For **Stacks Project** tags: the local files are
`references/stacks-algebra.tex` (00OE region — confirm presence,
else fetch via reference-retriever child), `references/stacks-coherent.tex`,
`references/stacks-constructions.tex`. **Verify each tag exists in
the local file before quoting it.** If not present, dispatch the
reference-retriever to download the relevant Stacks chapter.

For **Milne**: `references/abelian-varieties.pdf`. **Thm 3.1** (p. 15)
and **Lemma 3.3** (p. 17) are the source anchors for A.4.c.0 +
A.4.c.1.

## Out-of-scope

- Do NOT add `\leanok` or `\mathlibok` markers (deterministic phases
  handle those).
- Do NOT touch any other chapter.
- Do NOT modify Lean files.
- Do NOT speculate about A.4.c.1 (Thm 3.2 assembly) beyond Stage 6's
  immediate cascade.

## --write-domain (passed by dispatcher)

- `blueprint/src/chapters/Albanese_CodimOneExtension.tex`
- `references/**`
