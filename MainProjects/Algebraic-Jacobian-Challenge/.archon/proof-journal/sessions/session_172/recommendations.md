# Recommendations for iter-173 plan agent

## CRITICAL / HIGH

### Lane A G0BO — fire the progress-critic-mandated `mathlib-analogist` consult BEFORE assigning another prover round on PRIMARY 3.

- **Why**: iter-172 Lane A landed PRIMARY 1 axiom-clean but PRIMARY 2/3/SECONDARY all left as typed sorries — the **PARTIAL-low** bucket. The progress-critic `route172` corrective explicitly fires the consult on the chart-bridge specialisation `(gmScalingP1_cover).X i ≅ Spec((Away 𝒜 (X i)) ⊗[kbar] (GmRing kbar))` over `Over (Spec kbar)`. This is the **structural pullback bridge** identified by the prover's task_result as the next-iter unblocker.
- **What to ask the analogist (api-alignment mode)**: "Given `pullback (pullback.fst PLB.hom Gm.hom) (Proj.awayι 𝒜 (X i) hf_i) ⟶ ProjectiveLineBarScheme kbar`, what is the cleanest Mathlib idiom for constructing this morphism as `Spec((Away 𝒜 (X i)) ⊗[kbar] (GmRing kbar)) ⟶ Proj 𝒜`? Specifically: is there a `Limits.pullback.congrHom`-style hook that lets us replace one side of the pullback with `Spec.map (algebraMap _ _)` while preserving the over-`Spec kbar` structure?"
- **Deferral cost**: opening Lane A on PRIMARY 3 without the consult risks another iter of `pullbackSpecIso`-discovery churn. The consult is cheap (~1 plan-phase agent run); the prover round it precedes is expensive.
- **Pin**: `analogies/` slug suggestion = `chart-pullback-bridge`.

### Re-dispatch Lane B verbatim on `Picard/RelativeSpec.lean`.

- **Why**: iter-172 Lane B died to `API Error: 529 Overloaded` after 13 turns with 0 file edits. The chapter `Picard_RelativeSpec.tex` is on disk (449 LOC); the HARD GATE was CLEARED iter-172 plan-phase via `blueprint-reviewer picard-scoped172` (PASS, one `soon`-severity TODO on `thm:relative_spec_univ` proof prose, NOT blocking the file-skeleton lane). The lane is mechanical (~100-200 LOC of stubs).
- **What to do**: Re-dispatch with the iter-172 `objectives.md` Lane B section verbatim. No HARD-GATE re-run needed (chapter unchanged since iter-172 PASS). Per iter-170 → iter-172 KB pattern, external-API failure does NOT count as route falsification.
- **Pin**: lane re-dispatched at `iter/iter-173/objectives.md` Lane B; no plan-phase critic consult needed for this lane.

### Lean-auditor + lean-vs-blueprint-checker must-fix: `Scheme.PrimeDivisor.isCodim1AndIntegral : True := trivial` (RR/WeilDivisor.lean L90).

- **Severity**: must-fix-this-iter per BOTH iter-172 `lean-auditor iter172` AND `lean-vs-blueprint-checker wd172`. The placeholder field makes `Scheme.WeilDivisor X` structurally a free abelian group on **all** points of `X` rather than on codim-1 integral subschemes. The checker quantified this: with the `True` placeholder, `Scheme.PrimeDivisor X` is in bijection with the underlying carrier of `X`, so `Scheme.WeilDivisor X ≃ (X.carrier →₀ ℤ)`.
- **Mitigation context**: no project file currently consumes `WeilDivisor`/`PrimeDivisor` (only the umbrella imports it). So the wrongness is not poisoning downstream proofs YET, but the moment a sibling file under `RiemannRoch/` consumes the structure, the silent over-generation surfaces.
- **Two acceptable resolutions for iter-173**:
  - (a) Replace `True := trivial` with the real `Order.coheight point = 1 ∧ IsIntegral (X.closedSubschemeOfPoint point)` conjunction. Must happen before any other file imports `RiemannRoch.WeilDivisor`.
  - (b) Widen the placeholder to a `sorry` on a `Prop`-valued field so the wrongness surfaces as a kernel obligation rather than hiding silently behind `True`.
