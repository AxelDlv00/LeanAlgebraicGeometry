# Lean Audit Report

## Slug
iter161

## Iteration
161

## Scope
- files audited: 1 (`AlgebraicJacobian/AbelianVarietyRigidity.lean` — the only file with prover edits this iter, per directive)
- files skipped (per directive): rest of project — directive narrowed scope to the single edited file.

## Verification performed (read-only LSP)
- `lean_diagnostic_messages`: exactly 4 `sorry` warnings — L204 (`rigidity_eqAt_closedPoint_of_proper_into_affine`), L663 / L687 / L712 (the three pre-existing scaffold theorems). No errors.
- `lean_verify` axiom checks:
  - `eq_comp_of_isAffine_of_properIntegral` → `{propext, Classical.choice, Quot.sound}` — **axiom-clean, no `sorryAx`**. ✅
  - `morphism_eq_of_eqAt_closedPoints` → axiom-clean. ✅
  - `snd_left_isClosedMap` → axiom-clean. ✅
  - `rigidity_lemma` → includes `sorryAx` — honestly depends on the lone Step-1 residual (does NOT claim to be axiom-clean). ✅ consistent with docstrings.
- `lean_goal` at L263: residual obligation is `px ≫ U.ι ≫ f.left = px ≫ U.ι ≫ retract.left ≫ f.left` (i.e. the k̄-point slice-constancy `q ≫ f.left = q ≫ retract.left ≫ f.left`).
- `grep` for `axiom`: none.

## Per-file checklist

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none (the `sorry`s are honestly disclosed deferred obligations, not "wrong-but-works" admissions)
- **notes**:
  - **`eq_comp_of_isAffine_of_properIntegral` (L153) — SOUND.** Statement is true as written: over alg-closed `kbar`, a proper (`UniversallyClosed`) integral l.f.t. `k̄`-scheme `W` has `Γ(W) = k̄`, so any two `k̄`-sections `a,b` of `wk` agree after composing into an affine `V`. Every hypothesis is load-bearing: `IsAlgClosed` (collapses the finite extension via `ringHom_bijective_of_isIntegral`), `IsIntegral` (else `Γ(W)` not a field — two-point counterexample), `UniversallyClosed` (else `Γ(W)` not a field — e.g. `𝔸¹`), `LocallyOfFiniteType` (finiteness of `Γ` over `k̄`), `IsAffine V` (else `ext_of_isAffine` does not pin the map). Proof is honest, axiom-clean (verified), no laundering.
  - **`rigidity_eqAt_closedPoint_of_proper_into_affine` (L204) — TRUE-AS-STATED, sorry honestly disclosed.** The goal at a closed point of the saturated affine-landing open is a genuine mathematical truth (the slice `X_y ≅ X` is proper integral and maps to the affine `U₀`, forcing `f(x) = f(x₀,y)`). Load-bearing hyps present and faithful: `_hUV` (saturation — without it the slice is not contained in `U` and `_hfU` would not cover it), `_hfU` (affine-containment — without it the slice could map non-constantly into a projective target), `_hU₀` (affineness), `_hx` (closedness ⇒ `κ(x)=k̄`). NOTE: this Step-1 lemma correctly does **not** carry the collapse hypothesis `_hf` — that lives upstream in `rigidity_eqOn_dense_open` only for the non-emptiness of Mumford's `V`; it is not needed for the per-slice equation. This is **NOT** iter-157-style laundering: the headline `rigidity_lemma` honestly carries `sorryAx`, and the residual `sorry` statement is itself true (not a false/unsatisfiable premise propping a true headline).
  - **In-body reduction (L236–263) — SOUND.** `rw [← cancel_epi (Spec.map (residueFieldIsoBase …).hom)]` cancels a genuine iso (so an epi) on the left; the `suffices`/`pointOfClosedPoint`/`hqsec` block reduces the residue-field-probe goal to the `k̄`-point equation, and `lean_goal` confirms the remaining obligation is exactly that equation. Closing the `sorry` therefore does suffice for the stated goal. `hqsec` is established (currently unused — staged for the future discharge, not laundering).
  - **`rigidity_eqOn_saturated_open_to_affine` (L294) — assembly SOUND, but docstring STALE.** Body is `sorry`-free in itself: it discharges `Z.left.IsSeparated` and `JacobsonSpace U` as routine instances and assembles `morphism_eq_of_eqAt_closedPoints` over the per-slice Step 1. The instance arguments match. HOWEVER the docstring (L276–278) still says it is "isolated here as a named top-level obligation with a precise statement and `sorry` body" — it no longer has a `sorry` body (it is assembled). See Major.
  - **`morphism_eq_of_eqAt_closedPoints` (L112), `snd_left_isClosedMap` (L90), `rigidity_snd_lift` (L71) — sound and axiom-clean.** No issues.
  - **`rigidity_eqOn_dense_open` / `rigidity_core` / `rigidity_lemma` docstrings** accurately describe the chain status (single residual `sorry` = Step-1 geometric assembly); consistent with the `sorryAx` dependency observed.
  - **L201 status tag stale**: docstring header says "**Status (iter-160):**" on a declaration whose body+reduction were edited iter-161. Minor.

## Must-fix-this-iter

None. No excuse-comments, no weakened/wrong definitions, no parallel-API copies, no suspect bodies on substantive claims (the `sorry`s are honest deferred obligations on true statements), no unauthorized axioms.

## Major

- `AbelianVarietyRigidity.lean:276-278` — `rigidity_eqOn_saturated_open_to_affine` docstring claims the lemma is "isolated here as a named top-level obligation with a precise statement and `sorry` body". The lemma is now **assembled** (Step 1 ∘ Step 2) and its own body is `sorry`-free. The docstring misrepresents the proof status (says `sorry` where there is an assembled proof). Update to "assembled from Step 2 over the per-slice Step 1; transitively depends on Step 1's residual `sorry`." — Why flagged: docstring/proof-status mismatch on a load-bearing chain link is exactly the "stale/overstating" class the directive asked to surface; here it *under*states (claims unproven where proven), which is equally misleading for downstream planning.

## Minor

- `AbelianVarietyRigidity.lean:201` — status tag reads "(iter-160)" on a decl edited in iter-161; bump to iter-161 for accuracy.
- `AbelianVarietyRigidity.lean:289-292` — the `rigidity_eqOn_saturated_open_to_affine` docstring's "intended proof" prose says the globaliser feeds `ext_of_isDominant_of_isSeparated'`; the actual assembly routes through `morphism_eq_of_eqAt_closedPoints` (which internally uses `ext_of_isDominant`). Prose vs. realised-proof drift only.

## Excuse-comments (always called out separately)

None. The deferred `sorry`s are accompanied by precise mathematical descriptions of the residual obligation, not admissions of wrong code.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (stale docstring under-stating `rigidity_eqOn_saturated_open_to_affine`'s status)
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: The two new/edited proofs are sound — `eq_comp_of_isAffine_of_properIntegral` is genuinely axiom-clean and the reduced Step-1 lemma is true-as-stated with an honestly-disclosed residual `sorry` (not iter-157-style laundering); the only real issue is one stale docstring that still calls the now-assembled `rigidity_eqOn_saturated_open_to_affine` a `sorry`-bodied obligation.
