# progress-critic directive — ts229

## Active route under consideration for this iter's prover dispatch

### Route: A.1.c.SubT — ⊗-group-law / dual block (file `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`)

This is the SOLE ungated prover lane (every other lane is paused by a standing USER
ROUTE-C directive or gated behind this substrate). The route is building the ⊗-inverse
(`exists_tensorObj_inverse`, project sorry 80→79) for a by-hand `CommGroup` on
locally-trivial 𝒪_X-module iso-classes, via a "descent re-route" committed at iter-219.

- **Phase entered:** iter-219 (descent re-route committed).
- **STRATEGY.md `Iters left` (current, FROZEN):** ~3–4 (3 discrete pieces: C-bridge, A-engine, final assembly).
- **Elapsed in phase:** 10 iters (219–228).

**Per-iter signals (last 5 iters), format = project-sorry-count · helpers-added · status · blocker:**

- iter-224: 80 · +1 (internalHomEval naturality closed) · PARTIAL · blocker: Over.map coherence
- iter-225: 80 · +1 (`Scheme.Modules.dual` axiom-clean) · PARTIAL · blocker: descended `dual_eval` was sorry-transitive through abandoned d.2 stalk-⊗ → removed
- iter-226: 80 · +1 (`isIso_of_isIso_restrict` B-connector) · PARTIAL · blocker: A + C bridges still remain (B was OFF critical path)
- iter-227: 80 · +3 (`homMk`, `toPresheaf_map_homMk`, `restrictScalarsRingIsoDualEquiv`) · PARTIAL · blocker: A-engine `homOfLocalCompat` is a ~120–190 LOC build (build SIZE, not d.2); C-probe returned "d.2-free"
- iter-228: 80 · +3 (`dualPrecompEquiv`, presheaf `dualIsoOfIso`, sheaf `dualIsoOfIso`) · PARTIAL · **HARD BLOCK**: the C-bridge `dual_isLocallyTrivial` is GENUINELY blocked. Its blueprint "verbatim mirror of the closed tensor restrict-iso" claim was **empirically falsified** (read off via `lean_goal`): the dual is the SLICE internal-hom, not a sectionwise `restrictScalars`-image, so closing it needs a Mathlib-absent open-immersion **slice-site equivalence (~150–300 LOC)** — NOT the pre-built `restrictScalarsRingIsoDualEquiv`. The prover did NOT stub it.

**Net:** project sorry counter flat at 80 across the entire phase (219–228); each iter lands
axiom-clean helpers but `exists_tensorObj_inverse` (80→79) never closes. The iter-228 hard-block
is the new datum: the last "cheap" remaining piece (C-bridge) turned out to be large, so cost grew.

### This iter's proposed prover objective (PROGRESS.md `## Current Objectives`)

- **1 file:** `Picard/TensorObjSubstrate.lean` — PIVOT the route's PRIMARY prover focus from the
  now-confirmed-blocked C-bridge to the **unblocked, never-yet-primary A-engine `homOfLocalCompat`**
  (mathlib-build mode: build the load-bearing `localSection` sub-piece, then assemble
  `homOfLocalCompat` as far as axiom-clean). The C-bridge (slice-site equivalence) is deferred this
  iter pending a structural mathlib-analogist consult on the cleanest construction technique. No new
  sorry to be pinned. All other lanes correctly HELD/paused.

## Your task

Return a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR). Specifically assess:
1. Is the proposed pivot to the A-engine (a DIFFERENT, never-primary sub-piece, on the critical
   path, bounded, independent of the C blocker) genuine forward progress, or is it another
   helper-on-the-same-wall in disguise?
2. Given the falsified C estimate and 10-iter flat counter, name the corrective TYPE you'd
   prescribe (blueprint expansion / Mathlib-idiom consult / structural refactor / route pivot).
3. Dispatch-sanity: 1 file, ≤ cap, all other lanes held — flag any concern.
