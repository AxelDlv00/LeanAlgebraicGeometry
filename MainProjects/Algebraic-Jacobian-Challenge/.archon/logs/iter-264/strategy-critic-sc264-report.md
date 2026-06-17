# Strategy Critic Report

## Slug
sc264

## Iteration
264

## Routes audited

This audit is organized around the three still-live questions in the directive, each mapped to its
governing route in STRATEGY.md.

### Route: A.2.c-engine — `Rⁱf_*` Čech functor-law de-coupling (Q1)

- **Goal-alignment**: PASS — `Rⁱf_*` (i≥1) is the deepest root of the RR-free representability fork
  (A.2.c discharge), and the goal's `J := Pic⁰` representability cannot be reached without it under
  the chosen RR-free architecture. Building it is on the critical path, not optional.
- **Mathematical soundness**: PASS — the de-coupling is real, not a relabeling. The Čech functor laws
  `pushPullMap_id`/`pushPullMap_comp` are coherences of the **pullback** pseudofunctor
  (`Scheme.Modules.pullback`/`pullbackComp`/`pullbackId`). The project-local Sq1
  (`sheafificationCompPullback_comp`) is a coherence of the **tensor-comparison** iso `f^*(M⊗N)`. These
  are genuinely different constructions: a single-sheaf Čech complex's differentials involve no tensor
  product, so nothing in the functor-law proof can route back through Sq1. No hidden re-coupling at the
  functor-law layer.
- **Phantom prerequisites**: none — the named Mathlib lemmas are VERIFIED (see Prerequisite
  verification). `pseudofunctor_{right,left}_unitality`, `pseudofunctor_associativity`, `pullbackComp`,
  `pullbackId`, and `conjugateEquiv` all exist exactly where the strategy claims.
- **Effort honesty**: reasonable — the row honestly tags the ~85–140 iter figure as "UNDEMONSTRATED
  ~40/it" and the LOC/velocity arithmetic (3400–5500 ÷ 40 ≈ 85–137) is internally consistent.
- **Parallelism under-exploited**: yes (mild) — see Q3 note. The engine being decoupled AND the
  dominant pole means it should receive the **lion's share** of prover lanes, not equal footing with
  the ~15-iter substrate stream.
- **Verdict**: SOUND

### Route: A.1.c.sub — dual route-2 `sliceDualTransport` (Q2)

- **Goal-alignment**: PASS — `exists_tensorObj_inverse` (loc-triv inverse witness) is required to close
  the RPF carrier `IsLocallyTrivial` under group inverse, which the A.1.c.fun `addCommGroup` consumes.
- **Mathematical soundness**: PASS — `dual_restrict_iso` (dual commutes with restriction/pullback) is
  genuinely the single crux. I tested the obvious cheaper alternative (below) and it collapses back to
  the same linchpin, which corroborates rather than refutes the route.
