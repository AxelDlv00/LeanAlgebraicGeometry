# Strategy Critic Report

## Slug
iter137

## Iteration
137

## Routes audited

### Route: M1 — Bridge: presheaf ↔ algebra-Kähler form on an affine chart (EXCISED iter-126)

- **Goal-alignment**: PASS — Excise was correct: M1 had zero in-tree consumers and the named Mathlib-PR candidate (`kaehler_quotient_localization_iso`) is preserved as a standalone utility off-loop.
- **Mathematical soundness**: PASS — Excise math is a deletion-of-dead-code argument, trivially sound.
- **Sunk-cost reasoning detected**: no — the excise itself was an *anti*-sunk-cost move (iter-126 strategy-critic CHALLENGE on the iter-128 hard trigger was absorbed).
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — closed-decision book-keeping.
- **Verdict**: SOUND.

### Route: M2.a — `rigidity_over_k` (iter-126 scaffold; body iter-151+)

- **Goal-alignment**: PASS — `rigidity_over_k` is the load-bearing input for the `C(k) ≠ ∅` arm of `genusZeroWitness`'s universal-property field; closes the M2.a contribution to the protected `nonempty_jacobianWitness` chain.
- **Mathematical soundness**: PASS — Standard cotangent-vanishing rigidity (df = 0 on a smooth proper geometrically irreducible curve of genus 0 + char-p Frobenius iteration ⇒ factors through `Spec k`). The over-k commitment is verified k-agnostic at the signature level by the iter-127 analogist.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none on the M2.a body alone; the substantive Mathlib gaps live in the pile pieces (i)+(ii)+(iii). Mathlib names cited or implied (e.g. `Scheme.Over.ext_of_eqOnOpen`) are project-internal and audit-clean.
- **Effort honesty**: reasonable (1 iter / 50–150 LOC for body closure once the pile is built).
- **Verdict**: SOUND — body closure gated correctly on the shared pile.

### Route: M2.b — `genusZeroWitness` (iter-127 scaffold; body iter-153+)

- **Goal-alignment**: PASS — Combines (i) `C(k) ≠ ∅` arm via `rigidity_over_k` + (ii) `C(k) = ∅` arm vacuously via the `∀ P, IsAlbanese …` field's emptiness-of-`𝟙_ _ ⟶ C`. Both arms together produce a `JacobianWitness C` with underlying scheme `Spec k`, plugging the genus-0 sub-theorem into the protected chain.
- **Mathematical soundness**: PASS — Vacuity branch is type-theoretically sound (`𝟙_ (Over Spec k) ⟶ C` is exactly the type of `k`-rational points; empty for Brauer–Severi conics over ℚ; the universal `∀ P` quantification is vacuously true on that branch). The non-empty arm reduces cleanly to `rigidity_over_k`.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: the four-instance cluster on `Spec k` (`GrpObj`, `SmoothOfRelativeDimension 0`, `IsProper`, `GeometricallyIrreducible`) is project material; iter-130 progress-critic flagged the under-count, iter-131 strategy honestly re-priced this at 200–500 LOC / 2–3 iter. Mathlib `Algebra.IsStandardSmoothOfRelativeDimension` covers the algebra-side smoothness instance and is verified to exist.
- **Effort honesty**: reasonable (revised iter-130 to 2–4 iter / 320–750 LOC after the iter-130 Q5 under-count was corrected — that correction is itself an honest signal).
- **Verdict**: SOUND.

### Route: M2.body-pile — pieces (i)+(ii)+(iii) over k

