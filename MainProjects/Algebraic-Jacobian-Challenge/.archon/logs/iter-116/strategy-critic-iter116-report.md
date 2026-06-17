# Strategy Critic Report

## Slug
iter116

## Iteration
116

## Note on prior critique status (iter-115)

The iter-115 critique's two CHALLENGE items (aggregate-arithmetic / L880-converse hypothesis-and-closing-lemma names) were addressed in STRATEGY.md before iter-116. I confirm those edits cleanly: the Phase B row now (i) phrases the aggregate as conditional on the L880-converse outcome and (ii) names `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` with hypotheses `[FinitePresentation R S]`, `[Subsingleton (H1Cotangent R S)]`, basis range condition — matching Mathlib. So iter-115 CHALLENGES are now closed. This iter raises **new** CHALLENGES driven by the iter-115 prover INCOMPLETE on L175 and the user escalation in `USER_HINTS.md`.

## Routes audited

### Route: Phase A — Čech acyclicity (deferred, gated)

- **Goal-alignment**: PASS — Phase A is off-path; both substep dependencies (L1846 budget-deferred, L1120 PAUSED) honestly declared.
- **Mathematical soundness**: PASS — L1846 is documented as mechanizable-from-existing-Mathlib (not a phantom gap); L1120 STUCK status is recorded with hard-stop rule against repeated wrapper-engineering.
- **Sunk-cost reasoning detected**: no — the PAUSED/DEFERRED framing is the *opposite* of sunk-cost.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — "~30–80 LOC per-substep, conditional" is correctly framed as not on the iter-111+ schedule.
- **Verdict**: SOUND.

### Route: Phase B — Cotangent sheaves (L175, L880-forward, L897, L880-converse)

- **Goal-alignment**: PARTIAL — Phase B is now declared *not load-bearing on the 9 protected declarations* (the JacobianWitness exit policy detached this dependence), so its role is "blueprint-completeness commitment." That's fine framing. **But** the row still schedules L175 as the first prover lane, when the iter-115 prover returned INCOMPLETE on this exact target and the user has escalated for a route decision.
- **Mathematical soundness**: PASS for the L880 forward/converse decomposition. The decomposition correctly identifies `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` as the closing-lemma for the converse with `Subsingleton (Algebra.H1Cotangent R S)` as the genuine deformation-theoretic content. **But** the iter-115 prover stall on L175 is a fresh data point this strategy does not reflect.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags below.
- **Phantom prerequisites**: none (all 5 named Mathlib names verified, see § Prerequisite verification).
- **Effort honesty**: under-counted on L175; the Phase B row's "~2–3 iters / ~100–200 LOC" for L175 conflicts with the user's escalation evidence (5 consecutive iters, 0 sorries closed, +3 helpers added net). The escalation explicitly says the route is blocked on a missing Mathlib bridge ("`Scheme.PresheafOfModules`-on-affine-basis-of-X ⇒ sheaf on X"), which `analogies/affine-basis-sheaf-bridge.md` confirms is genuinely absent. Closing L175 honestly costs either: (Option 1) 5–10 iters to build the bridge; (Option 2) ~1–2 iters refactor to drop the sheaf obligation; (Option 3) 0 iters and one extra named-gap. **None of these three matches the current ~2–3 iter estimate.**
- **Verdict**: CHALLENGE.

### Route: Phase C0 — `instIsMonoidal_W` deferred Mathlib gap

- **Goal-alignment**: PASS — named gap #1; load-bearing on the post-C1 Pic-and-down arc; honest disclosure paragraph included.
- **Mathematical soundness**: PASS — the underlying gap (varying-ring `stalk_tensorObj`) is genuine.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — explicitly "Mathlib-deeper-foundations" deferred.
- **Verdict**: SOUND.

### Route: Phase C1 — refined `LineBundle` (DONE)

- **Goal-alignment**: PASS — body promotion landed iter-109; pullback route via the iter-109 sister pair is well-formed.
- **Mathematical soundness**: PASS — `LineBundle X := (Skeleton X.Modules)ˣ` against `BraidedCategory (X.Modules)` is correct.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: 0 (done).
- **Verdict**: SOUND.

### Route: Phase C2 — PicardFunctor verification round

- **Goal-alignment**: PASS — "verification round, likely no further work needed" is a defensible estimate.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND.

### Route: Phase C3 — Representability / `JacobianWitness` (DEFERRED via exit policy)

