# Iter-171 — Objectives (sidecar narrative for the prover dispatch)

## Lane A — `AlgebraicJacobian/Genus0BaseObjects.lean` (RE-ATTEMPT of iter-170 Lane A)

### Background (read this FIRST)

**iter-170 Lane A died to an external API-500 with 0 file edits after 251s / 22 turns.** The body-first test the iter-170 plan committed to (per progress-critic `routec170` CHURNING corrective + strategy-critic `routefork170` option-(c) commitment) was never actually executed; the prover got as far as setting up its TODO board, ran two `lean_run_code` probes verifying the `Algebra.compHom` recipe, then died at the next text-generation turn. **The reversal trigger DOES NOT FIRE for iter-171** because the test never ran. iter-171 re-attempts.

iter-171 progress-critic `route171` confirms: hold iter-171 as the DECISIVE test of option (c). If iter-171 returns PARTIAL-no-body (i.e. the prover RUNS the test this time and fails to produce a body skeleton with ≤3 internal sorries), iter-172 HARD-PIVOTs (route-pivot via mathlib-analogist consult on the entire `gmScalingP1` definition; NOT another armed-trigger extension).

The objectives below are RE-USED verbatim from iter-170's objectives.md (this lane's directive structure was correct; only execution failed).

### PRIMARY (must-land) — `gmScalingP1` body via `Scheme.Cover.glueMorphisms` SKELETON

**Body-first assembly. PARTIAL with internal sorries is ACCEPTABLE — the goal is to land a body shape that the helpers plug into, not to close the body axiom-clean this iter.**

Step-by-step:

