# Iter 046 — Objectives detail

## Lane 1 — QUOT annihilator characterization (QuotScheme.lean) [mathlib-build]

- **Build** `AlgebraicGeometry.Scheme.Modules.annihilator_ideal` (decl does not yet exist).
- **Signature target:** `F : X.Modules` `[F.IsQuasicoherent]`, `U : X.affineOpens`,
  finite-generation `[Module.Finite Γ(X, U.1) Γ(F, U.1)]` ⟹
  `(annihilator F).ideal U = Module.annihilator Γ(X, U.1) Γ(F, U.1)`.
- **Deps (all DONE):** `annihilator_ideal_le` (forward `≤`), gap2 `isLocalizedModule_basicOpen`,
  engine `annihilator_isLocalizedModule_eq_map` (@362, needs `[Module.Finite]`),
  `IsAffineOpen.isLocalization_basicOpen`.
- **Blueprint:** `lem:modules_annihilator_ideal` (L2414, updated to the conditional/f.g. form this iter).
- **Discipline:** term-mode only under the `X.Modules` diamond; no positional rw/simp/erw.
- **WATCH:** assembling the `ofIdeals` section over general affine `U` from basic-open data — if it needs
  an ideal-sheaf coherence beyond gap2+engine, flag the precise ingredient (no typed sorry).

## Blueprint prepared (no prover this iter)

- **GF base case** (`Picard_FlatteningStratification.tex`): 3 seams +2 coverage-debt blocks; route =
  affine-qcoh exactness of Γ via gap1/gap2 (Stacks 01PB), NOT stalkwise. Effort 1273→894.
- **SNAP** (`Picard_SectionGradedRing.tex`, NEW): layers = sheaf tensor powers → lax-monoidal Γ →
  DirectSum graded assembly; 5 `\mathlibok` anchors (PresheafOfModules monoidal+sheafification,
  SheafOfModules.unit, DirectSum.GCommSemiring/Gmodule); Stacks 01CA/01CU/01CV cited.

## Not dispatched / rationale
- FBC keystone — PARKED (kill-criterion; off critical path).
- 2nd/3rd prover lanes — GF/SNAP chapters (re)written this iter, no fresh blueprint-reviewer clear (HARD GATE).
