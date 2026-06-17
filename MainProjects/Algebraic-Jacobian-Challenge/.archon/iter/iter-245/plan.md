# Iter-245 plan-agent run

## Headline outcome

The **"soundness-before-budget catch that abandons a 20–38-iter build for an ~8–16-iter chart-chase"** iter.
iter-244 committed to building a *general* concrete strong-monoidal inverse-image pullback (D1 landed
axiom-clean). Before sinking a second iter into D2, I ran the soundness-check protocol: is the expensive build
even necessary? Two analyst passes (api-alignment), the second adversarially scoped, said **NO** — and pinned
two concrete errors in the iter-242/244 reasoning. The project pivots to the locally-trivial-restricted
oplax-δ chart-chase, the blueprint section was rewritten + gate-cleared via the same-iter fast path, and the
substrate prover is dispatched on the cheaper route this iter.

## What I processed (iter-244 outcomes)
- TensorObjSubstrate.lean: **D1 (`pullbackLanDecomposition` + 6 carrier/adjunction decls) landed axiom-clean.**
  → task_done; result file cleared. D1 is now RETAINED off-path (general infra, no longer load-bearing).
- lean-auditor ts244: 0 must-fix; majors = misleading file-header "so" (L43–46) + 34 deprecated `Sheaf.val`
  warnings. Header fix folded into Lane-1 secondary cleanup; `Sheaf.val` deferred (larger polish).
- lean-vs-blueprint ts244: the two flagged D1 blueprint-hygiene items (the `pullbackLanDecomposition` pin; the
  orphaned `tensorObjIsoclassCommMonoid` pin) were ALREADY fixed by the iter-244 review agent — checker report
  was stale on both. No action needed.

## Decision made

**Chosen: ABANDON the iter-244 general strong-monoidal pullback build; PIVOT to the locally-trivial-restricted
oplax-δ chart-chase for the pullback–tensor comparison iso.** Dispatch the substrate prover on it this iter
(D1'–D4' + the `IsInvertible.pullback` corollary), `[prover-mode: mathlib-build]`.

**Why (evidence — two adversarially-scoped analyst passes):**
- **The general build is unnecessary (analyst loctriv-bridge, Q3).** The only consumer of the comparison iso
  is the relative Picard functor, whose carrier `OnProduct` is `{M // IsLocallyTrivial M}`. It needs the iso
  only on locally-trivial (line-bundle) pairs, never general modules.
- **Two concrete errors in the iter-242/244 "general build necessary" reasoning, both confirmed:**
  1. The blocker forward bridge `IsInvertible ⟹ IsLocallyTrivial` IS Mathlib-scale (iter-243 right — no
     finite-presentation spreading-out for SheafOfModules) but is **off the critical path**: the consumer
     carries `IsLocallyTrivial` directly, so only the easy reverse `exists_tensorObj_inverse` is used.
  2. The "δ not an iso (`Γ(ℙ¹,𝒪(1))=0`)" obstruction was MISATTRIBUTED — it concerns the LAX tensorator of
     PUSHFORWARD (a right adjoint / global sections), NOT the OPLAX δ of PULLBACK (a left adjoint). Pullback
     provably preserves local triviality (`IsLocallyTrivial.pullback`, verified axiom-clean this iter), so δ
     IS an iso on locally-trivial objects.
- **The route reuses PROVEN bricks** (`pullbackTensorMap`, `pullbackUnitIso`, `isIso_of_isIso_restrict`,
  `tensorObj_isLocallyTrivial`, `pullbackObjUnitToUnit_comp` — all verified axiom-clean) and has a bounded
  decomposition with the SOLE genuinely-new sub-step (D3') having a proven axiom-clean unit analog.
- **The bridge granularity question (strategy-critic ts244 C3) is resolved (analyst rpf-bridge):** the RPF
  functor's `map_add` needs the comparison ISO (existence form), NOT a bare Prop `IsInvertible.pullback`
  (which leaves `functorial` unconstructible). The loc-triv comparison iso IS that data — modeled
  field-for-field on Mathlib `CommRing.Pic.mapAlgebra`. Consequence: the iter-244 "re-base OnProduct onto
  IsInvertible" carrier-pivot is RETRACTED — RPF stays on `IsLocallyTrivial` (its functor machinery is
  already 0-sorry).

**LOC/risk weighed:** ~200–400 LOC / ~8–16 iters vs 20–38 for the abandoned build — a ~2.5× reduction. The
adversarial check (analyst loctriv-bridge) confirmed the cheap route does NOT secretly re-import either blocked
bridge (forward bridge / concrete inverse-image model). Residual risk: D3' (δ vs base-change-square coherence)
is genuine new mate calculus; bounded, Mathlib-supported, unit analog done.

