# Iter 047 — Objectives detail

## Lane 1 — GF G1 base case (`FlatteningStratification.lean`, mathlib-build)
Build 4 axiom-clean decls bottom-up:
- seam 1 `gf_finiteType_affine_finite_cover_generated` — finite-type qcoh on affine ⟹ finite
  basic-open cover of globally-generated affines (Stacks 01PB; quasi-compactness). Mathlib-only.
- seam 2 `gf_affine_qcoh_Gamma_epi` — Γ sends qcoh epi to surjection. Recipe
  `analogies/gf-gamma-exact.md`: counit `fromTildeΓNatTrans` naturality + `[IsIso _.fromTildeΓ]`
  ⟹ `tilde.functor.map (Γπ)` epi; `tilde.functor` faithful ⟹ `epi_of_epi_map` ⟹ surjective.
  Take `[IsIso _.fromTildeΓ]` as hyps. (Mathlib Tilde.lean adjunction — analogist-verified.)
- seam 3 `gf_qcoh_finite_sections_globally_generated` — seam2 + `module_finite_of_surjective`.
- assembly `gf_qcoh_fintype_finite_sections` — seam1 → seam3 → DONE locality half.
DONE inputs: locality half (iter-045), gap2, G1-core `isIso_fromTildeΓ_of_isLocalizedModule_restrict`.
WATCH: seam-1 cover refinement; keep compHom/tower LOCAL. Out of scope: G3, genericFlatness.

## Lane 2 — SNAP layer 1 (`SectionGradedRing.lean` NEW, mathlib-build)
Create file + add root import (acyclic new leaf). Build Layer 1 axiom-clean:
- `sheafTensorObj` (objectwise `PresheafOfModules.monoidalCategory` + `sheafification` + `unit`),
  `sheafTensorPow`, `sheafModuleTwist`, `sheafTensorPow_add`.
Reuse Mathlib's monoidal scaffold (PRESENT — do not re-derive). Stop + hand off decomposition if
wiring `PresheafOfModules.Monoidal` → `SheafOfModules`-over-scheme blocks. Layers 2–3 next iter.

## Blueprint state
- HARD GATES PASSED (blueprint-reviewer iter047): FlatteningStratification, SectionGradedRing,
  QuotScheme-annihilator.
- Seam-2 proof refined this iter (writer gf-seam2 + clean iter047) to the Mathlib counit mechanism;
  `\mathlibok` anchor `lem:tilde_adjunction_mathlib` added.
- QuotScheme annihilator: `lem:modules_annihilator_ideal` global-finiteness + `lem:annihilator_map_basicOpen`
  block — reconciled (resolves iter-046 lean-vs-blueprint must-fixes + coverage debt).
