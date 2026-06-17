# Progress-critic directive — iter-039

Assess convergence of the single active route below. K = 4 iters of signals.

## Active route: 01I8 Route B (affine `F ≅ ~(ΓF)` via section-localization)

**Files under active prover work:** `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`
(the load-bearing B3 bridge file). `QcohTildeSections.lean` is import-blocked this iter (cannot
import B3/B4 decls that do not yet exist) — not a candidate lane.

**Strategy estimate:** STRATEGY row "01I8 `F≅~(ΓF)` via section-localization (Route B)" — Iters
left = ~2–3. The route ENTERED its current phase (Route B, after pivoting away from Route P) at
**iter-036**. So elapsed in-phase = 3 iters (036, 037, 038); now planning iter-039.

### Signals, last 4 iters (per the B1–B6 chain decomposition)

| iter | file(s) touched | helpers/decls added (axiom-clean) | named-target status | blocker phrase |
|---|---|---|---|---|
| 036 | QcohTildeSections | +3 (local-model bricks: tilde_section_isLocalizedModule, section_isLocalizedModule_of_isIso_fromTildeΓ, section_isLocalizedModule_of_presentation) | keystone `qcoh_section_isLocalizedModule` ABSENT | "blocked on `.over`→affine base-change bridge" |
| 037 | QcohTildeSections (+2), QcohRestrictBasicOpen (+5) | +7 — **B1** `qcoh_finite_presentation_cover` CLOSED + **B2** `presentationOverBasicOpen` CLOSED + 4 `Opens.overEquivalence_*` continuity decls | B1 + B2 named targets CLOSED (first named closures of the route) | B3 `overBasicOpenIsoRestrict` ABSENT — "site-equiv half done; residual = structure-sheaf compat φ/ψ" |
| 038 | QcohRestrictBasicOpen (+8) | +8 — **B3 engine** `modulesOverBasicOpenEquivalence` CLOSED (the analogist-designated single load-bearing lane; H₁/H₂ coherence discharged kernel-soundly) + 7 B3a helpers | B3 ENGINE closed; named B3 target `overBasicOpenIsoRestrict` (object iso) ABSENT — precise in-file TODO, "(pushforwardCongr ?_).app M typechecks against the target; remaining = data equality h with site functor F pinned; bounded mechanical, no math wall" | "no mathematical wall remains on Route B" |
| 039 (proposed) | QcohRestrictBasicOpen | target: **B3 object iso** `overBasicOpenIsoRestrict` (assemble from the iter-038 engine via pushforwardCongr+ι_appIso) **+ B4** `presentationModulesRestrictBasicOpen` (mechanical after B3) | — | — |

Project inline-sorry count = 2 throughout (both frozen/superseded — NOT the route's signal). The
route's signal is named-target closures + whether the residual is shrinking.

### The specific question

The named B3 target `overBasicOpenIsoRestrict` was "this iter's target" in iter-038 and is being
re-dispatched in iter-039. That is ONE slip of a named target. Meanwhile iter-038 DID close the B3
engine (`modulesOverBasicOpenEquivalence`), which the prior analogist designated as the *single
load-bearing lane* of B3 — i.e. the hard half. The remaining `overBasicOpenIsoRestrict` is reported
as a bounded mechanical assembly (typechecking skeleton in hand) with B4 mechanical after it.

Is this route **CONVERGING** (B1→B2→B3-engine is steady named-target progress down a finite chain,
residual genuinely shrinking) or **CHURNING** (helpers accumulating — +3,+7,+8 — while the named B3
target slips, design-shape suspected)? Distinguish "delivered the hard sub-brick, named wrapper is
mechanical and next" from "perpetually one-helper-away." Name the corrective TYPE if not CONVERGING.

## Current objectives proposal for iter-039

ONE prover lane: `QcohRestrictBasicOpen.lean` [prover-mode: mathlib-build] — build B3 object iso
`overBasicOpenIsoRestrict` (from the closed engine) then B4 `presentationModulesRestrictBasicOpen`.
No second lane (QcohTildeSections is genuinely import-blocked on B3/B4).
