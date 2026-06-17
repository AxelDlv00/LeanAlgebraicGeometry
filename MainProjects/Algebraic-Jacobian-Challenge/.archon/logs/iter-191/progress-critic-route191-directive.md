# Progress critic route191 directive

## Mandate

Fresh-context detection of route-level convergence vs churning vs
stuck. Last K=5 iters of signals per active route. Read ONLY this
directive and the signals below. Do NOT read STRATEGY.md, PROGRESS.md,
iter sidecars, blueprint chapters, or task_results.

For each route below, return one verdict:
- **CONVERGING** — closing toward zero residual sorries.
- **CHURNING** — helpers added each iter but residual unchanged.
- **STUCK** — no sorry-elimination or structural advance in K iters.
- **UNCLEAR** — not enough signal yet (1-2 iters of data).

CHURNING and STUCK are MUST-FIX-THIS-ITER. The planner will execute
the named corrective.

## Active routes — signals

### Lane I — `RiemannRoch/RationalCurveIso.lean` + paired `WeilDivisor.lean`

Strategy phase: **RR.4 / Pin 2 corrective**.
STRATEGY.md "Iters left": **~5-9**.
Phase entered: **iter-177 (file-skeleton)**.
Elapsed: 14 iters (iter-177 → iter-190).

Per-iter signals (file sorry counts via deterministic loop):
- iter-186: 4 sorries; substrate refactor
- iter-187: 4 sorries; ditto
- iter-188: 4 sorries; structural-conflict surfaced
- iter-189: 2 sorries; Pin 3 Step 1 closed inline (axiom-clean ~10 LOC),
  Pin 2 diagnosed false-as-stated
- iter-190: integration RED (parallel-prover name clash on
  `WeilDivisor.positivePart`); per-file count unmeasurable.
  Substantive landings: positivePart def axiom-clean (public, in
  WeilDivisor.lean), file-local pin in RationalCurveIso.lean (will
  clash with public), Pin 3 Step 2 sub-task (b) closed inline
  axiom-clean.

iter-190 prover status: PARTIAL (paired-prover integration clash);
HARD BAR mostly met per-file but integration failed.

Helpers added per iter: iter-188 +1; iter-189 +0 ; iter-190 +1 (the
file-local `WeilDivisor.positivePart` def — will be removed iter-191).

Iter-191 plan: dispatch prover on RationalCurveIso to (a) REMOVE the
file-local `WeilDivisor.positivePart` def (fix the clash), (b) keep
the file-local pin as a private specialisation of the public
existential pin, (c) continue Pin 3 Step 2 sub-tasks (a)/(c)/(d) via
the gap chain in `analogies/ratcurveiso-pin3.md`.

### Lane G — `Albanese/AuslanderBuchsbaum.lean`

Strategy phase: **A.4.b Auslander–Buchsbaum / Stacks 00NQ**.
STRATEGY.md "Iters left": **~8-14**.
Phase entered: iter-180 (G1 cotangent dim drop), iter-188 (G2 narrowed).
Elapsed: 10 iters (iter-180 → iter-190).

Per-iter signals (file sorry counts):
- iter-186: 4; G1 substrate scaffold
- iter-187: 4; substrate narrowed
- iter-188: 3; G1 cotangent dim-drop axiom-clean ~150 LOC
- iter-189: 2; consolidated 00NQ+00NU sorry → pure 00NQ
  `isDomain_of_regularLocal` + 3 axiom-clean helpers
- iter-190: 2; 2 NEW axiom-clean helpers (base case +
  inductive step prep); main `isDomain_of_regularLocal` body
  refactored to strong induction; base + `x ∉ 𝔭` axiom-clean;
  residual scoped to `x ∈ 𝔭` ↔ `(x) ∈ minimalPrimes R`

iter-190 prover status: SUCCESS (substrate narrowed; HARD BAR met).

Helpers added per iter: iter-188 +3; iter-189 +0; iter-190 +2.

Residual: `x ∈ 𝔭` case of Stacks 00NQ; iter-190 prover surfaced THREE
bypass attempts all blocked (prime avoidance, dimension formula,
nilpotence) and identified two routes:
1. Direct graded ring `gr_𝔪(R)` formalization (~500-800 LOC standalone)
2. Cohen structure theorem via completion `R → R̂ ≅ κ[[X_1,...,X_d]]`

