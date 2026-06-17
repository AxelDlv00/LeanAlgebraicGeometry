# Strategy Critic Report

## Slug
iter127

## Iteration
127

## Routes audited

### Route: M1 — Bridge presheaf ↔ algebra-Kähler form (EXCISED iter-126)

- **Goal-alignment**: PASS — excision is consistent with the iter-121 end-state (zero inline sorry); the M1.d Mathlib-PR candidate `kaehler_quotient_localization_iso` survives in-tree as a standalone utility and pre-bridge defs (`relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`) stay as future-consumer infra.
- **Mathematical soundness**: PASS — `KaehlerDifferential.exact_mapBaseChange_map` verified to exist in Mathlib `b80f227` (`Mathlib.RingTheory.Kaehler.Basic`); the construction sketch for `kaehler_quotient_localization_iso` is sound.
- **Sunk-cost reasoning detected**: no — the iter-126 excision explicitly killed the prior sunk-cost framing (a prior-strategy-critic challenge that was accepted).
- **Phantom prerequisites**: none.
- **Effort honesty**: n/a (route excised; off-loop PR work continues from `analogies/relative-differentials-presheaf-bridge.md`).
- **Verdict**: SOUND — route is dormant by design and the dormancy is well-justified.

### Route: M2.a — Rigidity over `k̄` (`rigidity_over_kbar` scaffolded iter-126; body gated on shared cotangent-vanishing pile)

