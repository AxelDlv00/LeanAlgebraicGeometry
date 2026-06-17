# Progress-critic directive — iter-242

Assess convergence per active route. Two routes under consideration for this iter's prover dispatch.

## Route A — `Picard/TensorObjSubstrate.lean` (A.1.c substrate: `IsInvertible.pullback`)

Phase entered (A.1.c substrate, Route Z): iter-238. STRATEGY `Iters left` for A.1.c: ~5–9.

Signals (last 4 iters), this sub-lane (the `IsInvertible.pullback` Route-Z substrate, NOT the deferred dual-bridge sorries):
- iter-238: `picCommGroup` (group law) landed axiom-clean. PARTIAL. helpers +9 (group law). active-sub sorry n/a.
- iter-239: sectionwise-`extendScalars` substrate recipe found DEAD; 1 brick `sheafifyTensorUnitIso` landed. PARTIAL. helpers +1. Phase-1 NOT closed.
- iter-240: 2 coherence linchpins landed axiom-clean (`pullbackObjUnitToUnit_comp` = blueprint's "genuinely-new ingredient", `unitToPushforwardObjUnit_comp`). PARTIAL. helpers +2. `pullbackUnitIso` blocked on a Lean TC-resolution accident (no sorry pin).
- iter-241: **Phase-1 PRIMARY `pullbackUnitIso` LANDED axiom-clean** + 3 reusable bricks. PARTIAL (primary closed). helpers +4. Finding: chart-chase was unnecessary (representable-flatness ⇒ pullbackObjUnitToUnit iso for ALL f).
- File sorry count: 2 → 2 → 2 → 2 (the two are pre-existing DEFERRED dual-bridge sorries, off the active sub-lane; the active work is sorry-free new declarations).
- Recurring blocker phrase: "genuine Mathlib-absent build, no comparison map" for Phase 2 (`pullbackTensorIso`). Appears iter-239 (as the dead recipe) and iter-241 (Phase 2 absent: no tensor-pullback comparison, no `MonoidalCategory (SheafOfModules)`).

Proposed iter-242 objective for this file: build Phase 2 `pullbackObjTensorToTensor` comparison map + attempt the iso, `[prover-mode: mathlib-build]`. This is a NEW target (Phase 1 just closed); it is a genuine Mathlib-absent multi-hundred-LOC engine build per the iter-241 handoff.

## Route B — `Cohomology/FlatBaseChange.lean` (A.2.c-engine: flat base change i=0)

Phase entered (A.2.c-engine, FlatBaseChange sub-lane): ~iter-233. STRATEGY `Iters left` for A.2.c-engine: ~30–60.

Signals (last 4 iters):
- iter-236: 3 axiom-clean Γ-fragment decls. PARTIAL. helpers +3. sorry 2.
- iter-239: 2 bricks (`gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`); `hloc` open. PARTIAL. helpers +2. sorry 2→3 (new pinned decl).
- iter-240: 4-iter `Module.compHom` carrier wall BROKEN via `algebraize`; residual moved within the decl to `hsq`. PARTIAL. helpers +0. sorry 3→3.
- iter-241: **`pushforward_spec_tilde_iso` CLOSED axiom-clean** (sorry 3→2). One-line structural refactor (`eqToIso`→`restrictScalarsCongr`). PARTIAL (sorry eliminated). helpers +0.
- Recurring blocker phrase (iters 237–240): `restrictScalarsComp'App` rewrite-matching / carrier wall — now RESOLVED.

Proposed iter-242 objective for this file: build the pullback-of-tilde affine dictionary `pullback (Spec.map φ)(tilde M) ≅ tilde (R'⊗_R M)` (the affine companion of the now-closed `pushforward_spec_tilde_iso`), feeding `affineBaseChange_pushforward_iso`. `[prover-mode: mathlib-build]`. NEW Mathlib-absent target (~hundreds LOC), per iter-241 handoff.

## What I need from you
1. Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR).
2. Both routes closed their primary residual THIS iter (Route A: `pullbackUnitIso`; Route B: `pushforward_spec_tilde_iso`). Both now face a fresh Mathlib-absent multi-hundred-LOC build. Is dispatching a prover (mathlib-build) on each the right move, or does either warrant a design/idiom pass first? Name the corrective TYPE if not CONVERGING.
3. Dispatch-sanity on the 2-file proposal (within cap, not a verbatim repeat of a walled approach).
