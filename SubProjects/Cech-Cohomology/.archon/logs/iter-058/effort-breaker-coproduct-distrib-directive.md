# Effort-breaker directive — decompose `coproduct_distrib_fibrePower`

## Target

`lem:coproduct_distrib_fibrePower` in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(currently around line 7559; `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso}`,
a build-target that does not yet exist in Lean).

This is the load-bearing Mathlib gap of the Sub-brick-A "Stub 1" route. A progress-critic flagged
the route CHURNING precisely because this 120–200 LOC induction has been carried as ONE monolithic
lemma; the corrective is to split it into a `\uses`-linked chain of small, independently-formalizable
sub-lemmas so the next prover gets ready leaves rather than a black box.

## Granularity

**Fine — one mathematical claim per lemma.** The current single proof bundles: (1) a slice
reformulation, (2) a base case, (3) an inductive step that itself chains binary distributivity +
nested-coproduct flattening + reindexing. Each of these should become its own `\begin{lemma}` block
with its own `\label`, `\lean{...}` build-target name, `\uses{...}`, and a one-paragraph informal
proof. The top lemma `lem:coproduct_distrib_fibrePower` is then reduced to a short assembly proof
that `\uses{}` the new sub-lemmas.

## Proof structure (cut along these seams)

The existing proof sketch (read the block in situ, ~lines 7586–7621) already names the seams.
Decompose into roughly these sub-lemmas (rename/merge as your judgement dictates, but keep each a
single claim):

1. **Slice reformulation** — `widePullback_overX_eq_prod`: for a finite family over base `S` in a
   category with pullbacks, the wide fibre power over `S` equals the iterated product in
   `Over S` (the base `Over.mk (𝟙 S)` is terminal via `Over.mkIdTerminal`, and
   `WidePullbackCone.isLimitOfFan` exhibits the wide pullback as that product). This gives the
   recursion `P^{×(p+2)} = P ×_S P^{×(p+1)}`. MECHANICAL, reusable. Suggested
   `\lean{CategoryTheory.widePullback_overX_eq_prod}` (or an `AlgebraicGeometry.*` name if the
   prover will instantiate only at `Scheme`).

2. **Base case** — `coproduct_distrib_fibrePower_zero`: the 1-fold fibre power of `∐_i X_i` is
   `∐_i X_i` itself, indexed by `σ : Fin 1 → ι ≅ ι` (trivial reindexing).

3. **Binary one-sided distributivity (packaged)** — `prod_coproduct_distrib`: in a
   `FinitaryPreExtensive` category with pullbacks, for objects over `S`,
   `A ×_S (∐_τ Y_τ) ≅ ∐_τ (A ×_S Y_τ)` and symmetrically `(∐_i X_i) ×_S B ≅ ∐_i (X_i ×_S B)`,
   obtained from `CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_map` (the binary
   distributivity instance). This is the single application of the extensivity hypothesis.

4. **Nested-coproduct flatten + reindex** — `coproduct_fibrePower_reindex`: combine
   `∐_i ∐_τ (X_i ×_S Y_τ)` into `∐_{(i,τ)}` via `Limits.sigmaSigmaIso`, then reindex pairs
   `(i, τ) ↦ Fin.cons i τ : Fin(p+2) → ι`, identifying `X_i ×_S Y_τ` with the `(p+2)`-fold fibre
   power along `σ`. (Pure combinatorial reindexing once steps 1+3 are in place.)

5. **Inductive assembly** — the reduced `lem:coproduct_distrib_fibrePower`: induction on `p`, using
   sub-lemmas 1–4; structure maps agree because each iso commutes with the projection to `S`.

Then instantiate at `Scheme` (`lem:finitaryExtensive_scheme_mathlib` provides
`FinitaryPreExtensive Scheme` + `HasPullbacks`).

Preserve the existing Mathlib-anchor `\uses{}` targets (`lem:isIso_sigmaDesc_map_mathlib`,
`lem:sigmaSigmaIso_mathlib`, `lem:widePullbackCone_isLimitOfFan_mathlib`,
`lem:finitaryExtensive_scheme_mathlib`) and distribute them to the sub-lemma that actually uses each.

Do NOT add `\leanok` markers (managed by the deterministic sync). You MAY mark a genuine Mathlib
dependency anchor `\mathlibok` if you add one, but the new sub-lemmas above are project build-targets
(not Mathlib) — leave them unmarked.

Recipe context for the prover already exists at `analogies/stub1-scheme-coproduct.md`; cite it in the
sub-lemma informal proofs where relevant. This is Archon-original categorical infrastructure (no
external math source), so omit `% SOURCE` citation lines.
