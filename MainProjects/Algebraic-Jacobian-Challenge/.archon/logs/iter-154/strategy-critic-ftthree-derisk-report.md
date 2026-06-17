# Strategy Critic Report

## Slug
ftthree-derisk

## Iteration
154

## Routes audited

### Route: C (M2 critical path) — chart-algebra piece (ii), over `[IsAlgClosed k̄]`

- **Goal-alignment**: PASS — the pointed-ℙ¹ rigidity is the load-bearing genus-0 universal property, and the protected signature carries no `C(k) ≠ ∅`; vacuity on the `∀ P` field for unpointed `C` is correctly reasoned (no `k`-points ⟹ vacuous), object `J` is real on both arms.
- **Mathematical soundness**: PASS — the single-element KDM route is sound step-by-step: `b ∉ range(k→B)` + `[IsAlgClosed k]` ⟹ `b` transcendental (contrapositive of "algebraic ⟹ in range"); transcendental ⟹ `RatFunc k ↪ K`; `FormallySmooth (RatFunc k) K` ⟹ `Subsingleton H1Cotangent` ⟹ `mapBaseChange` injective via `exact_δ_mapBaseChange` ⟹ `D_{RatFunc k}` vanishing contradicts the polynomial base case. This is the standard André–Quillen/cotangent base-change argument and it is internally consistent.
- **Sunk-cost reasoning detected**: no — this iter's edit *overturns* a prior "research-grade gap" verdict and discards dead `_mvPoly_*` scaffold; that is anti-sunk-cost. (Minor smell only: the four descoped over-`k` (S3.*) lemmas are retained "as future Mathlib-PR fodder" — see Sunk-cost flags.)
- **Phantom prerequisites**: none at the existence level — all five load-bearing names verified (see Prerequisite verification). BUT two *implicit* sub-obligations of `of_perfectField` are not named in the strategy: `[Algebra.EssFiniteType (RatFunc k) K]` and `[PerfectField (RatFunc k)]`. `of_perfectField` is an *instance* requiring `EssFiniteType`; the strategy lists it as `[verified]` without disclosing that establishing `EssFiniteType (RatFunc k) (Frac B)` is itself a project obligation. This is the single most likely place the assembly stalls.
- **Effort honesty**: reasonable, mildly optimistic — `1–2 iters / ≈100–150 LOC` for a 7-step assembly (localization push via `isLocalizedModule_map`; `IsDomain (Frac B)`; the `k → RatFunc k → K` scalar tower; `EssFiniteType` instance; `mapBaseChange`-injectivity ↔ `D`-transfer identification; transcendental↔embedding; algebraic↔in-range) is plausible given the skeleton compiles, but I would not be surprised by a spill to ~200 LOC and a third iter once instance plumbing is real. The strategy's own "residual risk = scalar-tower/instance plumbing" hedge is honest.
- **Verdict**: SOUND — proceed, but add the `EssFiniteType`/`PerfectField` sub-obligations to the gaps list so the prover doesn't discover them mid-assembly.

### Route: A (M3 off-critical-path) — Picard scheme via FGA

- **Goal-alignment**: PASS — `Pic⁰` supplies the real dim-`g` abelian-variety object unconditionally (required even when `C(k)=∅`), which the protected signature demands.
- **Mathematical soundness**: PASS — Nitsure Quot/Hilbert → Kleiman `th:main` → identity-component structure → `ex:jac` is the canonical FGA chain; the irreducibility of the Quot/Hilbert engine is correctly identified as the cost floor.
- **Effort honesty**: reasonable for an off-critical-path placeholder — `~5100 LOC / 40–70 iters` (~73–127 LOC/it) is internally consistent and explicitly the largest sub-project; not on the critical path, so precision is not yet required.
- **Verdict**: SOUND.

### Route: genusZeroWitness body + `k̄→k` descent (gated phase, not a committed "Route" but carries a load-bearing new obligation)

- **Mathematical soundness**: PARTIAL — the **NEW faithfully-flat descent of morphism equality** along `Spec k̄ → Spec k` is described inconsistently in two places (see Must-fix). It is simultaneously called "a two-line consequence of `Flat.epi_of_flat_of_surjective` [verified] (cheaper than the gap it replaced)" (Route C section) and "(NEW) gap … assess against Mathlib's scheme descent API when `genusZeroWitness` activates" (gaps section). It cannot be both verified-two-line and unassessed. Additionally: `epi_of_flat_of_surjective` yields that the *cover* is an epimorphism (right-cancellation, `f∘p = g∘p ⟹ f = g`), whereas descending an *equality of base-changed maps* `f_{k̄} = g_{k̄} ⟹ f = g` is a faithful-descent/injectivity-of-restriction statement; the reduction from one to the other (via the projection square) is exactly the unassessed step, not obviously two lines. This phase is 3–5 iters out so it does not block iter-154, but the inconsistency should be reconciled now while it is cheap.
- **Verdict**: CHALLENGE — reconcile the two descriptions and confirm the epi→equality-descent reduction before the phase activates.

## Format compliance

