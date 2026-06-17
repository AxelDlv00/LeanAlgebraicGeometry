# Strategy Critic Report

## Slug
foundation

## Iteration
001

## Routes audited

The strategy is organized as three phases, audited here as three routes plus a synthetic format route.

### Route: pushPull functor laws (`pushPullMap_comp`)

- **Goal-alignment**: PARTIAL — closing `pushPullMap_comp` only assembles `pushPullFunctor`, which only unblocks `CechNerve`/`CechComplex` being axiom-clean. It is necessary for the *construction* but contributes nothing to the comparison theorem's cohomological content. It is not the goal's bottleneck.
- **Mathematical soundness**: PASS — this is a pure pseudofunctor pentagon. The in-file scaffolding (`rawPushPullMap`, `pushPullMap_eq_raw`, `pushPull_unit_mate`, `pushPull_unit_comp`, `pushforwardComp_hom_app_id`, `pushPull_transport_cancel`) is axiom-clean and the kernel-`whnf` wall is documented as bypassed. The residual is a defeq-not-syntactic `erw` grind, mathematically trivial.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The "rate-limiter, weight effort there" posture prioritizes a definitional puzzle that has consumed ~5 prior iters, not the pole that decides feasibility.
- **Infrastructure-deferral detected**: no
- **Effort honesty**: under-counted — the strategy carries no LOC/iters estimate (the table lacks both columns); the in-file note estimates ~60–100 LOC, which is plausible for the pentagon but unrecorded in STRATEGY.md.
- **Verdict**: SOUND (as a sub-task) — but its *prioritization* is challenged under Route: comparison theorem and the Sunk-cost flags.

### Route: affine acyclicity (`CechAcyclic.affine`)

- **Goal-alignment**: PASS — relative Serre/Čech vanishing on affines (Stacks 02KG) is genuinely required; it is the acyclicity input that any route to the comparison theorem consumes.
- **Mathematical soundness**: PASS — the prime-local contracting-homotopy argument (`h(s)_{i₀…i_p} = s_{i_fix i₀…i_p}`, `f_{i_fix} ∉ 𝔭`) is the standard Stacks 02KG proof.
- **Infrastructure-deferral detected**: no — it is named, scoped to a concrete homotopy, and on the critical path.
- **Effort honesty**: under-counted — "may need explicit Koszul/standard-cover bookkeeping" with no LOC/iter estimate understates building the explicit localisation description of `CechComplex` on affines plus the module-level homotopy from scratch for `Scheme.Modules`. This is a substantial phase, not a one-liner.
- **Verdict**: SOUND — but note its under-exploited synergy with the comparison theorem (see re-decomposition under Alternative routes).

### Route: comparison theorem (`cech_computes_higherDirectImage`)

- **Goal-alignment**: PASS (as stated) — `Nonempty (homology i ≅ higherDirectImage f i F)` is exactly the protected target.
- **Mathematical soundness**: PARTIAL — the *stated* proof route (two spectral sequences: Čech-to-cohomology + Leray, both for `Scheme.Modules`) is sound mathematics but commits to the single heaviest possible infrastructure for a goal that only needs an object-level `Nonempty (… ≅ …)`. The strategy presents spectral sequences as if they were the only route; they are not (see Alternative routes — the acyclic-resolution theorem). Building two spectral sequences for sheaves of modules on schemes is potentially a multi-thousand-LOC undertaking absent from Mathlib.
- **Infrastructure-deferral detected**: yes — see Infrastructure-deferral findings. Both spectral sequences are declared "absent from Mathlib" with no project-side construction plan, no decomposition into sub-phases, and no iter estimate, while the goal provably requires *some* bridge from the Čech complex to `rightDerived`.
- **Effort honesty**: under-counted — labeled "DOMINANT pole" in the table yet given no LOC/iters estimate and no sub-decomposition, while the *Posture* section redirects effort away from it to `pushPullMap_comp`. The dominant pole is the least-scoped phase in the document.
- **Verdict**: CHALLENGE — the planner must (a) decide spectral-sequence vs. acyclic-resolution route and record it, and (b) decompose whichever it picks into concrete sub-phases with estimates, before treating `pushPullMap_comp` as the rate-limiter.

## Format compliance

