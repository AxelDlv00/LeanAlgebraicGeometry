# Blueprint Writer Report

## Slug
fbc-tilde

## Status
COMPLETE — all four required edits (A–D) landed; affine collapse traced explicitly and honestly, no strategy-modifying finding.

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

- **Added lemma** `\lemma`/`\label{lem:pushforward_base_change_mate_sections_direct}`/`\lean{AlgebraicGeometry.pushforward_base_change_mate_sections_direct}` — direct affine section-level value of the base-change map. New `\subsection{Tilde-transport direct proof of the section-level value}` (`\label{sec:fbc_tilde_transport_direct}`) inserted just before `lem:pushforward_base_change_mate_cancelBaseChange`. Statement: the conjugated map `Θ_src⁻¹ ⋙ Γ(α) ⋙ Θ_tgt : R'⊗_R M → (R'⊗_R A)⊗_A M` equals `cancelBaseChange⁻¹` (`r'⊗m ↦ (r'⊗1)⊗m`).
  - Proof sketch added: **Y** — and made the affine collapse EXPLICIT per directive part B (see below). `\uses{def:pushforward_base_change_map, lem:base_change_mate_domain_read, lem:base_change_mate_codomain_read, lem:pullback_spec_tilde_iso, lem:pushforward_spec_tilde_iso, lem:cancelBaseChange_mathlib}`. Carries a `% SOURCE QUOTE PROOF:` (verbatim Stacks "boils down to the equality" step) and a visible `\textit{Source: ...}` line. Ends with a `% LEAN HINT` comment.
- **Revised proof** `lem:pushforward_base_change_mate_cancelBaseChange` — REPLACED the conjugate-calculus proof body (was routing through `lem:base_change_mate_section_identity` → `lem:base_change_mate_gstar_transpose` via the generator trace) with the tilde-transport proof: cite `sections_direct` to get `θ = cancelBaseChange⁻¹` is iso → `IsIso Γ(α)` by conjugation → `IsIso α` by full faithfulness of `~(-)` on quasi-coherent source/target. The STATEMENT prose (the mathematical body, lines ~3322–3352 in the original) is unchanged.
- **Revised metadata** `lem:pushforward_base_change_mate_cancelBaseChange` (statement block) — updated the second `% NOTE:` to describe the tilde-transport route instead of the conjugate route, and re-pointed the statement-block `\uses{}` to drop `lem:base_change_mate_generator_trace, lem:base_change_mate_section_identity, lem:base_change_mate_gstar_transpose` and add `lem:pushforward_base_change_mate_sections_direct`. This is required for the DAG to actually drop the dependency (leandag aggregates statement + proof `\uses{}`); the mathematical statement prose was left intact.
- **Fixed dependencies (part D)** `lem:affine_base_change_pushforward` — verified its statement-block `\uses{}` (no `section_identity`/`gstar_transpose`, matches the §3 revised seam verbatim) and its proof-block `\uses{}` (likewise clean). No edit was needed there: the affine lemma already depended only on `pushforward_base_change_mate_cancelBaseChange`, so dropping `gstar_transpose`/`section_identity` from cancelBaseChange's deps removes them from the affine lemma's transitive chain automatically.

## Part B — affine collapse made explicit (the strategy-critic must-fix)

The proof unfolds `pushforwardBaseChangeMap`'s definition (the `(g^*⊣g_*)`-adjunct of `β = f_*η`, i.e. `α = ε_{f'_*(g')^*M̃} ∘ g^*(β)`) and evaluates each unit/counit layer concretely on a generator `r'⊗m`, citing one single-step tilde dictionary per layer:

1. **Inner unit `η`** (extension-of-scalars unit), via `pullback_spec_tilde_iso` for `g' = Spec(A → R'⊗_R A)`: `m ↦ (1⊗1)⊗m`.
2. **`f_* = restr_φ`**, via `pushforward_spec_tilde_iso`: restriction of scalars moves no elements, so `β: m ↦ (1⊗1)⊗m` read R-linearly.
3. **`g^* = R'⊗_R(-)`**, via `pullback_spec_tilde_iso` for `g = Spec ψ` (functoriality): `g^*(β) = id_{R'} ⊗ β`, `r'⊗m ↦ r'⊗((1⊗1)⊗m)`.
4. **Counit `ε`** (extension-of-scalars action map), via `pullback_spec_tilde_iso`: `r'⊗w ↦ r'·w`.

Composition: `r'⊗m ↦ r'·((1⊗1)⊗m) = (r'⊗1)⊗m = cancelBaseChange⁻¹(r'⊗m)`, the last step being the R'-action multiplying into the R' tensor slot — pure tensor universal property + the algebra map `φ`. **The collapse is genuine, not illusory:** it requires only the per-layer compatibility of each adjunction unit/counit with the single-step dictionaries (which the dictionaries, being natural isos of functors, already encode), NOT the multi-layer composite-`conjugateEquiv` recognition that `gstar_transpose` attempted. No flatness hypothesis. Hence **no `## Strategy-modifying findings`** — the bypass is real.

