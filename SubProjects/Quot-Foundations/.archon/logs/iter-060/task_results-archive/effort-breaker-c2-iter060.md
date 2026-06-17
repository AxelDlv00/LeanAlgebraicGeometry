# Effort Breaker Report

## Slug
c2-iter060

## Target
`lem:gr_bundleCocycle_mul` (`AlgebraicGeometry.Grassmannian.bundleTransition_cocycle`)

## Status
COMPLETE — target re-expressed as a 3-step chain (L1 matrix / L2 linkage / L3 transport),
plus the supporting matrix-automorphism infrastructure now made explicit in the blueprint.
L3 remains the substantive piece and is flagged for an optional finer re-break.

## Effort before → after
- target `effort_local`: **1814 → 895** (halved; proof body now a 3-line "by L1, L2, L3").
- sub-lemmas / definitions added: **10** (3 proof steps + 7 supporting infra blocks).
  effort cone now made explicit — `effort_total` rose (1814 → 4700) only because steps
  previously hidden inside the monolith are now counted as their own nodes.

## Chain added (target ← L1, L2, L3)

### The three proof steps (the directive's three seams)
- `\label{lem:gr_bundleCocycle_matrix}` `\lean{...bundleTransition_cocycle_matrix}` — **L1, matrix identity.**
  `(X^J_K)⁻¹ (X^I_J)⁻¹ = (X^I_K)⁻¹` over the triple-overlap ring. Pure matrix algebra:
  `X^J_K = (X^I_J)⁻¹ X^I_K` (submatrix-of-product, `lem:gr_mul_submatrix_col`), invert via
  `(AB)⁻¹=B⁻¹A⁻¹`, cancel via the two-sided Cramer identity.
  `\uses{def:gr_universalMinorInv, lem:gr_cocycle_imageMatrix_eq, lem:gr_universalMinorInv_identities,
  lem:gr_mul_submatrix_col, lem:gr_inv_mul_inv_mul_cancel, lem:gr_cocycle}` (effort_local 1402).
- `\label{lem:gr_matrixToFreeIso_mul}` `\lean{...matrixToFreeIso_mul}` — **L2, the linkage** (THE GAP
  iter-059 flagged). Composition of matrix automorphisms realises the matrix product (order
  reversed by component contravariance): `matrixToFreeIso(A)_hom ∘ matrixToFreeIso(B)_hom =
  matrixEnd(B·A)`. One-move proof off `matrixEnd_comp`.
  `\uses{def:gr_matrixToFreeIso, lem:gr_matrixToFreeIso_hom, lem:gr_matrixEnd_comp}` (effort_local 342).
- `\label{lem:gr_bundleCocycle_transport}` `\lean{...bundleTransition_cocycle_transport}` — **L3, the
  transport/bridge bookkeeping** (the substantive difficulty). Carries the three transitions to
  `V_IJK` via `pullbackBaseChangeTransport`, reassociates iterated pullbacks via `pullbackComp`,
  and pins the src/mid/tgt sheaves to a common `O^d_{V_IJK}` via the three `glueData_bridge_*`;
  each transported transition then becomes `matrixEnd` of a base-changed Cramer inverse, and
  L2 + L1 close the composite. Explicit src/mid/tgt domain matching given in the proof.
  `\uses{def:gr_bundleTransition, lem:gr_bundleCocycle_matrix, lem:gr_matrixToFreeIso_mul,
  lem:modules_pullback_basechange_transport, lem:gr_glueData_bridges, def:modules_pullbackComp,
  lem:gr_pullbackFreeIso}` (effort_local 2061).