- **Size**: 46 lines / 3162 bytes — within budget.
- **Headings**: FAIL — actual sections are `## Goal`, `## The construction (Stacks Project, Cohomology of Schemes)`, `## Phases & risks`, `## Posture`. Canonical skeleton requires `## Goal`, `## Phases & estimations`, `## Completed` (optional), `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`. None of `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` is present; `## The construction`, `## Phases & risks`, `## Posture` are non-canonical renames/extras.
- **Per-iter narrative detected**: no — STRATEGY.md itself is clean of iter numbers (the iter-271 narrative lives in the `.lean` file comments, out of scope here).
- **Accumulation detected**: no.
- **Table discipline**: FAIL — `## Phases & risks` table has columns `Phase | Status | Key Mathlib needs | Risks`; canonical requires `Phase | Status | Iters left | LOC | Key Mathlib needs | Risks`. The two missing columns (`Iters left`, `LOC`) are exactly the ones that would have exposed the comparison theorem's unestimated scope.
- **Format verdict**: NON-COMPLIANT

## Infrastructure-deferral findings

### Deferred: Čech-to-cohomology spectral sequence + Leray spectral sequence for `Scheme.Modules`

- **Required by goal**: partially — *some* bridge from `(CechComplex …).homology i` to `((pushforward f).rightDerived i).obj F` is required by the goal; the *two-spectral-sequence* realization specifically is not — a lighter bridge exists (acyclic resolutions). So the spectral sequences are required-as-currently-routed, not required-in-principle.
- **Current plan for building it**: none — "absent from Mathlib," with no project-side construction, no sub-decomposition, no timeline. The strategy describes a huge phase and is reluctant to start it (textbook deferral-by-non-decomposition).
- **Timeline**: absent.
- **Verdict**: CHALLENGE — the planner must either commit to the acyclic-resolution route (which avoids both spectral sequences) or decompose the spectral-sequence construction into concrete sub-phases with estimates. "Absent from Mathlib" is not a plan.

## Alternative routes (suggested)

### Alternative: acyclic-resolution route to the comparison (avoids BOTH spectral sequences)

- **What it looks like**: The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (where `Cᵖ = ∏ (j_{i₀…i_p})_* (F|_{U_{i₀…i_p}})`) is (i) a resolution of `F`, and (ii) termwise `f_*`-acyclic: `Rᵏ f_* (Cᵖ) = 0` for `k ≥ 1`, because each intersection is affine and `f ∘ j` pushes a quasi-coherent sheaf with no higher direct images (the relative form of `CechAcyclic.affine`). Then the abstract homological-algebra theorem "a resolution by `F`-acyclic objects computes the right-derived functor" gives `Rⁱf_* F ≅ Hⁱ(f_* C•) = Hⁱ(CechComplex)` directly — one comparison lemma, no spectral sequences.
- **Why it might be cheaper or sounder**: It replaces *two* spectral sequences for `Scheme.Modules` (huge, entirely absent) with *one* abstract lemma about `Functor.rightDerived` (provable by dimension-shifting / the injective-resolution comparison `InjectiveResolution.isoRightDerivedObj`, which Mathlib already has). Crucially it shares infrastructure with Route 2: the termwise-acyclicity input is the relative version of `CechAcyclic.affine`, so the affine-acyclicity phase feeds the comparison phase instead of the two being independent. This is the re-decomposition that removes a blocker (the Čech-to-cohomology SS) and merges work. It is also the standard textbook proof of "Čech computes derived cohomology" (Cartan/Leray acyclic-cover theorem), so it is the *default* route a fresh mathematician would take for the existence statement.
- **What the current strategy may have rejected**: unclear — the strategy never mentions it. Concern #1 in the directive raises exactly this; the strategy does not engage with it, which is the omission.
- **Severity of the omission**: critical — it potentially changes feasibility of the entire dominant pole.

## Sunk-cost flags

- `The composition law pushPullMap_comp is the rate-limiter; weight effort there.` — Why this is sunk-cost: `pushPullMap_comp` is a definitional-coherence puzzle that has stalled ~5 prior iters; finishing it unblocks only `CechNerve`/`CechComplex`, not the protected target, whose feasibility is gated on the unscoped comparison-theorem infrastructure. Recommendation: reframe the rate-limiter as the comparison theorem's homological bridge (decide spectral-sequence vs. acyclic-resolution and scope it) and de-risk *that* first; `pushPullMap_comp` is a parallelizable side-task, not the pole.

