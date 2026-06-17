# Blueprint Writer Report

## Slug
fbc-pivot

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

### Item 1 — obligation-2 route rewritten to the explicit-inverse argument
- **Added subsection** `\subsection{The section-level isomorphism via an explicit inverse}`
  / `\label{subsec:section_explicit_inverse}`, placed immediately before
  `lem:pushforward_base_change_mate_cancelBaseChange`. Opens with the conservativity
  framing (Γ conservative on the affine–affine model ⇒ bijective ⇒ iso) and fixes notation
  for the conjugated section-level map `θ : R'⊗_R M → (R'⊗_R A)⊗_A M`, generator value
  `r'⊗m ↦ (r'⊗1)⊗m`.
- **Added definition** `def:base_change_mate_section_inverse`
  / `\lean{AlgebraicGeometry.base_change_mate_section_inverse}` (to-be-built) — the explicit
  inverse `ι = regroup`, built from `regroupEquiv` and the two tilde–Γ counit/dictionary
  reads. `\uses{lem:base_change_mate_regroupEquiv, lem:base_change_mate_domain_read,
  lem:base_change_mate_codomain_read}`.
- **Added lemma** `lem:base_change_mate_section_map_inverse_id`
  / `\lean{...base_change_mate_section_map_inverse_id}` (to-be-built) — round-trip 1
  (`θ ⋙ ι = 𝟙`), proof by ModuleCat-ext / pure-tensor chase on `r'⊗m`.
- **Added lemma** `lem:base_change_mate_section_inverse_map_id`
  / `\lean{...base_change_mate_section_inverse_map_id}` (to-be-built) — round-trip 2
  (`ι ⋙ θ = 𝟙`), proof by pure-tensor chase on `(r'⊗a)⊗m` via the `A`-balancing.
- **Revised** `lem:pushforward_base_change_mate_cancelBaseChange` (the terminal IsIso
  assembly that feeds `affineBaseChange_pushforward_iso`): statement+proof `\uses` now drop
  `lem:base_change_mate_generator_trace` and route through
  `def:base_change_mate_section_inverse`,
  `lem:base_change_mate_section_map_inverse_id`,
  `lem:base_change_mate_section_inverse_map_id`; proof body rewritten to derive
  `IsIso Γ(α)` from the two round-trips (no generator-trace / adjoint-mate derivation).
  Statement value (`= cancelBaseChange`) and source quote retained.
- **Revised** the head prose of `\subsection{The section-level base-change identity}` to
  describe the explicit-inverse route as the active discharge of obligation 2.
- The two-obligation framing (obligation 1 = `base_change_map_affine_local`, the affine
  reduction, owed separately / out of scope; obligation 2 = section-level identity) was
  already present in `\subsection{The affine base-change lemma and its remaining
  obligations}` and is left intact; `affineBaseChange_pushforward_iso`'s proof already
  combines both.

### Item 2 — conjugate route marked SUPERSEDED (no deletions)
- **Added remark** at the head of the conjugate-side leg-reindex chain (before the
  reassoc Mathlib anchors) stating obligation 2 is now discharged by the explicit-inverse
  route, naming conj-1a/1b, conj-2b/2c/2d, conj-2a, `conjPullbackFactor`(+`_eq`),
  `gstar_transpose`, and the downstream `section_identity` / `generator_trace` as inert
  scaffolding retained only because their Lean decls still exist.
- **Added `% NOTE: SUPERSEDED`** to `lem:base_change_mate_gstar_transpose`.
- No block deleted.

### Item 3 — `lem:base_change_mate_codomain_read_legs` MAJOR mismatch fixed
- Rewrote the title/prose to the **`pullbackComp` (variable-legs)** form (pullback factor =
  project pseudofunctor coherence `pullbackComp_{e,Spec ιA}`, legs carried as free variables
  with `hfst/hsnd`), matching the pinned Lean decl.
- **Removed** `lem:leftAdjointCompIso_mathlib` and
  `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib` from this block's statement+proof
  `\uses`. (They were already present on `lem:base_change_mate_codomain_read_legs_conj`
  (conj-1a), so the "move onto conj-1a" was already satisfied.)
- Cleared the stale iter-035 planner-fix NOTE; left a short accurate NOTE pointing to conj-1a.

### Item 4 — 4 coverage-debt blocks added (placed beside conj-1a)
- **Added definition** `def:base_change_mate_codomain_read_legs_param`
  / `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs_param}` — codomain read with
  pullback factor abstracted as explicit iso argument `Pcomp`.
- **Added lemma** `lem:base_change_mate_codomain_read_legs_eq_param`
  / `\lean{...codomain_read_legs_eq_param}` — original read = `_param` at `pullbackComp`,
  by `rfl`.
- **Added definition** `def:conjPullbackFactor` / `\lean{AlgebraicGeometry.conjPullbackFactor}`
  — `leftAdjointCompIso` of the free legs `e`, `Spec ιA`. `\uses{lem:leftAdjointCompIso_mathlib}`.