### Supporting infrastructure made explicit (all already formalized in Lean → effort_local 0)
These were undocumented Lean helpers; I added faithful blueprint blocks so L2's `\uses` resolve
and the matrix-to-sheaf realisation is documented. sync_leanok will mark them `\leanok`.
- `\label{lem:gr_scalarEnd_comp}` `\lean{...scalarEnd_comp}` — scalarEnd composition = multiplication.
- `\label{lem:gr_scalarEnd_add}` `\lean{...scalarEnd_add}` — scalarEnd additivity.
- `\label{def:gr_matrixEnd}` `\lean{...matrixEnd}` — matrix → endomorphism of `O_S^d` via biproduct.
- `\label{lem:gr_matrixEnd_comp}` `\lean{...matrixEnd_comp}` — `matrixEnd M ∘ matrixEnd N = matrixEnd(N·M)`.
- `\label{lem:gr_matrixEnd_one}` `\lean{...matrixEnd_one}` — `matrixEnd 1 = id`.
- `\label{def:gr_matrixToFreeIso}` `\lean{...matrixToFreeIso}` — invertible matrix → free-sheaf automorphism.
- `\label{lem:gr_matrixToFreeIso_hom}` `\lean{...matrixToFreeIso_hom}` — forward map is `matrixEnd M` (rfl).

### Target rewrite
- `lem:gr_bundleCocycle_mul` statement and `\lean{}` unchanged. Proof body replaced by
  "by L1 (matrix), L2 (linkage), L3 (transport)"; proof `\uses{lem:gr_bundleCocycle_matrix,
  lem:gr_matrixToFreeIso_mul, lem:gr_bundleCocycle_transport}`.

## Still hard (re-break candidates)
- `lem:gr_bundleCocycle_transport` (L3) — effort_local 2061; this is the irreducible "endpoint
  bookkeeping" the directive named as substantive, but it CAN be split further if the prover
  stalls: one sub-lemma per bridge identification (src / mid / tgt) collapsing a transported
  `bundleTransition` to `matrixEnd` of the base-changed inverse on `O^d_{V_IJK}`, plus the
  `pullbackFreeIso` cancellation, then a final 3-line assembly. Re-dispatch the breaker at
  "fine" granularity on this node if it does not close in one prover pass.
- `lem:gr_bundleCocycle_matrix` (L1) — effort_local 1402 by the prose heuristic, but the real
  Lean difficulty is low: it rides almost entirely on the already-proven
  `lem:gr_cocycle_imageMatrix_eq` + `lem:gr_inv_mul_inv_mul_cancel`. Likely a single-pass close;
  no re-break expected.

## Could not decompose (strategy items)
- None. Every step the original monolith crossed is covered by some L_i; the matrix-product →
  scalarEnd-composition linkage that iter-059 review flagged as missing is now the explicit,
  already-formalized-infra-backed node `lem:gr_matrixToFreeIso_mul`.

## References consulted
- None retrieved this round. The matrix cocycle source (Nitsure §1, image-matrix formula
  `θ_{I,J}(X^J)=(X^I_J)⁻¹X^I`) is already cited at `def:gr_image_matrix` /
  `lem:gr_cocycle_imageMatrix_eq`; L1 reuses those existing cited results rather than re-deriving
  from source, so no new `% SOURCE` block was required.

## Notes for dispatcher
- `\lean{}` names assigned by convention for the **planned** (still-`sorry`/absent) nodes —
  confirm/scaffold:
  - `AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_matrix` (L1, NEW decl)
  - `AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_transport` (L3, NEW decl)
  - `AlgebraicGeometry.Grassmannian.matrixToFreeIso_mul` (L2, NEW decl)
- The 7 infra `\lean{}` names (`scalarEnd_comp`, `scalarEnd_add`, `matrixEnd`, `matrixEnd_comp`,
  `matrixEnd_one`, `matrixToFreeIso`, `matrixToFreeIso_hom`) already EXIST and are proven in
  `AlgebraicJacobian/Picard/GrassmannianQuot.lean` — they need no scaffolding; sync_leanok will
  mark them `\leanok`. `matrixEnd_comp` is the exact Lean lemma L2 wraps, so L2 is genuinely a
  one-liner once the new decl is scaffolded.
- No new macros required. LaTeX environments balanced (lemma 25/25, definition 14/14, proof 28/28);
  target `effort_local` 1814 → 895; all 10 new nodes resolve into the target's ancestor cone with
  no broken `\uses`.