- **Goal-alignment**: PASS — pile closure gates M2.a body, which gates M2.b body, which gates the genus-stratified body of `nonempty_jacobianWitness`. The dependency chain is explicit and tight; piece (iv) Serre duality is correctly deferred under the over-k commitment.
- **Mathematical soundness**: PARTIAL — pieces (i.a) (closed iter-132), (i.b) (in-flight iter-134–138), and (i.c) (iter-137+) decompose cleanly. **Concern**: piece (i.c)'s LOC envelope was inflated iter-133 from 100–300 LOC to 200–500 LOC to absorb the **chart-localisation identification** (~100–200 LOC) pushed down from piece (i.b). This pushdown is real (the chart-localisation is the artefact that bridges the canonical sheaf-level RHS of (i.b) to the non-canonical chart-base-changed body the rank lemma needs), but piece (i.c)'s row now bundles three responsibilities — chart-localisation identification, freeness conclusion, and rank pinning — under a single LOC estimate. That's a load-bearing hidden coupling. See CHALLENGE below.
- **Sunk-cost reasoning detected**: no on the pile itself (the iter-130 Q1 strike of ground (i) of the over-k re-defense is a model of honesty); but the over-k commitment defense is now thin enough that the strategy should self-flag this more sharply (see Route below).
- **Phantom prerequisites**: scheme-level absolute Frobenius `AlgebraicGeometry.Scheme.absoluteFrobenius` — VERIFIED MISSING from Mathlib `b80f227` (only ring-side `frobenius` in `Mathlib.Algebra.CharP.Frobenius`, plus unrelated `NumberTheory.FrobeniusNumber`). The strategy correctly tags this as NEEDS_MATHLIB_GAP_FILL at 800–1500 LOC / 4–7 iter. The iter-128 honest revision from the iter-127 300–600 LOC estimate is a good faith correction.
- **Effort honesty**: reasonable — totals 1850–3600 LOC over 9–20 iter; the upper bound is real; iter-133 sequenced watchpoint with LOC trigger on (i.b) at > 600 LOC OR > 2 iter slip protects against silent absorption.
- **Verdict**: CHALLENGE — see § Must-fix-this-iter item 1.

### Route: M3 — `positiveGenusWitness` (iter-134 scaffold; body off-critical-path)

- **Goal-alignment**: PASS — Both Route A (Picard scheme via FGA) and Route B (symmetric powers + Stein) target the Albanese variety, which is precisely the underlying scheme of the witness in genus ≥ 1.
- **Mathematical soundness**: PASS — both routes are standard.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: extensive — Hilbert/Quot representability, identity-component construction, symmetric powers of schemes, Stein factorisation, Brill–Noether–Riemann–Roch. The strategy honestly names all of these and acknowledges both routes exceed the 5000-LOC hard-fallback threshold (Route A ~6500 LOC, Route B ~9000 LOC) per the iter-123 audit.
- **Effort honesty**: reasonable — 100+ iter / 10000+ LOC midpoint; user-escalation has already fired; the user hint absorbed iter-126 is correctly cited as scope-bound to M3.
- **Verdict**: SOUND. (M3 is off the iter-by-iter critical path; the audit recorded the smallest extractable upstream-PR pieces.)

### Route: Genus-stratified body restructure of `nonempty_jacobianWitness`

- **Goal-alignment**: PASS — `by_cases h : genus C = 0` decomposes the protected theorem into the two scaffolds (`genusZeroWitness` + `positiveGenusWitness`). Iter-135 already landed the restructure; both scaffolds have `sorry` bodies but the inline `sorry` at `Jacobian.lean:194` is now honestly delegated.
- **Mathematical soundness**: PASS — `genus C : ℕ` is decidable-equality; the case-split is well-formed.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — the restructure cost is iter-135 (DONE); body closure is iter-157+ gated on M2 + M3.
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: Piece-(i.c) sub-decomposition

