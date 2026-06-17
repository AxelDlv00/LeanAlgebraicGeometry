# Strategy Critic Report

## Slug

iter115

## Iteration

115

## Routes audited

### Route: Phase A — Čech acyclicity (`BasicOpenCech.lean`)

- **Goal-alignment**: PASS — closed-out for autonomous-loop scope via Option (i) `DEFERRED (budget)` annotation on L1846; L1120 PAUSED. The route's deferral is consistent with the unconditional-core / framework-conditional split.
- **Mathematical soundness**: PASS — the deferral is labelled `DEFERRED (budget)`, NOT `MATHLIB GAP`, which is the soundness-correct categorisation (Mathlib b80f227 has `IsLocalizedModule.{Away,pi,prodMap}` + the algebra adapter, verified again this iter in the strategy text).
- **Sunk-cost reasoning detected**: no — the iter-108 escape-valve memo explicitly notes the L1120 PAUSED route "wrapper engineering AND body-level inlining of the same `Pi.lift` compositional approach are both committed to NOT be repeated."
- **Phantom prerequisites**: none — strategy correctly disclaims that L1846 needs `IsLocalizedModule.{Away,pi,prodMap}` + adapter, all present.
- **Effort honesty**: reasonable — the "~30–80 LOC remaining per-substep, conditional on predecessor substep landing" framing is now disambiguated from a global Phase A close-out cost (iter-111 framing precision was applied).
- **Verdict**: SOUND

### Route: Phase B — Cotangent sheaves (`Differentials.lean`)

- **Goal-alignment**: PASS — Phase B lands `Differentials.lean`'s cotangent API that the Picard arc consumes; iter-110 reclassification of `serre_duality_genus` as a named gap + iter-114 L880 decomposition keep the in-loop scope honest.
- **Mathematical soundness**: PARTIAL — the L880-converse description ("rebuilding a standard-smooth chart from a Ω-trivializing chart + flatness + `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`") is mathematically imprecise. `iff_of_isStandardSmooth` requires `[Algebra.IsStandardSmooth R S]` as a *hypothesis*, not a conclusion — it cannot be the closing lemma of the converse direction. The actual converse route in Mathlib goes via `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` (verified, in `Mathlib.RingTheory.Smooth.StandardSmoothOfFree`), which requires (i) `Algebra.FinitePresentation R S`, (ii) `Subsingleton (Algebra.H1Cotangent R S)`, (iii) a basis of Ω whose elements lie in the image of `KaehlerDifferential.D`. The strategy's "flatness" is the wrong hypothesis; what is needed is `H1Cotangent = 0` (formal smoothness / infinitesimal lifting). This is the genuine "deformation-theoretic" content the strategy mentions, but the parallel "flatness +" framing in the same paragraph muddles the picture.
- **Sunk-cost reasoning detected**: no — the iter-114 reframe of reason (ii) on current-correctness merits is genuinely merit-based; the parenthetical "the merit-frame here is current mathematical correctness of the definition — independent of the path the project took to land it" explicitly disclaims path-history.
- **Phantom prerequisites**: minor naming slips, no phantoms.
  - `KaehlerDifferential.isLocalizedModule_map` (iter-115 plan paragraph) — actual Mathlib name is `KaehlerDifferential.isLocalizedModule` (instance) at `Mathlib.RingTheory.Kaehler.TensorProduct`; the helper for module-level transport along `KaehlerDifferential.map` is the instance with that exact same name; the `_map` suffix is incorrect, but the underlying API is present.
  - `AlgebraicGeometry.Modules.tilde` (iter-115 plan paragraph) — actual Mathlib namespace is `ModuleCat.Tilde` in `Mathlib.AlgebraicGeometry.Modules.Tilde`. The infrastructure exists; the namespace path in the strategy is off.
