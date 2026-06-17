# Iter-031 objectives

Two parallel mathlib-build lanes (independent files; both 0-sorry → scaffold keyword on path line).

## Lane A — `CechBridge.lean` [prover-mode: mathlib-build]
Build family-parameterized `sectionCechComplexMapOpIsoFam` + `injective_cech_acyclicFam` over
`{ι}[Finite ι](U : ι → Opens X)`, NO covering hypothesis, mirroring the existing axiom-clean X.OpenCover
proofs and consuming Lane-A's `cechFreeComplex_quasiIsoFam` (+ supporting `…Fam` chain). Keep existing
X.OpenCover decls byte-identical (ADD alongside). Blueprint blocks `lem:section_cech_complex_mapop_iso`
(~2600), `lem:injective_cech_acyclic` (~2663) — both pin the `…Fam` names, FORMALIZE-READY.
Route A = CONVERGING (progress-critic). Bounded mirror of an existing proof.

## Lane B — `QcohTildeSections.lean` [prover-mode: mathlib-build]
Build Route-P lane 1: P0 `exists_finite_basicOpen_subcover` (pure topology, axiom-clean-able — do FIRST)
+ P1 `qcoh_localized_sections` (`Γ(X,F)→Γ(D(f),F)` is `IsLocalizedModule (.powers f)`, the load-bearing
GAP). Blueprint `lem:exists_finite_basicOpen_subcover` (~3827, self-contained), `lem:qcoh_localized_sections`
(~3867). Recipe `analogies/o1i8-qcoh-tilde-route.md`. P1 thin step (IsLocalizedModule from gluing data, no
named Lean API) flagged — partial P1 acceptable provided P0 green + local-triv scaffold compiles.

## Targets FORMALIZE-READY per blueprint-reviewer iter031 HARD GATE CLEARS.
## Watch (progress-critic iter031): Route B 3rd consecutive PARTIAL on P1 = iter-032 CHURNING →
## corrective is fine-grained/effort-breaker split of P1 (mathlib-analogy consult already done), NOT a
## repeat mathlib-build round.