## Cross-references introduced
- `\uses{lem:pushforward_base_change_mate_sections_direct}` added in statement + proof of `lem:pushforward_base_change_mate_cancelBaseChange` — target is the new block in this same chapter.
- New block `\uses{}` cites `def:pushforward_base_change_map`, `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:pullback_spec_tilde_iso`, `lem:pushforward_spec_tilde_iso`, `lem:cancelBaseChange_mathlib` — all pre-existing `\leanok`/`\mathlibok` nodes in this chapter.
- Verified via `leandag build --json`: `unknown_uses: []`, `conflicts: []`, `isolated: 2` (unchanged — `lem:annih…`, `lem:gr_de…`; the new node is wired in, not isolated). 9 sorry nodes unchanged at the blueprint level (the new lemma carries no `\leanok` yet, as required).

## References consulted
- `references/stacks-coherent.tex` (L925–938) — verbatim `% SOURCE QUOTE PROOF:` for `lem:pushforward_base_change_mate_sections_direct` (the Stacks "boils down to the equality `(R'⊗_R A)⊗_A M = R'⊗_R M` as R'-modules" step). Confirmed character-for-character this session.
- Existing in-chapter blocks read for accurate notation: `def:pushforward_base_change_map` (the adjunct/unit definition), `lem:base_change_mate_domain_read` / `lem:base_change_mate_codomain_read` (Θ_src/Θ_tgt), `lem:pullback_spec_tilde_iso` / `lem:pushforward_spec_tilde_iso` (the dictionaries), `lem:cancelBaseChange_mathlib` (`cancelBaseChange_symm_tmul`).

## Macros needed (if any)
- None. `\ggg` (diagrammatic composition) and `\widetilde`/`\operatorname` are already used throughout the chapter.

## Reference-retriever dispatches (if any)
- None. The required verbatim source was already on disk in `references/stacks-coherent.tex`.

## Notes for Plan Agent
- The conjugate-calculus scaffolding (`conj-0/1/2b/2c/2d`, `lem:base_change_mate_gstar_transpose`, `lem:base_change_mate_section_identity`, `lem:base_change_mate_generator_trace`, `lem:base_change_mate_regroupEquiv`) **remains in the chapter** as dead-end record nodes per the directive. They are no longer on the critical path of `lem:affine_base_change_pushforward`. They still show as sorry/`\leanok` per their own state and may now appear as nodes whose only downstream consumer (`generator_trace` ← old cancelBaseChange proof) was cut — `generator_trace`/`section_identity`/`gstar_transpose` may become an isolated dead-end sub-DAG. leandag still reports only the prior 2 isolated nodes (these conjugate nodes have internal edges among themselves), so no broken-ref issue; flagging only so the reviewer knows the conjugate sub-DAG is now intentionally orphaned from the goal.
- Lean prover objective for this pivot (per blueprint-review §3, restated for convenience): (1) prove `pushforward_base_change_mate_sections_direct` by `ext`/`TensorProduct.induction_on` unfolding `pushforwardBaseChangeMap` to `ε ∘ g^*(f_* η)` and rewriting each unit/counit by the section images of the two tilde dictionaries, closing with `cancelBaseChange_symm_tmul`; (2) swap the body of `pushforward_base_change_mate_cancelBaseChange` to call it; (3) confirm `affineBaseChange_pushforward_iso` / `flatBaseChange_pushforward_isIso` close downstream.

## Strategy-modifying findings
None. The affine collapse to `r'⊗m ↦ (r'⊗1)⊗m` is genuinely derivable from the single-step tilde dictionaries + tensor universal property without re-invoking the section-level mate identity. The tilde-transport bypass is sound.
