# Iter 002 — Plan

## State in
Build GREEN. 7 sorries: DualInverse {388,525,627,629}, TensorObjSubstrate {712,2623,2851}.
iter-001 ran both lanes FINE-GRAINED; both provers independently reported decomposition
**already complete** — every atomic sentence is an extracted named lemma. Residuals are
concrete multi-step recipes, not more sentences.

## Decision made
- **Switch both lanes fine-grained → `prove`.** Re-running fine-grained = "cosmetic recipe
  variation on same lane" failure mode (provers said: no sentence left to extract).
  - DUAL (DualInverse): L388/L525 are ONE shared technique — ε-naturality `erw` paste
    (`restrictScalarsLaxε` + `NatTrans.naturality`), confirmed to reduce via
    `ModuleCat.hom_ext`+`LinearMap.ext` to the pointwise ε-commutation eqn. L627/L629 =
    round-trip cancellation (`Iso.inv/hom_id` of `f.appIso` + `image_preimage_of_le` +
    `dualUnitRingSwap`/ε `@[simp]`). Anchor: Stacks 0B8K (dual); analogies/ma-legb262.md.
  - D3′ (TensorObjSubstrate): L2623 comp_tail = execute the NON-CIRCULAR fallback
    (analogies/d3-mate271.md): re-prove `sheafificationCompPullback_comp` wholesale via
    surjective/injective reduction of `leftAdjointCompNatTrans_assoc` (CompositionIso.lean:155),
    mirroring Mathlib `SheafOfModules.pullback_assoc`. ~40–60 LOC. Concrete recipe ⇒ attempt
    body (NOT "owed iter-N+"). L2851 only if comp_tail lands. L712 untouched (DUAL-downstream cycle).
- Reversal signal: a `prove` pass that closes 0 sorries + adds 0 partial tactic progress on
  the named recipe → next iter dispatch mathlib-analogist (cross-domain) on the cocycle.
- Soundness: not disproof-checking — iter-001 first attempt on this subproject; checker
  verified 16/16 pinned decls correct; targets are standard infra (dual loc-triv = 0B8K;
  equiv round-trips). No false-statement risk.

## Housekeeping
- Fixed all blueprint-doctor broken `\cref{chap:*}` (5 dropped parent chapters) → prose
  "(parent scope)" across 3 chapters. Doctor list now CLEAN.
- Coverage debt (95 unmatched lean_aux): re-defer. Reversal signal (frontier depends on
  unblueprinted helper) NOT fired — active targets all pinned; frontier nodes are SCAFFOLD
  (decls absent). Dedicated coverage pass once active sorries converge.

## Subagent skips
- strategy-critic: STRATEGY.md content unchanged this iter; iter-001 verdict SOUND, 0 live CHALLENGE/REJECT.
- blueprint-reviewer: covers-chapter `Picard_TensorObjSubstrate.tex` cleared HARD GATE iter-001 (complete+correct, no must-fix); only this-iter blueprint edit was doctor-mandated cosmetic `\cref`→prose cleanup in commentary (zero declaration/statement/`\uses`/proof change); no live must-fix on active chapters.
- progress-critic: only 1 prior prover iter (iter-001) — no K-iter (3–5) trajectory; critic returns UNCLEAR by its own "fresh route, 1–2 iters" definition. Re-dispatch at ≥3 prover iters.
