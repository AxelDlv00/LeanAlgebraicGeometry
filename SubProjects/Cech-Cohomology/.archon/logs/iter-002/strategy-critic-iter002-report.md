# Strategy Critic Report

## Slug
iter002

## Iteration
002

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — `Hⁱ(f_* C•) ≅ (pushforward f).rightDerived i F` is exactly the `Nonempty (… ≅ …)` weak-existence RHS; the Čech complex is the LHS. No gap between route end-state and the frozen goal.
- **Mathematical soundness**: PASS — this is literally Stacks 015E (Leray's acyclicity) folded with affine Serre vanishing (02KG/02KE). The three Mathlib anchors all exist and have the right shape: `InjectiveResolution.isoRightDerivedObj` (any injective resolution computes `rightDerived n`), `isZero_rightDerived_obj_injective_succ` (injectives are `G`-acyclic), `rightDerivedZeroIsoSelf` (degree-0 normalisation).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no formal deferral (nothing is punted to "upstream Mathlib" with no project-side plan), BUT see the pivot-renaming concern below under Effort honesty — the P4 "NOT a hand-built LES" framing understates a shared hard core.
- **Phantom prerequisites**: none. Every named lemma verified present.
- **Effort honesty**: under-counted in two places (P4 framing, P5 bundling) — detailed below.
- **Parallelism under-exploited**: no — P3 and P4 are correctly marked parallel; P1→P2 and P5(needs P2,P3,P4) are genuine dependencies.
- **Verdict**: CHALLENGE

The route is the correct one and will work, but two effort/framing issues must be addressed before scaffolding:

**(1) The P4 "comparison-of-resolutions, NOT a hand-built LES" framing is misleading.** The strategy bolds this as a design decision that *avoids* the missing LES/δ-functor for `Functor.rightDerived`. It does not actually avoid it. To prove the comparison `G(J•) → G(I•)` is a quasi-iso you reduce to the sub-lemma "`G` applied to a bounded-below exact complex of `G`-acyclic objects stays exact," whose proof breaks the complex into syzygy short exact sequences `0 → Zⁿ → Jⁿ → Zⁿ⁺¹ → 0` and propagates `G`-acyclicity + exactness of `0 → GZⁿ → GJⁿ → GZⁿ⁺¹ → 0` across them. That propagation *is* an LES fragment / connecting-homomorphism argument for `rightDerived`. So the "preferred" route and the "fallback (build the δ-functor LES from the horseshoe/snake)" share the same hard core — this is the "pivot renames the problem without solving it" pattern, internal to P4. The planner must either (a) restate P4 honestly as "build the SES-acyclicity-propagation lemma for `rightDerived` (an LES fragment), assembled from Mathlib's `Algebra/Homology/HomologySequence.lean` + horseshoe, then transport via `isoRightDerivedObj`," folding that work into the estimate, or (b) exhibit a concrete Mathlib-grounded path that genuinely needs no connecting map. The good news: Mathlib *does* ship the snake-lemma homology sequence for a SES of homological complexes (`HomologySequence.lean`, `DerivedCategory/HomologySequence.lean`), so the fragment is buildable — but it is real work that the current P4 prose hides.

**(2) P5 bundles substantial geometric infrastructure into a small cell.** P5 is `~2–4` iters / `~100–300` LOC, but its "termwise `(pushforward f)`-acyclicity" input requires *relative affine vanishing* `Rⁱ(affine morphism)_* = 0 (i>0)` and `R�q(jₛ)_* = 0` for affine open immersions into separated `X`, for `Scheme.Modules`. Each is a non-trivial relative-cohomology result absent from Mathlib, plus a Grothendieck-composition / base-change-to-affine-`S` reduction. The "(resolved) reduces cleanly" note in `## Open strategic questions` papers over this. `~100–300` LOC for assembly *plus* two relative-vanishing theorems *plus* the base-change reduction is optimistic; flag P5 LOC/iters as under-counted relative to the geometric content it carries.

### Route: B — two spectral sequences (REJECTED, fallback only)

- **Verdict**: SOUND — the rejection rationale checks out. Mathlib ships only the abstract `Algebra/Homology/SpectralObject/*` and `SpectralSequence/Basic.lean` framework; there is no Grothendieck/Leray spectral sequence assembled, and no Čech-to-derived SS. Building either is multi-thousand-LOC, strictly heavier than Route A's single comparison lemma + affine acyclicity, for the same `Nonempty (… ≅ …)` goal. Keeping it on record as a fallback only is the right call; no action needed.

## Format compliance

- **Size**: STRATEGY.md proper (`## Goal` … `## Mathlib gaps & new material`) ~130 lines — within budget. (`## References index` / `## Blueprint summary` / `## Prior critique status` in the pasted block are the *directive's* framing sections, not STRATEGY.md sections.)
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order. `## Completed` correctly omitted (nothing realized yet).
- **Per-iter narrative detected**: no — references like "blueprint-writer confirmed" are role attributions, not iter history; no "this iter / last iter / iter-NNN pivot" prose inside STRATEGY.md proper.
- **Accumulation detected**: no — no completed phase squatting in the active table, no excised route left in `## Routes`.
- **Table discipline**: PASS — `## Phases & estimations` is a proper table with the canonical columns and one-line cells; `LOC` cells are remaining-LOC ranges, `Status` is inline tags.
- **Format verdict**: COMPLIANT

## Alternative routes (suggested)

### Alternative: Build P4's LES fragment directly from Mathlib's homology sequence

- **What it looks like**: Rather than treating "comparison-of-resolutions" and "hand-built LES" as opposed options, treat the SES-acyclicity-propagation lemma as the single shared primitive and build it from `Algebra/Homology/HomologySequence.lean` (snake-lemma connecting map for a SES of homological complexes) plus the horseshoe lemma to lift a SES of objects to a SES of injective resolutions, then apply `G`. From that one primitive, both the dimension-shift `lem:acyclic_dimension_shift` and the comparison `lem:acyclic_resolution_computes_derived` follow.
- **Why it might be cheaper or sounder**: it stops the strategy from pretending the LES is avoidable and points P4 at the exact Mathlib file that provides the connecting homomorphism, de-risking the "Mathlib has NO LES" worry into "Mathlib has the snake lemma; assemble the `rightDerived` fragment."
- **What the current strategy may have rejected**: unclear — the strategy asserts the LES is absent for `Functor.rightDerived` (true at the `rightDerived n` API level) but does not note that the underlying snake-lemma machinery is present and sufficient.
- **Severity of the omission**: minor

### Alternative: Cross-check Mathlib's `Sites/SheafCohomology/{Cech,MayerVietoris}` before hand-rolling Čech machinery

- **What it looks like**: Mathlib now ships `CategoryTheory/Sites/SheafCohomology/Cech.lean`, `MayerVietoris.lean`, `Basic.lean`. Before building `CechNerve`/`CechComplex` and the affine contracting homotopy entirely from scratch (P2/P3), confirm whether any of that Čech-nerve / Mayer–Vietoris plumbing is reusable for `Scheme.Modules`.
- **Why it might be cheaper or sounder**: could save P2/P3 LOC if the nerve/complex assembly transfers.
- **What the current strategy may have rejected**: likely a genuine mismatch — that machinery is topos sheaf cohomology over a Grothendieck topology, whereas the goal is the *relative* derived pushforward `(pushforward f).rightDerived`; the two framings probably don't compose directly. Worth one explicit check, not a route change.
- **Severity of the omission**: minor

## Must-fix-this-iter

- Route A: CHALLENGE — restate P4 honestly. The "comparison-of-resolutions, NOT a hand-built LES" claim hides that both P4 options need the same SES-acyclicity-propagation (LES) fragment for `rightDerived`; fold that work into P4's estimate (it is buildable from Mathlib's `HomologySequence.lean` + horseshoe) or exhibit a genuinely connecting-map-free path.
- Route A: CHALLENGE — P5 effort under-counted. `~2–4` iters / `~100–300` LOC must absorb relative affine vanishing `Rⁱ(affine)_*=0`, `R�q(jₛ)_*=0` for affine open immersions into separated `X`, AND the base-change-to-affine-`S` reduction — each a substantial `Scheme.Modules` result absent from Mathlib. Re-estimate or split P5.

## Overall verdict

Route A is the right route and is mathematically sound — it is Stacks 015E composed with affine Serre vanishing, every named Mathlib anchor (`isoRightDerivedObj`, `isZero_rightDerived_obj_injective_succ`, `rightDerivedZeroIsoSelf`, plus the P1 mate-calculus lemmas) is verified present, and `rightDerivedFunctorPlus` is correctly *not* relied upon (it is an unimplemented doc-comment). Route A is genuine progress over Route B, not the same infrastructure renamed: Route B needs two spectral sequences that Mathlib has no assembled form of, which is strictly heavier than Route A's single comparison lemma. The two live CHALLENGEs are about honesty, not viability: (1) the P4 "NOT a hand-built LES" framing understates a shared hard core — the comparison-of-resolutions proof still requires an SES-acyclicity-propagation (LES) fragment for `rightDerived`, the same primitive its stated fallback needs, so the planner must own that work in the estimate (Mathlib's `HomologySequence.lean` makes it buildable); and (2) P5's `~100–300` LOC silently bundles relative affine vanishing and affine-open-immersion acyclicity for `Scheme.Modules`, which are real theorems and likely under-counted. No infrastructure-deferral finding rises to REJECT — nothing required by the goal is punted to upstream with no plan — and the document is format-COMPLIANT. Address the two CHALLENGEs in STRATEGY.md (or rebut in plan.md) and the strategy is fit to execute.