- **Chapter side**: `RiemannRoch_WeilDivisor.tex` `def:codim1_cycles` already carries an iter-172 `% NOTE` added by this review explicitly flagging the placeholder. **Additionally**: the checker `wd172` found the chapter is **materially under-specified** for the prime-divisor encoding — no Mathlib predicate named for "codim-1 prime", no `(*)` regularity-in-codim-1 hypothesis pinned. **Action**: iter-173 plan-phase MUST dispatch `blueprint-writer rr-prime-divisor-pin` to add a new `def:prime_divisor` block (or expand `def:codim1_cycles`) with an explicit `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` pin AND pin the standing $(*)$ hypothesis to a concrete Mathlib predicate so iter-173+ can refine the placeholder deterministically.

## CHURNING / STUCK route correctives

### Route 1 (genus-0 G0BO) — qualified CHURNING per `progress-critic route172`

- **Verdict**: 3-of-4 PARTIAL across iter-168/169/171/172 ⟹ fires the strict CHURNING-by-status rule. iter-172 iter was the make-or-break test; the result (PARTIAL-low) underperforms the "≥2 of 3 PRIMARY scaffolds close" reversal target.
- **However**: iter-172 PRIMARY 1's axiom-clean close was a **load-bearing helper unlocking 2 downstream consumers** — this is the iter-167 "cheapest-lever" KB pattern, NOT helper-supports churn. Reclassify iter-172 as **CONVERGING in disguise** for iter-173 budgeting: the unblocking is structural even though the headline bucket says PARTIAL-low.
- **Action**: open Lane A iter-173 with PRIMARY 3 attack AFTER the analogist consult. Plan should explicitly note the analogist-first hard gate so the planner does not skip ahead.

### Route 2 (Picard A.1.a Lane B) — STUCK no longer applies post-API-529

- **Verdict per progress-critic**: STUCK by 5+ iters deferral + 2 writer failures iter-171. **iter-172 changed the inputs**: the writer's 3rd attempt LANDED + the HARD GATE CLEARED + the prover lane fired (and was killed by external API). The route is **no longer STUCK** — its falsification predicate ("can the prover scaffold from the chapter?") was never run. Re-fire iter-173.

### Route 3 (RR.1 Lane C) — UNCLEAR → CONVERGING

- **Verdict per progress-critic**: UNCLEAR (fresh post-commitment). **iter-172 landed**: the file is on disk; 9 `\lean{...}` pins scaffolded; 3 of 9 sorry-free. Reclassify as **CONVERGING** for iter-173.
- **Action**: iter-173 body lane candidate = `Scheme.WeilDivisor.degree_hom` (pure Finsupp lemma, no scheme-theoretic content; closes via `Finsupp.sum_add_index` + `Finsupp.sum_zero_index`). Body for `ofClosedPoint` becomes attemptable once a curve-side closed-point ↔ prime-divisor lemma is added.

## Plan-agent action items for iter-173

### Refactor dispatch (carry-over from iter-171 lean-auditor)

The lean-auditor `iter172` re-flagged 3 of the 4 iter-171 stale-narrative blocks as still open:

1. `AlgebraicJacobian/RigidityKbar.lean:8-46` — header still presents the file as the live M2.a keystone gated on the "shared cotangent-vanishing Mathlib pile (iter-129+)"; per iter-163 route-C commitment, this is the fallback-(a) artifact and the cotangent-vanishing framing was demoted. Recommended fix: prepend a "Status (iter-163: route-(a) FALLBACK)" block.
2. `AlgebraicJacobian/Cotangent/GrpObj.lean:14-83` + `:297-326` — header still narrates the cotangent-vanishing pile as live; the load-bearing piece-(i.b) main lemma `mulRight_globalises_cotangent` was excised iter-145.
3. `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:36-79` — header still treats the chart-algebra route as live; demoted off-path iter-163.

