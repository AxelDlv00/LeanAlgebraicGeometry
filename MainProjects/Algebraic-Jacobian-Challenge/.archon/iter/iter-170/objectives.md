# Iter-170 — Objectives (sidecar narrative for the prover dispatch)

## Lane A — `AlgebraicJacobian/Genus0BaseObjects.lean`

### Background (read this FIRST)

iter-165→169 built helpers (cover, ℙ¹ points, chart-ring iso skeleton, Lane B exports) but the body of `gmScalingP1` has been bare `:= sorry` for 5 consecutive iters. iter-169 attempted three routes (direct `Proj.fromOfGlobalSections` from whole pullback; chart-glue Option B; functoriality-of-Proj) and each terminated at a different Mathlib gap. progress-critic `routec170` returned **CHURNING** with **primary corrective = BODY-FIRST attempt this iter**: assemble the body skeleton via `Scheme.Cover.glueMorphisms` with internal sorries acceptable as PARTIAL. The body-first attack tests whether helpers actually plug in.

mathlib-analogist `tensoraway` overrode the iter-169 prover's "TensorProduct CommRing missing" diagnosis: **the missing piece is `Algebra kbar (HomogeneousLocalization.Away 𝒜 _)`** (Mathlib only ships `Algebra (𝒜 0) (HomogeneousLocalization 𝒜 x)`). A 3-line `Algebra.compHom` instance closes this. Verified end-to-end via `lean_run_code`. Once that instance is in scope, `TensorProduct kbar (Away 𝒜 _) (GmRing kbar)` synthesizes `CommRing` + `Algebra kbar` directly. See `analogies/tensoraway-instance.md`.