1. **Add the 3-line `Algebra.compHom` instance** (the `tensoraway` unblock) immediately after `projectiveLineBarGrading_gradedRing` (~L84). Exact form per `analogies/tensoraway-instance.md`:

   ```lean
   /-- `kbar`-algebra structure on `HomogeneousLocalization.Away 𝒜 f` via the
   composition `kbar →+* ↥(𝒜 0) →+* Away 𝒜 f`. -/
   noncomputable instance algebraKbarAway
       (f : MvPolynomial (Fin 2) kbar) :
       Algebra kbar
         (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f) :=
     Algebra.compHom _ (algebraMap kbar ((projectiveLineBarGrading kbar) 0))
   ```

   This MUST land axiom-clean (no sorry). The standalone snippet verification via `lean_run_code` failed in iter-170 with `noncomputable` propagation artifacts (snippet's `abbrev projectiveLineBarGrading'` was missing the `noncomputable` annotation that the in-file declaration carries via its enclosing `noncomputable section`). **In-file landing IS fine**; do NOT pre-verify via `lean_run_code` standalone snippet — go straight to `Edit` the file + `lake build` + `lean_diagnostic_messages`.

2. **Define `gmScalingP1_chart{0,1}_ringMap`** as named declarations per `analogies/gmscaling-deep.md` Q3. The chart-1 ring map sends `X 1 ↦ (unit lift) ⊗ 1` and `X 0 ↦ (X 0 / X 1) ⊗ λ`; chart-0 is symmetric with `λ⁻¹` via `IsLocalization.Away.invSelf`. Use `MvPolynomial.eval₂RingHom` per the recipe at `analogies/gmscaling-deep.md` ~L320-330. ~10-20 LOC each, both axiom-clean.

3. **Assemble `gmScalingP1` body via `Scheme.Cover.glueMorphisms`** over `projGmCover := projectiveLineBarAffineCover.openCover.pullback₁ pullback.fst`. The structure of the body should be:

   ```lean
   noncomputable def gmScalingP1 (kbar : Type u) [Field kbar] :
       ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar :=
     Over.homMk
       (Scheme.Cover.glueMorphisms projGmCover
         -- For each chart i ∈ Fin 2, the chart-i morphism into ProjectiveLineBar.left
         (fun i => gmScalingP1_chart_i kbar i)
         -- Cross-chart agreement (cocycle) on D₊(X 0 · X 1)
         gmScalingP1_cocycle_agreement)
       (by sorry)  -- INTERNAL SORRY: Over-side coherence (if needed)
   ```

   Where `gmScalingP1_chart_i kbar i` is the chart-i scheme morphism (~15 LOC each), built from the chart-i ring map of Step 2 + `pullbackSpecIso` + `Proj.awayι` per `analogies/gmscaling-deep.md` Q3 L330-350. The `pullbackSpecIso` is at `Mathlib/.../Pullbacks.lean:702`.

   **Internal sorries accepted for PARTIAL**: at most 3 named top-level sorries (cocycle agreement, irrelevant-ideal condition if needed, Over-side coherence). Each internal sorry MUST be a top-level named declaration (per the no-buried-sorry rule), NOT an inline `by sorry` inside the body.

4. **Refactor**: if landing the body requires breaking out intermediate `gmScalingP1_chart_i` (the scheme morphism, not the ring map) as their own named decls, do so. Prefer that to inline `let`s.

### SECONDARY (mechanical, encouraged this lane) — `homogeneousLocalizationAwayIso_aux_left`

If iter-171 has prover budget after PRIMARY, attack `aux_left` (L368, `:= sorry`) via the "cancel surjective" route per `analogies/gmscaling-deep.md` Q2 L280-290:

- Show the inverse map `MvPolynomial Unit kbar → Away 𝒜 (X i)` is surjective (its image equals `Algebra.adjoin` of the localised generator, which is `⊤` by `Away.adjoin_mk_prod_pow_eq_top` from `Mathlib/RingTheory/GradedAlgebra/HomogeneousLocalization.lean:1064`, specialised to `d = 1`, `v = (X 0, X 1)`, `dv = (1, 1)`).
- Combine surjectivity with the proven `homogeneousLocalizationAwayIso_aux_right` (forward round-trip) to "cancel": `inverse ∘ forward = id`.

Estimated ~30-60 LOC. If lands: iso `homogeneousLocalizationAwayIso` lifts to fully axiom-clean; unblocks `projGm_isReduced` (L819) for iter-173.

### NOT ATTEMPTED this iter

- `gm_grpObj` body (L593) — 3rd-iter deferral; `GrpObj.ofRepresentableBy` route per `analogies/gm-grpobj-and-friends.md`. Body construction does NOT require it.
- `projGm_isReduced` (L819) — gated on `aux_left`. Only attempt as tertiary if SECONDARY lands.
- The 3 genuine Mathlib gaps L175/L182/L789 — per lean-auditor `iter169` confirmed real Mathlib gaps. Do not attempt.
- AVR L934 `iotaGm_isDominant` — gated on body landing; becomes `infer_instance` once body is real. Schedule iter-172/173.
- AVR L1141 `genusZero_curve_iso_P1` (RR bridge) — in-tree sub-build COMMITTED iter-171 via `blueprint-writer rr-bridge-subbuild` lane; first prover lane iter-172.

### Refactor coordination note

A `refactor avr-split` is dispatched this iter to split `AbelianVarietyRigidity.lean` (1198 LOC) into `RigidityLemma.lean` + reduced `AbelianVarietyRigidity.lean`. **This refactor does NOT touch `Genus0BaseObjects.lean`** (G0BO is the active prover-lane target; refactoring it concurrently is unsafe and explicitly deferred to iter-172). The G0BO prover should not encounter any direct conflict from the AVR refactor; the only G0BO-side impact is that `import AlgebraicJacobian.AbelianVarietyRigidity` chains may briefly fail to resolve mid-refactor — but since G0BO is UPSTREAM of AVR in the import graph (G0BO → AVR), G0BO does NOT import AVR. Safe.

### Stale docstrings to refresh

If the body skeleton lands, REWRITE the iter-169 docstrings on `gmScalingP1` (L626-684) + `gmScalingP1_collapse_at_zero` (L697-708) to be stable mathematical descriptions + 1-line TODO. Drop the "Iter-170 escalation surface" and "Iter-169 PARTIAL/escalation" sections — those belong in `.archon/iter/iter-NNN/`, not in source.

### Constraints

- **NO new axioms.** Every closed declaration `lean_verify`s to `{propext, Classical.choice, Quot.sound}`. The `Algebra.compHom` instance MUST be axiom-clean.
- **NO protected signature changes.** None of the touched declarations is protected (verified against `archon-protected.yaml`).
- **Every `sorry` (if any) must be the body of a top-level named declaration** — NEVER buried in `letI`/`have :=`/anonymous `fun`. Internal sorries inside `gmScalingP1` body should be hoisted to named top-level lemmas.
- **Build green**: `lake build AlgebraicJacobian.Genus0BaseObjects` exit 0; downstream `AlgebraicJacobian.AbelianVarietyRigidity` also stays green.
- **The iso (`homogeneousLocalizationAwayIso`) MUST NOT be load-bearing for `gmScalingP1` body shape THIS iter.** Body uses `pullbackSpecIso` + `Proj.awayι` + chart-side ring maps directly.

### Status target

- **COMPLETE** (best case): PRIMARY body skeleton lands with ≤1 internal sorry + `Algebra.compHom` axiom-clean + Step A ring maps axiom-clean + SECONDARY `aux_left` closes. G0BO 8 → 4 (-4).
- **PARTIAL (acceptable per progress-critic)**: PRIMARY body skeleton lands with ≤3 internal sorries + `Algebra.compHom` axiom-clean + Step A ring maps axiom-clean. G0BO 8 → 5 or 6 (-2 to -3 net).
- **PARTIAL (HARD-PIVOT triggers iter-172)**: PRIMARY body skeleton fails to even compile-as-shape (i.e. cannot write the `Scheme.Cover.glueMorphisms` invocation OR the `Algebra.compHom` instance hits unexpected synthesis failure). The route-pivot fires at iter-172 — no further extension of the option-(c) commitment.
- **INCOMPLETE**: no body landing AND no `Algebra.compHom` bridge AND no SECONDARY.

### Verification before reporting

- `lake build AlgebraicJacobian.Genus0BaseObjects` exit 0 (sorry warnings only).
- `lake build AlgebraicJacobian.AbelianVarietyRigidity` exit 0 (downstream green; may use the new `RigidityLemma.lean` if refactor landed in plan phase).
- `grep -n 'sorry' AlgebraicJacobian/Genus0BaseObjects.lean` — every hit at a top-level named declaration line.
- The `Algebra.compHom` instance is a top-level `noncomputable instance`.
- No new `axiom` keyword.

Detailed prover prompt + Mathlib citations are in `analogies/gmscaling-deep.md` (the 6-step plan) + `analogies/tensoraway-instance.md` (the `Algebra.compHom` recipe). Read both before starting.

### Self-pacing note

iter-170's prover lost 2 of 22 turns to a `lean_run_code` standalone snippet's `noncomputable` propagation artifact (the snippet didn't carry the `noncomputable section` blanket that the in-file declaration sits inside). **Skip standalone snippet pre-verification** for this iter's `Algebra.compHom` instance — go straight to `Edit` → `lake build` → `lean_diagnostic_messages`. This is faster AND matches the prover's actual operating environment.
