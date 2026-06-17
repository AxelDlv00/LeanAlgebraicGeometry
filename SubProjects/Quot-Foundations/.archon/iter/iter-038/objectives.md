# Iter 038 — Objectives (Quot-Foundations)

2 prover lanes (import-independent) + FBC analogist-resolved KEEP (no prover). Detail in PROGRESS.md
`## Current Objectives`.

| # | File | Mode | Target | Gate |
|---|------|------|--------|------|
| 1 | `Picard/QuotScheme.lean` | mathlib-build | `gammaImageRingEquiv` (σ_V) + `gammaPullbackImageIso_hom_semilinear`; then chain → `Hfr` → `isLocalizedModule_basicOpen_descent` + gap1 | blueprint-reviewer CONDITIONAL → pin added → CLEARED |
| 2 | `Picard/GrassmannianCells.lean` | mathlib-build (scaffold) | `existence_lift` (E4 valuative-criterion filler) | blueprint-reviewer CLEARS |

FBC (`Cohomology/FlatBaseChange.lean`): **no prover** — route KEEP (analogist `fbc-route-pivot`); the
`_legs_conj` conjugate-side prover round (conj-2b + conj-2d + reframing) is scheduled for iter-039.

## Tripwires
- **QUOT:** land (1) σ_V + (2) semilinearity axiom-clean at minimum; the (3) Hfr chain may hand off a
  decomposition if too large. If (2) cannot be proven term-mode (diamond resists), the next QUOT round
  consults the analogist on the `mapPresheaf` module-hom `map_smul` — NOT a keyed-`rw` retry.
- **GR:** E4 is frontier-ready with a full sketch; expect closure. If the `CommSq.LiftStruct` assembly blocks,
  land the two triangles as standalone lemmas.
