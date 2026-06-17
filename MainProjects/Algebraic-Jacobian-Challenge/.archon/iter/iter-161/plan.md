# Iter-161 plan-agent run

## Headline outcome

iter-161 is the **signature-gap-closure iter** mandated by the iter-160 review. The iter-160 prover
lane on bridge 2 proved **Step 2 axiom-clean** (`morphism_eq_of_eqAt_closedPoints`, the
dense-closed-points ⟹ hom-ext connective Mathlib doesn't package) and surfaced a genuine **chain
SIGNATURE GAP**: the route-B globalisation needs the closed points of the saturated open `U` DENSE
(a `JacobsonSpace`), which over `Spec k̄` follows from `(X⊗Y)` being locally of finite type — a
hypothesis the frozen chain signature lacked. Two independent iter-160 audits (lean-auditor +
lean-vs-blueprint-checker) landed this as the must-fix, with the same prescription: a
**plan-authorized signature change**, NOT proving at the broken signature.

This iter executed exactly that, end-to-end, via the sanctioned same-iter fast path:

1. **Confirmed the fix is clean before committing budget.** Searched Mathlib (existence-only) and
   verified all three discharging facts exist: `AlgebraicGeometry.LocallyOfFiniteType.jacobsonSpace`
   (`[LocallyOfFiniteType f] [JacobsonSpace Y] → JacobsonSpace X`), `Spec` of a field is Jacobson
   (`PrimeSpectrum.instJacobsonSpaceOfIsJacobsonRing`), `JacobsonSpace.of_isOpenEmbedding` (open
   subscheme inherits it). Confirmed none of the five chain lemmas is in `archon-protected.yaml`
   (only `genus`, `Jacobian.*`, `Jacobian.ofCurve` are) — so the refactor is in-bounds.
2. **refactor `lofft-thread`** — threaded `[LocallyOfFiniteType (X ⊗ Y).hom]` into all five chain
   lemmas. Build GREEN; sorry count unchanged (5); `#print axioms rigidity_lemma` shows no new custom
   axiom; all four internal call sites resolved the instance with no explicit-argument changes.
3. **blueprint-writer `lofft-blocks`** — stated the finite-type hypothesis on the chain blocks
   (retired the false "[IsAlgClosed] is the only added instance" claim), added the two missing
   `\lean{}` blocks (Step 2 proven, Step 1 residual w/ reused Mumford quote) + forward acyclic `\uses`
   edges, refreshed the "lone residual sorry" prose to name Step 1. No strategy-modifying findings.
4. **blueprint-reviewer `iter161`** (whole-blueprint, mandatory) → **HARD GATE CLEARS**: 12 chapters
   complete + correct, 0 must-fix; both iter-160 must-fixes resolved; `\uses` graph forward-acyclic
   (the iter-160 backward 2-cycle did NOT recur).
5. **Prover objective set** at `AbelianVarietyRigidity.lean`: (a) discharge the now-routine
   `JacobsonSpace U` instance (L238), (b) prove `rigidity_eqAt_closedPoint_of_proper_into_affine`
   (L151/body L173), the chain's lone genuinely-deep residual (Step 1, cohomology-free route B).

Net: chain sorry count unchanged (still 2 in-chain: the routine instance + the deep Step 1), but the
unit of progress is **the gap is closed** — both remaining sorries went from "not provable as
literally typed" to "provable as typed", and the deep residual is now sharply isolated as the single
geometric obligation standing between the project and a fully-proven, axiom-clean Rigidity Lemma.

## Subagent verdicts (absorbed)

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| refactor | lofft-thread | COMPLETE | `[LocallyOfFiniteType (X⊗Y).hom]` on 5 chain lemmas; build green; no new axioms; no protected sig touched; both chain sorries now provable-as-typed. |
| blueprint-writer | lofft-blocks | COMPLETE | Finite-type hyp stated; 2 new `\lean{}` blocks + forward `\uses`; stale prose refreshed; reused existing Mumford quote (no fabrication). No strategy-modifying findings. |
| blueprint-reviewer | iter161 | **PASS — HARD GATE CLEARS** | 12 chapters complete+correct, 0 must-fix; both iter-160 must-fixes resolved; chain `\uses` forward-acyclic; 1 informational (`genusZero_curve_iso_P1` large RR sub-build, not near-term). |
| progress-critic | rigidity-chain | **CONVERGING** | 1↔2 sorry oscillation is genuine forward motion (each iter 157→160 closed a named axiom-clean piece; residual depth monotonically falling); no recurring blocker; iter-161 IS the structural escalation. Non-gating: reword the busted `rigidity_lemma` "1–2" sub-cell (done); iter-162 = scheduled cube+RR OVER_BUDGET re-estimate trigger. |

## Decision made

**Thread `[LocallyOfFiniteType (X ⊗ Y).hom]` across the five chain lemmas (refactor), amend the
blueprint to match, clear the HARD GATE, then fire the prover at the deep Step-1 residual + the
routine instance. Do NOT pivot the route; do NOT prove at the old signature; do NOT open a cube/RR
lane this iter.**

- **Why this fix, not more proving.** The iter-160 sorries were not a Mathlib gap or a hard proof —
  they were an under-hypothesized statement (both audits concur). The route-B globalisation
  demonstrably requires dense closed points; the honest fix is to state the finite-type hypothesis
  that supplies them. It is free downstream (curves/AVs are finite type over `k̄`), threads purely by
  instance resolution (every chain lemma gets the same binder, so each caller has it in scope), and
  the three discharging Mathlib lemmas are verified to exist. Proving at the old signature is
  impossible-as-typed and was correctly refused.
- **Why no pivot.** Route (c) was reaffirmed SOUND by the iter-157 strategy-critic and progress-critic
  iter-161 returns CONVERGING. The chain is one deep geometric sorry away from closing.
- **Cheapest reversal signal.** If the prover finds Step 1 itself is not provable cohomology-free
  (i.e. genuinely needs proper-pushforward `f_*𝒪=𝒪` / relative Stein, the confirmed Mathlib gap), the
  route-B claim in `analogies/rigidity-affineconst.md` is wrong and we escalate to a fresh analogist
  consult before another prover round. Nothing observed this iter suggests that.
- **OVER_BUDGET watch (scheduled, not firing).** progress-critic set iter-162 as the trigger: if it
  again advances only the chain while cube + Riemann–Roch stay unstarted, re-estimate the full-arm
  `~10–18` cell and begin blueprinting the theorem of the cube. Recorded in PROGRESS.md "Next iter".

## Subagent skips

- strategy-critic: route (c) unchanged in substance — last ran iter-157 with verdict SOUND, no live
  CHALLENGE; iters 158–160 skipped it on the same grounds. The only STRATEGY.md edit this iter is a
  non-strategic honesty re-word of the `rigidity_lemma` estimation sub-cell (per the progress-critic
  throughput note); it touches no route, decomposition, or strategic question. Re-running a
  fresh-context strategic critique over an estimation-number reword would be a hollow dispatch — the
  exact failure mode the skip affordance exists to avoid.

## Notes
- No user hints this iter; iter-160 `plan.md` declared no `## Fallback if no user response` section,
  so proceeded normally (no user-silent fallback to execute/record).
- Tool substitutions: none (all Mathlib existence checks ran via `lean_leansearch`/`lean_loogle`).