- **Goal-alignment**: PARTIAL — the project's stated goal is the 9 protected declarations. The exit policy ships the 9 *against* `Nonempty (JacobianWitness C)`, an existence sorry. This is plainly *not* a complete construction of the Jacobian; the strategy is honest about this ("the project ships a Jacobian *framework*, conditional on the witness"). I accept this framing as the project's chosen scope reduction — the user authored `archon-protected.yaml` and the JacobianWitness pattern is documented. But a fresh reader should know: PARTIAL goal-alignment is the *intended* end-state, not an oversight.
- **Mathematical soundness**: PASS for the framework; conditional on the witness for the construction.
- **Sunk-cost reasoning detected**: no — the iter-105 REJECT correctly rejected the prior 50–150-iter estimate and the exit policy is the *right* response.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND (as a deferral policy).

### Route: Phase D, E — `Genus.lean`/`Jacobian.lean`/`AbelJacobi.lean`

- **Goal-alignment**: PARTIAL — same conditional framing as C3.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: 0.
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: Option 2 from USER_HINTS — refactor Phase B against the presheaf-only form

- **What it looks like**: stop bundling `Ω_{X/S}` as a `SheafOfModules`; keep it as a `PresheafOfModules` with affine-chart locally-free property as the *primitive* mathematical content. `cotangent_at_section` and `smooth_iff_locally_free_omega` get rewritten in terms of "locally-free as a module on each affine chart" (= the genuine mathematical content). The L175 sheaf-condition obligation evaporates because Phase B no longer asks for it.
- **Why it might be cheaper or sounder**: it bypasses the genuine Mathlib gap (affine-basis-sheaf bridge) rather than building infrastructure to fill it. It also better matches the proof strategy at the Mathlib level: `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential` is stated in terms of algebra-level Ω, not sheaf-level Ω, and the existing scheme-level adapter `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` quantifies over affine charts. So the project's natural framing is *already* presheaf-on-affine-charts; the iter-113 sheaf pivot is a detour.
- **What the current strategy may have rejected**: the strategy does not even *name* this option. It is not in the "Trim alternatives considered" section. The user has now explicitly raised it in USER_HINTS as Option 2.
- **Severity of the omission**: **critical** — this option might be cheaper than the entire Phase B as currently scheduled, and it is the user's request that the strategy address it.

### Alternative: Option 3 from USER_HINTS — declare L175 as named gap #8

- **What it looks like**: stub L175 with `sorry`, annotate as named Mathlib gap #8 (parallel to the existing 7), document the disclosure in End-state, and proceed with L880 / L897 against `Ω_{X/S}` formally as a presheaf. The mathematical content of the downstream consumers is identical; only the named-gap count increments.
- **Why it might be cheaper or sounder**: it's strictly cheaper than Option 1 (the bridge build) and slightly cheaper than Option 2 (no refactor). The cost is one extra named-gap entry. The strategy already accepts 7 named gaps and 1 budget-deferral; declaring an 8th is a small marginal disclosure.
- **What the current strategy may have rejected**: again, the strategy does not name this option. The "Narrower L880+L897-only trim" alternative considers declaring L880-converse as named gap #8 but not L175.
- **Severity of the omission**: **major** — Option 3 is a clean compromise. The strategy should at minimum document why it's not selected if it isn't, alongside the other trim alternatives.

### Alternative: Use `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential` directly for L880

- **What it looks like**: instead of decomposing `smooth_iff_locally_free_omega` into forward + converse with separate Mathlib citations, use the single Mathlib biconditional `IsStandardSmooth R S ↔ Subsingleton (H1Cotangent R S) ∧ ∃ I b, range b ⊆ range (KaehlerDifferential.D R S)` (under `[FinitePresentation R S]`), then sandwich with `iff_of_isStandardSmooth` to land at `IsStandardSmoothOfRelativeDimension n`. This skips the manual forward/converse reassembly.
- **Why it might be cheaper or sounder**: it removes one engineering step (the explicit reassembly) and uses Mathlib's strongest closure on the algebra side. The remaining work is the algebra-to-scheme translation (chart-by-chart application of `isSmoothOfRelativeDimension_iff`), which is the same work the strategy already has in mind for forward+converse but only counted once.
- **What the current strategy may have rejected**: probably not considered — the strategy's "decomposed iter-114 into forward + converse" language reads as if the decomposition is mandatory. It is not.
- **Severity of the omission**: **minor** — same Mathlib infra, slightly different routing. Worth mentioning so the prover dispatch order can pick the more direct path.

### Alternative: L1846 reactivation as a Phase A wedge-task (planner has flagged)

