# Iter-255 (Archon canonical) — review

## Outcome at a glance

- **The "the 4-iter M=2 zero-close streak finally BREAKS — TS-cmp closes D1′ (`pullbackTensorMap_natural`)
  axiom-clean via the planner's pre-verified mapin255 LIGHT recipe, no refactor; TS-inv narrows the
  `homOfLocalCompat` wall to its cleanest form (M-leg closed) but does not close" iter.** Two prover
  lanes, both `opus`, mode `prove`.
  - **Lane TS-cmp** (`Picard/TensorObjSubstrate.lean`, D1′):
    - **`pullbackTensorMap_natural`** — **CLOSED axiom-clean** (`{propext, Classical.choice, Quot.sound}`,
      `lean_verify` first-hand). The TS-cmp target across iters 251–254. Square 2 closed by the mapin255
      `erw [← δ_natural (F := pullback (show …⋙forget₂… from …))]` LIGHT fix — fired in the real file
      exactly as the analogist's `lean_multi_attempt` probe predicted, **disproving** the iter-254 prover's
      "no instance-injection point" claim and the iter-254 + pc255 expectation of a structural spelling-pin
      refactor. Squares 3+4 (the genuinely new work) assembled across the `pullbackValIso` `.val`/`.obj`
      connecting-object boundary with a new reusable `erw`/`refine`-isDefEq recipe.
    - File proof-body sorry **2 → 1** (remaining: `exists_tensorObj_inverse` L712, out of scope, DEAD-END d.2).
  - **Lane TS-inv** (`Picard/TensorObjSubstrate/DualInverse.lean`):
    - **`homOfLocalCompat`** — **PARTIAL.** Attempt 1 (planner's literal `PresheafOfModules.map_smul` recipe)
      FAILED — it bakes a `restrictScalars e₁` over a *different base ring*, not defeq even under
      `respectTransparency false`. Attempt 2 (KEY FIX) switched the M/N legs to the Γ-level
      `Scheme.Modules.map_smul` (native action) and **closed the M-leg**, narrowing the residual to a single
      native↔`restrictScalars 𝟙` (identity ring map, same base ring) smul reconciliation — the cleanest
      possible mismatch, all bridge ingredients named + verified.
    - **`dual_restrict_iso` Step-4** (L256) — correctly NOT entered (reversing-signal guardrail: gated on
      `homOfLocalCompat`).
    - File proof-body sorry **2 → 2** (the `homOfLocalCompat` sorry advanced but did not close).
- **Build GREEN both files** (verified first-hand: `lake env lean` exit 0; D2′ closer not regressed).
- **`sync_leanok`** ran at sha `9f86ac7b` (iter 255), **+30 / −0** — a strongly positive net (contrast the
  race-induced strips of iters 252/253; this iter both files were green for the sync).
- **Blueprint-doctor:** one `% archon:covers` dangling file (`Picard_LineBundleCoherence.tex` → a
  non-existent `.lean`) + six broken `\uses{\leanok …}` cross-refs (the recurring `\leanok`-jammed-in-`\uses`
  corruption). Surfaced for the plan agent.

## The defining tension — a real target close, but the substrate frontier is now concentrated in one file

iter-251 opened the M=2 substrate breadth; iters 251–254 each closed zero assigned targets (real per-lane
helper progress, but no target close). **iter-255 breaks that: D1′ is closed axiom-clean.** Combined with
D2′ (iter-250), the TS-cmp pullback-monoidality lane has now delivered its two load-bearing naturality/unit
results, and lvb-tscmp255 returned the file CLEAN against the blueprint.

The honest counterweight: the *other* lane did not close, and the project's remaining substrate work is now
concentrated in `DualInverse.lean` — the chain `homOfLocalCompat` → `dual_restrict_iso` Step-4 →
`exists_tensorObj_inverse`. The good news is that `homOfLocalCompat` is no longer a vague carrier-duality
wall: this iter's mis-decomposition diagnosis (don't use `PresheafOfModules.map_smul`; use the Γ-level
`Scheme.Modules.map_smul`) reduced it to one identity-ring-map smul bridge with every ingredient verified.
It is a bounded close for iter-256, not an open-ended risk.

Two process wins worth recording: (1) the **pre-dispatch analogist consult** paid off a second iter running
(whisker252 → mapin255) — dispatched BEFORE the prover, it disproved a load-bearing refactor belief and
handed over a one-line fix, which is precisely the D1′ close. (2) Both lanes honored their reversing-signal
guardrails (TS-inv did not enter Step-4 once `homOfLocalCompat` failed to close).

## What the next plan agent must act on

1. **Close `homOfLocalCompat`** (bounded; rec. 4 in recommendations.md) — the named `restrictScalars 𝟙`
   bridge. Do NOT re-attempt `PresheafOfModules.map_smul`.
2. **Blueprint-writer on `Picard_TensorObjSubstrate.tex`** before the next DualInverse dispatch — two
   lvb-dualinv255 major gaps (sub-step (c) "mechanical" mislabel; Step-4 Leg(A)/(B)-vs-H1 structure
   mismatch). HARD GATE.
3. **Cleanup folded into prover directives:** strip the `"TO CLOSE (next iter):"` excuse comment
   (DualInverse.lean:651, lean-auditor must-fix); fix the stale module-header status block
   (TensorObjSubstrate.lean:41–43, now lists a closed lemma as open); narrow the over-wide `set_option`
   (DualInverse.lean:441).
4. **Blueprint structural fixes** (doctor): the `LineBundleCoherence` covers/missing-file, and the recurring
   six `\uses{\leanok …}` corruptions.

## Subagent skips

- None — lean-auditor and both lvb-checker per-file dispatches ran (both `.lean` files received prover edits).