### Lane F — `Picard/QuotScheme.lean`

Strategy phase: **A.2.b Quot + Grassmannian**.
STRATEGY.md "Iters left": **~75-150**.
Phase entered: iter-184.
Elapsed: 7 iters (iter-184 → iter-190).

Per-iter signals:
- iter-186: 13; AddEquiv builds
- iter-187: 13; intermediate scaffold
- iter-188: 13; substrate work
- iter-189: 13; analogist-licensed unbundle (2 new typed-sorry pins
  `tildeIso_of_isQuasicoherent_isAffineOpen` + `pullback_of_openImmersion_iso_restrict`);
  `_sectionLinearEquiv` body not closed (HARD BAR missed)
- iter-190: 13; AddEquiv fully closed for `pullback_of_openImmersion_iso_restrict`;
  smul migration via `Hom.app_smul`; residual scoped to ring-identity +
  restrictScalars unfold (~30-60 LOC iter-191 close estimate)

iter-190 prover status: PARTIAL (HARD BAR ≥1 axiom-clean NOT MET);
substantial qualitative progress.

Helpers added per iter: iter-189 +2 (pinned); iter-190 +0.

iter-190 prover-side recommendation: "the dispatch rule 'If Step 3
fails axiom-clean, route escalates iter-191 to user-escalation for
Mathlib upstream PR on Stacks 01I8' should be RE-EVALUATED: the
failure is NOT on Step 1 (Stacks 01I8). The Step 3 residual gap is in
a different Mathlib region (Stacks 01HH-style structure-sheaf
compatibility + `ModuleCat.restrictScalars` smul unfolding). Both
ingredients ARE present in Mathlib b80f227 — no upstream PR needed,
just careful chaining."

### Lane A.3.i — `Picard/IdentityComponent.lean`

Strategy phase: **A.3.i GroupScheme.IdentityComponent**.
STRATEGY.md "Iters left": **~4-8**.
Phase entered: iter-185.
Elapsed: 6 iters (iter-185 → iter-190).

Per-iter signals:
- iter-186: 8; scaffold + 4 helpers
- iter-187: 9; +1 helper; locally-connected substrate Mathlib gap
- iter-188: 8; -1 (identityComponent_locallyConnectedSpace closed
  axiom-clean ~50 LOC; EGA I 6.1.9 chain landed via Path B)
- iter-189: 8; HARD SCOPE CAP fired (0 closures vs ≥2 target;
  CHURNING)
- iter-190: HALTED prover (no dispatch this iter; analogist consult
  deferred to iter-191 plan-phase per max_parallel=1 budget)

iter-190 status: HALTED. iter-191 plan-phase dispatches mathlib-
analogist `lane-a3i-isconnected-prod` (cross-domain-inspiration mode)
BEFORE next prover dispatch. The substrate gap is EGA IV₂ 4.5.8
analog (`Scheme.isConnected_pullback_of_isGeometricallyConnected`).

Helpers added per iter total over phase: 16 across 4 iters (the
CHURNING signal). iter-190 +0 (HALTED).

### Lane B / Lane B-consumers — `Genus0BaseObjects/Cross01Substrate.lean` → `GmScaling.lean`

Strategy phase: **Genus-0 rigidity chart-bridge III.c**.
STRATEGY.md "Iters left": **~3-5** (chart-bridge separated-locus).
Phase entered: iter-188 (Cross01Substrate file).
Elapsed: 3 iters (iter-188 → iter-190).

Per-iter signals (Cross01Substrate.lean):
- iter-188: file does not exist
- iter-189: 0 sorries (NEW file; Substrate 1 axiom-clean ~80 LOC)
- iter-190: 0 sorries (Substrate 2 `gmRing_tensor_homogeneousAway_isDomain`
  axiom-clean ~270 LOC)

iter-190 prover status: SUCCESS HARD BAR MET. Both substrates landed
axiom-clean kernel-only.

GmScaling.lean carries 4 sorries (Lane B consumers) — HALTED iter-190
pending Substrate 2 close. iter-191 plan-phase: dispatch prover on
GmScaling.lean to consume both substrates for 3 sorry closures
(`gmScalingP1_chart_agreement_cross01` cocycle, `gm_geomIrred`,
`projGm_isReduced`).

