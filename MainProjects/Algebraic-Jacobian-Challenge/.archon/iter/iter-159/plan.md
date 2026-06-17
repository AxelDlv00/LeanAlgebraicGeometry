# Iter-159 plan-agent run

## Headline outcome

Iter-159 is the **bridge-resolution iter** mandated by the iter-158 binding fallback. The iter-158
prover lane on the genus-0 keystone's geometric heart `rigidity_eqOn_dense_open` returned PARTIAL:
bridge 1 (closed map) was BUILT (`snd_left_isClosedMap`, axiom-clean), leaving TWO internal sorries
(`hfib`, the agreement equation) that the prover confirmed need lemmas **BUILT not FOUND**. The
progress-critic had bound: BEFORE another prover round, dispatch a `mathlib-analogist` consult
scoped to the two bridges. Honored — and **both consults returned concrete, char-free, LSP-verified
routes**, turning a feared-deep residual into a tractable one:

- **`hfib` — SOLVED.** ≈10-line char-free `IsPullback`-pasting assembly + the COARSE
  `image_preimage_eq_of_isPullback` (`PullbackCarrier.lean:414`). The fine `Triplet`/`tensor`/
  residue-field route the iter-158 prover had located is the WRONG granularity (3 unnecessary
  sub-builds) — abandoned. Full 7-step skeleton captured in `analogies/rigidity-hfib.md`.
- **agreement equation (bridge 2) — RESOLVED, cohomology-FREE, ~1–2 iter.** The relative Stein /
  `f_*O=O` framing IS a genuine Mathlib gap (no SteinFactorization, no proper-pushforward
  connectedness) — explicitly NOT to be attempted. The global-sections + per-closed-point route B
  suffices without cohomology: `ext_of_isAffine` per closed slice (`κ(y)=k̄` ⟹ `Γ(X_y)=k̄` via
  `isField_of_universallyClosed`/`finite_appTop_of_universallyClosed` + alg-closed) → globalize over
  dense closed points (`closure_closedPoints`/Jacobson) via `ext_of_isDominant_of_isSeparated'`.
  One missing connective (dense-closed-points hom-ext), buildable from those pieces. Recipe in
  `analogies/rigidity-affineconst.md`.
- **Enabling sig change:** add `[IsAlgClosed kbar]` to the 3 chain lemmas (`rigidity_eqOn_dense_open`,
  `rigidity_core`, `rigidity_lemma`) — needed for bridge 2's `κ(y)=k̄`; the 3 downstream consumers
  already carry it, so propagation is free.

Then via the sanctioned same-iter fast path: **blueprint-writer eqon-bridges** encoded both routes +
the `[IsAlgClosed]` note into `AbelianVarietyRigidity.tex`; **scoped blueprint-reviewer
eqon-bridges-recheck** → complete+correct, **HARD GATE CLEARS**; **prover lane re-fired** at
`rigidity_eqOn_dense_open` with the concrete recipes (sig change + `hfib` + docstring cleanup +
deep work on bridge 2).

## Subagent verdicts (absorbed)

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| progress-critic | keystone-trajectory | **UNCLEAR-but-healthy** | iter-158 = genuine forward motion (unsound→sound, bridge 1 built axiom-clean, residual narrowed to honest gaps), NOT churn; throughput honest + on-schedule; consult-then-prover is the correct corrective; near-zero prover load fine. **Binds:** committal outcome by iter-160 (buildable sub-lemma OR explicit decomposition — both delivered this iter); keep the theorem-of-the-cube cost visible so the route doesn't slip OVER_BUDGET once the heart closes. |
| mathlib-analogist | rigidity-hfib | **ALIGN_WITH_MATHLIB** (proposal-stage) | No off-the-shelf lemma, but a ≈10-line char-free assembly via `IsPullback` pasting + `image_preimage_eq_of_isPullback`. Abandon the `Triplet`/residue-field route. `analogies/rigidity-hfib.md`. |
| mathlib-analogist | rigidity-affineconst | **PROCEED (route B) + ALIGN (`[IsAlgClosed]`)** | Bridge 2 is a ~2–3 iter cohomology-FREE assembly, NOT the relative Stein gap (avoid). First step: `[IsAlgClosed kbar]` onto the 3 chain lemmas. `analogies/rigidity-affineconst.md`. |
| blueprint-writer | eqon-bridges | COMPLETE | Encoded both routes + `[IsAlgClosed]` note into `AbelianVarietyRigidity.tex`; Mumford/Milne verbatim quotes untouched; no markers; no `.lean` edits. |
| blueprint-reviewer | eqon-bridges-recheck | **PASS — HARD GATE CLEARS** | `AbelianVarietyRigidity.tex` complete+correct, 0 must-fix. Informational: thread "add `[IsAlgClosed]` to the 3 chain lemmas" into the prover directive (done). All other chapters complete+correct. |

## Decision made

**Honor the binding fallback (consult both bridges), then — both having resolved to concrete
char-free routes — re-fire the prover this iter on `rigidity_eqOn_dense_open` (sig change + `hfib`
+ docstrings + deep work on bridge 2). Do NOT pivot the route.**

- **Why.** The consults converted both residual sorries from "must be BUILT, route unknown" into
  concrete LSP-verified Mathlib assemblies (`hfib` mechanical; bridge 2 a named cohomology-free
  decomposition). This is exactly the committal outcome the progress-critic required, and it
  re-establishes a prover lane (avoiding the zero-prover churn pattern). The route (c) commitment
  (char-free AV rigidity) is unchanged and sound.
- **LOC/risk trade-off.** `hfib` + sig change + docstrings are mechanical (≈low LOC). Bridge 2 is
  the genuine deep residual (~1–2 iter) but now de-risked: cohomology-free, with named entry points.
  Crucially the consult ruled OUT the expensive trap (relative Stein / `f_*O=O` cohomology gap),
  saving a likely multi-iter dead end.
- **Cheapest reversal signal.** If the prover finds bridge 2's route-B globalization actually needs
  proper-pushforward cohomology after all (i.e. the dense-closed-points hom-ext cannot be built from
  the located pieces), that contradicts the analogist's cohomology-free claim → escalate to a
  cross-domain-inspiration consult or reconsider the slice-constancy formulation before more prover.

## Subagent skips

- strategy-critic: STRATEGY.md unchanged this iter (no edit); the committed route (c) is unchanged
  and the iter-157 CHALLENGE (route-c char-freeness) remains addressed (no live challenge). This
  iter is tactical execution WITHIN the committed route (resolving two located bridges), not a
  strategic change — per the descriptor's stated skip conditions. The bridge-2 de-risk (cohomology-
  free, not Stein) tightens the heart sub-estimate but does NOT change the full-arm estimate (still
  cube-dominated), so no STRATEGY phase-table edit and no >30% estimation change.

## Notes for next iter (iter-160)

- Collect the prover lane. Likely outcome: `hfib` + sig + docstrings closed; bridge 2 PARTIAL (deep).
  Continue bridge 2 via route B; a prover MUST run on this route iter-160 (the committal-state +
  no-3rd-consecutive-non-closing-iter constraint).
- Begin scoping the **theorem of the cube** (Mumford §6) — the dominant unstarted route-(c) cost,
  shared with Route A's Albanese UP. Pick the smallest entry to blueprint to prover-ready detail.