- **Effort honesty**: under-counted on the upper end of the aggregate. Per-component decomposition: L175 (2–3 iters / 100–200 LOC) + L880-forward (2–3 iters / 100–200 LOC) + L897 (1–2 iters / ~50–100 LOC, small) + L880-converse (3–6 iters / 200–500 LOC). Lower bounds sum to 8 iters / 450 LOC; upper bounds sum to 14 iters / 1000 LOC. The aggregate "~5–12 iters / ~250–400 LOC" understates both ends: the 5-iter floor only works if L880-converse fires the named-gap escape AND L897 is near-free; the 400-LOC ceiling is below even the lower-bound sum of the decomposition. A correct aggregate would be **"~5–8 iters / ~250–400 LOC if L880-converse fires the named-gap escape; ~8–14 iters / ~500–1000 LOC if L880-converse is closed in-loop."**
- **Verdict**: CHALLENGE — the aggregate estimate doesn't add up to the decomposition and the converse-direction hypothesis description is imprecise. Tactical issues, not strategic ones, but worth fixing before iter-115's prover lane opens.

### Route: Phase C0 — Monoidal `X.Modules`

- **Goal-alignment**: PASS — load-bearing-post-C1 framing is honestly disclosed; the gap is named in End-state.
- **Mathematical soundness**: PASS — `instIsMonoidal_W` deferral on varying-ring `stalk_tensorObj` is a real Mathlib gap.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none verified.
- **Effort honesty**: reasonable (deferred indefinitely, 0 LOC in-loop).
- **Verdict**: SOUND

### Route: Phase C1 — Refined `LineBundle`

- **Goal-alignment**: PASS — DONE iter-109; reason (ii) reframe (iter-114) on current-correctness merits is genuinely merit-based.
- **Mathematical soundness**: PASS — `LineBundle X := (Skeleton X.Modules)ˣ` is the standard sheaf-theoretic definition assuming the monoidal structure on `X.Modules` is the right one; the dependence on `instIsMonoidal_W` is disclosed as load-bearing.
- **Sunk-cost reasoning detected**: no — the iter-114 reframe explicitly substituted current-correctness framing for the prior iter-109-effort framing.
- **Phantom prerequisites**: `BraidedCategory (X.Modules)` chain inherited from `instIsMonoidal_W`; the iter-108 minor finding on `MonoidalCategory.Invertible` is now moot because the C1 body uses skeleton-units, not an `Invertible` typeclass.
- **Effort honesty**: reasonable (DONE; 0 LOC remaining).
- **Verdict**: SOUND

### Route: Phase C2 — `PicardFunctor` re-derivation

- **Goal-alignment**: PASS — the verification round (iter-111+ cheap intel) keeps the route honest.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none verified.
- **Effort honesty**: reasonable (~0–80 LOC, likely 0 after verification).
- **Verdict**: SOUND

### Route: Phase C3 — Representability / `JacobianWitness` (DEFERRED via exit policy)

- **Goal-alignment**: PASS — the JacobianWitness exit policy delivers the 9 protected declarations conditional on a single named `Nonempty` witness sorry; downstream consumers (`Jacobian`, `ofCurve`, four instances, `AbelJacobi.*`) carry typed-correct content that consumes `Nonempty (JacobianWitness C)`. The protected-chain promise is honoured up to the named witness gap.
- **Mathematical soundness**: PASS — the exit policy is soundness-rule-compliant (inline sorry at the use site; downstream signatures consume `Nonempty`).
- **Sunk-cost reasoning detected**: no — the iter-107 exit policy was a strategy-critic-driven RECT, not a sunk-cost continuation.
- **Phantom prerequisites**: confirmed absent from Mathlib (Hilbert/Quot schemes; finite-group quotients), correctly disclosed.
- **Effort honesty**: reasonable (deferred indefinitely; no in-loop budget).
- **Verdict**: SOUND

### Route: Phases D, E — `genus`/`Jacobian`/instances + Abel–Jacobi

- **Goal-alignment**: PASS — content-blocked-on-C3, file-level closure.
- **Mathematical soundness**: PASS — the protected declarations consume the `JacobianWitness` witness correctly.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable (0 LOC in-loop).
- **Verdict**: SOUND

