# Progress-critic directive — iter-032

Assess convergence per active route. Two routes feed this iter's prover assignment.

## Route A — cover-agnostic Čech bridge → AffineSerreVanishing cover system (02KG infra)

This route re-parameterized the free Čech resolution machinery to a raw finite family (no covering
hypothesis), so that injective Čech-acyclicity discharges `BasisCovSystem.injective_acyclic` over covers
of arbitrary distinguished opens `D(f)`. Signals (last 4 iters):

- iter-029: `AffineSerreVanishing.lean` +3 axiom-clean (PARTIAL — stopped on the ⊤-vs-`D(f)` design fork).
- iter-030: `FreePresheafComplex.lean` +50 axiom-clean (COMPLETE — entire free side re-parameterized to
  `…Fam`, up to `cechFreeComplex_quasiIsoFam`).
- iter-031: `CechBridge.lean` +10 axiom-clean (COMPLETE — both named family targets
  `sectionCechComplexMapOpIsoFam` + `injective_cech_acyclicFam`).
- Prover statuses: PARTIAL → COMPLETE → COMPLETE. Helpers/decls landed: 3, 50, 10. 0 new sorries every iter.
- Recurring blocker phrases: none live — the design fork was RESOLVED by the re-parameterization (iter-030)
  and the bridge side closed (iter-031). The infra is now in place.
- This iter's proposed lane: `AffineSerreVanishing.lean` [mathlib-build] — build the cover-system chain
  (`standard_cover_cofinal`, `toSheaf_preservesEpimorphisms`, `affine_surj_of_vanishing`, `affineCoverSystem`
  via the family form) — first prover round on this file since iter-029.
- Strategy `Iters left` for the 02KG phase: ~4–5. Phase entered: ~iter-028/029.

## Route B — 01I8 `F≅~(ΓF)` global generation (QcohTildeSections.lean)

The instance `[IsQuasicoherent F] → IsIso F.fromTildeΓ` via Route P (global generation). Signals:

- iter-029: `QcohTildeSections.lean` +4 axiom-clean (PARTIAL — conditional `[IsIso F.fromTildeΓ]` form +
  presentation form + 2 accessors).
- iter-030: +3 axiom-clean (PARTIAL — 01I8 steps (2)–(3): `isIso_fromTildeΓ_of_genSections`,
  `qcoh_iso_tilde_sections_of_genSections`, `free_isQuasicoherent`).
- iter-031: +1 axiom-clean (PARTIAL — P0 `exists_finite_basicOpen_subcover`; P1 `qcoh_localized_sections`
  NOT added — prover located the blocker as TWO missing pieces and recommended splitting P1 into P1a +
  P1b + sheaf condition).
- Prover statuses: PARTIAL → PARTIAL → PARTIAL (3 consecutive). Helpers/decls landed: 4, 3, 1 (decreasing).
  0 new sorries every iter; no relabeling of the gap (prover declined off-critical-path shortcuts each time).
- Recurring blocker phrase: "P1 `qcoh_localized_sections` / global generation needs affine-restriction infra
  + `IsLocalizedModule` patching, both absent from Mathlib."
- This iter's planned corrective (NOT another mathlib-build round on the same P1 recipe): STRUCTURAL split —
  blueprint-writer decomposes P1 into P1a (affine-restriction infra) + P1b (pure-algebra patching primitive),
  and the prover lane this iter targets ONLY the independent P1b (`IsLocalizedModule` local-on-span-cover via
  `IsLocalizedModule.mk`), not P1 as a whole.
- Strategy `Iters left` for the 02KG/01I8 phase: ~4–5. Phase entered: ~iter-029.

## This iter's PROGRESS.md `## Current Objectives` proposal

2 files (one prover each):
1. `AffineSerreVanishing.lean` — cover-system chain (mathlib-build).
2. `QcohTildeSections.lean` — P1b pure-algebra patching primitive (mathlib-build).

## Questions for you
- Is Route B CHURNING/STUCK given 3 consecutive PARTIALs with decreasing decl counts, OR is the
  decreasing count explained by the route reaching its genuinely-hard load-bearing leaf (each PARTIAL
  narrowing the gap with a concrete decomposition handoff)?
- Is the planned corrective (structural P1→P1a/P1b split + dispatching only the independent P1b) a
  sufficient response, or does the route need a different action (pivot, blueprint expansion, idiom consult)?
- Is Route A genuinely CONVERGING and safe to dispatch AffineSerreVanishing this iter?