**Recommended action**: dispatch a single `refactor` agent iter-173 plan-phase with slug `stale-narrative-iter173` whose directive bundles all 3 files. ~30-50 LOC of header-block edits total.

### Blueprint-writer dispatch on `Jacobian.tex`

The `lean-vs-blueprint-checker jacobian172` flagged a **major** blueprint internal inconsistency: three paragraphs at `Jacobian.tex` L344, L384-390, L425-427 still carry the pre-audit "A.4 bypass-holds / no new Mathlib namespace" prose that the iter-172 A.4 audit (at L574-602 + L656 in the same chapter) explicitly refutes. Plus a minor stale line-number reference at L556 (claims `Jacobian.lean:120-126` for `geometricallyIrreducible_id_Spec`; helper now at L134-140).

**Recommended action**: dispatch `blueprint-writer jacobian-a4-reconcile` iter-173 plan-phase. Directive: reconcile the 3 surviving "A.4 bypass-holds" paragraphs with the L574-602 + L656 audit verdict (outcome (b) — bypass FAILS, A.4 inherits Thm 3.2 + Lemma 3.3 + Auslander-Buchsbaum sub-build); refresh the stale line-number reference.

### Blueprint-writer dispatch on `RiemannRoch_WeilDivisor.tex` (chapter under-specification)

The `lean-vs-blueprint-checker wd172` flagged 4 **major** signature-looseness findings tracing to a chapter-side under-specification:
- `Scheme.WeilDivisor.ofClosedPoint` Lean signature is "any scheme + any IsClosed singleton" but the chapter pins "smooth proper curve over $k$".
- `Scheme.RationalMap.order`, `principal`, `principal_hom` use `[IsIntegral X]` but the chapter prose names Hartshorne's $(*)$ regularity-in-codim-1.
- `Scheme.WeilDivisor.degree` signature is broader than the chapter's "curve over $\bar k$" pin.
- The substantive helper `Scheme.PrimeDivisor` has no `\lean{...}` reference in the blueprint.

**Recommended action**: bundle into `blueprint-writer rr-prime-divisor-pin` (or split into 2 writers). Directive should add (a) a new `def:prime_divisor` block with `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` pin + Mathlib-vocabulary specification of the codim-1 witness; (b) a pinned standing $(*)$ hypothesis in a Mathlib predicate (e.g. `RegularInCodimension 1`, `IsNormal`, etc.); (c) explicit hypothesis-set guidance for `ofClosedPoint` / `degree` (tighten Lean or loosen chapter — chapter writer decides which is faithful to the maths).

### Blueprint-writer dispatch on `AbelianVarietyRigidity.tex` (chapter coverage gap)

The `lean-vs-blueprint-checker g0bo172` flagged a **major** chapter coverage gap: the 3 named scaffold sorries `gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence` lack per-decl `\lean{...}` pins. Recommend: add 3 `\lem{...}` blocks (or just `\lean{...}` annotations under the existing `def:gaTranslationP1` NOTE) so the deterministic `sync_leanok` / `\notready` machinery can track them individually.

### sync_leanok investigation (doctor)

iter-172 `sync_leanok-state.json` reports `chapters_touched: ["RiemannRoch_WeilDivisor.tex"]` but the AVR chapter should have gained `\leanok` on 3 proof blocks this iter (`mvPolyToHomogeneousLocalizationAway_surjective`, `homogeneousLocalizationAwayIso_aux_left`, `homogeneousLocalizationAwayIso`, all axiom-clean per `lean_verify`). Hypothesis: sync_leanok may not track `private` declarations. iter-173 plan should record this as a **doctor** investigation task.

## MEDIUM

### Promote `gmScalingP1_chart{0,1}_ringMap` and `gmScalingP1_cover` to chapter pins

The `lean-vs-blueprint-checker g0bo172` audit notes that these axiom-clean iter-171 helpers are referenced by name in the `def:gaTranslationP1` chapter NOTE but lack per-decl `\lean{...}` pins. Same chapter coverage gap as above; bundle into the iter-173 blueprint-writer dispatch.

### `projGm_isReduced` docstring stale "Mathlib gap" framing

