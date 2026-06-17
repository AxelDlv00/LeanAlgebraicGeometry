# Iter-027 objectives

## Lane 1 — `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean` [mathlib-build]
Add ONE new axiom-clean decl `absoluteCohomologyZeroAddEquiv_naturality` — naturality of H⁰≅Γ in the
coefficient sheaf. Blueprint `lem:absolute_cohomology_zero_natural` (line 3050), FORMALIZE-READY. Unblocks
01EO L3's surjectivity transfer. ~20–40 LOC. Recipe: post-comp by `mk₀ g` under `Ext.homEquiv₀` ↔ post-comp
by `g` under `jShriekOU_homEquiv` (natural in 2nd var) ↔ `g_U` on sections.

## Lane 2 — `AlgebraicJacobian/Cohomology/CechToCohomology.lean` (NEW) [mathlib-build]
Scaffold the new file (import CechBridge + AbsoluteCohomology; add to build root) and build the 01EO chain
as far as possible. Expected: **L1 `cechComplex_shortExact_of_basis` + L2 `quotient_cech_vanishing_of_basis`
land** (neither needs naturality); L3/L4/top hand off (gated on Lane-1 naturality, cross-lane invisible this
iter → iter-028). Exact signatures: `.archon/task_results/effort-breaker-split-01eo.md`. Blueprint blocks
`lem:cech_ses_of_basis` (3194), `lem:quotient_vanishing_cech` (3257), `lem:absolute_cohomology_one_vanishing`
(3296), `lem:absolute_cohomology_pos_vanishing` (3351), `lem:cech_to_cohomology_on_basis` (3407). General
basis criterion; inductive predicate abstract (not QCoh).

## Expected outcome
- Lane 1: naturality decl landed axiom-clean.
- Lane 2: file created, L1+L2 axiom-clean, clean handoff at L3 with the `cechCohomology`-accessor decision noted.
- Project sorry stays 2 (frozen/superseded). `unmatched` stays 0 (planner bundles any new helpers next iter).
