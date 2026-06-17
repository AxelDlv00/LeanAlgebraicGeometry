# Blueprint Writer Report

## Slug
tos-build-pivot

## Status
COMPLETE — the section `sec:tensorobj_pullback_monoidality` is rewritten to commit to the
concrete strong-monoidal pullback build; `lem:pullback_tensor_iso` is un-descoped and
decomposed (D1–D4) into named sub-lemmas, `lem:isinvertible_pullback` re-routes to the
3-line Stacks proof, and `lem:isinvertible_implies_locallytrivial` is demoted off-path.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Rewrote the section preamble** (the `\paragraph`s after the two intro paragraphs).
  Replaced the four old paragraphs ("The general comparison is descoped", "The route:
  local trivialisation", "Two negative results that pin the route", "Guardrail") with three:
  - **"The reduction to two general facts."** States `IsInvertible.pullback` is a 3-line
    consequence of (a) `lem:pullback_tensor_iso` (pullback ⊗-strong) and (b)
    `lem:pullback_unit_iso` (`f^*𝒪_X ≅ 𝒪_Y`), with the pull-back-the-inverse chain.
  - **"Why the general isomorphism is genuine content, not free."** Keeps the single
    negative-result paragraph: Γ is lax monoidal yet `Γ(ℙ¹,𝒪(1))=0` is not invertible, so
    the oplax comparison *map* is not enough — `δ` must be proved an *iso*. Explains why
    `lem:pullback_tensor_iso` is not a corollary of the oplax `lem:presheaf_pullback_oplaxmonoidal`.
  - **"The committed construction route."** The D1–D4 decomposition as an `itemize`, with
    the honest-cost note that D3 (filtered-colimit/tensor interchange + concrete `pullback₀`
    model) is Mathlib-absent and the multi-hundred-LOC content, while `distribBaseChange`,
    `leftAdjointUniq`, `sheafifyTensorUnitIso`, and the comparison map are in hand.
  - Removed all local-trivialisation / cover-route / "guardrail: not stalkwise" framing and
    the "descoped / off-path" claim for `lem:pullback_tensor_iso`.

- **Revised** `\label{lem:pullback_tensor_iso}` — un-descoped, now the COMMITTED build target.
  - Title dropped "--- descoped"; added `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}`.
  - `\uses` updated to `{def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso,
    lem:pullback_lan_decomposition, lem:pullback0_tensor_iso, lem:pullback_tensor_map}`.
  - Removed the "descoped / not formalised / no Lean declaration" paragraph; statement body
    now says it is the committed build target whose underlying morphism is `lem:pullback_tensor_map`.
  - Kept the `% SOURCE` / `% SOURCE QUOTE` / `\textit{Source}` for Stacks
    `lemma-tensor-product-pullback` verbatim (unchanged).
  - **Rewrote the proof** as the four-step concrete-model route (D1 decomposition, D2 scalar
    half strong via `distribBaseChange`, D3 topological filtered-colimit interchange flagged
    as the genuine Mathlib-absent build, D4 sheafify + transport along `leftAdjointUniq`),
    ending with the no-shortcut Γ remark.

- **Added lemma** `\label{lem:pullback_lan_decomposition}` (D1) — presheaf pushforward factors
  as fixed-ring pushforward ∘ restriction of scalars, so the pullback factors as
  `extendScalars ∘ pullback₀` with `pullback₀` the topological inverse image (`Lan` along
  `(Opens.map f.base)ᵒᵖ`). Proof sketch: left adjoint of a composite is the reverse composite
  of left adjoints. No Lean pin (assembly-level fact); Archon-original (no external SOURCE).

- **Added lemma** `\label{lem:pullback0_tensor_iso}` (D3) — `lean{...pullback0TensorIso}` —
  the topological inverse image commutes with ⊗ (filtered-colimit interchange). Proof sketch:
  pointwise `Lan` colimit formula, comma category `(F↓V)={U : f⁻¹V ⊆ U}` up-directed
  (`U₁∪U₂` upper bound), tensor commutes with filtered colimits (diagonal final). Explicitly
  flagged as the multi-hundred-LOC Mathlib-absent build, decomposition only (per directive
  out-of-scope: no full-rigour interchange proof).

- **Revised** `\label{lem:isinvertible_pullback}` — re-routed to the 3-line Stacks proof.
  - `\uses` (both statement and proof) now `{def:scheme_modules_isinvertible,
    lem:pullback_tensor_iso, lem:pullback_unit_iso}`; dropped
    `lem:isinvertible_implies_locallytrivial`, `lem:pullback_tensor_map`,
    `lem:isiso_of_isiso_restrict`, `lem:tensorobj_preserves_locally_trivial`,
    `lem:IsLocallyTrivial_pullback`.
  - `% NOTE:` rewritten to the 3-line-proof framing (witness `f^*N`; iso
    `(pullbackTensorIso)⁻¹ ≫ (pullback f).mapIso e ≫ pullbackUnitIso`; no cover, no local triv).
  - Kept the verbatim `% SOURCE` / `% SOURCE QUOTE` (statement) and `% SOURCE QUOTE PROOF:`
    (the 3-line Stacks proof) — both already present and correct against
    `references/stacks-modules.tex:4142–4157`.
  - Proof body rewritten to the Stacks proof: pull back the inverse `N`, compose
    `(lem:pullback_tensor_iso)⁻¹ ≫ f^*e ≫ pullbackUnitIso`, conclude `IsInvertible(f^*M)`.

- **Revised** `\label{lem:isinvertible_implies_locallytrivial}` — demoted off-path. Lemma and
  proof retained verbatim (the fact is true, kept for future A.2.c Quot-embedding). The
  `% NOTE:` now states it is OFF the `IsInvertible.pullback` critical path (the committed
  route never uses local triviality) and a prose sentence was added to the body recording it
  is for later use, not a dependency of `lem:isinvertible_pullback`.

## Cross-references introduced
- `\uses{lem:pullback_lan_decomposition}` and `\uses{lem:pullback0_tensor_iso}` added in
  `lem:pullback_tensor_iso` (statement + proof) — both labels are DEFINED by the two new
  blocks in this same chapter. ✓
- `\uses{lem:pullback_tensor_iso}` added in `lem:isinvertible_pullback` (statement + proof)
  and in the body of `lem:isinvertible_implies_locallytrivial` — target exists in this chapter. ✓
- `\uses{lem:presheaf_pushforward_laxmonoidal}` in `lem:pullback_lan_decomposition` — exists. ✓
- Verified balance excluding comments: lemma 50/50, proof 48/48, itemize 5/5.

## References consulted
- `references/stacks-modules.tex` — read L2385–2404 (`lemma-tensor-product-pullback`,
  statement + "Omitted" proof) and L4140–4164 (`lemma-pullback-invertible` statement +
  verbatim 3-line proof; `lemma-invertible-is-locally-free-rank-1` context). The verbatim
  `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` already in the chapter match these lines; I
  re-read them to confirm before re-routing the proofs.
- `analogies/presheaf-pullback-strong.md` (iter-244) — the verified D1–D4 decomposition: the
  `pushforward = pushforward₀ ∘ restrictScalars` factorisation, `extendScalars` strong via
  `distribBaseChange`, `pullback₀ = Lan (Opens.map f.base)ᵒᵖ` with `(F↓V)` up-directed, and
  the filtered-colimit/tensor interchange as the Mathlib-absent piece. Source of the precise
  Mathlib API names used in the prose.

## Macros needed (if any)
- None. `\operatorname*{colim}` is used (standard amsmath); the chapter already uses standard
  math macros and `\Scheme`, `\Pic`, etc. from `macros/common.tex`. No new macro introduced.

## Reference-retriever dispatches (if any)
- None. All required source material (`references/stacks-modules.tex`) was already on disk.

## Notes for Plan Agent
- **Route-choice is deliberate, not a cost reduction.** `analogies/presheaf-pullback-strong.md`
  rated the committed strong-monoidal build and the iter-243 local-trivialisation route as
  *equal cost* (both multi-hundred-LOC) and explicitly cautioned that calling
  local-trivialisation a mere "detour" is "not supported". The directive commits to the
  strong-monoidal route with eyes open and is honest about cost (D3 flagged Mathlib-absent).
  I wrote the chapter to that committed route. This is a route choice, not a strategy error,
  so it is recorded here rather than under "Strategy-modifying findings" — but the planner
  should be aware the chosen route is not cheaper than the one it replaces, only cleaner
  downstream (the 3-line `IsInvertible.pullback` and no reverse-bridge entanglement).
- **`sheafifyTensorUnitIso` / `pullback₀` model are Lean bricks, not blueprint labels.** The
  directive's D4 mentioned `\cref{lem:sheafify_tensor_unit_iso}`; no such labelled block
  exists, so I referenced the Lean brick `\mathtt{sheafifyTensorUnitIso}` in prose instead of
  emitting a dangling `\cref`. If you want a dedicated blueprint block for the
  sheafification-monoidality brick, that is a separate writer task.
- **`lem:IsLocallyTrivial_pullback`** is referenced by no block in this chapter after the
  edit (it was only in the old `lem:isinvertible_pullback` uses). It is presumably defined in
  another chapter; confirm it is not now orphaned project-wide if it existed only for the
  abandoned cover route.
- The two new sub-lemma blocks carry `\lean{...}` hints (`pullback0TensorIso`,
  and `pullbackTensorIso` on the main lemma) per the directive's intended names; the planner
  should confirm/finalise these Lean names before scaffolding. `lem:pullback_lan_decomposition`
  was left without a `\lean{...}` pin (it is an assembly-level structural fact whose final
  Lean shape — a `NatIso` of functors — the planner may want to name explicitly).

## Strategy-modifying findings
None. The chapter as written is mathematically sound and consistent with the committed route;
the equal-cost observation above is a route-selection note, not an invalidation of the
strategy (which already assumes the substrate is Mathlib-scale via every route).
