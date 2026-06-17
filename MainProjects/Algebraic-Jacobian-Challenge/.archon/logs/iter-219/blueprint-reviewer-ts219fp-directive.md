# Blueprint Reviewer Directive — SCOPED FAST-PATH (HARD GATE re-clearance)

## Slug
ts219fp

## Why this is a scoped fast-path dispatch
This is the sanctioned same-iter HARD-GATE fast path. A blueprint-writer (ts219dual) + blueprint-clean
(ts219) round just edited ONE chapter — `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — to
resolve the live must-fix items from the iter-218 per-file check and to ADD a decomposition of the
sheaf-internal-hom build. `lake build` is green (no Lean edits this iter). I need a fresh complete+correct
verdict on THIS chapter so a prover can be dispatched on its first new sub-step this iter.

Read the whole blueprint as you normally do, but the **verdict that gates this iter is for
`Picard_TensorObjSubstrate.tex` alone**. Report its `complete:` / `correct:` status and any
must-fix-this-iter findings on it specifically.

## What changed in this chapter (verify each was resolved correctly)

1. **[was MUST-FIX] `lem:tensorobj_inverse_invertible` proof** previously described constructing
   `L⁻¹ = ℋom(L,𝒪_X)` as if executable, but the object is Mathlib-absent. The writer reframed the proof
   as **infrastructure-blocked**: it now opens with an explicit note that the construction depends on a
   sheaf internal-hom of 𝒪_X-modules (absent at presheaf/sheaf/categorical level), states the route is
   realized once `sec:tensorobj_dual_infra` lands, and cross-references `lem:internal_hom_eval` /
   `lem:dual_isLocallyTrivial`. CHECK: does the proof prose now honestly represent the gap (not pretend
   the object is constructible), while keeping the correct mathematical route?

2. **[was MAJOR] `lem:tensorobj_assoc_iso` proof route mismatch.** A `Status (route mismatch, deferred)`
   note was added: the current Lean realization uses the whiskering composite (transitive open
   obligation), while the blueprint's gluing route is the intended obligation-free realization but needs
   morphism-level descent, deferred jointly with the dual block. CHECK: is this note accurate and clear?

3. **[was MINOR] superseded-block wording** "removed in iter-218" retracted (declarations still present).

4. **[NEW] `\section{...}\label{sec:tensorobj_dual_infra}`** decomposing the Decision-1 build into 5
   formalizable sub-steps + 2 remarks, sourced verbatim from `references/stacks-modules.tex`:
   - `def:presheaf_internal_hom` (`\lean{PresheafOfModules.internalHom}`) — slice formula
     `ℋom(M,N)(U):=M|_U⟶N|_U`;
   - `def:presheaf_dual` (`\lean{PresheafOfModules.dual}`);
   - `lem:internal_hom_eval` (`\lean{PresheafOfModules.internalHomEval}`) — evaluation `M⊗M^∨→R`;
   - `lem:internal_hom_isSheaf` (`\lean{AlgebraicGeometry.Scheme.Modules.dual}`) — sheaf condition;
   - `lem:dual_isLocallyTrivial` (`\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}`);
   - `rem:dual_discharges_inverse`, `rem:dual_via_stack`.
   CHECK: are these blocks (a) mathematically correct, (b) detailed enough that a prover could
   formalize the FIRST sub-step (`def:presheaf_internal_hom`), (c) well-formed (`\lean{}`/`\uses{}`/
   `\label{}` resolve), and (d) is the contravariance issue + slice-formula remedy explained clearly
   enough to guide a Lean construction?

## The gate question
Return `complete:` and `correct:` for `Picard_TensorObjSubstrate.tex`, and list any must-fix-this-iter
finding on it. If complete+correct with no must-fix, the gate is cleared and a prover may be dispatched
on `def:presheaf_internal_hom` (the first sub-step) this iter.