The `lean-vs-blueprint-checker g0bo172` audit notes the body (G0BO L1024-1026) cites "blocked by Mathlib gap on Smooth → GeometricallyReduced". iter-168 closed `projectiveLineBar_isReduced` along the **same chart-domain route** the docstring lists as the alternative — so the gap framing is potentially stale. Recommend: spot-audit when `projGm_isReduced` next becomes a target (gated on PRIMARY 1 — now landed — so it IS attemptable iter-173+).

### Picard chapter `% SOURCE QUOTE PROOF: TODO` (soon-severity)

`Picard_RelativeSpec.tex` `thm:relative_spec_univ` proof at L185-190 has `% SOURCE QUOTE PROOF: TODO retrieve from references/stacks-constructions.tex (proof of lemma-spec, L553-L600, ~50 lines)`. The proof prose IS a structural translation; per project rule "every reference must be local + verbatim", the TODO is non-compliant for an implementation lane. **Not blocking** the iter-173 file-skeleton re-attempt; **blocks** any iter-174+ body lane on this proof. Recommend filling the verbatim quote before iter-174 body lane fires.

## LOW

- Minor lean-auditor `iter172`: `Genus0BaseObjects.lean:237` `push Not at h` is valid via Mathlib's generalised `push` tactic but unidiomatic vs `push_neg at h`. Standardisation cosmetic.
- Minor lean-auditor `iter172`: `Cotangent/GrpObj.lean:138-161` "Caveat on canonicity" docstring is unusually long for a definition-level docstring. Trim once a follow-up canonicity lemma lands.
- Minor lean-auditor `iter172`: `RiemannRoch/WeilDivisor.lean:6` `import Mathlib` is the all-of-Mathlib import. Defensible for a scaffold; per-need imports would speed builds. Defer to iter-173+ when bodies land.

## Blocked targets (do NOT re-assign)

- **`gm_grpObj` (G0BO L768)** — pre-existing iter-167 escalation-watch target (4+ iters deferred). NOT in scope iter-172; iter-173 plan should decide whether to retire it (the genus-0 path now goes via `gmScalingP1` directly per iter-164 KB).
- **`gmScalingP1_collapse_at_zero` (G0BO L916)** — gated on PRIMARY 3 (`gmScalingP1_chart` body). Defer until iter-173 PRIMARY 3 lands.
- **`projectiveLineBar_geomIrred` / `projectiveLineBar_smoothOfRelDim` / `gm_geomIrred` / `projGm_isReduced`** (G0BO L188, L195, L994, L1026) — pre-existing iter-165 scaffold sorries with "Mathlib gap" docstrings. iter-169 lean-auditor confirmed these are real gaps. Do NOT re-assign without a fresh Mathlib-availability re-check (or a `mathlib-analogist` audit on each individually — recommend bundling into a single cross-domain-inspiration consult on "smoothness/geom-irreducibility/reduced for the explicit `Proj 𝒜` of a polynomial ring").

## Reusable proof patterns discovered

1. **`MvPolynomial.induction_on` for `Algebra.adjoin (𝒜 0) (Set.range v) = ⊤`** — refine syntax pattern; use `Subalgebra.{algebraMap_mem, add_mem, mul_mem}` not bare `add_mem` / `mul_mem`. Reusable for any "polynomial-ring generated over its constant subring" claim in a `Proj`-chart context.
2. **`HomogeneousLocalization.val_pow` for `val (x^n) = x.val^n`** — dedicated lemma; `RingHom.map_pow` fails because `val` is not bundled. Located at `Mathlib/RingTheory/GradedAlgebra/HomogeneousLocalization.lean:456`.
3. **`Fin.ext + omega` substitution** is cleaner than `fin_cases i` for explicit-index reduction. `fin_cases` keeps the `⟨0, _⟩` form which doesn't reduce `otherFin` cleanly.
4. **`Localization.mk_eq_mk_iff` + `Localization.r_iff_exists`** for reducing equality of `Localization.mk` fractions to a ring identity. Pattern from PRIMARY 1's `gen_eq_pow` helper.