- **What it looks like**: with Phase B paused pending user decision, reactivate L1846 as the iter-117 prover lane. It is documented as mechanizable from existing Mathlib (`IsLocalizedModule.{Away,pi,prodMap}` + algebra adapter), with the parked scaffolding at L1786–L1834 (~50 LOC of accreted iter-108/109 infrastructure) ready to consume.
- **Why it might be cheaper or sounder**: it converts the "L175 stall, no prover lane" situation into useful work. L1846 is a project-local mechanization, not a Mathlib gap, so the closure is genuinely tractable. The strategy's "Phase A is closed-out for the autonomous loop's scope" framing precludes this reactivation, but the framing was adopted under the budget pressure of Phase B competing for iter slots — if Phase B is paused, that pressure is lifted.
- **What the current strategy may have rejected**: the strategy frames Phase A as "closed for the autonomous loop" partly to free iter-budget for Phase B. With Phase B paused, the trade-off has changed.
- **Severity of the omission**: **minor** — the planner has already flagged this in the iter-116 directive. The strategy should explicitly name it as a fallback if the user picks Option 2 or 3 (since either of those frees iter slots from Phase B).

## Sunk-cost flags

- `"L175 first (foundational; the iter-113 unique-gluing pivot is the load-bearing residual)"` — **Why this is sunk-cost**: the L175 dispatch order is justified by the iter-113 pivot being "load-bearing", but iter-113's pivot has now produced 5 iters of 0 sorries closed. The iter-113 framing is the *cause* of the L175 stall, not a reason to keep doubling down on it. **Recommendation**: re-evaluate L175 on its current merits given the user's three-option fan, not on the iter-113 commitment to the unique-gluing reformulation.

- `"`Recommended dispatch order`: L175 first ... then L880-forward, then L897 (gated on L880-forward landing), then L880-converse as the heaviest"` — **Why this is sunk-cost**: this dispatch order is built assuming L175 closes. Five iters of evidence say it might not, yet the order keeps L175 in pole position. **Recommendation**: STRATEGY.md should record an *alternative dispatch order* triggered by Option 2 or Option 3 selection, where L175 is dropped or named-gapped and L880-forward becomes the first lane.

- `"`Trim alternatives considered`. Two distinct trim options have been considered and rejected: ..."` (and then enumerating "Aggressive trim" and "Narrower L880+L897-only trim", but not Options 2/3 from USER_HINTS) — **Why this is sunk-cost**: the trim-alternatives section was written when only the L880-converse stall was the live escape signal. The user's new escalation introduces Options 2 (refactor) and 3 (L175 named gap). The strategy *should* update this section now, not after iter-117 commits to one of the options. **Recommendation**: extend the trim-alternatives section with explicit treatment of Options 2 and 3 from USER_HINTS, even if neither is selected — document why.

- `"Phase A is now closed-out for the autonomous loop's scope"` — **Why this is sunk-cost (in a milder form)**: this framing was adopted under the pressure of Phase B competing for iter slots. With Phase B paused, the trade-off changes, but the strategy still treats Phase A as a closed chapter. **Recommendation**: soften to "Phase A is parked behind Phase B priorities; if Phase B is paused for >2 iters, L1846 reactivation is a candidate wedge-task" — this is what the planner has already proposed in the iter-116 directive.

## Prerequisite verification

All five Phase B Mathlib names verified via `lean_leansearch`:

- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`: **VERIFIED** (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`). Type: `[Nontrivial S] [IsStandardSmoothOfRelativeDimension n R S] → Module.rank S Ω[S⁄R] = n`.
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: **VERIFIED** (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`, declared as an `instance`). Type: `[IsStandardSmooth R S] → Module.Free S Ω[S⁄R]`.
- `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`: **VERIFIED** (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`). Hypotheses match strategy: `[FinitePresentation R S] [Subsingleton (H1Cotangent R S)]`, basis `b : Module.Basis I S Ω[S⁄R]`, range condition `Set.range b ⊆ Set.range (KaehlerDifferential.D R S)`.
- `Subsingleton (Algebra.H1Cotangent R S)`: **VERIFIED** as a Prop existing throughout Mathlib's smoothness library; bridges to `FormallySmooth` via `Algebra.FormallySmooth.subsingleton_h1Cotangent` and `Algebra.formallySmooth_iff` (the iff `FormallySmooth R A ↔ Module.Projective A Ω[A⁄R] ∧ Subsingleton (Algebra.H1Cotangent R A)` is a stronger characterisation than the project currently invokes — see "Bonus finding" below).
- `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`: **VERIFIED** (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`). Type: `[Nontrivial S] [IsStandardSmooth R S] → (IsStandardSmoothOfRelativeDimension n R S ↔ Module.rank S Ω[S⁄R] = n)`.

**Bonus finding** (not in strategy, worth incorporating): `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential` (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`) is the **full** biconditional under `[FinitePresentation R S]`:
```
IsStandardSmooth R S ↔ Subsingleton (H1Cotangent R S)
                      ∧ ∃ I b, Set.range b ⊆ Set.range (KaehlerDifferential.D R S)
```
This collapses the manual forward/converse reassembly that STRATEGY.md describes. The forward direction can use `IsStandardSmooth.free_kaehlerDifferential` to *produce* the basis; the converse comes out of this iff for free. Combined with `iff_of_isStandardSmooth`, the project lands at `IsStandardSmoothOfRelativeDimension n R S ↔ <conditions>` with one less rebuild step.

