# Progress-critic directive — iter-265

Assess convergence per active route from the extracted signals below. Three active prover routes are
under consideration for iter-265 dispatch. For each: CONVERGING / CHURNING / STUCK / UNCLEAR, and for
CHURNING/STUCK name the corrective TYPE (blueprint expansion / Mathlib-idiom consult / structural
refactor / route pivot / decompose-into-named-sublemmas).

K = last 5 iters of signals.

## Route DUAL — `Picard/TensorObjSubstrate/DualInverse.lean`
Target: `sliceDualTransport` (a hand-built `≃ₗ` with 7 fields) → `dual_restrict_iso` → unblocks the RPF
group inverse. The decl-level sorry count for the whole file has been flat at 2, but the target decl is a
monolithic `≃ₗ` whose fields close one at a time (the "internal holes" metric).

Signals (iter / status / internal-holes of sliceDualTransport / decl-sorry / what closed):
- iter-260: PARTIAL · — · 2 · route-1 proved structurally insufficient; route-2 sanctioned (nothing closed)
- iter-261: PARTIAL · 7 · 2 · leg-A built (categorical `.map`); module-instance wall resolved
- iter-262: PARTIAL · 7→6 · 2 · leg-B codomainMap closed (2 new axiom-clean decls)
- iter-263: PARTIAL · 6→5 · 2 · `map_add'` field closed axiom-clean
- iter-264: PARTIAL · 5→4 · 2 · `map_smul'` field closed axiom-clean
- Recurring phrase: "decl-sorry flat at 2" (artifact of the monolithic `≃ₗ`); internal holes strictly
  decreasing 7→6→5→4 each iter.
- Helpers added per iter: +2 (262), then in-place field closes (263, 264).
- Remaining fields: `naturality`, `invFun` (the linchpin), `left_inv`, `right_inv`.
- STRATEGY Iters-left for this phase (A.1.c.sub): ~8–14. Phase entered ~iter 239.

## Route D3PRIME — `Picard/TensorObjSubstrate.lean` (Sq1 tail)
Target: `sheafificationCompPullback_comp_tail` (private helper carrying the Sq1 residual) → feeds D3′
`pullbackTensorMap_restrict` → D4′ → RPF comparison iso.

Signals (iter / status / file-sorry / what closed / blocker phrase):
- iter-261: PARTIAL · 2→3 · opened `pullbackTensorMap_restrict`, extracted Sq1 · "R1/R5 tail"
- iter-262: PARTIAL · 3→3 · R0-peel (1 helper) · "R1/R5 collapse tail"
- iter-263: PARTIAL · 3→3 · main lemma closed, residual relocated to a tail helper; transposition route
  proved circular · "R1/R5 collapse tail"
- iter-264: PARTIAL · 3→3 · step-1 recovery brick `leftAdjointUniqUnitEta_app` (axiom-clean) + step-0
  structural setup landed · "R1/R5 collapse tail" / now refined to "presheaf↔sheaf forget/pushforward
  compatibility bridge feeding the recovered units"
- file-sorry FLAT at 3 for 4 consecutive iters.
- Helpers added per iter: +1 each (R0-peel 262, tail helper 263, leftAdjointUniqUnitEta_app 264).
- A mathlib-analogist consult (ma-d3264) already produced a concrete 6-step recipe; the prover got
  through steps 0–1 in iter-264, steps 2–5 (the mate-calculus assembly) remain.
- A lean-vs-blueprint check this iter found the blueprint's Sq1-tail micro-assembly UNDER-SPECIFIED
  (names the route but omits the explicit 5-step ordering) and `leftAdjointUniqUnitEta_app` blueprint-invisible.
- STRATEGY Iters-left for this phase (A.1.c.sub): ~8–14. Phase entered ~iter 239.

## Route ENGINE — `Cohomology/CechHigherDirectImage.lean`
Target: functor laws `pushPullMap_id`/`pushPullMap_comp` → assemble `pushPullFunctor` → `CechNerve`.
De-coupled from D3′ (uses only Mathlib pseudofunctor coherences). Dominant rate-limiter pole.

Signals (iter / status / file-sorry / what closed):
- iter-261: NEW · scaffolded (5 sorry + 1 def)
- iter-262: PARTIAL · 5→4 · 3 axiom-clean decls (nerve→complex plumbing)
- iter-263: PARTIAL · 4→4 · `pushPullObj`/`pushPullMap` (+2 axiom-clean defs)
- iter-264: PARTIAL · 4→4 · `pushPullMap_id` LANDED axiom-clean (the identity functor law)
- Real axiom-clean decls landing every iter; file-sorry flat at 4 because the 4 are infra-gated
  downstream sorries, not the active target.
- Next target `pushPullMap_comp` (pentagon law): route documented, the key ingredient
  `pseudofunctor_associativity` verified present/typechecks; blocker is proof length (~150 LOC), not a gap.
- STRATEGY Iters-left for this phase (A.2.c-engine): ~85–140 (dominant pole). Lane opened ~iter 261.

## My proposed iter-265 objectives (3 files)
1. `DualInverse.lean` [fine-grained] — open `invFun` (linchpin) + `naturality` (with the now-named ε-helper).
2. `TensorObjSubstrate.lean` [fine-grained] — DECOMPOSE the Sq1 tail into per-step named sub-lemmas
   (the 5th-PARTIAL corrective), extracting the presheaf↔sheaf compatibility bridge first.
3. `CechHigherDirectImage.lean` [mathlib-build] — close `pushPullMap_comp`, assemble `pushPullFunctor`,
   attempt `CechNerve`.

Dispatch-sanity: 3 files, all within cap. Confirm the D3PRIME corrective TYPE and whether DUAL/ENGINE
are genuinely converging or masking a stall.