- **Sunk-cost reasoning detected**: no — the justification is on merits ("the dual is the canonical
  inverse construction; the alternative is a fresh `stalkTensorIso`-magnitude build"), not "we've
  already invested N iters." The monolithic-decl-many-iters pattern is a real smell, but the strategy
  itself flags it as a Risk and commits to decomposition, and the sub-holes are closing one per iter
  (leg-A built, leg-B ε-iso closed, remaining = add/smul bridge + invFun) — convergent, not spinning.
- **Effort honesty**: reasonable, with one disclosed wrinkle — the LOC cell `~0/it (monolith metric
  artifact)` is the "~0/it while actively progressing" shape the audit normally flags, but here it is
  explicitly annotated as an artifact with a stated decomposition fix, so it is honest disclosure, not
  concealment.
- **Verdict**: SOUND

### Route: Critical path / bottom-up phase ordering (Q3)

- **Goal-alignment**: PASS — A.1.c.sub → A.1.c.fun → A.2.c is the RR-free spine; representability
  (A.2.c) genuinely precedes the AV structure (A.3) and Albanese UP (A.4), so the USER bottom-up
  constraint (no A.3+ before A.2.c) is also the mathematically correct order.
- **Mathematical soundness**: PASS — the engine sits *inside* A.2.c (the bottom), so front-loading it
  is bottom-up, not a violation. The strategy already commits to running the engine concurrently and
  dispatching the `pushPullMap_id`/`pushPullMap_comp` pass now.
- **Parallelism under-exploited**: yes — see Must-fix. With the engine at ~85–140 iters and the entire
  Picard substrate (A.1.c.sub + A.1.c.fun) at ~15–26 iters, the substrate is NOT the bottleneck; the
  engine is. The strategy treats them as co-equal parallel poles ("runs fully parallel"), but
  throughput-optimal allocation is maximal lanes on the engine and the substrate as a side-stream. This
  is a lane-allocation refinement, not a structural flaw.
- **Verdict**: SOUND

## Format compliance

- **Size**: 150 lines / ~11 KB — within budget (≤250 lines / ≤12 KB).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic
  questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — `"(iter-263 finding)"`, `"refutes the iter-262 coupling
  belief"`, `"DONE axiom-clean (iter-263)"`, `"(iter-263 finding, refutes the iter-262 coupling
  belief)"`. Per-iter history belongs in `iter/iter-NNN/plan.md`; the *content* of the finding (engine
  decoupled from Sq1) belongs in STRATEGY.md, but the `iter-NNN` provenance tags must be stripped.
- **Accumulation detected**: minor — completed sub-items tracked inline (`"D1'/D2'/Sq2/Sq2b/Sq3/Sq4
  CLOSED"`, `"Loc-triv entry DONE"`, `"⊗-group law is DONE"`). Acceptable as status context but trending
  toward a done-log; prune as items leave the active frontier.
- **Table discipline**: FAIL — the A.2.c-engine row carries multi-sentence prose in the Status cell and
  a parenthetical paragraph in the Iters-left cell (`"? (≈85–140 at an UNDEMONSTRATED ~40/it; revise
  once Čech velocity is real)"`). The rule is one short line per cell; long-form findings belong in the
  `## Routes` / `## Open strategic questions` prose, with the cell reduced to a pointer.
- **Format verdict**: DRIFTED

## Must-fix-this-iter

- Format: DRIFTED → resolve in-place this iter. (1) Strip `iter-NNN` provenance tags from STRATEGY.md
  (keep the *finding*, drop the iteration numbers — move provenance to `iter/iter-264/plan.md`). (2)
  Compress the A.2.c-engine table row to one short line per cell; relocate the prose to the engine
  paragraph under `## Routes` or the engine bullet under `## Open strategic questions`.
- Route Q3 / parallelism: the engine is decoupled AND the dominant pole (~85–140 iters vs ~15–26 for
  the whole substrate). Reflect in lane allocation that the engine — not the substrate finish — is the
  rate-limiter, and weight prover dispatch toward it accordingly rather than treating the two as
  co-equal parallel poles.

## Prerequisite verification

- `AlgebraicGeometry.Scheme.Modules.pseudofunctor_right_unitality`: VERIFIED (Mathlib.AlgebraicGeometry.Modules.Sheaf)
- `AlgebraicGeometry.Scheme.Modules.pseudofunctor_left_unitality_assoc`: VERIFIED (same module)
- `AlgebraicGeometry.Scheme.Modules.pseudofunctor_associativity`: VERIFIED (same module)
- `AlgebraicGeometry.Scheme.Modules.pullbackComp` / `pullbackId` / `pullback`: VERIFIED (same module)
- `CategoryTheory.conjugateEquiv` (+ `_id`, `_iso`, `_of_iso`): VERIFIED (Mathlib.CategoryTheory.Adjunction.Mates)
- `conjugateEquiv_pullbackComp_inv`, `conjugateEquiv_pullbackId_hom`: these read as project-local
  composites over the verified `conjugateEquiv` + `pullbackComp`/`pullbackId` machinery, not standalone
  Mathlib names — consistent with the strategy treating them as derivable, not assumed.

## Alternative routes (suggested)

### Alternative: inherit the inverse witness from `picCommGroup`, prove loc-triv via restriction-monoidality

- **What it looks like**: `picCommGroup` (DONE) already yields, for an invertible `M`, an inverse `N`
  with `M⊗N≅𝒪`. Given `M` loc-triv on `{Uᵢ}` with `M|_Uᵢ≅𝒪`, restriction-monoidality gives
  `N|_Uᵢ ≅ (𝒪⊗N)|_Uᵢ ≅ (M⊗N)|_Uᵢ ⊗ (M|_Uᵢ)⁻¹ ≅ 𝒪|_Uᵢ`, so the *existing* witness `N` is loc-triv on
  M's own cover — no dual base-change needed, since `exists_tensorObj_inverse` only demands SOME
  loc-triv inverse (its signature `∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (L⊗Linv≅𝒪)`).
- **Why it might be cheaper or sounder**: it would bypass `sliceDualTransport` entirely.
- **What the current strategy may have rejected**: on inspection the alternative collapses — to feed
  `picCommGroup` you first need `IsLocallyTrivial M ⟹ IsInvertible M` (a global ∃N statement), whose
  canonical construction is `N := M^∨` with `M⊗M^∨≅𝒪` checked locally, i.e. exactly
  `dual_restrict_iso`. The "cheaper" route therefore needs the SAME hard prerequisite. This is a
  *confirming* check, not a refutation: it independently validates the strategy's claim that
  `dual_restrict_iso` is the single linchpin.
- **Severity of the omission**: minor — worth one sentence in `## Open strategic questions` noting that
  the inverse-witness's hard core is `dual_restrict_iso` regardless of which surface route is taken, so
  no cheaper architecture exists to over-invest past.

## Overall verdict

All three live strategic questions are SOUND. Q1's engine de-coupling is the headline and it holds up
under fresh scrutiny: the named pullback-pseudofunctor coherences are real Mathlib lemmas in
`Mathlib.AlgebraicGeometry.Modules.Sheaf`, and they govern a construction (the pullback functor's own
identity/composition) genuinely disjoint from the project-local Sq1 (the tensor-comparison iso), so
running the `Rⁱf_*` Čech lane fully concurrently with the Picard substrate is correct with no hidden
re-coupling. Q2's dual route-2 is not over-investment: I independently verified that the obvious
cheaper alternative (reuse `picCommGroup`'s inverse) reduces to the very same `dual_restrict_iso`
crux, so the linchpin claim is corroborated. Q3's bottom-up ordering is correct, with one refinement —
because the engine is now both decoupled and the dominant ~85–140-iter pole while the entire substrate
is ~15–26 iters, lane allocation should weight the engine as the true rate-limiter rather than as a
co-equal parallel pole. No infrastructure-deferral pattern was found: A.2.c's `⟨sorry⟩` scaffold, the
`Rⁱf_*` build, and the gated A.3/A.4 rows all have concrete in-project plans (or correct gating), not
upstream-Mathlib hand-waves. The one must-fix is format: STRATEGY.md has DRIFTED via `iter-NNN`
provenance tags and multi-sentence prose in the A.2.c-engine table cells — restructure in place this
iter, preserving the findings while moving iteration numbers to the iter sidecar and prose to the
Routes/Open-questions sections.