## Alternative routes (suggested)

### Alternative: L880-converse via `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` (explicit) rather than the imprecise "flatness + `iff_of_isStandardSmooth`" route

- **What it looks like**: instead of the strategy's vaguely-described "rebuilding a standard-smooth chart from a Ω-trivializing chart + flatness + `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`" path, name the actual closing lemma `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` and enumerate its hypotheses verbatim: (i) `Algebra.FinitePresentation R S`, (ii) `Subsingleton (Algebra.H1Cotangent R S)`, (iii) a basis whose elements are in `Set.range (KaehlerDifferential.D R S)`. The genuine hard step is (ii) (formal smoothness / cotangent-cohomology vanishing); (iii) follows from a choice of generators differentiating to a basis. Once `IsStandardSmooth` lands, `iff_of_isStandardSmooth` gives `IsStandardSmoothOfRelativeDimension n` from `rank Ω = n`.
- **Why it might be cheaper or sounder**: the proof-DAG becomes explicit, and the (ii) sub-step's heaviness is exposed for honest budgeting. The strategy's "flatness" wording would otherwise lead the iter-115+ prover to try flatness-based reasoning that does not close the gap, churn 1–2 iters before discovering the missing `H1Cotangent` ingredient, and then need a re-plan. Naming the right lemma now saves that round-trip.
- **What the current strategy may have rejected**: nothing — the strategy mentions `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` and "deformation-theoretic lifting" but doesn't connect them via the actual closing lemma name. Likely an authorial oversight in the iter-114 effort-decomposition paragraph.
- **Severity of the omission**: minor — the route exists in the strategy's text in pieces; it just needs to be assembled correctly.

### Alternative: collapse the dual-condition narrower-trim trigger to a single "L880-converse stuck" signal

- **What it looks like**: the current trigger is "iter-115+ CHURNING on L880-converse for 2+ iters". Given that L880-converse is dispatched *last* in the Phase B order (after L175, L880-forward, L897), a single PARTIAL + a single PAUSED would be a stronger signal than two CHURNING iters (CHURNING needs progress-critic verdicts on consecutive iters; PARTIAL + PAUSED is the actual escape pattern fired on L1846 in iter-108 / L1120 in iter-106).
- **Why it might be cheaper or sounder**: the 2-iter CHURNING criterion risks producing two consecutive STUCK-or-PARTIAL iters with no progress, parallel to the L1120 pre-pause situation. Tightening to "one PARTIAL + one PAUSED" or "one STUCK verdict" fires the escape one iter earlier and saves budget.
- **What the current strategy may have rejected**: unclear — the iter-114 reframe just picked 2 iters of CHURNING without explicit justification.
- **Severity of the omission**: minor — the 2-iter criterion is acceptable; tightening would just be marginally cheaper.

### Alternative: declare the L880-converse direction a named gap up-front (skip the escape-valve dance entirely)

- **What it looks like**: the strategy's "decomposed `smooth_imp_locally_free_omega` / `locally_free_omega_imp_smooth` pair" already opens the door to declaring `locally_free_omega_imp_smooth` (the converse) as named gap #8 (Mathlib-gap: no `Algebra.IsStandardSmoothOfRelativeDimension.of_free_kaehlerDifferential` reverse direction in Mathlib b80f227) up-front, in this iter's plan, rather than holding it as a contingent option triggered by future churn. The forward direction + L897 corollary still land; the iff-form helper is sorry-stubbed in the soundness-compliant pattern (explicit forward + named-converse sorry).
- **Why it might be cheaper or sounder**: avoids 2+ wasted iters of churn on a direction the strategy's own narrative tags as "Hartshorne II.8.15 converse; requires either deformation-theoretic lifting or rebuilding a standard-smooth chart". The deformation-theoretic content (Subsingleton `H1Cotangent`) is genuinely heavy and the strategy correctly notes this; firing the named-gap declaration now is a strictly-tighter, equally-honest disclosure.
- **What the current strategy may have rejected**: iter-114 sunk-cost reframe rejected the broader L880-omission trim on the basis that the forward direction is tractable and produces concrete content. This narrower variant agrees with the iter-114 frame on the forward direction; it only differs on whether the converse needs to attempt-first-then-defer or just-defer.
- **Severity of the omission**: minor — the strategy already has the escape-valve; firing it up-front is a budget-efficiency choice the planner can make explicitly.

