# Progress-critic directive — iter-248

Assess convergence per route. Two active routes. Signals extracted by the planner below.

---

## Route TS — `Picard/TensorObjSubstrate.lean` (A.1.c.sub critical path)

**Goal of route:** prove the pullback–tensor comparison iso `f^*(M⊗N) ≅ f^*M ⊗ f^*N` on
locally-trivial (line-bundle) pairs (decl chain D2'→D3'→D4' funnelling through a landed reduction
brick), yielding `IsInvertible.pullback`. The current sub-goal is D2' = the η-bridge
`IsIso (a_Y.map (η (pullback φ')))`.

**Strategy estimate:** Iters-left = ~7–15. Route (loc-triv chart-chase) ENTERED at iter-245
(so 3 iters elapsed in this route: 245, 246, 247).

**Per-iter signals (last 5 iters):**
- iter-243: route-shape decisions (pre-pivot); 1 brick (`sheafifyTensorUnitIso`). PARTIAL.
- iter-244: D1 general-build (`pullbackLanDecomposition` + 6 decls) landed axiom-clean, then ABANDONED
  as off-path by the iter-245 pivot. PARTIAL.
- iter-245: pivot to loc-triv route; landed reduction brick `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`
  + 1 helper (2 axiom-clean decls). Reduced target to `IsIso (a_Y.map δ)`. Canonical sorry 2→2. PARTIAL.
- iter-246: D2' δ-wrapping + assembly (4 axiom-clean decls). Reduced target to the η-bridge
  `IsIso (a_Y.map η)`. Canonical sorry 2→2. PARTIAL.
- iter-247: η-bridge helpers `presheafUnit_comp_map_eta` + `isIso_sheafifyEta_of_unitSquare`
  (2 axiom-clean decls). Reduced target to a SINGLE morphism equation (the "square" `hsq`) with a
  paper-complete 7-step telescope where every step is a named existing Mathlib lemma. Canonical
  sorry 1→1 (the 2→1 drop was a refactor deleting a dead stub, not a proof). PARTIAL.

**Helpers added per iter:** 1, 6(abandoned), 2, 4, 2.
**Canonical critical-path sorry-elimination:** 0 across all 5 iters (the two deferred sorries
`exists_tensorObj_inverse`, group-law placeholders, unchanged — by design the payoff closes only at D4').
**Recurring blocker phrase:** "reduced to a single named residual; defeq-laden manual mate-telescope
across 3 nested adjunction layers; every lemma exists; could not encode the full telescope within budget;
no Mathlib gap." This is the 3rd consecutive named-residual PARTIAL with no goal closure.

**Note for your verdict:** the iter-247 prover left NO sorry pin (mathlib-build mode) but captured a
complete 7-step recipe (each step a named Mathlib lemma: `unit_naturality`,
`homEquiv_leftAdjointUniq_hom_app`, `comp_unit_app`, `leftAdjointOplaxMonoidal_η`,
`presheafUnit_comp_map_eta`). The blocker is described as long mechanical defeq-laden labor, NOT a
missing ingredient. The planner is weighing: switch the lane from `mathlib-build`/`prove` to
`fine-grained` mode + expand the blueprint to make the 7 telescope steps atomic named lemmas (execute,
don't re-reduce), vs a structural pivot. Name the corrective TYPE you recommend.

---

## Route RPF — `Picard/RelPicFunctor.lean` (A.1.c.fun)

**Goal of route:** the relative Picard functor group law on locally-trivial iso-classes; `addCommGroup`
real modulo the upstream reverse bridge; eventually `functorial`/`PicSharp` real.

**Strategy estimate:** Iters-left = ~7–12. Route ENTERED at iter-246 (2 iters elapsed: 246, 247).

**Per-iter signals:**
- iter-246: built `addCommGroup` modulo 4 LOCAL typed-sorry bridges (recipe was infeasible — import
  cycle; substrate lived downstream). Local sorry 1→4. PARTIAL (architectural diagnosis, not keepable
  proof).
- iter-247: import cycle broken by a refactor; rewired all 4 bridges to the upstream substrate. Local
  sorry 4→0 (only 1 cone sorry remains = upstream `exists_tensorObj_inverse`). `isLocallyTrivial_unit`
  closed with a real axiom-clean proof. `functorial`/`PicSharp` left as stubs — genuinely gated on the
  not-yet-landed Lane TS D4' (`pullback_tensor_iso_loctriv`). RESOLVED to the convergence target (sorry ≤1).

**Helpers added per iter:** n/a (rewire/cleanup). **Local sorry:** 1→4→0.
**Recurring blocker phrase:** none new; the only remaining work (`functorial`, `PicSharp` real body) is a
genuine cross-file dependency on Lane TS D4', not a within-file blocker.

**Note:** a fresh lean-auditor found 2 must-fix items in RPF (an excuse-comment "sorry-free placeholder"
on the load-bearing `PicSharp` PUnit-stub, and stale/factually-wrong module-header status claims). These
are doc/comment fixes (the real `PicSharp` upgrade is itself gated on D4'). The planner proposes a small
RPF cleanup lane this iter to fix those must-fix items honestly.

---

## This iter's proposed objectives (dispatch-sanity)
1. `Picard/TensorObjSubstrate.lean` — Lane TS, the D2' η-bridge square `hsq` via the 7-step telescope
   [proposed mode: fine-grained, after a blueprint-writer expands the telescope into atomic sentences].
2. `Picard/RelPicFunctor.lean` — Lane RPF, fix the 2 must-fix doc/excuse-comment items honestly;
   `functorial`/`PicSharp` real body HELD on Lane TS D4'.

2 files, within the 10 cap, independent files.

Give per-route verdicts (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any CHURNING/STUCK, name the
corrective TYPE.
