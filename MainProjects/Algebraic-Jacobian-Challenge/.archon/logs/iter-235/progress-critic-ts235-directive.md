# Progress-critic directive — iter-235

Assess convergence of the two active prover routes below. Verdict per route
(CONVERGING / CHURNING / STUCK / UNCLEAR). Use ONLY the signals provided.

## Route 1 — d.2 critical path: `Picard/TensorObjSubstrate/StalkTensor.lean`

Goal of the route: build `stalkTensorIso : (A⊗ᵖB).stalk x ≅ A.stalk x ⊗_{R.stalk x} B.stalk x`
(varying-ring stalk-tensor commutation), the SOLE remaining bottleneck for the relative-Picard
group law's associator. Mode: mathlib-build (no sorry pins — each step fully proved or absent).
Built bottom-up in 5 named stages (i)–(v); (v) `stalkTensorIso` is the deliverable.

Signals (last 4 iters; file created iter-233):
- iter-231: route did not exist (pre-carrier-pivot; the file's predecessor was a 14-iter dual stall).
- iter-232: file did not exist (carrier pivot + file-split iter).
- iter-233: file CREATED. +7 axiom-clean decls (forward comparison map `stalkTensorDesc` + 6 helpers).
  Stages (i)–(ii). Status: done. Sorry count 0→0. Blocker phrase: "reverse map (iv) ~150–250 LOC,
  no Mathlib shortcut".
- iter-234: +4 axiom-clean decls (`stalkTensorDescU_smul`, `stalkTensorDesc_germ`,
  `stalkTensorLinearMap`, `stalkTensorLinearMap_germ_tmul`). Stage (iii) — the explicit convergence
  probe imposed by iter-233's review ("land `stalkTensorLinearMap` this round") — MET. Status: done.
  Sorry 0→0. Named obstacle (CommRingCat/RingCat carrier-duality) identified AND resolved; route's
  stated risk retired. Blocker phrase for next step: "stage (iv) reverse map = nested colimit descent,
  ~150–250 LOC, `TensorProduct.directLimit`/`Module.DirectLimit` confirmed ABSENT — built by hand".
- Helpers/decls per iter: 7, then 4. Sorry: 0→0→0 (mathlib-build invariant).
- Proposed iter-235 objective: dispatch ONE prover lane to build stage (iv) (the reverse map
  `stalkTensorRev`) as the next unit, then stage (v) bundle if reached.

## Route 2 — engine parallel lane: `Cohomology/FlatBaseChange.lean`

Goal: `affineBaseChange_pushforward_iso` (i=0 flat base change, Stacks 02KH), via an affine
Spec/tilde pushforward/pullback dictionary. Mode: mathlib-build.

Signals (last 4 iters):
- iter-231: file did not exist.
- iter-232: file CREATED. +1 axiom-clean decl (`pushforwardBaseChangeMap`, the adjoint-mate base-change
  map). `affineBaseChange_pushforward_iso` PARTIAL (typed sorry at section-iso step). Sorry 0→1 (orphan
  file, uncounted then). Status: done.
- iter-233: +3 axiom-clean locality lemmas (`Modules.isIso_*`); affine lemma's first reduction wired.
  File wired into canonical build (+2 sorries now counted). Status: done.
- iter-234: 0 decls committed. Attempted Γ-fragment `moduleSpecΓFunctor_pushforward_tilde_iso`;
  skeleton typechecks but `map_smul'` BLOCKED on a typeclass-instance wall (intermediate
  `Module.compHom`/`restrictScalars` actions unnameable). Not committed. Sorry 2→2. Status: done
  (zero-commit). Blocker phrase: "instance wall — buried Γ-actions not synthesizable"; and a STANDING
  note from the prover: "even if the Γ-fragment closes, `affineBaseChange_pushforward_iso` does NOT
  close — still needs object-level quasi-coherence-of-pushforward (Mathlib-ABSENT), pullback dictionary,
  fibre-product identification, and `cancelBaseChange` match. Multi-brick engine build."
- Decls per iter: 1, 3, 0. Sorry: 1→2→2.
- Proposed iter-235 objective: continue with the prover's recommended element-free route (route 2:
  `restrictScalarsComp'App` + `ΓSpecIso_inv_naturality`), whose concrete next step is digging the
  pushforward ring map `ψ` out of `SheafOfModules.pushforward` internals.

## Strategy estimates (verbatim from STRATEGY.md `## Phases & estimations`)
- A.1.c.SubT (Route 1, d.2): Iters left ~4–7; LOC `~250–450 · ~0/it`; entered current (carrier-pivot/d.2)
  phase iter-232/233.
- A.2.c-engine (Route 2, FlatBaseChange seed): Iters left ~30–60 (whole engine); LOC `~3400–5500 · 0/it`;
  FlatBaseChange seeded iter-232.

## This iter's `## Current Objectives` proposal
2 files: `StalkTensor.lean` (Route 1, stage iv), `FlatBaseChange.lean` (Route 2, element-free route).

Key questions for you:
1. Is Route 1 (d.2) CONVERGING or churning? It has produced axiom-clean forward motion 2 consecutive
   iters (forward map → linear packaging), 0 sorries throughout, with each iter's named risk identified
   and retired — but the deliverable iso is still 1–2 stages away and the absolute sorry counter on the
   group law has not moved since iter-217. Distinguish "large genuine infra build progressing" from
   "helper-churn that never converges".
2. Is Route 2 (FlatBaseChange) churning/stuck? It produced 0 commits last iter and the prover's own note
   says the current brick is both blocked (instance wall) AND insufficient (needs a Mathlib-absent QC
   brick downstream regardless). Name the corrective TYPE if CHURNING/STUCK.