## Sunk-cost flags

None detected this iter. The iter-114 reframe of reason (ii) on `LineBundle X := (Skeleton X.Modules)ˣ` is genuinely merit-based — the parenthetical "the merit-frame here is current mathematical correctness of the definition — independent of the path the project took to land it" explicitly disclaims path-history.

## Prerequisite verification

- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`: VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`).
- `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`: VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`).
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`, instance).
- `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`: VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`). This is the genuine closing lemma for the L880-converse direction, and the strategy should name it explicitly (see Alternative above).
- `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`: VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`).
- `KaehlerDifferential.isLocalizedModule`: VERIFIED (`Mathlib.RingTheory.Kaehler.TensorProduct`, instance). Strategy uses the name `KaehlerDifferential.isLocalizedModule_map` — RENAMED (the `_map` suffix is wrong; the API is the instance with the base name).
- `KaehlerDifferential.isLocalizedModule_of_isLocalizedModule`: VERIFIED (sibling instance).
- `KaehlerDifferential.span_range_derivation`: not spot-checked (uniqueness lemma; standard).
- `ModuleCat.Tilde`: VERIFIED (`Mathlib.AlgebraicGeometry.Modules.Tilde`). Strategy uses `AlgebraicGeometry.Modules.tilde` — RENAMED (the namespace path is `ModuleCat.Tilde`, not `AlgebraicGeometry.Modules.tilde`).
- `TopCat.Presheaf.IsSheaf.isSheafOpensLeCover`: VERIFIED (`Mathlib.Topology.Sheaves.SheafCondition.OpensLeCover`).
- `TopCat.Presheaf.IsSheafOpensLeCover`: VERIFIED (predicate form, same module).
- `IsLocalizedModule.{Away, pi, prodMap}` + `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`: trusted from prior strategy-critic-iter108 verification (not re-checked this iter).

## Must-fix-this-iter

- Route Phase B: CHALLENGE — (a) aggregate "~5–12 iters / ~250–400 LOC" does not add up to the per-component decomposition (lower bound is 8 iters / 450 LOC; upper bound is 14 iters / 1000 LOC). Restate the aggregate as a *conditional* range that says "with L880-converse fired-as-named-gap" vs "with L880-converse in-loop". (b) L880-converse hypothesis description mentions "flatness" where the actual missing ingredient is `Subsingleton (Algebra.H1Cotangent R S)` (formal smoothness / cotangent-cohomology vanishing). The closing lemma is `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` (verified), not `iff_of_isStandardSmooth` (which needs `IsStandardSmooth` as a hypothesis, not a conclusion). Naming the right lemma now prevents 1–2 iters of churn on flatness-based reasoning that would not close.

## Overall verdict

A fresh mathematician would approve the strategy's overall *structure* — the JacobianWitness exit policy, the unconditional-core / framework-conditional split, the load-bearing-vs-orphan named-gap accounting, and the iter-114 L880 forward/converse decomposition are all sound and honestly disclosed. The single concrete blocker is Phase B's tactical execution detail: the aggregate estimate doesn't add up to its decomposition, and the L880-converse hypothesis description names the wrong closing lemma. Both are tactical, both are CHALLENGE-grade (not REJECT), and both are addressable by a few lines of STRATEGY.md edit before opening the iter-115 L175 prover lane. The iter-114 sunk-cost reframe of reason (ii) is genuinely merit-based and resolves the iter-114 challenge cleanly. No new strategic-level concerns surfaced this iter.
