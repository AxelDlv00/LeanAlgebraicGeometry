# Progress-critic directive — iter-216

Assess convergence of the SOLE active prover route. Fresh-context: do NOT read STRATEGY.md, PROGRESS.md, or blueprint. Render CONVERGING / CHURNING / STUCK / UNCLEAR with a corrective.

## Route: Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (⊗-group law on line bundles)

This route builds the commutative group law on iso-classes of invertible (locally-trivial) sheaves, the substrate for the Picard functor. It has been the sole productive Route A lane since iter ~209.

### Last 5 iters' signals (global sorry count is project-wide; file-local sorry count in parens)

| iter | global sorry | file sorry | helpers added (axiom-clean) | status | blocker phrase |
|---|---|---|---|---|---|
| 211 | 81 | 4 | 3-4 (`IsInvertible`, left/right unitor, braiding) | PARTIAL | associator flat-whiskering gap |
| 212 | 81 | 4 | 2 (`isIso_sheafification_map_of_W`, `W_whiskerRight_of_flat`) | PARTIAL | sectionwise flatness FALSE for invertibles |
| 213 | 81 | 4 | 3 (`W_whiskerLeft/Right_of_W`, `tensorObj_assoc_iso` ASSEMBLED) | PARTIAL | residual `isLocallyInjective_whiskerLeft_of_W` needs d.1+d.2 |
| 214 | 81 | 4 | 4 (`stalkLinearMap`/`_germ`/`_bijective_of_isIso`/`stalkLinearEquivOfIsIso`) | PARTIAL | d.1-bridge + d.2 stalk-⊗ over varying ring (Mathlib-absent) |
| 215 | 81 | 4 | 1 (`restrictScalarsRingIsoTensorEquiv` = H2 "bottom gap") | PARTIAL | H1 presheaf `pushforwardPushforwardAdj`; **FINAL one-iter gate NOT met** |

- Net global sorry: flat at 81 for 6 consecutive iters. File-local: flat at 4.
- iter-214 progress-critic set a one-iter gate (close `isLocallyInjective_whiskerLeft_of_W` or escalate iter-216). iter-215 did not close it. iter-215 progress-critic re-issued: FINAL gate, close this iter or escalate iter-216, no further infra round. **That gate is now unmet a 2nd time.**
- The recurring pattern: each iter lands a true axiom-clean helper while the load-bearing sorry stays open; the named blocker is excavated one level deeper each pass.

### KEY NEW SIGNAL this iter (consider in your verdict)
The residual has provably SHRUNK and is now ONE named, bounded, buildable Mathlib ingredient: **H1 = presheaf-level `pushforwardPushforwardAdj`** (~100–150 LOC; the SHEAF version exists in Mathlib at `Sheaf/PushforwardContinuous.lean:226`, this is the presheaf port). Closing H1 closes the linchpin `tensorObj_restrict_iso`, which (per the planner's restructuring) lets the associator be re-proved directly for locally-trivial inputs (template: the already-green `tensorObj_isLocallyTrivial`), making the open whiskering sorry dead code. The H2 bottom gap closed in-file iter-215.

### Strategy estimate vs elapsed
STRATEGY.md `A.1.c.SubT` row: Iters-left = ~2–4. Phase entered ~iter 209. Elapsed in-phase ≈ 6–7 iters. So elapsed already exceeds the upper estimate.

### Planner's proposed objective this iter
Single file (`TensorObjSubstrate.lean`), `[prover-mode: mathlib-build]` targeting H1 (`pushforwardPushforwardAdj` at presheaf level) + the ~20 LOC H2 packaging to close `tensorObj_restrict_iso`. NOT another speculative helper — the explicit named ingredient the whole chain funnels through.

### Question for you
Is dispatching a bounded mathlib-build on the single named ingredient H1 a legitimate convergence step, or is it the same "+1 helper, residual unchanged" churn pattern under a new label? Name the corrective TYPE if CHURNING/STUCK (blueprint expansion / Mathlib-idiom consult / structural refactor / route pivot / escalate-and-hold).