- **Goal-alignment**: PASS — closes the rigidity prerequisite for M2.b's `isAlbaneseFor` field on the `C(k) ≠ ∅` branch.
- **Mathematical soundness**: PASS — the C.2.b/c/d/e decomposition matches the standard Mumford-style argument and the iter-126 strategy-critic's framing correction (named-sorry body gated on C.2.d) is honest about what's open.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim` are PHANTOM as the strategy admits (Mathlib has no `AbelianVariety` file — verified by loogle returning empty for `AbelianVariety`; `CategoryTheory.GrpObj` does exist in `Mathlib.CategoryTheory.Monoidal.Grp` so the proposed naming idiom under the `GrpObj` namespace is plausible).
- **Effort honesty**: reasonable for the scaffold (~50 LOC iter-126); body closure is counted under M2.d-alt's shared-pile rows; not double-counted here.
- **Verdict**: SOUND — scaffold deliverable is correctly scoped; body closure is correctly deferred to the shared-pile iter-129+ lanes.

### Route: M2.b — Genus-0 witness `genusZeroWitness` (scheduled iter-127 scaffold)

- **Goal-alignment**: PASS — produces the genus-0 arm of `nonempty_jacobianWitness`.
- **Mathematical soundness**: PARTIAL — the vacuity branch ("`C(k) = ∅` ⇒ `isAlbaneseFor` vacuously satisfied") IS sound on the protected `ofCurve` signature (a `P : 𝟙_ ⟶ C` morphism from the monoidal unit is exactly a `k`-rational point and the set is empty when `C(k) = ∅`), but the strategy never explicitly cross-references the actual `JacobianWitness` structure field signatures to verify the vacuity reading. **The vacuity claim should be confirmed against the in-tree `JacobianWitness` definition before scaffolding** — if `isAlbaneseFor` is bundled differently (e.g. existential over $P$ rather than universal), the vacuity branch flips polarity.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: depends on M2.a's `rigidity_over_kbar` for the `C(k) ≠ ∅` branch; that scaffold landed iter-126 with a named sorry, which is acceptable for an iter-127 scaffold-on-scaffold dispatch (the deeper sorry is allowed by the named-builder pattern).
- **Effort honesty**: ~100 LOC for the builder seems reasonable assuming the vacuity polarity holds; could double if the `IsAlbanese` structure forces additional obligations.
- **Verdict**: CHALLENGE — the M2.b scaffold dispatch this iter must verify the `JacobianWitness` field signature (specifically how `isAlbaneseFor` is quantified) and prove the vacuity branch is genuinely vacuous, not assumed-vacuous. A short comment in the scaffold citing the binder shape is the minimum.

### Route: M2.c — Base-change-and-descent infrastructure (iter-139–146 in current timeline)

- **Goal-alignment**: PASS — transports rigidity from `k̄` back to `k`.
- **Mathematical soundness**: PASS — Galois descent of morphism equality is standard.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: partial — the strategy admits the precise "two scheme morphisms equal iff equal after base change" lemma must be assembled from `IsLocalAtTarget.descendsAlong` + `RingHom.FaithfullyFlat.codescendsAlong_surjective` + `Spec.map_injective`. This is honest scoping.
- **Effort honesty**: 4–8 iter / 300–500 LOC was already revised upward iter-124; consistent.
- **Verdict**: CHALLENGE — the strategy already commits to dispatch a `cotangent-vanishing-pile-over-k-iter127` analogist this iter to scope the over-k alternative that would DROP M2.c entirely. This is the right dispatch but the order is suspect: the over-k alternative was raised iter-125, accepted as a strategic question iter-126, deferred to a TO_USER.md flag, and is only NOW (iter-127) scheduled for analogist scoping. **Two iters of latency on a route-pruning decision is a smell**: had this been dispatched iter-126 in parallel with the over-k̄ analogist, the project would have known by iter-127 whether M2.c can be dropped. The planner should commit to running the over-k analogist THIS iter and acting on its verdict in the same plan phase if possible.

### Route: M2.c.aux — `geomIrred.exists_kalg_pt` (PHANTOM)

- **Goal-alignment**: PASS — provides the `k̄`-rational-point existence on `C_{k̄}`.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: confirmed PHANTOM per iter-124 spot-check; Mathlib has `Algebra.IsGeometricallyReduced` (verified) but no witness lemma producing a `k̄`-rational point from geometric irreducibility + non-emptiness.
- **Effort honesty**: 200–400 LOC reasonable.
- **Verdict**: SOUND — dependency on M2.c (avoidable via the over-k alternative being scoped this iter). Tied to the M2.c CHALLENGE above.

### Route: M2.d — Riemann–Roch path for genus-0 identification

- **Goal-alignment**: PARTIAL — produces `C_{k̄} ≅ ℙ¹_{k̄}` over `k̄`, but only matters as a fallback if M2.d-alt fails. Strategy presents the choice as open "made in the iter that first attempts M2.d (estimated iter-130+)" but operationally it may be foreclosed (see verdict).
- **Mathematical soundness**: PASS — standard RR-over-curves argument.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: every sub-piece (divisor module, degree, RR space, Serre duality, RR theorem) is admitted as a Mathlib gap.
- **Effort honesty**: **UNDER-COUNTED**. The M2.d row claims 1500–3000 LOC for the FULL stack (divisor module + degree + RR space + **Serre duality** + RR theorem + corollary + gluing). But the iter-126 analogist's standalone Serre duality estimate (per `analogies/serre-duality.md` iter-110 verdict, cited in the M2.d-alt piece (iv) row) is **3000–8000 LOC**. Serre duality alone exceeds the entire M2.d budget. Either the M2.d estimate is wrong, or the standalone Serre duality estimate is wrong, or M2.d's RR path uses a curve-specific lightweight Serre duality that wasn't compared apples-to-apples with the standalone estimate. **The strategy needs to reconcile this**.
- **Verdict**: CHALLENGE — both the cost estimate and the "choice still open" framing need re-grounding (see verdict on M2.d-alt below).

### Route: M2.d-alt — Cotangent-vanishing rigidity / shared cotangent-vanishing pile

- **Goal-alignment**: PARTIAL — pieces (i)+(ii)+(iii) close M2.a body (rigidity over `k̄`). Pieces (i)+(ii)+(iii)+(iv) would close M2.d-alt's genus-0 identification. **Piece (iv) is DEFERRED.** So M2.d-alt as a SOURCE of genus-0 identification is structurally unavailable in the iter-129+ shared-pile build.
- **Mathematical soundness**: PASS for the pile pieces; piece (iv) deferral implies M2.d-alt's genus-0-identification arm is incomplete, but the rigidity arm (M2.a body closure via pieces (i)+(ii)+(iii)) is sound.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: `GrpObj.omega_*` PHANTOM (confirmed); `Differential.ContainConstants` VERIFIED (exists in `Mathlib.RingTheory.Derivation.DifferentialRing` — found via leansearch); `CharP.Frobenius` claimed but not spot-checked here.
- **Effort honesty**: pile (i)+(ii)+(iii) at 1350–2600 LOC is QC'd by analogist; piece (i) at 800–1500 LOC is the dominant driver and names the presheaf-vs-sheaf bridge as inherited cost. The estimate is honest but **contingent**: if the presheaf-vs-sheaf bridge requires building the scheme-level cotangent sheaf from scratch (independent Mathlib gap), piece (i)'s cost could spill another 500–1000 LOC. The 4× upward correction from iter-126 already absorbs one upward revision; further upward revision is possible.
- **Verdict**: CHALLENGE — the operational status of "M2.d vs M2.d-alt choice still open" is misleading. Per the iter-126 deferral of piece (iv), M2.d-alt's genus-0 identification arm is NOT a viable iter-129+ deliverable. The project IS forced toward M2.d (RR path) for genus-0 identification, which compounds the M2.d cost-honesty challenge above. **The strategy should explicitly acknowledge: "M2.d-alt covers M2.a body only; M2.d (RR) is the only path to genus-0 identification under current scoping; Serre duality is a shared dependency that appears in BOTH M2.d's sub-step decomposition AND M2.d-alt's piece (iv)."**

### Route: M3 — Positive-genus witness `positiveGenusWitness` (off-critical-path)

- **Goal-alignment**: PASS — closes the positive-genus arm.
- **Mathematical soundness**: PASS — both Route A (FGA Picard) and Route B (Sym + Stein) are mathematically sound paths.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: extensive — both routes name multi-thousand-LOC Mathlib gaps; honestly disclosed.
- **Effort honesty**: 100+ iter / 10000+ LOC per route is honest; the iter-123 audit per-piece breakdown (Route A ~6500 LOC; Route B ~9000 LOC) is rigorous.
- **Verdict**: SOUND — the iter-126 user-hint absorption (do-the-work over named-axiom; PR-and-wait) is consistent with the iter-121 zero-sorry end-state. M3 is correctly off the iter-by-iter critical path until M2 closes.

## Alternative routes (suggested)

### Alternative: Build the scheme-level cotangent sheaf as a standalone Mathlib-PR target BEFORE piece (i)

- **What it looks like**: Treat "scheme-level cotangent sheaf" as an iter-128 (or earlier) Mathlib-PR scaffold target in its own right. It is independently useful Mathlib infrastructure (consumed by RR, by smoothness criteria, by every future curve/surface result), and it is the named "inherited cost" of piece (i). A clean cotangent-sheaf foundation in Mathlib would (a) unbundle the presheaf-vs-sheaf bridge from piece (i)'s LOC line, (b) provide a credit-bearing upstream PR earlier than piece (i)'s closure, and (c) reduce piece (i)'s estimate from 800–1500 LOC down to ~400–800 LOC by removing the bridge work.
- **Why it might be cheaper or sounder**: the cotangent sheaf is a Mathlib gap with HUGE cross-utility (RR path, smoothness criteria, surface theory — all consume it). It is much more PR-shaped than piece (i)'s `GrpObj.omega_free` (the latter is Jacobian-specific, the former is generic algebraic geometry). Front-loading the cotangent sheaf as a standalone PR-target gives the loop a forward-progress signal AND a Mathlib contribution that pays for itself across multiple downstream routes.
- **What the current strategy may have rejected**: the strategy bundles "presheaf-vs-sheaf bridge cost" into piece (i) per `analogies/cotangent-presheaf-design.md`, treating it as a sub-cost. The bundling might have been chosen to keep the M2.a closure timeline tight (frontloading more upstream work delays M2.a). But the timeline is already iter-138 to iter-145 for M2.a body closure; another 5–8 iter for a standalone cotangent-sheaf PR doesn't change the order of magnitude AND parallelises with M3 PR work.
- **Severity of the omission**: major — this is the strategy's single largest LOC line item and the bundling decision deserves explicit weighting in STRATEGY.md.

### Alternative: Dispatch the over-k cotangent-vanishing analogist in parallel with iter-126's over-k̄ analogist (already addressed for iter-127)

- **What it looks like**: instead of running the over-k analogist iter-127 (one iter after over-k̄), run them in the same plan phase iter-126. Compare the two scopings side-by-side and pick the cheaper one before scaffolding M2.b iter-127.
- **Why it might be cheaper or sounder**: if the over-k alternative scopes equivalently to over-k̄, M2.c (300–500 LOC, 4–8 iter) drops entirely AND the M2.b vacuity branch logic simplifies (Brauer–Severi conics over `ℚ` are handled directly over `ℚ` without descent). Two iters earlier than the current schedule.
- **What the current strategy may have rejected**: the iter-126 plan-agent may have wanted iter-126 to focus on the primary over-k̄ scoping before opening an alternative. But analogist consults are read-only and parallelisable. The opportunity cost is one iter.
- **Severity of the omission**: minor (iter-127 is dispatching it now per the directive; the omission is a 1-iter delay, not a strategic flaw). Logging it as a process lesson for future analogist dispatches.

### Alternative: Treat Serre duality as a SHARED dependency at the M2.d level, not as a piece-inside-one-variant

- **What it looks like**: refactor STRATEGY.md so Serre duality is a top-level "Shared dependency: Serre duality for curves over `k̄`" item with its own cost row (3000–8000 LOC per the iter-110 verdict), consumed by both M2.d (RR path) and M2.d-alt's piece (iv). Strip the duplicate accounting (M2.d's row currently buries Serre duality inside its 1500–3000 LOC; M2.d-alt's piece (iv) names it standalone at 3000–8000 LOC; these can't both be right).
- **Why it might be cheaper or sounder**: not cheaper, but HONEST. It would surface the genuine cost of genus-0 identification under either variant and force the strategy to acknowledge that Serre duality is a strict prerequisite for closing M2 regardless of which M2.d variant is chosen. It would also surface that the "choice still open" framing for M2.d-vs-M2.d-alt is artificial: the two variants share the most expensive dependency.
- **What the current strategy may have rejected**: the split-by-variant accounting may have been chosen for backward continuity with earlier strategy iters when M2.d-alt was branded as the "Serre-duality-only" alternative to "full Riemann-Roch". With M2.d's own sub-step list now explicitly naming Serre duality (line 188 of STRATEGY.md), that branding is no longer accurate.
- **Severity of the omission**: critical — the strategy currently sells the M2.d-vs-M2.d-alt choice as open while the cost-accounting is inconsistent between the two variants. This is a strategic decision-quality issue, not a cosmetic one.

## Sunk-cost flags

(No sunk-cost reasoning detected in the current strategy. The iter-126 excision of M1 was itself a sunk-cost correction and is documented as such. The M3 user-hint absorption is a forward-looking commitment, not justification by prior investment.)

## Prerequisite verification

- `CategoryTheory.GrpObj`: VERIFIED (`Mathlib.CategoryTheory.Monoidal.Grp`).
- `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim`: PHANTOM (confirmed; strategy admits).
- `Differential.ContainConstants`: VERIFIED (`Mathlib.RingTheory.Derivation.DifferentialRing`); piece (ii) ring-level alignment supported.
- `KaehlerDifferential.exact_mapBaseChange_map`: VERIFIED (`Mathlib.RingTheory.Kaehler.Basic`); M1.d standalone PR's exact-sequence input is real.
- `Algebra.IsGeometricallyReduced`: VERIFIED (`Mathlib.RingTheory.Nilpotent.GeometricallyReduced`); but this is "geometrically reduced", not "geometrically irreducible" — the project's `geomIrred.exists_kalg_pt` remains PHANTOM as the strategy admits.
- `AbelianVariety` (Mathlib namespace): MISSING (loogle returned no results) — strategy's switch to `GrpObj` namespace is correct.
- `AlgebraicGeometry.IsLocalAtTarget.descendsAlong`, `RingHom.FaithfullyFlat.codescendsAlong_surjective`, `Spec.map_injective`: not spot-checked this iter; iter-124 spot-check claimed VERIFIED.
- `Mathlib.Algebra.CharP.Frobenius`: not spot-checked this iter; strategy claims VERIFIED.

## Must-fix-this-iter

- **Route M2.b: CHALLENGE** — the iter-127 scaffold dispatch must verify the `JacobianWitness.isAlbaneseFor` field's binder shape and confirm the vacuity branch is genuinely vacuous on the protected definition. A one-line cross-reference comment in the scaffold body is the minimum.
- **Route M2.c: CHALLENGE** — the over-k analogist dispatch this iter must produce a CONCRETE verdict that the planner ACTS ON in the iter-127 plan phase. If the analogist confirms over-k viability, STRATEGY.md must be updated this iter to drop M2.c (not park it for "future consideration").
- **Route M2.d: CHALLENGE** — Serre duality cost-accounting is inconsistent across M2.d and M2.d-alt piece (iv). Reconcile the estimates (3000–8000 LOC standalone vs. buried inside M2.d's 1500–3000 LOC total) by the end of this iter.
- **Route M2.d-alt: CHALLENGE** — explicitly acknowledge that piece (iv) deferral forecloses M2.d-alt's genus-0 identification arm; rename/re-scope M2.d-alt as "rigidity-over-k̄ pile" since it no longer covers M2.d-alt's original purpose (genus-0 identification).
- **Alternative (standalone cotangent sheaf): critical** — the strategy must weigh treating the scheme-level cotangent sheaf as a standalone Mathlib-PR target ahead of piece (i), and EITHER adopt the unbundling OR explicitly rebut it in STRATEGY.md.
- **Alternative (Serre duality as shared dependency): critical** — the strategy must refactor the M2.d / M2.d-alt accounting to treat Serre duality as a shared top-level dependency, not as a piece-inside-one-variant.

## Overall verdict

A fresh mathematician would approve the project's high-level architecture (genus case-split; M1-excised; M2-then-M3 sequencing; shared cotangent-vanishing pile for M2.a body) and the explicit phantom-prerequisite disclosure. However, three concerns are material: (1) Serre duality cost-accounting is internally inconsistent between M2.d and M2.d-alt's piece (iv), and reconciliation likely shows BOTH variants share the most expensive dependency, making the "open choice" framing artificial; (2) the strategy bundles the scheme-level cotangent sheaf into piece (i) as a sub-cost when it is independently useful Mathlib infrastructure that could land as a standalone PR earlier than piece (i)'s closure; (3) the META-PATTERN concern from prior iters is STILL LIVE — iters 125–128 produce only refactors, scaffolds, and analogist consults without prover-lane closure work, and the strategy's iter-128 piece (i) scaffold is yet another non-closure iter. Iter-127 must reconcile (1) and (2) inline OR explicitly rebut, AND act on the over-k analogist's verdict within the same plan phase to prevent another iter of latency.

---

**Return line**: `iter127: CHALLENGE — 8 routes audited, 5 CHALLENGE verdicts (+ 2 critical alternative omissions)`
**Report path**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/task_results/strategy-critic-iter127.md`
