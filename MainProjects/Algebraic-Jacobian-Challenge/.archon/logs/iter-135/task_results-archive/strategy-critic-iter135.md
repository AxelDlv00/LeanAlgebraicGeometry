# Strategy Critic Report

## Slug

iter135

## Iteration

135

## Posture going in

The directive explicitly framed three questions: (1) is the active
critical path still mathematically sound; (2) are the absorbed
iter-134 CHALLENGEs settled, live-pending, or in need of re-issue;
and (3) is over-k holding up vs. its competitors. I read STRATEGY.md
end-to-end (569 lines), the iter-134-introduced text in particular,
the protected signatures in `references/challenge.lean`, all eleven
blueprint chapter heads, and spot-checked named Mathlib infra via
`mcp__archon-lean-lsp__lean_loogle` and `grep` against the local
Mathlib snapshot.

## Iter-134 absorbed-challenges status

The iter-134 critique surfaced three CHALLENGEs (and two minor
alternatives). I checked the iter-134 → iter-135 stable text to see
which CHALLENGEs are now settled in STRATEGY.md, which remain
live-pending verification, and which need re-issuing.

- **iter-134 CHALLENGE 1 — Trigger (a') LOC arm (was: trigger only
  fired on prover-lane verdict, leaving a "ships 600+ LOC inside
  the iter envelope but still fails" failure mode unaddressed).**
  **STATUS: ABSORBED**, line 496 of STRATEGY.md. The Watchpoint
  now reads "**> 2 iter slip beyond the 2–4 iter envelope OR > 600
  LOC of (i.b)-side build without converging**". The LOC arm is
  named explicitly and the "OR" disjunction makes it independently
  sufficient. Settled.

- **iter-134 CHALLENGE 2 — Forward-merit weighting on the
  fibre-free 4-axis scorecard (was: axes (3)+(4) carry switching-
  cost flavor and shouldn't outweigh axes (1)+(2) when (1) flips
  against (B) after empirical measurement).** **STATUS: ABSORBED**,
  lines 522 of STRATEGY.md. The "Forward-merit-vs-switching-cost
  weighting" paragraph explicitly tags (3) as past-investment and
  (4) as speculative-consumer, commits to re-weighting axes (1)+(2)
  over (3)+(4) at the iter-138+ re-evaluation, and pre-commits to
  downgrading axis (4) to "named-object utility for committed
  protected-declaration consumers only" before treating it as
  load-bearing. Settled.

- **iter-134 CHALLENGE 3 — Piece (i.a) honest framing (was: the
  iter-127 "1 iter, no corrective overhead" estimate vs. the
  iter-132 reality of "5 iter / 3 body reshapes / ~600 LOC of
  build-and-correct" should be visible in the sequencing table,
  not buried in narrative).** **STATUS: ABSORBED**, line 473
  of STRATEGY.md. The piece (i.a) sequencing row now reads
  "**Total cost iter-128→iter-132 across 3 body reshapes: ~600
  LOC of build-and-correct work** … final tree state 284 LOC … the
  corrective overhead (~600 LOC build-and-correct) is the
  visible-to-future-reader signal that 'definition + rank lemma'
  was harder than the iter-127 estimate". Settled.

- **iter-134 minor alternative 1 — `positiveGenusWitness` scaffold
  to be landed parallel to `genusZeroWitness`**. **STATUS:
  EXECUTED**, line 213 of STRATEGY.md confirms scaffold LANDED
  iter-134 via `refactor-positiveGenusWitness-scaffold-iter134`,
  sorry count 3 → 4. Settled.

- **iter-134 minor alternative 2 — M3 scaffold landing (parallel
  to M2 critical path).** **STATUS: EXECUTED** alongside the above
  (the same refactor lane). Settled.

**Net:** the iter-134 critique has been integrated as STRATEGY.md
prose, not silently dropped. No iter-134 CHALLENGEs need re-issuing.

I issue one new CHALLENGE and one new ALTERNATIVE below, both
specific to iter-135 (not iter-134 holdovers).

## Routes audited

### Route: M1 (presheaf-bridge) — EXCISED iter-126

- **Goal-alignment**: PASS — excised piece had zero in-tree
  consumers; deletion is goal-positive.
- **Mathematical soundness**: PASS — M1.d standalone
  (`kaehler_quotient_localization_iso`) preserved as
  off-loop Mathlib-PR utility; no live Lean obligation rests on it.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND.

### Route: M2.a — `rigidity_over_kbar` / `rigidity_over_k`

- **Goal-alignment**: PASS — the genus-0 universal-property arm
  of `nonempty_jacobianWitness` reduces to a rigidity statement
  for morphisms from a smooth proper geom-irr genus-0 curve to a
  smooth proper geom-irr group scheme; this route names exactly
  that statement.
- **Mathematical soundness**: PARTIAL — scaffold landed iter-126;
  body closure depends on pieces (i)+(ii)+(iii) of the over-k
  pile. Soundness rests on the iter-127 over-k analogist's
  OK_OVER_K verdict + the iter-133 mathlib-analogist's
  sheaf-level-RHS proceed verdict. Both are documented,
  Mathlib-name-checked (see § Prerequisite verification), and
  guarded by revert triggers (a')/(b)/(c).
- **Sunk-cost reasoning detected**: yes (1 instance, but
  the strategy itself flags it). Lines 498–505 explicitly call
  out the over-k re-defense: ground (i) "iter-128 kernel-clean
  close = tractability evidence" was struck iter-130; ground (ii)
  "blueprint cleanliness" is downgraded to "real but cheap to
  reproduce"; the only remaining quantitative case is the **0–500
  LOC lower-bound-zero savings vs over-`k̄`+M2.c**. Self-flagging
  is the discipline I would have asked for, so this is fine, but
  see CHALLENGE 1 below for what it means for iter-135.
- **Phantom prerequisites**: none for the scaffold; pieces (i.b),
  (ii), (iii) are NEEDS_MATHLIB_GAP_FILL but every named gap is
  in the live inventory.
- **Effort honesty**: reasonable. Iter-128's piece (iii) inflation
  from 300–600 LOC to 800–1500 LOC was the right call and
  STRATEGY.md still carries it.
- **Verdict**: SOUND (but see CHALLENGE 1).

### Route: M2.b — `genusZeroWitness`

- **Goal-alignment**: PASS — defines a `JacobianWitness C` builder
  on the `genus C = 0` branch with underlying scheme `Spec k`,
  consumes `rigidity_over_k` on the `C(k) ≠ ∅` branch, vacuity
  on the `C(k) = ∅` branch. The vacuity-branch analysis
  (`Jacobian.lean:160` field `isAlbaneseFor` is `∀ P, IsAlbanese …`)
  is correct: when `𝟙_ _ ⟶ C` is empty, the universal
  quantification is vacuously satisfied by Lean's `∀` semantics.
- **Mathematical soundness**: PASS for the scaffold (landed
  iter-127); body closure gated on M2.a body, which is gated on
  the pile. Chain is linear and well-defined.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable. Iter-130's revision (1 iter /
  100–200 LOC → 2–4 iter / 320–750 LOC) for the terminal-object
  cluster + vacuity-branch encoding is honest.
- **Verdict**: SOUND.

### Route: M2.body-pile — pieces (i)+(ii)+(iii)

- **Goal-alignment**: PASS — pieces directly feed `rigidity_over_k`
  body, which feeds `genusZeroWitness`, which feeds the
  genus-stratified body of `nonempty_jacobianWitness`.
- **Mathematical soundness**:
  - **Piece (i.a) DONE iter-132**: kernel-clean, references
    `Module.finrank_baseChange` (verified) and
    `Module.finrank_eq_of_rank_eq` (verified). Sound.
  - **Piece (i.b)** iter-134+: relies on iter-133 mathlib-analogist's
    sheaf-level-RHS recommendation. Sound on the analogist verdict
    but **not yet empirically tested by a prover lane** — see
    CHALLENGE 1.
  - **Piece (i.c)** iter-137+: chart-localisation identification
    pushed in from (i.b); LOC revised 200–500 LOC iter-133. Sound
    on paper.
  - **Piece (ii)** iter-141+: ring-side `Differential.ContainConstants`
    verified in Mathlib; scheme-side lift `Scheme.Over.ext_of_diff_zero`
    is a NEEDS_MATHLIB_GAP_FILL of 250–500 LOC. Sound.
  - **Piece (iii)** iter-144+: scheme-level absolute Frobenius is
    PHANTOM in Mathlib `b80f227` (grep confirms: no
    `AlgebraicGeometry.Scheme.absoluteFrobenius`, no `AbelianVariety`
    namespace, only ring-side `Mathlib.Algebra.CharP.Frobenius`).
    800–1500 LOC PROVISIONAL pending iter-135–138 no-Frobenius /
    higher-Kähler-vanishing analogist. Sound with PROVISIONAL flag.
  - **Piece (iv)** Serre duality: DEFERRED named-gap. Sound to
    defer under the over-k commitment.
- **Sunk-cost reasoning detected**: no (the iter-133 ground (iv)
  reinstatement is explicitly scope-narrowed to piece (i.a) only).
- **Phantom prerequisites**:
  - `AlgebraicGeometry.Scheme.absoluteFrobenius` — confirmed PHANTOM.
    STRATEGY.md correctly labels it.
  - `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim` —
    PHANTOM but in piece (i.c) named build.
  - `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` — PHANTOM but
    in piece (ii) named build.
  - `Ideal.IsLocalRing.CotangentSpace` referenced in STRATEGY.md
    is **slightly misnamed**: the actual qualified name is
    `IsLocalRing.CotangentSpace` (declared at
    `Mathlib/RingTheory/Ideal/Cotangent.lean:299`, in the
    `IsLocalRing` namespace, not `Ideal.IsLocalRing`). The
    `Ideal.` prefix in STRATEGY.md mixes the *file path* with the
    *namespace*. Minor wart, not strategically load-bearing.
- **Effort honesty**: reasonable. The 1850–3600 LOC / 9–20 iter
  total is honestly arrived at.
- **Verdict**: SOUND (with the piece-(i.b) empirical-untested
  caveat in CHALLENGE 1; with the minor naming wart noted above).

### Route: M2.c (Galois descent) + M2.c.aux — DROPPED iter-127

- **Goal-alignment**: PASS — dropping is goal-positive under the
  over-k commitment.
- **Mathematical soundness**: PASS — over-k pile pieces
  (i)+(ii)+(iii) build directly over arbitrary base field per the
  iter-127 analogist; descent is unnecessary.
- **Verdict**: SOUND.

### Route: M3 — `positiveGenusWitness` (off-critical-path)

- **Goal-alignment**: PASS — `positiveGenusWitness` is the
  positive-genus arm of the genus-stratified body of
  `nonempty_jacobianWitness`. Required for the protected target.
- **Mathematical soundness**: PASS at scaffold level (landed
  iter-134). Body closure depends on Route A or Route B; both
  exceed the 5000-LOC hard-fallback threshold; user-escalation
  triggered iter-124; iter-126 user hint endorsed "do the work,
  no axioms; ~6500–9000 LOC may not be that much for an AI".
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: many (Hilbert/Quot/Picard for Route
  A; `Sym^n` of schemes / Stein factorisation for Route B); all
  correctly named as multi-K-LOC Mathlib contributions; all in
  the live inventory under M3.
- **Effort honesty**: reasonable — 100+ iter / 10000+ LOC per
  route is honestly daunting.
- **Verdict**: SOUND (off-critical-path until M2 closes).

### Route: Genus-stratified body of `nonempty_jacobianWitness`

- **Goal-alignment**: PASS — closing the chain.
- **Mathematical soundness**: PASS — `genus C : ℕ` is
  decidable-equality, the `by_cases h : genus C = 0` is
  well-formed, and the two arms `genusZeroWitness` /
  `positiveGenusWitness` cover the disjunction.
- **Verdict**: SOUND, but see ALTERNATIVE 1 below: this route is
  *scheduled* iter-157+ even though both witness scaffolds have
  been landed (M2.b iter-127, M3 iter-134). The "gated on M2.b
  body close + M3 scaffold landing" framing in STRATEGY.md
  line 213 over-restricts the gate — the body restructure can
  land *before* either body closes because both witnesses can
  carry `sorry` bodies indefinitely while the restructure ships.

## Alternative routes (suggested)

### Alternative 1: Land the genus-stratified body restructure now, not iter-157+

- **What it looks like**: STRATEGY.md line 213 says the body
  restructure of `nonempty_jacobianWitness` (the
  `by_cases h : genus C = 0` decomposition into
  `genusZeroWitness` and `positiveGenusWitness`) is iter-157+ work,
  "gated on M2.b body close + M3 scaffold landing here". The M3
  scaffold landed iter-134; the gate now reads "M2.b body close".
  But neither witness's body needs to be closed for the
  restructure to compile and `lean_verify` cleanly to
  `sorryAx` — both can carry `sorry` bodies indefinitely.
  Landing the restructure as a separate refactor lane (estimated
  ~30–60 LOC, single iter) iter-135–137 would let the protected
  `nonempty_jacobianWitness` chain `lean_verify` against TWO named
  `sorry` sites (`genusZeroWitness`, `positiveGenusWitness`)
  instead of ONE inline `sorry`, which is structurally cleaner
  and exposes any instance-resolution / decidable-eq /
  type-class fragility long before iter-157+.

- **Why it might be cheaper or sounder**: (a) zero impact on the
  pile build because the body uses only the two witness *names*,
  not their bodies; (b) early discovery of any
  `by_cases`-decidability issue (`genus C : ℕ` is
  `DecidableEq` but the genus value depends on Mathlib's `H1` on
  `Scheme.toModuleKSheaf C` so the actual `Decidable (genus C = 0)`
  resolution may need a thin helper); (c) the M2 closure date
  iter-157+ is dominated by pile build, not by the restructure
  itself, so landing the restructure now does not race the pile.

- **What the current strategy may have rejected**: line 213's
  "gated on M2.b body close + M3 scaffold landing" framing reads
  like a precondition copied from an earlier strategy iteration
  (when both scaffolds were absent). The M3 scaffold landing
  iter-134 closed half of that gate; the M2.b body close half is
  not actually load-bearing for the restructure.

- **Severity of the omission**: minor. The structural risk of
  late discovery is real but cheap to mitigate.

### Alternative 2: Smoke-test the pile end-to-end against
`rigidity_over_kbar` body before piece (iii) lands

- **What it looks like**: the pile pieces (i.b)+(i.c)+(ii)+(iii)
  are scheduled linearly iter-134 → iter-150 with `rigidity_over_kbar`
  body closure iter-151+. The current strategy has no intermediate
  "do the pieces actually compose" checkpoint between
  iter-141 (piece (ii) landing) and iter-151 (M2.a body). An
  intermediate prover lane around iter-143 that attempts the
  M2.a body closure with pieces (iii) **axiomatised**
  (project-local axiom matching the eventual piece (iii)
  signature, *removed* once piece (iii) lands) would smoke-test
  pieces (i.b)+(i.c)+(ii) composition into the rigidity body
  ~8 iter earlier than the M2.a body closure lane. If the
  axiomatised-piece-(iii) closure attempt fails on a piece-(i)
  or piece-(ii) integration issue, the project learns this at
  iter-143 instead of iter-151.

- **Why it might be cheaper or sounder**: catches integration
  issues 8 iter earlier in a multi-month build. The project's
  soundness rule "No new axioms" forbids the axiomatised piece
  in the *final* tree, but a smoke-test lane that introduces and
  removes the axiom in the same iter does not violate the rule;
  the kernel-clean discipline is checked at piece (iii) landing,
  not at the smoke-test.

- **What the current strategy may have rejected**: the no-axioms
  rule may have been read too strictly. STRATEGY.md § Soundness
  rules line 382 says "Every closed declaration must `lean_verify`
  to kernel-only axioms" — a temporary smoke-test scaffold that
  is removed in the same iter does not close the M2.a body;
  it only verifies that pieces compose. The rule is honored.

- **Severity of the omission**: minor (worth raising; not
  load-bearing for goal alignment).

## Sunk-cost flags

The strategy is largely self-disciplined about sunk-cost. The
one residue worth naming explicitly:

- "**The over-k commitment (iter-133) is now defended on
  cleanliness (ii) + active revert option (iii) + piece (i.a)
  tractability (iv, scope-narrow)**" (line 505). Why this is
  sunk-cost-adjacent: with quantitative net savings of 0–500
  LOC (lower bound *zero*), the over-k vs over-`k̄`+M2.c
  decision is no longer a quantitative win; it is held on
  three qualitative grounds, of which (ii) is itself partially
  past-investment in `RigidityKbar.tex`. The strategy already
  self-flags this on line 505 ("treat (ii) as 'real but cheap
  to reproduce under the over-`k̄` baseline' rather than a
  strong independent ground"). This is fine, but it makes the
  over-k commitment a thin one — the revert triggers (a')/(b)/(c)
  are now the load-bearing safety net. Recommendation: see
  CHALLENGE 1.

## Must-fix-this-iter

- **Route M2.a / M2.body-pile: CHALLENGE 1 — piece (i.b) sheaf-
  level RHS recipe is unverified by any prover lane.** STRATEGY.md
  commits to the iter-133 mathlib-analogist's recommended
  sheaf-level-RHS phrasing for piece (i.b) (`Ω_{G/k} ≅ pr_1^*
  (η_G^* Ω_{G/k})` in the presheaf-of-modules category, with the
  chart-localisation identification pushed into piece (i.c)).
  The watchpoint (line 496) is wired: "> 2 iter slip beyond the
  2–4 iter envelope OR > 600 LOC of (i.b)-side build without
  converging". But the trigger fires only **at piece (i.b) prover
  lane close**, i.e. only after the lane has *consumed up to* 2
  iter / 600 LOC. The empirical risk is asymmetric: if the
  recipe is wrong, the project pays up to 6 iter (the slip
  window) + the (a')/(c) revert cost. **The planner should
  pre-stage a 1-iter spike** for iter-135 or iter-136 — a
  minimal prover lane that tries to *state* the piece (i.b)
  Lean target in sheaf-level RHS form and check
  type-class / instance / pullback-shape resolution against the
  existing `cotangentSpaceAtIdentity` + project's
  `relativeDifferentialsPresheaf`, without attempting body
  closure. This is a cheap signal that the recipe at least
  type-checks. If the spike fails fast, the (a') trigger fires
  before the 600-LOC arm matters; if it succeeds, the lane
  proceeds with empirical confidence. The planner must either
  (a) update STRATEGY.md to schedule this spike, or (b) record
  an explicit rebuttal in `iter/iter-135/plan.md` naming why the
  spike is not needed.

- **Alternative 1: minor — strategy ignored landing the
  genus-stratified body restructure ahead of M2.b body close.**
  Recommendation: planner addresses by either scheduling the
  restructure as a single-iter refactor lane iter-135–137 or
  rebutting the alternative in `iter/iter-135/plan.md`.

- **Alternative 2: minor — strategy lacks an intermediate
  pile-composition smoke-test before M2.a body closure.**
  Recommendation: planner addresses by either scheduling the
  smoke-test as a temporary-axiom prover lane iter-143 or
  rebutting it as not-cost-justified.

## Prerequisite verification

Spot-checked named Mathlib infrastructure against the local
`b80f227` snapshot via `mcp__archon-lean-lsp__lean_loogle` and
`grep`:

- `Module.finrank_baseChange`: VERIFIED
  (`Mathlib/LinearAlgebra/Dimension/Constructions`).
- `Module.finrank_eq_of_rank_eq`: VERIFIED
  (`Mathlib/LinearAlgebra/Dimension/Finrank`).
- `KaehlerDifferential.tensorKaehlerEquiv`: VERIFIED
  (`Mathlib/RingTheory/Kaehler/TensorProduct.lean:249`).
- `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`: VERIFIED
  (`Mathlib/RingTheory/Etale/Kaehler.lean:38`).
- `Algebra.FormallyUnramified.of_isLocalization`: VERIFIED
  (`Mathlib/RingTheory/Unramified/Basic.lean:364`).
- `Differential.ContainConstants`: VERIFIED
  (`Mathlib/RingTheory/Derivation/DifferentialRing.lean:62`).
- `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`: VERIFIED
  (`Mathlib/RingTheory/Smooth/StandardSmoothOfFree.lean:49`).
- `AlgebraicGeometry.isField_of_universallyClosed`: VERIFIED
  (`Mathlib/AlgebraicGeometry/Morphisms/Proper.lean:143`); supports
  the iter-129 diagnostic that the iter-128 evaluate-then-extend-
  scalars body collapsed to zero for the consumer class.
- `Ideal.IsLocalRing.CotangentSpace`: RENAMED — the actual
  qualified name is `IsLocalRing.CotangentSpace` (declared inside
  the `IsLocalRing` namespace at
  `Mathlib/RingTheory/Ideal/Cotangent.lean:299`). STRATEGY.md
  mixes file-path prefix with namespace; future planner / prover
  reads must use `IsLocalRing.CotangentSpace` (no `Ideal.` prefix).
- `AlgebraicGeometry.Scheme.absoluteFrobenius`: MISSING (phantom).
  Confirms STRATEGY.md's piece (iii) honest-LOC accounting;
  scheme-level Frobenius must be built. `AbelianVariety`
  namespace is also fully absent, consistent with the iter-126
  analogist's verdict that the project must use the `GrpObj`
  namespace.

## Overall verdict

A fresh mathematician reading STRATEGY.md as it stands today
**would approve the active critical path with one new caveat**:
the iter-134 critique has been integrated, the route is
goal-aligned, the Mathlib prerequisites are honestly named
(every PHANTOM is in the live inventory), and the revert
triggers (a')/(a'')/(b)/(c) provide the right safety net for
the over-k commitment whose quantitative case is admittedly
thin (0–500 LOC, lower bound zero). The over-k vs over-`k̄`
decision is held more on qualitative grounds than on net-savings
arithmetic, but the strategy itself self-flags this with the
load-bearing analysis on lines 498–505, which is the discipline
I would have asked for. The one new live CHALLENGE: piece (i.b)'s
sheaf-level RHS recipe is committed to via a single analogist
verdict (iter-133) and has not been empirically tested by a
prover lane; the watchpoint fires only after up to 2 iter / 600
LOC of build, which is an asymmetric risk profile worth
pre-empting with a 1-iter type-check spike. Two minor
alternatives (early body restructure landing; intermediate
pile-composition smoke test) are worth surfacing for the planner
to either schedule or rebut.

**Iter-134 absorbed-CHALLENGE status:** 3/3 settled, no
re-issues. **New iter-135 CHALLENGEs:** 1 CHALLENGE + 2 minor
alternatives.
