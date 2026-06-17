# Blueprint Writer Directive

## Slug
fbc-revert

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Strategy context
A prior writer pass this session ("fbc-pivot") rewrote the obligation-2 discharge of the affine
base-change lemma to an "affine-local explicit-inverse + element-`ext`" route and flagged the
conjugate-counit route as superseded. **That route choice is REVERSED.** Reason (verified against the Lean
source): `pushforwardBaseChangeMap` is *defined* as an adjunction transpose
(`((pullbackPushforwardAdjunction g).homEquiv _ _).symm (inner)`), so any element-level evaluation unfolds
via `Adjunction.homEquiv_counit` to the mate form and lands back on `base_change_mate_gstar_transpose`. The
project's own source comment (FlatBaseChange.lean:2054-2057) records the per-generator/element route as a
dead end: *"`ext x` reduces the goal to the full opaque geometric composite applied to `1 ⊗ₜ x`, which
neither `rfl` nor `simp` can evaluate (the geometric counit/pullback/Γ have no element-level normal form) —
the abstract conjugate calculus above is the only tractable route."* Conversely the conjugate-counit route
is NOT exhausted: it has a **landed, compiling master counit-transport identity `huce`**
(FlatBaseChange.lean:2099) and a bounded, enumerated ~150-LOC remainder (steps 2–3 at lines 2109-2121).
The active route for obligation 2 is therefore the conjugate-counit calculus, closing
`base_change_mate_gstar_transpose` from `huce`.

## Required content

1. **REMOVE the three explicit-inverse blocks the prior pass added** (they describe a documented-dead
   route and have no Lean decls):
   - `\definition`/`\label{def:base_change_mate_section_inverse}` (`\lean{...base_change_mate_section_inverse}`),
   - `\lemma`/`\label{lem:base_change_mate_section_map_inverse_id}`,
   - `\lemma`/`\label{lem:base_change_mate_section_inverse_map_id}`,
   and the wrapping `\subsection{...}`/`\label{subsec:section_explicit_inverse}` that introduced them
   (the conservativity-framing subsection). Delete these blocks cleanly (no dangling `\begin`/`\end`).

2. **Revert `lem:pushforward_base_change_mate_cancelBaseChange` to the conjugate route** (re-aligning the
   blueprint with the LIVE Lean body, which routes through `generator_trace`):
   - statement+proof `\uses` route back through `lem:base_change_mate_generator_trace`,
     `lem:base_change_mate_section_identity`, `lem:base_change_mate_gstar_transpose` (the actual Lean
     dependency chain); DROP `def:base_change_mate_section_inverse`,
     `lem:base_change_mate_section_map_inverse_id`, `lem:base_change_mate_section_inverse_map_id`.
   - restore the proof prose to the adjoint-mate / generator-trace derivation (`IsIso Γ(α)` from
     `base_change_mate_generator_trace` ⟹ `Γ(α) = cancelBaseChange⁻¹`, no flatness). Keep the statement
     value (`= cancelBaseChange`) and its source quote.

3. **Remove the "superseded" framing on the conjugate route — it is ACTIVE again.**
   - Delete the remark added at the head of the conjugate-side leg-reindex chain that called conj-1a/1b,
     conj-2b/2c/2d, conj-2a, `conjPullbackFactor`, `gstar_transpose`, `section_identity`,
     `generator_trace` "inert scaffolding."
   - Remove the `% NOTE: SUPERSEDED` on `lem:base_change_mate_gstar_transpose`.
   - Restore any prose in `\subsection{The section-level base-change identity}` head that the prior pass
     changed to "explicit-inverse is the active discharge", so it describes the conjugate-counit route.

