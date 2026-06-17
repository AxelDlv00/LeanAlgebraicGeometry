# Iter-191 objectives

Per-lane detailed work plan for iter-191 prover phase.

## DROPPED — Lane F `Picard/QuotScheme.lean` (DEFERRED iter-192)

Per progress-critic route191 verdict CHURNING (5 consecutive iters
flat at 13 sorries; PARTIAL×2 in last 2 iters), Lane F is DROPPED
from iter-191 prover objectives. The progress-critic primary corrective
"Mathlib analogy consult before or alongside prover" is ACTIONED by
the iter-191 plan-phase dispatch of `mathlib-analogist
lane-f-restrictscalars-smul` (api-alignment mode). iter-192 prover
dispatch is gated on the analogist verdict; the directive will name
the canonical chaining sequence (or a high-level Mathlib lemma if
one exists).

---

## Lane G — `Albanese/AuslanderBuchsbaum.lean`

**Status**: SUCCESS iter-190 (substrate dramatically narrowed; 2
axiom-clean helpers + base + `x ∉ 𝔭` axiom-clean). Residual is the
`x ∈ 𝔭` ↔ `(x) ∈ minimalPrimes R` contradiction step.

**Decision** (per iter-190 review recommendations §6): bounded
~150 LOC iter-191 attempt. Attempt the Cohen-via-completion bypass
first (R Noetherian local ⟹ R̂ ≅ κ[[X_1,...,X_d]] which is a domain
⟹ R injects into a domain). If Cohen structure theorem is missing
from Mathlib b80f227, initiate the graded ring scaffold
`gr_𝔪(R) ≅ κ[X_1,...,X_d]` (~150 LOC first step of ~500-800 LOC full
build).

**iter-191 prover target**: land ≥1 axiom-clean intermediate helper
on the residual case. Acceptable outcomes:
- Cohen-completion bridge: `IsAdicComplete` + `IsLocalRing R̂` ⟹
  `R̂ ≅ κ[[X_1,...,X_d]]` ⟹ `IsDomain R̂` ⟹ `IsDomain R` (via
  faithful injection).
- Graded ring scaffold: first piece of `gr_𝔪(R)` as a graded ring (e.g.
  `GradedRing` instance), without yet attempting the
  polynomial-isomorphism.

**HARD BAR**: ≥1 axiom-clean helper landed. Helper budget = 2.

**Blueprint**: `chapters/Albanese_AuslanderBuchsbaum.tex` (PASS).

---

## Lane B-consumers — `Genus0BaseObjects/GmScaling.lean`

**Status**: HALTED iter-190 pending Substrate 2 close in
Cross01Substrate.lean (now done axiom-clean). iter-191 opens
consumer prover dispatch.

**Decision** (per iter-190 review recommendations §8): both
substrates (S1: `IsClosedImmersion.lift_iff_range_subset` iter-189,
S2: `gmRing_tensor_homogeneousAway_isDomain` iter-190) are axiom-clean
and exported from `Cross01Substrate.lean`. iter-191 prover consumes
them in `GmScaling.lean`.

**iter-191 prover target**: close 3 consumer sorries per
`analogies/lane-b-substrate.md` §3:
1. `gmScalingP1_chart_agreement_cross01` cocycle (uses S1).
2. `gm_geomIrred` (uses S2 — tensor of domains over alg-closed = domain).
3. `projGm_isReduced` (uses S2 + standard `IsReduced` propagation).

**HARD BAR**: ≥2 of 3 consumer sorries close axiom-clean. Helper
budget = 1.

**Blueprint**: `chapters/Genus0BaseObjects_Cross01Substrate.tex`
(substrates) + `chapters/AbelianVarietyRigidity.tex` III.c
substrate-hooks (consumers).

---

## Lane E — `AbelianVarietyRigidity.lean` (SCOPED to sub-step per STUCK corrective)

**Status**: STUCK per progress-critic route191 verdict (sorry count
unchanged across K=5 iters; helpers added iter-190 without count
reduction; `chart1_composition_isOpenImmersion` over-budget twice
in iter-188 and iter-190).

**Progress-critic corrective**: blueprint expansion OR sub-step
scope. iter-191 plan chooses the **sub-step scope** option — the
work is split into 2 hard-bounded parts with a budget cap each.