Helpers added per iter: iter-189 +0 (NEW file at 0); iter-190 +0
(NEW substrate landed kernel-only).

### Lane E — `AbelianVarietyRigidity.lean`

Strategy phase: **Rigidity / iotaGm packaging**.
STRATEGY.md "Iters left": (not separately rowed; embedded in Route C
chart-bridge stack).
Phase entered: iter-180+.
Elapsed: ~10 iters.

Per-iter signals:
- iter-186: 2 sorries
- iter-187: 2; substrate refactor attempted
- iter-188: 2; STUCK + OVER_BUDGET
- iter-189: 2; structural-conflict surfaced
- iter-190: 2; refactor `lane-e-iotagm-packaging` extracted
  `iotaGm_r_1` def + `iotaGm_r_1_fac`; iter-190 prover closed
  `iotaGm_r_1_range_subset` body axiom-clean (Attempt 2 via stepwise
  `change` chain); 3 → 2; chart1_composition_isOpenImmersion not
  closed (~150 LOC budget exceeded)

iter-190 prover status: SUCCESS HARD BAR MET (1 closure axiom-clean).

Helpers added per iter: iter-190 +1 (the refactor extracted def, but
also closed body so net structural).

### Lane H — `RiemannRoch/RRFormula.lean` (HALTED iter-190)

Strategy phase: **RR.2 assembly**.
STRATEGY.md "Iters left": ~4-8.
Phase entered: iter-178.
Elapsed: 12 iters (iter-178 → iter-190).

Per-iter signals:
- iter-186-189: HALTED pending H1Vanishing chapter
- iter-190: H1Vanishing chapter LANDED (560 lines via writer
  `rr-h1vanishing-skeleton`); RRFormula prover NOT dispatched
  (still gated on H1Vanishing.lean Lean scaffolding)

iter-191 plan: dispatch file-skeleton prover on H1Vanishing.lean per
the chapter signatures (file-skeleton dispatch type), THEN bodies in
subsequent iters → RRFormula closes downstream.

### Lane A — `RiemannRoch/OCofP.lean` (DEFERRED iter-190)

Per progress-critic CONDITIONAL iter-190: 3 remaining OCofP sorries
gated on RR.2.H¹ scaffolding iter-191+. Deferred iter-190 to avoid
wasted PARTIAL.

iter-191 plan: continue deferral (gated on H1Vanishing.lean
substrate work).

### Lane M↓ — `Albanese/CodimOneExtension.lean` (RE-OPENED iter-190)

Strategy phase: **Lane M↓ Stacks 00TT**.
STRATEGY.md "Iters left": **~8-15**.
Phase entered: iter-190 plan-phase (re-opened from suspended).
Elapsed: 1 plan-phase iter.

Per-iter signals: file unchanged iter-190 (no prover dispatch).
iter-191 plan: dispatch first prover on
`isRegularLocalRing_stalk_of_smooth` skeleton (~50-100 LOC initial via
smooth → flat → polynomial presentation chain).

## Iter-191 proposed objectives (the planner's draft)

The planner is proposing 7 prover lanes for iter-191:

1. **`RiemannRoch/RationalCurveIso.lean`** — Lane I CLASH FIX +
   Pin 3 Step 2 continued
2. **`Picard/QuotScheme.lean`** — Lane F Step 3 residual close
3. **`Albanese/AuslanderBuchsbaum.lean`** — Lane G continued (`x ∈ 𝔭`)
4. **`Genus0BaseObjects/GmScaling.lean`** — Lane B consumers
5. **`AbelianVarietyRigidity.lean`** — Lane E continued
6. **`RiemannRoch/H1Vanishing.lean`** — Lane H NEW file scaffold
7. **`Albanese/CodimOneExtension.lean`** — Lane M↓ first skeleton

Dispatch-sanity check: 7 lanes is under the 10-cap. Lane A.3.i is
NOT in the list (HALTED pending analogist verdict).

## Output

Verdict per active route. The planner reads your verdicts and either
follows the corrective or writes an explicit rebuttal in
`iter/iter-191/plan.md`.

Specifically flag any route the planner is proposing to dispatch
this iter that you think should be HALTED (e.g. CHURNING with no
new corrective), and any HALTED route where a fresh corrective is
now available.
