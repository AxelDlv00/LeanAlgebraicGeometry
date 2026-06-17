# Progress-critic directive — iter-249

Assess convergence of the project's single active prover route. One block below.

## Route TS — `Picard/TensorObjSubstrate.lean` (A.1.c.sub, the loc-triv pullback–tensor comparison iso = critical path)

This is the ONLY active prover lane. Every other lane (RelPicFunctor, FlatBaseChange, Albanese, RR.*) is gated downstream of it or PAUSED, so there is no parallel route to assess.

### Strategy estimate (from STRATEGY.md `## Phases & estimations`)
- Phase: "A.1.c.sub — comparison iso on line bundles (loc-triv-restricted)".
- **Iters left (estimate): ~7–15.**
- The route has been the active critical path continuously across the window below (≥6 iters); it did not just enter this phase.

### Last 5 iters — extracted signals (244 → 248)

| iter | prover status | file sorry (TS) | canonical critical-path sorry | new decls / "helpers" added | residual after the iter | recurring blocker phrase |
|---|---|---|---|---|---|---|
| 244 | PARTIAL | 1 | flat | (δ-route reduction work) | `IsIso (a_Y.map δ)` | "recipe complete, cannot encode within budget" |
| 245 | PARTIAL | 1 | flat | +1 (reduction brick `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`) | reduced to sheafified δ | "recipe complete, cannot encode within budget" |
| 246 | PARTIAL | 1 (→1) | flat | +4 (δ-wrapping decls) | reduced to η-bridge `IsIso (a_Y.map η)` | "recipe complete, cannot encode within budget" |
| 247 | PARTIAL | 1 | flat | +2 (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`) | reduced to single "unit square" equation | "recipe complete, cannot encode within budget" |
| 248 | PARTIAL | 1 → 2 | flat | +3 (★ `compHomEquivFactor`, ★ `leftAdjointUniqUnitEta`, + `rfl` linchpin `sheafificationCompPullback_eq_leftAdjointUniq`) + assembly + D2′ closer | reduced to ONE concrete (∗∗) residual inside `pullbackEtaUnitSquare` | NEW: "2/3 ★ atomic steps CLOSED; one (∗∗) bookkeeping residual; step-7 blueprint block ill-typed" |

### What changed at iter-248 vs the 244–247 pattern
- iters 244–247: each iter reduced the residual one level and landed axiom-clean *helpers*, but **closed no atomic obligation outright** — the pattern the prior verdict (ts248 = STUCK) named.
- iter-248: the route was switched to `fine-grained` on a freshly-atomized telescope. Result: **2 of 3 ★ abstract adjunction mate-lemmas closed axiom-clean** (`compHomEquivFactor`, `leftAdjointUniqUnitEta`), AND the 5-iter "3-layer adjunction defeq wall" hypothesis was **retired** — the linchpin `sheafificationCompPullback_eq_leftAdjointUniq` holds by `rfl`. The 3rd ★ step (`epsilonPresheafToSheafUnit`) was NOT closed because its blueprint statement is ill-typed (uses a sheaf-level `Functor.LaxMonoidal.ε` that has no Mathlib instance at the pin).
- Net: file sorry +1 (a new scoped (∗∗) at L1672), canonical critical-path sorry count **still flat** (no Picard cone sorry eliminated) — 10th consecutive flat iter.

### This iter's (249) proposed objective — for your dispatch-sanity check
- **1 file: `Picard/TensorObjSubstrate.lean`** — mode `prove`. Plan-side prerequisites first (blueprint-writer retypes step-7 `lem:epsilon_presheaf_to_sheaf_unit` to a `.val`-level identity + adds a block for the `rfl` linchpin; blueprint-clean; fast-path scoped re-review). Then ONE `prove` pass on the single (∗∗) residual inside `pullbackEtaUnitSquare`, which closes D2′ (`pullbackTensorMap_unit_isIso`). Secondary: fix one stale module-status docstring (lean-auditor major).
- **No second lane** dispatched: RelPicFunctor is gated cross-file on D4′ (which needs D2′→D3′→D4′ first); D3′ is in the SAME file as D2′ so cannot be a parallel lane.

### Question for you
Is route TS **CONVERGING** (iter-248's two ★ closures + the `rfl` linchpin are genuine sorry-elimination that broke the STUCK pattern, and one bounded `prove` pass after the blueprint retype is a reasonable expectation to close D2′) — or is iter-248 the **fifth instance of the same "reduce one level, close nothing canonical" pattern dressed up** (canonical counter flat for a 10th iter; file sorry actually went UP)?

If you judge CHURNING/STUCK, name the corrective TYPE precisely (blueprint expansion / Mathlib-idiom consult / structural refactor / route pivot) — the plan agent has already done the iter-248 corrective (atomize + fine-grained), so a repeat of that is not available; say what is materially different. Also flag whether the proposed single-lane dispatch is sound given no parallel route exists.