**Decision** (per iter-190 review recommendations §7 + progress-critic
route191): approach (b) — refactor specialise-on-`iotaGm_r_1` then
close. SCOPED to 2 parts:

**Part 1** (~30 LOC): refactor
`iotaGm_chart1_composition_isOpenImmersion` +
`iotaGm_chart1_section` signatures to specialise on `iotaGm_r_1` /
`iotaGm_r_1_fac` directly (drop abstract `r_1, h_r_1` parameters).

**Part 2** (~80 LOC, HARD BUDGET): close body via
`IsOpenImmersion.lift_app` + `Proj.basicOpenIsoAway` +
`IsLocalization.map` on chart-1 coord. **If 80 LOC budget is hit
without closure, STOP — do NOT exceed**. Defer Part 2 closure to
iter-192 after blueprint expansion.

**HARD BAR**: at MINIMUM Part 1 (the refactor specialization) lands
axiom-clean. If Part 2 closes within budget, file sorry count drops
2 → 1 (net −1). If Part 2 hits the budget wall, Part 1 lands but
sorry count unchanged at 2.

**Failure mode** (Part 2 budget wall): iter-192 plan-phase dispatches
`blueprint-writer avr-chart1-composition-expand` to expand the
chapter's sketch on `iotaGm_chart1_composition_isOpenImmersion` BEFORE
re-attempting the body close.

**Helper budget**: 1.

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (CLEARED).

---

## Lane H — `RiemannRoch/H1Vanishing.lean` (NEW FILE — file-skeleton dispatch)

