# Directive: progress-critic — Route B (01I8) convergence over the last 5 iters

## Active route under assessment
**Route B — 01I8 `F ≅ ~(ΓF)` via section-localization** (file:
`AlgebraicJacobian/Cohomology/QcohTildeSections.lean` for the keystone; the B-chain leaves landed in
`AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`). This is the project's critical path: the
02KG top theorems, the P5a vanishing inputs, and the P5b final assembly all gate on it.

## Last-5-iters signals (extracted by the planner)

Project inline-sorry count: **2 → 2 → 2 → 2 → 2** across iters 036–040 (both sorries are
frozen/superseded: dead `CechAcyclic.affine`, frozen P5b `CechHigherDirectImage`). The route's
progress is measured by axiom-clean NEW declarations on the B-chain, not sorry elimination.

| iter | prover status | new axiom-clean decls | milestone | recurring blocker phrase |
|---|---|---|---|---|
| 036 | (Route B setup / B0 consolidation) | — | Route B selected over Route P | — |
| 037 | COMPLETE | +7 | B1 `qcoh_finite_presentation_cover` + B2 `presentationOverBasicOpen` | — |
| 038 | COMPLETE | +8 | B3 **engine** `modulesOverBasicOpenEquivalence` (load-bearing half) | "pushforwardCongr metavariable" (B3 object iso slipped) |
| 039 | **NOOP** (0 provers ran) | 0 | dispatch-phrasing bug (`_SCAFFOLD_RE` keyword) — NOT a math slip | "noop-drop" |
| 040 | COMPLETE | +4 | B3 **object iso** `overBasicOpenIsoRestrict` + B4 `presentationModulesRestrictBasicOpen` (first genuine attempt) | — |

So: every iter that actually RAN a prover (037, 038, 040) closed its named target axiom-clean on (at
worst) the first genuine attempt. The one zero-progress iter (039) was a dispatch-phrasing bug, not a
math/term-mode wall, and was corrected. The B-chain leaves B0–B4 are now all DONE.

## Strategy estimate vs elapsed
- STRATEGY 01I8 row: `Iters left ~2–3` (this iter); the route entered its current section-localization
  phase around iter-036/037 (so ~4 iters elapsed in-phase, B1→B2→B3-engine→B3-objiso+B4).

## This iter's proposed objective (for your dispatch-sanity check)
- **1 file:** `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` — scaffold + build the keystone
  `qcoh_section_isLocalizedModule` (mathlib-build). The decl does not exist yet; it is the leandag
  frontier node (effort 3117, the highest single node).
- **NEW this iter — a soundness flag the planner raised:** the planned span-cover descent
  (`isLocalizedModule_of_span_cover`) may UNDER-SCOPE the keystone — discharging its per-`gⱼ`
  hypothesis appears to need `Γ(D(gⱼ),F)≅Γ(X,F)_{gⱼ}` (the sheaf-gluing/Čech-H⁰ step), which the 5
  listed `\uses` don't supply. The planner is dispatching a mathlib-analogist THIS iter to resolve the
  route BEFORE finalizing the keystone objective.

## Your question
Is Route B **CONVERGING**, or is the keystone about to become a churn/stall risk? In particular:
1. Given the B-chain leaves all landed monotonically (no helper-churn — each iter closed a distinct
   named target, blockers evolved and did not recur), is the route on track?
2. Is the planner's iter-041 move — surfacing the keystone soundness risk and consulting the analogist
   to resolve the descent route BEFORE dispatching the deep keystone prover — the right de-risking, or
   is it over-caution that should instead just dispatch the prover? (Consider: the keystone is effort
   3117, the highest node, and everything downstream gates on it; a wrong route burns a deep lane.)
3. Any signal that the keystone will recur as a blocker (e.g. the "section comparison" being repeatedly
   hand-waved across bridge.md → STRATEGY → here)?

Verdict per route (CONVERGING / CHURNING / STUCK / UNCLEAR) with the corrective TYPE if not CONVERGING.