- **What it looks like**: Split piece (i.c) explicitly into (i.c.1) chart-localisation identification (~100–200 LOC; the artefact pushed in from (i.b)); (i.c.2) `omega_free` (the freeness conclusion ~50–150 LOC); (i.c.3) `omega_rank_eq_dim` (the rank pinning ~50–150 LOC). Treat each as a separately scaffoldable prover lane with its own blueprint hardening.
- **Why it might be cheaper or sounder**: The current single-row "200–500 LOC" envelope bundles three logically distinct responsibilities under one estimate. If any one of the three sub-pieces blows its budget (the iter-134 LOC-trigger watchpoint discipline that protects (i.b) should equally protect (i.c)), the bundled framing makes the blow-up harder to localise. A 3-row decomposition matches the discipline applied to piece (i) at the (i.a)/(i.b)/(i.c) level — and would let the iter-138+ re-evaluation scorecard (fibre-free vs (B)) reason at sub-piece granularity instead of bundled.
- **What the current strategy may have rejected**: unclear from prose — the iter-133 pushdown from (i.b) into (i.c) is named, but the bundling rationale (vs sub-decomposing on the spot) is not articulated.
- **Severity of the omission**: minor (escalating to major if iter-137 dispatches (i.c)-side artefacts inline with (i.b)).

### Alternative: Direct route through `KaehlerDifferential` exactness for piece (ii) (path (b) of the iter-139/140 consult, named outright)

- **What it looks like**: The iter-139/140 consult is scheduled to choose between (a) installing a `Differential B` typeclass instance on chart algebras via a splitting, vs (b) routing piece (ii) through `KaehlerDifferential` exactness directly (`KaehlerDifferential.exact_kerCotangentToTensor_mapBaseChange` + a kernel-of-derivation argument, with `KaehlerDifferential.D R B` taking the role of the universal derivation). Path (b) directly states "if `d_{B/A} x = 0` then `x ∈ range(algebraMap A B)`" — which is structurally what piece (ii) needs.
- **Why it might be cheaper or sounder**: Path (a) is structurally unnatural — `Differential B` is a derivation `B → B` valued in `B`, used for differential rings (e.g. differential Galois theory). Installing such an instance via a "splitting of `B → Ω_{B/A}`" requires picking a non-canonical splitting; `ContainConstants` of the chosen splitting is then a property of that choice rather than an intrinsic property of `Ω_{B/A}`. Path (b) avoids the splitting entirely, uses the universal derivation directly, and consumes lemmas that already exist in Mathlib (verified: `KaehlerDifferential.exact_kerCotangentToTensor_mapBaseChange` ∈ `Mathlib.RingTheory.Kaehler.Basic`, `Algebra.H1Cotangent.exact_δ_mapBaseChange` ∈ `Mathlib.RingTheory.Kaehler.JacobiZariski`).
- **What the current strategy may have rejected**: nothing yet — the iter-136 consult-scheduling row presents (a) and (b) as parallel options awaiting analogist verdict. The strategy could pre-empt the consult on path (a)'s structural awkwardness and commit to path (b) directly, saving the consult iter.
- **Severity of the omission**: minor — the iter-139/140 consult will likely return path (b) anyway; pre-committing would save one analogist iter but is not load-bearing.

### Alternative: Genus = 1 fast path within M3

- **What it looks like**: Sub-case `genus C = 1`: in this case the Jacobian *is* `C` (with a chosen `k`-rational point as zero, if one exists). For elliptic curves the Albanese-variety construction reduces to identifying `C` itself with its own Jacobian rather than building a higher-dimensional Picard scheme.
- **Why it might be cheaper or sounder**: cuts M3 into a (much easier) genus-1 arm + a (still hard) genus ≥ 2 arm. The genus-1 arm avoids Hilbert/Quot/Sym^g entirely. The genus ≥ 2 arm still needs Routes A or B but covers a smaller logical surface.
- **What the current strategy may have rejected**: unclear — the strategy frames M3 as a single block ("positive genus") without sub-casing on `genus C = 1` vs `genus C ≥ 2`. The genus-1 case still requires a `k`-rational point on `C` to identify `J ≅ C`; without one, the elliptic-curve case is itself non-trivial. So this isn't a free win, but it's an unmentioned axis of decomposition.
- **Severity of the omission**: minor (M3 is off the critical path; sub-casing decisions can wait until the user-escalation routes are picked).

### Alternative: Pre-commit to the revert decision rather than maintain (a')/(b)/(c) trigger machinery

