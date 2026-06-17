# Progress-critic directive — iter-239 (slug ts239)

Assess convergence per active route. The Picard group-law arc (d.2 → associator → `picCommGroup`)
TERMINATED iter-238 (axiom-clean deliverable) — that route is closed; do NOT assess it. Two routes are
live this iter:

## Route A — `Cohomology/FlatBaseChange.lean` (engine; RE-ENGAGING after a STUCK verdict)

Target sub-goal: `pushforward_spec_tilde_iso` ⇒ close `affineBaseChange_pushforward_iso`.

Last K=4 signals (iters 235→238):
- iter-235: no prover (STUCK corrective): mathlib-analogist consult + soundness fix (`[F.IsQuasicoherent]` added to two false-as-typed signatures) + proof-route reframe. sorry 2→2.
- iter-236: 3 axiom-clean Γ-fragment decls (`gammaPushforwardIso`, `gammaPushforwardTildeIso`,
  `globalSectionsIso_hom_comp_specMap_appTop`). Brick NOT assembled. sorry 2→2. status PARTIAL.
- iter-237: 3 axiom-clean route-iii decls (`powers_restrictScalars`,
  `fromTildeΓ_app_isIso_of_isLocalizedModule`, `pushforward_spec_tilde_iso_of_isLocalizedModule`).
  HARD sorry-closure commitment (`affineBaseChange_pushforward_iso`) MISSED. sorry 2→2. status PARTIAL.
- iter-238: STUCK (your prior verdict ts238); prover DEFERRED; corrective EXECUTED = blueprint expansion
  (writer `fbcdax` spelled out the element-free `D(a)`-level transport recipe: `e_{D(a)}` linear equiv +
  `D(a)` ring equation + `IsLocalizedModule.of_linearEquiv`/`powers_restrictScalars` transport ⇒ `hloc`).
  No prover ran. sorry 2→2.
- Recurring blocker phrase: structure-sheaf "smul carrier wall", now at its 3rd section location (`D(a)`);
  the single named residual obligation is `hloc` (quasi-coherence of the affine pushforward).

STRATEGY `Iters left` for the engine phase: ~30–60; the phase was seeded ~iter-233; this specific brick
target (`pushforward_spec_tilde_iso`) has been the focus since ~iter-234.

This iter's proposal: re-engage the prover on the now-FULLY-SPECIFIED `D(a)`-transport target (the
iter-238 blueprint expansion is the sanctioned STUCK corrective — this is NOT a verbatim re-dispatch; the
target acquired a concrete element-free recipe it lacked before). Question for you: is this re-engagement
a justified post-corrective dispatch, or does the 4-iter sorry-flat trajectory mean the lane needs a
deeper pivot (e.g. a different decomposition of `affineBaseChange_pushforward_iso`, or parking it)?

## Route B — `Picard/TensorObjSubstrate.lean`: NEW substrate lane `IsInvertible.pullback` (FRESH)

The group-law arc closed iter-238. The next critical-path step (A.1.c, re-base the relative-Picard
consumer onto the `IsInvertible` carrier) requires a NEW substrate lemma `IsInvertible.pullback`
(pullback preserves tensor-invertibility), whose backbone is Mathlib `(extendScalars f).Monoidal`
(strong-monoidal extension of scalars, confirmed present) + `SheafOfModules.sheafificationCompPullback`.
This lane has 0 prior prover attempts (fresh). Dispatched [mathlib-build].

Question for you: this is a fresh route (UNCLEAR expected). Flag only if you see a churn risk in the
framing itself (e.g. the substrate looks like it will spawn a helper cascade rather than converge).

## Output
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) + for any CHURNING/STUCK the corrective TYPE.
For Route A specifically: is the post-corrective re-engagement sound, or is a deeper pivot owed?
