# Strategy Critic Report

## Slug
iter011

## Iteration
011

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — the chain P3 → P3b (`affine_serre_vanishing`) → P5a (termwise acyclicity + augmented-Čech resolution) → P5b (assembly with the done P4 engine) terminates exactly at the frozen `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`. No surface gap.
- **Mathematical soundness**: PASS — the two Route-A inputs hold up under a fresh read. (i) The augmented Čech complex of sheaves is a resolution by elementary stalkwise contractibility (any open cover; the localization machinery is not even needed for this part). (ii) Termwise `(pushforward f)`-acyclicity of `Cᵖ = ∏ (jₛ)_*(F|_{Uₛ})` reduces, via the open-immersion composition `R(f∘jₛ)_* = Rf_* ∘ R(jₛ)_*` and `f` separated ⟹ `Uₛ ∩ f⁻¹V` affine, to `affine_serre_vanishing` on those affine intersections. This is the standard Cartan–Leray acyclic-cover argument and is correctly wired.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — P3b builds the irreducible `injective_cech_acyclic` brick itself (ACTIVE/NEXT with iter+LOC estimates); nothing load-bearing is pushed to "upstream Mathlib" or "future work."
- **Phantom prerequisites**: none. Both named natives verified (see Prerequisite verification).
- **Effort honesty**: under-counted (leaning) — see Effort note below.
- **Parallelism under-exploited**: no — the file-split explicitly carves out the P3/P3b-independent 01XJ leaf (`HigherDirectImagePresheaf.lean`) and a P3b bridge lane as separate parallel prover lanes.
- **Verdict**: SOUND

### Route: B — two spectral sequences (REJECTED, fallback)

- **Verdict**: SOUND — the rejection is well-reasoned and, crucially, honest about *not* escaping the irreducible `injective_cech_acyclic` brick by switching routes. No avoidance dressed as a pivot here.

### Route: The acyclicity bridge (P3b, load-bearing)

- **Goal-alignment**: PASS — yields `affine_serre_vanishing`, the sole geometry-unblocking input.
- **Mathematical soundness**: PASS — the non-circularity is genuine: P3 supplies *standard-cover Čech-complex exactness* (condition (3) of Stacks 01EO), and the 01EO dimension shift lifts it to *sheaf* vanishing using only `injective_cech_acyclic` + `ses_cech_h1`, never feeding affine sheaf vanishing back as a hypothesis. This is the textbook Stacks 01EW/01EO bootstrap; the iter-010 circularity (term-acyclicity from the homotopy alone) is correctly excised.
- **Infrastructure-deferral detected**: no.
- **Verdict**: SOUND

## Format compliance

- **Size**: ~106 lines (STRATEGY.md body, directive lines 19–124) / well under 12 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order. (`## References index` / `## Blueprint summary` / `## Prior critique status` belong to the directive, not the strategy.)
- **Per-iter narrative detected**: yes — `"The irreducible brick the iter-009 plan wrongly denied needing"` (P3b Risks cell) names a specific past iteration in prose. Per-iter history belongs in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: no — completed phases (P1, P2, P4) are correctly in `## Completed`, not the active table; no excised route lingers.
- **Table discipline**: FAIL (minor) — two deviations. (a) Several `Key Mathlib needs` / `Risks` cells run multi-sentence (the rule is "one short line per cell"); the P3 and P3b rows are paragraph-dense. (b) The `Status` column uses ordering phrases with parentheticals (`NEXT (unblocks all geometry)`, `AFTER P3b`, `LAST (needs P3, P3b, P4, P5a)`) rather than short inline status tags (`ACTIVE`/`BLOCKED`/`PAUSED`).
- **Format verdict**: DRIFTED

## Alternative routes (suggested)

### Alternative: derive `PMod(O_X)` enough injectives from Mathlib's Grothendieck-category engine

