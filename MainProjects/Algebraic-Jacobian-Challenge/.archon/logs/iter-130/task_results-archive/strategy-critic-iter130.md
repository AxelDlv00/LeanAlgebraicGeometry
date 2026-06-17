# Strategy Critic Report

## Slug
iter130

## Iteration
130

## Routes audited

The current STRATEGY.md operates one critical-path strategic route (M2 over-k → genus-stratified body of `nonempty_jacobianWitness`) plus two sequenced milestones (M1 EXCISED, M3 user-escalated PR-and-wait). I audit each, with extra weight on the five iter-130 directive asks.

### Route: M1 — Presheaf-bridge (EXCISED iter-126)

- **Goal-alignment**: PASS — excision drops a sorry without introducing project debt; the surviving Mathlib-PR candidate `kaehler_quotient_localization_iso` is an off-loop optional.
- **Mathematical soundness**: PASS — the excise's grep-confirmed "zero in-tree consumers" is the right test.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND.

### Route: M2 — Over-k rigidity → `genusZeroWitness` → `nonempty_jacobianWitness` (THE critical path)

- **Goal-alignment**: PASS, contingent — the genus-stratified `by_cases h : genus C = 0` reformulation does close `nonempty_jacobianWitness` once both `genusZeroWitness` and `positiveGenusWitness` materialise. The signature freezes work in M2's favour. The vacuity claim on `IsAlbanese C P J` when `𝟙_ _ ⟶ C` is empty is type-theoretically valid (`∀ P, P ∈ ∅ → ...` is vacuous).
- **Mathematical soundness**: PARTIAL — the over-k rigidity argument is mathematically sound at the prose level (the shear iso is base-independent; absolute Frobenius is intrinsic; `Differential.ContainConstants` is k-agnostic). But the iter-129 Replacement-(B) decision introduces a new soundness concern (see Q2 below): the chart-dependent cotangent at identity may NOT cleanly couple with the iter-130+ piece-(i.b) shear-iso globalisation, because that step IS effectively Lie-algebra-style and the analogist explicitly flagged "for a hypothetical future Lie-algebra-bracket consumer, replacement (A) or (C) would be required."
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags below. The "over-k re-defense on revised numbers" section invokes "the iter-128 prover lane closed `lieAlgebra` body kernel-clean on the over-k path" as ground (i) of the affirmative defense, while the *same iter* the analogist concluded that the iter-128 body is *mathematically wrong* (provably zero for the consumer class). A body that compiles kernel-clean but provably computes the wrong object is empty evidence for the over-k path's tractability.
- **Phantom prerequisites**: Two candidates the planner names as confirmed Mathlib that are at least worth a second look. **`AlgebraicGeometry.Scheme.absoluteFrobenius`** is correctly flagged PHANTOM and budgeted (good). **Step (5a) `Module.Free.tensorProduct` and step (5b) `Module.finrank_baseChange`** are tagged `[expected]` not `[verified]` in `analogies/lieAlgebra-rank-bridge.md` — under Replacement (B) the rank lemma critically depends on these (this is the difference between "consumable from Mathlib" and "we have to fight typeclass inference for a few hundred LOC"). One quick prover lane should verify they exist *for the precise ring-changing situation* before committing to Replacement (B). Spot-check: I verified `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`, `Algebra.IsStandardSmooth.free_kaehlerDifferential`, `Ideal.IsLocalRing.CotangentSpace`, `IsRegularLocalRing`, `Differential.ContainConstants`, `AlgebraicGeometry.isField_of_universallyClosed`, and `Mathlib.Algebra.CharP.Frobenius` all exist. **`Scheme.frobenius`/`absoluteFrobenius` returned no results — confirms the PHANTOM call.**
- **Effort honesty**: under-counted in **two specific places** — see Q5 below. The 9–20 iter / 1850–3600 LOC pile estimate is plausible at its midpoint, but does NOT visibly account for (a) the cluster of instance-construction work needed on `Spec k` for `genusZeroWitness` (group-object structure, `IsProper`, `GeometricallyIrreducible`, `SmoothOfRelativeDimension 0`), and (b) the iter-130 body-swap from the iter-128 wrong body to Replacement (B), which is itself a refactor with downstream callsite churn.
- **Verdict**: CHALLENGE.

