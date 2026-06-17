# iter-271 objectives (prover dispatch)

3 lanes, all HARD-GATE-cleared, all with a pc271 corrective baked into the directive.

1. **DualInverse.lean** [fine-grained] — extract `sliceDualTransportInv` top-level def FIRST
   (CHURNING corrective), then `invFun` + `left_inv`/`right_inv`; `naturality` stretch.
   Gate cleared by the plan-agent invFun ε-direction prose fix.
2. **TensorObjSubstrate.lean** [fine-grained] — `sheafificationCompPullback_comp_tail` R1/R5
   recovery via `conjugateEquiv_whiskerLeft` (analogist `analogies/d3-mate271.md`), fallback =
   CompositionIso `leftAdjointCompNatTrans_assoc` reduction. STUCK corrective = analogist consult
   (completed pre-dispatch).
3. **CechHigherDirectImage.lean** [mathlib-build] — generalized kernel-cheap eqToHom-transport
   cancellation lemma (option b, free equality var + subst); escalate to def refactor (option a)
   if the kernel wall survives subst.

## Measurable bars
- L1: `sliceDualTransportInv` axiom-clean top-level def + `invFun` closed (internal holes 4→≤2).
- L2: `sheafificationCompPullback_comp_tail` axiom-clean (file-sorry 3→2), OR the
  `conjugateEquiv_whiskerLeft` `have` landed with a precise (a)–(e) blocker.
- L3: generalized eqToHom-cancellation lemma axiom-clean; `pushPullMap_comp` if budget remains;
  a precise kernel-wall report deciding the option-a escalation.

## Escalation ladder (next iter)
- DUAL: if the extraction does not typecheck → reassess the ≃ₗ-by-hand packaging.
- D3′: if the `conjugateEquiv_whiskerLeft` `have` is attempted but assembly stalls (6th PARTIAL)
  → switch the whole lane to the CompositionIso fallback.
- ENGINE: if option (b) hits the kernel wall → dispatch the refactor subagent for the
  transport-light `pushPullMap` redefinition (option a), then re-prove `pushPullMap_id`.
