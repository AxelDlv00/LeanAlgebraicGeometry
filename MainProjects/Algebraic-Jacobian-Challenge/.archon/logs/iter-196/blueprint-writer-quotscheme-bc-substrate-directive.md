# Blueprint-writer directive — slug `quotscheme-bc-substrate`

## Chapter

`blueprint/src/chapters/Picard_QuotScheme.tex`

## Strategy context

Lane F (QuotScheme) is **STUCK** per iter-196 progress-critic. 4 iters,
0 closures. Plan-phase LOC estimate in iter-195 was off ~5× (predicted
~10-30 LOC, actual ~100-150 LOC). The progress-critic's primary
corrective is **blueprint expansion**: the chapter's current Beck-
Chevalley sketch is too thin to support prover closure.

## What you must add

Add a new subsection at the end of section
`\section{Cohomology and base change}` (after the existing
`\subsection{Iter-189 analogist-licensed unbundle pins}` around L1078)
documenting the iter-195 Beck-Chevalley 6-stage decomposition and the
(N1)–(N4) substrate gaps.

Specifically:

### New subsection: `\subsection{Iter-195 Beck-Chevalley 6-stage decomposition + (N1)–(N4) substrate}`

Place it directly before `\section{Lean encoding}` (around L1078).

The new content should include the following 4 named `\lemma` blocks
(or `\definition` blocks, whichever fits — they're the (N1)–(N4)
substrate naturality lemmas needed to close
`pullback_app_isoTensor_baseMap_sectionLinearEquiv`), each with:

1. A `\lean{...}` pin naming the planned project-side substrate
   declaration. These do NOT exist on disk yet; they are the substrate
   the iter-196+ prover will land. Suggested names:
   - `(N1)`: `AlgebraicGeometry.Scheme.Modules.baseMap_pullbackComp_apply`
   - `(N2)`: `AlgebraicGeometry.Scheme.Modules.baseMap_pullback_comp_apply`
   - `(N3)`: `AlgebraicGeometry.Scheme.Modules.baseMap_pullbackCongr_apply`
   - `(N4)`: `AlgebraicGeometry.Scheme.Modules.baseMap_inv_step3_open_immersion`

2. A `\uses{...}` listing the existing substrate it depends on
   (notably `lem:pullback_tildeIso`, the existing `_step1_apply` /
   `_step2_apply` Σ-pair identities, and `Scheme.Modules.baseMap`
   itself).

3. An informal proof body (NO Lean code; mathematical prose) tracing
   the adjoint-functor / pullback / unit composition route. The
   project's `Scheme.Modules.baseMap` ultimately comes from
   `pullbackPushforwardAdjunction.unit`; (N1)–(N3) are naturality
   squares of that unit at triples of morphisms; (N4) is the
   `step3` inversion via `restrictFunctorIsoPullback`.

4. LOC estimate (each sub-lemma) — be honest: ~20-30 LOC each, ~80-120
   LOC total for the 4. The iter-195 estimate of "~10-30 LOC" was for
   the *consumer*, not the substrate; the substrate gap is the
   ~100-150 LOC volume.

### And: expand the existing `def:pullback_app_isoTensor_sigma` block

The current proof sketch at the bottom of the `\definition` block
(around L893-899) refers to "Beck-Chevalley intertwining; iter-189+
build via the 5-step Tilde-isoTop route". Replace this paragraph with
a precise 6-stage decomposition mirroring the in-file comments at
`AlgebraicJacobian/Picard/QuotScheme.lean:999-1037`:

```
Stage 1 (closed via `_step2_apply` + inv_hom_id): ...
Stage 2 (uses (N1) baseMap naturality + `_step1_apply`): ...
Stage 3 (uses (N2) baseMap composition via pullbackComp): ...
Stage 4 (uses (N3) baseMap transport via pullbackCongr): ...
Stage 5 (uses (N2) again): ...
Stage 6 (uses (N4) step3 inversion): ...
```

Each stage should be ONE math sentence in the prose, naming the
substrate lemma it uses by `\cref{...}`. The blueprint is what the
prover reads; this is the explicit recipe it needs.

### Source citations

This is iter-187/189 mathlib-analogist-verified material. Specifically:
- Stages 2–4 use `pullbackPushforwardAdjunction` naturality (Mathlib
  `Mathlib.AlgebraicGeometry.Sheaves.Modules.Pullback`).
- Stage 6 uses `restrictFunctorIsoPullback` (Mathlib
  `Mathlib.AlgebraicGeometry.OpenImmersion`).
- The overall composition pattern is the Mathlib-canonical "tilde
  preserves cobase change" route from Stacks 01HQ /0BJ8 (already
  cited in the chapter at L918 and L953).

No NEW external sources needed; no reference-retriever dispatch
required.

## What you must NOT do

- Do NOT add or remove any `\leanok` or `\mathlibok` markers. Those
  are handled by the `sync_leanok` phase and review agent,
  respectively.
- Do NOT modify any Lean file.
- Do NOT touch other chapters.
- Do NOT speculate beyond the 4 substrate naming + the 6-stage
  decomposition. The chapter's coverage of A.2.b file-skeleton
  (Hilbert polynomial, Grassmannian, Quot representability) is fine
  as-is.

## Verification step

After your edit, the blueprint should compile (`leanblueprint
compile` is not required, but the LaTeX should be syntactically
valid). The new subsection's `\cref{...}` calls should reference
existing labels (notably `lem:pullback_tildeIso`,
`def:quot_canonical_basechange_map`,
`def:pullback_app_isoTensor_sigma`).

## Report shape

In `task_results/blueprint-writer-quotscheme-bc-substrate.md`:
- LOC delta of the chapter (one number).
- The 4 new `\lean{...}` pins introduced.
- One paragraph describing the structural shape of the new
  subsection.

Out-of-scope items reported under `## Strategy-modifying findings`
ONLY if the blueprint rewrite surfaces a strategic issue (e.g.
"actually the substrate IS in Mathlib at L<line> and the project's
named gap should re-export instead"). Otherwise omit that section.
