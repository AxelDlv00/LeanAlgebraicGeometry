# lean-vs-blueprint-checker directive — iter-041 — QuotScheme

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

- Lean file: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint chapter: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex`

## Context for this check
Seven new non-private declarations landed this iter (file tail, ~lines 2027–2280), closing the QUOT "gap1"
chain: `image_basicOpen_of_affine`, `compositeBasicOpenImmersion_image_basicOpen`, `image_basicOpen_eq_inf`,
`section_localization_hfr_aux`, `section_localization_hfr_basicOpen`,
`isLocalizedModule_basicOpen_descent` (keystone), `isIso_fromTildeΓ_of_isQuasicoherent` (gap1).

## Specific things to check
1. The keystone `isLocalizedModule_basicOpen_descent` is pinned by blueprint block at ~line 4105
   (`lem:section_localization_descent`?) and gap1 `isIso_fromTildeΓ_of_isQuasicoherent` at ~line 4215
   (`lem:qcoh_affine_isIso_fromTildeΓ`). Confirm the Lean statements MATCH the blueprint statements (not just
   the names) — no fake/over-strong/over-weak signatures.
2. **Suspected pin mismatches** (report severity): blueprint block `lem:composite_immersion_flocus_basicOpen`
   (~line 4339) pins `\lean{...compositeBasicOpenImmersion_flocus_image}` which does NOT exist; the built decl
   is `compositeBasicOpenImmersion_image_basicOpen`, but the blueprint block bundles TWO claims
   (σ(f')=algebraMap AND j''ᵁD(f')=D(f)⊓D(s)) while the built decl proves only the image identity. Is a re-pin
   safe, or does the block need a SPLIT? Also blocks pinning `isLocalizedModule_basicOpen` (~2478) and
   `isLocalizedModule_basicOpen_of_isQuasicoherent` (~2718) name decls that don't exist — are these legacy/
   alternative formulations, or should they map to the built decls?
3. Coverage debt: `image_basicOpen_of_affine`, `compositeBasicOpenImmersion_image_basicOpen`,
   `image_basicOpen_eq_inf`, `section_localization_hfr_aux` have NO blueprint block (lean_aux). Confirm.

## Output
Bidirectional report (Lean→blueprint AND blueprint→Lean), must-fix flagged. Read both paths directly.
