# Blueprint Writer Report

## Slug
rigiditykbar-piecei-realign-iter132

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/RigidityKbar.tex`

## Changes Made

- **Revised** `\begin{proof} \leanok` block of `lem:GrpObj_cotangentSpace`
  (lines ~112-122) — re-framed the construction prose as the iter-131
  Replacement (B) pure-term `noncomputable def` (was "iter-130 Lean
  construction"); replaced "extracted via `Classical.choice`" with
  "extracted via a `Classical.choose`-chain"; added a parenthetical
  pointing to the new "Iter-131 `Classical.choose`-chain body shape"
  paragraph and to the companion lemma
  `cotangentSpaceAtIdentity_eq_extendScalars` as the structural-shape
  rewrite handle. Mathematical content unchanged.

- **Revised** `% Lean signature stub` comment block of
  `lem:GrpObj_cotangent_bridge` (lines ~127-135) — reworded the
  preamble from "iter-130+ build target; bridges the iter-128 body
  construction" to "iter-130+ build target; bridges the iter-131
  chart-base-changed Kähler body of `\cref{lem:GrpObj_cotangentSpace}`";
  added a 6-line note pinning the lemma's `\notready` status as
  vestigial-on-live-path under Replacement (B), pointing to the
  rank-lemma's Q4-collapse footer paragraph. Lean signature stub itself
  (the commented-out `noncomputable def` skeleton) unchanged.

- **Revised** `\begin{proof}` Step 1 of `lem:GrpObj_cotangent_bridge`
  (lines ~159-169) — re-framed Step 1 to start from the iter-131
  chart-base-changed body `k ⊗_{Γ(G, V)} Ω_{Γ(G, V)/Γ(Spec k, U)}`
  (was: "iter-128 body extends scalars of `(Ω_{G/k})(G)` along
  `ψ : Γ(G, 𝒪_G) → k`"). The factorisation through the local stalk
  now also includes the parallel base-side localisation
  `Γ(Spec k, U) → k`, and the bridge target is stated as the
  chart-independent `k ⊗_{𝒪_{G, η_G}} Ω_{𝒪_{G, η_G}/k}`. Step 2
  (residue-map identification with `𝔪 / 𝔪²`) and the closing
  paragraph are unchanged except for replacing the closing paragraph's
  "via `Classical.choice`" with "via the iter-131 `Classical.choose`-chain
  on `\cref{thm:smooth_locally_free_omega}`" for terminology consistency.

- **Rewrote** the `\begin{proof}` block of
  `lem:GrpObj_lieAlgebra_finrank` (lines ~201-241) — replaced the
  iter-128/iter-130 hybrid 4-step proof with a new 4-step structure
  matching the directive:
    - **Step 1 (chart-side Kähler rank)** — extract `hfree` and
      `hrank` from `\cref{thm:smooth_locally_free_omega}`'s existential
      directly; convert `hrank` (`Module.rank ... = ↑n`) to a
      `Module.finrank ... = n` over `Γ(G, V)` via
      `Module.finrank_eq_of_rank_eq` (Mathlib name verified iter-132).
    - **Step 2 (base-change to `k`)** — apply `Module.finrank_baseChange`
      with `hfree` discharging the `Module.Free` hypothesis to bring
      the `finrank` down to `k`, closing the rank lemma on the live
      (B) path. A separate sub-paragraph notes the companion freeness
      fact `Algebra.TensorProduct.instFree` (informational; not on the
      rank-lemma critical path; relevant for the consumer
      `\cref{lem:GrpObj_omega_free}`).
    - **Step 3 (alternative canonical route, currently deferred)** —
      demoted the iter-128-era 𝔪/𝔪² closure to a deferred alternative:
      bridges via `\cref{lem:GrpObj_cotangent_bridge}` (currently
      `\notready`), then regularity + Krull-dim of the local stalk +
      `IsRegularLocalRing`/`Ideal.IsLocalRing.CotangentSpace`. Marked
      explicitly as off-live-path under Replacement (B); preferred
      only if a non-rigidity consumer requires the canonical
      stalk-side presentation.
    - **Step 4 (dualisation conclusion)** — carries the `finrank
      𝔤^∨ = n` conclusion across `k`-linear duality to deliver the
      consequent `finrank 𝔤 = n`.
  Added a **"Mathlib name summary (live closure path under
  Replacement (B))"** paragraph listing the four Mathlib names per
  directive: `Scheme.smooth_locally_free_omega` (project),
  `Module.finrank_eq_of_rank_eq`, `Module.finrank_baseChange`,
  `Algebra.TensorProduct.instFree` (informational); each with its
  Mathlib home file. Added a final **"Iter-131 strategy-critic Q4
  collapse (footer)"** paragraph documenting the trio→duo collapse
  on the live (B) path, with the (a') trigger condition at iter-133+
  for re-entering the live closure. Added
  `thm:smooth_locally_free_omega` to the proof's `\uses{...}` list.

- **Added** a new `\paragraph{Iter-131 \texttt{Classical.choose}-chain
  body shape (Lean encoding note).}` paragraph immediately after
  `rem:piece_i_first_target` (lines ~302-306, inside the subsection
  `\subsection{Piece (i): sub-lemma decomposition for iter-128+ build}`).
  ~10-15 lines documenting:
    - The iter-131 `let`-chain of
      `Classical.choose` / `Classical.choose_spec` accessors that
      introduces `U, V, e, h_{xV}, ψ_V`.
    - The outer body shape
      `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V)
       Ω[Γ(G, V)/Γ(Spec k, U)])`.
    - The companion lemma `cotangentSpaceAtIdentity_eq_extendScalars`
      as a `rfl`-closed structural-shape rewrite handle.
    - The recommended downstream rewrite pattern
      (`obtain ⟨U, V, e, h_top, heq⟩ := ...`; rewrite `heq`; re-extract
      `hfree`/`hrank` on the same `Classical.choose`-chain; feed into
      `Module.finrank_baseChange`).
    - A pointer to `analogies/cotangent-body-shape.md` § "Future
      cleanup" for the deferred `Σ'`-bundled interface alternative.

