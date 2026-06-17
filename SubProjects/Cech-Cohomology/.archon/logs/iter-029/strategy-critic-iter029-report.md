# Strategy Critic Report

## Slug
iter029

## Iteration
029

## Routes audited

### Route A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PARTIAL — the route's cone reaches the frozen target, BUT it routes through `cech_eq_cohomology_of_basis` / `affine_serre_vanishing`, which carry `[EnoughInjectives X.Modules]`, while the frozen target `cech_computes_higherDirectImage` provides only the strictly weaker `[HasInjectiveResolutions X.Modules]`. The connector is real but unnamed (see Must-fix).
- **Mathematical soundness**: PASS — the augmented Čech complex `0→F→C⁰→C¹→…` as an `(pushforward f)`-acyclic resolution, fed to the P4 Leray lemma, is the standard one-abstract-lemma route; matches Stacks `lemma-relative-affine-vanishing` (coherent.tex L180–199) + Leray 015E.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no (the hard inputs — affine Serre vanishing, termwise acyclicity — are each on an active lane with a concrete decomposition, not deferred to "upstream").
- **Phantom prerequisites**: none newly identified; the P4 lemma `rightDerivedIsoOfAcyclicResolution` is stated and axiom-clean per Completed.
- **Effort honesty**: reasonable for the comparison assembly itself; the acyclicity inputs (P5a/P5b) are the real cost and are separately rowed.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND (conditional on naming the EnoughInjectives connector — tracked under Route A's CHALLENGE below).

### Route: 02KG affine instantiation (the affine `BasisCovSystem`)

- **Goal-alignment**: PASS — the decomposition mirrors the Stacks proof of `lemma-quasi-coherent-affine-cohomology-zero` (coherent.tex L157–174) verbatim: apply 01EO with B = affine opens, Cov = standard covers, discharge (1) ∩-of-standard-opens-is-standard, (2) cofinality (`schemes-lemma-standard-open`), (3) standard-cover Čech vanishing = P3's `lemma-cech-cohomology-quasi-coherent-trivial` (coherent.tex L44–135). The source proof IS this 3-condition discharge. The decomposition is faithful.
- **Mathematical soundness**: PASS — non-circular: P3 produces standard-cover Čech vanishing; the 01EO dimension-shift lifts it to affine sheaf vanishing without ever assuming affine vanishing. Confirmed against source.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — but see the tilde-globalisation note under Effort honesty; it is named as DUE this lane, not deferred.
- **Phantom prerequisites**: the qcoh→tilde reduction `F|_U ≅ ~(Γ(U,F))` (01I8 globalisation of 01HV). This is genuinely needed for condition (3) at arbitrary qcoh `F` (P3 proved (3) only for `~M`), exactly as the Stacks proof writes "Write `F|_U = ~M`" (coherent.tex L58). Mathlib coverage of the qcoh↔module equivalence on `Spec` is partial; this is the single least-certain prerequisite in the lane. Not phantom, but not free.
- **Effort honesty**: under-counted risk — the `~200–400 LOC` for 02KG bundles faces_mem + the `CovDatum`↔`X.OpenCover` cover-representation bridge + the tilde globalisation. The tilde globalisation alone could consume most of that budget; the cover bridge is fiddly plumbing. Flag as optimistic, not unsound.
- **Parallelism under-exploited**: minor — faces_mem, the cover bridge, and the tilde globalisation are largely independent obligations and could be dispatched in parallel rather than serialized into one 02KG lane.
- **Verdict**: SOUND.

### Route: Absolute cohomology realization — Ext of the corepresenting object (Form B)

- **Goal-alignment**: PASS — `H^p(U,F) := Ext^p(jShriekOU U, F)` with `jShriekOU U = sheafify(free(yoneda U))` keeps the SES in `X.Modules`, giving off-the-shelf injective-vanishing + covariant LES at fixed first argument. This is what 01EO consumes; H⁰≅Γ is shipped.
- **Mathematical soundness**: PASS — corepresentability chain is sound; Form B correctly avoids the `j_!` restriction-preserves-injectives obstruction (200–500 LOC) by putting the injective in the second Ext argument.
- **Sunk-cost reasoning detected**: no — the choice is justified on merits (the discarded Form A / `rightDerived` / `Sheaf.H` alternatives are each given a concrete technical reason).
- **Phantom prerequisites**: the P5a last-mile `Hᵏ((f_*I^•)(V)) = Ext^k(jShriek(f⁻¹V), G)` (Ext computed by an injective resolution of the 2nd arg). Named as an open question, due when P5a consumers dispatch. Mathlib's `Abelian.Ext` is derived-category based; the "Ext = injective-resolution cohomology of 2nd arg" comparison is the load-bearing unverified lemma here. Flag to verify before P5a assembly.
- **Effort honesty**: reasonable for the shipped corepresentability piece; the P5a Ext-comparison bridge is the uncosted residual.
- **Verdict**: SOUND.

### Route B — two spectral sequences (REJECTED)

- **Verdict**: SOUND (as a rejection) — correctly rejected; both spectral sequences are absent from Mathlib and rest on the same `injective_cech_acyclic` brick as A, so rejecting B escapes nothing. Retaining it as a 3-line "fallback only" pointer is borderline accumulation (see Format).

## Format compliance

- **Size**: ~120 lines (STRATEGY.md core, Goal→Mathlib gaps) / well under budget — within budget (the appended References index / Blueprint chapters / "Question for you" are directive scaffolding, not STRATEGY.md).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in exact canonical order; `## Completed` correctly between Phases and Routes.
- **Per-iter narrative detected**: no — `## Completed` uses the allowed ledger form (`022 · ~14`); no "this iter / last iter" prose in any active section.
- **Accumulation detected**: yes (minor) — the REJECTED Route B still occupies a `## Routes` subsection, and `### The acyclicity bridge` + `### Absolute cohomology realization` are design-narrative subsections beyond the Route A/B routes proper. Tolerable but trending toward bloat.
- **Table discipline**: FAIL (drift, not structural) — several `Risks` cells in `## Phases & estimations` (the 02KG and P5a rows) and several `## Completed` cells run multi-sentence, violating "one short line per cell".
- **Format verdict**: DRIFTED

## Must-fix-this-iter

- **Route A: CHALLENGE** — the frozen target `cech_computes_higherDirectImage` provides `[HasInjectiveResolutions X.Modules]`, but its cone (`cech_eq_cohomology_of_basis`, `absoluteCohomology_eq_zero_of_basis`, `affine_serre_vanishing`) requires the strictly stronger `[EnoughInjectives X.Modules]`. The strategy carries EnoughInjectives "as an explicit hypothesis because the instance is genuinely absent in Mathlib" but NEVER names how the final assembly discharges it from the weaker frozen hypothesis. The connector `HasInjectiveResolutions C → EnoughInjectives C` is TRUE and I verified it compiles in ~6 lines (extract the degree-0 mono into the injective `I.cocomplex.X 0` via Mathlib's `CategoryTheory.InjectiveResolution.instMonoFNatι`). The planner must record this bridge as an explicit obligation in the cone of the protected target. Good news: this RESOLVES the strategy's recurring anxiety — no free `EnoughInjectives X.Modules` instance is needed; it is derived from the frozen hypothesis. But because it is load-bearing for the protected goal, it must be on the books, not left implicit.

- **Route: Absolute cohomology (Form B) — verify before P5a**: confirm Mathlib supports "Ext^k(A,−) computed by an injective resolution of the second argument" for `Abelian.Ext` over `X.Modules` (the P5a last-mile `Hᵏ((f_*I^•)(V)) = Ext^k(...)`). If absent, this is a new project-side lemma that should be rowed, not treated as off-the-shelf.

## Overall verdict

The strategy is structurally sound and the 02KG decomposition is a faithful, non-circular transcription of the Stacks proof of `lemma-quasi-coherent-affine-cohomology-zero` (verified line-by-line against coherent.tex L157–174 and the 01EO three-condition criterion in cohomology.tex L1696–1714). 01EO completion and the P3/P3b bridge bricks genuinely break the affine-vanishing circular regress. The one material gap is a goal-alignment one the strategy does not acknowledge: **the strategy carries `[EnoughInjectives X.Modules]` on every downstream lemma, but the frozen protected target provides only `[HasInjectiveResolutions X.Modules]`**, and the strategy names no connector — so as written, the final assembly cannot type-check. The connector exists and is a ~6-line lemma I verified compiles, so this is a CHALLENGE (record the obligation), not a REJECT. Secondary risks: the qcoh→tilde globalisation `F≅~(ΓF)` and the cover-representation bridge are honestly named but likely under-budgeted within the single 02KG lane and are independent enough to parallelize; the P5a Ext-by-injective-resolution comparison is named but its Mathlib backing is unverified and should be confirmed before P5b assembly. Format is DRIFTED (long table cells, retained REJECTED route) — a light in-place trim, not a restructure.