**Bonus finding** (scheme-level): `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` (`Mathlib.AlgebraicGeometry.Morphisms.Smooth`) is the affine-chart iff at the scheme level. Either L880 direction (forward or converse) at scheme level requires this iff to translate between scheme-level smoothness and chart-by-chart `RingHom.IsStandardSmoothOfRelativeDimension` on the `appLE` map. The strategy's Phase B effort estimate counts the algebra-level work but does not surface this algebra-to-scheme translation step explicitly. For the converse direction in particular, constructing the chart `(U, V)` per point of `X` from the locally-free hypothesis on Ω is a substantive sub-step that probably adds ~100–200 LOC on top of the algebra-level work. The "~3–6 iters / ~200–500 LOC" estimate for L880-converse may need to land at the higher end.

## Must-fix-this-iter

- **Route Phase B: CHALLENGE** — STRATEGY.md must reflect the iter-115 L175 stall and the user escalation. Concretely:
  1. Update the Phase B row to acknowledge L175 closure is gated on a user decision among Options 1 / 2 / 3 (USER_HINTS.md, written iter-116).
  2. Replace the L175 "~2–3 iters / ~100–200 LOC" estimate with per-option figures: Option 1 ≈ 5–10 iters / 500–1500 LOC; Option 2 ≈ 1–2 iters refactor + the existing L880/L897 budget; Option 3 ≈ 0 iters for the L175 line (folds into an 8th named gap).
  3. Add an explicit alternative-dispatch-order branch for the case where the user picks Option 2 or 3 (L880-forward becomes the first prover lane; L175 is either refactored away or stubbed as gap #8).

- **Alternative Option 2 (refactor to presheaf-only): critical** — STRATEGY.md's "Trim alternatives considered" section must include Option 2 explicitly, with the same accept-or-reject reasoning the existing two alternatives carry. The omission is structurally similar to the prior "narrower trim" omission that the iter-114 critic flagged.

- **Alternative Option 3 (L175 named gap #8): major** — same as above. Option 3 is the cheapest fallback and should be a documented trim option even if not selected.

- **Conditional aggregate: CHALLENGE** — the aggregate currently branches only on L880-converse. Given the L175 stall, the aggregate should branch on **both** L175 fate (per Option 1/2/3) AND L880-converse fate. Without that, the aggregate over-estimates how mechanical the path-from-today is.

- **Sunk-cost framing: CHALLENGE** — the "L175 first, foundational" dispatch order and the "Phase A is now closed-out" framing both predate the iter-115 evidence. The strategy must record the trade-off-shift driven by 5 iters of L175 evidence + the planner's L1846 reactivation flag.

## Overall verdict

The strategy is **mostly sound on routes that are off-path (Phase A, C0, C1, C2, C3 exit policy)**, where the iter-110+ work landed clean deferral decisions and the named-gap accounting is honest. The **Phase B route, however, is materially out-of-date** given the iter-115 prover INCOMPLETE on L175 and the user escalation. A fresh mathematician reading the current STRATEGY.md would conclude "L175 is a tractable 2–3-iter close-out" — but the project itself has been running into evidence that this is not the case for five consecutive iterations, and the user is now formally asking for a route decision among three documented options, none of which match the strategy's current Phase B framing.

Two of those three options (Option 2 refactor; Option 3 named gap #8) are not even named in the strategy's "Trim alternatives considered" section, despite being explicit user-facing options. This is the same pattern (omitted trim alternative) the iter-114 critic flagged, recurring. The planner has paused the L175 lane this iter, which is correct, but the strategy on disk does not yet match the live planning reality — and the strategy's job is to *be* the live planning reality for a fresh reader. Hence the CHALLENGE verdict on Phase B and on the conditional aggregate. The five Mathlib-name prerequisites for the L880 sub-route are all verified clean; the strategy's algebra-level recipe is sound. The gap is in the framing of L175 and the failure to surface the user's option fan.

---

`iter116: CHALLENGE — 7 routes audited, 2 CHALLENGE verdicts (Phase B route, conditional aggregate), plus 2 critical/major missing trim alternatives (Options 2 and 3 from USER_HINTS) and sunk-cost reasoning around the L175 dispatch order. Five Phase B Mathlib prerequisites verified.`

Report path: `.archon/task_results/strategy-critic-iter116.md`