- **Size**: 199 lines / 12919 bytes — **over byte budget** (~12 KB / 12288 B; 12.6 KB actual). Line count within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive. 10 `iter-NNN` tokens (iter-149/150/151/153 ×1 each, iter-154 ×6) plus range phrases. Representative: "**De-risked iter-154**: the iter-149–153 'FT.3 = research-grade Mathlib gap' read is OVERTURNED"; "**Bright-line lifted (iter-154).** The iter-151–153 bright-line … has served its purpose: the iter-154 analogist consult ran"; "the iter-150 'subsingleton H¹ ⟹ Γ ≅ k' reformulation that was DISCARDED". This is precisely the history-tracking the skeleton forbids; it belongs in `iter/iter-154/plan.md`.
- **Accumulation detected**: yes (minor) — `constants_integral_over_base_field` is described as CLOSED/collapsed yet retains a full paragraph in both the Phases Status cell and the Route C body, despite the stated policy "STRATEGY.md tracks only remaining work."
- **Table discipline**: FAIL (minor) — the LOC column header is bare `LOC`, not `LOC (remaining · realized/it)`; no row carries a realized-per-iter velocity figure, and row 1's LOC cell holds prose ("≈100–150 · KDM closes the file") rather than `remaining · velocity`. No arithmetic impossibilities between `Iters left` and LOC.
- **Format verdict**: DRIFTED — core skeleton (headings + table) intact, but the per-iter narrative is saturating enough, and the byte budget breached, that this is a must-fix cleanup this iter, not a cosmetic deferral.

## Sunk-cost flags

- "the four general-over-`k` (S3.sep.1/2)+(S3.pi.1/2) lemmas in `ChartAlgebraS3.lean` … survive as valid off-path scaffolds / future Mathlib-PR fodder, not blocking" — Why this is sunk-cost: retaining descoped, off-critical-path code justified by *potential future* upstream use rather than current need is a mild keep-because-we-wrote-it smell. Recommendation: decide on its merits — if no committed downstream consumer exists, mark `ChartAlgebraS3.lean` orphaned (memory already notes it is orphaned) and stop tracking it in STRATEGY.md; salvage value to a Mathlib PR is an independent, later decision.

## Prerequisite verification

- `Algebra.H1Cotangent.exact_δ_mapBaseChange`: VERIFIED (`Mathlib.RingTheory.Kaehler.JacobiZariski`).
- `Algebra.FormallySmooth.of_perfectField`: VERIFIED (`Mathlib.RingTheory.Smooth.Field`) — **but** is an `instance` requiring `[PerfectField K]` + `[Algebra.EssFiniteType K L]` with both `K,L` fields; the strategy under-states these.
- `KaehlerDifferential.polynomialEquiv_D`: VERIFIED (`Mathlib.RingTheory.Kaehler.Polynomial`).
- `Module.FaithfullyFlat.one_tmul_eq_zero_iff`: VERIFIED (`Mathlib.RingTheory.Flat.FaithfullyFlat.Basic`).
- `IsAlgClosed.algebraMap_bijective_of_isIntegral`: VERIFIED (`Mathlib.FieldTheory.IsAlgClosed.Basic`) — requires `[IsDomain K]` + `[Algebra.IsIntegral k K]`; for `constants` the `IsDomain Γ(X,O_X)` premise rides on `C` integral (fine, but a premise to discharge).
- `Algebra.EssFiniteType (RatFunc k) (Frac B)`: NOT NAMED in strategy — required by `of_perfectField`; flag as obligation (see Must-fix).

## Must-fix-this-iter

- Route genusZeroWitness/descent: CHALLENGE — reconcile the contradictory descriptions of the `Spec k̄ → Spec k` morphism-equality descent ("two-line verified consequence" vs "(NEW) gap to assess") and confirm the `epi_of_flat_of_surjective` → equality-descent reduction is actually the right cancellation direction. Pick one characterization in STRATEGY.md.
- Prerequisite: name `Algebra.EssFiniteType (RatFunc k) (Frac B)` and `PerfectField (RatFunc k)` (char-0 perfectness) as project sub-obligations of the KDM assembly; `of_perfectField` does not apply without them. This is the most likely stall point for the "1–2 iter" estimate.
- Format: DRIFTED — strip the ~10 `iter-NNN` narrative tokens (iter-149/150/151/153/154) to `iter/iter-154/plan.md`; trim the file back under 12 KB; add the `realized/it` velocity to the LOC column (or revert the header to bare-LOC and accept the minor discipline gap consciously). Move the closed-`constants` paragraph to a sidecar, leaving only the remaining-work pointer.

## Overall verdict

A fresh mathematician would approve the strategy's **content**: the de-risk is well-grounded — all five load-bearing Mathlib names verify at the existence level, the single-element/`H1Cotangent` KDM route is a recognized and sound argument, the pointed-vs-unpointed spine is correctly goal-aligned (object real on both arms, vacuity only on `∀P`), and the iter-154 edit is healthily anti-sunk-cost (it overturns a prior verdict and discards dead scaffold rather than defending it). Three material concerns must be addressed before the iter closes: (1) the `of_perfectField` route has an undisclosed `EssFiniteType (RatFunc k) (Frac B)` sub-obligation that is the realistic threat to the "1–2 iter" estimate, so the estimate is mildly optimistic and the prerequisite list is incomplete; (2) the new `k̄→k` descent obligation is described two contradictory ways and the cited lemma gives the wrong cancellation direction for descending an equality — reconcile now while the phase is still gated; (3) the document has DRIFTED — pervasive `iter-NNN` narrative and a 12.6 KB size breach that must be cleaned in place. None rise to REJECT; the strategy is SOUND with the above CHALLENGEs.