**Is this rotation-churn? No.** progress-critic ts245 separately judged the iter-244 build CONVERGING (D1 a
load-bearing brick, not orbit churn). The pivot is orthogonal to that verdict: the build WAS progressing, but
on an unnecessarily general problem. This is a one-time, evidence-based reduction triggered by a NEW finding
(the pushforward-lax/pullback-oplax conflation + the consumer-carrier fact), not cosmetic surface-route
rotation. It reuses the bricks the build already produced where applicable and discards only the unstarted
expensive part (D2/D3-general).

**Cheapest reversing signal:** D3' (`pullbackTensorMap_restrict`) proves materially harder than its proven unit
analog `pullbackObjUnitToUnit_comp` — i.e. the tensorator mate calculus does not reduce the way the unit mate
calculus did. Then decompose D3' further (do NOT revive the general Lan build).

## Parallelization (A.1.c.fun) — set up for next iter
RPF stays on `IsLocallyTrivial`; `LineBundlePullback.lean` is already 0-sorry (`OnProduct`,
`IsLocallyTrivial.pullback`, `pullbackAlongProjection` all axiom-clean). The ONE open sorry is
`RelPicFunctor.addCommGroup` (L269), which consumes the loc-triv comparison iso (`map_add`). Next iter:
blueprint-writer pass on `Picard_RelPicFunctor.tex` (full `addCommGroup` spec on the CommRing.Pic template) →
gate → author `addCommGroup` + `PicSharp.functorial` against a typed-sorry bridge on
`pullbackTensorIsoOfLocallyTrivial` (Mathlib-gradient parallelization so A.2.c is not blocked). Not opened this
iter (the RelPicFunctor chapter is `partial`; needs the writer pass first — HARD GATE).

## Subagents dispatched

| Subagent | Slug | Verdict |
|---|---|---|
| progress-critic | ts245 | **Lane A CONVERGING** — iter-244 CHURNING corrective executed; D1 a named load-bearing brick; flat counter by-design; D2 well-scoped. Dispatch-sanity OK (1/10). (Saw the build in isolation; pivot is orthogonal.) |
| mathlib-analogist (api-alignment) | rpf-bridge | RPF `map_add` needs the comparison ISO, NOT a bare Prop; field-for-field on Mathlib `CommRing.Pic.mapAlgebra`. Resolved the bridge-granularity question + surfaced the loc-triv chart-chase direction. |
| mathlib-analogist (api-alignment) | loctriv-bridge | **PIVOT — general build NOT necessary** (adversarially confirmed). Forward bridge Mathlib-scale but off-path; δ-counterexample misattributed; loc-triv comparison iso = chart-chase ~200–400 LOC / 8–16 iters; does NOT re-import the blocked bridges. |
| blueprint-writer | loctriv-pivot | COMPLETE — `sec:tensorobj_pullback_monoidality` rewritten to D1'–D4' + re-routed `lem:isinvertible_pullback`; general-build blocks demoted off-path. No strategy-modifying findings. |
| blueprint-clean | loctriv | PASS — 4 rendered-text strips + 1 Lean-dot fix; Stacks quotes byte-faithful; env 40/40; labels resolve. |
| blueprint-reviewer | loctriv-regate | **HARD GATE CLEARS — TensorObjSubstrate** (D1'–D4' + corollary complete+correct, actionable; demotion coherent; 0 must-fix; 1 soon = stale Route-C prose; 0 unstarted-phase). |

## Subagent skips

- strategy-critic: SKIPPED. STRATEGY.md was edited this iter, but the change is a WITHIN-PHASE
  implementation-route refinement of A.1.c.sub (general build → loc-triv chart-chase), not a global-arc change
  (the Route-A arc to Pic representability is unchanged). The pivot was adversarially validated by analyst
  loctriv-bridge (which read the actual Lean + Mathlib + Stacks — deeper than the strategy-critic's
  fresh-arc read). The strategy-critic's value is on the arc, not the Mathlib tactic; marginal value here is
  low and its directive forbids passing it the analyst evidence. Re-dispatch next iter if the RPF
  parallelization or a deeper route question opens.

## Notes for review agent
- Add the `\uses{lem:pullback_tensor_iso_loctriv}` edge to `lem:rel_pic_sharp_groupoid` in
  `Picard_RelPicFunctor.tex` (blueprint-reviewer loctriv-regate cross-chapter note) when the RPF block is next
  touched.
- Stale prose ("single genuinely-deep residual sorry") in `AbelianVarietyRigidity.tex` proof blocks
  (`lem:rigidity_eqOn_dense_open` et al.) — soon-severity blueprint cleanup; Route C, non-blocking; the chain
  is axiom-clean since iter-162.
- Informational: D3' (`lem:pullback_tensor_map_basechange`) statement `\uses` over-includes
  `lem:pullback_tensor_map_natural` (harmless ghost edge — D3's proof doesn't consume it).
