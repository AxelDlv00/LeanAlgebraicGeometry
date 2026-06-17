# Progress-critic directive — iter-215

Assess convergence of the SOLE active prover lane. One route only.

## Route TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (A.1.c.SubT, ⊗-group law)

Strategy estimate for this phase (verbatim from the STRATEGY.md phase row):
- Iters left: ~3–6
- Entered current phase (route (e)): iter-214 (the route-(e) pivot). Prior to that, routes
  (c)/(d)/flat-exactness on the same substrate since iter-209.

### Last 5 iters — extracted signals

| iter | global sorry | TS-file code sorries | helpers/decls added | prover status | recurring blocker phrase |
|---|---|---|---|---|---|
| 210 | 81 | 4 | restructure pair (no new closes) | PARTIAL | "associator gate" |
| 211 | 81 | 4 | +1 (`W_whiskerLeft_of_flat`); IsInvertible+unitors+braiding closed | PARTIAL | "flat-whiskering bridge" |
| 212 | 81 | 4 | +2 (`isIso_sheafification_map_of_W`, `W_whiskerRight_of_flat`) | PARTIAL | "sectionwise flatness false for invertibles" |
| 213 | 81 | 4 | +2 (`W_whiskerLeft/Right_of_W`); associator `tensorObj_assoc_iso` ASSEMBLED (compiles, rests on 1 residual) | PARTIAL | "stalk port d.1/d.2" |
| 214 | 81 | 4 | +4 (`stalkLinearMap`, `_germ`, `_bijective_of_isIso`, `stalkLinearEquivOfIsIso` — the d.1-linearity core, all axiom-clean) | PARTIAL | "d.1-bridge + d.2 stalk-⊗ commutation" |

### Critical-path residual (current)

The lane's lone open critical-path sorry is `isLocallyInjective_whiskerLeft_of_W` (the load-bearing
field of the sole new obligation `(J.W).IsMonoidal`; route (e) gets associator/unitors/braiding free
from Mathlib's `LocalizedMonoidal` once this instance lands). To close it, two ingredients remain:
- **d.1-bridge** (~80–150 LOC): site-`W` ⟺ stalkwise-iso characterisation on `Opens X`. Concrete
  assembly route exists (`WEqualsLocallyBijective` + topological stalk criteria
  `app_injective_iff_stalkFunctor_map_injective` / `locally_surjective_iff_surjective_on_stalks`).
- **d.2** (~150–250 LOC): stalk commutes with the relative module-presheaf tensor over a VARYING
  ring — `(F⊗ᵖM)_x ≅ F_x ⊗_{R_x} M_x`. Prover reports this as genuinely Mathlib-absent (the largest,
  least-certain piece). NOT yet attempted.

### iter-214-specific facts (new this window)

- d.1-CORE landed axiom-clean (4 decls) — first concrete bricks of the residual, not another bridge.
- A PROGRESS.md/recipe factual error was corrected: Mathlib `ModuleCat/Stalk.lean` already supplies
  the stalk MODULE structure, so d.1 shrank from "build the stalk module" to "linearity packaging
  (done) + d.1-bridge". This is a genuine de-risk.
- Prior progress-critic (ts214) returned STUCK + a one-iter gate: "if d.1+d.2 both compile
  axiom-clean THIS iter, proceed; else escalate — no further infra iter." That gate was NOT met
  (only d.1-core landed; d.2 untouched).

### Planner's proposed iter-215 objective

ONE file: `Picard/TensorObjSubstrate.lean`, `[prover-mode: mathlib-build]`, scoped to d.1-bridge
(tractable, known route) + a feasibility-attempt on d.2, assembling with the 4 d.1-core bricks.
(Plan also: blueprint-writer to fix the stale TS chapter sketch before dispatch.)

### Question for you

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) given the new d.1-core landing and the
concretely-scoped residual. If STUCK/CHURNING, name the corrective TYPE. Specifically weigh: is the
"5th net-zero global counter" a genuine stall, or legitimate sub-sorry mathlib-build progress under
the Mathlib-gradient strategy? And is dispatching one more focused mathlib-build iter (d.1-bridge +
d.2 feasibility) the right move, or has the lane earned a USER escalation per its pre-committed
reversal (reversal trigger = "no route exists"; a concrete route currently exists)?