- **Added lemma** `lem:conjPullbackFactor_eq_pullbackComp`
  / `\lean{...conjPullbackFactor_eq_pullbackComp}` — `= pullbackComp e.hom (Spec ιA)`.
  `\uses{def:conjPullbackFactor, lem:pullbackComp_eq_leftAdjointCompIso}`.
- Also wired conj-1a's `\uses` to include `def:base_change_mate_codomain_read_legs_param`
  and `def:conjPullbackFactor` (its Lean body literally calls both), for graph accuracy.

### Item 5 — `lem:gammaMap_pushforwardCongr_hom` sharpened
- Result corrected from "the identity morphism" to the precise `= eqToHom(h)` form
  (`h` the induced equality of section modules), matching the Lean statement
  `= eqToHom (by rw [hfg])`. Proof prose adjusted accordingly.

## Cross-references introduced / changed
- `\uses` on `lem:pushforward_base_change_mate_cancelBaseChange` (stmt+proof): dropped
  `lem:base_change_mate_generator_trace`; added `def:base_change_mate_section_inverse`,
  `lem:base_change_mate_section_map_inverse_id`, `lem:base_change_mate_section_inverse_map_id`.
- `\uses` on `lem:base_change_mate_codomain_read_legs` (stmt+proof): dropped the two
  `leftAdjointCompIso` Mathlib anchors.
- `\uses` on `lem:base_change_mate_codomain_read_legs_conj`: added
  `def:base_change_mate_codomain_read_legs_param`, `def:conjPullbackFactor`.
- New blocks' `\uses` link to `lem:base_change_mate_regroupEquiv`,
  `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`,
  `lem:pullback_fst_snd_specMap_tensor`, `lem:leftAdjointCompIso_mathlib`,
  `lem:pullbackComp_eq_leftAdjointCompIso`, `lem:base_change_mate_codomain_read_legs`.

### leandag verification
- `leandag build --json`: **0 conflicts, 0 unknown_uses**. Chapter has **0 isolated** nodes
  (`leandag query --isolated --chapter Cohomology_FlatBaseChange` → none).
- The 4 coverage-debt decls are now matched (no longer blueprint-without-Lean / Lean-without-block).
- The 3 new explicit-inverse decls correctly show as to-be-built (blueprint node, no Lean yet).
- LaTeX begin/end balanced (lemma 88/88, definition 14/14, proof 72/72, remark 2/2).
- No `\leanok` added or removed anywhere.

## References consulted
- No new citation blocks were authored: every block added this round is project-bespoke
  (explicit-inverse element chase) or a thin coverage-debt entry for an existing Lean decl,
  so no `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source:}` lines were written. The pre-existing
  verbatim quotes on `lem:pushforward_base_change_mate_cancelBaseChange`,
  `lem:base_change_mate_regroupEquiv`, etc. were left untouched. Consequently no
  `references/*.md`/`*.tex` files were opened for quote production this session.
- `references/summary.md` — read for the source index (stacks-coherent 02KH, stacks-schemes
  01I9), confirming the affine-base-change quote already in the chapter is the correct one.
- `blueprint/src/chapters/Cohomology_RegroupHelper.tex` — read to confirm the regroup label
  (`lem:base_change_regroup_linearEquiv`) and the in-chapter ModuleCat iso
  (`lem:base_change_mate_regroupEquiv`) the new inverse block builds on.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — read the actual signatures of the 4
  coverage-debt decls and `gammaMap_pushforwardCongr_hom` (the `eqToHom` form) to write
  faithful blocks.

## Macros needed (if any)
- None. `\ggg`, `\cref`, `\widetilde`, `\operatorname` are all already in use in this chapter
  / project macros.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- The 3 new explicit-inverse decls (`base_change_mate_section_inverse`,
  `base_change_mate_section_map_inverse_id`, `base_change_mate_section_inverse_map_id`) are
  to-be-built; they are the new prover targets for obligation 2. The hard content is the
  generator value of `θ` on `r'⊗m` (= `(r'⊗1)⊗m`), now to be obtained by a direct element
  chase through the affine dictionaries + `pullback_fst_snd_specMap_tensor` rather than via
  the abandoned `generator_trace`/`gstar_transpose`/conj-2a chain.
- `lem:base_change_mate_generator_trace` and `lem:base_change_mate_section_identity` are now
  off the critical path (cancelBaseChange no longer `\uses` them). Their Lean decls still
  exist and still build, so the blocks are retained; they are flagged in the superseded
  remark. The Lean proof of `pushforward_base_change_mate_cancelBaseChange` still references
  `generator_trace` until the prover rewrites it to the round-trip route — that is the
  intended next prover step, so the blueprint `\uses` now describes the target route, not the
  current Lean body. Worth a prover objective to realign the Lean.
- Obligation 1 (`base_change_map_affine_local`, the restriction-compatibility / affine
  reduction) is unchanged and remains the separately-owed Mathlib-absent build per directive.

## Strategy-modifying findings
- None.
