# Progress-critic directive — iter-041

Assess convergence per active route. Two routes are candidates for this iter's prover dispatch.
Signals are extracted from the last 4 iters (037–040). Do NOT read STRATEGY.md / blueprint / sidecars.

## Route FBC — `Cohomology/FlatBaseChange.lean` (`_legs_conj` / `gstar_transpose`)

STRATEGY: FBC-A1 phase `Iters left = 1`; route entered its current (conjugate-discharge) phase ~iter-035 (≈6 iters elapsed).

Signals (per iter):
- iter-037: no FBC prover (assembly tripwire fired — inline `_legs` assembly closed nothing). sorry 4→4.
- iter-038: no FBC prover (cross-domain analogist consult → verdict KEEP conjugate route). sorry 4→4.
- iter-039: FBC prover [fine-grained]. Landed +2 axiom-clean decls (conj-2b `reindex_conj_pullbackLeg`, conj-2d `reindex_conj_crossLayer`). The one-shot single-`conjugateEquiv`-component reframing did NOT close `_legs_conj`. sorry 4→4. KILL-CRITERION FIRED.
- iter-040: no FBC prover (honored kill-criterion). api-alignment analogist → ALIGN to Fallback B (layer-by-layer conjugate transport via `conjugateEquiv_symm_comp` + whiskering; materially different from the iter-039 one-shot reframing). sorry 4→4.
- Recurring blocker phrase: "`_legs_conj` reframing does not close" / "`gstar_transpose` not closing" — 3+ iters.
- Proposed iter-041 action: FBC prover [fine-grained] on `_legs_conj` via the NEW Fallback-B route (recipe `analogies/fbc-legs-conj-injective-route.md`), declared the FINAL in-loop attempt; kill-criterion = if it closes nothing → user escalation (no further analogist rounds).

## Route QUOT — `Picard/QuotScheme.lean` (gap1 section-transport producer)

STRATEGY: QUOT-defs phase `Iters left = 1–3`; route entered the gap1-assembly phase ~iter-027 (≈14 iters elapsed — flagged OVER_BUDGET last iter).

Signals (per iter):
- iter-037: QUOT prover. +3 axiom-clean gap1 feeder decls (`isLocalizedModule_powers_transport` and combined bridges). sorry 4→4 (4 = protected stubs, unrelated).
- iter-038: QUOT prover. +2 axiom-clean decls (`gammaImageRingEquiv` σ_V; `gammaPullbackImageIso_hom_semilinear`). sorry 4→4.
- iter-039: QUOT prover. +3 axiom-clean decls (`isLocalizedModule_powers_transport`, `_of_basicOpen_cover` instantiable descent, `isIso_fromTildeΓ_of_iso`). sorry 4→4.
- iter-040: QUOT prover [mathlib-build]. +4 axiom-clean decls (`compositeBasicOpenImmersion`, producer (a) `pullback_composite_immersion_isIso_fromTildeΓ` — the critical piece, `compositeBasicOpenImmersion_isOpenImmersion`, range-half of (b) `compositeBasicOpenImmersion_opensRange`). sorry 4→4. TOP producer deferred as a 3-bridge ring-identification build.
- Status note: each iter adds axiom-clean decls toward the keystone; the gap1 keystone (`isIso_fromTildeΓ_of_isQuasicoherent`) is not yet closed (its prerequisites are being built bottom-up).
- Proposed iter-041 action: QUOT prover [mathlib-build] continuing the producer — build TOP `section_localization_hfr_basicOpen` (σ composite via ΓSpecIso+gammaImageRingEquiv; A as R-algebra via .toAlgebra; (c) semilinear-over-composite; (d) scalar tower; (b) f-locus half), then keystone + gap1 (one-liners).

## This iter's proposed `## Current Objectives` (2 files)
1. `Picard/QuotScheme.lean` — QUOT producer continuation [mathlib-build].
2. `Cohomology/FlatBaseChange.lean` — FBC `_legs_conj` FINAL round [fine-grained].

Give a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any CHURNING/STUCK, the corrective TYPE.