- **What it looks like**: Acknowledge that the quantitative case for over-k vs over-`k̄` is now lower-bound zero (per strategy line 487 "net savings 2–6 iter / 0–500 LOC"), that ground (ii) is admitted to be switching-cost, ground (iv) is route-validation-only, and ground (iii) was demoted iter-136 to risk mitigation. Re-frame the over-k commitment as a *bounded-cost operational default* rather than a defended strategic choice: stay because reverting also costs ~1 iter, so the operational savings are zero either way.
- **Why it might be cheaper or sounder**: This is the honest framing the strategy is already 90% of the way towards (lines 506–514 explicitly name the demotion). Articulating it directly would simplify decision-making on the (a')/(b)/(c) triggers — they become "fire any of them, revert immediately, ~1 iter" rather than "fire any of them, revert reluctantly given accumulated over-k investment." The strategy currently keeps three separate triggers wired and re-litigated each iter; collapsing to "operational default; revert on any trigger" reduces strategy-document maintenance burden.
- **What the current strategy may have rejected**: the strategy may be retaining (a')/(b)/(c) as decision-quality machinery rather than a single revert button. That's defensible — the triggers do distinguish causes — but the *defense framing* of the over-k commitment under the demoted-(iii) state is awkwardly verbose.
- **Severity of the omission**: minor — operational outcome is the same; this is a strategy-document streamlining recommendation, not a route correction.

## Sunk-cost flags

The strategy is unusually disciplined about flagging its own sunk-cost vulnerabilities — iter-130 struck ground (i) of the over-k defense; iter-136 demoted ground (iii); iter-134 separated forward-merit axes from switching-cost axes in the fibre-free scorecard; iter-128's CHALLENGE on user-hint citation discipline is enforced. The strategy explicitly applies self-flagging discipline.

One residual smell to log without re-escalating:

- "**(ii) Blueprint cleanliness (load-bearing, switching-cost-flavored)** ... it is real, but not independent positive evidence the over-k route is better than over-`k̄` *in the abstract*" (strategy line 508) — **Why this is sunk-cost-tinged**: the strategy already self-flags this. Recommendation: as proposed in Alternative 4 above, complete the framing by retitling the over-k commitment from "defended" to "operationally defaulted, bounded revert cost". The strategy is one paragraph away from this; the discipline is already present.

(No other sunk-cost smells detected. The iter-128 user-hint-citation-discipline rule at line 398 is a genuine corrective on a real prior risk — it stays as-is.)

## Prerequisite verification

Each Mathlib name the strategy cites that I could spot-check via leansearch/loogle:

- `IsLocalRing.CotangentSpace`: VERIFIED (`Mathlib.RingTheory.Ideal.Cotangent`).
- `Differential.ContainConstants`: VERIFIED (`Mathlib.RingTheory.Derivation.DifferentialRing`); keyed on `Differential B`, with `mem_range_of_deriv_eq_zero` constructor — exactly as strategy describes.
- `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`: VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`); the converse-with-`Subsingleton (Algebra.H1Cotangent R S)` hypothesis is exactly as the strategy's M4 disclosure describes.
- `KaehlerDifferential.tensorKaehlerEquiv`: VERIFIED (`Mathlib.RingTheory.Kaehler.TensorProduct`).
- `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`: VERIFIED (`Mathlib.RingTheory.Etale.Kaehler`).
- `TopCat.Presheaf.pullback`: VERIFIED (`Mathlib.Topology.Sheaves.Presheaf`).
- `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`: VERIFIED (`Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf`).
- `Algebra.IsStandardSmoothOfRelativeDimension`: VERIFIED (`Mathlib.RingTheory.Smooth.StandardSmooth`).
- `AlgebraicGeometry.Scheme.absoluteFrobenius`: VERIFIED MISSING — only ring-side `frobenius` (`Mathlib.Algebra.CharP.Frobenius`, `Mathlib.Algebra.CharP.Lemmas`) and unrelated `NumberTheory.FrobeniusNumber`; the scheme-level Frobenius is a genuine gap. Matches strategy's claim (and Stacks Tag 0CC4 reference).

Naming nit (does not change the verdict): strategy line 446 cites `KaehlerDifferential.exact_mapBaseChange_map` family. The actual Mathlib name appears to be `KaehlerDifferential.exact_kerCotangentToTensor_mapBaseChange` (along with `Algebra.H1Cotangent.exact_δ_mapBaseChange`). The family exists; the strategy's paraphrase is loose. RENAMED, not phantom.

## Must-fix-this-iter

- **Route M2.body-pile — CHALLENGE**: Piece (i.c) bundles three responsibilities (chart-localisation identification from (i.b) pushdown, `omega_free` freeness conclusion, `omega_rank_eq_dim` rank pinning) under a single "200–500 LOC" envelope. The iter-137 dispatch on piece (i.b) Step 2 (the `relativeDifferentialsPresheaf_basechange_along_proj_two` Mathlib-gap-fill, ~150–300 LOC) is sequenced correctly relative to the Main Compose, but the *downstream* (i.c) row needs the same level of decomposition (i.c.1/i.c.2/i.c.3) the (i.a)/(i.b)/(i.c) split already applies one level up. Planner must either (a) split (i.c) explicitly in STRATEGY.md before iter-137+ scaffolding lands an inline triple-deck, or (b) record an explicit rebuttal in `iter/iter-137/plan.md` arguing the bundling is intentional (e.g. because (i.c.1) is structurally inseparable from (i.c.2)). The iter-133 8-line pushdown note ("pushed in from piece (i.b)") is honest but not load-bearing-enough for a 200–500 LOC item.

- **Alternative "Piece-(i.c) sub-decomposition" — minor**: see above. Tied to the CHALLENGE; addressing the CHALLENGE addresses this.

- **Alternative "Pre-commit path (b) of iter-139/140 consult" — minor**: path (a) (`Differential B` typeclass via splitting) is structurally awkward; the strategy could pre-empt the consult by committing to path (b) directly. Not blocking; one analogist-iter savings.

- **Alternative "Over-k commitment re-framed to bounded-revert operational default" — minor**: see above. Document-streamlining recommendation; outcome-equivalent.

No phantom prerequisites. No REJECT verdict.

## Overall verdict

A fresh mathematician would approve this strategy with one mid-severity correction. The strategy is unusually disciplined about anti-sunk-cost framing (the iter-130 strike of over-k defense ground (i), iter-136 demotion of ground (iii) to risk mitigation, iter-134 forward-merit-vs-switching-cost weighting in the fibre-free scorecard, iter-128 user-hint citation discipline rule) — these are healthy patterns. Mathlib prerequisite citations are accurate where I could verify them (modulo one loose family-name in the `KaehlerDifferential.exact_*` citations). The piece (i.b) Step 2 dispatch this iter is sequenced correctly relative to the Main Compose. The qualitative defense of the over-k commitment is now honest in its framing (switching-cost named; route-validation scope-bound; risk-mitigation demoted), with the bounded-revert escape hatch wired through triggers (a')/(b)/(c). The piece (iii) provisional commitment to ~800–1500 LOC scheme-level absolute Frobenius is genuinely provisional — the iter-135–138 analogist consult on the no-Frobenius / higher-Kähler-vanishing alternative is on the critical path (must return before iter-141 piece (ii) scaffolding) and the strategy enumerates the pivot conditions concretely. The `Differential.ContainConstants` alignment row scheduled iter-139/140 is honestly named as needed-before-piece-(ii)-scaffolding rather than a deferral. The main concern is the piece (i.c) bundling: the chart-localisation pushdown from (i.b) inflated (i.c)'s LOC by exactly the amount stripped from (i.b), creating a hidden three-responsibility coupling under one envelope. That coupling deserves an explicit decomposition before iter-137+ scaffolding rather than after.
