# Blueprint-writer directive — bw255-eng (engine entry chapter)

## Task

Author a NEW blueprint chapter `blueprint/src/chapters/Picard_LineBundleCoherence.tex` for the
A.2.c-engine entry construction:

> **`IsLocallyTrivial M ⟹ M.IsFinitePresentation`** (a locally-trivial line bundle is a coherent,
> locally free rank-1 — hence finitely presented — `𝒪`-module), plus a rank-1 / flatness record.

This is the cheap, ON-PATH half of the Quot-scheme embedding's line-bundle coherence requirement
(the embedding's input is a `Pic⁰` point, whose carrier is already `IsLocallyTrivial`, so the
Mathlib-scale `IsInvertible ⟹ loc-triv` spreading-out is NEVER crossed). The full cost scoping lives
in `analogies/engine252.md` (read it in full) — the decomposition C1–C4 below is taken from there.

## Mathematical content to write (from analogies/engine252.md)

Target lemma (project-bespoke assembly; Lean name to pin, e.g.
`AlgebraicGeometry.Scheme.Modules.IsLocallyTrivial.isFinitePresentation`):
from `IsLocallyTrivial M` (`Picard/LineBundlePullback.lean:115`: `∀ x, ∃ affine U ∋ x, M.restrict U.ι ≅ 𝒪_U`)
produce `M.IsFinitePresentation` (Mathlib `SheafOfModules.IsFinitePresentation` via `QuasicoherentData`).

Four sub-steps, each its own `\begin{lemma}`/`\begin{definition}` block with `\lean{...}` pin and
`\uses{...}`:
- **C1 cover extraction** — turn pointwise `IsLocallyTrivial M` into an indexed affine OPEN COVER
  `{U_i}` of `X` with per-index trivialisation `e_i : M.restrict (U_i).ι ≅ 𝒪_{U_i}`. Flag the open
  question (chief unknown): the `J.over X` / `X.ringCatSheaf` site instances that `QuasicoherentData`
  demands (`HasWeakSheafify` / `WEqualsLocallyBijective` / `HasSheafCompose`) must be discharged —
  state this as a hypothesis/assumption to be verified when the Lean file is scaffolded.
- **C2 per-chart free presentation** — from `M.restrict U_i ≅ 𝒪_{U_i}` (rank-1 free) produce the
  trivial free presentation of `𝒪_{U_i}` (`SheafOfModules.free` + `ιFree`).
- **C3 assemble `M.IsFinitePresentation`** — package C1+C2 into `SheafOfModules.QuasicoherentData`
  + `IsFinitePresentation.mk`; `IsFiniteType` then free (`instIsFiniteTypeOfIsFinitePresentation`).
- **C4 rank-1 / flat record** — rank 1 and flatness are chart-local (`𝒪_{U_i}`); expose whatever the
  Quot embedding consumes.

## Source / citation discipline

The mathematical fact "a finite locally free (hence rank-1 invertible) module sheaf is finitely
presented / coherent" is standard. Provide a `% SOURCE:` + verbatim `% SOURCE QUOTE:` from a source
you READ locally. Candidate local sources already in `references/`:
- `references/stacks-modules.tex` (ch.17 "Modules on Ringed Spaces", §17.25 invertible modules, tag
  01CR / Def 01CS / Lemma 0B8K, lines ~4038–4411) — the invertible-module definition.
If you need a more specific tag for "finite locally free ⟹ finitely presented / coherent" (e.g. a
Stacks "Modules" or "Cohomology of Schemes" tag on finite locally free / coherent modules) and it is
NOT in `references/`, you ARE authorized (`references/**` in your write-domain) to spawn a
reference-retriever to fetch it; wait for it, read it, then quote verbatim. Do NOT fabricate a quote.

## Scope / constraints

- This is PREP for a future parallel prover lane (the Lean file `Picard/LineBundleCoherence.lean` does
  not exist yet; it will be scaffolded a later iter). Write the chapter so it is complete enough to
  scaffold + prove from.
- Do NOT add `\leanok` / `\mathlibok` markers (managed deterministically).
- Stay within `blueprint/src/chapters/Picard_LineBundleCoherence.tex` (+ `references/**` for retrieval).
- If drafting surfaces a strategy-level issue (e.g. the loc-triv ⟹ finite-presentation route has a
  hidden Mathlib-scale gap after all), STOP and report it under "Strategy-modifying findings" rather
  than papering it with vague prose.
