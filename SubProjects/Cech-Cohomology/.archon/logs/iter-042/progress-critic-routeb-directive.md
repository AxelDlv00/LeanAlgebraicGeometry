# Progress-critic directive — Route B keystone convergence (last K=4 iters)

Assess convergence of the single active route below. Use ONLY the signals provided. Do not read
PROGRESS.md / STRATEGY.md / blueprint chapters.

## Route: Route B keystone (01I8 `F ≅ ~(ΓF)` via section-localisation, sheaf-axiom equalizer)

Files: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` (active),
`AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` (B-chain leaves, now done).
Mode: `mathlib-build` — the route builds NEW axiom-clean declarations bottom-up (it does not fill a
pre-existing project sorry). Convergence = named-target advance + decreasing residual to the keystone,
NOT a falling inline-sorry count (the route's inline-sorry count is constant at 2, both unrelated
frozen/superseded decls).

### Strategy estimate for this phase
- STRATEGY `01I8 ... (Route B)` row: **Iters left ~2–3**, LOC ~120–250.
- The route entered its current (keystone) sub-phase at **iter-041** (after the B-chain leaves B0–B4
  completed iter-040). So this is the **2nd** iter of the keystone sub-phase.

### Last 4 iters — signals

| iter | file(s) touched | axiom-clean decls added | prover status | recurring blocker phrase |
|---|---|---|---|---|
| 038 | QcohRestrictBasicOpen | +8 (B3 engine `modulesOverBasicOpenEquivalence` + 7 B3a helpers) | COMPLETE | — |
| 039 | (none) | 0 | NOOP-DROP (objective silently dropped by a dispatch-keyword trap; 0 provers ran) | dispatch-phrasing bug, not math |
| 040 | QcohRestrictBasicOpen | +4 (B3 object iso `overBasicOpenIsoRestrict` + B4 `presentationModulesRestrictBasicOpen` + 2 helpers) | COMPLETE | — |
| 041 | QcohTildeSections | +3 (`qcoh_section_equalizer` [substantial sheaf-axiom equalizer theorem] + `isLocalizedModule_powers_restrictScalars_of_algebraMap` [base-ring descent helper] + 1 private) | PARTIAL (1 of 2 planned leaves landed; 2nd leaf `tile_section_localization` NOT landed but advanced — see below) | "modulesSpecToSheaf ∘ restrict section comparison is not rfl" (NEW this iter) |

### Detail on the iter-041 PARTIAL (the signal to judge)
- Planned 2 leaves: `qcoh_section_equalizer` (landed) and `tile_section_localization` (NOT landed).
- `tile_section_localization` did not land, but the prover (a) built one of its two required ingredients
  (the base-ring descent helper, axiom-clean), (b) discovered the planned recipe ("section comparison is
  `restrict_obj`-rfl") was UNSOUND and proved it concretely (a defeq failure via `run_code`), (c) handed
  back a precise 2-sub-lemma decomposition (Sub-lemma A: opens identities; Sub-lemma B: a ~100–150 LOC
  natural section-comparison iso). It stopped honestly rather than papering with a sorry.
- The blocker phrase "circular keystone" from the PRIOR sub-phase (iter-041 entry) was RESOLVED at iter-041
  start (the route was re-shaped from span-cover descent to the sheaf-axiom equalizer); it is NOT recurring.
  The new blocker ("section comparison not rfl") is a freshly-surfaced, precisely-decomposed gap, first seen
  this iter.

### This iter's (042) proposed objective
- 1 file: `QcohTildeSections.lean`. ONE `mathlib-build` lane to build `tile_section_localization` via its
  decomposition: Sub-lemma A (opens identities) + Sub-lemma B (the section-comparison iso) + the
  already-built base-ring descent helper. The blueprint sketch for `tile_section_localization` is being
  rewritten THIS iter (it previously carried the unsound rfl recipe) before dispatch.

## Question
Is this route CONVERGING, CHURNING, STUCK, or UNCLEAR? In particular: is re-dispatching
`tile_section_localization` (now with a corrected, honestly-decomposed blueprint sketch and one of its two
ingredients already built) a genuine next step, or a repeated-blocker churn pattern? Name the corrective
type if not CONVERGING.