### Route: M3 — Positive-genus witness (user-escalated PR-and-wait + do-the-work)

- **Goal-alignment**: PASS at the M3 closure layer (whichever route eventually closes will produce a `JacobianWitness`).
- **Mathematical soundness**: PASS at the prose level for both routes.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: large — the M3 audit names ~6500 LOC of phantom Mathlib infrastructure for Route A. Correctly recorded as such.
- **Effort honesty**: honest. The 6500–9000 LOC estimate is documented and the user has explicitly accepted the cost.
- **Verdict**: SOUND, but inert until M2 closes. M3 is not active on the iter-130 critical path, so I do not score it CHALLENGE.

---

## Answers to the five directive asks

### Q1 — Is the over-k re-defense on revised numbers genuinely sound, or sunk-cost?

**Partially sunk-cost.** Of the three grounds in `STRATEGY.md` § "Over-k re-defense on revised numbers":

- **(i) "iter-128 prover lane closed `lieAlgebra` body kernel-clean on the over-k path":** This is **empty evidence**. By the iter-129 analogist's own verdict, the iter-128 body computes the **zero `k`-module** for every smooth proper geometrically irreducible `G/k` with relative dimension ≥ 1 (the consumer class). A kernel-clean closure of a *mathematically wrong* definition tells you essentially nothing about the over-k path's tractability — it only tells you that Lean's type-checker accepts the construction. The strategy invokes this as positive evidence in the same paragraph that mandates the iter-130 body-swap. That is sunk-cost: claiming credit for an iter-128 deliverable that this iter also declares broken.
- **(ii) "Blueprint is cleaner":** Sound, but minor.
- **(iii) "Auto-revert trigger (c) wired":** Sound process discipline; not sunk-cost.

**Recommendation:** Strike ground (i) from the affirmative defense. The over-k commitment now rests on (ii)+(iii) + the LOC arithmetic. The LOC arithmetic itself is now "0–500 LOC savings, lower bound zero" — so the over-k path is defended **on cleanliness + an active revert option**, not on a quantitative argument. State this honestly in STRATEGY.md.

### Q2 — Is Replacement (B) the right body, or should the project route through (A) or (C)?

**Replacement (B) has a soundness gap the analogist acknowledges in one sentence but the strategy does not actively manage.** The analogist's verdict for (B) says: *"For a hypothetical future Lie-algebra-bracket consumer, replacement (A) or (C) would be required."*

The iter-130+ piece-(i.b) `mulRight_globalises_cotangent` IS effectively a Lie-algebra-style consumer of the cotangent at identity. The shear-iso argument

  `Ω_{G/k} ≅ pr_1^* (η[G]^* Ω_{G/k}) ⊗_k O_G`

names `η[G]^* Ω_{G/k}` (the cotangent at identity) **as the fibre object of the trivialisation**. Under Replacement (B) this fibre is *non-canonical* (depends on a chart V chosen via `Classical.choice`); the LHS `Ω_{G/k}` is canonical. So the shear-iso globalisation requires a bridge stating "the chart-V base-changed Kähler module agrees, up to canonical k-linear iso, with the genuine cotangent fibre at the identity section" — a bridge that is exactly the canonical-cotangent piece that (B) was supposed to avoid.

There are two ways forward, neither of which the strategy commits to:

1. **Commit to Replacement (A) (stalk-side `Ideal.IsLocalRing.CotangentSpace`) for piece (i.a)** despite the +500–1000 LOC. The canonical cotangent at identity is `m_{η_G}/m_{η_G}^2` where `m_{η_G}` is the maximal ideal of the local ring `O_{G, η_G(pt)}`. This is canonical, has the rank-lemma path via `IsRegularLocalRing.iff_finrank_cotangentSpace` (verified), and naturally feeds the shear-iso argument because mulRight acts on `G` and hence on stalks. Net LOC: 800–1500 (B) + soundness-bridge unknown vs ~1300–2500 (A) with no bridge needed. The strategy's claim "(B) saves 500–1000 LOC" may be illusory once the bridge is paid.

