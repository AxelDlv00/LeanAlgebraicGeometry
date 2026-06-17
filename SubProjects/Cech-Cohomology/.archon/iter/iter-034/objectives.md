# Iter-034 objectives (detail)

## Lane 1 — `AffineSerreVanishing.lean` (mathlib-build, RE-DISPATCH)
Cover-system build (02KG). Did NOT run iter-033 (dispatch shortfall); recipe `analogies/tosheaf-epi.md`.
Build order: `toSheaf_preservesFiniteColimits` (sheafification-square `PreservesFiniteColimits`, NOT via
`forget`) → `toSheaf_preservesEpimorphisms` → `affine_surj_of_vanishing` (term-mode
`(Sheaf.isLocallySurjective_iff_epi' _).mpr inferInstance`) → `affineCoverSystem` (`BasisCovSystem (Spec R)`;
`injective_acyclic` ← `injective_cech_acyclicFam`). STOP before `affine_serre_vanishing` (gated on 01I8).
Blueprint blocks: `lem:toSheaf_preservesFiniteColimits`, `lem:to_sheaf_preserves_epi`,
`lem:affine_surj_of_vanishing`, `def:affine_cover_system`.

## Lane 2 — `TildeExactness.lean` (mathlib-build, CONTINUATION)
ONE remaining build: Ab-stalk germ-naturality transport ⟹ `(tilde.functor R).PreservesMonomorphisms`, then
assemble `tildePreservesFiniteLimits` via `tilde_preservesFiniteLimits_of_preservesKernels` (already built).
Use `Scheme.Modules.toPresheaf` (Faithful/ReflectsIso/PreservesLimits) + `tilde.toStalk` +
`IsLocalizedModule (tilde.toStalk · x).hom` + `app_injective_of_stalkFunctor_map_injective` +
`tilde_toStalk_map_injective`. Preferred: per-kernel comparison `tilde(ker f) → ker(tilde f)` stalkwise iso
(folds mono + kernel into one transport). AVOID the ModuleCat-stalk route (private handles). Also fix the
file's misleading obstruction-2 docstring. Blueprint block: `lem:tilde_preserves_kernels`.

## Plan-phase subagent results (this iter)
- progress-critic `iter034`: CONVERGING ×2, dispatch OK. Watch a 2nd tilde PARTIAL on same blocker.
- blueprint-reviewer `iter034`: HARD GATE CLEARS both lanes; DAG clean; 2 soon findings off-lane (pin-less
  transport-exposition blocks, intentional).
- refactor `tilde-import`: root barrel imports TildeExactness; `lake build` EXIT 0.
- effort-breaker `p1a` + blueprint-clean `p1a`: P1a decomposed into a 3-lemma chain (next-iter lane).

## NOT dispatched this iter (deferred)
- P1a prover lane (`modules_restrict_basicOpen` → `tilde_restrict_basicOpen` →
  `presentation_restrict_basicOpen` → top) — decomposed this iter, dispatchable NEXT iter.
