# Strategy Critic Report

## Slug
iter114

## Iteration
114

## Routes audited

### Route: Phase A — Čech acyclicity (DEFERRED / gated)

- **Goal-alignment**: PASS — Phase A is honestly labelled deferred; L1846 carries `-- DEFERRED (budget): ...` annotation; the route does not gate any of the 9 protected declarations.
- **Mathematical soundness**: PASS — L1846 is correctly identified as mechanizable from existing Mathlib (`IsLocalizedModule.Away` verified to exist in `Mathlib.Algebra.Module.LocalizedModule.Basic`; the strategy's `{Away,pi,prodMap}` triple is plausible).
- **Sunk-cost reasoning detected**: no — the "L1120 PAUSED (7 consecutive PARTIAL + 2 PAUSED iters)" status is an honest pause-counter, not a "we should keep pushing because we've already invested" framing.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — "~30–80 LOC per substep, conditional" is consistent with the substep granularity. The fact that substeps gate on each other (L1212/L1536/L1564 conditional on predecessor) is correctly noted.
- **Verdict**: SOUND.

### Route: Phase B — Cotangent sheaves (~4–8 iter, 3 sorries in scope)

- **Goal-alignment**: PARTIAL — Phase B is explicitly NOT load-bearing for the 9 protected declarations, only for blueprint-completeness. The strategy acknowledges this and provides a rationale ("Scope rationale (added iter-112)"). The rationale is acceptable but the trade-off is on the planner's shoulders, not subsumed.
- **Mathematical soundness**: PARTIAL — the three sorries are mathematically well-posed:
  - L175 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`: close via `PresheafOfModules.DifferentialsConstruction.isUniversal'` (verified to exist) + `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing_types` (verified) is a viable route. ~80–120 LOC is plausible.
  - L897 `cotangent_at_section`: corollary of L880 via pullback preservation of locally-free; plausible as ~1–2 iters.
  - L880 `smooth_iff_locally_free_omega`: this is Hartshorne II.8.15. The forward direction (standard-smooth ⇒ Ω locally free of rank n) leverages `IsStandardSmoothOfRelativeDimension` (verified) plus Jacobi-criterion lemmas. The converse is much harder — it requires either deformation-theoretic lifting or rebuilding a local standard-smooth chart from a Ω-trivializing chart and a flatness hypothesis. Mathlib b80f227's `IsSmooth` is defined as *standard-smooth-locally* (not formally-smooth), so the converse demands constructing standard-smooth charts.
- **Sunk-cost reasoning detected**: yes — minor. The "Scope rationale" reason (ii) "erase the post-C1 monoidal-X.Modules work that establishes the *correct* sheaf-theoretic `LineBundle` as the iter-109 promotion delivered" leans on sunk-cost framing (we should not trim because doing so would *erase* prior work). The genuine reason is (i) blueprint commitment; (ii) double-counts erasure-cost as merit.
- **Phantom prerequisites**: none.
- **Effort honesty**: under-counted on L880. "Heaviest of the three ~2–4 iters" is optimistic. Hartshorne II.8.15's converse via Nakayama + standard-smooth-chart construction is a substantial theorem; 5–10 iters / 400–800 LOC is more realistic. Forward direction may land in 2–3 iters, but the converse alone is plausibly 3–6.
- **Verdict**: CHALLENGE — L880 effort estimate is under-counted; the planner must either (a) widen the estimate, (b) decompose L880 into forward / converse with separate budgets, or (c) explicitly defer the converse via a soundness-rule-compliant iff-helper pattern if the converse becomes a 50+-LOC blocker.

### Route: Phase C0 — Monoidal `X.Modules` (DEFERRED via Mathlib gap)

- **Goal-alignment**: PASS — `instIsMonoidal_W` is correctly framed as load-bearing-post-C1 and is explicitly disclosed.
- **Mathematical soundness**: PASS — the gap (`stalk_tensorObj` for varying-ring R₀) is a genuine Mathlib limitation; I could not locate it via loogle / leansearch.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: N/A (deferred).
- **Verdict**: SOUND.

### Route: Phase C1 — Refined `LineBundle` (DONE iter-109)

- **Goal-alignment**: PASS — `LineBundle X := (Skeleton X.Modules)ˣ` is the canonical sheaf-theoretic LineBundle. `CategoryTheory.Skeleton` is verified to exist (`Mathlib.CategoryTheory.Skeletal`).
- **Mathematical soundness**: PASS — `Pic.pullback` hand-built through `mapSkeleton` is a valid construction provided the iter-109 sister pair (`SheafOfModules.pullback_tensorObj` and `pullback_oneIso`) is mathematically TRUE. Both are mathematically true (pullback is left-adjoint to pushforward, hence preserves colimits hence tensor products; preserves the unit by adjunction), so they are honest Mathlib-infrastructure gaps, not unsound fudges.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none — `SheafOfModules.pullback` exists; only its monoidal-coherence isos are absent.
- **Effort honesty**: 0 (done).
- **Verdict**: SOUND.

### Route: Phase C2 — `PicardFunctor` re-derivation (~0–4 iter, ~0–80 LOC)

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — the iter-109 universe bumps likely absorbed the C1 promotion side-effects.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — "Likely outcome: no further work needed" is appropriately hedged with a verification-round caveat.
- **Verdict**: SOUND.

### Route: Phase C3 — Representability / `JacobianWitness` (DEFERRED via exit policy)

- **Goal-alignment**: PASS — the exit policy correctly identifies `nonempty_jacobianWitness` as the single load-bearing gap on the protected chain.
- **Mathematical soundness**: PASS — `Nonempty (JacobianWitness C)` for a smooth proper geometrically irreducible curve over a field IS classically true (Jacobians exist; the witness packages the data the protected decls need). A `sorry`-bodied existence of a true statement is soundness-rule-compliant per the strategy's own rule.
- **Sunk-cost reasoning detected**: no — the strategy-critic-iter105 REJECT of the 10–15 / 1500 LOC estimate was correctly accepted; the realistic 50–150 iter / 5000–15000 LOC scope is honestly disclosed.
- **Phantom prerequisites**: Hilbert schemes, Quot schemes, finite-group scheme quotients absent from Mathlib b80f227 — I could not locate Hilbert/Quot scheme infrastructure via leansearch (only generic `Scheme` results). The strategy's claim is correct.
- **Effort honesty**: reasonable for the deferred-track estimate.
- **Verdict**: SOUND.

### Route: Phase D, E — file-level closure

- **Goal-alignment**: PASS — file-level closure already achieved; content-level routed through `JacobianWitness`.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: 0 / 0.
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: Tighten L1039 `serre_duality_genus` Lean signature rather than relax blueprint prose

- **What it looks like**: The "Prior critique status" notes that iter-114 plans to reconcile the `IsIntegral C.left` / `Smooth C.hom` hypotheses of `serre_duality_genus` by relaxing blueprint prose (rather than tightening Lean). An alternative: keep the blueprint prose at "smooth proper geometrically irreducible curve over a field" and either (i) raise the Lean signature to `[IsGeometricallyIntegral]` once Mathlib provides it (note this gap is real — I verified that only `AlgebraicGeometry.IsIntegral` exists for schemes in b80f227, no `IsGeometricallyIntegral`), or (ii) add an explicit `% NOTE:` reference like `[gap: IsGeometricallyIntegral]` and keep the prose intact.
- **Why it might be cheaper or sounder**: For the *dimension equation* `dim_k H^0(Ω) = dim_k H^1(O)` the geometric-integrality hypothesis is *not* strictly required (Serre duality holds for any smooth proper variety; both sides have equal k-dimension over any field). So the relaxed-Lean signature is *mathematically OK*, and the strategy's relax-prose plan is fine. BUT: future consumers of `serre_duality_genus` may want the geometric-integrality form for downstream identifications with `genus(C_{k̄})`. Tracking the gap explicitly (rather than dissolving it into prose) preserves that future option.
- **What the current strategy may have rejected**: probably the cost of carrying yet another disclosure paragraph; the strategy is already managing 7 named gaps + 1 budget-deferral.
- **Severity of the omission**: minor — the strategy's plan does not produce an unsound artifact, since the dimension equation is true under the relaxed hypothesis.

### Alternative: Decompose L880 into forward + converse with separate budgets

- **What it looks like**: Split `smooth_iff_locally_free_omega` into `smooth_imp_locally_free_omega` (forward, plausibly 2–3 iters / 100–200 LOC) and `locally_free_omega_imp_smooth` (converse, plausibly 3–6 iters / 200–500 LOC). The forward direction lands quickly and unblocks L897. The converse is the genuine cost-driver.
- **Why it might be cheaper or sounder**: matches the cost structure; lets the planner stage dispatch (forward first → L897 → converse) without one stubborn converse-proof iter-blocking the whole Phase B residual.
- **What the current strategy may have rejected**: unclear — the strategy bundles them; possibly out of "iff-shaped helpers are how the file consumes the result". But you can always reconstruct an iff from a forward + converse pair without changing the consumer.
- **Severity of the omission**: minor — bundling is fine if the converse lands in 2 iters; risky if it stalls.

### Alternative: Plain-language Phase B trim with explicit blueprint-coverage disclosure

- **What it looks like**: trim Phase B to *just* L175 (the helper #1 sub-content), defer L880 + L897 as named gaps parallel to the existing 7, and emit a blueprint-coverage disclosure paragraph that explicitly says "the `Differentials.lean` chapter ships its cotangent-sequence interface but defers the smooth-iff-locally-free-Ω equivalence as a known gap".
- **Why it might be cheaper or sounder**: cuts ~3–6 iters of work that the strategy itself admits is not load-bearing on the protected chain. The aggregate `~6–12 prover iterations` estimate becomes `~3–4`, which is meaningfully tighter.
- **What the current strategy may have rejected**: the iter-112 scope-rationale paragraph explicitly considered scope-trim and rejected it. Reasons (i) and (iii) (blueprint commitment, artifact utility) are sound; reason (ii) (sunk-cost on iter-109 promotion) is the soft spot. A blueprint-coverage disclosure paragraph fully satisfies (i) and (iii).
- **Severity of the omission**: major — the strategy gestures at this option ("the alternative — trim project scope") but conflates it with a more aggressive trim that *would* invalidate the blueprint chapters. A *targeted* L880+L897 trim (disclosure-only, leaving L175 in scope) is a narrower middle option the strategy doesn't enumerate.

## Sunk-cost flags

- `"erase the post-C1 monoidal-X.Modules work that establishes the *correct* sheaf-theoretic LineBundle as the iter-109 promotion delivered"` — Why this is sunk-cost: framing the trim cost as "erasing prior work" double-counts the iter-109 effort as merit; the right merit-frame is "the iter-109 `LineBundle X := (Skeleton X.Modules)ˣ` is correct sheaf theory, *independent* of how it was reached". Recommendation: reframe scope-rationale reason (ii) on the *current* mathematical correctness of the C1 promotion, not on iter-109's effort.

## Prerequisite verification

- `IsLocalizedModule.Away`: VERIFIED (exists, `Mathlib.Algebra.Module.LocalizedModule.Basic`).
- `CategoryTheory.Skeleton`: VERIFIED (exists, `Mathlib.CategoryTheory.Skeletal`).
- `SheafOfModules.pullback`: VERIFIED (exists, `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackContinuous`); monoidal-coherence isos confirmed ABSENT — the iter-109 sister pair is a genuine gap, not a phantom.
- `AlgebraicGeometry.Scheme.Modules.pullback`: VERIFIED (exists, `Mathlib.AlgebraicGeometry.Modules.Sheaf`).
- `AlgebraicGeometry.IsSmooth` / `IsSmoothOfRelativeDimension`: VERIFIED (exist, `Mathlib.AlgebraicGeometry.Morphisms.Smooth`).
- `PresheafOfModules.DifferentialsConstruction.isUniversal'`: VERIFIED (exists, `Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf`).
- `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing_types`: VERIFIED (exists, `Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing`).
- `CommRingCat.KaehlerDifferential`: VERIFIED (exists, `Mathlib.Algebra.Category.ModuleCat.Differentials.Basic`).
- `AlgebraicGeometry.IsGeometricallyIntegral` for schemes: MISSING — searching returned only `AlgebraicGeometry.IsIntegral` (no geometric-integrality predicate at scheme level in b80f227). Strategy's claim is correct.
- Hilbert / Quot schemes: MISSING — no results via leansearch for "Hilbert scheme", "Quot scheme", or representability of these functors. Strategy's claim is correct.
- Serre duality / dualizing sheaf / trace morphism: MISSING — leansearch on "Serre duality coherent sheaf" returned only the `CommRing.Pic` and sheaf-machinery unrelated results, no `serreDuality` / `dualizingSheaf` / `traceMorphism`. Strategy's claim is correct.
- `stalk_tensorObj` for varying-ring R₀ (PresheafOfModules.stalk_tensorObj): MISSING — loogle returned no results. Strategy's claim is correct.

## Must-fix-this-iter

- Route Phase B: CHALLENGE — L880 `smooth_iff_locally_free_omega` effort estimate ("~2–4 iters; heaviest of the three") is under-counted relative to the genuine Hartshorne II.8.15 converse. Planner must either (a) widen the estimate to ~5–10 iters / 400–800 LOC, (b) decompose into forward / converse with separate budgets, or (c) record an explicit rebuttal in `iter/iter-114/plan.md` explaining why the converse will land in ≤4 iters under Mathlib b80f227's `IsStandardSmoothOfRelativeDimension`-based smoothness.
- Alternative "Plain-language Phase B trim with explicit blueprint-coverage disclosure": major — strategy considered + rejected a more aggressive trim, but did not enumerate the narrower L880+L897-only deferral. Planner must either (a) update STRATEGY.md to address this narrower option, or (b) record an explicit rebuttal in `iter/iter-114/plan.md` naming why the L175-only Phase B scope (with L880+L897 deferred as named gaps #8 / #9) is worse than the current ~6–12-iter Phase B plan.
- Sunk-cost reframe: minor — scope-rationale reason (ii) should be reframed on current-correctness merits, not on iter-109 effort-erasure cost. Planner can address inline in STRATEGY.md without a separate rebuttal.

## Overall verdict

A fresh mathematician would substantially approve this strategy. The protected-chain framing (one load-bearing gap `nonempty_jacobianWitness`; six orphan-disclosure gaps; one budget-deferral) is honest, the soundness rule is explicit, and the prerequisite claims hold up to spot-check (`Skeleton`, `IsLocalizedModule.Away`, `SheafOfModules.pullback`, `IsSmoothOfRelativeDimension`, `KaehlerDifferential` all verified present; `IsGeometricallyIntegral`-for-schemes, Hilbert/Quot schemes, Serre duality, and the monoidal-coherence isos of `pullback` all verified absent). The Phase C3 exit policy via `JacobianWitness` is a sound application of the soundness rule (a `sorry`-bodied existence of a classically-true witness). Material concerns are confined to Phase B: the L880 estimate is optimistic (challenge — must widen or decompose), and the iter-112 scope-rationale ought to enumerate a narrower L880+L897-only trim option as a serious alternative. The post-C1 `instIsMonoidal_W` disclosure is correctly load-bearing-flagged. No REJECT verdicts; two CHALLENGEs and one minor sunk-cost reframe.