The strategic decision (planner-made, recorded in `iter/iter-170/plan.md`): **option (c) inline chart-glue at scale, committed across iter-170 → iter-172**. NOT option (a) Mathlib upstream PR. NOT option (b) `[CharZero]` (rejected as goal-weakening per strategy-critic `routefork170`).

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

   This MUST land axiom-clean (no sorry). Verify by `inferInstance : CommRing (TensorProduct kbar (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (X i)) (GmRing kbar))` in a test position.

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
         (by sorry))  -- INTERNAL SORRY 1: cocycle agreement (acceptable for iter-170 PARTIAL)
       (by sorry)  -- INTERNAL SORRY 2: Over-side coherence with structure maps (likely closeable inline)
   ```

   Where `gmScalingP1_chart_i kbar i` is the chart-i scheme morphism (~15 LOC each), built from the chart-i ring map of Step 2 + `pullbackSpecIso` + `Proj.awayι` per `analogies/gmscaling-deep.md` Q3 L330-350. The `pullbackSpecIso` is at `Mathlib/.../Pullbacks.lean:702`.

   **Internal sorries accepted for PARTIAL**: at most 3 named internal sorries, one for cocycle agreement, one for irrelevant-ideal condition (if Proj.fromOfGlobalSections is used), one for any `Over`-side coherence step that needs the bigger refactor. Each internal sorry MUST be a top-level named lemma (per the no-buried-sorry rule), NOT an inline `by sorry` inside the body.

4. **Refactor**: if landing the body requires breaking out intermediate `gmScalingP1_chart_i` (the scheme morphism, not the ring map) as their own named decls, do so. Prefer that to inline `let`s. Each named intermediate is testable + reviewable.

### SECONDARY (mechanical, encouraged this lane) — `homogeneousLocalizationAwayIso_aux_left`

If iter-170 has prover budget after PRIMARY, attack `aux_left` (L368, `:= sorry`) via the "cancel surjective" route per `analogies/gmscaling-deep.md` Q2 L280-290:

- Show the inverse map `MvPolynomial Unit kbar → Away 𝒜 (X i)` is surjective (its image equals `Algebra.adjoin` of the localised generator, which is `⊤` by `Away.adjoin_mk_prod_pow_eq_top` from `Mathlib/RingTheory/GradedAlgebra/HomogeneousLocalization.lean:1064`, specialised to `d = 1`, `v = (X 0, X 1)`, `dv = (1, 1)`).
- Combine surjectivity with the proven `homogeneousLocalizationAwayIso_aux_right` (forward round-trip) to "cancel": `forward (inverse x) = x` is `_aux_right`; surjectivity lets us write any `y = inverse x` for some `x`, so `forward y = forward (inverse x) = x = inverse (forward x) = inverse y`, hence `inverse ∘ forward = id`.

Estimated ~30-60 LOC. If lands, the iso `homogeneousLocalizationAwayIso` lifts to fully axiom-clean. **Closing `aux_left` ALSO unblocks `projGm_isReduced` (L819) for a future iter** (per `tensoraway` Q5: chart-ring identifies with `kbar[u]`, tensor with `kbar[t, t⁻¹]` is `kbar[u, t, t⁻¹]` localization-of-polynomial-ring, hence reduced).

### NOT ATTEMPTED this iter

- `gm_grpObj` body (L593) — 3rd-iter deferral; `GrpObj.ofRepresentableBy` route per `analogies/gm-grpobj-and-friends.md`, but option (c) body construction does NOT require it. Schedule iter-172.
- `projGm_isReduced` (L819) — gated on `homogeneousLocalizationAwayIso` lifting fully axiom-clean (i.e. on `aux_left` closing). If `aux_left` lands SECONDARY this iter, you MAY attempt `projGm_isReduced` as a tertiary; otherwise leave it.
- The 3 genuine Mathlib gaps L175 `projectiveLineBar_geomIrred`, L182 `projectiveLineBar_smoothOfRelDim`, L789 `gm_geomIrred` — per lean-auditor `iter169` confirmed as real Mathlib gaps. Do not attempt.
- AVR L931 `iotaGm_isDominant` — gated on `gmScalingP1` body landing concrete; becomes a trivial `infer_instance` once the body is real. Schedule iter-172.
- AVR L1135 `genusZero_curve_iso_P1` (RR bridge) — deferred to upstream Mathlib.

### Stale docstrings to refresh

The iter-169 docstrings on `gmScalingP1` (L626-684) + `gmScalingP1_collapse_at_zero` (L697-708) carry 60-line iter-status prose. If you land the body skeleton, REWRITE both docstrings to be stable mathematical descriptions + a single TODO line pointing at the iter sidecar. Drop the "Iter-170 escalation surface" and "Iter-169 PARTIAL/escalation" sections — those belong in `.archon/iter/iter-NNN/`, not in source.

Same for `gmScalingP1_collapse_at_zero` if iter-170 doesn't close it: a 1-line "gated downstream of `gmScalingP1` body" docstring suffices.

### Constraints

- **NO new axioms.** Every closed declaration `lean_verify`s to `{propext, Classical.choice, Quot.sound}`. The `Algebra.compHom` instance MUST be axiom-clean.
- **NO protected signature changes.** None of the touched declarations is protected (verified against `archon-protected.yaml`).
- **Every `sorry` (if any) must be the body of a top-level named declaration** — NEVER buried in `letI`/`have :=`/anonymous `fun`. Internal sorries inside `gmScalingP1` body should be hoisted to named top-level lemmas (e.g. `gmScalingP1_cocycle_agreement`, `gmScalingP1_irrelevant_ideal_condition`).
- **Build green**: `lake build AlgebraicJacobian.Genus0BaseObjects` exit 0; downstream `AlgebraicJacobian.AbelianVarietyRigidity` also stays green.
- **The iso (`homogeneousLocalizationAwayIso`) MUST NOT be load-bearing for `gmScalingP1` body shape THIS iter.** The body shape uses `pullbackSpecIso` + `Proj.awayι` + chart-side ring maps. The iso is a SECONDARY-grade lift; if it lands, the body uses `homogeneousLocalizationAwayIso.symm` for chart-i Spec.map shortcuts in iter-171's cleanup pass, not for the iter-170 skeleton.

### Status target

- **COMPLETE** (best case): PRIMARY body skeleton lands with ≤1 internal sorry + `Algebra.compHom` axiom-clean + Step A ring maps axiom-clean + SECONDARY `aux_left` closes. G0BO 8 → 4 (-4).
- **PARTIAL (the progress-critic's acceptable PARTIAL)**: PRIMARY body skeleton lands with ≤3 internal sorries + `Algebra.compHom` axiom-clean + Step A ring maps axiom-clean. G0BO 8 → 5 or 6 (-2 to -3 net). This is the explicit body-first PARTIAL the critic prescribed.
- **PARTIAL (escalation re-armed)**: PRIMARY body skeleton fails to even compile-as-shape (i.e. cannot write the `Scheme.Cover.glueMorphisms` invocation OR the `Algebra.compHom` instance hits unexpected synthesis failure). Falls back to attempting just SECONDARY (`aux_left`) and Step A ring maps. iter-171 plan opens with the option-(a) reversal trigger fired.
- **INCOMPLETE**: build broken or no body landing AND no `Algebra.compHom` bridge.

### Verification before reporting

- `lake build AlgebraicJacobian.Genus0BaseObjects` exit 0 (sorry warnings only for the named internal sorries + unclosed deferred items).
- `lake build AlgebraicJacobian.AbelianVarietyRigidity` exit 0 (downstream green).
- `grep -n 'sorry' AlgebraicJacobian/Genus0BaseObjects.lean` — every hit must be at a top-level named declaration line, no inline `by sorry` inside a body. (The body of `gmScalingP1` is itself a top-level decl, so internal sorries hoisted out of it are also top-level.)
- The `Algebra.compHom` instance is a top-level `noncomputable instance` declaration (not buried).
- No new `axiom` keyword in the file.

Detailed prover prompt + Mathlib citations are in `analogies/gmscaling-deep.md` (the 6-step plan) + `analogies/tensoraway-instance.md` (the `Algebra.compHom` recipe). Read both before starting.
