# Strategy Critic Report

## Slug
iter131

## Iteration
131

## Routes audited

### Route: Over-k path commitment (M2.a / M2.b without base-change to k̄)

- **Goal-alignment**: PASS — the over-k rigidity, applied at a marked `k`-point in the `C(k) ≠ ∅` arm + vacuity in the `C(k) = ∅` arm, produces the protected `JacobianWitness` for genus-0 curves under the frozen signature.
- **Mathematical soundness**: PASS — pieces (i)+(ii)+(iii) are intrinsically k-agnostic per `analogies/cotangent-vanishing-pile-over-k.md`; the relevant Mathlib infrastructure (`Differential.ContainConstants`, `frobenius R p`, `Scheme.Over.ext_of_eqOnOpen`) carries no alg-closed hypotheses.
- **Sunk-cost reasoning detected**: yes — see § Sunk-cost flags entry 1 (the iter-130 close as standing evidence for over-k tractability after the iter-130 strike).
- **Phantom prerequisites**: none under (B); the scheme-level absolute Frobenius is *honestly* labelled a gap with revised 800–1500 LOC budget; the (B)→(A) bridge is contingent (trigger (a')).
- **Effort honesty**: reasonable, with one caveat — the 2–6 iter / 0–500 LOC "saving vs over-k̄ baseline" is now a lower-bound-zero band, openly admitted. The over-k case is defended on cleanliness + revert wiring rather than headline LOC; this is honest framing.
- **Verdict**: SOUND — the over-k route is structurally defensible and has working revert triggers. The marginal quantitative case has been correctly downgraded; do not retreat from this commitment on iter-131 evidence alone.

### Route: Replacement (B) chart-base-changed `cotangentSpaceAtIdentity` body

- **Goal-alignment**: PARTIAL — (B) delivers a `ModuleCat k` whose rank equals `n`, which is enough for the rank-only consumer at the rigidity argument's existential phrasing. It is **not** the canonical cotangent at identity that the blueprint prose names. Goal-alignment depends on every downstream consumer being rank-only.
- **Mathematical soundness**: PASS — base-changing `Ω[Γ(V)/Γ(U)]` along `ψ_V : Γ(V) → k` to obtain a rank-`n` `k`-module is mathematically correct; the analogy traces the closure chain end-to-end against verified Mathlib lemmas.
- **Sunk-cost reasoning detected**: yes — see § Sunk-cost flags entries 2–3.
- **Phantom prerequisites**: `Module.Free.tensorProduct` / `Module.finrank_baseChange` are tagged `[expected]` in the analogy (not yet verified by name). These are standard Mathlib idioms and very likely exist, but the iter-132+ rank-lemma prover lane should verify by name before dispatch.
- **Effort honesty**: **under-counted**. The iter-129 analogist gave (B) "50–100 LOC, 1–2 prover iters" for the rank lemma + body presentation. Iter-128 (wrong body), iter-130 (opaque body), iter-131 (refactor diversion, no prover dispatch), iter-132+ (rank-lemma prover) is now **at least 4 iters and ≥ 200 LOC** for the same scope. The 50–100 LOC / 1–2 iter framing is empirically broken; STRATEGY.md should record the revised piece (i.a) budget honestly (definition + rank lemma: ~4–5 iter / 250–500 LOC under (B)) and propagate the 1-iter slip to the M2.a body closure chain.
- **Verdict**: **CHALLENGE** — (B) is structurally defensible but the iter-131 plan must (a) revise the piece (i.a) budget honestly, (b) make the iter-131 refactor's deliverable testable before close (i.e. rank-lemma stub statement must type-check against the refactored body), and (c) pre-commit to a piece-(i.b) feasibility analogist *before* the iter-132+ prover lane proceeds further than the rank lemma. Item (c) is the most important — see Route below.

### Route: Trio decomposition for piece (i.a) — "definition + bridge + rank"

- **Goal-alignment**: PARTIAL — the trio framing is a vestige of the iter-129 (A)-vs-(B) deliberation. Under (B), there is **no bridge step**: the rank lemma closes directly via `smooth_locally_free_omega` + `rank_kaehlerDifferential` + base change. Under (A), the bridge (standard-smooth-at-prime ⇒ regular-local-ring-of-dim-n) is a substantive 300–600 LOC piece, but that's only on the (B)→(A) escape branch.
- **Mathematical soundness**: PASS, but framing-confused — the directive's blueprint summary lists "(i.a-bridge) to local-ring cotangent (`\notready`)" as a piece in `RigidityKbar.tex`. Under iter-129's PROCEED-on-(B) verdict, this bridge piece **should not be on the live build path**. It exists in the blueprint as either (a) a vestige to delete, or (b) a contingent piece keyed to trigger (a') firing.
- **Sunk-cost reasoning detected**: no, but framing rot — the trio was authored when (A) was a live candidate; under (B), it overstates the scope.
- **Phantom prerequisites**: none.
- **Effort honesty**: over-counted relative to (B), under-counted relative to (A). The trio shape conflates two routes' scopes.
- **Verdict**: **CHALLENGE** — STRATEGY.md should either (a) explicitly mark the "(i.a-bridge)" blueprint piece as "vestigial under (B); only relevant if trigger (a') fires," or (b) collapse the trio to a duo (definition + rank lemma) under (B). The current blueprint listing risks the iter-132+ prover or blueprint-writer trying to populate the bridge piece *under (B)*, burning iters on a piece that doesn't need to exist on the live path.

### Route: iter-150+ M2.a body closure sequencing

- **Goal-alignment**: PASS — the sequencing produces the closed `rigidity_over_k` body and downstream `genusZeroWitness` body, which is what M2 needs.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: under-counted by 1 iter — the iter-128 wrong body + iter-130 opaque body + iter-131 refactor diversion has shifted piece (i.a) closure to iter-132+. The downstream chain (piece (i.b) iter-133+, piece (i.c) iter-137+, piece (ii) iter-141+, piece (iii) iter-144+, M2.a body iter-151+, M2.b body iter-153+, M2 closure iter-157+) should be recorded honestly. The strategy already has Q5-iter-130 logged a 2–4 iter / 320–750 LOC under-count for M2.b; the iter-131 slip is a separate (smaller) one and should be appended.
- **Verdict**: **CHALLENGE** — append the iter-131 1-iter slip to the Sequencing table; the slip is small but cumulative honesty matters for the iter-156+ M2 closure date.

### Route: Trigger (a') auto-revert clause + iter-130 strengthening

- **Goal-alignment**: PASS — the trigger is the load-bearing safety net for the over-k commitment.
- **Mathematical soundness**: PASS — the trigger fires on the right signal (piece (i.b) functorial shear-iso INCOMPLETE or requires inline (B)→(A) bridge ≥ 300 LOC).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND — the strengthened iter-130 clause is the right hedge. **One refinement recommendation** (not a CHALLENGE): add an *earlier* tripwire that fires now — if the iter-131 refactor itself needs > 200 LOC to expose chart data via `Classical.choose`, that's an inversion of (B)'s headline "50–100 LOC closure" budget and a leading indicator that piece (i.b) will need the bridge. A 200-LOC chart-exposure cost would not destroy (B), but it would justify pre-emptively scoping the (A) escape ahead of iter-133+.

## Alternative routes (suggested)

### Alternative: (B′) chart-base-change at `m_V`-quotient level — `m_V / m_V²` over the chart's prime corresponding to `η(pt)`

- **What it looks like**: Instead of base-changing `Ω[Γ(V)/Γ(U)]` along `ψ_V : Γ(V) → k`, define `cotangentSpaceAtIdentity G := m_V / m_V²` where `m_V ⊂ Γ(V)` is the maximal ideal corresponding to the prime `ψ_V^{-1}(0)` (the image of `η_G` restricted to V). This is the "stalk-side at the chart" approach — half-way between (A) and (B).
- **Why it might be cheaper or sounder**: The fibre `m_V / m_V²` is the canonical cotangent of the affine chart at the marked point. It has rank `n` for free (smoothness at the point ⇒ regular local ring ⇒ cotangent of rank `n`), bypassing the Kähler-module-base-change argument. It is still chart-dependent (so `Classical.choice`-flavoured) but the rank lemma closes via `IsLocalRing.subsingleton_cotangentSpace_iff` / `IsRegularLocalRing.iff_finrank_cotangentSpace` *directly*, without `Module.Free.tensorProduct` plumbing. More importantly, the shear iso `(a, b) ↦ (a · b, b)` has a natural restriction to `Spec Γ(V) × Spec Γ(V)` (the affine chart's diagonal), where the cotangent at the diagonal point IS `m_V / m_V²` — making piece (i.b) globalisation more direct on the chart.
- **What the current strategy may have rejected**: the iter-129 analogy file (Decision 2) characterised (A) as the "stalk-side `IsLocalRing.CotangentSpace`" route at 500–1000 LOC for the *global* stalk. The chart-level (B′) variant evaluates the same idiom but only on the chosen chart's ring, which is cheaper because the stalk identification step is replaced by a chart-localisation step. The analogy did not separately consider this hybrid; it framed the choice as (A: global stalk) vs (B: global base-change) vs (C: sheafify).
- **Severity of the omission**: **major**. If piece (i.b) needs the cotangent at identity as a named fibre with reasonable canonicity properties — which is the strategy-critic Q2 concern — (B′) gives that without (A)'s full global-stalk overhead. The strategy should dispatch a one-iter analogist to scope (B′) against (B) at the rank-lemma + piece-(i.b) joint planning horizon. If (B′)'s rank-lemma closure path is ≤ (B)'s, and (B′)'s piece-(i.b) closure is structurally cleaner, it dominates.

### Alternative: fibre-free piece (i) reformulation (already mentioned, but under-emphasised)

- **What it looks like**: Prove `Ω_{G/k}` is globally free of rank `n` directly via the shear iso, without ever defining or naming `cotangentSpaceAtIdentity`. The shear iso establishes a globally-trivial relative cotangent sheaf; the rank claim is a property of `Ω_{G/k}` itself.
- **Why it might be cheaper or sounder**: Eliminates piece (i.a) entirely. Folds (i.a) + (i.b) + (i.c) into a single proof obligation "Ω_{G/k} is globally free of rank `n`". The proof obligation is heavier (~400–800 LOC vs the bundled 800–1500), but the structural risks of (B)'s chart-dependent fibre disappear: there is no fibre to choose.
- **What the current strategy may have rejected**: STRATEGY.md mentions this as a "documented backup option" with trigger "if iter-131+ piece (i.b) closure fails under both (B) AND (A)". This puts the fibre-free reformulation at the *third* attempt, after (B) and (A) have both burned iters.
- **Severity of the omission**: **minor** in absolute terms (the strategy does name it), **major** in priority — the fibre-free option should be elevated from "Option 3 backup" to "Option 1 alternative if iter-132+ rank lemma under (B) closes cleanly but iter-133+ (i.b) shows friction". Promotion criterion: the *moment* (B)'s rank lemma closes (iter-132+), the strategy should re-evaluate whether to pursue (i.b) under (B) or pivot to fibre-free for (i.b)+(i.c). Both options would have a closed rank lemma in hand; only the (i.b) approach differs.

### Alternative: skip piece (i.a) entirely — fold cotangent-at-identity into the rigidity proof's local term-mode

- **What it looks like**: Drop the named `cotangentSpaceAtIdentity G` declaration. Inside the body of `rigidity_over_k`, construct the chart-base-changed module *locally* (term-mode), use it for the cotangent-vanishing argument, and discard it. No external declaration; no rank-lemma-as-separate-theorem.
- **Why it might be cheaper or sounder**: Eliminates ~100–200 LOC of named-declaration plumbing and the iter-131 opacity-defect problem entirely (since `Classical.choose` term-mode obtain inside a proof block exposes the chart naturally without sigma-typing into an external declaration). Sacrifices the blueprint chapter's prose readability ("the cotangent at identity is …" becomes "in the proof of rigidity we construct an auxiliary module …").
- **What the current strategy may have rejected**: The iter-128 scaffold landed `cotangentSpaceAtIdentity` as an external named declaration per the iter-128 progress-critic's "borderline-too-ambitious bundling" warning, which separated definition from rank lemma. That separation logic *required* the declaration to be external. With the iter-131 evidence that external naming is leaking opacity defects, term-mode internalisation deserves a re-look.
- **Severity of the omission**: **minor** — this is a stylistic / blueprint-coherence question and unlikely to dominate any LOC budget, but it's worth one paragraph in STRATEGY.md to note that the named-declaration is a presentation choice, not a strict requirement.

## Sunk-cost flags

1. > "the iter-130 prover lane that closed `cotangentSpaceAtIdentity` body to Replacement (B) landed kernel-clean and passed the iter-130 progress-critic acceptance test on its literal terms"

   **Why this is sunk-cost**: A body that type-checks but wraps its content in `Classical.choice ⟨_⟩` — discarding the chart witness — is not a real piece-(i.a) deliverable. It type-checks; it does not deliver. Citing "kernel-clean close + progress-critic pass" as evidence the iter-130 prover lane succeeded re-affirms an outcome that is, in substance, an unfinished close. The strategy already struck the iter-128 close as evidence (per Q1-iter-130); the iter-130 close deserves the same treatment for the same reason — Lean type-checking is not mathematical progress when the result is unusable downstream.

   **Recommendation**: Reframe iter-130 in STRATEGY.md's sequencing table: "iter-130 prover lane shipped a Lean-type-correct but mathematically-opaque body that requires refactor iter-131 before downstream rank-lemma work. Net iter-130 progress: 0 piece-(i.a) deliverables. Cumulative piece-(i.a) iters: iter-128 + iter-130 + iter-131 + iter-132 (planned) = 4 iters consumed for definition + rank lemma."

2. > Iter-131 plan: "refactor only; no prover dispatch this iter"

   **Why this is sunk-cost-adjacent**: Iter-128 was named the META-PATTERN TRIPWIRE checkpoint ("iter-128 MUST dispatch a prover or the meta-pattern flips to CHURNING"). Iter-128's prover dispatch shipped a wrong body. Iter-130's prover dispatch shipped an opaque body. Iter-131 now defers prover to iter-132. The pattern is: each prover dispatch on piece (i.a) closes-but-is-wrong, triggering a refactor before the next prover dispatch. The strategy should not present iter-131 as a clean refactor lane; it should record this as "iter-131 is the **second** prover-recovery iter for piece (i.a)" and treat the pattern as a leading indicator that piece (i.a) is sized larger than the strategy estimates.

   **Recommendation**: Add a META-PATTERN-TRIPWIRE re-evaluation to iter-131's plan.md (or STRATEGY.md): "Piece (i.a) has now consumed 3 iters of refactor-or-prover work without a usable deliverable. If iter-132+ prover lane on the rank lemma also returns INCOMPLETE or requires further refactor, the strategy MUST trigger a piece-(i.a)-scoping analogist on whether the entire (B) route should be replaced with (A) or fibre-free reformulation before further iter burn."

3. > "the iter-131 plan-agent intends to dispatch a refactor lane (not a prover lane) to fix the body shape"

   **Why this is sunk-cost-adjacent**: The directive describes the iter-131 plan as fixing "the body shape". This presumes the body's *math* is right and only its *presentation* is wrong. That presumption is sunk-cost: the iter-129 analogist gave (B) the verdict "non-canonical (depends on chart choice via `Classical.choice`)" — so a `Classical.choice`-flavoured body is *intrinsic* to (B), not a presentation defect. The iter-131 refactor is genuinely needed (to expose chart witness via sigma-typed `Classical.choose`), but framing it as "fixing the iter-130 body shape" understates that the iter-130 body was shipped against the analogy's recommended construction.

   **Recommendation**: The iter-131 refactor's directive should explicitly cite the analogy file's recommended body shape (`obtain ⟨U, V, e, hxV, ...⟩ := smooth_locally_free_omega ...; exact (ModuleCat.extendScalars ψV.hom).obj ...`) and require the deliverable match it. A successful iter-131 close should also dispatch a one-iter analogist on alternative (B′) (chart-level `m_V / m_V²`) to inform the iter-132+ rank-lemma directive, so that the iter-132+ prover lane is not the first thing that discovers a better fibre presentation existed.

## Prerequisite verification

- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`: VERIFIED (in `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`, exact signature confirmed via loogle).
- `IsLocalRing.CotangentSpace`: VERIFIED (in `Mathlib.RingTheory.Ideal.Cotangent`; the analogy's "`Ideal.IsLocalRing.CotangentSpace`" appears to be a stale fully-qualified form — actual Mathlib name is `IsLocalRing.CotangentSpace`).
- `IsLocalRing.instFiniteDimensionalResidueFieldCotangentSpaceOfIsNoetherianRing`: VERIFIED (gives `FiniteDimensional (ResidueField R) (CotangentSpace R)` for any Noetherian local ring).
- `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`: VERIFIED (per analogy; not re-checked here).
- `Mathlib.Algebra.CharP.Frobenius` ring-level Frobenius: VERIFIED (per `cotangent-vanishing-pile-over-k.md` Decision (iii)).
- `Differential.ContainConstants`: VERIFIED (per `cotangent-vanishing-pile-over-k.md` Decision (ii); `Mathlib/RingTheory/Derivation/DifferentialRing.lean:62–66`).
- `AlgebraicGeometry.GrpObj.lieAlgebra` / `cotangentSpaceAtIdentity`: VERIFIED in-project (iter-128 landing). Not a Mathlib piece.
- `AlgebraicGeometry.Scheme.absoluteFrobenius`: **CONFIRMED GAP** — Mathlib b80f227 has no scheme-level Frobenius; the project must build it (revised 800–1500 LOC).
- `Module.Free.tensorProduct` / `Module.finrank_baseChange`: tagged `[expected]` in the analogy — likely exists under standard Mathlib idioms but **not verified by name in this critique**. Iter-132+ rank-lemma prover lane should verify these by name before dispatch; if missing, the rank lemma's claimed 50–100 LOC closure may slip.

## Must-fix-this-iter

- **Route Replacement (B)**: CHALLENGE — (a) revise piece (i.a) budget honestly in STRATEGY.md (definition + rank lemma now ≥ 4 iter / ≥ 200 LOC consumed before any rank lemma closes; the iter-129 analogy's "50–100 LOC / 1–2 iter" framing is empirically broken); (b) ensure the iter-131 refactor lane's deliverable is testable before close (rank-lemma stub statement must type-check against the refactored body, exposing chart data via `Classical.choose`, not `Classical.choice`); (c) pre-commit to a piece-(i.b) feasibility analogist before iter-133+ prover dispatch on (i.b).
- **Route Trio decomposition (i.a + i.a-bridge + i.a-rank)**: CHALLENGE — under (B), the "(i.a-bridge)" piece in `RigidityKbar.tex` is vestigial; either mark it explicitly as contingent on trigger (a') firing, or collapse the trio framing to a duo (definition + rank lemma) under (B). The current blueprint listing risks iter-132+ blueprint or prover work being mis-allocated to a piece that doesn't need to exist on the live (B) path.
- **Route iter-150+ M2.a body closure sequencing**: CHALLENGE — append the iter-131 1-iter slip (piece (i.a) closure shifted from iter-128 / iter-129 to iter-132+) to STRATEGY.md's Sequencing table. Downstream chain: piece (i.b) iter-133+ (was 130+), piece (i.c) iter-137+, piece (ii) iter-141+, piece (iii) iter-144+, M2.a body iter-151+, M2.b body iter-153+, M2 closure iter-157+ (was 156+).
- **Alternative (B′) chart-level `m_V / m_V²`**: critical — strategy should dispatch a one-iter analogist to scope (B′) vs (B) at the rank-lemma + piece-(i.b) joint planning horizon, with output landing iter-132 or iter-133. If (B′) dominates (B) on either rank-lemma cost or piece-(i.b) closure, it should be the route adopted for iter-132+.
- **Alternative fibre-free piece (i) reformulation**: minor — elevate from "Option 3 backup" to "evaluate at iter-132+ rank-lemma close" with explicit criterion: if (B)'s rank lemma closes in ≤ 100 LOC, evaluate fibre-free for (i.b)+(i.c) before continuing on (B)'s (i.b).
- **Sunk-cost flag 1 (iter-130 close as evidence)**: must-fix — reframe the iter-130 outcome in STRATEGY.md's sequencing table as "0 piece-(i.a) deliverables; type-correct opaque body requires iter-131 refactor before downstream work". Stop citing iter-130 as positive evidence for (B) tractability.

## Overall verdict

A fresh mathematician would approve the over-k strategic commitment and the (B) body-presentation choice **on their mathematical merits** — both are sound, and the strategy's revert triggers are well-wired. But the same fresh reader would flag, immediately and loudly, that **the iter-128/130/131 sequence is a pattern, not a one-off**: three iters consumed for what was scoped as a 1–2 iter, 50–100 LOC piece. The strategy currently treats iter-131 as a clean refactor diversion; it is in fact the second recovery iter for a piece whose iter-129 cost estimate has now been empirically refuted by a factor of ~3. The strategy needs to (a) honestly revise the piece (i.a) budget, (b) ensure the iter-131 refactor delivers something testable, and (c) scope alternative (B′) before iter-132+ commits more iter-burn to (B). The iter-131 refactor-only plan IS the right tactical move; what's missing is the strategic acknowledgment that this is the *second* tactical recovery and the *third* iter on piece (i.a), and that the meta-pattern is now a leading indicator that the (B)-vs-(A) / fibre-free decision deserves a fresh look at iter-132+ rank-lemma close, not at the much-later piece-(i.b) close.

Five routes audited; three CHALLENGE verdicts on routes; one critical and one minor alternative omission; three sunk-cost flags. No REJECT verdicts — the strategy is recoverable with directed edits.