**Status**: file does not yet exist. iter-190 blueprint-doctor
flagged `% archon:covers AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
in `RiemannRoch_H1Vanishing.tex` (chapter landed iter-190 plan-phase
ahead of the Lean file).

**Decision**: file-skeleton dispatch type. Per the plan-agent prompt
"File-skeleton dispatches" section: scaffold 8 declarations from the
chapter with `sorry` bodies; do NOT attempt to prove any of them
this iter.

**iter-191 prover target**: create
`AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` with:
- Imports: `Mathlib` + `AlgebraicJacobian.Cohomology.StructureSheafModuleK`
  + `AlgebraicJacobian.RiemannRoch.WeilDivisor` (for
  `PrimeDivisor.closure_isIrreducible`).
- Namespace: `AlgebraicGeometry.Scheme`.
- 8 public declarations matching the chapter's `\lean{...}` pins:
  1. `def IsFlasque` — flasque sheaf predicate.
  2. `theorem IsFlasque.pushforward` — pushforward of flasque is flasque.
  3. `theorem IsFlasque.constant_of_irreducible` — constant sheaf on
     irreducible space is flasque.
  4. `theorem HModule_flasque_eq_zero` — flasque sheaves have vanishing
     higher cohomology.
  5. `theorem skyscraperSheaf_eq_pushforward_const` — skyscraper sheaf
     iso pushforward of constant sheaf.
  6. `theorem PrimeDivisor.closure_isIrreducible` — closure of a closed
     point is irreducible.
  7. `theorem skyscraperSheaf_isFlasque` — closed-point skyscraper is
     flasque.
  8. `theorem H1_skyscraperSheaf_finrank_eq_zero` — H¹ of closed-point
     skyscraper has dimension zero.

All bodies as `sorry`. Add namespace `end`s and umbrella import
in `AlgebraicJacobian.lean`.

**HARD BAR**: file compiles; 8 declarations present with intended
type signatures; `lake build AlgebraicJacobian` GREEN.

**Failure mode**: if a signature elaboration fails (e.g.
`Scheme.HModule kbar` accessibility from the new file's imports),
report STRUCTURAL_BLOCKED and document the missing import/instance.

**Blueprint**: `chapters/RiemannRoch_H1Vanishing.tex` (560 lines;
PASS per iter-190 blueprint-writer landing).

---

## Lane M↓ — `Albanese/CodimOneExtension.lean` (first scaffold)

**Status**: RE-OPENED iter-190 as project-side Option (a) build per
strategy-critic REJECT on Option (c). 3 sorries existing; the target
is `isRegularLocalRing_stalk_of_smooth` (Stacks 00TT).

**Decision**: iter-191 first prover dispatch. ~50-100 LOC initial
scaffold of Stage 1 of the Stacks 00TT proof chain: smooth → flat at
stalk → polynomial presentation. Full ~150-300 LOC over ~8-15 iters.

**iter-191 prover target**: Stage 1-2 skeleton. The proof chain:
1. Smooth morphism ⟹ flat (`Mathlib.AlgebraicGeometry.Smooth.flat`
   or similar; verify presence).
2. Flat at stalk of smooth ⟹ standard smooth presentation (`Stacks 00T7`
   in `stacks-algebra.md`).
3. Standard smooth presentation ⟹ polynomial-generators free module
   (`Ω_{S/R}` free on `dx_{c+1},...,dx_n`).
4. Regular sequence ⟹ regular local ring.

**HARD BAR**: Stage 1-2 axiom-clean (smooth → flat + standard
presentation skeleton). Helper budget = 2.

**Failure mode**: if a Mathlib substrate is missing (e.g.
`SmoothOfRelativeDimension n` does NOT export the "flat at stalk"
instance), scope iter-191 dispatch to ONLY Stage 1 + named typed
sorry on Stage 2-4.

**Blueprint**: `chapters/Albanese_CodimOneExtension.tex`.

---

## Off-limits / deferred iter-191

- **`AlgebraicJacobian/Picard/IdentityComponent.lean`** (Lane A.3.i):
  HALT prover iter-191 pending analogist verdict (`lane-a3i-isconnected-prod`
  dispatched this plan-phase). iter-192+ prover dispatch GATED on
  analogist verdict + verdict-acted-upon.
- **`AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`** (Lane I
  Pin 3 Step 2): handled in plan-phase via the refactor; Pin 3 Step 2
  sub-tasks (a)/(c)/(d) gated on iter-192+ analogist
  `iso-of-degree-one-pin3` consult.
- **`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`**: handled in
  plan-phase via the refactor; body of
  `degree_positivePart_principal_eq_finrank` deferred iter-192+ via
  Hartshorne II.6.9 affine-chart route.
- **`AlgebraicJacobian/RiemannRoch/RRFormula.lean`** (Lane H downstream):
  HALT iter-191 prover; iter-192+ closes `H1_skyscraperSheaf_finrank_eq_zero`
  body via the new H1Vanishing.lean file-skeleton's API.
- **`AlgebraicJacobian/RiemannRoch/OCofP.lean`** (Lane A downstream):
  3 remaining sorries gated on RR.2.H¹ scaffold + bodies; iter-192+.
- **`AlgebraicJacobian/RiemannRoch/OcOfD.lean`** (Lane J):
  STRUCTURALLY BLOCKED. DO NOT DISPATCH.

## Sorry projection iter-191 post-prover

Entering iter-191 post-plan-phase (after refactor lands):
**~78 sorries** (clash resolved; file-local pin removed; integration
GREEN).

Best case (all 6 HARD BARs met):
- Lane F: −1 (Step 3 axiom-clean)
- Lane G: 0 net (helper landed; main sorry still narrowing)
- Lane B-consumers: −2 (2 of 3 consumers close)
- Lane E: −1 (chart1_composition closes)
- Lane H: +8 typed-sorry pins (file-skeleton; expected per file-skeleton
  dispatch semantics)
- Lane M↓: +1 typed-sorry pin (Stage 1-2 scaffold) or +2 (Stage 3-4 also)
Net: 78 − 4 + 9 = **~83**.

Realistic (3-4 HARD BARs met):
78 − 2 + 9 = **~85**.

Worst case (Lane F PARTIAL again; Lane G 0 closures; Lane B-consumers
1 close; Lane E PARTIAL; full skeleton dispatches add 10+):
78 + 0 + 10 = **~88**.

The file-skeleton dispatches add typed-sorry pins by design — this is
the "scaffolding ahead of body work" pattern. The post-iter-191 sorry
count is expected to RISE; the value is in the *substrate-narrowing*
landing for future iters.

## Iter-191 deltas to STRATEGY.md (none planned plan-phase)

The strategy is unchanged this iter pending the strategy-critic
iter191 verdict. If strategy-critic returns CHALLENGE this iter,
STRATEGY.md is amended per the verdict before prover phase begins
(or an explicit rebuttal recorded in plan.md).