## Prerequisite verification

- `CategoryTheory.Functor.rightDerived`: VERIFIED (injective-resolution-based; the RHS `higherDirectImage` consumes it under `[HasInjectiveResolutions X.Modules]`).
- `CategoryTheory.InjectiveResolution.isoRightDerivedObj`: VERIFIED — exists; computes `rightDerived` from an injective resolution. This is the seed from which the *missing* acyclic-resolution lemma would be proved by dimension-shifting.
- General "`F`-acyclic resolution computes `Functor.rightDerived`": MISSING — searched leansearch/loogle; Mathlib has only the injective-resolution comparison, not the acyclic-resolution generalization. The lighter Alternative route must build this single abstract lemma.
- Čech-to-cohomology and Leray spectral sequences for `Scheme.Modules`: MISSING — as the strategy itself states.
- `Scheme.Modules.pseudofunctor_associativity` / `pseudofunctor_right_unitality` / `pullbackComp` / `pushforwardComp` / `unit_conjugateEquiv` / `conjugateEquiv_pullbackComp_inv`: VERIFIED — the file compiles with only three `sorry`s (`CechNerve`, `CechAcyclic.affine`, `cech_computes_higherDirectImage`), and `pushPullMap_id` / `pushPull_unit_mate` close using these names; the `pushPullMap_comp` prerequisites are real, not phantom.

## Must-fix-this-iter

- Route comparison theorem: CHALLENGE — the dominant pole is routed exclusively through two `Scheme.Modules` spectral sequences with no plan/decomposition/estimate. Planner must decide spectral-sequence vs. acyclic-resolution and record the decision, then decompose the chosen route into concrete sub-phases.
- Route comparison theorem: infrastructure-deferral CHALLENGE — the two spectral sequences are required-as-routed but deferred to "absent from Mathlib" with no project-side timeline. Either adopt the acyclic-resolution route (avoids them) or produce a concrete build plan with iter estimates.
- Alternative "acyclic-resolution route": critical omission — the standard, infrastructure-sharing, spectral-sequence-free route to the existence statement is not mentioned; it reuses `InjectiveResolution.isoRightDerivedObj` and folds Route 2's affine acyclicity into the comparison.
- Phantom prerequisite (lighter route): the general "F-acyclic resolution computes rightDerived" lemma is MISSING from Mathlib and must be built if the Alternative is adopted — scope it as a sub-phase.
- Format: NON-COMPLIANT — restructure STRATEGY.md in-place this iter: rename to canonical headings (`## Phases & estimations`, add `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`), and add the missing `Iters left` and `LOC` columns to the phases table (their absence is what hid the comparison theorem's unestimated scope).

## Overall verdict

The construction decomposition (Čech nerve → push-pull functor → affine acyclicity → comparison) is mathematically sound and the three `sorry`s are correctly placed, but the strategy mis-identifies its own bottleneck. **The strategy defers the two spectral sequences for `Scheme.Modules`, which (in some form) are required for the stated goal**, with no project-side construction plan, no decomposition, and no estimate — while the *Posture* redirects effort to `pushPullMap_comp`, a definitional-coherence side-task that unblocks only the construction and has already absorbed ~5 iters. The comparison theorem, labeled "DOMINANT pole" in the very same table, is the least-scoped phase in the document. A fresh mathematician would not reach for two spectral sequences to get a `Nonempty (… ≅ …)`: the standard route is the acyclic-resolution (Cartan/Leray acyclic-cover) theorem, which replaces both spectral sequences with one abstract lemma over `Functor.rightDerived` (buildable from Mathlib's existing `InjectiveResolution.isoRightDerivedObj`) and folds the affine-acyclicity phase in as its acyclicity input — removing a blocker and sharing infrastructure. The planner must de-risk the comparison theorem's homological bridge FIRST (choose and scope spectral-sequence vs. acyclic-resolution), treat `pushPullMap_comp` as a parallelizable side-task rather than the rate-limiter, and restructure the NON-COMPLIANT STRATEGY.md onto the canonical skeleton (which, with the `Iters left`/`LOC` columns restored, would itself have surfaced the unestimated dominant pole).