2. **Stay with Replacement (B) but explicitly state the piece-(i.b) re-framing.** If `genusZeroWitness` only needs `∃ T, finrank k T = n`, then piece (i.b) need not bottleneck on a specific "cotangent at identity" type — it can be reformulated as "there exists a global frame of `Ω_{G/k}` of rank n" without nominating a single fibre. This is achievable but requires a non-trivial restatement of piece (i.b) at the blueprint level; the current `RigidityKbar.tex` framing (per the strategy's mention) still uses the named-fibre formulation.

**Verdict on Q2:** CHALLENGE — the strategy must either (a) elevate Replacement (A) to the chosen body and accept the +500–1000 LOC, or (b) explicitly re-state piece (i.b) in a form that does not need a canonical "cotangent at identity" fibre. The current state ("Replacement (B) wins on LOC, defer the canonicity issue") is the strategy taking on hidden technical debt.

### Q3 — Is the piece-(iii) honest-LOC accounting (800–1500 LOC for scheme-level absolute Frobenius) consistent with the user-hint citation discipline?

**Yes, this one is clean.** STRATEGY.md justifies the +500–900 LOC piece-(iii) revision on the merits: "Mathlib `b80f227` has NO scheme-level Frobenius at all", "Stacks Tag 0CC4 is the canonical reference for the build". No appeal to "user said do the work" is made for piece (iii) specifically. The user-hint citation discipline rule (newly codified per `strategy-critic-iter128` sunk-cost flag) is honoured. My spot-check via `lean_local_search` confirms: `Scheme.frobenius` returns nothing; only `WittVector.frobenius`, `Mathlib.Algebra.CharP.Lemmas.frobenius`, and `Mathlib.Algebra.CharP.Frobenius.frobenius_def` exist. The PHANTOM call is correct.

The only mild concern: 800–1500 LOC for a scheme-level absolute Frobenius construction is plausible for "definition + smoothness compatibility + cotangent vanishing + iteration lemmas", but it is at the optimistic end of the range. Stacks Tag 0CC4 covers definition + ~5 lemmas; the Lean transcription typically inflates 2–3×. **If piece (iii) approaches 1500 LOC and is less than 50% complete, trigger (b) of the auto-revert clause fires** — good that this is wired.

**Verdict on Q3:** PASS.

### Q4 — Does Replacement (B) + rank lemma + (i.b)/(i.c) close M2.a body, or is over-k structurally flawed?

**The iter-128 failure was an isolated implementation bug, not a structural flaw in the over-k path.** The over-k path is mathematically sound (per the iter-127 analogist's three pieces all OK_OVER_K). The iter-128 body was *one specific construction* (evaluate the presheaf at `op ⊤` + extend scalars) that happens to compute zero for proper geometrically integral `G/k`. Replacement (B) (and (A) and (C)) all sidestep that bug.

**However**, Q2's concern resurfaces here. Replacement (B) closes the *rank lemma* but does NOT obviously close the chained piece-(i.b) globalisation. The chain:

- piece (i.a): cotangent at identity exists, rank n. ✓ under (B)
- piece (i.b): the cotangent at identity, globalised by mulRight, gives a global frame of Ω_{G/k}. — THIS NAMES THE COTANGENT AT IDENTITY AS THE FIBRE. (B) returns a chart-dependent object; the global frame argument needs the fibre to be canonical OR a bridge.
- piece (i.c): Ω_{G/k} is free. ✓ follows from (i.b).

So Q4's answer is: the over-k path is structurally sound, but Replacement (B) closes only step (i.a) and leaves step (i.b) under-specified. If the iter-130+ prover lane on (i.b) encounters the chart-dependence wall, the project will either need to upgrade to Replacement (A) (paying the deferred bridge cost) or restate (i.b) in a fibre-free form. The "auto-revert" trigger (a') is correctly retargeted to iter-130+ piece (i.b) — that's the right place to check this.

**Verdict on Q4:** SOUND on the over-k path itself; **CHALLENGE on the iter-129 body-choice commitment** as flagged in Q2. The iter-128 failure does not invalidate the over-k commitment, but the iter-129 replacement choice may invalidate the piece-(i.b) closure.

### Q5 — Is the iter-149+ M2 closure honest, or under-counted?

**Under-counted in two specific places.**

1. **Terminal-object instance cluster on `Spec k` for `genusZeroWitness`.** The `JacobianWitness C` structure (per `Jacobian.lean:160`-area, per the strategy) requires: underlying scheme + group-object structure + `SmoothOfRelativeDimension n` (matching `genus C`) + `IsProper` + `GeometricallyIrreducible` + `isAlbaneseFor` field. For `genusZeroWitness`, all five instances on `Spec k` must be constructed (`Spec k` is a terminal object in `Scheme/k`, so its group-object structure is forced, but the `SmoothOfRelativeDimension 0`, `IsProper`, `GeometricallyIrreducible` instances on `Spec k` over itself need definitional work — none of these are stated as already-built Mathlib instances anywhere I see). The strategy estimates "M2.b body closure: +1 iter / +100–200 LOC". I estimate this cluster alone is 200–500 LOC over 2–3 iter, not 100–200 LOC over 1 iter.

2. **iter-130 body-swap + downstream callsite churn.** The strategy's iter-129 directive mandates swapping the iter-128 `cotangentSpaceAtIdentity` body to Replacement (B) before any rank-lemma dispatch. This is its own refactor (~100–200 LOC: redefine the body, re-export, update callsites — there is at least the `AlgebraicJacobian/Cotangent/GrpObj.lean` file plus possibly the iter-128 blueprint chapter `RigidityKbar.tex` to align). The strategy folds this into the iter-130 "objectives" but does not give it a separate budget line. If the body-swap encounters typeclass inference fights (likely with `extendScalars` on `ψ_V` where `ψ_V` was just synthesised from an adjunction calculation), it could itself eat 1–2 iter.

3. **C(k) = ∅ vacuity branch verification.** The strategy claims the iter-127 vacuity-binder check is settled. The math is sound (`∀ P : Empty, _ ` is `True`), but the *Lean encoding* depends on whether `𝟙_ _ ⟶ C` being empty is decidable at the term level. If the proof has to case-split on `Nonempty (𝟙_ _ ⟶ C)` it needs `Classical.byCases`, and if it has to *use* the empty hypothesis to vacuously satisfy `IsAlbanese`, it needs `IsEmpty.elim` or similar. None of this is hard but it's not zero LOC either. ~20–50 LOC, ~0.5 iter.

**Cumulative under-count: ~300–700 LOC, ~3–5 iter** spread across M2.b body closure and the iter-130 body-swap. The honest iter-149+ M2 closure becomes iter-152+ to iter-172+ — not a strategic-route-breaking miss but worth correcting in the sequencing table.

**Verdict on Q5:** CHALLENGE — under-counted in the visible places named above.

---

## Alternative routes (suggested)

### Alternative: Skip a named "cotangent at identity" object; prove `Ω_{G/k}` locally free + global trivialisation directly

- **What it looks like**: Instead of building `cotangentSpaceAtIdentity` as a k-vector space and then trivialising `Ω_{G/k}` via translation, build the global trivialisation `Ω_{G/k} ≅ O_G^n` directly. The argument: smooth ⇒ locally free; group structure ⇒ the local-free trivialisation, evaluated on the identity-section's open neighbourhood, extends globally via the shear iso applied to the relative differentials sheaf functorially. Never name a single k-vector space as "the" cotangent at identity.
- **Why it might be cheaper or sounder**: Sidesteps the entire Replacement-(A)-vs-(B)-vs-(C) trilemma. The output `Ω_{G/k} ≅ O_G^n` is exactly what the iter-126 chain wanted in the first place; the cotangent at identity was a *waypoint*, not a destination. The trade-off: the shear-iso argument is now stated entirely sheaf-theoretically, which may be heavier in Mathlib than the project's existing `relativeDifferentialsPresheaf` ergonomics.
- **What the current strategy may have rejected**: The strategy commits early to "the cotangent at identity is a k-vector space" framing, inherited from informal Lie-theory prose. The Lean formalisation cost of *naming* the cotangent at identity is paid in spades by Replacement (A)/(B)/(C); a fibre-free reformulation may halve piece (i)'s cost. Likely-unconsidered.
- **Severity of the omission**: major.

### Alternative: Replace the Frobenius iteration argument with the formally-unramified path

- **What it looks like**: Mumford's `df = 0 ⇒ f` constant on a curve uses Frobenius iteration in char p to handle inseparability. An alternative is: in char p, after handling the separable part via `Differential.ContainConstants`, what remains is a purely inseparable factor `C^{1/p^n} → A`, and a smooth `A` over `k` has `Algebra.FormallyUnramified` global sections in a precise sense (any infinitesimal lift extends uniquely). Mathlib's `Algebra.FormallyUnramified.iff_subsingleton_Omega` (verified family) + properness of `A` could in principle short-circuit the iteration. I have not worked out the details, so this is speculative.
- **Why it might be cheaper or sounder**: Avoids building scheme-level absolute Frobenius from scratch (a Mathlib gap of 800–1500 LOC). The formally-unramified machinery already exists for rings; the scheme lift exists for ring-side operations on affine charts.
- **What the current strategy may have rejected**: Strategy commits to Option A (Frobenius iteration) per the iter-126 analogist. The unramified alternative wasn't scoped.
- **Severity of the omission**: minor — speculative; would need a focused analogist to confirm. Mention for the planner's awareness rather than a must-act.

### Alternative: The ℙ¹-specific rigidity hedge (the strategy already names but does not activate)

- **What it looks like**: For the `C(k) ≠ ∅` branch of `genusZeroWitness` only, use the explicit ℙ¹-specific rigidity (Spec k[t] and Spec k[1/t] charts) rather than the general over-k rigidity. The `C(k) = ∅` branch is vacuous.
- **Why it might be cheaper or sounder**: ~500–1000 LOC per the strategy's own hedge note — substantially cheaper than the general pile (1850–3600 LOC).
- **What the current strategy may have rejected**: The strategy explicitly documents this hedge but defers activation to "if the over-k pile exceeds 2000 LOC at iter-145+". This is reasonable as a hedge but the trigger is far downstream. If the iter-130 body-swap encounters obstruction (Q2/Q4 concern), the hedge may be the better immediate pivot rather than continuing on the general pile.
- **Severity of the omission**: minor (already documented as hedge), but worth keeping in active monitoring rather than buried as a fallback.

---

## Sunk-cost flags

- **"the iter-128 prover lane closed `lieAlgebra` body kernel-clean on the over-k path *without* using the shear iso or any base-change-and-descent step, providing empirical evidence the over-k pieces (i)/(ii) are tractable"** — Why this is sunk-cost: the closed body provably computes the *zero `k`-module* for the consumer class (per `analogies/lieAlgebra-rank-bridge.md` Decision 1), so a kernel-clean closure is evidence only of Lean type-checking, not of the over-k path's tractability for the rank-n target. Recommendation: strike ground (i) from the over-k re-defense; rest the affirmative defense on blueprint cleanliness + active revert trigger, and acknowledge the LOC-arithmetic lower bound of zero net savings.

- **"the iter-129 blueprint-writer pass on `RigidityKbar.tex` (which authored the bridge lemma to `𝔪_{η_G} / 𝔪_{η_G}^2`) is closer to the Replacement (A) canonical framing; this is acceptable — the blueprint documents the canonical version and Lean ships the non-canonical (B) as a working stand-in"** — Why this is sunk-cost-adjacent: justifies a blueprint/code divergence ("Lean ships B, blueprint says A") on the grounds that swapping them out is downstream work. A fresh reviewer would say: pick one. If (A) is canonical and the blueprint already aligns to it, the Lean side should align too unless the LOC argument is strong — and Q2 shows the LOC argument is weaker than the strategy claims (B's hidden bridge cost may match A's stated cost). Recommendation: re-open the (A)-vs-(B) decision before iter-130 fires, given Q2's analysis.

---

## Prerequisite verification

I spot-checked the load-bearing Mathlib names via `lean_local_search`:

- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`: VERIFIED.
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: VERIFIED.
- `Algebra.IsStandardSmoothOfRelativeDimension` (the class): VERIFIED.
- `Ideal.IsLocalRing.CotangentSpace`: VERIFIED.
- `IsRegularLocalRing` (the class): VERIFIED. The companion `IsRegularLocalRing.iff_finrank_cotangentSpace` did not appear in my targeted search; the bridge to "smooth over field at prime ⇒ regular local ring of dim n" remains gap-flagged as expected.
- `Differential.ContainConstants`: VERIFIED.
- `AlgebraicGeometry.isField_of_universallyClosed`: VERIFIED.
- `Mathlib.Algebra.CharP.Frobenius` (ring-side `frobenius`): VERIFIED.
- `Scheme.frobenius` / `Scheme.absoluteFrobenius`: MISSING — confirms the strategy's PHANTOM call. Only `WittVector.frobenius` and ring-side `frobenius` (Mathlib.Algebra.CharP.Lemmas) appear.
- `Module.Free.tensorProduct` and `Module.finrank_baseChange`: TAGGED `[expected]` in the analogist file — I did not verify; recommend a quick prover lane confirms these exist in the exact ring-changing form needed before committing Replacement (B) to the iter-130 prover queue.

---

## Must-fix-this-iter

- **Route M2: CHALLENGE — Sunk-cost ground (i)** ("iter-128 prover closed kernel-clean") in the over-k re-defense must be struck. The closed body is the wrong mathematical object; closure is not evidence of over-k tractability. Either remove the claim, or restate as "the iter-128 build verified Lean's type-checker accepts the construction; mathematical correctness is being added this iter via Replacement (B)" — but then re-acknowledge the affirmative defense rests on (ii)+(iii) only.

- **Route M2: CHALLENGE — Replacement (B) vs (A) decision should be re-opened**. The analogist's verdict committed to (B) on a 500–1000 LOC savings argument, but the piece-(i.b) shear-iso globalisation IS a Lie-algebra-style consumer that the analogist flagged as needing (A) or (C). The strategy must either (a) commit to (A) and pay the +500–1000 LOC for canonicity, or (b) restate piece (i.b) in a fibre-free form so the chart-dependence of (B) is not load-bearing. The current "(B) for the rank lemma, decide (i.b) framing later" is technical debt deferred into a downstream prover lane.

- **Route M2: CHALLENGE — Sequencing under-counts (Q5)**. The iter-149+ M2 closure estimate omits (a) terminal-object instance construction on `Spec k` for `genusZeroWitness` (group, `IsProper`, `GeometricallyIrreducible`, `SmoothOfRelativeDimension 0`), (b) the iter-130 body-swap refactor LOC, (c) C(k) = ∅ vacuity-branch Lean encoding work. Honest revision: ~300–700 LOC / 3–5 iter spread across M2.b body closure and iter-130 body-swap; iter-149+ → iter-152+ to iter-172+.

- **Alternative "fibre-free piece (i)" reformulation: MAJOR — strategy ignored a route that may sidestep the entire (A)-vs-(B)-vs-(C) trilemma**. The planner should either (a) explicitly consider and document why a fibre-free piece (i) is not viable, or (b) dispatch an analogist to scope it.

- **Verification request: Module.Free.tensorProduct + Module.finrank_baseChange** in the exact ring-changing form needed by Replacement (B) — confirm before iter-130 fires the rank-lemma prover lane.

---

## Overall verdict

A fresh mathematician would approve the strategic shape (M1 EXCISED, M2 over-k → genus-stratified body, M3 user-escalated) and most of the per-piece reasoning. But the iter-129 body-choice (Replacement B) and the over-k re-defense both carry **deferred-bridge-cost reasoning** that the strategy frames as resolved when it is not: (i) the over-k re-defense smuggles in a sunk-cost claim about the iter-128 closure that the same iter declared mathematically wrong; (ii) the Replacement-(B) choice saves LOC on the rank lemma at the cost of a (B)→canonical bridge that resurfaces in piece (i.b)'s shear-iso step, where the analogist's own verdict says (A) or (C) would be required. The sequencing also under-counts terminal-object instance work for `genusZeroWitness`. The strategy is *workable* but its iter-130 commitments are aimed at a target whose downstream cost has been mis-allocated. The planner should re-open the body-choice decision against the explicit piece-(i.b) consumer requirement, strike the sunk-cost ground from the over-k defense, and add explicit budget lines for terminal-object instance construction and the iter-130 body-swap refactor.