## Cross-references introduced

- `\uses{thm:smooth_locally_free_omega}` added in proof of
  `lem:GrpObj_lieAlgebra_finrank` — `thm:smooth_locally_free_omega`
  is defined in `blueprint/src/chapters/Differentials.tex` and is
  already in the project's blueprint graph (it is the forward
  Jacobian criterion).
- New textual cross-reference to "Iter-131 `Classical.choose`-chain
  body shape" paragraph appears from (a) the `lem:GrpObj_cotangentSpace`
  proof's "Caveat on canonicity" paragraph and (b) Step 1 of the
  `lem:GrpObj_lieAlgebra_finrank` proof. The paragraph itself is a
  `\paragraph{}`-level item with no `\label{}`, so cross-references
  are by section name in text, not by `\cref{}` (LaTeX paragraphs
  are not naturally referencable without an explicit label).
- `\cref{lem:GrpObj_omega_free}` cross-reference added in the rank
  lemma proof's "Companion freeness fact" paragraph (Step 2's
  companion); `lem:GrpObj_omega_free` exists in this chapter (piece
  (i.c) `\notready` lemma).

## Macros needed (if any)

None — all macros used (`\Spec`, `\Over`, `\GrpObj`, `\finrank`,
`\notready`, `\leanok`, `\cref`, `\texttt`, `\mathfrak`, `\mathrm`,
etc.) are already established in the chapter or `macros/common.tex`.
The `\paragraph{}`-style mini-section follows the existing pattern
already used elsewhere in the chapter (e.g. "Iter-127 over-k
commitment", "Iter-127 over-k risk register").

## Reference-retriever dispatches (if any)

None — all references named in the directive were already in the
project's references / analogies directories
(`analogies/cotangent-body-shape.md`,
`analogies/lieAlgebra-rank-bridge.md`,
`AlgebraicJacobian/Cotangent/GrpObj.lean`,
`AlgebraicJacobian/Differentials.lean`). The Mathlib names listed
under "Required content" (`Module.finrank_baseChange`,
`Module.finrank_eq_of_rank_eq`,
`Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`,
`Algebra.TensorProduct.instFree`) are stated by the directive itself
as "verified iter-132"; I propagated those Mathlib home file paths
verbatim from the directive (`Mathlib.LinearAlgebra.Dimension.Constructions`,
`Mathlib.LinearAlgebra.Dimension.Finrank`,
`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`,
`Mathlib.RingTheory.TensorProduct.Free`).

## Notes for Plan Agent

- **Out-of-scope siblings left untouched as instructed:**
  `lem:GrpObj_mulRight_globalises` (piece (i.b), `\notready`),
  `lem:GrpObj_omega_free` (piece (i.c), `\notready`),
  `lem:GrpObj_omega_rank_eq_dim` (piece (i.c), `\notready`), the
  chapter intro / § Statement / § Proof decomposition / shared-pile
  intro list / § Use in the project / § Mathlib status — all
  unchanged.
- **`rem:piece_i_first_target` was left unchanged** even though it
  still describes the original trio (definition + bridge + rank) as
  "the natural first target" rather than reflecting the iter-131 Q4
  duo collapse. The directive did not explicitly authorize editing
  the remark, and the remark's text remains accurate at the
  description level (the trio is still defined, even if the bridge
  is currently `\notready` and not on the live path). If the plan
  agent wants the remark to also reflect the duo collapse — i.e., a
  sentence like "Under iter-131 Replacement (B), the live closure is
  the duo (definition + rank); the bridge is currently deferred" —
  that is a small follow-up that fits naturally next to the rank
  lemma's footer paragraph. Surfacing as a Notes-level suggestion
  rather than acting on it.
- **Cross-reference style for the new paragraph:** I used in-text
  references ("see \S 'Iter-131 `Classical.choose`-chain body shape'
  below") rather than a `\cref{...}` cross-reference because
  `\paragraph{...}` blocks are not naturally referenceable without
  an explicit `\label{}`. If the plan agent wants
  `\cref{}`-clickable references in the typeset blueprint, the next
  pass could add an explicit `\label{par:iter131_choose_chain}`
  (or convert the paragraph to a `\subsubsection{...}` with a
  label). Both are minor stylistic choices and out of scope for
  this directive.
- **LaTeX validity check:** balanced environments verified by
  `grep -c "\\begin{X}"` vs `\\end{X}` for `proof`, `lemma`,
  `remark`, `theorem`, `itemize`: all match (proof 6/6, lemma 6/6,
  remark 2/2, theorem 1/1, itemize 5/5). File grew from 281 to 324
  lines.

## Strategy-modifying findings

None. The directive was a coherent re-alignment pass against the
iter-131 Lean body of `cotangentSpaceAtIdentity` and the iter-131
Q4 strategy-critic duo collapse already documented in STRATEGY.md.
The prose re-write surfaced no new strategy-level issues: the
4-step proof structure for the rank lemma matches what the iter-132
prover lane will formalize against `Scheme.smooth_locally_free_omega`
+ `Module.finrank_eq_of_rank_eq` + `Module.finrank_baseChange`, and
the demotion of the 𝔪/𝔪² route to Step 3 (deferred) matches the
iter-131 Q4 trio→duo collapse already recorded in the strategy.