- **What it looks like**: The strategy lists "`PMod(O_X)` enough injectives" among the P3b items "ALL absent from Mathlib … from-scratch." But Mathlib ships `CategoryTheory/Abelian/GrothendieckCategory/EnoughInjectives.lean` (`instance enoughInjectives : EnoughInjectives C` for any Grothendieck abelian `C`) and `IsGrothendieckAbelian (ModuleCat R)` (`Mathlib/Algebra/Category/ModuleCat/AB.lean`). The missing link is only `IsGrothendieckAbelian (PresheafOfModules …)` — a presheaf category valued in a Grothendieck category over a small site — which is a single instance to establish, not a hand-built injective-enough-ness proof. Once it lands, enough-injectives for `PMod(O_X)` (and indeed `HasInjectiveResolutions X.Modules`, the frozen hypothesis) is `inferInstance`.
- **Why it might be cheaper or sounder**: collapses one of the four from-scratch P3b sub-bricks to a thin instance derivation, materially de-risking the phase.
- **What the current strategy may have rejected**: unclear — the strategy does not mention the Grothendieck-category lever at all, so this reads as an unexamined omission rather than a considered rejection.
- **Severity of the omission**: minor — it lowers P3b cost/risk; it does not change soundness or the route. The genuinely irreducible P3b work (`injective_cech_acyclic`, `ses_cech_h1`, the 01EO shift) remains.

## Prerequisite verification

- `exact_of_isLocalized_span` (`Mathlib/RingTheory/LocalProperties/Exactness.lean:173`): VERIFIED
- `AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop` (`Mathlib/AlgebraicGeometry/Cover/Open.lean:203`): VERIFIED
- Scheme Serre-vanishing / qcoh sheaf cohomology in Mathlib: MISSING (confirmed absent — only étale-adic site cohomology `Sheaf J AddCommGrpCat` exists). The strategy's gap claim is honest.
- `EnoughInjectives (PresheafOfModules …)` direct instance: MISSING — but reachable via `GrothendieckCategory.enoughInjectives` (see Alternative).

## Effort honesty note

P3b is estimated ~4–7 iters / ~300–600 LOC to build, from scratch over ringed-space `O_X`-modules: presheaf-Čech-exact-as-a-functor, enough injectives, `injective_cech_acyclic` (δ-functor universality), `ses_cech_h1`, and the 01EO dimension shift. The completed P4 row shows a *single* abstract acyclic-resolution lemma cost 6 iters / 965 LOC. P3b bundles roughly four distinct from-scratch homological results of comparable difficulty, yet is budgeted below P4's realized LOC. Absent the Grothendieck-category shortcut above, this estimate is optimistic — the planner should treat ~600 LOC / 7 iters as a floor, not a midpoint, or split P3b into named sub-rows so the cost is visible. Not a soundness defect; an estimate-calibration flag.

## Must-fix-this-iter

- Format: DRIFTED — remove the per-iter-narrative phrase `"the iter-009 plan wrongly denied needing"` from the P3b Risks cell (state the claim timelessly, e.g. "the irreducible brick the minimal route cannot avoid"); compress the multi-sentence `Key Mathlib needs`/`Risks` cells to one short line each and reduce `Status` cells to bare tags. In-place edit, cheap.

## Overall verdict

The strategy is mathematically SOUND and goal-aligned. Route A's chain (P3 standard-cover Čech vanishing → P3b non-circular 01EO lift to `affine_serre_vanishing` → P5a termwise acyclicity → P5b assembly on the completed P4 engine) is the standard Cartan–Leray construction, correctly decomposed, with the prior-iter circularity genuinely excised by routing term-acyclicity through the injective-acyclic / dimension-shift bridge rather than the homotopy alone. Both named Mathlib natives (`exact_of_isLocalized_span`, `affineOpenCoverOfSpanRangeEqTop`) are verified, and the claimed gaps (scheme Serre vanishing, `O_X`-module Čech machinery) are honestly absent. There are **no infrastructure-deferral findings**: the irreducible `injective_cech_acyclic` brick is owned and budgeted, not deferred upstream. Two non-blocking items: (1) the strategy overstates the from-scratch burden of `PMod(O_X)` enough-injectives — Mathlib's `GrothendieckCategory.enoughInjectives` + `IsGrothendieckAbelian (ModuleCat R)` reduce it to one instance, an unexploited lever; (2) P3b's effort estimate is optimistic against P4's realized 965 LOC for a single lemma. Format is DRIFTED, not non-compliant: fix the lone iter-009 prose reference and tighten the verbose table cells in place this iter.
