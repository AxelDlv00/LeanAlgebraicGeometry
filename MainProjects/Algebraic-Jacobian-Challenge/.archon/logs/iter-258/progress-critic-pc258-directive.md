# progress-critic pc258 — convergence audit (iter-258 plan phase)

Assess each active route's trajectory over the last 4–5 iters. Verdict per route
(CONVERGING / CHURNING / STUCK / UNCLEAR) + dispatch-sanity on the proposed objectives.

## Route TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean`
Phase: A.1.c.sub, active ~24 iters. Strategy Iters-left: ~6–11.
Signals (sorry count / status / helpers / blocker):
- iter-253: 2→2 PARTIAL — homOfLocalCompat hf re-sign; blocker "restrictScalars carrier bridge".
- iter-254: 2→2 PARTIAL — homOfLocalCompat sub-step (a) closed, M-leg; same blocker.
- iter-255: 2→2 PARTIAL — homOfLocalCompat M-leg closed; residual = one f-leg smul bridge.
- iter-256: 2→1 — **homOfLocalCompat CLOSED axiom-clean** (5-iter streak broken).
- iter-257: 1→2 PARTIAL (decomposed) — `dual_restrict_iso` Step-4 → new helper `sliceDualTransport`
  (signature VERIFIED, body sorry). NOT closed: ~200 LOC sectionwise build + a decisive cross-lane
  compilation race (this file imports TensorObjSubstrate.lean which the concurrent TS-cmp lane kept
  broken most of the session → LSP returned empty goals). Recurring NEW finding: the genuine route is
  to build the SHARED ROOT `SheafOfModules.overEquivalence` (see below), which subsumes the sectionwise
  build and also closes the engine.

## Route TS-cmp — `Picard/TensorObjSubstrate.lean` (D3′ `pullbackTensorMap_restrict`)
Phase: A.1.c.sub, active ~24 iters. Strategy Iters-left: ~6–11.
Signals:
- iter-254: 3→2 PARTIAL — D1′ δ_natural carrier wall.
- iter-255: 2→1 — **D1′ CLOSED axiom-clean**.
- iter-256: 1→2 PARTIAL — D3′ mirror recipe DISPROVEN; scaffold + ROADMAP.
- iter-257: 2→2 PARTIAL — closed only `toRingCatSheafHom_comp_hom_reconcile` (found to be `rfl`, a
  triviality). The genuine Sq2 content ("Sq2b" = monoidality of `pullbackComp` / δ-transport of
  `leftAdjointCompIso`) is **Mathlib-absent**; its very statement is blocked by 3 documented frictions
  (CommRingCat/forget₂ monoidal-instance pin on `δ (pullback φ')`; `(F:=F⋙G)` factorization +
  associativity defeq; reconciliation defeq not firing at `.app`). Negative Mathlib search. Prover named
  the template to port: `CategoryTheory.Adjunction.isMonoidal_comp` (mate calculus).
  Recurring blocker phrase across iter-256/257: "pullbackTensorMap is a 4-fold composite; the monoidality
  of pullbackComp is the irreducible Mathlib-absent step."

## Route engine — `Picard/LineBundleCoherence.lean`
Phase: A.2.c-engine, fresh (2 iters). Strategy Iters-left (engine row): large but this entry ~3–6.
Signals:
- iter-256: scaffold, 5 sorry, site instances confirmed present.
- iter-257: **5→1** — four bodies closed axiom-clean (+ reusable bricks); sole remaining sorry
  `chartOverIso` = the SHARED ROOT `SheafOfModules.overEquivalence` (same wall as TS-inv).

## SHARED ROOT (the iter-258 pivot) — NEW lane, not started
`SheafOfModules.overEquivalence`: modules-level lift of `Opens.overEquivalence`, ring-sheaf transported.
Both the engine `chartOverIso` and the dual `sliceDualTransport` reduce to it (two independent prover
task results converged on this). ~200–350 LOC, new file. Proposed as the iter-258 PRIMARY lane
(mathlib-build mode).

## Proposed iter-258 objectives (dispatch-sanity check these)
1. NEW `Picard/SheafOverEquivalence.lean` — mathlib-build the shared root `SheafOfModules.overEquivalence`.
2. `Picard/TensorObjSubstrate.lean` — D3′ Sq2b — ONLY if a cross-domain analogist returns a concrete
   `isMonoidal_comp`-porting recipe this iter; else HELD for the analogist round.
HELD this iter: `DualInverse.lean` (gated on shared root + avoids the import race), `LineBundleCoherence.lean`
(1 sorry from done, gated on shared root).

## Questions for you
- Is the TS-inv "build the shared root instead of grinding sliceDualTransport sectionwise" a sound
  re-route or a route-pivot that needs flagging? (The sectionwise helper was signature-verified, not
  reversing-signalled.)
- Is TS-cmp D3′ CHURNING/STUCK? It has closed only a `rfl` triviality in 2 iters on the genuine content;
  the real step is Mathlib-absent monoidality. Should it hold for the analogist round rather than
  re-dispatch?
- Dispatch-sanity on the proposed 1–2 lanes (file count, import-independence, the no-concurrent-edit+import
  lesson from iter-257's race).
