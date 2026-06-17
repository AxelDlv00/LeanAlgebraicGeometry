# Strategy Critic Report

## Slug
iter142

## Iteration
142

## Routes audited

### Route: End-state of zero in-tree sorry (PROVISIONAL on piece (iii); named-gap fallback)

- **Goal-alignment**: PASS — zero in-tree sorry on the nine protected declarations is exactly what the project goal demands; the named-gap-sorry fallback for piece (iii) `Scheme.absoluteFrobenius` is explicitly scoped and triggered (iter-144+ MANDATORY chart-algebra-vs-bundled gate; auto-fire if ≥2 PARTIAL iters or build exceeds project sustainability).
- **Mathematical soundness**: PASS — fallback is honest ("zero inline sorry modulo one named-gap on a Mathlib-canonical piece"); analogous to the M1.d off-loop PR precedent.
- **Sunk-cost reasoning detected**: no — the strategy itself acknowledges "**Iter-139 honest acknowledgement**: the in-tree-build commitment is switching-cost + zero-sorry-end-state-commitment-driven, NOT a 'in-tree is cheaper' decision," recording the analogist's recommendation that "named-gap sorry IS the cheaper escape hatch" as an active alternative. That self-flagging is exactly what a fresh reader would demand.
- **Phantom prerequisites**: none — every NEEDS_BUILD piece (`Scheme.absoluteFrobenius`, `GrpObj.omega_*`, scheme-level `Ω` base-change) is explicitly named as a phantom in the gap inventory.
- **Effort honesty**: reasonable — multi-year wall-clock framing (9–24 months at sustainable 50–100 LOC/iter) is honest given the M2 critical-path (17+ iter shared pile) plus M3 (65–180 iter / 6500–9000+ LOC).
- **Verdict**: SOUND.

### Route: Genus case-split decomposition (M2 + M3)

- **Goal-alignment**: PASS — the protected `nonempty_jacobianWitness` signature admits `by_cases h : genus C = 0` as the body since `genus C : ℕ` is decidable-equality.
- **Mathematical soundness**: PASS — the vacuity branch for `C(k) = ∅` on the genus-0 arm is sound (`isAlbaneseFor : ∀ P : 𝟙_ ⟶ C, IsAlbanese …` is Lean-vacuously true when the binder type is empty). Brauer–Severi conics over ℚ are properly handled.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none at this layer (all gaps are absorbed by M2/M3 sub-routes).
- **Effort honesty**: reasonable.
- **Verdict**: SOUND.

### Route: Over-k commitment for the cotangent-vanishing pile (vs over-`k̄` + M2.c Galois descent)

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — the functorial shear-iso route is base-independent; absolute Frobenius (not relative) is intrinsic, ducks the perfectness requirement that relative Frobenius would impose.
- **Sunk-cost reasoning detected**: NO — actively self-flagged. Grounds (i)+(iii) struck/demoted; ground (iv) scope-narrowed to piece (i.a); ground (ii) honestly relabelled "switching-cost-flavored"; iter-138 reframing to "operationally defaulted, bounded revert cost preserved" is intellectually honest. The lower-bound quantitative case is **zero** (2–6 iter / 0–500 LOC saved vs over-`k̄`+M2.c, per iter-128 revision), and the strategy says so plainly.
- **Phantom prerequisites**: none at this layer.
- **Effort honesty**: reasonable; lower bound is honest.
- **Verdict**: CHALLENGE — see Must-fix #1. The over-k vs over-`k̄` framing has become more ornate than load-bearing. The iter-141 finding that piece (i.b) Step 2 is **base-independent** (so route-pivot does nothing for the bottleneck) elevates a question the strategy doesn't yet answer: **for every base-independent pile piece, the over-k vs over-`k̄` choice is purely notational**. If that's the case for pieces (i.a), (i.b), (i.c), and (iii) (none of them care about `k̄`-rational points under the committed shapes), then the elaborate operational defense in §§ Direct over-k rigidity / Over-k re-defense / Iter-138 reframing collapses to "we name our base field `k`; pivot would change nothing." The strategy should explicitly say which pile pieces are base-dependent vs base-independent, so that pivot triggers (a')/(b)/(c) only fire on pieces where base-dependence is structurally possible.

