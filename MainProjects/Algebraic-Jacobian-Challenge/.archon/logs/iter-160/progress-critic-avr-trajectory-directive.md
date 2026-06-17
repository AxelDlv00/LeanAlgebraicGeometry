# Progress-critic directive — AV-rigidity route trajectory

Assess convergence of the single active route. One route block below; signals for the last 3 iters.

## Active route: AbelianVarietyRigidity.lean — the Rigidity-Lemma chain (genus-0 route (c))

Goal of this route: prove `rigidity_lemma` (Mumford Form I) axiom-clean, char-free, over an
algebraically closed base — the cube-free entry of the genus-0 arm. The chain is
`rigidity_lemma → rigidity_core → rigidity_eqOn_dense_open → rigidity_eqOn_saturated_open_to_affine`.
All of `rigidity_lemma`, `rigidity_core`, `rigidity_eqOn_dense_open`, `rigidity_snd_lift`,
`snd_left_isClosedMap` are now `sorry`-free in their own bodies; the chain's lone residual `sorry`
is the bottom helper `rigidity_eqOn_saturated_open_to_affine` (bridge 2 = slice-constancy).

### Per-iter signals (file = AbelianVarietyRigidity.lean)

- **iter-157**: prover fired `rigidity_lemma`. Status: landed but UNSOUND (dropped the collapse
  hyp `_hf`; helper false-as-stated). New helper added: `rigidity_snd_lift` (sound). File
  sorry-bearing decls: 4. Blocker phrase: "keystone laundered through unsatisfiable sorry".
- **iter-158**: refactor threaded `_hf` (soundness REPAIRED — false→true); prover fired
  `rigidity_eqOn_dense_open` → PARTIAL. Bridge 1 BUILT as new helper `snd_left_isClosedMap`
  (axiom-clean). Left 2 internal sorries (`hfib`, agreement equation). File sorry-bearing decls: 4.
  Blocker phrase: "two bridges need lemmas BUILT not FOUND".
- **iter-159**: mathlib-analogist consults resolved both bridges to concrete char-free routes;
  prover fired `rigidity_eqOn_dense_open` → `hfib` CLOSED (axiom-clean); bridge 2 EXTRACTED to new
  named helper `rigidity_eqOn_saturated_open_to_affine` (sorry body, route-B docstring).
  `rigidity_eqOn_dense_open` now sorry-free in own body. File sorry-bearing decls: 4 (but chain
  internal sorries 2→1). Global sorry 7→7. Blocker phrase: "dense-closed-points ⟹ hom-ext is the
  one missing connective (route B), ~1–2 iter".

Net trend over 3 iters: helpers ADDED = `rigidity_snd_lift` (157), `snd_left_isClosedMap` (158),
`rigidity_eqOn_saturated_open_to_affine` (159). Chain internal sorries: false-laundered (157) →
sound 2 sorries (158) → sound 1 sorry (159). Each added helper was either CLOSED axiom-clean or is
the single remaining honest residual — not an accumulating ring of un-closing helpers.

### Strategy estimate (verbatim from STRATEGY.md "genus-0 rigidity" row)
- Iters left: "cube-dominated: rigidity_lemma 1–2; full arm ~10–18 (cumulative keystone ≈8 elapsed
  + this)".
- Phase entered: route (c) committed iter-156/157 (the AbelianVarietyRigidity.lean file was created
  iter-157). So ~3 elapsed iters in the current decomposition.

### This iter's proposed objectives (iter-160)
- 1 DEEP lane: `AbelianVarietyRigidity.lean` — prove `rigidity_eqOn_saturated_open_to_affine` (the
  lone chain sorry) via route B (per-closed-slice constancy + dense-closed-points globalisation),
  decomposing into named sub-lemmas as needed; PARTIAL acceptable.
- 1 trivial cleanup lane (optional): `Cotangent/GrpObj.lean` — trim 2 stale docstrings flagged by
  the iter-159 lean-auditor (0-sorry file; cosmetic).

## What I need from you
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) for the AV-rigidity chain. Is the
sequence "add helper → close it or isolate the next honest residual" genuine convergence, or
helper-churn? Is firing the prover again at `rigidity_eqOn_saturated_open_to_affine` the right move,
or should something else happen first? Note: the cube + Riemann–Roch sub-builds remain entirely
unstarted and are the dominant downstream cost — flag if the iters-left is drifting toward
OVER_BUDGET.
