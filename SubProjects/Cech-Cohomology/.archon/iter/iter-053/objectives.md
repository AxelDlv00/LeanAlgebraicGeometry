# Iter-053 objectives

Two deep `mathlib-build` lanes on freshly-scaffolded downstream files (both gate-cleared, both compile
as stubs).

## Lane 1 — `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`
- Target: `cechAugmented_exact` (1 stub sorry). Blueprint `lem:cech_augmented_resolution`.
- Route: prepend-`i_fix` homotopy (local vanishing on `{V ⊆ some Uᵢ}`) + `homologyIsoSheafify` +
  `sheafify_kills_locally_zero` + faithful-`toSheaf` IsZero-reflection (3-line helper) across the
  `sheafificationCompToSheaf` square. Recipe: blueprint Steps 1–4 + `analogies/tosheaf-reflect.md`.
- Key build: F-valued objectwise prepend homotopy (template `CombinatorialCech.combHomotopy`).

## Lane 2 — `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Targets: `higherDirectImage_openImmersion_acyclic` (part 1), `higherDirectImage_openImmersion_comp`
  (part 2). 2 stub sorries. Blueprint `lem:open_immersion_pushforward_comp`.
- Route: presheaf description (01XJ) + `affine_serre_vanishing` (done) for part 1; injective-resolution
  + P4 acyclic-resolution comparison + `f_*∘j_* = (f∘j)_*` for part 2.

## Gate / verification this iter
- blueprint-reviewer `iter053` + `iter053-recheck`: HARD GATE CLEARS both files, 0 must-fix.
- `lake build` GREEN (8331 jobs); only the 3 expected stub-sorry warnings.
- strategy-critic SOUND (CHALLENGE addressed); progress-critic CONVERGING; analogist PROCEED.
