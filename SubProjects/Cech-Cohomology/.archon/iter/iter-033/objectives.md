# Iter-033 objectives

Two parallel mathlib-build lanes (one prover per file).

## Lane 1 — `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` [mathlib-build]
02KG cover-system chain. Build order:
1. `toSheaf_preservesFiniteColimits` — `PreservesFiniteColimits (SheafOfModules.toSheaf R)` via the
   sheafification square `sheafificationCompToSheaf` + left-adjoint reflector `L` (NOT `forget`). Recipe:
   `analogies/tosheaf-epi.md`; blueprint `lem:toSheaf_preservesFiniteColimits`.
2. `toSheaf_preservesEpimorphisms` — corollary via `preservesEpimorphisms_of_preservesColimitsOfShape`.
3. `affine_surj_of_vanishing` — `Epi g ⟹ IsLocallySurjective (toSheaf g)` term-mode + `standard_cover_cofinal`
   + `ses_cech_h1`.
4. `affineCoverSystem` — bundle `BasisCovSystem`; `injective_acyclic` ← `injective_cech_acyclicFam`.
Top theorems gated on 01I8 — STOP at the bundle.

## Lane 2 — `AlgebraicJacobian/Cohomology/TildeExactness.lean` (NEW) [mathlib-build]
`tildePreservesFiniteLimits` — tilde functor preserves kernels / finite limits, via stalkwise flatness
(`Tilde.stalkIso` → `M_𝔭` exact → `isIso_of_stalkFunctor_map_iso`). Blueprint `lem:tilde_preserves_kernels`.
01I8 Route-P step P3.

## Gate status
Both Gate 1 (toSheaf) and Gate 2 (tilde) CLEARED by blueprint-reviewer `iter033` (+ fast-path
`tosheaf-rereview`). Coverage debt cleared (unmatched 8→1).

## Deferred to iter-034
- P1a effort-breaker on `lem:isQuasicoherent_restrict_basicOpen` (geometry infra absent from Mathlib), then
  its build lane → P1 `qcoh_localized_sections`.