### Route: M2.body-pile piece (i.b) Step 2 — universal-property-at-presheaf-level

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — the iter-137 analogist diagnostic (`PresheafOfModules.pullback` opacity + `PresheafOfModules.isoMk` all-opens naturality) forces the universal-property route; analogically clean.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: `PresheafOfModules.pullback` VERIFIED via loogle (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`), and the analogist's "defined as `(pushforward φ).leftAdjoint`" framing is consistent with the verified `pullbackPushforwardAdjunction`. `KaehlerDifferential.tensorKaehlerEquiv` — rate-limited; trust the strategy unless evidence otherwise.
- **Effort honesty**: iter-137 envelope ~360–710 LOC for Step 2 alone; revised from iter-133's 150–300 LOC. Honest; the analogist did the work of widening with documented arithmetic. The renormalised 1000-LOC cumulative cap (~316 + ~710 + 30% slack) is internally consistent.
- **Verdict**: SOUND.

### Route: M2.body-pile piece (iii) — scheme-level absolute Frobenius

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — Stacks Tag 0CC4 is the canonical reference; ring-side `Mathlib.Algebra.CharP.Frobenius` is the building block.
- **Sunk-cost reasoning detected**: NO — the iter-139 honest acknowledgement explicitly disavows "in-tree is cheaper" framing and records the named-gap alternative as active. Self-flagged.
- **Phantom prerequisites**: `AlgebraicGeometry.Scheme.absoluteFrobenius` PHANTOM — verified by my spot-check (`leansearch "scheme absolute Frobenius"` returns only ring-side `frobenius` + `LinearMap.frobenius` + `FiniteField.Extension.frob`; no scheme-level construction).
- **Effort honesty**: 800–1500 LOC (iter-128 revised from 300–600 LOC); iter-141 Wave 1 analogist confirmed in-tree midpoint ~1025 LOC stays below 2000 LOC pivot threshold. Chart-algebra alternative at 450–900 LOC dominates on raw LOC and is wired for iter-144 MANDATORY re-evaluation. Honest.
- **Verdict**: SOUND.

### Route: M2.body-pile piece (ii) — direct KaehlerDifferential path

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — the iter-138 `containConstants` analogist verdict (path (b) direct, reject path (a)) is well-reasoned; the `Differential R` instance graph in Mathlib is for differential fields in the Liouville tradition, not chart algebras.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: `Scheme.Over.ext_of_diff_zero` is named as PHANTOM (not yet built). Acceptable.
- **Effort honesty**: 300–600 LOC.
- **Verdict**: SOUND.

### Route: M3 — Picard (Route A) vs Symmetric powers (Route B), user-escalation triggered

- **Goal-alignment**: PASS — both routes produce a `JacobianWitness` for positive genus.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no — user-escalation was the principled action (>5000 LOC hard fallback fired iter-124); user hint iter-126 selected option 1 (do the work).
- **Phantom prerequisites**: representability of Hilbert/Quot/Pic functors, symmetric powers of schemes, Stein factorisation, Riemann–Roch — all named.
- **Effort honesty**: Route A ~6500 LOC, Route B ~9000 LOC. Honest.
- **Verdict**: SOUND.

### Route: Body shape Replacement (B) — chart-base-change `Classical.choose`-chain

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — Mathlib precedent `Polynomial.SplittingFieldAux` shows pure-term `noncomputable def` with `let`-bindings on `Classical.choose`/`.choose_spec` exposes structural form.
- **Sunk-cost reasoning detected**: no — the iter-133 4-axis scorecard (LOC + canonicity + blueprint + downstream API) replaced the iter-132 1-axis test and reaffirmed (B) on three of four axes; only canonicity favored fibre-free, and the iter-131 acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars` partially recovers it. Forward-merit-vs-switching-cost weighting was explicitly built into the re-evaluation rule (iter-134 sunk-cost awareness).
- **Phantom prerequisites**: none.
- **Effort honesty**: piece (i.a) closed at ~300 LOC final-tree (within envelope) but ~600 LOC build-and-correct (acknowledged honestly).
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: Collapse the over-k operational defense to a one-sentence convention statement

- **What it looks like**: Replace §§ "Direct over-k rigidity — COMMITTED iter-127" + "Over-k re-defense on revised numbers" + "Iter-138 reframing to 'operationally defaulted'" (currently ~6 paragraphs of layered, self-flagged operational-default argument) with: "Operational convention: pile pieces are formulated over an arbitrary base field `k`. Triggers (a'), (b), (c) fire only on pile pieces whose body becomes base-dependent (currently none, per iter-141 piece (i.b) base-independence finding)." Keep the revert wiring; drop the multi-paragraph debate, which is now closed by the iter-141 base-independence observation.
- **Why it might be cheaper or sounder**: The strategy already says (iter-141 must-fix #4) that "piece (i.b) is base-independent" — so route-pivoting changes nothing about the bottleneck. If the same is true of pieces (i.a) (already closed), (i.c) (assembly lemmas on top of (i.b)), and (iii) (absolute Frobenius is intrinsic per the iter-127 analogist), then **none of the active pile pieces is base-dependent**, and over-k vs over-`k̄` is a pure notational convention. The current strategy's ornate defense reads as if the choice matters; it doesn't, by the strategy's own iter-141 finding. Simplification improves clarity without changing the work.
- **What the current strategy may have rejected**: Unclear — the strategy may have kept the layered narrative as historical record. If so, the historical block should be archived (e.g. moved to a "decision history" appendix) and the live strategy should state the current convention plainly.
- **Severity of the omission**: minor.

### Alternative: In-loop scaffold of `Mathlib.AlgebraicGeometry.RelativeSpec` (raised by iter-140; not adopted)

- **What it looks like**: A 1-iter / +1-sorry / ~20-LOC scaffold of the protected `RelativeSpec` declaration inside the project tree, parallel to the existing M2 work, taking advantage of the M2 wait-window. The iter-123 audit identified `RelativeSpec` as the smallest extractable upstream-PR piece (~700–1100 LOC; useful regardless of M3 Route A vs B).
- **Why it might be cheaper or sounder**: Adds a sorry but moves the project from "M3 documentation only" to "M3 has a sorry-scaffold building." If the M2 build hits a longer-than-expected stall, the scaffold absorbs the spare cycles into M3 progress rather than blueprint polishing.
- **What the current strategy may have rejected**: The strategy explicitly says "Alternative not adopted: in-loop scaffold of `RelativeSpec` ... M2 critical-path absorption higher-priority during the M2 wait window; scaffolding adds a sorry to the active count. Re-evaluation iter-150+ if M2 closure timeline extends materially."
- **Severity of the omission**: minor — strategy named and rejected this; raising for completeness. **However**: the "iter-150+ re-evaluation" lacks a trigger condition. Suggestion: tie it to a concrete signal (e.g. "if M2.body-pile cumulative LOC exceeds 50% of the 1850–3600 LOC envelope without piece (i.b) closing").

### Alternative: Promote piece (iii) named-gap-sorry to PREFERRED DEFAULT (vs current "active alternative") earlier than iter-144

- **What it looks like**: Replace the iter-144 MANDATORY chart-algebra-vs-bundled re-evaluation gate with an iter-141-immediate decision to land the piece (iii) named-gap-sorry now, deferring the 800–1500 LOC in-tree scheme-Frobenius build indefinitely.
- **Why it might be cheaper or sounder**: The iter-138 hedge analogist explicitly recommends named-gap sorry as the cheaper path (~0 LOC + 0 iter). The end-state is then "zero in-tree sorry modulo one named-gap on `Scheme.absoluteFrobenius`", which the strategy already endorses as honest fallback. Bringing this forward would unblock pieces (i.c)+(ii) closure and the M2.a body close on a faster trajectory.
- **What the current strategy may have rejected**: The strategy gates the named-gap on "iter-141 piece (i.c) closure + iter-143 piece (ii) closure both substantive; if either returns PARTIAL across 2+ iters the plan agent MUST re-open this decision." The gate is principled: it doesn't want to take the escape hatch before exhausting the in-tree options.
- **Severity of the omission**: minor — the gating is mathematically conservative and respects the user-hint to "do the work." Not a strategic flaw.

## Sunk-cost flags

None this iter. The strategy self-flags every sunk-cost smell I would otherwise raise:
- Iter-138 "switching-cost + zero-sorry-end-state-commitment-driven" honest acknowledgement on piece (iii).
- Iter-130 ground (i) strike (kernel-clean iter-128 closure NOT evidence of route tractability).
- Iter-132 ground (i.a) tractability scoped narrowly to "route-validation only, not route-comparison."
- Iter-134 forward-merit-vs-switching-cost weighting in the (B) vs fibre-free 4-axis scorecard.
- Iter-138 LOC renormalisation discipline (asymmetric one-way ratchet forbidden).
- Iter-140 consult-count arm narrowed to envelope-widening only.
- Iter-141 multi-year wall-clock correction.
- Iter-141 CHURNING-trigger discipline (diagnostic question, not pre-committed answer).

The strategy has matured into one that names its own sunk-cost hazards. A fresh reader's complaint would be that the *history of self-flagging* now exceeds the *forward strategic content* in volume, but that's a clarity issue, not a soundness issue.

## Prerequisite verification

- `IsLocalRing.CotangentSpace`: VERIFIED (`Mathlib.RingTheory.Ideal.Cotangent`).
- `Module.finrank_baseChange`: VERIFIED (`Mathlib.LinearAlgebra.Dimension.Constructions`).
- `PresheafOfModules.pullback`: VERIFIED (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`); analogist's "left adjoint of pushforward" diagnostic consistent with `PresheafOfModules.pullbackPushforwardAdjunction`.
- `AlgebraicGeometry.Scheme.absoluteFrobenius`: MISSING (PHANTOM, correctly classified); only ring-side `frobenius`/`LinearMap.frobenius`/`FiniteField.Extension.frob` exist in `Mathlib.Algebra.CharP.*`.
- `Mathlib.Algebra.CharP.Frobenius`: VERIFIED (ring-side baseline for piece (iii) build).
- `Differential` (instance graph): the strategy's diagnostic (Liouville-tradition differential fields only) — trust the iter-138 analogist consult; no contradicting Mathlib evidence surfaced.
- `KaehlerDifferential.tensorKaehlerEquiv`: not verified this iter (rate limit); strategy uses it as a building block; no reason to doubt absent contrary evidence.

## Must-fix-this-iter

- **Route Over-k commitment: CHALLENGE** — Simplify the §§ "Direct over-k rigidity / Over-k re-defense / Iter-138 reframing" multi-paragraph operational-default narrative to a brief convention statement. The iter-141 base-independence finding closes the route-decision debate: pile pieces (i.a)/(i.b)/(i.c)/(iii) are all base-independent under the committed shapes, so over-k vs over-`k̄` is notational. Keep revert triggers (a'/b/c), but state explicitly that they fire only on pieces with *base-dependent body shape*, of which there are currently none. The current ornate self-flagging is correct but no longer load-bearing; collapsing it improves clarity and lets future fresh readers focus on what's actually live.

- **Edit-residue cleanup: CHALLENGE** — Two minor residues from iter-141 edits remain:
  1. Final paragraph of strategy ("The estimated iter for this restructure is post-M2.b / post-M3-scaffolding, i.e. **multi-month away**") contradicts the iter-141 multi-year framing adopted at the top. Either change to "multi-year away" or clarify that "multi-month" refers specifically to the restructure-with-scaffolds-only landing (a one-off body edit) rather than completion.
  2. The "Iter-141+ scheduled obligations" block lists "**Iter-141 (mandatory) piece (iii) scheme-Frobenius scoping analogist**" as a forward obligation, but the "Prior critique status" section reports the analogist has already returned with HYBRID verdict. Mark the iter-141 obligation as DONE/RESOLVED so future readers (including next iter's strategy critic) don't re-trigger it.

- **Alternative iter-150+ M3 PR-piece re-evaluation: minor** — Strategy says "Re-evaluation iter-150+ if M2 closure timeline extends materially" but "extends materially" lacks a concrete signal. Suggested trigger: "if cumulative M2.body-pile LOC exceeds 50% of the 1850–3600 LOC envelope without piece (i.b) closing, dispatch iter-150 analogist on in-loop scaffold of `RelativeSpec`."

(No REJECT verdicts. No new phantom prerequisites.)

## Overall verdict

A fresh mathematician would approve this strategy with minor cleanup notes. The strategy has matured to the point where it correctly identifies and self-flags its own sunk-cost hazards (over-k commitment grounds (i)/(iii) struck/demoted; piece (iii) in-tree commitment honestly named as switching-cost-driven; LOC renormalisation discipline made symmetric; CHURNING-triggers decoupled from pre-committed answers). The four iter-141 edits are internally consistent in substance; only two minor residues remain ("multi-month away" tail and the unupdated "Iter-141 mandatory" obligation block). The one substantive challenge is that the over-k vs over-`k̄` debate, having been definitively closed by the iter-141 base-independence finding for piece (i.b), now warrants a clarity collapse — keep the revert wiring, drop the ornate operational defense — but this is presentation, not strategy. Goal-alignment, mathematical soundness, prerequisite hygiene, and effort honesty are all in good shape. **CHALLENGE on 1 route (over-k presentation), CHALLENGE on edit residue cleanup; zero REJECT.**
