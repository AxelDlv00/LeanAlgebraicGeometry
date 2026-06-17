# Iter-032 objectives (detail)

## Lane 1 — `AffineSerreVanishing.lean` [mathlib-build] — 02KG cover-system chain
Build (none exist yet): `toSheaf_preservesEpimorphisms`, `standard_cover_cofinal`,
`affine_surj_of_vanishing`, `affineCoverSystem`. Wire `injective_acyclic` via the family
`injective_cech_acyclicFam` (CechBridge, iter-031). Top theorems (`affine_cech_vanishing_qcoh`,
`affine_serre_vanishing`) GATED on 01I8 `qcoh_iso_tilde_sections` unconditional — stop there.
Blueprint blocks (all formalize-ready, blueprint-reviewer iter032 HARD GATE CLEAR):
`lem:to_sheaf_preserves_epi`, `lem:standard_cover_cofinal`, `lem:affine_surj_of_vanishing`,
`def:affine_cover_system`, `lem:affine_faces_mem`/`lem:cover_datum_bridge` (built iter-029),
`def:basis_cov_system` (CechToCohomology).
Imports: `CechBridge` + `CechToCohomology`.

## Lane 2 — `QcohTildeSections.lean` [mathlib-build] — P1b pure-algebra patching primitive
Build `isLocalizedModule_of_span_cover` (NEW block `lem:isLocalizedModule_of_span_cover`,
HARD GATE CLEAR). Over-`R` form: `g : M →ₗ[R] N`, `f : R`, `s : Fin n → R`, `span(range s)=⊤`;
per-`j` `IsLocalizedModule (powers f) g_{s_j}` ⟹ `IsLocalizedModule (powers f) g`. Via
`IsLocalizedModule.mk` + partition of unity. NOT P1/P1a (P1a = `isQuasicoherent_restrict_basicOpen`
is blueprint-only project-to-build this iter).

## Expectation
- Lane 1: PARTIAL→COMPLETE arc normal for first substantive round (progress-critic: still CONVERGING).
- Lane 2: P1b is the CHURNING-corrective for Route B; a clean P1b confirms the split is viable.

## Blocked / not dispatched
- `affine_serre_vanishing`, `affine_cech_vanishing_qcoh` — gated on 01I8 unconditional qcoh form.
- P1a `isQuasicoherent_restrict_basicOpen`, `tildePreservesFiniteLimits` — blueprint-only (Mathlib gaps).
