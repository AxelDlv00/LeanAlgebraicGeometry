# blueprint-reviewer directive — iter-245 (slug: loctriv-regate)

You perform your usual whole-blueprint audit. The SPECIFIC gate decision I need from this run is for
ONE chapter that was rewritten THIS iter, so I can clear the HARD GATE and dispatch a prover on its
Lean file `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` in the SAME iter (sanctioned same-iter
fast path).

## Chapter under gate: `Picard_TensorObjSubstrate.tex`, § `sec:tensorobj_pullback_monoidality`

This section was rewritten this iter (blueprint-writer loctriv-pivot + blueprint-clean loctriv) to
PIVOT off an abandoned route. Context so you can judge correctness:

- **OLD (abandoned) route:** build a *general* concrete strong-monoidal inverse-image pullback
  (`lem:pullback_lan_decomposition` D1, `lem:pullback0_tensor_iso` via `Lan` + Mathlib-absent
  filtered-colimit/⊗ interchange, `lem:pullback_tensor_iso` general) to get `f^*(M⊗N)≅f^*M⊗f^*N`
  for ALL modules — a 20–38-iter Mathlib-scale build. These blocks are now DEMOTED/off-path with
  NOTEs (math retained).
- **NEW (live) route:** the comparison iso is needed only on **locally-trivial (line-bundle) pairs**
  (the consumer carrier `OnProduct` is `{M // IsLocallyTrivial M}`). The new live target
  `lem:pullback_tensor_iso_loctriv` upgrades the already-PROVEN oplax comparison MAP
  `lem:pullback_tensor_map` to an iso via a chart-chase over a common trivialising cover, reducing to
  the unit pair where `lem:pullback_unit_iso` (PROVEN) applies. New sub-lemmas: `lem:pullback_tensor_map_natural`
  (D1'), `lem:pullback_tensor_iso_unit` (D2'), `lem:pullback_tensor_map_basechange` (D3', the sole
  genuinely-new sub-step, tensorator analog of the PROVEN `lem:pullbackObjUnitToUnit_comp`),
  `lem:pullback_tensor_iso_loctriv` (D4'). `lem:isinvertible_pullback` is re-routed onto the loc-triv
  comparison (now carries `IsLocallyTrivial M/N` hypotheses).

## What I need (gate criteria for this section)

For `Picard_TensorObjSubstrate.tex` report your standard per-chapter verdict (`complete`, `correct`),
and specifically judge:
1. Are the new lemmas D1'–D4' + the re-routed `lem:isinvertible_pullback` mathematically CORRECT and
   stated with enough detail to formalize (proof sketches actionable, not hand-wavy)?
2. Is the demotion of the old general-build blocks coherent — no live `\uses{}` edge still depends on
   the abandoned `lem:pullback0_tensor_iso` / general `lem:pullback_tensor_iso` from the
   `lem:isinvertible_pullback` path?
3. Any must-fix-this-iter finding touching this section?

If the section comes back complete + correct with no must-fix, the gate clears and I dispatch the
prover this iter. Also surface any unstarted-phase proposals and cross-chapter issues per your normal
audit, but the blocking decision is the above.