4. **Sharpen `lem:base_change_mate_gstar_transpose`'s proof block to the concrete `huce` remainder** (the
   iter-036 prover target). The proof has a landed master counit-transport identity `huce` (the conjugate
   `conjugateEquiv_counit_symm` of the comparison, with `hpullinv`/`hcounitL`/`hcounitR` fused — already
   compiling). Describe the remaining ~150-LOC telescoping as the steps to formalize:
   - **(a) inner reindex** `Γ_R(θ_in) = ρ` (the canonical `m ↦ (1⊗1)⊗m`, = `base_change_mate_inner_value`),
     **reproven INLINE** from the proved standalone `lem:base_change_mate_fstar_reindex_legs_unitExpand` +
     `lem:base_change_mate_fstar_reindex_legs_gammaDistribute` + `lem:gammaMap_pushforwardComp_*` +
     Seam-1 `lem:base_change_mate_unit_value` + `lem:pullbackPushforward_unit_comp` — NOT cited from the
     sorry-backed `lem:base_change_mate_fstar_reindex` / `_legs` / conj-2a;
   - **(b) one-generator close** `extendScalars ψ (ρ) ≫ ε^alg = regroupEquiv.inv` on `r'⊗m ↦ (1⊗r')⊗m`, a
     one-generator `ext` against `lem:base_change_mate_regroupEquiv`;
   - **(c) dictionary cancellation** matching `huce`'s `pullback_spec_tilde_iso` / tilde-counit factors
     against the `pushforward_spec_tilde_iso`/`pullback_spec_tilde_iso` baked into `Θ_src`/`Θ_tgt`.
   Update the proof block `\uses` to: `lem:base_change_mate_fstar_reindex_legs_unitExpand`,
   `lem:base_change_mate_fstar_reindex_legs_gammaDistribute`, `lem:base_change_mate_unit_value`,
   `lem:pullbackPushforward_unit_comp`, `lem:base_change_mate_regroupEquiv`,
   `lem:conjugateEquiv_counit_symm_mathlib` (the `huce` source; add a Mathlib anchor block if missing),
   `lem:pullback_spec_tilde_iso`, and the `gammaMap_pushforwardComp_*` collapse lemmas. Do NOT `\uses`
   `lem:base_change_mate_fstar_reindex_legs`/conj-2a (deliberately bypassed). Mark no `\leanok`.

## Keep unchanged (route-independent fixes from the prior pass — do NOT revert these)
- The `lem:base_change_mate_codomain_read_legs` mismatch fix (now describes the `pullbackComp` variable-legs
  form; the two `leftAdjointCompIso` Mathlib anchors live on conj-1a).
- The 4 coverage-debt blocks: `def:base_change_mate_codomain_read_legs_param`,
  `lem:base_change_mate_codomain_read_legs_eq_param`, `def:conjPullbackFactor`,
  `lem:conjPullbackFactor_eq_pullbackComp`.
- The `lem:gammaMap_pushforwardCongr_hom` sharpening to the `eqToHom` form.

## Out of scope
- Obligation 1 (the affine reduction / restriction-compatibility @ line 2303) — separate owed build.
- `flatBaseChange_pushforward_isIso` (the global flat case).
- Any `\leanok` marker.

## References
- The `huce` remainder is project-bespoke (the recipe is in the Lean source comments, no external proof to
  quote) — the `gstar_transpose` block stands on its sketch. Keep any pre-existing verbatim source quotes
  on `cancelBaseChange`/`regroupEquiv` intact. `references/summary.md` for the 02KH affine-base-change quote
  already in the chapter (unchanged).

## Expected outcome
The chapter's obligation-2 discharge is the conjugate-counit route again: `cancelBaseChange` routes through
`generator_trace`→`section_identity`→`gstar_transpose` (matching the live Lean), the explicit-inverse blocks
and superseded remarks are gone, and `lem:base_change_mate_gstar_transpose`'s proof block carries the
concrete `huce`-remainder steps (a)/(b)/(c) with accurate `\uses` as the iter-036 prover target. The
route-independent fixes (mismatch, 4 coverage blocks, gammaMap sharpening) are retained. leandag clean, no
`\leanok` touched.
