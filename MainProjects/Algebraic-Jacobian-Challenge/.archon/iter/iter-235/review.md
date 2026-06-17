# Iter-235 (Archon canonical) — review

## Outcome at a glance

- **The "d.2 stage (iv) reverse map lands axiom-clean end-to-end, but the iso still won't assemble
  and the carrier-duality wall resurfaces at the balancing" iter.** ONE prover lane (the FlatBaseChange
  slot was correctly swapped for a `mathlib-analogist` consult, per the iter-235 progress-critic STUCK
  verdict — no prover ran on FlatBaseChange).
  - **`StalkTensor.lean`** (mathlib-build, d.2 — the named critical path): **10 axiom-clean `private`
    declarations**, building the **entire stage-(iv) nested double-colimit reverse descent**
    (`revInnerLeg`, `revInnerLeg_apply`, `revInner`, `germ_revInner`, `revInner_germ`, `revOuterLeg`,
    `revOuterLeg_apply`, `revBihom`, `germ_revBihom`, `revBihom_germ_tmul`). 0 sorries.
    `lean_verify = {propext, Classical.choice, Quot.sound}`.
- **Canonical sorry count: unchanged.** The reverse-map block is +10 decls / +0 sorry; the SOLE
  residual (`revBihom_balanced` + `stalkTensorRev`) is a documented in-file **comment, not a sorry**.
- **Build GREEN** (LSP clean, `grep sorry|admit|native_decide|^axiom` empty). **Blueprint-doctor CLEAN.**
  **`sync_leanok` iter 235, sha `2cda42af`, +1 / −1**, `Picard_TensorObjSubstrate.tex` (the stage-(iii)
  `stalkTensorLinearMap` pin gained `\leanok`). **No laundering** — `stalkTensorIso` carries no `\leanok`
  (the iso is not built; verified first-hand).

## The defining tension — the gate was met (in spirit), the wall moved, the counter did not

iter-234's review imposed a falsifiable gate: *dispatch stage (iv) as the WHOLE reverse map; do NOT
fragment into more sub-`stalkTensorDescU`-style helpers.* **The gate was met.** The 10 decls are the
natural structural decomposition of a double `colimit.desc` (inner leg → inner descent → outer leg →
outer descent, each with a germ characterization), not peripheral helper churn — and the lean-auditor
independently confirmed every one is a genuine non-vacuous construction with a substantive
cocone-naturality sub-proof (the `revInner` naturality alone is a ~20-line discharge via `germ_res` +
`tensorObj_map_tmul` + `Functor.map_comp` + poset thinness). This is the third consecutive iter the d.2
lane has landed a named stage axiom-clean (233 forward map, 234 `R_x`-linear packaging, 235 reverse
descent). That is convergence.

Two stings, honestly carried:

1. **The iso does not assemble; the counter is flat for the 18th iter (since iter-217).** Stage (iv) is
   ~95% done but the balancing `revBihom_balanced` (→ `stalkTensorRev`) is not landed, and the stage-(v)
   mutual-inversion bundle is fully open. `stalkTensorIso` — the thing that unblocks
   `isLocallyInjective_whiskerLeft_of_W` → unconditional associator → `thm:pic_commgroup` — is still
   ≥2 sub-steps away. The counter-moving datapoint remains owed.
2. **The "retired" carrier-duality risk is NOT fully retired.** iter-234's review banked the
   CommRingCat/RingCat duality as solved by the stage-(iii) recipe. The balancing exposed that the
   stage-(iii) recipe does **not** transfer verbatim: `PresheafOfModules.map_smul` adds a
   `restrictScalars` wrapper, so `TensorProduct.smul_tmul` cannot synthesize the `DistribMulAction`
   defeq. The prover correctly stopped at a clean committable boundary (gap as comment, not sorry) and
   left a precise two-route handoff; route 2 (stalk-level smul via `germ_smul`, scalar stays at `R_x`)
   is the recommended next attempt. This is a *finding*, not avoidance — but it means the lead lane's
   single technical risk is live, not closed.

## Process correctness

- **Prover: on-target and honest.** Built the whole reverse map as the directed unit (honoring the
  no-fragmentation gate), kept the file 0-sorry / axiom-clean, stopped at a real boundary rather than
  sorry-pinning a half-built `stalkTensorRev`, and documented the balancing blocker + two concrete
  routes precisely. Exactly the mathlib-build discipline the lane requires.
- **Planner (iter-235): sound.** Honored the FlatBaseChange STUCK verdict by replacing the prover slot
  with a read-only consult (not a cosmetic recipe re-try); the consult paid off (found + fixed a
  CRITICAL soundness defect — both FBC theorems took an arbitrary `F` where Stacks 02KH needs
  `[F.IsQuasicoherent]`; refactor applied, build green). Strategy-critic / blueprint-reviewer skips
  were correctly recorded (STRATEGY.md unchanged, prior verdicts SOUND/clear).
- **Review subagents (this phase):** lean-auditor `ts235` (0 must-fix, 0 major, 3 minor) and
  lean-vs-blueprint-checker `stalktensor` (0 must-fix, 1 major, 1 minor). The major (stale `% NOTE:`
  on `lem:stalk_tensor_commutation` — "iter-234" + a LaTeX typo) was **fixed by the review agent this
  iter**. The minor (stage-(iv) prose doesn't name the carrier-duality sub-obstacle) is a plan-side
  blueprint-writer task, flagged in recommendations.

## What the next plan iter must do

1. **Dispatch the balancing via route 2** (stalk-level smul). Tell the prover explicitly NOT to re-try
   the section-level `smul_tmul` route (all variants failed this iter). Then `stalkTensorRev` and the
   stage-(v) bundle. **Convergence gate for iter-236:** land `revBihom_balanced` + `stalkTensorRev`, or
   the d.2 *tactic* (not the carrier pivot) should be re-evaluated.
2. **Blueprint-writer:** add the carrier-duality sub-obstacle + route-2 resolution to stage (iv) prose
   of `§sec:tensorobj_stalk_tensor` before the prover round.
3. **FlatBaseChange:** do NOT re-open with a prover unless the single Mathlib-absent brick
   (`pushforward (Spec.map φ)(tilde M) ≅ tilde (restrictScalars φ.hom M)`, via `tilde.functor`
   full-faithfulness + `fromTildeΓ` counit) is in hand and the blueprint covers it. Stays behind d.2.

## Subagent skips

- (none for the review phase — both highly-recommended review subagents were dispatched.)
