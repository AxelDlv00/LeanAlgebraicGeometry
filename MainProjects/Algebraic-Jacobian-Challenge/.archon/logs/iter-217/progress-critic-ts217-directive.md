# Progress-critic directive (iter-217)

Fresh-context convergence audit of the single active prover route. Assess ONLY the
signals below; do not read STRATEGY.md / PROGRESS.md / blueprint / iter sidecars.

## Route: Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

The lane builds the substrate for a hand-built commutative group on locally-trivial
iso-classes (the relative Picard group). Phase entered iter ~209/210 (the
⊗-invertibility pivot). Strategy's current `Iters left` estimate for this phase:
**~2–5**. Elapsed in current phase: **~7–8 iters** (209/210 → 217).

### Per-iter signals (K = 6: iters 211–216)

- **Global project sorry count:** 211=81, 212=81, 213=81, 214=81, 215=81, 216=81
  (flat at 81 for 6 consecutive iters; this is the 7th iter on the route).
- **TS-file code sorry count:** 4 → 4 → 4 → 4 → 4 → 4 (unchanged every iter).
- **Net axiom-clean declarations added per iter (all genuine, verified):**
  - 211: unitors, braiding, `IsInvertible` (group-law existence facts)
  - 212: `isIso_sheafification_map_of_W` (the localization bridge)
  - 213: `tensorObj_assoc_iso` ASSEMBLED + `W_whiskerLeft/Right_of_W` (route-(d))
  - 214: 4 `stalkLinearMap*` decls (d.1 stalk-linearity core)
  - 215: `restrictScalarsRingIsoTensorEquiv` (H2 "bottom gap")
  - 216: 6 decls — `restrictScalars_isIso_μ/ε`, `restrictScalarsMonoidalOfRingEquiv`,
    `_of_bijective` forms (the ModuleCat-level H2 strong-monoidal core)
- **Prover statuses:** PARTIAL (211), PARTIAL (212), PARTIAL (213), PARTIAL (214),
  PARTIAL (215), PARTIAL (216). Zero `sorry` eliminated across the whole window.
- **Recurring blocker phrase:** "the linchpin needs a Mathlib-absent ingredient"
  — across the window the named ingredient MOVED: route-(d) whiskering →
  `(J.W).IsMonoidal` → d.1 stalk-bridge + d.2 stalk-⊗ → (iter-216) a single named
  ingredient **H1** (presheaf-level `pushforwardPushforwardAdj`).
- **iter-215 and iter-216 each carried a pre-committed gate** ("close the residual
  this iter or escalate"); BOTH were missed. iter-216 ran a planner-set make-or-break
  test ("free-cover avoids H1") which returned **NEGATIVE** (H1 confirmed on the
  critical path). A USER escalation FYI is live.

### This iter's (217) proposed prover objective

- **1 file:** `Picard/TensorObjSubstrate.lean`
- **Mode:** `mathlib-build` (NOT `prove`) — the objective is to construct the named,
  finite ingredient **H1** (presheaf-level pushforward adjunction `pushforward β ⊣
  pushforward φ`, then `pushforward β ≅ pullback φ` via `leftAdjointUniq`), mirroring
  the existing Mathlib **sheaf**-level `SheafOfModules.pushforwardPushforwardAdj`.
  This differs from iters 211–216 (which were `prove`-mode attempts on the residual /
  a make-or-break test). H1 has an exact sheaf-level template to mirror.

## What I need

Your per-route verdict (CONVERGING / UNCLEAR / CHURNING / STUCK) with reasoning, and
— critically — whether dispatching a `mathlib-build` round on the *single named,
templated* ingredient H1 is materially different from the prior 6 `prove`-mode
helper rounds, or whether it is the same churn under a new name. If STUCK/CHURNING,
name the corrective TYPE you recommend (route pivot / blueprint expansion /
Mathlib-idiom consult / structural refactor / USER escalation). Write to
`task_results/progress-critic-ts217.md`.
