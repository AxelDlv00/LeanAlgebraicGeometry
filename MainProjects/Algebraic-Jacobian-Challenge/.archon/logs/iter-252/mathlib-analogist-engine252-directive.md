# mathlib-analogist engine252 — directive

## Mode: api-alignment

## Question (cost-scoping pass for a deferred, goal-required construction)
The project's A.2.c representability phase (build `Pic⁰_{C/k}` as an actual `Scheme`) needs, for the
Quot-scheme embedding, the construction:

    `IsInvertible M  ⟹  M is a coherent, locally free 𝒪-module of rank 1`

(Stacks tag `lemma-invertible-is-locally-free-rank-1`), where `M : Scheme.Modules X` /
`SheafOfModules`, and the project carries `IsInvertible M := ∃ N, Nonempty (M ⊗ N ≅ 𝟙_)` (Stacks 0B8K/01CX).
This is currently DEFERRED in STRATEGY.md with "cost UNRESOLVED … whether this is the same Mathlib-scale
spreading-out or a cheaper coherence statement is UNDECIDED." A fresh strategy critic flagged it as the
project's deepest unquantified risk and asked for a scoping pass NOW rather than ~12–16 iters out.

This is a SCOPING question, not a build request. **Tell me:**
1. Does Mathlib already have anything in this direction for `SheafOfModules` / `Scheme.Modules` — an
   "invertible ⟹ locally free of rank 1" statement, or the `Module.InvertibleModule` / `Module.Projective`
   / finite-locally-free / `Module.FinitePresentation` machinery that would compose into it? Search
   `Mathlib.RingTheory.PicardGroup`, `Mathlib.Algebra.Module.{Projective,FiniteType}`, the SheafOfModules
   coherence APIs, and `Mathlib.AlgebraicGeometry.Modules.*`.
2. Is the obstacle the same Mathlib-absent "finite-presentation spreading-out for SheafOfModules" that the
   FORWARD bridge `IsLocallyTrivial ⟹ IsInvertible` was found to need (Mathlib-scale, off-path), or is
   `IsInvertible ⟹ coherent loc-free rank 1` a strictly cheaper coherence/rank statement that can be
   assembled from existing Mathlib (e.g. via the local triviality already carried by the consumer)?
3. Give a realistic LOC / iter cost band and a 1-paragraph build sketch (the chain of Mathlib lemmas, or
   the named gap that must be built first). I will use this to re-estimate the A.2.c engine row and decide
   whether to open an engine prover lane in parallel with the substrate.

Write the persistent scoping note (cost band + build sketch + verified-present vs absent Mathlib pieces)
to `analogies/engine252.md`.
