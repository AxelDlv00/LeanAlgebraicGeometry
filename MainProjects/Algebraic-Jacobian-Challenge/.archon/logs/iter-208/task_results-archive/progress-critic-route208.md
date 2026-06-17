# Progress Critic Report

## Slug
route208

## Iteration
208

## Routes audited

### Route: Lane TS — `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 4 → 4 → 3 → 3 across iters 204–207. The single step-down (iter 205→206) was a dead-code removal (`monoidalCategory := sorry` from the deliberately-abandoned §2 monoidal instance). The three critical-path sorries — `tensorObj_restrict_iso`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj` — have not moved; they stand at 3 for the full 4-iter window.
- **Helper accumulation**: 10+ helpers and infrastructure items added across iters 204–207 (axiom-clean isos, lax-monoidal ε/μ/instance, transport lemmas, reduction steps). Zero critical-path sorry eliminations. The payoff ratio is 0/10.
- **Recurring blockers**: The surface phrase changed each iter, but every iteration ran into the same underlying wall — `(PresheafOfModules.pullback φ.hom).Monoidal` is absent from Mathlib. "whiskerLeft route disproven" (iter 204) → "MonoidalClosed absent" (iter 205) → "comparison map absent" (iter 206) → "ring-layer mismatch / pullback.Monoidal absent" (iter 207). This is one blocker with four renamed facets. The recurring-blocker rule fires across all 4 iters.
- **Avoidance patterns**: None detected. The route was active (not reclassified or deferred) across all 4 iters. No consecutive plan-only iters.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL — four consecutive PARTIAL statuses. Meets the CHURNING threshold (≥3 of last K iters PARTIAL) and, combined with zero critical-path sorry elimination, meets the STUCK threshold.
- **Throughput**: SLIPPING — STRATEGY.md estimated ~3–5 iters remaining from iter-202; elapsed is ~6 iters (202–207). The upper bound of the estimate (5 iters) is now exceeded. Elapsed has not reached 2× the upper bound (10 iters), so formally SLIPPING rather than OVER_BUDGET — but the estimate was never realistic given the Mathlib gap identified only mid-phase.

- **Verdict**: **STUCK**

  Both CHURNING and STUCK rules fire: helpers were added in all 4 of the last 4 iters while the critical-path sorry count is net-unchanged, prover status was PARTIAL ≥ 3 consecutive iters, and the same underlying blocker recurred across all 4 iters without resolution. STUCK is the worse verdict and takes precedence.

- **Primary corrective**: **Refactor** (structural re-route to sectionwise proof via line-bundle hypotheses), preceded by **Blueprint expansion** (the chapter must be rewritten to reflect the sectionwise strategy before the prover is dispatched).

  **Why**: The abstract-adjoint δ comparison-map route has been disproven in four distinct framings — every framing reduced to `(PresheafOfModules.pullback φ.hom).Monoidal`, an instance that does not exist in Mathlib at the pinned commit. No amount of additional infrastructure around the current abstract route will close this: the required instance is a genuine upstream gap. The planner's proposed sectionwise pivot is structurally different in the right way. Reading the current file: Steps 1–2 of `tensorObj_restrict_iso` are already closed (restriction → pullback via `restrictFunctorIsoPullback`; sheafification commutation via `sheafificationCompPullback`); the single remaining `sorry` at Step 3 is the presheaf-level base-change iso `pullback (M ⊗ N) ≅ (pullback M) ⊗ (pullback N)`. For an open immersion and line bundles with explicit free-rank-one trivialisations, this iso is constructible affine-locally without any monoidal-closed or strong-monoidal instance — sectionwise it is `B ⊗_A (A ≅ B) ≅ (B ⊗_A A) ≅ B` repeated in each factor, which is just extension of scalars applied to a generator. That is the genuine escape from the Mathlib gap.

  The corrective is: (1) Blueprint expansion — rewrite the `tensorObj_restrict_iso` chapter to give an explicit sectionwise proof sketch using free-rank-one trivialisations and the line-bundle hypothesis; (2) Refactor — add the IsLocallyTrivial / rank-one hypotheses to `tensorObj_restrict_iso`, remove the abstract δ-route reduction steps at Step 3 in the file (they are a dead end), and let the prover work sectionwise. Both must happen before the next prover round.

- **Secondary correctives**: None. The sectionwise pivot is the single correct move; do not also attempt to file a Mathlib PR for `pullback.Monoidal` as a side channel this iter — that would be a distraction and adds no in-iter sorry elimination.

---

## PROGRESS.md dispatch sanity

- **File count**: 1 (cap: not stated in directive; default 10)
- **Ready but not dispatched**: Not enumerated in the directive — cannot assess under-dispatch against the full project file list from signals provided.
- **Over the cap**: No.
- **Under-dispatch finding**: Indeterminate — the directive enumerates only one active route and does not supply a "N of M ready" count for other files. Cannot confirm or rule out under-dispatch without that information.
- **Verdict**: **OK** (within the scope of what the directive supplies). The planner should confirm in the iter sidecar whether other files with complete blueprint chapters and open sorries are being deliberately held back, and if so name the strategic reason; otherwise fill all ready lanes up to the cap.

---

## Must-fix-this-iter

- **Route Lane TS**: STUCK — primary corrective: **Refactor + Blueprint expansion** (structural re-route to sectionwise proof). Why: critical-path sorries unchanged for 4 iters, 10+ helpers accumulated with zero payoff, same underlying Mathlib gap (pullback not strong-monoidal) disproven under four reframings. The planner's proposed structural re-route is the correct corrective type; dispatch a blueprint-writer first, then the prover in `prove` mode on the rewritten chapter.
- **Route Lane TS**: SLIPPING — STRATEGY.md estimates ~3–5 iters remaining (set at iter-202), elapsed is ~6 iters. Revise the `Iters left` entry in STRATEGY.md to reflect the reset caused by the pivot; the sectionwise approach is a genuine structural change and the clock should restart from a realistic estimate for the new route.

---

## Overall verdict

One route audited; it is **STUCK**. The route has accumulated over ten helpers and infrastructure items across four iters while the three critical-path sorries have not moved, every attempted closure approach was subsequently disproven, and the prover returned PARTIAL in every iteration. The planner's proposed structural re-route (sectionwise proof via line-bundle hypotheses, abandoning the abstract comparison-map route) is the correct corrective type — it directly addresses the verified Mathlib gap by bypassing the missing `pullback.Monoidal` instance rather than trying to construct it. The planner must dispatch a blueprint-writer to rewrite the chapter before the prover round, then run the prover on the rewritten sectionwise route; dispatching another helper round on the existing abstract-category strategy is the failure pattern this audit exists to prevent.
