# Progress-Critic Directive

## Slug
ts220

## Active route under assessment

**Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`** (the sole productive Route A
prover lane). This lane entered a NEW, deliberately-committed sub-phase at iter-219:
**A.1.c.SubT.dual** — a funded `mathlib-build` of the Mathlib-absent *sheaf internal hom of
𝒪_X-modules* (the `⊗`-inverse's missing primitive). Strategy's `Iters left` estimate for this
sub-phase: **~6–12 iters** (it entered the phase at iter-219, so it is at elapsed iter 1 of ~6–12).

This is NOT a "fill a sorry" lane right now — it is an infrastructure build whose explicit success
metric per the `mathlib-build` contract is *axiom-clean reusable bricks + a precise handoff*, NOT
sorry-count reduction. The block lands a sorry-elimination (`exists_tensorObj_inverse`) only at its
END (~iter 6–12). I want your fresh-context read on whether the build is genuinely CONVERGING
(each iter lays a real, reusable, named brick toward the target with a shrinking residual of
unbuilt sub-steps) versus CHURNING (helpers accumulate but the target stays equally far away).

### Last 5 iters' signals (Lane TS)

| Iter | Prover status | sorry (project) | New axiom-clean decls | Blocker / shape |
|---|---|---|---|---|
| 215 | PARTIAL | 81 | `restrictScalarsRingIsoTensorEquiv` + H2-core start | building restrict-iso substrate |
| 216 | PARTIAL (make-or-break NEGATIVE) | 81 | 6 (ModuleCat H2 core) | free-cover-avoids-H1 refuted; H1 on critical path |
| 217 | **COMPLETE** (linchpin closed) | **81→80** | 5 (H1 presheaf pushforward adj + H2 strong-monoidal) | closed `tensorObj_restrict_iso` |
| 218 | INCOMPLETE (pre-committed gate) | 80 | 0 (docstring edits only) | `exists_tensorObj_inverse` needs Mathlib-absent dual; gate fired as designed |
| 219 | PARTIAL (mathlib-build, 1st sub-step) | 80 | **11** (value module `homModule`/`internalHomObjModule` + helpers) | full presheaf assembly is next chunk; precise handoff given |

Helpers-added rate: 215≈3, 216≈6, 217≈5, 218≈0, 219≈11. Sorry trajectory: 81→81→80→80→80.

### The specific decomposition of the funded build (so you can judge "residual shrinking")

The dual block decomposes into these named sub-steps (blueprint `sec:tensorobj_dual_infra`):
1. **value module** `ℋom(M,N)(U) = Module(R(U))(M|_U⟶N|_U)` — **BUILT iter-219** (`homModule`,
   `internalHomObjModule`, 11 decls, axiom-clean).
2. **restriction maps** `(M|_U⟶N|_U) → (M|_V⟶N|_V)` for `V⟶U` + **presheaf assembly** into the full
   `PresheafOfModules.internalHom` — NEXT (iter-220 target).
3. `dual M := internalHom M unit`; evaluation `M ⊗ M^∨ → R` (`internalHomEval`).
4. sheaf condition → `Scheme.Modules.dual`; `dual_isLocallyTrivial`.
5. discharge `exists_tensorObj_inverse` via the assembled dual + evaluation.

### Planner's iter-220 PROGRESS proposal

One file in `## Current Objectives`: `Picard/TensorObjSubstrate.lean`, `[prover-mode: mathlib-build]`,
target = sub-step 2 (restriction maps + presheaf assembly of `PresheafOfModules.internalHom`).
Blueprint to be expanded this iter with named restriction-map sub-target before dispatch.

## What I need from you

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) **for the A.1.c.SubT.dual sub-phase
specifically**, judged against its own ~6–12 iter estimate and its named-sub-step decomposition —
NOT against the older `exists_tensorObj_inverse` sorry-stall framing (that sorry is, by design, the
LAST step of the block). Concretely:

1. Is iter-219's output (11 axiom-clean value-module decls + precise next-step handoff) a
   *convergent* brick — i.e. does it visibly retire sub-step 1 and de-risk sub-step 2 — or is it
   another helper-accretion round that leaves the target as far away as before?
2. Is dispatching sub-step 2 (restriction maps + assembly) the correct next move, or do the signals
   indicate the build itself is mis-shaped (e.g. helpers multiplying around a definition whose shape
   is wrong)?
3. If you see a churn/stuck pattern, name the corrective TYPE (blueprint expansion / Mathlib-idiom
   consult / structural refactor / route pivot).

Do not read STRATEGY.md, PROGRESS.md, blueprint chapters, or iter sidecars — judge only from the
signals above.
